Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751237Ab2HTSWT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 14:22:19 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7KIMJYk017867
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 20 Aug 2012 14:22:19 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/6] [media] Put the test devices together
Date: Mon, 20 Aug 2012 15:22:12 -0300
Message-Id: <1345486935-18002-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
References: <1345486935-18002-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Vivi is not that important to appear at the main menu, so move it
to its own submenu. Also, the mem2mem test device driver is
similar to vivi. So, put both at the same menu.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/platform/Kconfig | 54 +++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 39da25b..54e9ebb 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -1,19 +1,5 @@
 if MEDIA_CAMERA_SUPPORT
 
-config VIDEO_VIVI
-	tristate "Virtual Video Driver"
-	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
-	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
-	select FONT_8x16
-	select VIDEOBUF2_VMALLOC
-	default n
-	---help---
-	  Enables a virtual video driver. This device shows a color bar
-	  and a timestamp, as a real device would generate by using V4L2
-	  api.
-	  Say Y here if you want to test video apps or debug V4L devices.
-	  In doubt, say N.
-
 #
 # Platform drivers
 #	All drivers here are currently for webcam support
@@ -135,16 +121,6 @@ menuconfig V4L_MEM2MEM_DRIVERS
 
 if V4L_MEM2MEM_DRIVERS
 
-config VIDEO_MEM2MEM_TESTDEV
-	tristate "Virtual test device for mem2mem framework"
-	depends on VIDEO_DEV && VIDEO_V4L2
-	select VIDEOBUF2_VMALLOC
-	select V4L2_MEM2MEM_DEV
-	default n
-	---help---
-	  This is a virtual test device for the memory-to-memory driver
-	  framework.
-
 config VIDEO_CODA
 	tristate "Chips&Media Coda multi-standard codec IP"
 	depends on VIDEO_DEV && VIDEO_V4L2
@@ -200,4 +176,34 @@ config VIDEO_MX2_EMMAPRP
 
 endif # V4L_MEM2MEM_DRIVERS
 
+menuconfig V4L_TEST_DRIVERS
+	bool "Media test drivers"
+	depends on MEDIA_CAMERA_SUPPORT
+
+if V4L_TEST_DRIVERS
+config VIDEO_VIVI
+	tristate "Virtual Video Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
+	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
+	select FONT_8x16
+	select VIDEOBUF2_VMALLOC
+	default n
+	---help---
+	  Enables a virtual video driver. This device shows a color bar
+	  and a timestamp, as a real device would generate by using V4L2
+	  api.
+	  Say Y here if you want to test video apps or debug V4L devices.
+	  In doubt, say N.
+
+config VIDEO_MEM2MEM_TESTDEV
+	tristate "Virtual test device for mem2mem framework"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF2_VMALLOC
+	select V4L2_MEM2MEM_DEV
+	default n
+	---help---
+	  This is a virtual test device for the memory-to-memory driver
+	  framework.
+endif #V4L_TEST_DRIVERS
+
 endif # MEDIA_CAMERA_SUPPORT
-- 
1.7.11.4

