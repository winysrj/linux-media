Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58900 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752654AbZDXLAC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 07:00:02 -0400
Date: Fri, 24 Apr 2009 13:00:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RFC] soc-camera: Convert to a platform driver
In-Reply-To: <87iqlgkykd.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.0904241258350.4201@axis700.grange>
References: <Pine.LNX.4.64.0904061207530.4285@axis700.grange> <87iqlgkykd.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Apr 2009, Robert Jarzmik wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> 
> > diff --git a/arch/arm/mach-pxa/mioa701.c b/arch/arm/mach-pxa/mioa701.c
> > index 97c93a7..5c8aabf 100644
> > --- a/arch/arm/mach-pxa/mioa701.c
> > +++ b/arch/arm/mach-pxa/mioa701.c
> > @@ -724,19 +724,19 @@ struct pxacamera_platform_data mioa701_pxacamera_platform_data = {
> >  	.mclk_10khz = 5000,
> >  };
> >  
> > -static struct soc_camera_link iclink = {
> > -	.bus_id	= 0, /* Must match id in pxa27x_device_camera in device.c */
> > -};
> > -
> >  /* Board I2C devices. */
> I would rather have :
> /*
>  * Board I2C devices
>  */

As a matter of fact (from git-blame):

8e7ccddf (Robert Jarzmik 2008-11-15 16:09:54 +0100 732) /* Board I2C devices. */

> The remaining /* blurpblurg */ forms are a leftover in device comments.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
