function login(){
	var email = $('#email').val();
	var password = $('#password').val();
	// console.log(email, password);
	var user_info = {"email":email, "password":password};
	console.log(user_info);

	$.ajax({
		url: "/admin",
		type: "POST",
		contentType:"application/json",
		dataType: "json",
		data: JSON.stringify(user_info),
		success: function(results){
			if(results.session == 'start'){
				$("#results").html('success!');
			}				
		},
		error: function(error){
			$("#results").html('Invalid username/password!');
		},
	});
}