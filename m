Return-path: <linux-media-owner@vger.kernel.org>
Received: from alexa-out-blr-01.qualcomm.com ([103.229.18.197]:62860 "EHLO
        alexa-out-blr-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725855AbeJIPOL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 11:14:11 -0400
From: Malathi Gottam <mgottam@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, acourbot@chromium.org,
        vgarodia@codeaurora.org, mgottam@codeaurora.org
Subject: [PATCH] media: venus: amend buffer size for bitstream plane
Date: Tue,  9 Oct 2018 13:22:10 +0530
Message-Id: <1539071530-1441-1-git-send-email-mgottam@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For lower resolutions, incase of encoder, the compressed
frame size is more than half of the corresponding input
YUV. Keep the size as same as YUV considering worst case.

Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 2679adb..05c5423 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -649,7 +649,7 @@ u32 venus_helper_get_framesz(u32 v4l2_fmt, u32 width, u32 height)
 	}
 
 	if (compressed) {
-		sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2 / 2;
+		sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2;
 		return ALIGN(sz, SZ_4K);
 	}
 
-- 
1.9.1
