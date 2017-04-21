Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:39498 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1036024AbdDUHuk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 03:50:40 -0400
Message-ID: <1492761035.12924.0.camel@mtksdaap41>
Subject: Re: [PATCH] [media] mtk-vcodec: avoid warnings because of empty
 macros
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@infradead.org>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Date: Fri, 21 Apr 2017 15:50:35 +0800
In-Reply-To: <5bc3ebc3c6f57c2b30126f113bc35ec95c6f5b5d.1492599391.git.mchehab@s-opensource.com>
References: <5bc3ebc3c6f57c2b30126f113bc35ec95c6f5b5d.1492599391.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-04-19 at 07:56 -0300, Mauro Carvalho Chehab wrote:
> Remove those gcc warnings:
> 
> 	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c: In function 'mtk_vcodec_dec_pw_on':
> 	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c:114:51: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
> 	   mtk_v4l2_err("pm_runtime_get_sync fail %d", ret);
> 	                                                   ^
> 
> By adding braces.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> index 12480837ff2e..237e144c194f 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> @@ -66,15 +66,15 @@ extern bool mtk_vcodec_dbg;
>  
>  #else
>  
> -#define mtk_v4l2_debug(level, fmt, args...)
> -#define mtk_v4l2_err(fmt, args...)
> -#define mtk_v4l2_debug_enter()
> -#define mtk_v4l2_debug_leave()
> +#define mtk_v4l2_debug(level, fmt, args...) {}
> +#define mtk_v4l2_err(fmt, args...) {}
> +#define mtk_v4l2_debug_enter() {}
> +#define mtk_v4l2_debug_leave() {}
>  
> -#define mtk_vcodec_debug(h, fmt, args...)
> -#define mtk_vcodec_err(h, fmt, args...)
> -#define mtk_vcodec_debug_enter(h)
> -#define mtk_vcodec_debug_leave(h)
> +#define mtk_vcodec_debug(h, fmt, args...) {}
> +#define mtk_vcodec_err(h, fmt, args...) {}
> +#define mtk_vcodec_debug_enter(h) {}
> +#define mtk_vcodec_debug_leave(h) {}
>  
>  #endif
>  

Acked-by: Tiffany Lin <Tiffany.lin@mediatek.com>
