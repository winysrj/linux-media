Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51895 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab2JMLXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Oct 2012 07:23:08 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so3556620pad.19
        for <linux-media@vger.kernel.org>; Sat, 13 Oct 2012 04:23:07 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] [media] s5p-mfc: Fix compilation warning
Date: Sat, 13 Oct 2012 16:48:34 +0530
Message-Id: <1350127114-5170-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added missing const qualifier.
Without this patch compiler gives the following warning:

drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1576:2: warning:
initialization from incompatible pointer type [enabled by default]
drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1576:2: warning:
(near initialization for ‘s5p_mfc_enc_ioctl_ops.vidioc_subscribe_event’)
[enabled by default]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 2af6d52..5c1d727 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1542,7 +1542,7 @@ int vidioc_encoder_cmd(struct file *file, void *priv,
 }
 
 static int vidioc_subscribe_event(struct v4l2_fh *fh,
-					struct v4l2_event_subscription *sub)
+				  const struct v4l2_event_subscription *sub)
 {
 	switch (sub->type) {
 	case V4L2_EVENT_EOS:
-- 
1.7.4.1

