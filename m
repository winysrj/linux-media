Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:64335 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754635AbdDELKE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 07:10:04 -0400
Message-ID: <1491390599.32502.1.camel@mtksdaap41>
Subject: Re: [PATCH] media: mtk-vcodec: remove informative log
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Date: Wed, 5 Apr 2017 19:09:59 +0800
In-Reply-To: <1491389669-32737-1-git-send-email-minghsiu.tsai@mediatek.com>
References: <1491389669-32737-1-git-send-email-minghsiu.tsai@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-04-05 at 18:54 +0800, Minghsiu Tsai wrote:
> Driver is stable. Remove DEBUG definition from driver.
> 
> There are debug message in /var/log/messages if DEBUG is defined,
> such as:
> [MTK_V4L2] level=0 fops_vcodec_open(),170: decoder capability 0
> [MTK_V4L2] level=0 fops_vcodec_open(),177: 16000000.vcodec decoder [0]
> [MTK_V4L2] level=0 fops_vcodec_release(),200: [0] decoder
> 
> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Acked-by:Tiffany Lin <Tiffany.lin@mediatek.com>

> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> index 7d55975..1248083 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> @@ -31,7 +31,6 @@ struct mtk_vcodec_mem {
>  extern int mtk_v4l2_dbg_level;
>  extern bool mtk_vcodec_dbg;
>  
> -#define DEBUG	1
>  
>  #if defined(DEBUG)
>  
