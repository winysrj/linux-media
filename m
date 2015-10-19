Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34241 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbJSWIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2015 18:08:11 -0400
Received: by lbbwb3 with SMTP id wb3so97513630lbb.1
        for <linux-media@vger.kernel.org>; Mon, 19 Oct 2015 15:08:09 -0700 (PDT)
From: Valentine Barshak <valentine.barshak@cogentembedded.com>
To: linux-media@vger.kernel.org, valentine.barshak@cogentembedded.com
Subject: [PATCH] [media] test
Date: Tue, 20 Oct 2015 01:08:07 +0300
Message-Id: <1445292487-22427-1-git-send-email-valentine.barshak@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: valentine.barshak@cogentembedded.com

test
---
 drivers/media/platform/soc_camera/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index dddca60..6540847 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -43,12 +43,14 @@ config VIDEO_RCAR_VIN
 config VIDEO_SH_MOBILE_CSI2
 	tristate "SuperH Mobile MIPI CSI-2 Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAVE_CLK
+	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
 	---help---
 	  This is a v4l2 driver for the SuperH MIPI CSI-2 Interface
 
 config VIDEO_SH_MOBILE_CEU
 	tristate "SuperH Mobile CEU Interface driver"
 	depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
+	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
 	select VIDEOBUF2_DMA_CONTIG
 	select SOC_CAMERA_SCALE_CROP
 	---help---
-- 
1.9.3

