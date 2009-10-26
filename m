Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:52370 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451AbZJZKC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 06:02:29 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: rath <mailings@web150.mis07.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 26 Oct 2009 15:32:36 +0530
Subject: RE: cpu load of webcam read out with omap3/beagleboard
Message-ID: <19F8576C6E063C45BE387C64729E73940436E5F43A@dbde02.ent.ti.com>
References: <4ADAF16B.1090409@hardware-datenbank.de>
 <62C779E180BB45FB828023FAF1233BAA@pcvirus>
In-Reply-To: <62C779E180BB45FB828023FAF1233BAA@pcvirus>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: rath [mailto:mailings@web150.mis07.de]
> Sent: Friday, October 23, 2009 7:58 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav
> Subject: Re: cpu load of webcam read out with omap3/beagleboard
> 
> Nobody has an idea? I think this cpu load isn't normal, becuase
> everywhere
> you can read, that the bealgeboard is very fast and it has 500MHz...
> 
> Regards, Joern
> 
> 
> ----- Original Message -----
> From: "Rath" <mailings@hardware-datenbank.de>
> To: "Linux-Media" <linux-media@vger.kernel.org>
> Sent: Sunday, October 18, 2009 12:43 PM
> Subject: cpu load of webcam read out with omap3/beagleboard
> 
> 
> > Hi,
> >
> > I have beagleboard with the OMAP3530 processor and I want to read
> a usb
> > webcam out. But I only get usable results at 160x120 resolution.
> > I set the pixelformat to "V4L2_PIX_FMT_RGB24" and the resolution
> to
> > 160x120. With these settings I get 30fps at 4% cpu load. But when
> I set
> > the resolution to 320x240 or 640x480 the cpu load is at 98% and I
> get only
> > 17 or 4fps. Also I get at 640x480 errors like "libv4lconvert:
> Error
> > decompressing JPEG: fill_nbits error: need 9 more bits".
> >
> > Is this a normal behavior or is  there a way to fix  this?  I
> think the
> > problem is the conversion from MJPEG to RGB, because when I set
> the
> > pixelformat to MJPEG the cpu load is <1%.  
[Hiremath, Vaibhav] This itself clarifies that the conversion is proving to be costly here, since with MJPEG you are getting <1% CPU consumption. I have never used/came across such use-case/scenario, so it is really difficult to comment on this.

Thanks,
Vaibhav

> But  I need RGB data
> for image
> > processing.
> >
> > I hope someone can help me.
> >
> > Regards, Joern
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 

