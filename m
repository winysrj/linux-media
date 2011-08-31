Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1442 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab1HaNja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Aug 2011 09:39:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/6] V4L menu: move three sensor drivers to the correct sensor section.
Date: Wed, 31 Aug 2011 15:38:43 +0200
Message-Id: <7496a1e99f593f638ef3806479e4f924c3de6b19.1314797675.git.hans.verkuil@cisco.com>
In-Reply-To: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
References: <1314797925-8113-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b5c71c4b9e2f88bd5698a9920b24d24786e4a28c.1314797675.git.hans.verkuil@cisco.com>
References: <b5c71c4b9e2f88bd5698a9920b24d24786e4a28c.1314797675.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/Kconfig |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 8a16a69..5beff36 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -489,6 +489,20 @@ config VIDEO_TCM825X
 	  This is a driver for the Toshiba TCM825x VGA camera sensor.
 	  It is used for example in Nokia N800.
 
+config VIDEO_SR030PC30
+	tristate "SR030PC30 VGA camera sensor support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This driver supports SR030PC30 VGA camera from Siliconfile
+
+config VIDEO_NOON010PC30
+	tristate "NOON010PC30 CIF camera sensor support"
+	depends on I2C && VIDEO_V4L2
+	---help---
+	  This driver supports NOON010PC30 CIF camera from Siliconfile
+
+source "drivers/media/video/m5mols/Kconfig"
+
 comment "Flash devices"
 
 config VIDEO_ADP1653
@@ -724,12 +738,6 @@ config VIDEO_M32R_AR_M64278
 	  To compile this driver as a module, choose M here: the
 	  module will be called arv.
 
-config VIDEO_SR030PC30
-	tristate "SR030PC30 VGA camera sensor support"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  This driver supports SR030PC30 VGA camera from Siliconfile
-
 config VIDEO_VIA_CAMERA
 	tristate "VIAFB camera controller support"
 	depends on FB_VIA
@@ -740,14 +748,6 @@ config VIDEO_VIA_CAMERA
 	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
 	   with ov7670 sensors.
 
-config VIDEO_NOON010PC30
-	tristate "NOON010PC30 CIF camera sensor support"
-	depends on I2C && VIDEO_V4L2
-	---help---
-	  This driver supports NOON010PC30 CIF camera from Siliconfile
-
-source "drivers/media/video/m5mols/Kconfig"
-
 config VIDEO_OMAP3
 	tristate "OMAP 3 Camera support (EXPERIMENTAL)"
 	select OMAP_IOMMU
-- 
1.7.5.4

