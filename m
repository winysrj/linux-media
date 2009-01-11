Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46353 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752675AbZAKSQ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 13:16:29 -0500
Date: Sun, 11 Jan 2009 19:16:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <damm@igel.co.jp>
Subject: [PATCH 2/2] soc-camera: extend soc_camera_bus_param_compatible with
 more tests
Message-ID: <Pine.LNX.4.64.0901111902400.16531@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add data signal polarity and bus-width tests to 
soc_camera_bus_param_compatible().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Tested on pxa270 with mt9m001. Please review / test further platforms and 
configurations.

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 7440d92..b39e093 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -239,15 +239,17 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
 static inline unsigned long soc_camera_bus_param_compatible(
 			unsigned long camera_flags, unsigned long bus_flags)
 {
-	unsigned long common_flags, hsync, vsync, pclk;
+	unsigned long common_flags, hsync, vsync, pclk, data, buswidth;
 
 	common_flags = camera_flags & bus_flags;
 
 	hsync = common_flags & (SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW);
 	vsync = common_flags & (SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW);
 	pclk = common_flags & (SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING);
+	data = common_flags & (SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_LOW);
+	buswidth = common_flags & SOCAM_DATAWIDTH_MASK;
 
-	return (!hsync || !vsync || !pclk) ? 0 : common_flags;
+	return (!hsync || !vsync || !pclk || !data || !buswidth) ? 0 : common_flags;
 }
 
 extern unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
