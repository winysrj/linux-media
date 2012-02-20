Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16319 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2BTKTl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 05:19:41 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZO00JIDSORJJ@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Feb 2012 10:19:39 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZO00406SORNH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Feb 2012 10:19:39 +0000 (GMT)
Date: Mon, 20 Feb 2012 11:19:34 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: [PATCH] s5p-jpeg: Adapt to new controls
To: linux-media@vger.kernel.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1329733174-21608-1-git-send-email-andrzej.p@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adapt to new controls (subsampling)

This is a follow up to http://www.spinics.net/lists/linux-media/msg44348.html

For encoding, the destination format now needs to be set to V4L2_PIX_FMT_JPEG
and the subsampling (4:2:2 or 4:2:0) needs to be set using the respective
control (V4L2_CID_JPEG_CHROMA_SUBSAMPLING). Required buffer size for
destination image during encoding is no longer deduced from the format (which
generally implied overestimation), but needs to be given from userspace in
sizeimage.

Not strictly related to the added controls, this patch also fixes setting the
subsampling of the destination image for decoding, depending on the destination
format.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-jpeg/jpeg-core.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index c104aeb..5a49c30 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -32,10 +32,9 @@
 
 static struct s5p_jpeg_fmt formats_enc[] = {
 	{
-		.name		= "YUV 4:2:0 planar, YCbCr",
-		.fourcc		= V4L2_PIX_FMT_YUV420,
-		.depth		= 12,
-		.colplanes	= 3,
+		.name		= "JPEG JFIF",
+		.fourcc		= V4L2_PIX_FMT_JPEG,
+		.colplanes	= 1,
 		.types		= MEM2MEM_CAPTURE,
 	},
 	{
@@ -43,7 +42,7 @@ static struct s5p_jpeg_fmt formats_enc[] = {
 		.fourcc		= V4L2_PIX_FMT_YUYV,
 		.depth		= 16,
 		.colplanes	= 1,
-		.types		= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
+		.types		= MEM2MEM_OUTPUT,
 	},
 	{
 		.name		= "RGB565",
@@ -1025,11 +1024,14 @@ static void s5p_jpeg_device_run(void *priv)
 		jpeg_htbl_dc(jpeg->regs, 2);
 		jpeg_htbl_ac(jpeg->regs, 3);
 		jpeg_htbl_dc(jpeg->regs, 3);
-	} else {
+	} else { /* S5P_JPEG_DECODE */
 		jpeg_rst_int_enable(jpeg->regs, true);
 		jpeg_data_num_int_enable(jpeg->regs, true);
 		jpeg_final_mcu_num_int_enable(jpeg->regs, true);
-		jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
+		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV)
+			jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
+		else
+			jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_420);
 		jpeg_jpgadr(jpeg->regs, src_addr);
 		jpeg_imgadr(jpeg->regs, dst_addr);
 	}
@@ -1269,6 +1271,7 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 
 	curr_ctx->subsampling = jpeg_get_subsampling_mode(jpeg->regs);
 	spin_unlock(&jpeg->slock);
+
 	jpeg_clear_int(jpeg->regs);
 
 	return IRQ_HANDLED;
-- 
1.7.0.4

