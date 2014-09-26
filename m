Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:21048 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaIZE7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 00:59:25 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NCH000NLSIZCG10@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Sep 2014 13:59:23 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com, kiran@chromium.org
Subject: [PATCH v2 07/14] [media] s5p-mfc: Don't crash the kernel if the
 watchdog kicks in.
Date: Fri, 26 Sep 2014 10:22:15 +0530
Message-id: <1411707142-4881-8-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
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
 drivers/media/platform/s5p-mfc/s5p_mfc.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3fc2f8a..8d5da0c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -337,8 +337,7 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		ctx->state = MFCINST_RES_CHANGE_INIT;
 		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 		wake_up_ctx(ctx, reason, err);
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
+		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 		s5p_mfc_clock_off();
 		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		return;
@@ -410,8 +409,7 @@ leave_handle_frame:
 		clear_work_bit(ctx);
 	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	wake_up_ctx(ctx, reason, err);
-	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-		BUG();
+	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	s5p_mfc_clock_off();
 	/* if suspending, wake up device and do not try_run again*/
 	if (test_bit(0, &dev->enter_suspend))
@@ -458,8 +456,7 @@ static void s5p_mfc_handle_error(struct s5p_mfc_dev *dev,
 			break;
 		}
 	}
-	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-		BUG();
+	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	s5p_mfc_clock_off();
 	wake_up_dev(dev, reason, err);
@@ -513,8 +510,7 @@ static void s5p_mfc_handle_seq_done(struct s5p_mfc_ctx *ctx,
 	}
 	s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 	clear_work_bit(ctx);
-	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-		BUG();
+	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 	s5p_mfc_clock_off();
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	wake_up_ctx(ctx, reason, err);
@@ -552,19 +548,13 @@ static void s5p_mfc_handle_init_buffers(struct s5p_mfc_ctx *ctx,
 		} else {
 			ctx->dpb_flush_flag = 0;
 		}
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
-
+		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 		s5p_mfc_clock_off();
-
 		wake_up(&ctx->queue);
 		s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	} else {
-		if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-			BUG();
-
+		WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 		s5p_mfc_clock_off();
-
 		wake_up(&ctx->queue);
 	}
 }
@@ -638,8 +628,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 				mfc_err("post_frame_start() failed\n");
 			s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
 			wake_up_ctx(ctx, reason, err);
-			if (test_and_clear_bit(0, &dev->hw_lock) == 0)
-				BUG();
+			WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 			s5p_mfc_clock_off();
 			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		} else {
-- 
1.7.9.5

