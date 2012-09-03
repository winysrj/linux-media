Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57390 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab2ICQjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 12:39:40 -0400
Subject: Re: [PATCH v3 07/16] media: coda: stop all queues in case of lockup
From: Philipp Zabel <p.zabel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
In-Reply-To: <CACKLOr1brydhZsZFiY=rBs9SzG9mcKwOViy+uZy-4ka6R51VPw@mail.gmail.com>
References: <1346400670-16002-1-git-send-email-p.zabel@pengutronix.de>
	 <1346400670-16002-8-git-send-email-p.zabel@pengutronix.de>
	 <CACKLOr1brydhZsZFiY=rBs9SzG9mcKwOViy+uZy-4ka6R51VPw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Sep 2012 18:39:36 +0200
Message-ID: <1346690376.2391.50.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Am Montag, den 03.09.2012, 14:18 +0200 schrieb javier Martin:
> On 31 August 2012 10:11, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Add a 1 second timeout for each PIC_RUN command to the CODA. In
> > case it locks up, stop all queues and dequeue remaining buffers.
> >
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > Changes since v2:
> >  - Call cancel_delayed_work in coda_stop_streaming instead of coda_irq_handler.
> > ---
> >  drivers/media/platform/coda.c |   21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> >
> > diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> > index 7bc2d87..6e3f026 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
> > @@ -137,6 +137,7 @@ struct coda_dev {
> >         struct vb2_alloc_ctx    *alloc_ctx;
> >         struct list_head        instances;
> >         unsigned long           instance_mask;
> > +       struct delayed_work     timeout;
> >  };
> >
> >  struct coda_params {
> > @@ -723,6 +724,9 @@ static void coda_device_run(void *m2m_priv)
> >                                 CODA7_REG_BIT_AXI_SRAM_USE);
> >         }
> >
> > +       /* 1 second timeout in case CODA locks up */
> > +       schedule_delayed_work(&dev->timeout, HZ);
> > +
> >         coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
> >  }
> >
> > @@ -1221,6 +1225,8 @@ static int coda_stop_streaming(struct vb2_queue *q)
> >         }
> >
> >         if (!ctx->rawstreamon && !ctx->compstreamon) {
> > +               cancel_delayed_work(&dev->timeout);
> > +
> 
> Since 'schedule_delayed_work()' is called for each frame and
> 'cancel_delayed_work()' is called only when stopping the streaming,
> the timeout will always trigger after 1 second.
> I can confirm this due some tests where I always get this message
> after one second:  coda coda-imx27.0: CODA PIC_RUN timeout, stopping
> all streams

Yes, removing the __cancel_delayed_work in coda_irq_handler was a
mistake.

> Please find some of my doubts below:
> 
> Do we really need this patch? Couldn't you just use
> 'coda_command_sync()' for CODA_COMMAND_PIC_RUN? Why did you changed
> 'cancel_delayed_work()' from the IRQ to stop streaming? I think the
> former was correct, wasn't it?

Ideally, the CODA shouldn't hang. I've seen it happen, though - whether
because of firmware or driver bugs I couldn't say.

Using coda_command_sync would mean spinning in coda_wait_timeout all the
time. I guess we could put device_run to sleep with
wait_for_completion_interruptible_timeout and just complete the
completion in the irq handler.

regards
Philipp

