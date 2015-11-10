var GetURL = function() {};

GetURL.prototype = {
    
run: function(arguments) {
    //arguments.completionFunction({ "currentUrl" : document.URL });
    
    arguments.completionFunction({"URL": document.URL, "pageSource": document.documentElement.outerHTML, "title": document.title, "selection": window.getSelection().toString()});
    
}
    
};

var ExtensionPreprocessingJS = new GetURL;