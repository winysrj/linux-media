Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:32850 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbdIMIEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 04:04:47 -0400
From: Allen Pais <allen.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH] drivers:staging/media:Use ARRAY_SIZE() for the size calculation of the array
Date: Wed, 13 Sep 2017 13:34:39 +0530
Message-Id: <1505289879-26163-1-git-send-email-allen.lkml@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index e882b55..d822918 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -451,7 +451,7 @@ static enum ia_css_frame_format yuv422_copy_formats[] = {
 	IA_CSS_FRAME_FORMAT_YUYV
 };
 
-#define array_length(array) (sizeof(array)/sizeof(array[0]))
+#define array_length(array) (ARRAY_SIZE(array))
 
 /* Verify whether the selected output format is can be produced
  * by the copy binary given the stream format.
-- 
2.7.4
