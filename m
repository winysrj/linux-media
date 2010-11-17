Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:37488 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759779Ab0KQHJK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 02:09:10 -0500
Date: Wed, 17 Nov 2010 08:09:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] =?utf-8?b?bXgyX2NhbWVyYTo=?= fix pixel clock polarity
 configuration
In-Reply-To: <loom.20101110T152629-530@post.gmane.org>
Message-ID: <Pine.LNX.4.64.1011170805280.25275@axis700.grange>
References: <a54ec7e539912fd6009803cffa331b028fdb9a67.1288162873.git.baruch@tkos.co.il>
 <Pine.LNX.4.64.1010272336290.13615@axis700.grange> <loom.20101110T152629-530@post.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 10 Nov 2010, Baruch Siach wrote:

> Guennadi Liakhovetski <g.liakhovetski <at> gmx.de> writes:
> 
> > On Wed, 27 Oct 2010, Baruch Siach wrote:
> > > When SOCAM_PCLK_SAMPLE_FALLING, just leave CSICR1_REDGE unset, 
> > > otherwise we get
> > > the inverted behaviour.
> > Seems logical to me, that if this is true, then you need the inverse:
> > 
> > 	if (!(common_flags & SOCAM_PCLK_SAMPLE_FALLING))
> > 		csicr1 |= CSICR1_INV_PCLK;
> 
> No. Doing so you'll get the inverted behaviour of SAMPLE_RISING. When
> common_flags have SAMPLE_RISING set and SAMPLE_FALLING unset you get
> CSICR1_REDGE set, which triggers on the rising edge, and then also
> CSICR1_INV_PCLK set, which invert this. Thus you get the expected 
> behaviour of SAMPLE_FALLING.
> 
> Currently you get the inverted behaviour only for SAMPLE_FALLING.
> 
> IMO, we should just use CSICR1_REDGE to set the sample timing, and leave
> CSICR1_INV_PCLK alone.

Ah, right, of course, I've overlooked that CSICR1_REDGE flag. Then yes, 
your patch makes sense and should go in for 2.6.37.

Thanks
Guennadi

> 
> baruch
> 
> > >  	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
> > >  		csicr1 |= CSICR1_REDGE;
> > > -	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
> > > -		csicr1 |= CSICR1_INV_PCLK;
> > >  	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
> > >  		csicr1 |= CSICR1_SOF_POL;
> > >  	if (common_flags & SOCAM_HSYNC_ACTIVE_HIGH)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
