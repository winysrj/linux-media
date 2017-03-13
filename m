Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:5467 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755789AbdCMDFC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Mar 2017 23:05:02 -0400
Message-ID: <1489374294.19716.1.camel@mtksdaap41>
Subject: Re: [PATCH] [media] vcodev: mediatek: add missing include in JPEG
 decoder driver
From: Rick Chang <rick.chang@mediatek.com>
To: =?ISO-8859-1?Q?J=E9r=E9my?= Lefaure <jeremy.lefaure@lse.epita.fr>
CC: Bin Liu <bin.liu@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date: Mon, 13 Mar 2017 11:04:54 +0800
In-Reply-To: <20170312201329.28357-1-jeremy.lefaure@lse.epita.fr>
References: <20170312201329.28357-1-jeremy.lefaure@lse.epita.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2017-03-12 at 16:13 -0400, Jérémy Lefaure wrote:
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
> 
> Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
> ---
>  drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Rick Chang <rick.chang@mediatek.com>
