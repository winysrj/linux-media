Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55357 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965285AbcAZOit (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 09:38:49 -0500
Date: Tue, 26 Jan 2016 15:38:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <rainyfeeling@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>
Subject: Re: [PATCH 06/13] atmel-isi: check ISI_SR's flags by polling instead
 of interrupt
In-Reply-To: <CAJe_HAeKRtAzcz+s7D_5sXp9pnnM1Mhvu_3L1HQGPLsJLJbTSw@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1601261528560.28816@axis700.grange>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
 <Pine.LNX.4.64.1601241757340.16570@axis700.grange>
 <CAJe_HAeKRtAzcz+s7D_5sXp9pnnM1Mhvu_3L1HQGPLsJLJbTSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 26 Jan 2016, Josh Wu wrote:

> Hi, Guennadi
> 
> 2016-01-25 0:58 GMT+08:00 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > On Mon, 18 Jan 2016, Josh Wu wrote:
> >
> >> In current code, we use a interrupt to check whether ISI reset/disable
> >> action is done. Actually, we also can check ISI SR to check the
> >> reset/disable action by polling, and it is simpler and straight forward.
> >>
> >> So this patch use isi_hw_wait_status() to check the action status. As
> >> the interrupt checking the status is useless, so just remove the interrupt
> >> & completion code.
> >
> > Sorry, I'm not convinced. Switching from interrupt-driven to polling seems
> > counter-productive to me. Why do you want this?
> 
> Yes, it is counter-productive If such code is called very frequently.
> But here we only used for reset and disable the hardware.
> 
> I think it is more straightforward and simple when we just check
> status register after write the reset or disable the ISI control
> register. Using interrupt here is over designed.

I still don't see how you're gaining from this. If you were writing new 
code and you would say: "you know, this path will only be hit rarely, we 
don't know whether interrupt would work, but we have here this simple 
polling solution, that works" I would understand. But you already have a 
technically-superior solution in place! And it works, right? Why change 
it? On the one hand it's your hardware and it's up to you which direction 
to develop it, and my task is just to help you integrate your work into 
the mainline. On the other hand I really don't see any benefits, sorry. 
I'd prefer not to do this unless you can explain the benefits.

> for the sake of performance I should use cpu_releax() instead of
> msleep() when waiting for the status bit.

Don't think that's a good idea. cpu_relax() allows the scheduler to switch 
over to a different task, but if none is active, it'll come back instead 
of going to sleep. Unless of course your event really kicks in very 
quickly - much faster than 1ms. But depending on your architecture 
implementation, msleep(1) might also be implemented as a busy look, then 
cpu_relax() would be better.

Thanks
Guennadi

> 
> Best Regards,
> Josh Wu
> 
> >
> > Thanks
> > Guennadi
> >
> >>
> >> Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
> >> ---
> >>
> >>  drivers/media/platform/soc_camera/atmel-isi.c | 59 ++++++---------------------
> >>  1 file changed, 13 insertions(+), 46 deletions(-)
> >>
> >> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> >> index f0508ea..4ddc309 100644
> >> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> >> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> >> @@ -12,7 +12,6 @@
> >>   */
> >>
> >>  #include <linux/clk.h>
> >> -#include <linux/completion.h>
> >>  #include <linux/delay.h>
> >>  #include <linux/fs.h>
> >>  #include <linux/init.h>
> >> @@ -81,7 +80,6 @@ struct atmel_isi {
> >>       struct isi_dma_desc             dma_desc[MAX_BUFFER_NUM];
> >>       bool                            enable_preview_path;
> >>
> >> -     struct completion               complete;
> >>       /* ISI peripherial clock */
> >>       struct clk                      *pclk;
> >>       unsigned int                    irq;
> >> @@ -281,51 +279,14 @@ static irqreturn_t isi_interrupt(int irq, void *dev_id)
> >>       mask = isi_readl(isi, ISI_INTMASK);
> >>       pending = status & mask;
> >>
> >> -     if (pending & ISI_CTRL_SRST) {
> >> -             complete(&isi->complete);
> >> -             isi_writel(isi, ISI_INTDIS, ISI_CTRL_SRST);
> >> -             ret = IRQ_HANDLED;
> >> -     } else if (pending & ISI_CTRL_DIS) {
> >> -             complete(&isi->complete);
> >> -             isi_writel(isi, ISI_INTDIS, ISI_CTRL_DIS);
> >> -             ret = IRQ_HANDLED;
> >> -     } else {
> >> -             if (likely(pending & ISI_SR_CXFR_DONE) ||
> >> -                             likely(pending & ISI_SR_PXFR_DONE))
> >> -                     ret = atmel_isi_handle_streaming(isi);
> >> -     }
> >> +     if (likely(pending & ISI_SR_CXFR_DONE) ||
> >> +         likely(pending & ISI_SR_PXFR_DONE))
> >> +             ret = atmel_isi_handle_streaming(isi);
> >>
> >>       spin_unlock(&isi->lock);
> >>       return ret;
> >>  }
> >>
> >> -#define      WAIT_ISI_RESET          1
> >> -#define      WAIT_ISI_DISABLE        0
> >> -static int atmel_isi_wait_status(struct atmel_isi *isi, int wait_reset)
> >> -{
> >> -     unsigned long timeout;
> >> -     /*
> >> -      * The reset or disable will only succeed if we have a
> >> -      * pixel clock from the camera.
> >> -      */
> >> -     init_completion(&isi->complete);
> >> -
> >> -     if (wait_reset) {
> >> -             isi_writel(isi, ISI_INTEN, ISI_CTRL_SRST);
> >> -             isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
> >> -     } else {
> >> -             isi_writel(isi, ISI_INTEN, ISI_CTRL_DIS);
> >> -             isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> >> -     }
> >> -
> >> -     timeout = wait_for_completion_timeout(&isi->complete,
> >> -                     msecs_to_jiffies(500));
> >> -     if (timeout == 0)
> >> -             return -ETIMEDOUT;
> >> -
> >> -     return 0;
> >> -}
> >> -
> >>  /* ------------------------------------------------------------------
> >>       Videobuf operations
> >>     ------------------------------------------------------------------*/
> >> @@ -493,8 +454,11 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
> >>       pm_runtime_get_sync(ici->v4l2_dev.dev);
> >>
> >>       /* Reset ISI */
> >> -     ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
> >> -     if (ret < 0) {
> >> +     isi_writel(isi, ISI_CTRL, ISI_CTRL_SRST);
> >> +
> >> +     /* Check Reset status */
> >> +     ret  = isi_hw_wait_status(isi, ISI_CTRL_SRST, 500);
> >> +     if (ret) {
> >>               dev_err(icd->parent, "Reset ISI timed out\n");
> >>               pm_runtime_put(ici->v4l2_dev.dev);
> >>               return ret;
> >> @@ -549,8 +513,11 @@ static void stop_streaming(struct vb2_queue *vq)
> >>                       ISI_SR_CXFR_DONE | ISI_SR_PXFR_DONE);
> >>
> >>       /* Disable ISI and wait for it is done */
> >> -     ret = atmel_isi_wait_status(isi, WAIT_ISI_DISABLE);
> >> -     if (ret < 0)
> >> +     isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
> >> +
> >> +     /* Check Reset status */
> >> +     ret  = isi_hw_wait_status(isi, ISI_CTRL_DIS, 500);
> >> +     if (ret)
> >>               dev_err(icd->parent, "Disable ISI timed out\n");
> >>
> >>       pm_runtime_put(ici->v4l2_dev.dev);
> >> --
> >> 1.9.1
> >>
> 
