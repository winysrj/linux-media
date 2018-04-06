Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:58260 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751312AbeDFImF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 04:42:05 -0400
Subject: Re: [PATCH v2 15/19] omap2: omapfb: allow building it with
 COMPILE_TEST
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
References: <cover.1522959716.git.mchehab@s-opensource.com>
 <f0947227675df4a774949500b6ee4cac1485b494.1522959716.git.mchehab@s-opensource.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <4561c3e1-dba6-d2c6-1649-5d79d5512f06@ti.com>
Date: Fri, 6 Apr 2018 11:41:24 +0300
MIME-Version: 1.0
In-Reply-To: <f0947227675df4a774949500b6ee4cac1485b494.1522959716.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/04/18 23:29, Mauro Carvalho Chehab wrote:
> This driver builds cleanly with COMPILE_TEST, and it is
> needed in order to allow building drivers/media omap2
> driver.
> 
> So, change the logic there to allow building it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/video/fbdev/omap2/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/video/fbdev/omap2/Kconfig b/drivers/video/fbdev/omap2/Kconfig
> index 0921c4de8407..82008699d253 100644
> --- a/drivers/video/fbdev/omap2/Kconfig
> +++ b/drivers/video/fbdev/omap2/Kconfig
> @@ -1,4 +1,4 @@
> -if ARCH_OMAP2PLUS
> +if ARCH_OMAP2PLUS || COMPILE_TEST
>  
>  source "drivers/video/fbdev/omap2/omapfb/Kconfig"
>  
> 

Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi

-- 
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
