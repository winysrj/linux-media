Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.222.116]:59209 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaGDDkK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jul 2014 23:40:10 -0400
From: ayaka <ayaka@soulik.info>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com, m.chehab@samsung.com,
	ayaka <ayaka@soulik.info>
Subject: [PATCH] s5p-mfc: encoder handles buffers freeing
Date: Fri,  4 Jul 2014 11:39:24 +0800
Message-Id: <1404445164-13625-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add handling of buffer freeing reqbufs request to the encoder of
s5p-mfc.

Signed-off-by: ayaka <ayaka@soulik.info>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index d26b248..74fb80b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1166,6 +1166,11 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			mfc_err("error in vb2_reqbufs() for E(D)\n");
 			return ret;
 		}
+		if (reqbufs->count == 0) {
+			mfc_debug(2, "Freeing buffers\n");
+			ctx->capture_state = QUEUE_FREE;
+			return ret;
+		}
 		ctx->capture_state = QUEUE_BUFS_REQUESTED;
 
 		ret = s5p_mfc_hw_call(ctx->dev->mfc_ops,
@@ -1200,6 +1205,11 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			mfc_err("error in vb2_reqbufs() for E(S)\n");
 			return ret;
 		}
+		if (reqbufs->count == 0) {
+			mfc_debug(2, "Freeing buffers\n");
+			ctx->output_state = QUEUE_FREE;
+			return ret;
+		}
 		ctx->output_state = QUEUE_BUFS_REQUESTED;
 	} else {
 		mfc_err("invalid buf type\n");
-- 
1.9.3

