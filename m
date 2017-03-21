Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:27039 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755329AbdCUBW2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 21:22:28 -0400
Message-ID: <1490059335.27725.7.camel@mtksdaap41>
Subject: Re: [PATCH 1/2] [media] vcodec: mediatek: add missing linux/slab.h
 include
From: Rick Chang <rick.chang@mediatek.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Bin Liu <bin.liu@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Minghsiu Tsai" <minghsiu.tsai@mediatek.com>,
        Ricky Liang <jcliang@chromium.org>,
        <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, "Hans Verkuil" <hverkuil@xs4all.nl>
Date: Tue, 21 Mar 2017 09:22:15 +0800
In-Reply-To: <20170320094812.1365229-1-arnd@arndb.de>
References: <20170320094812.1365229-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

Thank you for the patch, but someone has fixed the same problem.

Regards,
Rick

On Mon, 2017-03-20 at 10:47 +0100, Arnd Bergmann wrote:
> With the newly added driver, I have run into randconfig failures like:
> 
> drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c: In function 'mtk_jpeg_open':
> drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c:1017:8: error: implicit declaration of function 'kzalloc';did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
> 
> Including the header with the declaration solves the problem.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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
