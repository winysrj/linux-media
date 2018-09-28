Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35005 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbeI1NzY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 09:55:24 -0400
Received: by mail-wr1-f66.google.com with SMTP id o16so5239008wrx.2
        for <linux-media@vger.kernel.org>; Fri, 28 Sep 2018 00:32:59 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: hyun.kwon@xilinx.com, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, michal.simek@xilinx.com
Cc: Andrea Merello <andrea.merello@gmail.com>,
        linux-media@vger.kernel.org, Mirco Di Salvo <mirco.disalvo@iit.it>
Subject: [PATCH] [media] v4l: xilinx: fix typo in formats table
Date: Fri, 28 Sep 2018 09:32:13 +0200
Message-Id: <20180928073213.10022-1-andrea.merello@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In formats table the entry for CFA pattern "rggb" has GRBG fourcc.
This patch fixes it.

Cc: linux-media@vger.kernel.org
Signed-off-by: Mirco Di Salvo <mirco.disalvo@iit.it>
Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/media/platform/xilinx/xilinx-vip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/platform/xilinx/xilinx-vip.c
index 311259129504..e9567cdfb89b 100644
--- a/drivers/media/platform/xilinx/xilinx-vip.c
+++ b/drivers/media/platform/xilinx/xilinx-vip.c
@@ -36,7 +36,7 @@ static const struct xvip_video_format xvip_video_formats[] = {
 	{ XVIP_VF_MONO_SENSOR, 8, "mono", MEDIA_BUS_FMT_Y8_1X8,
 	  1, V4L2_PIX_FMT_GREY, "Greyscale 8-bit" },
 	{ XVIP_VF_MONO_SENSOR, 8, "rggb", MEDIA_BUS_FMT_SRGGB8_1X8,
-	  1, V4L2_PIX_FMT_SGRBG8, "Bayer 8-bit RGGB" },
+	  1, V4L2_PIX_FMT_SRGGB8, "Bayer 8-bit RGGB" },
 	{ XVIP_VF_MONO_SENSOR, 8, "grbg", MEDIA_BUS_FMT_SGRBG8_1X8,
 	  1, V4L2_PIX_FMT_SGRBG8, "Bayer 8-bit GRBG" },
 	{ XVIP_VF_MONO_SENSOR, 8, "gbrg", MEDIA_BUS_FMT_SGBRG8_1X8,
-- 
2.17.1
