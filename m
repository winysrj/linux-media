Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58493 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762247AbZDBRyE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2009 13:54:04 -0400
Date: Thu, 2 Apr 2009 19:54:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Darius Augulis <augulis.darius@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	paulius.zaleckas@teltonika.lt,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [RFC PATCH V2] Add camera (CSI) driver for MX1
In-Reply-To: <49D4FAF0.9060305@gmail.com>
Message-ID: <Pine.LNX.4.64.0904021952220.5263@axis700.grange>
References: <20090330145310.20826.77060.stgit@localhost.localdomain>
 <Pine.LNX.4.64.0904010034300.12031@axis700.grange> <49D4FAF0.9060305@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2 Apr 2009, Darius Augulis wrote:

> 
> > > + * struct mx1_camera_pdata - i.MX1/i.MXL camera platform data
> > > + * @init:	Init board resources
> > > + * @exit:	Release board resources
> > > + * @mclk_10khz:	master clock frequency in 10kHz units
> > > + * @flags:	MX1 camera platform flags
> > > + */
> > > +struct mx1_camera_pdata {
> > > +	int (*init)(struct device *);
> > > +	int (*exit)(struct device *);
> > >     
> > 
> > I thought the agreement was to avoid these .init() and .exit() hooks in new
> > code...
> >   
> 
> Should I config board statically during system start-up?

Unless you have some special requirements why you want to do this 
dynamically - yes.

> 
> 
> > > +static void mx1_videobuf_queue(struct videobuf_queue *vq,
> > > +						struct videobuf_buffer *vb)
> > > +{
> > > +	struct soc_camera_device *icd = vq->priv_data;
> > > +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > > +	struct mx1_camera_dev *pcdev = ici->priv;
> > > +	struct mx1_buffer *buf = container_of(vb, struct mx1_buffer, vb);
> > > +
> > > +	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> > > +		vb, vb->baddr, vb->bsize);
> > > +
> > > +	list_add_tail(&vb->queue, &pcdev->capture);
> > >     
> > 
> > No, you had a spinlock here and in DMA ISR in the previous version, and it
> > was correct. Without that lock the above list_add races with list_del_init()
> > in mx1_camera_wakeup().
> >   
> 
> what can save and help for the spinlock on single-core system? mx3 there does
> not have spinlock.

The IRQ can interrupt you while you're manipulating the list in 
mx1_videobuf_queue(), and corrupt the list. This is not just a spinlock, 
it also disables interrupts. Also, think about preemptible kernels.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
