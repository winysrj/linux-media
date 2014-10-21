Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62599 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbaJULIO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:08:14 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	kiran@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH v3 12/13] [media] s5p-mfc: fix V4L2_CID_MIN_BUFFERS_FOR_CAPTURE on resolution change.
Date: Tue, 21 Oct 2014 16:37:06 +0530
Message-Id: <1413889627-8431-13-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
References: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

G_CTRL on V4L2_CID_MIN_BUFFERS_FOR_CAPTURE will fail if userspace happens to
query it after getting a resolution change event and before the codec has
a chance to parse the header and switch to an initialized state.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index a98fe02..de90465 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -740,7 +740,8 @@ static int s5p_mfc_dec_g_v_ctrl(struct v4l2_ctrl *ctrl)
 		    ctx->state < MFCINST_ABORT) {
 			ctrl->val = ctx->pb_count;
 			break;
-		} else if (ctx->state != MFCINST_INIT) {
+		} else if (ctx->state != MFCINST_INIT &&
+				ctx->state != MFCINST_RES_CHANGE_END) {
 			v4l2_err(&dev->v4l2_dev, "Decoding not initialised\n");
 			return -EINVAL;
 		}
-- 
1.7.9.5

