Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:37466 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935148AbcHaP3z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 11:29:55 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: [PATCH 3/3] doc-rst:c-domain: function-like macros index entry
Date: Wed, 31 Aug 2016 17:29:32 +0200
Message-Id: <1472657372-21039-4-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de>
References: <1472657372-21039-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

For function-like macros, sphinx creates 'FOO (C function)' entries.
With this patch 'FOO (C macro)' are created for function-like macros,
which is the same for object-like macros.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/sphinx/cdomain.py | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/sphinx/cdomain.py b/Documentation/sphinx/cdomain.py
index 0816090..2a1bd09 100644
--- a/Documentation/sphinx/cdomain.py
+++ b/Documentation/sphinx/cdomain.py
@@ -37,6 +37,7 @@ from docutils.parsers.rst import directives
 
 import sphinx
 from sphinx import addnodes
+from sphinx.locale import _
 from sphinx.domains.c import c_funcptr_sig_re, c_sig_re
 from sphinx.domains.c import CObject as Base_CObject
 from sphinx.domains.c import CDomain as Base_CDomain
@@ -66,6 +67,8 @@ class CObject(Base_CObject):
         "name" : directives.unchanged
     }
 
+    is_function_like_macro = False
+
     def handle_func_like_macro(self, sig, signode):
         u"""Handles signatures of function-like macros.
 
@@ -104,6 +107,7 @@ class CObject(Base_CObject):
             param += nodes.emphasis(argname, argname)
             paramlist += param
 
+        self.is_function_like_macro = True
         return fullname
 
     def handle_signature(self, sig, signode):
@@ -151,6 +155,12 @@ class CObject(Base_CObject):
                 self.indexnode['entries'].append(
                     ('single', indextext, targetname, '', None))
 
+    def get_index_text(self, name):
+        if self.is_function_like_macro:
+            return _('%s (C macro)') % name
+        else:
+            return super(CObject, self).get_index_text(name)
+
 class CDomain(Base_CDomain):
 
     """C language domain."""
-- 
2.7.4

