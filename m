Return-path: <mchehab@pedra>
Received: from mail.rapiddevelopmentkit.de ([217.6.246.34]:34258 "EHLO
	root.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab1DGMiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 08:38:04 -0400
Subject: Re: [PATCH 1/2] mt9v022: fix pixel clock
From: Teresa Gamez <T.Gamez@phytec.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1104071303001.26842@axis700.grange>
References: <1302098515-12176-1-git-send-email-t.gamez@phytec.de>
	 <Pine.LNX.4.64.1104071303001.26842@axis700.grange>
Date: Thu, 07 Apr 2011 14:38:06 +0200
Message-ID: <1302179886.5045.5.camel@lws-gamez>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Guennadi,

Sorry for the first mail...

The datasheet also says (see table 3):

<quote>
Pixel clock out. DOUT is valid on rising edge of this
clock.
</quote>

There is a difference between DOUT beeing vaild and DOUT beeing set up.
So does SOCAM_PCLK_SAMPLE_RISING mean that the data is valid at rising
edge or does it mean the data is set up at rising edge? 

I have tested this with a pcm038 but I will also make meassurements with
the pcm037.

Teresa

Am Donnerstag, den 07.04.2011, 13:08 +0200 schrieb Guennadi
Liakhovetski:
> On Wed, 6 Apr 2011, Teresa Gámez wrote:
> 
> > Measurements show that the setup of the pixel clock is not correct.
> > The 'Invert Pixel Clock' bit has to be set to 1 for falling edge
> > and not for rising.
> 
> Doesn't seem correct to me. The mt9v022 datasheet says:
> 
> <quote>
> Invert pixel clock. When set, LINE_VALID,
> FRAME_VALID, and DOUT is set up to the rising edge
> of pixel clock, PIXCLK. When clear, they are set up to
> the falling edge of PIXCLK.
> </quote>
> 
> and this works for present mt9v022 configurations, which include at least 
> two boards: PXA270-based arch/arm/mach-pxa/pcm990-baseboard.c and i.MX31 
> based arch/arm/mach-mx3/mach-pcm037.c. If this is different for your 
> board, maybe you have to set the SOCAM_SENSOR_INVERT_PCLK flag in your 
> "struct soc_camera_link" instance.
> 
> Thanks
> Guennadi
> 
> > Signed-off-by: Teresa Gámez <t.gamez@phytec.de>
> > ---
> >  drivers/media/video/mt9v022.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
> > index 6a784c8..dec2a69 100644
> > --- a/drivers/media/video/mt9v022.c
> > +++ b/drivers/media/video/mt9v022.c
> > @@ -228,7 +228,7 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
> >  
> >  	flags = soc_camera_apply_sensor_flags(icl, flags);
> >  
> > -	if (flags & SOCAM_PCLK_SAMPLE_RISING)
> > +	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
> >  		pixclk |= 0x10;
> >  
> >  	if (!(flags & SOCAM_HSYNC_ACTIVE_HIGH))
> > -- 
> > 1.7.0.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


