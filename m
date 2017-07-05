Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38072 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbdGEFfk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Jul 2017 01:35:40 -0400
Received: by mail-wm0-f52.google.com with SMTP id f67so100843113wmh.1
        for <linux-media@vger.kernel.org>; Tue, 04 Jul 2017 22:35:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170705053348.2865-1-hiroh@chromium.org>
References: <20170705053348.2865-1-hiroh@chromium.org>
From: Hirokazu Honda <hiroh@chromium.org>
Date: Wed, 5 Jul 2017 14:35:38 +0900
Message-ID: <CAO5uPHN_6yTYw2DzCinV_AC11vYC5bKqYEH-8kJw+m=Dcxc2PQ@mail.gmail.com>
Subject: Re: [PATCH v3] [media] mtk-vcodec: Show mtk driver error without
 DEBUG definition
To: Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Hirokazu Honda <hiroh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixing whitespace in the previous patch.

On Wed, Jul 5, 2017 at 2:33 PM, Hirokazu Honda <hiroh@chromium.org> wrote:
> A driver error message is shown without DEBUG definition
> to find an error and debug easily.
>
> Signed-off-by: Hirokazu Honda <hiroh@chromium.org>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> index 237e144c194f..c1378c1b402c 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> @@ -32,6 +32,15 @@ extern int mtk_v4l2_dbg_level;
>  extern bool mtk_vcodec_dbg;
>
>
> +#define mtk_v4l2_err(fmt, args...)                                     \
> +       pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
> +              ##args)
> +
> +#define mtk_vcodec_err(h, fmt, args...)                                        \
> +       pr_err("[MTK_VCODEC][ERROR][%d]: %s() " fmt "\n",               \
> +              ((struct mtk_vcodec_ctx *)h->ctx)->id, __func__, ##args)
> +
> +
>  #if defined(DEBUG)
>
>  #define mtk_v4l2_debug(level, fmt, args...)                             \
> @@ -41,11 +50,6 @@ extern bool mtk_vcodec_dbg;
>                                 level, __func__, __LINE__, ##args);      \
>         } while (0)
>
> -#define mtk_v4l2_err(fmt, args...)                \
> -       pr_err("[MTK_V4L2][ERROR] %s:%d: " fmt "\n", __func__, __LINE__, \
> -              ##args)
> -
> -
>  #define mtk_v4l2_debug_enter()  mtk_v4l2_debug(3, "+")
>  #define mtk_v4l2_debug_leave()  mtk_v4l2_debug(3, "-")
>
> @@ -57,22 +61,16 @@ extern bool mtk_vcodec_dbg;
>                                 __func__, ##args);                      \
>         } while (0)
>
> -#define mtk_vcodec_err(h, fmt, args...)                                        \
> -       pr_err("[MTK_VCODEC][ERROR][%d]: %s() " fmt "\n",               \
> -              ((struct mtk_vcodec_ctx *)h->ctx)->id, __func__, ##args)
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
> --
> 2.13.2.725.g09c95d1e9-goog
>
