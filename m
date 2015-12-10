Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59036 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbbLJOk7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 09:40:59 -0500
Date: Thu, 10 Dec 2015 12:40:54 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
	Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] [media] staging/davinci_vfpe: allow modular build
Message-ID: <20151210124054.3c527f11@recife.lan>
In-Reply-To: <2029571.PWO4DcqdUl@wuerfel>
References: <2029571.PWO4DcqdUl@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Dec 2015 15:29:38 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> It has never been possible to actually build this driver as
> a loadable module, only built-in because the Makefile attempts
> to build each file into its own module and fails:
> 
> ERROR: "mbus_to_pix" [drivers/staging/media/davinci_vpfe/vpfe_video.ko] undefined!
> ERROR: "vpfe_resizer_register_entities" [drivers/staging/media/davinci_vpfe/vpfe_mc_capture.ko] undefined!
> ERROR: "rsz_enable" [drivers/staging/media/davinci_vpfe/dm365_resizer.ko] undefined!
> ERROR: "config_ipipe_hw" [drivers/staging/media/davinci_vpfe/dm365_ipipe.ko] undefined!
> ERROR: "ipipe_set_lutdpc_regs" [drivers/staging/media/davinci_vpfe/dm365_ipipe.ko] undefined!
> 
> It took a long time to catch this bug with randconfig builds
> because at least 14 other Kconfig symbols have to be enabled in
> order to configure this one.
> 
> The solution is really easy: this patch changes the Makefile to
> link all files into one module.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> 
> diff --git a/drivers/staging/media/davinci_vpfe/Makefile b/drivers/staging/media/davinci_vpfe/Makefile
> index c64515c644cd..3019c9ecd548 100644
> --- a/drivers/staging/media/davinci_vpfe/Makefile
> +++ b/drivers/staging/media/davinci_vpfe/Makefile
> @@ -1,3 +1,5 @@
> -obj-$(CONFIG_VIDEO_DM365_VPFE) += \
> +obj-$(CONFIG_VIDEO_DM365_VPFE) += davinci-vfpe.o
> +
> +davinci-vfpe-objs := \
>  	dm365_isif.o dm365_ipipe_hw.o dm365_ipipe.o \
>  	dm365_resizer.o dm365_ipipeif.o vpfe_mc_capture.o vpfe_video.o
> 

That seems a bad signal to me... I guess either this driver was never
actually tested or it was tested only if compiled as built-in...

Regards,
Mauro
