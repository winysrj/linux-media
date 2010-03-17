Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47671 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754716Ab0CQMhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 08:37:55 -0400
Date: Wed, 17 Mar 2010 13:38:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] V4L: introduce a Kconfig variable to disable helper-chip
 autoselection
Message-ID: <Pine.LNX.4.64.1003171336180.4354@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Helper-chip autoselection doesn't work in some situations. Add a configuration
variable to let drivers disable it. Use it to disable autoselection if
SOC_CAMERA is selected.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This will also be used from VOU video-output driver, other SoC drivers 
might also want to select this option.

 drivers/media/video/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 64682bf..73f3808 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -77,8 +77,12 @@ config VIDEO_FIXED_MINOR_RANGES
 
 	  When in doubt, say N.
 
+config VIDEO_HELPER_CHIPS_AUTO_DISABLE
+	bool
+
 config VIDEO_HELPER_CHIPS_AUTO
 	bool "Autoselect pertinent encoders/decoders and other helper chips"
+	depends on !VIDEO_HELPER_CHIPS_AUTO_DISABLE
 	default y
 	---help---
 	  Most video cards may require additional modules to encode or
@@ -816,6 +820,7 @@ config SOC_CAMERA
 	tristate "SoC camera support"
 	depends on VIDEO_V4L2 && HAS_DMA && I2C
 	select VIDEOBUF_GEN
+	select VIDEO_HELPER_CHIPS_AUTO_DISABLE
 	help
 	  SoC Camera is a common API to several cameras, not connecting
 	  over a bus like PCI or USB. For example some i2c camera connected
-- 
1.6.2.4

