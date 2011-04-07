Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:61588 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab1DGMlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 08:41:20 -0400
Date: Thu, 7 Apr 2011 14:41:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Teresa Gamez <T.Gamez@phytec.de>
cc: linux-media@vger.kernel.org
Subject: Re: Antwort: Re: [PATCH 1/2] mt9v022: fix pixel clock
In-Reply-To: <OF0E7310A6.B4F9559D-ONC125786B.003E2F29-C125786B.004202D7@phytec.de>
Message-ID: <Pine.LNX.4.64.1104071419540.26842@axis700.grange>
References: <1302098515-12176-1-git-send-email-t.gamez@phytec.de>
 <Pine.LNX.4.64.1104071303001.26842@axis700.grange>
 <OF0E7310A6.B4F9559D-ONC125786B.003E2F29-C125786B.004202D7@phytec.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Teresa

On Thu, 7 Apr 2011, Teresa Gamez wrote:

> Hello Guennadi,
> 
> the datasheet also says (see table 3):
> 
> <quote>
> Pixel clock out. DOUT is valid on rising edge of this
> clock.
> </quote>
> 
> There is a difference between DOUT beeing vaild and DOUT beeing set up. 
> So does SOCAM_PCLK_SAMPLE_RISING mean that the data is valid at rising 
> edge or 
> does it mean the data is set up at rising edge? 

Hm, yeah, looks like a typical example of a copy-paste datasheet to me:-( 
And now we don't know which of the two is actually supposed to be true. As 
for "set up" vs. "valid" - not sure, whether there is indeed a difference 
between them. To me "set up _TO_ the rising edge" is a short way to set 
"set up to be valid at the rising edge," however, I might be wrong. Can 
you tell me in more detail what and where (at the sensor board or on the 
baseboard) you measured and what it looked like? I think, Figure 7 and the 
description below it are interesting. From that diagram I would indeed say 
indeed the DOUT pins are valid and should be sampled at the rising edge by 
default - when bit 4 in 0x74 is not set. SOCAM_PCLK_SAMPLE_RISING means, 
that the data should be sampled at the rising of pclkm, i.e., it is valid 
there.

So, yes, if your measurements agree with figure 7 from the datasheet, we 
shall assume, that the driver implements the pclk polarity wrongly. But 
the fix should be more extensive, than what you've submitted: if we invert 
driver's behaviour, we should also invert board configuration of all 
driver users: pcm990 and pcm037. Or we have to test them and verify, that 
the inverted pclk polarity doesn't megatively affect the image quality, or 
maybe even improves it.

Thanks
Guennadi

> I have tested this with a pcm038 but I will also make meassurements with 
> the pcm037.
> 
> Teresa
> 
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> schrieb am 07.04.2011 
> 13:08:11:
> 
> > Von: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > An: Teresa Gámez <t.gamez@phytec.de>
> > Kopie: linux-media@vger.kernel.org
> > Datum: 07.04.2011 13:08
> > Betreff: Re: [PATCH 1/2] mt9v022: fix pixel clock
> > 
> > On Wed, 6 Apr 2011, Teresa Gámez wrote:
> > 
> > > Measurements show that the setup of the pixel clock is not correct.
> > > The 'Invert Pixel Clock' bit has to be set to 1 for falling edge
> > > and not for rising.
> > 
> > Doesn't seem correct to me. The mt9v022 datasheet says:
> > 
> > <quote>
> > Invert pixel clock. When set, LINE_VALID,
> > FRAME_VALID, and DOUT is set up to the rising edge
> > of pixel clock, PIXCLK. When clear, they are set up to
> > the falling edge of PIXCLK.
> > </quote>
> > 
> > and this works for present mt9v022 configurations, which include at 
> least 
> > two boards: PXA270-based arch/arm/mach-pxa/pcm990-baseboard.c and i.MX31 
> 
> > based arch/arm/mach-mx3/mach-pcm037.c. If this is different for your 
> > board, maybe you have to set the SOCAM_SENSOR_INVERT_PCLK flag in your 
> > "struct soc_camera_link" instance.
> > 
> > Thanks
> > Guennadi
> > 
> > > Signed-off-by: Teresa Gámez <t.gamez@phytec.de>
> > > ---
> > >  drivers/media/video/mt9v022.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/mt9v022.c 
> b/drivers/media/video/mt9v022.c
> > > index 6a784c8..dec2a69 100644
> > > --- a/drivers/media/video/mt9v022.c
> > > +++ b/drivers/media/video/mt9v022.c
> > > @@ -228,7 +228,7 @@ static int mt9v022_set_bus_param(struct 
> > soc_camera_device *icd,
> > > 
> > >     flags = soc_camera_apply_sensor_flags(icl, flags);
> > > 
> > > -   if (flags & SOCAM_PCLK_SAMPLE_RISING)
> > > +   if (flags & SOCAM_PCLK_SAMPLE_FALLING)
> > >        pixclk |= 0x10;
> > > 
> > >     if (!(flags & SOCAM_HSYNC_ACTIVE_HIGH))
> > > -- 
> > > 1.7.0.4
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media" 
> in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
