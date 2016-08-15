Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:33610 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbcHOOI5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 10:08:57 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 3/5] doc-rst: moved *duplicate* warnings to nitpicky mode
Date: Mon, 15 Aug 2016 16:08:26 +0200
Message-Id: <1471270108-29314-4-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
References: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Moved the *duplicate C object description* warnings for function
declarations in the nitpicky mode. In nitpick mode, you can suppress
those warnings (e.g. ioctl) with::

  nitpicky = True
  nitpick_ignore = [
      ("c:func", "ioctl"),
  ]

See Sphinx documentation for the config values for ``nitpick`` and
``nitpick_ignore`` [1].

With this change all the ".. cpp:function:: int ioctl(..)" descriptions
(found in the media book) can be migrated to ".. c:function:: int
ioctl(..)", without getting any warnings. E.g.::

  .. cpp:function:: int ioctl( int fd, int request, struct cec_event *argp )

  .. c:function:: int ioctl( int fd, int request, struct cec_event *argp )

The main effect, is that we get those *CPP-types* back into Sphinx's C-
namespace and we need no longer to distinguish between c/cpp references,
when we refer a function like the ioctl.

[1] http://www.sphinx-doc.org/en/stable/config.html?highlight=nitpick#confval-nitpicky

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/sphinx/cdomain.py | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/sphinx/cdomain.py b/Documentation/sphinx/cdomain.py
index 99cd035..cb4e8c9 100644
--- a/Documentation/sphinx/cdomain.py
+++ b/Documentation/sphinx/cdomain.py
@@ -10,6 +10,10 @@ u"""
 
     List of customizations:
 
+    * Moved the *duplicate C object description* warnings for function
+      declarations in the nitpicky mode. See Sphinx documentation for
+      the config values for ``nitpick`` and ``nitpick_ignore``.
+
     * Add option 'name' to the "c:function:" directive.  With option 'name' the
       ref-name of a function can be modified. E.g.::
 
@@ -60,6 +64,29 @@ class CObject(Base_CObject):
                 pass
         return fullname
 
+    def add_target_and_index(self, name, sig, signode):
+        # for C API items we add a prefix since names are usually not qualified
+        # by a module name and so easily clash with e.g. section titles
+        targetname = 'c.' + name
+        if targetname not in self.state.document.ids:
+            signode['names'].append(targetname)
+            signode['ids'].append(targetname)
+            signode['first'] = (not self.names)
+            self.state.document.note_explicit_target(signode)
+            inv = self.env.domaindata['c']['objects']
+            if (name in inv and self.env.config.nitpicky):
+                if self.objtype == 'function':
+                    if ('c:func', name) not in self.env.config.nitpick_ignore:
+                        self.state_machine.reporter.warning(
+                            'duplicate C object description of %s, ' % name +
+                            'other instance in ' + self.env.doc2path(inv[name][0]),
+                            line=self.lineno)
+            inv[name] = (self.env.docname, self.objtype)
+
+        indextext = self.get_index_text(name)
+        if indextext:
+            self.indexnode['entries'].append(('single', indextext,
+                                              targetname, '', None))
 
 class CDomain(Base_CDomain):
 
-- 
2.7.4

