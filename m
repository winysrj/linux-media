Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:42414 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbcHOPQW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 11:16:22 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH] doc-rst: add index to sub-folders
Date: Mon, 15 Aug 2016 17:15:59 +0200
Message-Id: <1471274159-2533-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Add a index if only a sub-folder is build e.g.::

  make SPHINXDIRS=media cleandocs htmldocs

BTW: removed dead search link in the top-index file

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/gpu/conf.py     | 2 ++
 Documentation/gpu/index.rst   | 7 +++++++
 Documentation/index.rst       | 1 -
 Documentation/media/conf.py   | 2 ++
 Documentation/media/index.rst | 7 +++++++
 5 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/gpu/conf.py b/Documentation/gpu/conf.py
index d60bcd0..6314d17 100644
--- a/Documentation/gpu/conf.py
+++ b/Documentation/gpu/conf.py
@@ -1,3 +1,5 @@
 # -*- coding: utf-8; mode: python -*-
 
 project = "Linux GPU Driver Developer's Guide"
+
+tags.add("subproject")
diff --git a/Documentation/gpu/index.rst b/Documentation/gpu/index.rst
index fcac0fa..5ff3d2b 100644
--- a/Documentation/gpu/index.rst
+++ b/Documentation/gpu/index.rst
@@ -12,3 +12,10 @@ Linux GPU Driver Developer's Guide
    drm-uapi
    i915
    vga-switcheroo
+
+.. only::  subproject
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/index.rst b/Documentation/index.rst
index bdd9525..a15f818 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -19,4 +19,3 @@ Indices and tables
 ==================
 
 * :ref:`genindex`
-* :ref:`search`
diff --git a/Documentation/media/conf.py b/Documentation/media/conf.py
index 62bdba2..77cb2bb 100644
--- a/Documentation/media/conf.py
+++ b/Documentation/media/conf.py
@@ -1,3 +1,5 @@
 # -*- coding: utf-8; mode: python -*-
 
 project = 'Linux Media Subsystem Documentation'
+
+tags.add("subproject")
diff --git a/Documentation/media/index.rst b/Documentation/media/index.rst
index e85c557..7f8f0af 100644
--- a/Documentation/media/index.rst
+++ b/Documentation/media/index.rst
@@ -10,3 +10,10 @@ Contents:
    media_kapi
    dvb-drivers/index
    v4l-drivers/index
+
+.. only::  subproject
+
+   Indices
+   =======
+
+   * :ref:`genindex`
-- 
2.7.4

