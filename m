Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:48036 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752017AbcLMFm3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 00:42:29 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: HeungJun Kim <riverful.kim@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH RFC] [media] m5mols: add missing dependency on VIDEO_IR_I2C
Date: Tue, 13 Dec 2016 06:44:08 +0100
Message-Id: <1481607848-24053-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Depends on: tag in Kconfig for CONFIG_VIDEO_M5MOLS does not list
VIDEO_IR_I2C so Kconfig displays the dependencies needed so the M-5MOLS
driver can not be found. 

Fixes: commit cb7a01ac324b ("[media] move i2c files into drivers/media/i2c")
Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

searching for VIDEO_M5MOLS in menuconfig currently shows the following 
dependencies
 Depends on: MEDIA_SUPPORT [=m] && I2C [=y] && VIDEO_V4L2 [=m] && \
             VIDEO_V4L2_SUBDEV_API [=y] && MEDIA_CAMERA_SUPPORT [=y]  
but as the default settings include MEDIA_SUBDRV_AUTOSELECT=y the
"I2C module for IR" submenu (CONFIG_VIDEO_IR_I2C) is not displayed
adding the VIDEO_IR_I2C to the dependency list makes this clear

Q: should a patch like this carry a Fixes: tag ? 

Patch was tested against: x86_64_defconfig

Patch is against 4.9.0 (localversion-next is next-20161212)

 drivers/media/i2c/m5mols/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/Kconfig b/drivers/media/i2c/m5mols/Kconfig
index dc8c250..6847a1b 100644
--- a/drivers/media/i2c/m5mols/Kconfig
+++ b/drivers/media/i2c/m5mols/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_M5MOLS
 	tristate "Fujitsu M-5MOLS 8MP sensor support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on I2C && VIDEO_IR_I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	depends on MEDIA_CAMERA_SUPPORT
 	---help---
 	  This driver supports Fujitsu M-5MOLS camera sensor with ISP
-- 
2.1.4

