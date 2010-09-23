Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:40914 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab0IWXpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 19:45:15 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [RESEND][PATCH v2 2/6] OMAP1: Add support for SoC camera interface
Date: Fri, 24 Sep 2010 01:44:45 +0200
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl> <201009110334.03905.jkrzyszt@tis.icnet.pl> <20100923232309.GV4211@atomide.com>
In-Reply-To: <20100923232309.GV4211@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201009240144.47422.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Friday 24 September 2010 01:23:10 Tony Lindgren napisał(a):
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100910 18:26]:
> > This patch adds support for SoC camera interface to OMAP1 devices.
> >
> > Created and tested against linux-2.6.36-rc3 on Amstrad Delta.
> >
> > For successfull compilation, requires a header file provided by PATCH 1/6
> > from this series, "SoC Camera: add driver for OMAP1 camera interface".
>
> <snip>
>
> > diff -upr linux-2.6.36-rc3.orig/arch/arm/mach-omap1/include/mach/camera.h
> > linux-2.6.36-rc3/arch/arm/mach-omap1/include/mach/camera.h
> > ---
> > linux-2.6.36-rc3.orig/arch/arm/mach-omap1/include/mach/camera.h	2010-09-0
> >3 22:34:03.000000000 +0200 +++
> > linux-2.6.36-rc3/arch/arm/mach-omap1/include/mach/camera.h	2010-09-09
> > 18:42:30.000000000 +0200 @@ -0,0 +1,8 @@
> > +#ifndef __ASM_ARCH_CAMERA_H_
> > +#define __ASM_ARCH_CAMERA_H_
> > +
> > +#include <media/omap1_camera.h>
> > +
> > +extern void omap1_set_camera_info(struct omap1_cam_platform_data *);
> > +
> > +#endif /* __ASM_ARCH_CAMERA_H_ */
>
> Care to refresh this patch so it does not include media/omap1_camera.h?
>
> That way things keep building if I merge this one along with the omap
> patches and the drivers/media patches can get merged their via media.
>
> I think you can just move the OMAP1_CAMERA_IOSIZE to the devices.c or
> someplace like that?

Tony,
Not exactly. I use the OMAP1_CAMERA_IOSIZE inside the driver when reserving 
space for register cache.

I think that I could just duplicate its definition in the devices.c for now, 
than clean things up with a folloup patch when both parts already get merged. 
Would this be acceptable?

Thanks,
Janusz

>
> Regards,
>
> Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
