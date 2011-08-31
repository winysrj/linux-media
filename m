Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3631 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab1HaNjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 09:39:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/6] VL menu: Move some of the less often used drivers down in the menu list.
Date: Wed, 31 Aug 2011 15:38:45 +0200
Message-Id: <e7ad492588c045dcb9aa2bae25186b83dfb707a0.1314797675.git.hans.verkuil@cisco.com>
In-Reply-To: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
References: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b5c71c4b9e2f88bd5698a9920b24d24786e4a28c.1314797675.git.hans.verkuil@cisco.com>
References: <b5c71c4b9e2f88bd5698a9920b24d24786e4a28c.1314797675.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index d14da37..97fdaa7 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -646,22 +646,6 @@ config VIDEO_VIVI
 
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
@@ -676,6 +660,8 @@ source "drivers/media/video/cx18/Kconfig"
 
 source "drivers/media/video/saa7164/Kconfig"
 
+source "drivers/media/video/zoran/Kconfig"
+
 source "drivers/media/video/marvell-ccic/Kconfig"
 
 config VIDEO_VIA_CAMERA
@@ -688,6 +674,20 @@ config VIDEO_VIA_CAMERA
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
1.7.5.4

