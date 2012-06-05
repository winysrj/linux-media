Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63390 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab2FEOGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2012 10:06:24 -0400
Received: by weyu7 with SMTP id u7so3598291wey.19
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2012 07:06:23 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, fabio.estevam@freescale.com,
	mchehab@infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH] media: mx2_camera: Add YUYV output format.
Date: Tue,  5 Jun 2012 16:06:13 +0200
Message-Id: <1338905173-5968-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While YUYV format can be handled using generic pass-through mode,
in order to allow resizing the eMMa-PrP has to know exactly
what format it is dealing with to process data accordingly.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/mx2_camera.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index b30ebe5..c8fa457 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -332,6 +332,32 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 		}
 	},
 	{
+		.in_fmt		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.out_fmt	= V4L2_PIX_FMT_YUYV,
+		.cfg		= {
+			.channel	= 1,
+			.in_fmt		= PRP_CNTL_DATA_IN_YUV422,
+			.out_fmt	= PRP_CNTL_CH1_OUT_YUV422,
+			.src_pixel	= 0x22000888, /* YUV422 (YUYV) */
+			.ch1_pixel	= 0x62000888, /* YUV422 (YUYV) */
+			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH1WERR |
+						PRP_INTR_CH1FC | PRP_INTR_LBOVF,
+		}
+	},
+	{
+		.in_fmt		= V4L2_MBUS_FMT_YUYV8_2X8,
+		.out_fmt	= V4L2_PIX_FMT_YUYV,
+		.cfg		= {
+			.channel	= 1,
+			.in_fmt		= PRP_CNTL_DATA_IN_YUV422,
+			.out_fmt	= PRP_CNTL_CH1_OUT_YUV422,
+			.src_pixel	= 0x22000888, /* YUV422 (YUYV) */
+			.ch1_pixel	= 0x62000888, /* YUV422 (YUYV) */
+			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH1WERR |
+						PRP_INTR_CH1FC | PRP_INTR_LBOVF,
+		}
+	},
+	{
 		.in_fmt		= V4L2_MBUS_FMT_YUYV8_2X8,
 		.out_fmt	= V4L2_PIX_FMT_YUV420,
 		.cfg		= {
-- 
1.7.0.4

