Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:50103 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbKMVdh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 16:33:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
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
Subject: Re: [PATCH 2/2] [media] include/media: move platform driver headers to a separate dir
Date: Fri, 13 Nov 2015 22:31:15 +0100
Message-ID: <4273019.OjrpsKyH2t@wuerfel>
In-Reply-To: <20151113171341.0972ef7a@recife.lan>
References: <413d2bb0b813a7e62867de7a94b0ab61e16cb1cb.1447261977.git.mchehab@osg.samsung.com> <4220808.QEkJDXYE1T@wuerfel> <20151113171341.0972ef7a@recife.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 13 November 2015 17:13:41 Mauro Carvalho Chehab wrote:
> Em Wed, 11 Nov 2015 21:26:31 +0100
> Arnd Bergmann <arnd@arndb.de> escreveu:
> 

>  include/media/{ => drv-intf}/cx2341x.h                   | 0
>  include/media/{ => drv-intf}/cx25840.h                   | 0
>  include/media/{ => drv-intf}/exynos-fimc.h               | 0
>  include/media/{ => drv-intf}/msp3400.h                   | 0
>  include/media/{ => drv-intf}/s3c_camif.h                 | 0
>  include/media/{ => drv-intf}/saa7146.h                   | 0
>  include/media/{ => drv-intf}/saa7146_vv.h                | 2 +-
>  include/media/{ => drv-intf}/sh_mobile_ceu.h             | 0
>  include/media/{ => drv-intf}/sh_mobile_csi2.h            | 0
>  include/media/{ => drv-intf}/sh_vou.h                    | 0
>  include/media/{ => drv-intf}/si476x.h                    | 0
>  include/media/{ => drv-intf}/soc_mediabus.h              | 0
>  include/media/{ => drv-intf}/tea575x.h                   | 0
>  include/media/i2c/tw9910.h                               | 2 +-
>  include/media/{ => platform_data}/gpio-ir-recv.h         | 0
>  include/media/{ => platform_data}/ir-rx51.h              | 0
>  include/media/{ => platform_data}/mmp-camera.h           | 0
>  include/media/{ => platform_data}/omap1_camera.h         | 0
>  include/media/{ => platform_data}/omap4iss.h             | 0
>  include/media/{ => platform_data}/s5p_hdmi.h             | 0
>  include/media/{ => platform_data}/si4713.h               | 0
>  include/media/{ => platform_data}/sii9234.h              | 0
>  include/media/{ => platform_data}/smiapp.h               | 0
>  include/media/{ => platform_data}/soc_camera.h           | 0
>  include/media/{ => platform_data}/soc_camera_platform.h  | 2 +-
>  include/media/{ => platform_data}/timb_radio.h           | 0
>  include/media/{ => platform_data}/timb_video.h           | 0
>  sound/pci/es1968.c                                       | 2 +-
>  sound/pci/fm801.c                                        | 2 +-
>  155 files changed, 158 insertions(+), 158 deletions(-)

As Geert said, include/linux/platform_data/media/ would be nicer for
consistency with other subsystems.

> diff --git a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> index ede2bdbb5dd5..44ba1f28bb34 100644
> --- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> +++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
> @@ -33,7 +33,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/leds.h>
>  #include <linux/platform_data/asoc-mx27vis.h>
> -#include <media/soc_camera.h>
> +#include <media/platform_data/soc_camera.h>
>  #include <sound/tlv320aic32x4.h>
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>

This looks like a mistake: the header contains the string 'platform_data',
but it is not actually a platform data header file in the sense
that it defines the interface between platform and driver.

Maybe soc_camera.h is important enough to still leave it as a core
file in the existing location? Or possibly a separate directory for
media/soc_camera/*.h

> @@ -24,7 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/kfifo.h>
>  #include <linux/module.h>
> -#include <media/cx25840.h>
> +#include <media/drv-intf/cx25840.h>
>  #include <media/rc-core.h>
>  
>  #include "cx25840-core.h"

For this case, I think the original patch to move it into include/media/i2c
was more logical as it mirrors the file structure. I was mainly talking
about the platform_data being different from the rest.

	Arnd
