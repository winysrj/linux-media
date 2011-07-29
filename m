Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 02C0118B04A
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:01 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkW-0007oE-RI
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:00 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 26/59] V4L: soc-camera: compatible bus-width flags
Date: Fri, 29 Jul 2011 12:56:26 +0200
Message-Id: <1311937019-29914-27-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the new subdevice media-bus configuration methods bus-width is not
configured along with other bus parameters, instead, it is derived from
the data format. With those methods it is convenient to specify
supported bus-widths in the platform data as (1 << (width - 1)). We
redefine SOCAM_DATAWIDTH_* flags to use the same convention to make
platform data seemlessly reusable.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/media/soc_camera.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 936a504..73337cf 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -241,19 +241,19 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
 #define SOCAM_MASTER			(1 << 0)
 #define SOCAM_SLAVE			(1 << 1)
 #define SOCAM_HSYNC_ACTIVE_HIGH		(1 << 2)
-#define SOCAM_HSYNC_ACTIVE_LOW		(1 << 3)
+#define SOCAM_HSYNC_ACTIVE_LOW		(1 << 6)
 #define SOCAM_VSYNC_ACTIVE_HIGH		(1 << 4)
 #define SOCAM_VSYNC_ACTIVE_LOW		(1 << 5)
-#define SOCAM_DATAWIDTH_4		(1 << 6)
+#define SOCAM_DATAWIDTH_4		(1 << 3)
 #define SOCAM_DATAWIDTH_8		(1 << 7)
 #define SOCAM_DATAWIDTH_9		(1 << 8)
 #define SOCAM_DATAWIDTH_10		(1 << 9)
-#define SOCAM_DATAWIDTH_15		(1 << 10)
-#define SOCAM_DATAWIDTH_16		(1 << 11)
+#define SOCAM_DATAWIDTH_15		(1 << 14)
+#define SOCAM_DATAWIDTH_16		(1 << 15)
 #define SOCAM_PCLK_SAMPLE_RISING	(1 << 12)
 #define SOCAM_PCLK_SAMPLE_FALLING	(1 << 13)
-#define SOCAM_DATA_ACTIVE_HIGH		(1 << 14)
-#define SOCAM_DATA_ACTIVE_LOW		(1 << 15)
+#define SOCAM_DATA_ACTIVE_HIGH		(1 << 10)
+#define SOCAM_DATA_ACTIVE_LOW		(1 << 11)
 #define SOCAM_MIPI_1LANE		(1 << 16)
 #define SOCAM_MIPI_2LANE		(1 << 17)
 #define SOCAM_MIPI_3LANE		(1 << 18)
-- 
1.7.2.5

