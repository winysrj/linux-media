Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:63159 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbbJSBsU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Oct 2015 21:48:20 -0400
Date: Mon, 19 Oct 2015 03:48:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/5] media: atmel-isi: correct yuv swap according to
 different sensor outputs
In-Reply-To: <561DF979.9050501@atmel.com>
Message-ID: <Pine.LNX.4.64.1510190212340.26684@axis700.grange>
References: <1442898875-7147-1-git-send-email-josh.wu@atmel.com>
 <1442898875-7147-2-git-send-email-josh.wu@atmel.com>
 <Pine.LNX.4.64.1510041751480.26834@axis700.grange> <561DF979.9050501@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Wed, 14 Oct 2015, Josh Wu wrote:

> Hi, Dear Guennadi
> 
> Thanks for the review.
> 
> On 10/5/2015 12:43 AM, Guennadi Liakhovetski wrote:
> > Hi Josh,
> > 
> > On Tue, 22 Sep 2015, Josh Wu wrote:
> > 
> > > we need to configure the YCC_SWAP bits in ISI_CFG2 according to current
> > > sensor output and Atmel ISI output format.
> > > 
> > > Current there are two cases Atmel ISI supported:
> > >    1. Atmel ISI outputs YUYV format.
> > >       This case we need to setup YCC_SWAP according to sensor output
> > >       format.
> > >    2. Atmel ISI output a pass-through formats, which means no swap.
> > >       Just setup YCC_SWAP as default with no swap.
> > > 
> > > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > > ---
> > > 
> > >   drivers/media/platform/soc_camera/atmel-isi.c | 43
> > > ++++++++++++++++++++-------
> > >   1 file changed, 33 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> > > b/drivers/media/platform/soc_camera/atmel-isi.c
> > > index 45e304a..df64294 100644
> > > --- a/drivers/media/platform/soc_camera/atmel-isi.c
> > > +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> > > @@ -103,13 +103,41 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
> > >   	return readl(isi->regs + reg);
> > >   }
> > >   +static u32 setup_cfg2_yuv_swap(struct atmel_isi *isi,
> > > +		const struct soc_camera_format_xlate *xlate)
> > > +{
> > This function will be called only for the four media codes from the
> > switch-case statement below, namely for
> > 
> > MEDIA_BUS_FMT_VYUY8_2X8
> > MEDIA_BUS_FMT_UYVY8_2X8
> > MEDIA_BUS_FMT_YVYU8_2X8
> > MEDIA_BUS_FMT_YUYV8_2X8
> > 
> > > +	/* By default, no swap for the codec path of Atmel ISI. So codec
> > > +	* output is same as sensor's output.
> > > +	* For instance, if sensor's output is YUYV, then codec outputs YUYV.
> > > +	* And if sensor's output is UYVY, then codec outputs UYVY.
> > > +	*/
> > > +	u32 cfg2_yuv_swap = ISI_CFG2_YCC_SWAP_DEFAULT;
> > Then this ISI_CFG2_YCC_SWAP_DEFAULT will only hold for
> > MEDIA_BUS_FMT_YUYV8_2X8? Why don't you just add one more case below? Don't
> > think this initialisation is really justified.
> This default initial value is for all host_fmt_fourcc case. Not just for
> V4L2_PIX_FMT_YUYV this case.

Right, yes, missed this. How about this then:

	if (xlate->host_fmt->fourcc != V4L2_PIX_FMT_YUYV)
		return ISI_CFG2_YCC_SWAP_DEFAULT;

	switch (xlate->code) {
	case MEDIA_BUS_FMT_VYUY8_2X8:
		return ISI_CFG2_YCC_SWAP_MODE_3;
	case MEDIA_BUS_FMT_UYVY8_2X8:
		return ISI_CFG2_YCC_SWAP_MODE_2;
	case MEDIA_BUS_FMT_YVYU8_2X8:
		return ISI_CFG2_YCC_SWAP_MODE_1;
	}

	return ISI_CFG2_YCC_SWAP_DEFAULT;

Or even exactly as you have it in your patch only remove the cfg2_yuv_swap 
variable and do "return" directly after each "case MEDIA_..." and one more 
with SWAP_DEFAULT in the end.

> > > +
> > > +	if (xlate->host_fmt->fourcc == V4L2_PIX_FMT_YUYV) {
> > > +		/* all convert to YUYV */
> > > +		switch (xlate->code) {
> > > +		case MEDIA_BUS_FMT_VYUY8_2X8:
> > > +			cfg2_yuv_swap = ISI_CFG2_YCC_SWAP_MODE_3;
> > > +			break;
> > > +		case MEDIA_BUS_FMT_UYVY8_2X8:
> > > +			cfg2_yuv_swap = ISI_CFG2_YCC_SWAP_MODE_2;
> > > +			break;
> > > +		case MEDIA_BUS_FMT_YVYU8_2X8:
> > > +			cfg2_yuv_swap = ISI_CFG2_YCC_SWAP_MODE_1;
> > > +			break;
> > > +		}
> > > +	}
> > > +
> > > +	return cfg2_yuv_swap;
> > > +}
> > > +
> > >   static void configure_geometry(struct atmel_isi *isi, u32 width,
> > > -			u32 height, u32 code)
> > > +		u32 height, const struct soc_camera_format_xlate *xlate)
> > >   {
> > >   	u32 cfg2;
> > >     	/* According to sensor's output format to set cfg2 */
> > > -	switch (code) {
> > > +	switch (xlate->code) {
> > >   	default:
> > >   	/* Grey */
> > >   	case MEDIA_BUS_FMT_Y8_1X8:
> > > @@ -117,16 +145,11 @@ static void configure_geometry(struct atmel_isi
> > > *isi, u32 width,
> > >   		break;
> > >   	/* YUV */
> > >   	case MEDIA_BUS_FMT_VYUY8_2X8:
> > > -		cfg2 = ISI_CFG2_YCC_SWAP_MODE_3 | ISI_CFG2_COL_SPACE_YCbCr;
> > > -		break;
> > >   	case MEDIA_BUS_FMT_UYVY8_2X8:
> > > -		cfg2 = ISI_CFG2_YCC_SWAP_MODE_2 | ISI_CFG2_COL_SPACE_YCbCr;
> > > -		break;
> > >   	case MEDIA_BUS_FMT_YVYU8_2X8:
> > > -		cfg2 = ISI_CFG2_YCC_SWAP_MODE_1 | ISI_CFG2_COL_SPACE_YCbCr;
> > > -		break;
> > >   	case MEDIA_BUS_FMT_YUYV8_2X8:
> > > -		cfg2 = ISI_CFG2_YCC_SWAP_DEFAULT | ISI_CFG2_COL_SPACE_YCbCr;
> > > +		cfg2 = ISI_CFG2_COL_SPACE_YCbCr |
> > > +				setup_cfg2_yuv_swap(isi, xlate);
> > >   		break;
> > >   	/* RGB, TODO */
> > >   	}
> > I would move this switch-case completely inside setup_cfg2_yuv_swap().
> > Just do
> > 
> > 	cfg2 = setup_cfg2_yuv_swap(isi, xlate);
> > 
> > and handle the
> > 
> >   	case MEDIA_BUS_FMT_Y8_1X8:
> > 
> > in the function too. These two switch-case statements really look
> > redundant.
> Technically, you can do that. But for my point of view, the
> setup_cfg2_yuv_swap() only need to setup the yuv swap register field.
> 
> And other cfg2 field need to be configured as well, especially in the case
> sensor output a RGB data. That should be implement soon.

Understand. I don't like redundant code and this certainly looks redundant 
to me. I'd be glad if you could remove this redundancy, but if you feel 
strongly about it, feel free to keep as is.

Thanks
Guennadi

> > > @@ -407,7 +430,7 @@ static int start_streaming(struct vb2_queue *vq,
> > > unsigned int count)
> > >   	isi_writel(isi, ISI_INTDIS, (u32)~0UL);
> > >     	configure_geometry(isi, icd->user_width, icd->user_height,
> > > -				icd->current_fmt->code);
> > > +				icd->current_fmt);
> > >     	spin_lock_irq(&isi->lock);
> > >   	/* Clear any pending interrupt */
> > > -- 
> > > 1.9.1
> > > 
> > Thanks
> > Guennadi
> 
> Best Regards,
> Josh Wu
> 
