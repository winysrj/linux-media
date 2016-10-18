Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:45954 "EHLO smtp3-1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034085AbcJRRTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 13:19:52 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH] doc-rst: reST-directive kernel-cmd parse with tabs
Date: Tue, 18 Oct 2016 19:19:28 +0200
Message-Id: <1476811168-2651-2-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1476811168-2651-1-git-send-email-markus.heiser@darmarit.de>
References: <1476811168-2651-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a 'tab-width' option to the kernel-cmd, and convert
whitespace (tabs) well. The default 'tab-width' is 8.  This is also a
bugfix, since without this patch, tabs in command's output are not
handled.

Signed-off-by: Markus Heiser <markus.heiser@darmarit.de>
---
 Documentation/sphinx/kernel_cmd.py | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/sphinx/kernel_cmd.py b/Documentation/sphinx/kernel_cmd.py
index 43f02b0..bbe8fa9 100644
--- a/Documentation/sphinx/kernel_cmd.py
+++ b/Documentation/sphinx/kernel_cmd.py
@@ -27,6 +27,10 @@ u"""
 
         PATH=$(srctree)/scripts:$(srctree)/Documentation/sphinx:...
 
+    ``tab-width``
+
+      Tabulator width of output, default is 8.
+
     ``depends <list of comma separated file names>``
 
       If the stdout of the command line depends on files, you can add them as
@@ -70,7 +74,7 @@ from sphinx.ext.autodoc import AutodocReporter
 
 from docutils import nodes
 from docutils.parsers.rst import Directive, directives
-from docutils.statemachine import ViewList
+from docutils import statemachine
 from docutils.utils.error_reporting import ErrorString
 
 
@@ -105,7 +109,8 @@ class KernelCmd(Directive):
     option_spec = {
         "depends"   : directives.unchanged,
         "code-block": directives.unchanged,
-        "debug"     : directives.flag
+        "debug"     : directives.flag,
+        "tab-width" : directives.nonnegative_int
     }
 
     def warn(self, message, **replace):
@@ -148,6 +153,7 @@ class KernelCmd(Directive):
         shell_env["srctree"] = srctree
 
         lines = self.runCmd(cmd, shell=True, cwd=cwd, env=shell_env)
+
         nodeList = self.nestedParse(lines, fname)
         return nodeList
 
@@ -176,7 +182,7 @@ class KernelCmd(Directive):
         return unicode(out)
 
     def nestedParse(self, lines, fname):
-        content = ViewList()
+        content = statemachine.ViewList()
         node    = nodes.section()
 
         if "code-block" in self.options:
@@ -191,7 +197,10 @@ class KernelCmd(Directive):
                 code_block += "\n    " + l
             lines = code_block + "\n\n"
 
-        for c, l in enumerate(lines.split("\n")):
+        tab_width = self.options.get('tab-width', 8)
+        lines = statemachine.string2lines(lines, tab_width, convert_whitespace=True)
+
+        for c, l in enumerate(lines):
             content.append(l, fname, c)
 
         buf  = self.state.memo.title_styles, self.state.memo.section_level, self.state.memo.reporter
-- 
2.7.4

