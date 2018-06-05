Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:37431 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbeFEEvC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 00:51:02 -0400
Received: by mail-pl0-f65.google.com with SMTP id 31-v6so736616plc.4
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 21:51:01 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] media: venus: keep resolution when adjusting format
Date: Tue,  5 Jun 2018 13:50:46 +0900
Message-Id: <20180605045046.200011-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When checking a format for validity, the resolution is reset to 1280x720
whenever the pixel format is not supported. This behavior can mislead
user-space into believing that this is the only resolution supported,
and looks strange considering that if we try/set the same format with
just the pixel format changed to a valid one, the call will this time
succeed without altering the resolution.

Resolution is managed independently of the pixel format, so remove this
reset.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 2 --
 drivers/media/platform/qcom/venus/venc.c | 2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 49bbd1861d3a..f89a91d43cc9 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -173,8 +173,6 @@ vdec_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 		else
 			return NULL;
 		fmt = find_format(inst, pixmp->pixelformat, f->type);
-		pixmp->width = 1280;
-		pixmp->height = 720;
 	}
 
 	pixmp->width = clamp(pixmp->width, inst->cap_width.min,
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 6b2ce479584e..11dafc7848c5 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -297,8 +297,6 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 		else
 			return NULL;
 		fmt = find_format(inst, pixmp->pixelformat, f->type);
-		pixmp->width = 1280;
-		pixmp->height = 720;
 	}
 
 	pixmp->width = clamp(pixmp->width, inst->cap_width.min,
-- 
2.17.1.1185.g55be947832-goog
