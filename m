Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:51466 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab0IWOwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 10:52:14 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2 1/6] SoC Camera: add driver for OMAP1 camera interface
Date: Thu, 23 Sep 2010 16:51:35 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl> <201009222013.58035.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1009231514000.23561@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1009231514000.23561@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201009231651.36589.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thursday 23 September 2010 15:33:54 Guennadi Liakhovetski napisał(a):
> On Wed, 22 Sep 2010, Janusz Krzysztofik wrote:
> > Wednesday 22 September 2010 01:23:22 Guennadi Liakhovetski napisał(a):
> > > On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:
> > > > +
> > > > +	vb = &buf->vb;
> > > > +	if (waitqueue_active(&vb->done)) {
> > > > +		if (!pcdev->ready && result != VIDEOBUF_ERROR)
> > > > +			/*
> > > > +			 * No next buffer has been entered into the DMA
> > > > +			 * programming register set on time, so best we can do
> > > > +			 * is stopping the capture before last DMA block,
> > > > +			 * whether our CONTIG mode whole buffer or its last
> > > > +			 * sgbuf in SG mode, gets overwritten by next frame.
> > > > +			 */
> > >
> > > Hm, why do you think it's a good idea? This specific buffer completed
> > > successfully, but you want to fail it just because the next buffer is
> > > missing? Any specific reason for this?
> >
> > Maybe my comment is not clear enough, but the below suspend_capture()
> > doesn't indicate any failure on a frame just captured. It only prevents
> > the frame from being overwritten by the already autoreinitialized DMA
> > engine, pointing back to the same buffer once again.
> >
> > > Besides, you seem to also be
> > > considering the possibility of your ->ready == NULL, but the queue
> > > non-empty, in which case you just take the next buffer from the queue
> > > and continue with it. Why error out in this case?
> >
> > pcdev->ready == NULL means no buffer was available when it was time to
> > put it into the DMA programming register set.
>
> But how? Buffers are added onto the list in omap1_videobuf_queue() under
> spin_lock_irqsave(); and there you also check ->ready and fill it in. 

Guennadi,
Yes, but only if pcdev->active is NULL, ie. both DMA and FIFO are idle, never 
if active:

+	list_add_tail(&vb->queue, &pcdev->capture);
+	vb->state = VIDEOBUF_QUEUED;
+
+	if (pcdev->active)
+		return;

Since the transfer of the DMA programming register set content to the DMA 
working register set is done automatically by the DMA hardware, this can 
pretty well happen while I keep the lock here, so I can't be sure if it's not 
too late for entering new data into the programming register set. Then, I 
decided that this operation should be done only just after the DMA interrupt 
occured, ie. the current DMA programming register set content has just been 
used and can be overwriten.

I'll emphasize the above return; with a comment.

> In 
> your completion you set ->ready = NULL, but then also call
> prepare_next_vb() to get the next buffer from the list - if there are any,
> so, how can it be NULL with a non-empty list?

It happens after the above mentioned prepare_next_vb() gets nothing from an 
empty queue, so nothing is entered into the DMA programming register set, 
only the last, just activated, buffer is processed, then 
omap1_videobuf_queue() puts a new buffer into the queue while the active 
buffer is still filled in, and finally the DMA ISR is called on this last 
active buffer completion.

I hope this helps.

> > As a result, a next DMA transfer has
> > just been autoreinitialized with the same buffer parameters as before. To
> > protect the buffer from being overwriten unintentionally, we have to stop
> > the DMA transfer as soon as possible, hopefully before the sensor starts
> > sending out next frame data.
> >
> > If a new buffer has been queued meanwhile, best we can do is stopping
> > everything, programming the DMA with the new buffer, and setting up for a
> > new transfer hardware auto startup on nearest frame start, be it the next
> > one if we are lucky enough, or one after the next if we are too slow.
> >
> > > And even if also the queue
> > > is empty - still not sure, why.
> >
> > I hope the above explanation clarifies why.
> >
> > I'll try to rework the above comment to be more clear, OK? Any hints?
> >
> > > > linux-2.6.36-rc3.orig/include/media/omap1_camera.h	2010-09-03
> > > > 22:34:02.000000000 +0200 +++
> > > > linux-2.6.36-rc3/include/media/omap1_camera.h	2010-09-08
> > > > 23:41:12.000000000 +0200 @@ -0,0 +1,35 @@
> > > > +/*
> > > > + * Header for V4L2 SoC Camera driver for OMAP1 Camera Interface
> > > > + *
> > > > + * Copyright (C) 2010, Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > > > + *
> > > > + * This program is free software; you can redistribute it and/or
> > > > modify + * it under the terms of the GNU General Public License
> > > > version 2 as + * published by the Free Software Foundation.
> > > > + */
> > > > +
> > > > +#ifndef __MEDIA_OMAP1_CAMERA_H_
> > > > +#define __MEDIA_OMAP1_CAMERA_H_
> > > > +
> > > > +#include <linux/bitops.h>
> > > > +
> > > > +#define OMAP1_CAMERA_IOSIZE		0x1c
> > > > +
> > > > +enum omap1_cam_vb_mode {
> > > > +	CONTIG = 0,
> > > > +	SG,
> > > > +};
> > >
> > > See above - are these needed here?
> > >
> > > > +
> > > > +#define OMAP1_CAMERA_MIN_BUF_COUNT(x)	((x) == CONTIG ? 3 : 2)
> > >
> > > ditto
> >
> > I moved them both over to the header file because I was using the
> > OMAP1_CAMERA_MIN_BUF_COUNT(CONTIG) macro once from the platform code in
> > order to calculate the buffer size when calling the then NAKed
> > dma_preallocate_coherent_memory(). Now I could put them back into the
> > driver code, but if we ever get back to the concept of preallocating a
> > contignuos piece of memory from the platform init code, we might need
> > them back here, so maybe I should rather keep them, only rename the two
> > enum values using a distinct name space. What do you think is better for
> > now?
>
> Yeah, up to you, I'd say, but if you decide to keep them in the header,
> please, use a namespace.

OK, I'll use a namespace then.

> I'm satisfied with your answers to the rest of my questions / comments:)

Glad to hear :)

Thanks,
Janusz

> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


