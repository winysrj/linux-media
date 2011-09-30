Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4717 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab1I3JBk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 05:01:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 5/7] VL menu: Move some of the less often used drivers down in the menu list.
Date: Fri, 30 Sep 2011 11:01:14 +0200
Message-Id: <a2a0306e0995e22edc67788c97512cf18f19d457.1317372990.git.hans.verkuil@cisco.com>
In-Reply-To: <1317373276-5818-1-git-send-email-hverkuil@xs4all.nl>
References: <1317373276-5818-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317372990.git.hans.verkuil@cisco.com>
References: <9198dc44ea6f7b8e481c8e6bb24c80fc1b2429ed.1317372990.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 07d31d4..b4a14f3 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -662,22 +662,6 @@ config VIDEO_VIVI
 
 source "drivers/media/video/bt8xx/Kconfig"
 
-source "drivers/media/video/zoran/Kconfig"
-
-config VIDEO_MEYE
-	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
-	depends on PCI && SONY_LAPTOP && VIDEO_V4L2
-	---help---
-	  This is the video4linux driver for the Motion Eye camera found
-	  in the Vaio Picturebook laptops. Please read the material in
-	  <file:Documentation/video4linux/meye.txt> for more information.
-
-	  If you say Y or M here, you need to say Y or M to "Sony Laptop
-	  Extras" in the misc device section.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called meye.
-
 source "drivers/media/video/saa7134/Kconfig"
 
 source "drivers/media/video/cx88/Kconfig"
@@ -692,6 +676,8 @@ source "drivers/media/video/cx18/Kconfig"
 
 source "drivers/media/video/saa7164/Kconfig"
 
+source "drivers/media/video/zoran/Kconfig"
+
 source "drivers/media/video/marvell-ccic/Kconfig"
 
 config VIDEO_VIA_CAMERA
@@ -704,6 +690,20 @@ config VIDEO_VIA_CAMERA
 	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
 	   with ov7670 sensors.
 
+config VIDEO_MEYE
+	tristate "Sony Vaio Picturebook Motion Eye Video For Linux"
+	depends on PCI && SONY_LAPTOP && VIDEO_V4L2
+	---help---
+	  This is the video4linux driver for the Motion Eye camera found
+	  in the Vaio Picturebook laptops. Please read the material in
+	  <file:Documentation/video4linux/meye.txt> for more information.
+
+	  If you say Y or M here, you need to say Y or M to "Sony Laptop
+	  Extras" in the misc device section.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called meye.
+
 #
 # Platform multimedia device configuration
 #
-- 
1.7.6.3

