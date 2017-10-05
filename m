Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:44377 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751380AbdJEArl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 20:47:41 -0400
Received: by mail-pg0-f42.google.com with SMTP id b1so5910706pge.1
        for <linux-media@vger.kernel.org>; Wed, 04 Oct 2017 17:47:41 -0700 (PDT)
Date: Wed, 4 Oct 2017 17:47:38 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] staging/atomisp: Convert timers to use timer_setup()
Message-ID: <20171005004738.GA22870@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c  | 13 ++++---------
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h  |  6 +-----
 .../media/atomisp/pci/atomisp2/atomisp_compat_css20.c     |  2 +-
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c | 15 +++++----------
 4 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index f48bf451c1f5..6a38cd64b2a1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -1660,20 +1660,15 @@ void atomisp_css_flush(struct atomisp_device *isp)
 	dev_dbg(isp->dev, "atomisp css flush done\n");
 }
 
-#ifndef ISP2401
-void atomisp_wdt(unsigned long isp_addr)
-#else
-void atomisp_wdt(unsigned long pipe_addr)
-#endif
+void atomisp_wdt(struct timer_list *t)
 {
 #ifndef ISP2401
-	struct atomisp_device *isp = (struct atomisp_device *)isp_addr;
+	struct atomisp_sub_device *asd = from_timer(asd, t, wdt);
 #else
-	struct atomisp_video_pipe *pipe =
-		(struct atomisp_video_pipe *)pipe_addr;
+	struct atomisp_video_pipe *pipe = from_timer(pipe, t, wdt);
 	struct atomisp_sub_device *asd = pipe->asd;
-	struct atomisp_device *isp = asd->isp;
 #endif
+	struct atomisp_device *isp = asd->isp;
 
 #ifdef ISP2401
 	atomic_inc(&pipe->wdt_count);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
index 31ba4e613d13..4bb83864da2e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
@@ -85,11 +85,7 @@ static inline void __iomem *atomisp_get_io_virt_addr(unsigned int address)
 void atomisp_msi_irq_init(struct atomisp_device *isp, struct pci_dev *dev);
 void atomisp_msi_irq_uninit(struct atomisp_device *isp, struct pci_dev *dev);
 void atomisp_wdt_work(struct work_struct *work);
-#ifndef ISP2401
-void atomisp_wdt(unsigned long isp_addr);
-#else
-void atomisp_wdt(unsigned long pipe_addr);
-#endif
+void atomisp_wdt(struct timer_list *t);
 void atomisp_setup_flash(struct atomisp_sub_device *asd);
 irqreturn_t atomisp_isr(int irq, void *dev);
 irqreturn_t atomisp_isr_thread(int irq, void *isp_ptr);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index 05897b747349..0b907474e024 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -4515,7 +4515,7 @@ int atomisp_css_isr_thread(struct atomisp_device *isp,
 			for (i = 0; i < isp->num_of_streams; i++)
 				atomisp_wdt_stop(&isp->asd[i], 0);
 #ifndef ISP2401
-			atomisp_wdt((unsigned long)isp);
+			atomisp_wdt(&isp->asd[0].wdt);
 #else
 			queue_work(isp->wdt_work_queue, &isp->wdt_work);
 #endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 663aa916e3ca..76dc779f32c3 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1155,17 +1155,12 @@ static int init_atomisp_wdts(struct atomisp_device *isp)
 		struct atomisp_sub_device *asd = &isp->asd[i];
 		asd = &isp->asd[i];
 #ifndef ISP2401
-		setup_timer(&asd->wdt, atomisp_wdt, (unsigned long)isp);
+		timer_setup(&asd->wdt, atomisp_wdt, 0);
 #else
-		setup_timer(&asd->video_out_capture.wdt,
-			atomisp_wdt, (unsigned long)&asd->video_out_capture);
-		setup_timer(&asd->video_out_preview.wdt,
-			atomisp_wdt, (unsigned long)&asd->video_out_preview);
-		setup_timer(&asd->video_out_vf.wdt,
-			atomisp_wdt, (unsigned long)&asd->video_out_vf);
-		setup_timer(&asd->video_out_video_capture.wdt,
-			atomisp_wdt,
-			(unsigned long)&asd->video_out_video_capture);
+		timer_setup(&asd->video_out_capture.wdt, atomisp_wdt, 0);
+		timer_setup(&asd->video_out_preview.wdt, atomisp_wdt, 0);
+		timer_setup(&asd->video_out_vf.wdt, atomisp_wdt, 0);
+		timer_setup(&asd->video_out_video_capture.wdt, atomisp_wdt, 0);
 #endif
 	}
 	return 0;
-- 
2.7.4


-- 
Kees Cook
Pixel Security
