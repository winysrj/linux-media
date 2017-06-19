Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:30135 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751324AbdFSH7I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 03:59:08 -0400
Message-ID: <1497859143.27486.1.camel@mtksdaap41>
Subject: Re: [PATCH v2] [media] mtk-vcodec: Show mtk driver error without
 DEBUG definition
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hirokazu Honda <hiroh@chromium.org>
CC: Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 19 Jun 2017 15:59:03 +0800
In-Reply-To: <20170530095358.2685-1-hiroh@chromium.org>
References: <20170530095358.2685-1-hiroh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-05-30 at 18:53 +0900, Hirokazu Honda wrote:
> A driver error message is shown without DEBUG definition
> to find an error and debug easily.
> 
> Signed-off-by: Hirokazu Honda <hiroh@chromium.org>
Acked-by: Tiffany Lin <tiffany.lin@mediatek.com>

> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> index 237e144c194f..06c254f5c171 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> @@ -32,6 +32,15 @@ extern int mtk_v4l2_dbg_level;
>  extern bool mtk_vcodec_dbg;
>  
> 
> +#define mtk_v4l2_err(fmt, args...)                \
> +	pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
> +	       ##args)
> +
> +#define mtk_vcodec_err(h, fmt, args...)					\
> +	pr_err("[MTK_VCODEC][ERROR][%d]: %s() " fmt "\n",		\
> +	       ((struct mtk_vcodec_ctx *)h->ctx)->id, __func__, ##args)
> +
> +
>  #if defined(DEBUG)
>  
>  #define mtk_v4l2_debug(level, fmt, args...)				 \
> @@ -41,11 +50,6 @@ extern bool mtk_vcodec_dbg;
>  				level, __func__, __LINE__, ##args);	 \
>  	} while (0)
>  
> -#define mtk_v4l2_err(fmt, args...)                \
> -	pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
> -	       ##args)
> -
> -
>  #define mtk_v4l2_debug_enter()  mtk_v4l2_debug(3, "+")
>  #define mtk_v4l2_debug_leave()  mtk_v4l2_debug(3, "-")
>  
> @@ -57,22 +61,16 @@ extern bool mtk_vcodec_dbg;
>  				__func__, ##args);			\
>  	} while (0)
>  
> -#define mtk_vcodec_err(h, fmt, args...)					\
> -	pr_err("[MTK_VCODEC][ERROR][%d]: %s() " fmt "\n",		\
> -	       ((struct mtk_vcodec_ctx *)h->ctx)->id, __func__, ##args)
> -
>  #define mtk_vcodec_debug_enter(h)  mtk_vcodec_debug(h, "+")
>  #define mtk_vcodec_debug_leave(h)  mtk_vcodec_debug(h, "-")
>  
>  #else
>  
>  #define mtk_v4l2_debug(level, fmt, args...) {}
> -#define mtk_v4l2_err(fmt, args...) {}
>  #define mtk_v4l2_debug_enter() {}
>  #define mtk_v4l2_debug_leave() {}
>  
>  #define mtk_vcodec_debug(h, fmt, args...) {}
> -#define mtk_vcodec_err(h, fmt, args...) {}
>  #define mtk_vcodec_debug_enter(h) {}
>  #define mtk_vcodec_debug_leave(h) {}
>  
