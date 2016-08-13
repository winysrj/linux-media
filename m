Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:37720 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbcHMONc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 10:13:32 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 2/7] doc-rst: add stand-alone conf.py to media folder
Date: Sat, 13 Aug 2016 16:12:43 +0200
Message-Id: <1471097568-25990-3-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

With the media/conf.py, and media/index.rst the media folder can be
build and distributed stand-alone.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/index.rst       |  7 +------
 Documentation/media/conf.py   |  3 +++
 Documentation/media/index.rst | 12 ++++++++++++
 3 files changed, 16 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/media/conf.py
 create mode 100644 Documentation/media/index.rst

diff --git a/Documentation/index.rst b/Documentation/index.rst
index e0fc729..bdd9525 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -6,18 +6,13 @@
 Welcome to The Linux Kernel's documentation!
 ============================================
 
-Nothing for you to see here *yet*. Please move along.
-
 Contents:
 
 .. toctree::
    :maxdepth: 2
 
    kernel-documentation
-   media/media_uapi
-   media/media_kapi
-   media/dvb-drivers/index
-   media/v4l-drivers/index
+   media/index
    gpu/index
 
 Indices and tables
diff --git a/Documentation/media/conf.py b/Documentation/media/conf.py
new file mode 100644
index 0000000..62bdba2
--- /dev/null
+++ b/Documentation/media/conf.py
@@ -0,0 +1,3 @@
+# -*- coding: utf-8; mode: python -*-
+
+project = 'Linux Media Subsystem Documentation'
diff --git a/Documentation/media/index.rst b/Documentation/media/index.rst
new file mode 100644
index 0000000..e85c557
--- /dev/null
+++ b/Documentation/media/index.rst
@@ -0,0 +1,12 @@
+Linux Media Subsystem Documentation
+===================================
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+   media_uapi
+   media_kapi
+   dvb-drivers/index
+   v4l-drivers/index
-- 
2.7.4

