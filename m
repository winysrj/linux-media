Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41635 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab3GZNWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 09:22:48 -0400
Message-ID: <1374844932.4013.25.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 1/8] [media] coda: use vb2_set_plane_payload instead
 of setting v4l2_planes[0].bytesused directly
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?ISO-8859-1?Q?Ga=EBtan?= Carlier <gcembed@gmail.com>,
	Wei Yongjun <weiyj.lk@gmail.com>
Date: Fri, 26 Jul 2013 15:22:12 +0200
In-Reply-To: <20130726100239.3fa8dee3@samsung.com>
References: <1371801334-22324-1-git-send-email-p.zabel@pengutronix.de>
	 <1371801334-22324-2-git-send-email-p.zabel@pengutronix.de>
	 <20130726100239.3fa8dee3@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am Freitag, den 26.07.2013, 10:02 -0300 schrieb Mauro Carvalho Chehab:
> Hi Philipp,
> 
> Em Fri, 21 Jun 2013 09:55:27 +0200
> Philipp Zabel <p.zabel@pengutronix.de> escreveu:
> 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Please provide a description of the patch.

Sorry, how about this:

"As stated in the vb2_buffer documentation, drivers should not directly fill
 in v4l2_planes[0].bytesused, but should use vb2_set_plane_payload()
 function instead. No functional changes."

regards
Philipp

> Thanks!
> Mauro
> 
> > ---
> >  drivers/media/platform/coda.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> > index c4566c4..90f3386 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
> > @@ -1662,12 +1662,12 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
> >  	wr_ptr = coda_read(dev, CODA_REG_BIT_WR_PTR(ctx->idx));
> >  	/* Calculate bytesused field */
> >  	if (dst_buf->v4l2_buf.sequence == 0) {
> > -		dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr) +
> > -						ctx->vpu_header_size[0] +
> > -						ctx->vpu_header_size[1] +
> > -						ctx->vpu_header_size[2];
> > +		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr +
> > +					ctx->vpu_header_size[0] +
> > +					ctx->vpu_header_size[1] +
> > +					ctx->vpu_header_size[2]);
> >  	} else {
> > -		dst_buf->v4l2_planes[0].bytesused = (wr_ptr - start_ptr);
> > +		vb2_set_plane_payload(dst_buf, 0, wr_ptr - start_ptr);
> >  	}
> >  
> >  	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n",
> 
> 


