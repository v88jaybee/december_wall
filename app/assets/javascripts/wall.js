$(document).ready(function(){
    $("body")
        .on("submit", "#message_form", function(e){
            e.preventDefault();
            submit_wall_form($(this));
        })
        .on("submit", ".delete_message_form", function(e){
            e.preventDefault();
            submit_wall_form($(this));
        })
        .on("submit", ".comment_form", function(e){
            e.preventDefault();
            submit_wall_form($(this));
        })
        .on("submit", ".delete_comment_form", function(e){
            e.preventDefault();
            submit_wall_form($(this));
        })
});

function submit_wall_form(form){
    $.post(form.attr("action"), form.serialize(), function(result_message){
        if(result_message.status){
            location.reload();
        }
        else{
            alert(result_message.message)
        }
    }, "json");

    return false;
}