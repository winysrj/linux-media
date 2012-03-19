Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50034 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2CSLmP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 07:42:15 -0400
Received: by ghrr11 with SMTP id r11so5287858ghr.19
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2012 04:42:14 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, andrzej.p@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5p-jpeg: Make the output format setting conditional
Date: Mon, 19 Mar 2012 17:04:49 +0530
Message-Id: <1332156889-8175-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

S5P-JPEG IP on Exynos4210 SoC supports YCbCr422 and YCbCr420
as decoded output formats. But the driver used to fix the output
format as YCbCr422. This is now made conditional depending upon
the requested output format.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-jpeg/jpeg-core.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
index 1105a87..ee78fb2 100644
--- a/drivers/media/video/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
@@ -957,7 +957,10 @@ static void s5p_jpeg_device_run(void *priv)
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
-- 
1.7.4.1

