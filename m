Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54645 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbbKMW5m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 17:57:42 -0500
Date: Fri, 13 Nov 2015 20:57:28 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	linux-sh@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
	Sergey Lapin <slapin@ossfans.org>,
	Sekhar Nori <nsekhar@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Harald Welte <laforge@openezx.org>, devel@driverdev.osuosl.org,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	openezx-devel@lists.openezx.org,
	Russell King <linux@arm.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Vinod Koul <vinod.koul@intel.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Kukjin Kim <kgene@kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Junghak Sung <jh1009.sung@samsung.com>,
	D aniel Ribeiro <drwyrm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Inki Dae <inki.dae@samsung.com>,
	linux-samsung-soc@vger.kernel.org,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	linux-omap@vger.kernel.org, Stefan Schmidt <stefan@openezx.org>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Josh Wu <josh.wu@atmel.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Simon Horman <horms@verge.net.au>,
	Sascha Hauer <kernel@pengutronix.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH 2/2] [media] include/media: move platform driver headers
 to a separate dir
Message-ID: <20151113205728.39c12b7b@recife.lan>
In-Reply-To: <4273019.OjrpsKyH2t@wuerfel>
References: <413d2bb0b813a7e62867de7a94b0ab61e16cb1cb.1447261977.git.mchehab@osg.samsung.com>
	<4220808.QEkJDXYE1T@wuerfel>
	<20151113171341.0972ef7a@recife.lan>
	<4273019.OjrpsKyH2t@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 13 Nov 2015 22:31:15 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Friday 13 November 2015 17:13:41 Mauro Carvalho Chehab wrote:
> > Em Wed, 11 Nov 2015 21:26:31 +0100
> > Arnd Bergmann <arnd@arndb.de> escreveu:
> > 
> 
> >  include/media/{ => drv-intf}/cx2341x.h                   | 0
> >  include/media/{ => drv-intf}/cx25840.h                   | 0
> >  include/media/{ => drv-intf}/exynos-fimc.h               | 0
> >  include/media/{ => drv-intf}/msp3400.h                   | 0
> >  include/media/{ => drv-intf}/s3c_camif.h                 | 0
> >  include/media/{ => drv-intf}/saa7146.h                   | 0
> >  include/media/{ => drv-intf}/saa7146_vv.h                | 2 +-
> >  include/media/{ => drv-intf}/sh_mobile_ceu.h             | 0
> >  include/media/{ => drv-intf}/sh_mobile_csi2.h            | 0
> >  include/media/{ => drv-intf}/sh_vou.h                    | 0
> >  include/media/{ => drv-intf}/si476x.h                    | 0
> >  include/media/{ => drv-intf}/soc_mediabus.h              | 0
> >  include/media/{ => drv-intf}/tea575x.h                   | 0
> >  include/media/i2c/tw9910.h                               | 2 +-
> >  include/media/{ => platform_data}/gpio-ir-recv.h         | 0
> >  include/media/{ => platform_data}/ir-rx51.h              | 0
> >  include/media/{ => platform_data}/mmp-camera.h           | 0
> >  include/media/{ => platform_data}/omap1_camera.h         | 0
> >  include/media/{ => platform_data}/omap4iss.h             | 0
> >  include/media/{ => platform_data}/s5p_hdmi.h             | 0
> >  include/media/{ => platform_data}/si4713.h               | 0
> >  include/media/{ => platform_data}/sii9234.h              | 0
> >  include/media/{ => platform_data}/smiapp.h               | 0
> >  include/media/{ => platform_data}/soc_camera.h           | 0
> >  include/media/{ => platform_data}/soc_camera_platform.h  | 2 +-
> >  include/media/{ => platform_data}/timb_radio.h           | 0
> >  include/media/{ => platform_data}/timb_video.h           | 0
> >  sound/pci/es1968.c                                       | 2 +-
> >  sound/pci/fm801.c                                        | 2 +-
> >  155 files changed, 158 insertions(+), 158 deletions(-)
> 
> As Geert said, include/linux/platform_data/media/ would be nicer for
> consistency with other subsystems.

OK! I have a new series of patches almost ready. I'll be sending it
tomorrow, after addressing your concerns.

> 
> > diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> > index ede2bdbb5dd5..44ba1f28bb34 100644
> > --- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> > +++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> > @@ -33,7 +33,7 @@
> >  #include <linux/dma-mapping.h>
> >  #include <linux/leds.h>
> >  #include <linux/platform_data/asoc-mx27vis.h>
> > -#include <media/soc_camera.h>
> > +#include <media/platform_data/soc_camera.h>
> >  #include <sound/tlv320aic32x4.h>
> >  #include <asm/mach-types.h>
> >  #include <asm/mach/arch.h>
> 
> This looks like a mistake: the header contains the string 'platform_data',
> but it is not actually a platform data header file in the sense
> that it defines the interface between platform and driver.
> 
> Maybe soc_camera.h is important enough to still leave it as a core
> file in the existing location? Or possibly a separate directory for
> media/soc_camera/*.h

Ok, I'll fix it. 

> 
> > @@ -24,7 +24,7 @@
> >  #include <linux/slab.h>
> >  #include <linux/kfifo.h>
> >  #include <linux/module.h>
> > -#include <media/cx25840.h>
> > +#include <media/drv-intf/cx25840.h>
> >  #include <media/rc-core.h>
> >  
> >  #include "cx25840-core.h"
> 
> For this case, I think the original patch to move it into include/media/i2c
> was more logical as it mirrors the file structure. I was mainly talking
> about the platform_data being different from the rest.

cx25840 is not (always) an I2C. On most devices, this is actually an IP
block inside the bridge chipset. 

That's why I didn't include it on patch 1/1. There's one thing to
notice about that, though: while most of the header is describing
the driver interface, it does contain one platform_data in the end:

/* pvr150_workaround activates a workaround for a hardware bug that is
   present in Hauppauge PVR-150 (and possibly PVR-500) cards that have
   certain NTSC tuners (tveeprom tuner model numbers 85, 99 and 112). The
   audio autodetect fails on some channels for these models and the workaround
   is to select the audio standard explicitly. Many thanks to Hauppauge for
   providing this information.
   This platform data only needs to be supplied by the ivtv driver. */
struct cx25840_platform_data {
	int pvr150_workaround;
};

While we might split it, I guess it is not worth, specially since
I don't think we'll see any new driver using it.

Also, this is actually a hack used only by the ivtv driver.

Regards,
Mauro
