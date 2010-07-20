Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39179 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759365Ab0GTJtu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 05:49:50 -0400
Date: Tue, 20 Jul 2010 11:49:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [RFC] [PATCH 0/6] Add camera support to the OMAP1 Amstrad Delta
 videophone
In-Reply-To: <201007180618.08266.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1007201139320.29807@axis700.grange>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Janusz

On Sun, 18 Jul 2010, Janusz Krzysztofik wrote:

> This series consists of the following patches:
> 
>   1/6	SoC Camera: add driver for OMAP1 camera interface
>   2/6	OMAP1: Add support for SoC camera interface
>   3/6	SoC Camera: add driver for OV6650 sensor
>   4/6	SoC Camera: add support for g_parm / s_parm operations
>   5/6	OMAP1: Amstrad Delta: add support for on-board camera
>   6/6	OMAP1: Amstrad Delta: add camera controlled LEDS trigger

It is an interesting decision to use soc-camera for an OMAP SoC, as you 
most probably know OMAP3 and OMAP2 camera drivers do not use soc-camera. I 
certainly do not want to discourage you from using soc-camera, just don't 
want you to go the wrong way and then regret it or spend time re-designing 
your driver. Have you had specific reasons for this design? Is OMAP1 so 
different from 2 (and 3)? In any case - thanks for the patches, if you do 
insist on going this path (;)) I'll review them and get back to you after 
that. Beware, it might be difficult to finish the review process in time 
for 2.6.36...

Thanks
Guennadi

> 
>  arch/arm/mach-omap1/board-ams-delta.c     |   69 +
>  arch/arm/mach-omap1/devices.c             |   43
>  arch/arm/mach-omap1/include/mach/camera.h |    8
>  drivers/media/video/Kconfig               |   20
>  drivers/media/video/Makefile              |    2
>  drivers/media/video/omap1_camera.c        | 1656 ++++++++++++++++++++++++++++++
>  drivers/media/video/ov6650.c              | 1336 ++++++++++++++++++++++++
>  drivers/media/video/soc_camera.c          |   18
>  include/media/omap1_camera.h              |   16
>  include/media/v4l2-chip-ident.h           |    1
>  10 files changed, 3169 insertions(+)
> 
> Thanks,
> Janusz
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
