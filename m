Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:15474 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaIJIES (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 04:04:18 -0400
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCHv3 1/3] [media] disable OMAP1 COMPILE_TEST
Date: Wed, 10 Sep 2014 10:04:12 +0200
Message-id: <3055703.v1cXzV8T6U@amdc1032>
In-reply-to: <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
References: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <5f850d5d45a27c50dabf3da08689cbedf986841b.1410288748.git.m.chehab@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

On Tuesday, September 09, 2014 03:54:04 PM Mauro Carvalho Chehab wrote:
> This driver depends on a legacy OMAP DMA API. So, it won't
> compile-test on other archs.
> 
> While we might add stubs to the functions, this is not a
> good idea, as the hole API should be replaced.

This is also not a good idea becaouse it would break the driver
for OMAP1 once somebody enables COMPILE_TEST option while also
having ARCH_OMAP1 enabled (which is perfectly fine and shouldn't
cause the driver breakage).  In general COMPILE_TEST option is
completely independent from the arch specific ones and it should
not change behaviour of the existing code.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> So, for now, let's just remove COMPILE_TEST and wait for
> some time for people to fix. If not fixed, then we'll end
> by removing this driver as a hole.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 6af6c6dccda8..f2776cd415ca 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -63,7 +63,7 @@ config VIDEO_SH_MOBILE_CEU
>  config VIDEO_OMAP1
>  	tristate "OMAP1 Camera Interface driver"
>  	depends on VIDEO_DEV && SOC_CAMERA
> -	depends on ARCH_OMAP1 || COMPILE_TEST
> +	depends on ARCH_OMAP1
>  	depends on HAS_DMA
>  	select VIDEOBUF_DMA_CONTIG
>  	select VIDEOBUF_DMA_SG

