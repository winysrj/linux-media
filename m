Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:33620 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbcHOOIx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 10:08:53 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/5] doc-rst:c-domain: ref-name of a function declaration
Date: Mon, 15 Aug 2016 16:08:25 +0200
Message-Id: <1471270108-29314-3-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
References: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Add option 'name' to the "c:function:" directive.  With option 'name'
the ref-name of a function can be modified. E.g.::

    .. c:function:: int ioctl( int fd, int request )
       :name: VIDIOC_LOG_STATUS

The func-name (e.g. ioctl) remains in the output but the ref-name
changed from ``ioctl`` to ``VIDIOC_LOG_STATUS``. The index entry for
this function is also changed to ``VIDIOC_LOG_STATUS`` and the function
can now referenced by::

    :c:func:`VIDIOC_LOG_STATUS`

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/kernel-documentation.rst | 29 +++++++++++++++++++++++++++++
 Documentation/sphinx/cdomain.py        | 31 +++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/Documentation/kernel-documentation.rst b/Documentation/kernel-documentation.rst
index 391decc..a0dcae1 100644
--- a/Documentation/kernel-documentation.rst
+++ b/Documentation/kernel-documentation.rst
@@ -107,6 +107,35 @@ Here are some specific guidelines for the kernel documentation:
   the order as encountered."), having the higher levels the same overall makes
   it easier to follow the documents.
 
+
+the C domain
+------------
+
+The `Sphinx C Domain`_ (name c) is suited for documentation of C API. E.g. a
+function prototype:
+
+.. code-block:: rst
+
+    .. c:function:: int ioctl( int fd, int request )
+
+The C domain of the kernel-doc has some additional features. E.g. you can
+*rename* the reference name of a function with a common name like ``open`` or
+``ioctl``:
+
+.. code-block:: rst
+
+     .. c:function:: int ioctl( int fd, int request )
+        :name: VIDIOC_LOG_STATUS
+
+The func-name (e.g. ioctl) remains in the output but the ref-name changed from
+``ioctl`` to ``VIDIOC_LOG_STATUS``. The index entry for this function is also
+changed to ``VIDIOC_LOG_STATUS`` and the function can now referenced by:
+
+.. code-block:: rst
+
+     :c:func:`VIDIOC_LOG_STATUS`
+
+
 list tables
 -----------
 
diff --git a/Documentation/sphinx/cdomain.py b/Documentation/sphinx/cdomain.py
index c32387a..99cd035 100644
--- a/Documentation/sphinx/cdomain.py
+++ b/Documentation/sphinx/cdomain.py
@@ -7,8 +7,24 @@ u"""
 
     :copyright:  Copyright (C) 2016  Markus Heiser
     :license:    GPL Version 2, June 1991 see Linux/COPYING for details.
+
+    List of customizations:
+
+    * Add option 'name' to the "c:function:" directive.  With option 'name' the
+      ref-name of a function can be modified. E.g.::
+
+          .. c:function:: int ioctl( int fd, int request )
+             :name: VIDIOC_LOG_STATUS
+
+      The func-name (e.g. ioctl) remains in the output but the ref-name changed
+      from 'ioctl' to 'VIDIOC_LOG_STATUS'. The function is referenced by::
+
+          * :c:func:`VIDIOC_LOG_STATUS` or
+          * :any:`VIDIOC_LOG_STATUS` (``:any:`` needs sphinx 1.3)
 """
 
+from docutils.parsers.rst import directives
+
 from sphinx.domains.c import CObject as Base_CObject
 from sphinx.domains.c import CDomain as Base_CDomain
 
@@ -29,6 +45,21 @@ class CObject(Base_CObject):
     """
     Description of a C language object.
     """
+    option_spec = {
+        "name" : directives.unchanged
+    }
+
+    def handle_signature(self, sig, signode):
+        """Transform a C signature into RST nodes."""
+        fullname = super(CObject, self).handle_signature(sig, signode)
+        if "name" in self.options:
+            if self.objtype == 'function':
+                fullname = self.options["name"]
+            else:
+                # FIXME: handle :name: value of other declaration types?
+                pass
+        return fullname
+
 
 class CDomain(Base_CDomain):
 
-- 
2.7.4

