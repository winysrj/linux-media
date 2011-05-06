Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:51900 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1EFOHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 10:07:05 -0400
Date: Fri, 6 May 2011 16:07:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Teresa Gamez <T.Gamez@phytec.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] mt9v022: fix pixel clock
In-Reply-To: <1304687639.11400.383.camel@lws-gamez>
Message-ID: <Pine.LNX.4.64.1105061541360.10445@axis700.grange>
References: <1302791997-12679-1-git-send-email-t.gamez@phytec.de>
 <Pine.LNX.4.64.1105040959130.23196@axis700.grange> <1304687639.11400.383.camel@lws-gamez>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Teresa,

On Fri, 6 May 2011, Teresa Gamez wrote:

> Hello Guennadi,
> 
> Am Mittwoch, den 04.05.2011, 10:17 +0200 schrieb Guennadi Liakhovetski:
> > Hi Teresa
> > 
> > I'm adding Mauro to CC, because we were discussing adding these (this one 
> > and mt9m111) patches to .39.
> > 
> > On Thu, 14 Apr 2011, Teresa Gámez wrote:
> > 
> > > The setup of the pixel clock is done wrong in the mt9v022 driver.
> > > The 'Invert Pixel Clock' bit has to be set to 1 for falling edge
> > > and not for rising. This is not clearly described in the data
> > > sheet.
> > 
> > I finally got round to test your patch on pcm037. But sorry, I cannot 
> > reproduce your success. What's even worth, your patch, if applied to the 
> > stock kernel, really messes up Bayer colours for me. With your patch alone 
> > I cannot select the Bayer filter starting pixel parameter to produce 
> > correct colours. Without your patch colours do not look very clean, that's 
> > true, but I always attributed it to some sensor fine-tuning issues. But at 
> > least they are correct. 
> 
> Thank you for testing this.

Np, sorry, I only now came round to doing this, but as this is going to be 
a fix, it should be even possible to push it after .39 for stable.

> Of course the Bayer to RGB conversion can have a impact on the test result.
> 
> To avoid this, it might be better to first try out the test pattern 
> generated by the color or monochrom mtv9v022 sensor. With the test 
> pattern no Bayer conversion should be made.

Yes, could try this. But there really seems to be a difference between our 
boards. If this turns out to be the case, we'll have to distinguish 
between the two board versions in the platform data and use the inverter 
flag for one of them.

> Our setup in the i.MX31 controller:
> * Reg 0x53FC_0060 (CSI_SENS_CONF), Bit 3 (SENS_PIX_CLK_POL)  = 0 
>  <quote> pixel clock is directly applied to internal circuitry 
>  (rising edge). </quote>
>   
>  Which means its using rising edge (See Datasheet mcimx31 Rev3.4 10/2007 i.MX31):
>  <quote> The timing specifications are referenced to the rising 
>  edge of SENS_PIX_CLK when the SENS_PIX_CLK_POL bit in the 
>  CSI_SENS_CONF register is cleared. When the SENS_PIX_CLK_POL 
>  is set, the clock is inverted and all timing specifications 
>  will remain the same but are referenced to the falling edge of 
>  the clock.</quote>
> 
> * The MCLOCK is setup with 20MHz
> 
> Setup of the camera sensor mt9v022:
> * Reg 0x74 Bit 4 = 0	# Pixelclock at rising edge
> * Reg 0x7F= 0x2800      # generates vertical shade
> * Reg 0x70 Bit 5 = 0    # disable noise correction
> 			(is nessessary for correct testpattern)
> 
> Our result: test pattern verical is ok
> 
> Now changed setup to:
> * Reg 0x74 Bit 4 = 1	# Pixelclock at falling edge
> 
> Our result: test pattern has errors on a closer look.
> 
> We have tested this with PCM037/PCM970 on a 2.6.39-rc6.

Thanks for the data. There is an even better way to verify this: set bit 
10 of the 0x7f register and write a specific value in bits [9-0], then you 
should be getting exactly this value in your video buffers.

Thanks
Guennadi

> 
> Teresa
> 
> > An easy way to test colours is to point the camera 
> > at the LED pair on the board - blinking red and constant green next to the 
> > ethernet port. You once mentioned, that in your BSP you have the 
> > SOCAM_SENSOR_INVERT_PCLK flag set in your platform data. Maybe you were 
> > testing with that one? Then yes, of course, you'd have to compensate it by 
> > inverting the bit in the sensor. In any case, your patch if applied alone, 
> > seems to break camera on pcm037. Am I missing something?
> > 
> > Thanks
> > Guennadi
> > 
> > > 
> > > Tested on pcm037 and pcm027/pcm990.
> > > 
> > > Signed-off-by: Teresa Gámez <t.gamez@phytec.de>
> > > ---
> > >  drivers/media/video/mt9v022.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
> > > index 6a784c8..dec2a69 100644
> > > --- a/drivers/media/video/mt9v022.c
> > > +++ b/drivers/media/video/mt9v022.c
> > > @@ -228,7 +228,7 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
> > >  
> > >  	flags = soc_camera_apply_sensor_flags(icl, flags);
> > >  
> > > -	if (flags & SOCAM_PCLK_SAMPLE_RISING)
> > > +	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
> > >  		pixclk |= 0x10;
> > >  
> > >  	if (!(flags & SOCAM_HSYNC_ACTIVE_HIGH))
> > > -- 
> > > 1.7.0.4
> > > 
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
