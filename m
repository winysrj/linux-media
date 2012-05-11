Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44949 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab2EKHt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:49:27 -0400
Received: by pbbrp8 with SMTP id rp8so2967672pbb.19
        for <linux-media@vger.kernel.org>; Fri, 11 May 2012 00:49:26 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, k.debski@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH] [media] s5p-mfc: Add missing static storage class in s5p_mfc_enc.c file
Date: Fri, 11 May 2012 13:08:14 +0530
Message-Id: <1336721894-32435-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following sparse warnings:
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:1439:5: warning: symbol 'vidioc_s_parm' was not declared. Should it be static?
drivers/media/video/s5p-mfc/s5p_mfc_enc.c:1455:5: warning: symbol 'vidioc_g_parm' was not declared. Should it be static?

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index dff9dc7..acedb20 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -1436,7 +1436,8 @@ static const struct v4l2_ctrl_ops s5p_mfc_enc_ctrl_ops = {
 	.s_ctrl = s5p_mfc_enc_s_ctrl,
 };
 
-int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
+static int vidioc_s_parm(struct file *file, void *priv,
+			 struct v4l2_streamparm *a)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 
@@ -1452,7 +1453,8 @@ int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
 	return 0;
 }
 
-int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
+static int vidioc_g_parm(struct file *file, void *priv,
+			 struct v4l2_streamparm *a)
 {
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
 
-- 
1.7.4.1

