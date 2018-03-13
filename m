Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:43961 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752074AbeCMJLm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 05:11:42 -0400
Received: by mail-pg0-f67.google.com with SMTP id e9so7699201pgs.10
        for <linux-media@vger.kernel.org>; Tue, 13 Mar 2018 02:11:42 -0700 (PDT)
From: Alexandre Courbot <acourbot@chromium.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] venus: vdec: fix format enumeration
Date: Tue, 13 Mar 2018 18:11:35 +0900
Message-Id: <20180313091135.145589-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

find_format_by_index() stops enumerating formats as soon as the index
matches, and returns NULL if venus_helper_check_codec() finds out that
the format is not supported. This prevents formats to be properly
enumerated if a non-supported format is present, as the enumeration will
end with it.

Fix this by moving the call to venus_helper_check_codec() into the loop,
and keep enumerating when it fails.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>

Change-Id: I4ff66e0b85172598efa59a6f01da8cb60597a6a5
---
 drivers/media/platform/qcom/venus/vdec.c | 13 +++++++------
 drivers/media/platform/qcom/venus/venc.c |  9 +++++++--
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index c9e9576bb08a..3677302cfe43 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -135,20 +135,21 @@ find_format_by_index(struct venus_inst *inst, unsigned int index, u32 type)
 		return NULL;
 
 	for (i = 0; i < size; i++) {
+		bool valid;
+
 		if (fmt[i].type != type)
 			continue;
-		if (k == index)
+		valid = (type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE ||
+			 venus_helper_check_codec(inst, fmt[i].pixfmt));
+		if (k == index && valid)
 			break;
-		k++;
+		if (valid)
+			k++;
 	}
 
 	if (i == size)
 		return NULL;
 
-	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
-	    !venus_helper_check_codec(inst, fmt[i].pixfmt))
-		return NULL;
-
 	return &fmt[i];
 }
 
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index e3a10a852cad..5eba4c7cd52e 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -120,11 +120,16 @@ find_format_by_index(struct venus_inst *inst, unsigned int index, u32 type)
 		return NULL;
 
 	for (i = 0; i < size; i++) {
+		bool valid;
+
 		if (fmt[i].type != type)
 			continue;
-		if (k == index)
+		valid = (type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ||
+			 venus_helper_check_codec(inst, fmt[i].pixfmt));
+		if (k == index && valid)
 			break;
-		k++;
+		if (valid)
+			k++;
 	}
 
 	if (i == size)
-- 
2.16.2.660.g709887971b-goog
