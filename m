Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34844 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdBWLqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 06:46:50 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Inki Dae <inki.dae@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] media: mfc: Fix race between interrupt routine and device
 functions
Date: Thu, 23 Feb 2017 12:43:27 +0100
Message-id: <1487850219-6482-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170223114347eucas1p21e5aed393511b41e51aac1df2762db83@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Interrupt routine must wake process waiting for given interrupt AFTER
updating driver's internal structures and contexts. Doing it in-between
is a serious bug. This patch moves all calls to the wake() function to
the end of the interrupt processing block to avoid potential and real
races, especially on multi-core platforms. This also fixes following issue
reported from clock core (clocks were disabled in interrupt after being
unprepared from the other place in the driver, the stack trace however
points to the different place than s5p_mfc driver because of the race):

WARNING: CPU: 1 PID: 18 at drivers/clk/clk.c:544 clk_core_unprepare+0xc8/0x108
Modules linked in:
CPU: 1 PID: 18 Comm: kworker/1:0 Not tainted 4.10.0-next-20170223-00070-g04e18bc99ab9-dirty #2154
Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
Workqueue: pm pm_runtime_work
[<c010d8b0>] (unwind_backtrace) from [<c010a534>] (show_stack+0x10/0x14)
[<c010a534>] (show_stack) from [<c033292c>] (dump_stack+0x74/0x94)
[<c033292c>] (dump_stack) from [<c011cef4>] (__warn+0xd4/0x100)
[<c011cef4>] (__warn) from [<c011cf40>] (warn_slowpath_null+0x20/0x28)
[<c011cf40>] (warn_slowpath_null) from [<c0387a84>] (clk_core_unprepare+0xc8/0x108)
[<c0387a84>] (clk_core_unprepare) from [<c0389d84>] (clk_unprepare+0x24/0x2c)
[<c0389d84>] (clk_unprepare) from [<c03d4660>] (exynos_sysmmu_suspend+0x48/0x60)
[<c03d4660>] (exynos_sysmmu_suspend) from [<c042b9b0>] (pm_generic_runtime_suspend+0x2c/0x38)
[<c042b9b0>] (pm_generic_runtime_suspend) from [<c0437580>] (genpd_runtime_suspend+0x94/0x220)
[<c0437580>] (genpd_runtime_suspend) from [<c042e240>] (__rpm_callback+0x134/0x208)
[<c042e240>] (__rpm_callback) from [<c042e334>] (rpm_callback+0x20/0x80)
[<c042e334>] (rpm_callback) from [<c042d3b8>] (rpm_suspend+0xdc/0x458)
[<c042d3b8>] (rpm_suspend) from [<c042ea24>] (pm_runtime_work+0x80/0x90)
[<c042ea24>] (pm_runtime_work) from [<c01322c4>] (process_one_work+0x120/0x318)
[<c01322c4>] (process_one_work) from [<c0132520>] (worker_thread+0x2c/0x4ac)
[<c0132520>] (worker_thread) from [<c0137ab0>] (kthread+0xfc/0x134)
[<c0137ab0>] (kthread) from [<c0107978>] (ret_from_fork+0x14/0x3c)
---[ end trace 1ead49a7bb83f0d8 ]---

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: af93574678108 ("[media] MFC: Add MFC 5.1 V4L2 driver")
CC: stable@vger.kernel.org # v4.5+
---
This issue was there from the beggining of the driver, but this patch applies
only to v4.5+ kernels.
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 9e0685beb048..d6cb315dac60 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -657,9 +657,9 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 				break;
 			}
 			s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
-			wake_up_ctx(ctx, reason, err);
 			WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
 			s5p_mfc_clock_off();
+			wake_up_ctx(ctx, reason, err);
 			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 		} else {
 			s5p_mfc_handle_frame(ctx, reason, err);
@@ -673,15 +673,11 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 	case S5P_MFC_R2H_CMD_OPEN_INSTANCE_RET:
 		ctx->inst_no = s5p_mfc_hw_call(dev->mfc_ops, get_inst_no, dev);
 		ctx->state = MFCINST_GOT_INST;
-		clear_work_bit(ctx);
-		wake_up(&ctx->queue);
 		goto irq_cleanup_hw;
 
 	case S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET:
-		clear_work_bit(ctx);
 		ctx->inst_no = MFC_NO_INSTANCE_SET;
 		ctx->state = MFCINST_FREE;
-		wake_up(&ctx->queue);
 		goto irq_cleanup_hw;
 
 	case S5P_MFC_R2H_CMD_SYS_INIT_RET:
@@ -691,9 +687,9 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		if (ctx)
 			clear_work_bit(ctx);
 		s5p_mfc_hw_call(dev->mfc_ops, clear_int_flags, dev);
-		wake_up_dev(dev, reason, err);
 		clear_bit(0, &dev->hw_lock);
 		clear_bit(0, &dev->enter_suspend);
+		wake_up_dev(dev, reason, err);
 		break;
 
 	case S5P_MFC_R2H_CMD_INIT_BUFFERS_RET:
@@ -708,9 +704,7 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		break;
 
 	case S5P_MFC_R2H_CMD_DPB_FLUSH_RET:
-		clear_work_bit(ctx);
 		ctx->state = MFCINST_RUNNING;
-		wake_up(&ctx->queue);
 		goto irq_cleanup_hw;
 
 	default:
@@ -729,6 +723,8 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 		mfc_err("Failed to unlock hw\n");
 
 	s5p_mfc_clock_off();
+	clear_work_bit(ctx);
+	wake_up(&ctx->queue);
 
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	spin_unlock(&dev->irqlock);
-- 
1.9.1
