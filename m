Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37039 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab0HIPLm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 11:11:42 -0400
Received: from octopus.hi.pengutronix.de ([2001:6f8:1178:2:215:17ff:fe12:23b0])
	by metis.ext.pengutronix.de with esmtp (Exim 4.71)
	(envelope-from <mgr@pengutronix.de>)
	id 1OiU0r-0000GQ-Ri
	for linux-media@vger.kernel.org; Mon, 09 Aug 2010 17:11:41 +0200
Received: from mgr by octopus.hi.pengutronix.de with local (Exim 4.69)
	(envelope-from <mgr@pengutronix.de>)
	id 1OiU0r-0002uR-Qf
	for linux-media@vger.kernel.org; Mon, 09 Aug 2010 17:11:41 +0200
Date: Mon, 9 Aug 2010 16:57:04 +0200
From: Michael Grzeschik <m.grzeschik@pengutronix.de>
To: linux-media-owner@vger.kernel.org
Cc: baruch@tkos.co.il, g.liakhovetski@gmx.de, s.hauer@pengutronix.de
Subject: [PATCH v2][RESEND] mx2_camera: remove emma limitation for RGB565
Message-ID: <20100809145704.GA9670@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008052112440.26127@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

In the current source status the emma has no limitation for any PIXFMT
since the data is parsed raw and unprocessed into the memory.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
v1 -> v2
        Changed Comment in emma_buf_init as recommended

 drivers/media/video/mx2_camera.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index e859c7f..ccd121f 100644
--- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -712,8 +712,11 @@ static void mx27_camera_emma_buf_init(struct soc_camera_device *icd,
 	/*
 	 * We only use the EMMA engine to get rid of the broken
 	 * DMA Engine. No color space consversion at the moment.
-	 * We adjust incoming and outgoing pixelformat to rgb16
-	 * and adjust the bytesperline accordingly.
+	 * We set the incomming and outgoing pixelformat to an
+	 * 16 Bit wide format and adjust the bytesperline
+	 * accordingly. With this configuration the inputdata
+	 * will not be changed by the emma and could be any type
+	 * of 16 Bit Pixelformat.
 	 */
 	writel(PRP_CNTL_CH1EN |
 			PRP_CNTL_CSIEN |
@@ -897,10 +900,6 @@ static int mx2_camera_set_fmt(struct soc_camera_device *icd,
 		return -EINVAL;
 	}
 
-	/* eMMA can only do RGB565 */
-	if (mx27_camera_emma(pcdev) && pix->pixelformat != V4L2_PIX_FMT_RGB565)
-		return -EINVAL;
-
 	mf.width	= pix->width;
 	mf.height	= pix->height;
 	mf.field	= pix->field;
@@ -944,10 +943,6 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
 
 	/* FIXME: implement MX27 limits */
 
-	/* eMMA can only do RGB565 */
-	if (mx27_camera_emma(pcdev) && pixfmt != V4L2_PIX_FMT_RGB565)
-		return -EINVAL;
-
 	/* limit to MX25 hardware capabilities */
 	if (cpu_is_mx25()) {
 		if (xlate->host_fmt->bits_per_sample <= 8)
-- 
1.7.1

