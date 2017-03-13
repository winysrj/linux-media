Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:60697 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750790AbdCMKSa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 06:18:30 -0400
Subject: Re: [PATCH] [media] vcodev: mediatek: add missing include in JPEG
 decoder driver
To: =?UTF-8?Q?J=c3=a9r=c3=a9my_Lefaure?= <jeremy.lefaure@lse.epita.fr>,
        Rick Chang <rick.chang@mediatek.com>,
        Bin Liu <bin.liu@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
References: <20170312201329.28357-1-jeremy.lefaure@lse.epita.fr>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <27eb2dc3-cc98-d41f-ed4f-71b2660702aa@xs4all.nl>
Date: Mon, 13 Mar 2017 11:17:33 +0100
MIME-Version: 1.0
In-Reply-To: <20170312201329.28357-1-jeremy.lefaure@lse.epita.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/12/2017 09:13 PM, Jérémy Lefaure wrote:
> The driver uses kzalloc and kfree functions. So it should include
> linux/slab.h. This header file is implicitly included by v4l2-common.h
> if CONFIG_SPI is enabled. But when it is disabled, slab.h is not
> included. In this case, the driver does not compile:
> 
> drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c: In function ‘mtk_jpeg_open’:
> drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1017:8: error: implicit
> declaration of function ‘kzalloc’
> [-Werror=implicit-function-declaration]
>   ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>         ^~~~~~~
> drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1017:6: warning:
> assignment makes pointer from integer without a cast [-Wint-conversion]
>   ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>       ^
> drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1047:2: error: implicit
> declaration of function ‘kfree’ [-Werror=implicit-function-declaration]
>   kfree(ctx);
>   ^~~~~
> 
> This patch adds the missing include to fix this issue.

Thanks for the patch, but someone else made the same fix already and it is
queued up for 4.12.

Regards,

	Hans

> 
> Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
> ---
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> index b10183f7942b..f9bd58ce7d32 100644
> --- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> +++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
> @@ -22,6 +22,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <media/v4l2-event.h>
>  #include <media/v4l2-mem2mem.h>
> 
