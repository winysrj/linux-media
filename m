Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:10164 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaIOGtP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:49:15 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00E7BKA27MB0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:49:14 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 15/17] [media] s5p-mfc: remove reduntant clock on & clock off
Date: Mon, 15 Sep 2014 12:13:10 +0530
Message-id: <1410763393-12183-16-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sysmmu will control mfc device clock on/off wherever
needed. Explicit clock on/off in the driver is not needed
anymore. Remove such reduntant clock on/off in the driver.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c     |    2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    6 ------
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index f4cb7f2..3a1f97e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -883,7 +883,6 @@ static int s5p_mfc_release(struct file *file)
 
 	mfc_debug_enter();
 	mutex_lock(&dev->mfc_mutex);
-	s5p_mfc_clock_on();
 	vb2_queue_release(&ctx->vq_src);
 	vb2_queue_release(&ctx->vq_dst);
 	/* Mark context as idle */
@@ -906,7 +905,6 @@ static int s5p_mfc_release(struct file *file)
 			mfc_err("Power off failed\n");
 	}
 	mfc_debug(2, "Shutting down clock\n");
-	s5p_mfc_clock_off();
 	dev->ctx[ctx->num] = NULL;
 	s5p_mfc_dec_ctrls_delete(ctx);
 	v4l2_fh_del(&ctx->fh);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index ca4b69f9..d0bdbfb 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -487,8 +487,6 @@ static int reqbufs_output(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 {
 	int ret = 0;
 
-	s5p_mfc_clock_on();
-
 	if (reqbufs->count == 0) {
 		mfc_debug(2, "Freeing buffers\n");
 		ret = vb2_reqbufs(&ctx->vq_src, reqbufs);
@@ -525,7 +523,6 @@ static int reqbufs_output(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 		ret = -EINVAL;
 	}
 out:
-	s5p_mfc_clock_off();
 	if (ret)
 		mfc_err("Failed allocating buffers for OUTPUT queue\n");
 	return ret;
@@ -536,8 +533,6 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 {
 	int ret = 0;
 
-	s5p_mfc_clock_on();
-
 	if (reqbufs->count == 0) {
 		mfc_debug(2, "Freeing buffers\n");
 		ret = vb2_reqbufs(&ctx->vq_dst, reqbufs);
@@ -579,7 +574,6 @@ static int reqbufs_capture(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx,
 		ret = -EINVAL;
 	}
 out:
-	s5p_mfc_clock_off();
 	if (ret)
 		mfc_err("Failed allocating buffers for CAPTURE queue\n");
 	return ret;
-- 
1.7.3.rc2

