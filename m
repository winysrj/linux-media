Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:12471 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752096AbcIHGRT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 02:17:19 -0400
Message-ID: <1473312106.22713.1.camel@mtksdaap41>
Subject: Re: [PATCH] [media] VPU: mediatek: fix null pointer dereference on
 pdev
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Colin King <colin.king@canonical.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Wei Yongjun" <yongjun_wei@trendmicro.com.cn>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 8 Sep 2016 13:21:46 +0800
In-Reply-To: <20160907171027.16424-1-colin.king@canonical.com>
References: <20160907171027.16424-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2016-09-07 at 18:10 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> pdev is being null checked, however, prior to that it is being
> dereferenced by platform_get_drvdata.  Move the assignments of
> vpu and run to after the pdev null check to avoid a potential
> null pointer dereference.
> 

Reviewed-by:Tiffany Lin <tiffany.lin@mediatek.com>

> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/media/platform/mtk-vpu/mtk_vpu.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
> index c9bf58c..43907a3 100644
> --- a/drivers/media/platform/mtk-vpu/mtk_vpu.c
> +++ b/drivers/media/platform/mtk-vpu/mtk_vpu.c
> @@ -523,9 +523,9 @@ static int load_requested_vpu(struct mtk_vpu *vpu,
>  
>  int vpu_load_firmware(struct platform_device *pdev)
>  {
> -	struct mtk_vpu *vpu = platform_get_drvdata(pdev);
> +	struct mtk_vpu *vpu;
>  	struct device *dev = &pdev->dev;
> -	struct vpu_run *run = &vpu->run;
> +	struct vpu_run *run;
>  	const struct firmware *vpu_fw = NULL;
>  	int ret;
>  
> @@ -534,6 +534,9 @@ int vpu_load_firmware(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> +	vpu = platform_get_drvdata(pdev);
> +	run = &vpu->run;
> +
>  	mutex_lock(&vpu->vpu_mutex);
>  	if (vpu->fw_loaded) {
>  		mutex_unlock(&vpu->vpu_mutex);


