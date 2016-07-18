Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45848 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbcGRB4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 21:56:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 17/36] [media] doc-rst: add davinci-vpbe documentation
Date: Sun, 17 Jul 2016 22:56:00 -0300
Message-Id: <e0f104538c2a1b777e5adfd24ae54a2bb84ba825.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
In-Reply-To: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
References: <d8e9230c2e8b8a67162997241d979ee4031cb7fd.1468806744.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert it to rst format and add it to the v4l-drivers book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/v4l-drivers/davinci-vpbe.rst | 32 +++++++++++++-----------
 Documentation/media/v4l-drivers/index.rst        |  1 +
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/Documentation/media/v4l-drivers/davinci-vpbe.rst b/Documentation/media/v4l-drivers/davinci-vpbe.rst
index dc9a297f49c3..b545fe001919 100644
--- a/Documentation/media/v4l-drivers/davinci-vpbe.rst
+++ b/Documentation/media/v4l-drivers/davinci-vpbe.rst
@@ -1,9 +1,9 @@
+The VPBE V4L2 driver design
+===========================
 
-                VPBE V4L2 driver design
- ======================================================================
+File partitioning
+-----------------
 
- File partitioning
- -----------------
  V4L2 display device driver
          drivers/media/platform/davinci/vpbe_display.c
          drivers/media/platform/davinci/vpbe_display.h
@@ -22,11 +22,11 @@
          drivers/media/platform/davinci/vpbe_osd.h
          drivers/media/platform/davinci/vpbe_osd_regs.h
 
- Functional partitioning
- -----------------------
+Functional partitioning
+-----------------------
 
- Consists of the following (in the same order as the list under file
- partitioning):-
+Consists of the following (in the same order as the list under file
+partitioning):
 
  1. V4L2 display driver
     Implements creation of video2 and video3 device nodes and
@@ -74,20 +74,22 @@
     features. The VPBE module interacts with the OSD for enabling and
     disabling appropriate features of the OSD.
 
- Current status:-
+Current status
+--------------
 
- A fully functional working version of the V4L2 driver is available. This
- driver has been tested with NTSC and PAL standards and buffer streaming.
+A fully functional working version of the V4L2 driver is available. This
+driver has been tested with NTSC and PAL standards and buffer streaming.
 
- Following are TBDs.
+To be done
+----------
 
- vpbe display controller
+vpbe display controller
     - Add support for external encoders.
     - add support for selecting external encoder as default at probe time.
 
- vpbe venc sub device
+vpbe venc sub device
     - add timings for supporting ths8200
     - add support for LogicPD LCD.
 
- FB drivers
+FB drivers
     - Add support for fbdev drivers.- Ready and part of subsequent patches.
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 839374e60280..1ab7a84de0ff 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -24,4 +24,5 @@ License".
 	cpia2
 	cx18
 	cx88
+	davinci-vpbe
 	zr364xx
-- 
2.7.4

