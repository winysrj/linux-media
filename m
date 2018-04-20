Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52593 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755393AbeDTPNc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 11:13:32 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20180420151330euoutp014d993dc684e47a443c54a1da15c7b7f8~nLaq4VmZR1131211312euoutp01R
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2018 15:13:30 +0000 (GMT)
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 15/19] omap2: omapfb: allow building it with
 COMPILE_TEST
Date: Fri, 20 Apr 2018 17:13:17 +0200
Message-ID: <3329803.Cv7XkTmsQk@amdc3058>
In-Reply-To: <f0947227675df4a774949500b6ee4cac1485b494.1522959716.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
References: <cover.1522959716.git.mchehab@s-opensource.com>
        <CGME20180405202959epcas4p4eba19cc23d569d34223cc7d22a536753@epcas4p4.samsung.com>
        <f0947227675df4a774949500b6ee4cac1485b494.1522959716.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, April 05, 2018 04:29:42 PM Mauro Carvalho Chehab wrote:
> This driver builds cleanly with COMPILE_TEST, and it is
> needed in order to allow building drivers/media omap2
> driver.
> 
> So, change the logic there to allow building it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

This change has broken build on OF=n && COMPILE_TEST=y configs:

https://patchwork.kernel.org/patch/10352465/

[ This is not a problem when compiling for OMAP2 because it depends
  on ARM Multiplatform support which (indirectly) selects OF. ]

Also I would really prefer that people won't merge fbdev related
patches without my ACK and I see this patch in -next coming from
one of your trees..

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

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
