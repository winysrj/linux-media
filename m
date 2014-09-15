Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:17481 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaIOGtP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:49:15 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00H3KK9XVI80@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:49:09 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 14/17] [media] s5p-mfc: fix V4L2_CID_MIN_BUFFERS_FOR_CAPTURE on
 resolution change.
Date: Mon, 15 Sep 2014 12:13:09 +0530
Message-id: <1410763393-12183-15-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
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
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 9103258..ca4b69f9 100644
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
1.7.3.rc2

