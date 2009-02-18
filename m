Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57163 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752686AbZBRTLJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 14:11:09 -0500
Date: Wed, 18 Feb 2009 20:11:20 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] sh_mobile_ceu: Add field signal operation
In-Reply-To: <Pine.LNX.4.64.0902050846080.5553@axis700.grange>
Message-ID: <Pine.LNX.4.64.0902182010350.6371@axis700.grange>
References: <ubpthwd06.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0902050846080.5553@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'll hold off on both these SOCAM_FIELD_ID_* patches until we have 
clarified this, ok?

Thanks
Guennadi

On Thu, 5 Feb 2009, Guennadi Liakhovetski wrote:

> On Tue, 3 Feb 2009, Kuninori Morimoto wrote:
> 
> > sh_mobile_ceu can support "field signal" from external module.
> > To support this operation, SH_CEU_FLAG_USE_FLDID_{HIGH, LOW}
> > are added to header.
> 
> I never dealt with interlaced video, so, I probably just don't understand 
> something, please explain. I understand the Field ID signal is optional, 
> and, if used, it can be either active high or low. But who gets to decide 
> which polarity is applicable in a specific case? The platform? Is it not 
> like with other control signals, where if both partners are freely 
> configurable, then any polarity can be used; if one is configurable and 
> another is hard-wired, only one polarity can be used. And as long as the 
> signal is available (connected), the platform has no further influence on 
> its use? Ok, there can be an inverter there, but that we can handle too.
> 
> So, wouldn't something like
> 
> +	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_FLDID)
> +		flags |= SOCAM_FIELD_ID_ACTIVE_HIGH | SOCAM_FIELD_ID_ACTIVE_LOW;
> +
> 
> ...
> 
> +	if (common_flags & (SOCAM_FIELD_ID_ACTIVE_HIGH | SOCAM_FIELD_ID_ACTIVE_LOW) ==
> +	    SOCAM_FIELD_ID_ACTIVE_LOW)
> +		/* The client only supports active low field ID */
> +		value |= 1 << 16;
> +	/* Otherwise we are free to choose, leave default active high */
> 
> Or does Field ID work differently?
> 
> And what do you do, if the platform doesn't specify SH_CEU_FLAG_USE_FLDID, 
> i.e., it is not connected, but the client does? Or the other way round? In 
> other words, is it a working configuration, when one of the partners 
> provides this signal and the other one doesn't? I guess it is, because, 
> you say, it is optional. So we shouldn't test it in 
> soc_camera_bus_param_compatible()?
> 
> Thanks
> Guennadi
> 
> > 
> > Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> > ---
> > v1 -> v2
> > o field name fix
> > 
> >  drivers/media/video/sh_mobile_ceu_camera.c |    7 +++++++
> >  include/media/sh_mobile_ceu.h              |    2 ++
> >  2 files changed, 9 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> > index aa20745..1f746e1 100644
> > --- a/drivers/media/video/sh_mobile_ceu_camera.c
> > +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> > @@ -118,6 +118,12 @@ static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
> >  	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_16BIT_BUS)
> >  		flags |= SOCAM_DATAWIDTH_16;
> >  
> > +	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_FLDID_HIGH)
> > +		flags |= SOCAM_FIELD_ID_ACTIVE_HIGH;
> > +
> > +	if (pcdev->pdata->flags & SH_CEU_FLAG_USE_FLDID_LOW)
> > +		flags |= SOCAM_FIELD_ID_ACTIVE_LOW;
> > +
> >  	if (flags & SOCAM_DATAWIDTH_MASK)
> >  		return flags;
> >  
> > @@ -474,6 +480,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
> >  	    icd->current_fmt->fourcc == V4L2_PIX_FMT_NV61)
> >  		value ^= 0x00000100; /* swap U, V to change from NV1x->NVx1 */
> >  
> > +	value |= common_flags & SOCAM_FIELD_ID_ACTIVE_LOW ? 1 << 16 : 0;
> >  	value |= common_flags & SOCAM_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
> >  	value |= common_flags & SOCAM_HSYNC_ACTIVE_LOW ? 1 << 0 : 0;
> >  	value |= buswidth == 16 ? 1 << 12 : 0;
> > diff --git a/include/media/sh_mobile_ceu.h b/include/media/sh_mobile_ceu.h
> > index 0f3524c..8da9437 100644
> > --- a/include/media/sh_mobile_ceu.h
> > +++ b/include/media/sh_mobile_ceu.h
> > @@ -3,6 +3,8 @@
> >  
> >  #define SH_CEU_FLAG_USE_8BIT_BUS	(1 << 0) /* use  8bit bus width */
> >  #define SH_CEU_FLAG_USE_16BIT_BUS	(1 << 1) /* use 16bit bus width */
> > +#define SH_CEU_FLAG_USE_FLDID_HIGH	(1 << 2) /* top field if FLD is high */
> > +#define SH_CEU_FLAG_USE_FLDID_LOW	(1 << 3) /* top field if FLD is low */
> >  
> >  struct sh_mobile_ceu_info {
> >  	unsigned long flags;
> > -- 
> > 1.5.6.3
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
