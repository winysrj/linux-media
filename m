Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:38349 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751286AbdBOOed (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 09:34:33 -0500
Date: Wed, 15 Feb 2017 08:34:30 -0600
From: Benoit Parrot <bparrot@ti.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [Patch 2/2] media: ti-vpe: vpe: allow use of user specified
 stride
Message-ID: <20170215143430.GA10737@ti.com>
References: <20170213130658.31907-1-bparrot@ti.com>
 <20170213130658.31907-3-bparrot@ti.com>
 <4f5aa907-59fe-0230-7108-ef292978fcde@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4f5aa907-59fe-0230-7108-ef292978fcde@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tomi Valkeinen <tomi.valkeinen@ti.com> wrote on Wed [2017-Feb-15 13:22:42 +0200]:
> Hi,
> 
> On 13/02/17 15:06, Benoit Parrot wrote:
> > Bytesperline/stride was always overwritten by VPE to the most
> > adequate value based on needed alignment.
> > 
> > However in order to make use of arbitrary size DMA buffer it
> > is better to use the user space provide stride instead.
> > 
> > The driver will still calculate an appropriate stride but will
> > use the provided one when it is larger than the calculated one.
> > 
> > Signed-off-by: Benoit Parrot <bparrot@ti.com>
> > ---
> >  drivers/media/platform/ti-vpe/vpe.c | 28 ++++++++++++++++++++--------
> >  1 file changed, 20 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> > index 2dd67232b3bc..c47151495b6f 100644
> > --- a/drivers/media/platform/ti-vpe/vpe.c
> > +++ b/drivers/media/platform/ti-vpe/vpe.c
> > @@ -1597,6 +1597,7 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
> >  	struct v4l2_plane_pix_format *plane_fmt;
> >  	unsigned int w_align;
> >  	int i, depth, depth_bytes, height;
> > +	unsigned int stride = 0;
> >  
> >  	if (!fmt || !(fmt->types & type)) {
> >  		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
> > @@ -1683,16 +1684,27 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
> >  		plane_fmt = &pix->plane_fmt[i];
> >  		depth = fmt->vpdma_fmt[i]->depth;
> >  
> > -		if (i == VPE_LUMA)
> > -			plane_fmt->bytesperline = (pix->width * depth) >> 3;
> > -		else
> > -			plane_fmt->bytesperline = pix->width;
> > +		stride = (pix->width * fmt->vpdma_fmt[VPE_LUMA]->depth) >> 3;
> > +		if (stride > plane_fmt->bytesperline)
> > +			plane_fmt->bytesperline = stride;
> 
> The old code calculates different bytes per line for luma and chroma,
> but the new one calculates only for luma. Is that correct?

The previous method which happened to produce the correct value was
not proper as the spec for NV12/NV16 states that the chroma bytes per
line/stride should be the same as the LUMA stride only the number of
lines might differ which affect how the sizeimage component is
calculated. This patch takes that into account.

Benoit

> 
>  Tomi
> 
