Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36374 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdIMIjf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 04:39:35 -0400
From: Allen Pais <allen.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH v2] drivers:staging/media:Use ARRAY_SIZE() for the size calculation of the array
Date: Wed, 13 Sep 2017 14:09:25 +0530
Message-Id: <1505291965-27118-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index e882b55..bee3043 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -451,8 +451,6 @@ static enum ia_css_frame_format yuv422_copy_formats[] = {
 	IA_CSS_FRAME_FORMAT_YUYV
 };
 
-#define array_length(array) (sizeof(array)/sizeof(array[0]))
-
 /* Verify whether the selected output format is can be produced
  * by the copy binary given the stream format.
  * */
@@ -468,7 +466,7 @@ verify_copy_out_frame_format(struct ia_css_pipe *pipe)
 	switch (pipe->stream->config.input_config.format) {
 	case IA_CSS_STREAM_FORMAT_YUV420_8_LEGACY:
 	case IA_CSS_STREAM_FORMAT_YUV420_8:
-		for (i=0; i<array_length(yuv420_copy_formats) && !found; i++)
+		for (i=0; i<ARRAY_SIZE(yuv420_copy_formats) && !found; i++)
 			found = (out_fmt == yuv420_copy_formats[i]);
 		break;
 	case IA_CSS_STREAM_FORMAT_YUV420_10:
@@ -476,7 +474,7 @@ verify_copy_out_frame_format(struct ia_css_pipe *pipe)
 		found = (out_fmt == IA_CSS_FRAME_FORMAT_YUV420_16);
 		break;
 	case IA_CSS_STREAM_FORMAT_YUV422_8:
-		for (i=0; i<array_length(yuv422_copy_formats) && !found; i++)
+		for (i=0; i<ARRAY_SIZE(yuv422_copy_formats) && !found; i++)
 			found = (out_fmt == yuv422_copy_formats[i]);
 		break;
 	case IA_CSS_STREAM_FORMAT_YUV422_10:
-- 
2.7.4
