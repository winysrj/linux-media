Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:63935 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932448AbcGLLVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 07:21:53 -0400
Message-ID: <1468322502.2462.8.camel@mtksdaap41>
Subject: Re: [PATCH -next] [media] vcodec: mediatek: Fix return value check
 in mtk_vcodec_init_enc_pm()
From: tiffany lin <tiffany.lin@mediatek.com>
To: <weiyj_lk@163.com>
CC: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Wei Yongjun" <yongjun_wei@trendmicro.com.cn>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>
Date: Tue, 12 Jul 2016 19:21:42 +0800
In-Reply-To: <1468321348-16045-1-git-send-email-weiyj_lk@163.com>
References: <1468321348-16045-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by:Tiffany Lin <tiffany.lin@mediatek.com>

On Tue, 2016-07-12 at 11:02 +0000, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, the function devm_clk_get() returns ERR_PTR()
> and not returns NULL. The NULL test in the return value check
> should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
> index 2379e97..3e73e9d 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
> @@ -67,27 +67,27 @@ int mtk_vcodec_init_enc_pm(struct mtk_vcodec_dev *mtkdev)
>  	pm->dev = &pdev->dev;
>  
>  	pm->vencpll_d2 = devm_clk_get(&pdev->dev, "venc_sel_src");
> -	if (pm->vencpll_d2 == NULL) {
> +	if (IS_ERR(pm->vencpll_d2)) {
>  		mtk_v4l2_err("devm_clk_get vencpll_d2 fail");
> -		ret = -1;
> +		ret = PTR_ERR(pm->vencpll_d2);
>  	}
>  
>  	pm->venc_sel = devm_clk_get(&pdev->dev, "venc_sel");
> -	if (pm->venc_sel == NULL) {
> +	if (IS_ERR(pm->venc_sel)) {
>  		mtk_v4l2_err("devm_clk_get venc_sel fail");
> -		ret = -1;
> +		ret = PTR_ERR(pm->venc_sel);
>  	}
>  
>  	pm->univpll1_d2 = devm_clk_get(&pdev->dev, "venc_lt_sel_src");
> -	if (pm->univpll1_d2 == NULL) {
> +	if (IS_ERR(pm->univpll1_d2)) {
>  		mtk_v4l2_err("devm_clk_get univpll1_d2 fail");
> -		ret = -1;
> +		ret = PTR_ERR(pm->univpll1_d2);
>  	}
>  
>  	pm->venc_lt_sel = devm_clk_get(&pdev->dev, "venc_lt_sel");
> -	if (pm->venc_lt_sel == NULL) {
> +	if (IS_ERR(pm->venc_lt_sel)) {
>  		mtk_v4l2_err("devm_clk_get venc_lt_sel fail");
> -		ret = -1;
> +		ret = PTR_ERR(pm->venc_lt_sel);
>  	}
>  
>  	return ret;
> 
> 


