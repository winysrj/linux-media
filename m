Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:59882 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752087Ab0IWNdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 09:33:42 -0400
Date: Thu, 23 Sep 2010 15:33:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [PATCH v2 1/6] SoC Camera: add driver for OMAP1 camera interface
In-Reply-To: <201009222013.58035.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1009231514000.23561@axis700.grange>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009110321.25852.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1009211639410.11896@axis700.grange>
 <201009222013.58035.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 22 Sep 2010, Janusz Krzysztofik wrote:

> Wednesday 22 September 2010 01:23:22 Guennadi Liakhovetski napisał(a):
> > On Sat, 11 Sep 2010, Janusz Krzysztofik wrote:
> > > +
> > > +	vb = &buf->vb;
> > > +	if (waitqueue_active(&vb->done)) {
> > > +		if (!pcdev->ready && result != VIDEOBUF_ERROR)
> > > +			/*
> > > +			 * No next buffer has been entered into the DMA
> > > +			 * programming register set on time, so best we can do
> > > +			 * is stopping the capture before last DMA block,
> > > +			 * whether our CONTIG mode whole buffer or its last
> > > +			 * sgbuf in SG mode, gets overwritten by next frame.
> > > +			 */
> >
> > Hm, why do you think it's a good idea? This specific buffer completed
> > successfully, but you want to fail it just because the next buffer is
> > missing? Any specific reason for this? 
> 
> Maybe my comment is not clear enough, but the below suspend_capture() doesn't 
> indicate any failure on a frame just captured. It only prevents the frame 
> from being overwritten by the already autoreinitialized DMA engine, pointing 
> back to the same buffer once again.
> 
> > Besides, you seem to also be 
> > considering the possibility of your ->ready == NULL, but the queue
> > non-empty, in which case you just take the next buffer from the queue and
> > continue with it. Why error out in this case? 
> 
> pcdev->ready == NULL means no buffer was available when it was time to put it 
> into the DMA programming register set.

But how? Buffers are added onto the list in omap1_videobuf_queue() under 
spin_lock_irqsave(); and there you also check ->ready and fill it in. In 
your completion you set ->ready = NULL, but then also call 
prepare_next_vb() to get the next buffer from the list - if there are any, 
so, how can it be NULL with a non-empty list?

> As a result, a next DMA transfer has 
> just been autoreinitialized with the same buffer parameters as before. To 
> protect the buffer from being overwriten unintentionally, we have to stop the 
> DMA transfer as soon as possible, hopefully before the sensor starts sending 
> out next frame data.
> 
> If a new buffer has been queued meanwhile, best we can do is stopping 
> everything, programming the DMA with the new buffer, and setting up for a new 
> transfer hardware auto startup on nearest frame start, be it the next one if 
> we are lucky enough, or one after the next if we are too slow.
> 
> > And even if also the queue 
> > is empty - still not sure, why.
> 
> I hope the above explanation clarifies why.
> 
> I'll try to rework the above comment to be more clear, OK? Any hints?

> > > linux-2.6.36-rc3.orig/include/media/omap1_camera.h	2010-09-03
> > > 22:34:02.000000000 +0200 +++
> > > linux-2.6.36-rc3/include/media/omap1_camera.h	2010-09-08
> > > 23:41:12.000000000 +0200 @@ -0,0 +1,35 @@
> > > +/*
> > > + * Header for V4L2 SoC Camera driver for OMAP1 Camera Interface
> > > + *
> > > + * Copyright (C) 2010, Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + */
> > > +
> > > +#ifndef __MEDIA_OMAP1_CAMERA_H_
> > > +#define __MEDIA_OMAP1_CAMERA_H_
> > > +
> > > +#include <linux/bitops.h>
> > > +
> > > +#define OMAP1_CAMERA_IOSIZE		0x1c
> > > +
> > > +enum omap1_cam_vb_mode {
> > > +	CONTIG = 0,
> > > +	SG,
> > > +};
> >
> > See above - are these needed here?
> >
> > > +
> > > +#define OMAP1_CAMERA_MIN_BUF_COUNT(x)	((x) == CONTIG ? 3 : 2)
> >
> > ditto
> 
> I moved them both over to the header file because I was using the 
> OMAP1_CAMERA_MIN_BUF_COUNT(CONTIG) macro once from the platform code in order 
> to calculate the buffer size when calling the then NAKed 
> dma_preallocate_coherent_memory(). Now I could put them back into the driver 
> code, but if we ever get back to the concept of preallocating a contignuos 
> piece of memory from the platform init code, we might need them back here, so 
> maybe I should rather keep them, only rename the two enum values using a 
> distinct name space. What do you think is better for now?

Yeah, up to you, I'd say, but if you decide to keep them in the header, 
please, use a namespace.

I'm satisfied with your answers to the rest of my questions / comments:)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
