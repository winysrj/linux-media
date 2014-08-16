Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:48844 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHPUhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Aug 2014 16:37:54 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so3473148wes.24
        for <linux-media@vger.kernel.org>; Sat, 16 Aug 2014 13:37:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1408122629-19634-1-git-send-email-rupran@einserver.de>
References: <1408122629-19634-1-git-send-email-rupran@einserver.de>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 16 Aug 2014 21:37:22 +0100
Message-ID: <CA+V-a8syMAQXW1qvjZK=eVf+aVLE2SGPrjXL7jA1__iaPnf09w@mail.gmail.com>
Subject: Re: [PATCH] drivers: media: platform: Makefile: Add build dependency
 for davinci/
To: Andreas Ruprecht <rupran@einserver.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

On Fri, Aug 15, 2014 at 6:10 PM, Andreas Ruprecht <rupran@einserver.de> wrote:
> In the davinci/ subdirectory, all drivers but one depend on
> CONFIG_ARCH_DAVINCI. The only exception, selected by CONFIG_VIDEO_DM6446_CCDC,
> is also available on CONFIG_ARCH_OMAP3.
>
> Thus, it is not necessary to always descend into davinci/. It is sufficient to
> do this only if CONFIG_ARCH_OMAP3 or CONFIG_ARCH_DAVINCI is selected. While the
> latter is already present, this patch changes the dependency from obj-y to
> obj-$(CONFIG_ARCH_OMAP3).
>

I have submitted a proper fix [1], so NACK.

[1] https://patchwork.kernel.org/patch/4730111/

Regards,
--Prabhakar Lad

> Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
> ---
>  drivers/media/platform/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index e5269da..d32e79a 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -47,7 +47,7 @@ obj-$(CONFIG_SOC_CAMERA)              += soc_camera/
>
>  obj-$(CONFIG_VIDEO_RENESAS_VSP1)       += vsp1/
>
> -obj-y  += davinci/
> +obj-$(CONFIG_ARCH_OMAP3)       += davinci/
>
>  obj-$(CONFIG_ARCH_OMAP)        += omap/
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
