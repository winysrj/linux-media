Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44963 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbcGDLr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 07:47:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 17/51] Documentation: linux_tv: remove controls.rst
Date: Mon,  4 Jul 2016 08:46:38 -0300
Message-Id: <9900ae2869fcd6da6d69ff0082009ab8f7f714ae.1467629489.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467629488.git.mchehab@s-opensource.com>
References: <cover.1467629488.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This auto-generated file is bogus: it just adds a toc for two
other files. Instead, just move the controls and extended-controls
directly to the common.rst file.

this avoids a blank page, and better organize the document.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/media/v4l/common.rst   |  3 ++-
 Documentation/linux_tv/media/v4l/controls.rst | 18 ------------------
 2 files changed, 2 insertions(+), 19 deletions(-)
 delete mode 100644 Documentation/linux_tv/media/v4l/controls.rst

diff --git a/Documentation/linux_tv/media/v4l/common.rst b/Documentation/linux_tv/media/v4l/common.rst
index 0e85b46b2efc..40d3feab5ab9 100644
--- a/Documentation/linux_tv/media/v4l/common.rst
+++ b/Documentation/linux_tv/media/v4l/common.rst
@@ -37,7 +37,8 @@ applicable to all devices.
     tuner
     standard
     dv-timings
-    controls
+    control
+    extended-controls
     format
     planar-apis
     crop
diff --git a/Documentation/linux_tv/media/v4l/controls.rst b/Documentation/linux_tv/media/v4l/controls.rst
deleted file mode 100644
index fe5bca543699..000000000000
--- a/Documentation/linux_tv/media/v4l/controls.rst
+++ /dev/null
@@ -1,18 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-.. toctree::
-    :maxdepth: 1
-
-    control
-    extended-controls
-
-
-
-
-.. ------------------------------------------------------------------------------
-.. This file was automatically converted from DocBook-XML with the dbxml
-.. library (https://github.com/return42/sphkerneldoc). The origin XML comes
-.. from the linux kernel, refer to:
-..
-.. * https://github.com/torvalds/linux/tree/master/Documentation/DocBook
-.. ------------------------------------------------------------------------------
-- 
2.7.4


