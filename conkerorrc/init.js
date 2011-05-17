require("new-tabs.js");
require('page-modes/gmail.js');

url_remoting_fn = load_url_in_new_buffer;
url_completion_use_history = true;

require("global-overlay-keymap.js");
define_key_alias("C-m", "return");

set_user_agent("Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.3) Gecko/20100401 Firefox/4.0 (.NET CLR 3.5.30729)");

// load download buffers in the background in the current
// window, instead of in new windows.
download_buffer_automatic_open_target = OPEN_NEW_BUFFER_BACKGROUND;

// default directory for downloads and shell commands.
cwd = get_home_directory();
cwd.append("Downloads");

// editor_shell_command
editor_shell_command = "emacsclient -c";

// view source in your editor.
view_source_use_external_editor = true;

define_opensearch_webjump("ja-google", make_file("~/.conkerorrc/search-engines/ja-google.xml"));

interactive("copy-title-and-url",
           "copy current page title and url to clipboard.",
            function (I) {
                let spec = load_spec(I.buffer.top_frame);
                let text = I.buffer.top_frame.getSelection();
                if (text == "") {
                    text = load_spec_title(spec);
                }
                writeToClipboard(text + " " + load_spec_uri_string(spec));
            });

interactive("copy-title-and-url-moin",
           "copy current page title and url to clipboard.",
            function (I) {
                let spec = load_spec(I.buffer.top_frame);
                let text = I.buffer.top_frame.getSelection();
                if (text == "") {
                    text = load_spec_title(spec);
                }
                writeToClipboard(" * [[" + load_spec_uri_string(spec) + "|" + text + "]]");
            });

interactive("twitter-post",
           "copy current page title and url to clipboard.",
            function (I) {
                let spec = load_spec(I.buffer.top_frame);
                let text = I.buffer.top_frame.getSelection();
                if (text == "") {
                    text = load_spec_title(spec);
                }
                const twittercom = "http://twitter.com/intent/tweet";
                load_url_in_new_buffer(twittercom + "?status=" + text + " " + load_spec_uri_string(spec));
            });

