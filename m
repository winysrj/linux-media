Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54058 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321AbaJULHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 07:07:52 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	kiran@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH v3 07/13] [media] s5p-mfc: Don't crash the kernel if the watchdog kicks in.
Date: Tue, 21 Oct 2014 16:37:01 +0530
Message-Id: <1413889627-8431-8-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
References: <1413889627-8431-1-git-send-email-arun.kk@samsung.com>
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
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index eb71055..8620236 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -342,8 +342,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		ctx->state = MFCINST_RES_CHANGE_INIT;
 		s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 		wake_up_ctx(ctx, reason, err);
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
+		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 		s5p_mfc_clock_off();
 		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 		return;
@@ -415,8 +414,7 @@ leave_handle_frame:
 		clear_work_bit(ctx);
 	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 	wake_up_ctx(ctx, reason, err);
-	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-		BUG();
+	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	s5p_mfc_clock_off();
 	/* if suspending, wake up device and do not try_run again*/
 	if (test_bit(0, &dev->enter_suspend))
@@ -463,8 +461,7 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 			break;
 		}
 	}
-	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-		BUG();
+	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 	s5p_mfc_clock_off();
 	wake_up_dev(dev, reason, err);
@@ -518,8 +515,7 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 	}
 	s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 	clear_work_bit(ctx);
-	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-		BUG();
+	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	s5p_mfc_clock_off();
 	s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 	wake_up_ctx(ctx, reason, err);
@@ -557,16 +553,14 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 		} else {
 			ctx->dpb_flush_flag = 0;
 		}
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
+		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 
 		s5p_mfc_clock_off();
 
 		wake_up(&ctx->queue);
 		s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 	} else {
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
+		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 
 		s5p_mfc_clock_off();
 
@@ -643,8 +637,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 				mfc_err("post_frame_start() failed\n");
 			s5p_mfc_hw_call_void(dev->mfc_ops, clear_int_flags, dev);
 			wake_up_ctx(ctx, reason, err);
-			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-				BUG();
+			WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 			s5p_mfc_clock_off();
 			s5p_mfc_hw_call_void(dev->mfc_ops, try_run, dev);
 		} else {
-- 
1.7.9.5

