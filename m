Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:57538 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZKQONU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 09:13:20 -0500
From: "Y, Kishore" <kishore.y@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 17 Nov 2009 19:45:52 +0530
Subject: [RFC] [PATCH] omap_vout: default colorspace for RGB565 set to SRGB
Message-ID: <E0D41E29EB0DAC4E9F3FF173962E9E940254299E0F@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is dependent on the patch
[PATCH 4/4] OMAP2/3 V4L2: Add support for OMAP2/3 V4L2 driver on top of DSS2

>From 41b85f02f441771ace6c42ee08475ab7be04eb90 Mon Sep 17 00:00:00 2001
From: Kishore Y <kishore.y@ti.com>
Date: Wed, 11 Nov 2009 19:47:14 +0530
Subject: [PATCH] omap_vout: default colorspace for RGB565 set to SRGB

Default video format is set to RGB565 and the colorspace is set to
JPEG. Best colorspace for RGB565 is SRGB and hence changed to it.

Signed-off-by: Kishore Y <kishore.y@ti.com>
---
 drivers/media/video/omap/omap_vout.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 6118665..7092ef2 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -2078,7 +2078,7 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 	pix->bytesperline = pix->width * 2;
 	pix->sizeimage = pix->bytesperline * pix->height;
 	pix->priv = 0;
-	pix->colorspace = V4L2_COLORSPACE_JPEG;
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
 
 	vout->bpp = RGB565_BPP;
 	vout->fbuf.fmt.width  =  display->panel.timings.x_res;
-- 
1.5.4.3


Regards,
Kishore Y
Ph:- +918039813085

