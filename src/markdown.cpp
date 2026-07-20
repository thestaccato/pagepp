#include "markdown.h"
#include <cmark.h>

std::string markdown_to_html(const std::string& md) {
    if (md.empty()) return "";
    char* html = cmark_markdown_to_html(
        md.c_str(), md.size(),
        CMARK_OPT_DEFAULT | CMARK_OPT_SMART | CMARK_OPT_UNSAFE
    );
    std::string result(html);
    free(html);
    return result;
}
