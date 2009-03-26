Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZCZUJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 16:09:24 -0400
Date: Thu, 26 Mar 2009 17:09:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Darius Augulis <augulis.darius@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
Message-ID: <20090326170910.6926d8de@pedra.chehab.org>
In-Reply-To: <49CBD53C.6060700@gmail.com>
References: <49C89F00.1020402@gmail.com>
	<Pine.LNX.4.64.0903261405520.5438@axis700.grange>
	<49CBD53C.6060700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Darius,

On Thu, 26 Mar 2009 21:19:24 +0200
Darius Augulis <augulis.darius@gmail.com> wrote:

> Guennadi Liakhovetski wrote:
> > Sascha,
> >
> > would you prefer me to pull this via soc-camera or you'd prefer to handle 
> > it in your mxc tree? I think it's better to pull it via v4l, so, I'd need 
> > your acks for platform parts, especially for the assembly, ksyms and FIQ 
> > code.
> >
> > Hi Darius,
> >   
> Hi Guennadi, Sascha,
> 
> > On Tue, 24 Mar 2009, Darius wrote:
> >
> > Please, send your patches inline next time. Also, as noticed inline, 
> > you'll have to rebase this onto a current v4l stack, e.g., linux-next.
> >   
> 
> ok, I just started to use stgit now.

Please always base your patches against the last v4l-dvb tree or linux-next.
This is specially important those days, where v4l core is suffering several
changes.
> 
> > From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> >
> > Driver for i.MX1/L camera (CSI) host.
> >
> > Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> >
> > You are forwarding his patch, so, you have to sign-off under it. Why isn't 
> > he submitting it himself?
> >   
> 
> clear. This is because we work together on two archs - MXC and Gemini.
> Paulius will maintain all our Gemini patches and I will take care about 
> MXC, also old patches from Paulius.
> I will need some time to study this CSI and driver code, then I could 
> fix your comments.
> Thank you for review and notes!

Still, it is better to send this via v4l-dvb patch, to avoid merge conflicts
and breakages due to API differences.
> >> +/* buffer for one video frame */
> >> +struct imx_buffer {
> >> +	/* common v4l buffer stuff -- must be first */
> >> +	struct videobuf_buffer vb;
> >>     
> >
> > Here you have one space
> >
> >   
> >> +
> >> +	const struct soc_camera_data_format        *fmt;
> >>     
> >
> > Here you have 8 spaces
> >
> >   
> >> +
> >> +	int			inwork;
> >>     
> >
> > Here you have tabs. Please, unify.

Please always check your patches with checkpatch.pl. This will point such issues.

> >> +static int imx_videobuf_prepare(struct videobuf_queue *vq,
> >> +		struct videobuf_buffer *vb, enum v4l2_field field)
> >> +{
> >> +	struct soc_camera_device *icd = vq->priv_data;
> >> +	struct imx_buffer *buf = container_of(vb, struct imx_buffer, vb);
> >> +	int ret;
> >> +
> >> +	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> >> +		vb, vb->baddr, vb->bsize);
> >> +
> >> +	/* Added list head initialization on alloc */
> >> +	WARN_ON(!list_empty(&vb->queue));

Hmm... why do you need such warning?

> >> +static void imx_videobuf_release(struct videobuf_queue *vq,
> >> +				 struct videobuf_buffer *vb)
> >> +{
> >> +	struct imx_buffer *buf = container_of(vb, struct imx_buffer, vb);
> >> +#ifdef DEBUG

I haven't seen where you are defining DEBUG. if those debug stuff are needed
only during development, it is better to remove it, to avoid polluting upstream
with useless code.

> >> +static void imx_camera_dma_irq(int channel, void *data)
> >> +{
> >> +	struct imx_camera_dev *pcdev = data;
> >> +	struct imx_buffer *buf;
> >> +	unsigned long flags;
> >> +	struct videobuf_buffer *vb;
> >> +
> >> +	spin_lock_irqsave(&pcdev->lock, flags);
> >> +
> >> +	imx_dma_disable(channel);
> >> +
> >> +	if (unlikely(!pcdev->active)) {
> >> +		dev_err(pcdev->dev, "DMA End IRQ with no active buffer\n");
> >> +		goto out;
> >> +	}
> >> +
> >> +	vb = &pcdev->active->vb;
> >> +	buf = container_of(vb, struct imx_buffer, vb);
> >> +	WARN_ON(buf->inwork || list_empty(&vb->queue));

Why do you need a warning here?

> >> + * Copyright (C) 2008, Darius Augulis <augulis.darius@gmail.com>
> >> + *
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published by
> >> + * the Free Software Foundation; either version 2 of the License, or
> >> + * (at your option) any later version.
> >>     
> >
> > Here >= 2 again

About the licensing, you can use both GPLv2 only or GPLv2 or later. It is
better to use the same for all drivers.

Cheers,
Mauro
