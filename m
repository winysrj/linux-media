Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:53885 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755999Ab0KJNE6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 08:04:58 -0500
Date: Wed, 10 Nov 2010 14:05:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] mx2_camera: fix pixel clock polarity configuration
In-Reply-To: <20101110121445.GF26776@jasper.tkos.co.il>
Message-ID: <Pine.LNX.4.64.1011101401400.13739@axis700.grange>
References: <a54ec7e539912fd6009803cffa331b028fdb9a67.1288162873.git.baruch@tkos.co.il>
 <20101110121445.GF26776@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 10 Nov 2010, Baruch Siach wrote:

> Hi linux-media,
> 
> On Wed, Oct 27, 2010 at 09:03:52AM +0200, Baruch Siach wrote:
> > When SOCAM_PCLK_SAMPLE_FALLING, just leave CSICR1_REDGE unset, otherwise we get
> > the inverted behaviour.
> > 
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> 
> Trying my luck again. Now adding Guennadi to Cc.

Trying again will not help, until you reply to my previous comment, and 
you, probably, will not reply to it, until your mail-server stops 
rejecting my mails, and it probably will reject this one too in a way 
similar too

<baruch@tkos.co.il>:
62.219.50.35_does_not_like_recipient./Remote_host_said:_550_5.7.1_<baruch@tkos.co.il>..._Rejected_recent_spam_sourc
e_[mailout-de.gmx.net]_Reply_at_http://tk-open-systems.com/unblockme/index.php?id=tango/Giving_up_on_62.219.50.35./

Thanks
Guennadi

> 
> This is a real bug fix, BTW.
> 
> baruch
> 
> > ---
> >  drivers/media/video/mx2_camera.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > index 3ea2ec0..02f144f 100644
> > --- a/drivers/media/video/mx2_camera.c
> > +++ b/drivers/media/video/mx2_camera.c
> > @@ -811,8 +811,6 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
> >  
> >  	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
> >  		csicr1 |= CSICR1_REDGE;
> > -	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
> > -		csicr1 |= CSICR1_INV_PCLK;
> >  	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
> >  		csicr1 |= CSICR1_SOF_POL;
> >  	if (common_flags & SOCAM_HSYNC_ACTIVE_HIGH)
> > -- 
> 
> -- 
>                                                      ~. .~   Tk Open Systems
> =}------------------------------------------------ooO--U--Ooo------------{=
>    - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
