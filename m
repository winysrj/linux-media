Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49832 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaEZTuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:50:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Julien BERAUD <julien.beraud@parrot.com>,
	Boris Todorov <boris.st.todorov@gmail.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Enrico <ebutera@users.berlios.de>,
	Stefan Herbrechtsmeier <sherbrec@cit-ec.uni-bielefeld.de>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Chris Whittenburg <whittenburg@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 07/11] omap3isp: ccdc: Simplify the configuration function
Date: Mon, 26 May 2014 21:50:08 +0200
Message-Id: <1401133812-8745-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Assign the format variable to the sink pad format earlier and use it
instead of accessing the sink pad format directly from the ISP
structure.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 6409292..8fbba95 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1114,6 +1114,9 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
 			->bus.parallel;
 
+	/* CCDC_PAD_SINK */
+	format = &ccdc->formats[CCDC_PAD_SINK];
+
 	/* Compute the lane shifter shift value and enable the bridge when the
 	 * input format is YUV.
 	 */
@@ -1124,8 +1127,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		depth_in = fmt_info->width;
 	}
 
-	fmt_info = omap3isp_video_format_info
-		(isp->isp_ccdc.formats[CCDC_PAD_SINK].code);
+	fmt_info = omap3isp_video_format_info(format->code);
 	depth_out = fmt_info->width;
 	shift = depth_in - depth_out;
 
@@ -1157,9 +1159,6 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	else
 		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
 
-	/* CCDC_PAD_SINK */
-	format = &ccdc->formats[CCDC_PAD_SINK];
-
 	/* Mosaic filter */
 	switch (format->code) {
 	case V4L2_MBUS_FMT_SRGGB10_1X10:
-- 
1.8.5.5

