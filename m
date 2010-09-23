Return-path: <mchehab@pedra>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:53816 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0IWXXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 19:23:13 -0400
Date: Thu, 23 Sep 2010 16:23:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [RESEND][PATCH v2 2/6] OMAP1: Add support for SoC camera
 interface
Message-ID: <20100923232309.GV4211@atomide.com>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
 <201009110323.12250.jkrzyszt@tis.icnet.pl>
 <201009110334.03905.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009110334.03905.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [100910 18:26]:
> This patch adds support for SoC camera interface to OMAP1 devices.
> 
> Created and tested against linux-2.6.36-rc3 on Amstrad Delta.
> 
> For successfull compilation, requires a header file provided by PATCH 1/6 from 
> this series, "SoC Camera: add driver for OMAP1 camera interface".

<snip>

> diff -upr linux-2.6.36-rc3.orig/arch/arm/mach-omap1/include/mach/camera.h 
> linux-2.6.36-rc3/arch/arm/mach-omap1/include/mach/camera.h
> --- linux-2.6.36-rc3.orig/arch/arm/mach-omap1/include/mach/camera.h	2010-09-03 22:34:03.000000000 +0200
> +++ linux-2.6.36-rc3/arch/arm/mach-omap1/include/mach/camera.h	2010-09-09 18:42:30.000000000 +0200
> @@ -0,0 +1,8 @@
> +#ifndef __ASM_ARCH_CAMERA_H_
> +#define __ASM_ARCH_CAMERA_H_
> +
> +#include <media/omap1_camera.h>
> +
> +extern void omap1_set_camera_info(struct omap1_cam_platform_data *);
> +
> +#endif /* __ASM_ARCH_CAMERA_H_ */

Care to refresh this patch so it does not include media/omap1_camera.h?

That way things keep building if I merge this one along with the omap
patches and the drivers/media patches can get merged their via media.

I think you can just move the OMAP1_CAMERA_IOSIZE to the devices.c or
someplace like that?

Regards,

Tony
