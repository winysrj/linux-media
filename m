Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45375 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbeDGLq5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 07:46:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/2] media: omapfb: relax compilation if COMPILE_TEST
Date: Sat, 07 Apr 2018 14:46:56 +0300
Message-ID: <3343566.MdR49rtcuZ@avalon>
In-Reply-To: <c318fd1c9f79995c6c2e4e82ca99ff494b2afb7b.1523028795.git.mchehab@s-opensource.com>
References: <96572680e698fc554310e18cd6a166a0fb3bf32c.1523028795.git.mchehab@s-opensource.com> <c318fd1c9f79995c6c2e4e82ca99ff494b2afb7b.1523028795.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Friday, 6 April 2018 18:33:20 EEST Mauro Carvalho Chehab wrote:
> The dependency of DRM_OMAP = n can be relaxed for just
> compilation test.
> 
> This allows building the omap3isp driver with allyesconfig
> on ARM.

omapfb has nothing to do with omap3isp. I assume you meant omap_vout.

There's a reason why both DRM_OMAP and FB_OMAP2 can't be compiled at the same 
time, they export identical symbols. I believe you will end up with link 
failures if you do so.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/video/fbdev/omap2/omapfb/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/fbdev/omap2/omapfb/Kconfig
> b/drivers/video/fbdev/omap2/omapfb/Kconfig index e6226aeed17e..e42794a5e26c
> 100644
> --- a/drivers/video/fbdev/omap2/omapfb/Kconfig
> +++ b/drivers/video/fbdev/omap2/omapfb/Kconfig
> @@ -4,7 +4,7 @@ config OMAP2_VRFB
>  menuconfig FB_OMAP2
>          tristate "OMAP2+ frame buffer support"
>          depends on FB
> -        depends on DRM_OMAP = n
> +        depends on DRM_OMAP = n || COMPILE_TEST
> 
>          select FB_OMAP2_DSS
>  	select OMAP2_VRFB if ARCH_OMAP2 || ARCH_OMAP3

-- 
Regards,

Laurent Pinchart
