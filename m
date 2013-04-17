Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:54508 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966435Ab3DQOQE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 10:16:04 -0400
Date: Wed, 17 Apr 2013 16:15:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Igor Kugasyan <kugasyan@hotmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mt9v034 driver
In-Reply-To: <DUB112-W5AD3C17EE426206DFAEF9D2CE0@phx.gbl>
Message-ID: <Pine.LNX.4.64.1304171609080.16330@axis700.grange>
References: <DUB112-W5AD3C17EE426206DFAEF9D2CE0@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Igor

(forwarding to the real media Mailing List)

On Wed, 17 Apr 2013, Igor Kugasyan wrote:

> Dear Mr. Guennadi,
> 
> Please tell me can I use the soc_camera_ (soc_camera.h, soc_camera.c) 
> interface for a mt9v034 driver as a mt9v022 driver or not?

I don't know anything about mt9v034. It might or might not be compatible 
with one of supported cameras. If it isn't, a new driver has to be 
developed.

> I've read your Video4Linux soc-camera subsystem document and not found a mt9v034 among client drivers.
> I have the Leopard Board 368 (LI-TB02) with the WVGA camera

No, you cannot use soc-camera with Leopard Board. Its camera interface 
might be supported by some other driver, but I'm not sure about that.

>           LI-VM34LP but I haven't a mt9v034 driver for my camera
> for the linux-2.6.32 kernel with RidgeRun

Don't think there's anything that can be done with any kernel apart from 
the current -next, i.e. the forthcoming 3.10.

>           2011Q2 SDK for LeopardBoardDM365 and 
> dvsdk_dm365-evm_4_02_00_06. I haven't sufficient experience for 
> comprehension but I learn...

The only possibility I see is to use a current kernel, adapt an existing 
or write a new camera sensor driver for mt9v034 and use it with the 
appropriate SoC camera interface driver.

Thanks
Guennadi

> Please,
>           please, help me to solve this problem.
> 
>         Thanks
>           in advance.
> 
>         
> 
>         Best regards,
> 
>           
> 
>           Sincerely
>               yours
> 
>             Igor Kugasyan
> 
>             CONECS SSRE
> 
>             Lviv 79060
> 
>             Naukova 7
> 
>             Ukraine
> 
>           
> 
>         T +38 032 2952597
> 
>         F +38 032 2954879
> 
>         E dndp@conecs.lviv.ua 		 	   		  

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
