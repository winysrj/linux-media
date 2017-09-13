Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:37301 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbdIMJQF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 05:16:05 -0400
From: Allen Pais <allen.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH v4] [media]atomisp:use ARRAY_SIZE() instead of open coding.
Date: Wed, 13 Sep 2017 14:45:58 +0530
Message-Id: <1505294158-28408-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The array_length() macro just duplicates ARRAY_SIZE(), so we can
delete it.

v4: Update the commit message.

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
