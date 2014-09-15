Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:62532 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaIOGsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Sep 2014 02:48:51 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NBX00BJFK9EPY50@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 15 Sep 2014 15:48:50 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com
Subject: [PATCH 09/17] [media] s5p-mfc: Don't crash the kernel if the watchdog
 kicks in.
Date: Mon, 15 Sep 2014 12:13:04 +0530
Message-id: <1410763393-12183-10-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
References: <1410763393-12183-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

If the software watchdog kicks in, the watchdog worker is not synchronized
with hardware interrupts and does not block other instances. It's possible
for it to clear the hw_lock, making other instances trigger a BUG() on
hw_lock checks. Since it's not fatal to clear the hw_lock to zero twice,
just WARN in those cases for now. We should not explode, as firmware will
return errors as needed for other instances after it's reloaded, or they
will time out.

A clean fix should involve killing other instances when watchdog kicks in,
but requires a major redesign of locking in the driver.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 4ab3b53..cc9fd0c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -344,8 +344,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		ctx->state = MFCINST_RES_CHANGE_INIT;
 		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 		wake_up_ctx(ctx, reason, err);
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
+		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		return;
 	}
@@ -416,8 +415,7 @@ leave_handle_frame:
 		clear_work_bit(ctx);
 	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	wake_up_ctx(ctx, reason, err);
-	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-		BUG();
+	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	/* if suspending, wake up device*/
 	if (test_bit(0, &dev->enter_suspend))
 		wake_up_dev(dev, reason, err);
@@ -463,8 +461,7 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 			break;
 		}
 	}
-	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-		BUG();
+	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	if (test_and_clear_bit(0, &dev->clk_flag))
 		s5p_mfc_clock_off();
@@ -519,8 +516,7 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 	}
 	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	clear_work_bit(ctx);
-	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-		BUG();
+	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	wake_up_ctx(ctx, reason, err);
 }
@@ -557,14 +553,12 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 		} else {
 			ctx->dpb_flush_flag = 0;
 		}
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
+		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 
 		wake_up(&ctx->queue);
 		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	} else {
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
+		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 
 		if (test_and_clear_bit(0, &dev->clk_flag))
 			s5p_mfc_clock_off();
@@ -641,8 +635,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 				mfc_err("post_frame_start() failed\n");
 			s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 			wake_up_ctx(ctx, reason, err);
-			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-				BUG();
+			WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		} else {
 			s5p_mfc_handle_frame(ctx, reason, err);
-- 
1.7.3.rc2

