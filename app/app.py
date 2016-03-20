from flask import Flask, jsonify, render_template, request, session, redirect
from flask.ext.httpauth import HTTPBasicAuth
from functools import wraps
import json, flask
from model import DBconn
import flask
import sys

app = Flask(__name__)
auth = HTTPBasicAuth()

def spcall(qry, param, commit=False):
    try:
        dbo = DBconn()
        cursor = dbo.getcursor()
        cursor.callproc(qry, param)
        res = cursor.fetchall()
        if commit:
            dbo.dbcommit()
        return res
    except:
        res = [("Error: " + str(sys.exc_info()[0]) + " " + str(sys.exc_info()[1]),)]
    return res


#############################################AUTHENTICATION#########################################
def check_auth(email, password):
    #this function will check the username and password is valid.

    user = spcall('checkauth',(email, password) )
    print user

    if 'Invalid Username or Password' in str(user[0][0]):
        return False

    elif 'Ok' in str(user[0][0]):    
        session['logged_in'] = True
        return True

    return False

@app.route('/login', methods='POST')
def login():
    # I use try method because everytime i get tha json dta from the client
    # side it always return a null but it prints the data in the terminal. Need to fix this
    try:
        if request.method == 'POST':
            json_data = request.get_json(force=False)
            print "GET JSON IS " + str(json_data['email'])
            if check_auth(str(json_data['email']), str(json_data['password'])) is True:
                return jsonify({"session":"start"})
            else:
                return jsonify({"session":"destroy"})
    except:
        return redirect('/admin')
        
    return render_template('admin/login.html')

@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    return jsonify({'session':'destroy'})

#create a wrapper: this wrapper is for athenticating users
def ibs_login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if session.get('logged_in'):
            if session['logged_in']:
                pass

        else:
            return login()
        return f(*args, **kwargs)

    return decorated

####################################################################################################

@app.route('/admin/<string:', methods=['POST', 'GET'])
def admin():
    return render_template('admin/index.html')


@app.after_request
def add_cors(resp):
    resp.headers['Access-Control-Allow-Origin'] = flask.request.headers.get('Origin', '*')
    resp.headers['Access-Control-Allow-Credentials'] = True
    resp.headers['Access-Control-Allow-Methods'] = 'POST, OPTIONS, GET, PUT, DELETE'
    resp.headers['Access-Control-Allow-Headers'] = flask.request.headers.get('Access-Control-Request-Headers',
                                                                             'Authorization')
    # set low for debugging

    if app.debug:
        resp.headers["Access-Control-Max-Age"] = '1'
    return resp




if __name__ == '__main__':
    app.secret_key = 'super secret key'
    app.config['SESSION_TYPE'] = 'filesystem'
    app.run(debug=True, port=8000)