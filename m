Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:41630 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750820AbcIGHNq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Sep 2016 03:13:46 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH v2 1/3] doc-rst:c-domain: fix sphinx version incompatibility
Date: Wed,  7 Sep 2016 09:12:56 +0200
Message-Id: <1473232378-11869-2-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

The self.indexnode's tuple has changed in sphinx version 1.4, from a
former 4 element tuple to a 5 element tuple.

https://github.com/sphinx-doc/sphinx/commit/e6a5a3a92e938fcd75866b4227db9e0524d58f7c

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/sphinx/cdomain.py | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/Documentation/sphinx/cdomain.py b/Documentation/sphinx/cdomain.py
index 9eb714a..5f0c7ed 100644
--- a/Documentation/sphinx/cdomain.py
+++ b/Documentation/sphinx/cdomain.py
@@ -29,11 +29,15 @@ u"""
 
 from docutils.parsers.rst import directives
 
+import sphinx
 from sphinx.domains.c import CObject as Base_CObject
 from sphinx.domains.c import CDomain as Base_CDomain
 
 __version__  = '1.0'
 
+# Get Sphinx version
+major, minor, patch = map(int, sphinx.__version__.split("."))
+
 def setup(app):
 
     app.override_domain(CDomain)
@@ -85,8 +89,14 @@ class CObject(Base_CObject):
 
         indextext = self.get_index_text(name)
         if indextext:
-            self.indexnode['entries'].append(('single', indextext,
-                                              targetname, '', None))
+            if major == 1 and minor < 4:
+                # indexnode's tuple changed in 1.4
+                # https://github.com/sphinx-doc/sphinx/commit/e6a5a3a92e938fcd75866b4227db9e0524d58f7c
+                self.indexnode['entries'].append(
+                    ('single', indextext, targetname, ''))
+            else:
+                self.indexnode['entries'].append(
+                    ('single', indextext, targetname, '', None))
 
 class CDomain(Base_CDomain):
 
-- 
2.7.4

