Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:64877 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaIZFA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 01:00:27 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NCH0064OSKKQ0E0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Sep 2014 14:00:20 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com, kiran@chromium.org
Subject: [PATCH v2 12/14] [media] s5p-mfc: fix V4L2_CID_MIN_BUFFERS_FOR_CAPTURE
 on resolution change.
Date: Fri, 26 Sep 2014 10:22:20 +0530
Message-id: <1411707142-4881-13-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

G_CTRL on V4L2_CID_MIN_BUFFERS_FOR_CAPTURE will fail if userspace happens to
query it after getting a resolution change event and before the codec has
a chance to parse the header and switch to an initialized state.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index fe4d21c..301d74f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -756,7 +756,8 @@ static int s5p_mfc_dec_g_v_ctrl(struct v4l2_ctrl *ctrl)
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

