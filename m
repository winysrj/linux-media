Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:41608 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753663AbcIGHNo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 03:13:44 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH v2 2/3] doc-rst:c-domain: function-like macros arguments
Date: Wed,  7 Sep 2016 09:12:57 +0200
Message-Id: <1473232378-11869-3-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Handle signatures of function-like macros well. Don't try to deduce
arguments types of function-like macros.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/sphinx/cdomain.py | 55 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/Documentation/sphinx/cdomain.py b/Documentation/sphinx/cdomain.py
index 5f0c7ed..df0419c 100644
--- a/Documentation/sphinx/cdomain.py
+++ b/Documentation/sphinx/cdomain.py
@@ -1,4 +1,5 @@
 # -*- coding: utf-8; mode: python -*-
+# pylint: disable=W0141,C0113,C0103,C0325
 u"""
     cdomain
     ~~~~~~~
@@ -25,11 +26,18 @@ u"""
 
           * :c:func:`VIDIOC_LOG_STATUS` or
           * :any:`VIDIOC_LOG_STATUS` (``:any:`` needs sphinx 1.3)
+
+     * Handle signatures of function-like macros well. Don't try to deduce
+       arguments types of function-like macros.
+
 """
 
+from docutils import nodes
 from docutils.parsers.rst import directives
 
 import sphinx
+from sphinx import addnodes
+from sphinx.domains.c import c_funcptr_sig_re, c_sig_re
 from sphinx.domains.c import CObject as Base_CObject
 from sphinx.domains.c import CDomain as Base_CDomain
 
@@ -57,9 +65,54 @@ class CObject(Base_CObject):
         "name" : directives.unchanged
     }
 
+    def handle_func_like_macro(self, sig, signode):
+        u"""Handles signatures of function-like macros.
+
+        If the objtype is 'function' and the the signature ``sig`` is a
+        function-like macro, the name of the macro is returned. Otherwise
+        ``False`` is returned.  """
+
+        if not self.objtype == 'function':
+            return False
+
+        m = c_funcptr_sig_re.match(sig)
+        if m is None:
+            m = c_sig_re.match(sig)
+            if m is None:
+                raise ValueError('no match')
+
+        rettype, fullname, arglist, _const = m.groups()
+        arglist = arglist.strip()
+        if rettype or not arglist:
+            return False
+
+        arglist = arglist.replace('`', '').replace('\\ ', '') # remove markup
+        arglist = [a.strip() for a in arglist.split(",")]
+
+        # has the first argument a type?
+        if len(arglist[0].split(" ")) > 1:
+            return False
+
+        # This is a function-like macro, it's arguments are typeless!
+        signode  += addnodes.desc_name(fullname, fullname)
+        paramlist = addnodes.desc_parameterlist()
+        signode  += paramlist
+
+        for argname in arglist:
+            param = addnodes.desc_parameter('', '', noemph=True)
+            # separate by non-breaking space in the output
+            param += nodes.emphasis(argname, argname)
+            paramlist += param
+
+        return fullname
+
     def handle_signature(self, sig, signode):
         """Transform a C signature into RST nodes."""
-        fullname = super(CObject, self).handle_signature(sig, signode)
+
+        fullname = self.handle_func_like_macro(sig, signode)
+        if not fullname:
+            fullname = super(CObject, self).handle_signature(sig, signode)
+
         if "name" in self.options:
             if self.objtype == 'function':
                 fullname = self.options["name"]
-- 
2.7.4

