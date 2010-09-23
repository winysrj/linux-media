Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:36447 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754394Ab0IWQKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 12:10:34 -0400
Date: Thu, 23 Sep 2010 18:10:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 1/6] SoC Camera: add driver for OMAP1 camera interface
In-Reply-To: <201009231651.36589.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1009231806190.23561@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009222013.58035.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1009231514000.23561@axis700.grange>
 <201009231651.36589.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 23 Sep 2010, Janusz Krzysztofik wrote:

> Thursday 23 September 2010 15:33:54 Guennadi Liakhovetski napisał(a):
> > On Wed, 22 Sep 2010, Janusz Krzysztofik wrote:
> > > Wednesday 22 September 2010 01:23:22 Guennadi Liakhovetski napisał(a):
> > > > On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:
> > > > > +
> > > > > +	vb = &buf->vb;
> > > > > +	if (waitqueue_active(&vb->done)) {
> > > > > +		if (!pcdev->ready && result != VIDEOBUF_ERROR)
> > > > > +			/*
> > > > > +			 * No next buffer has been entered into the DMA
> > > > > +			 * programming register set on time, so best we can do
> > > > > +			 * is stopping the capture before last DMA block,
> > > > > +			 * whether our CONTIG mode whole buffer or its last
> > > > > +			 * sgbuf in SG mode, gets overwritten by next frame.
> > > > > +			 */
> > > >
> > > > Hm, why do you think it's a good idea? This specific buffer completed
> > > > successfully, but you want to fail it just because the next buffer is
> > > > missing? Any specific reason for this?
> > >
> > > Maybe my comment is not clear enough, but the below suspend_capture()
> > > doesn't indicate any failure on a frame just captured. It only prevents
> > > the frame from being overwritten by the already autoreinitialized DMA
> > > engine, pointing back to the same buffer once again.
> > >
> > > > Besides, you seem to also be
> > > > considering the possibility of your ->ready == NULL, but the queue
> > > > non-empty, in which case you just take the next buffer from the queue
> > > > and continue with it. Why error out in this case?
> > >
> > > pcdev->ready == NULL means no buffer was available when it was time to
> > > put it into the DMA programming register set.
> >
> > But how? Buffers are added onto the list in omap1_videobuf_queue() under
> > spin_lock_irqsave(); and there you also check ->ready and fill it in. 
> 
> Guennadi,
> Yes, but only if pcdev->active is NULL, ie. both DMA and FIFO are idle, never 
> if active:
> 
> +	list_add_tail(&vb->queue, &pcdev->capture);
> +	vb->state = VIDEOBUF_QUEUED;
> +
> +	if (pcdev->active)
> +		return;
> 
> Since the transfer of the DMA programming register set content to the DMA 
> working register set is done automatically by the DMA hardware, this can 
> pretty well happen while I keep the lock here, so I can't be sure if it's not 
> too late for entering new data into the programming register set. Then, I 
> decided that this operation should be done only just after the DMA interrupt 
> occured, ie. the current DMA programming register set content has just been 
> used and can be overwriten.
> 
> I'll emphasize the above return; with a comment.

Ok

> > In 
> > your completion you set ->ready = NULL, but then also call
> > prepare_next_vb() to get the next buffer from the list - if there are any,
> > so, how can it be NULL with a non-empty list?
> 
> It happens after the above mentioned prepare_next_vb() gets nothing from an 
> empty queue, so nothing is entered into the DMA programming register set, 
> only the last, just activated, buffer is processed, then 
> omap1_videobuf_queue() puts a new buffer into the queue while the active 
> buffer is still filled in, and finally the DMA ISR is called on this last 
> active buffer completion.
> 
> I hope this helps.

Let's assume it does:) You seem to really understand how this is working 
and even be willing to document the driver, thus making it possibly the 
best documented soc-camera related piece of software;)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
