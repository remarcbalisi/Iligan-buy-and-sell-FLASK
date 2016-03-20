function login(){
	var email = $('#email').val();
	var password = $('#password').val();
	var user_info = {"email":email, "password":password};

	$.ajax({
		url: "/login",
		type: "POST",
		contentType:"application/json",
		data: JSON.stringify(user_info),
		dataType: "json",
		success: function(results){
			if(results.session == 'start' && results.usertype == '1'){
				$.ajax({
					url:"/admin",
					type:"GET",
				});
			}				
		},
		error: function(error){
			$("#results").html('Invalid username/password!');
		},
	});
}