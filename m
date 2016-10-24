Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:13386 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932203AbcJXDuA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 23:50:00 -0400
Message-ID: <1477280975.10501.16.camel@mtksdaap41>
Subject: Re: FW: [PATCH] mtk-vcodec: fix some smatch warnings
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: <daniel.thompson@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Mon, 24 Oct 2016 11:49:35 +0800
In-Reply-To: <6D1A1B40F9E1B64689A7C1952F8B336792FED2F0@mtkmbs08n1>
References: <066110a3574ef835ba47a0996343474288da72cc.1477058315.git.mchehab@s-opensource.com>
         <6D1A1B40F9E1B64689A7C1952F8B336792FED2F0@mtkmbs08n1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> Fix this bug:
> 	drivers/media/platform/mtk-vcodec/vdec_drv_if.c:38 vdec_if_init() info: ignoring unreachable code.
> 
> With is indeed a real problem that prevents the driver to work!
> 
> While here, also remove an used var, as reported by smatch:
> 
> 	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c: In function 'mtk_vcodec_init_dec_pm':
> 	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c:29:17: warning: variable 'dev' set but not used [-Wunused-but-set-variable]
> 	  struct device *dev;
> 	                 ^~~
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c | 2 --
>  drivers/media/platform/mtk-vcodec/vdec_drv_if.c       | 1 +
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
> index 18182f5676d8..79ca03ac449c 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
> @@ -26,14 +26,12 @@ int mtk_vcodec_init_dec_pm(struct mtk_vcodec_dev *mtkdev)  {
>  	struct device_node *node;
>  	struct platform_device *pdev;
> -	struct device *dev;
>  	struct mtk_vcodec_pm *pm;
>  	int ret = 0;
>  
>  	pdev = mtkdev->plat_dev;
>  	pm = &mtkdev->pm;
>  	pm->mtkdev = mtkdev;
> -	dev = &pdev->dev;
>  	node = of_parse_phandle(pdev->dev.of_node, "mediatek,larb", 0);
>  	if (!node) {
>  		mtk_v4l2_err("of_parse_phandle mediatek,larb fail!"); diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_if.c b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
> index 3cb04ef45144..9813b2ffd5fa 100644
> --- a/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
> +++ b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
> @@ -31,6 +31,7 @@ int vdec_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
>  	switch (fourcc) {
>  	case V4L2_PIX_FMT_H264:
>  	case V4L2_PIX_FMT_VP8:
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> --
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html


