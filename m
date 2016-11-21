Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:16514 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753240AbcKULQw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 06:16:52 -0500
Message-ID: <1479726989.25126.2.camel@mtksdaap41>
Subject: Re: [PATCH] [media] VPU: mediatek: fix dereference of pdev before
 checking it is null
From: andrew-ct chen <andrew-ct.chen@mediatek.com>
To: Colin King <colin.king@canonical.com>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Wei Yongjun" <yongjun_wei@trendmicro.com.cn>,
        <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 21 Nov 2016 19:16:29 +0800
In-Reply-To: <20161116191650.11486-1-colin.king@canonical.com>
References: <20161116191650.11486-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2016-11-16 at 19:16 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> pdev is dereferenced using platform_get_drvdata before a check to
> see if it is null, hence there could be a potential null pointer
> dereference issue. Instead, first check if pdev is null and only then
> deference pdev when initializing vpu.
> 
> Found with static analysis by CoverityScan, CID 1357797
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

Reviewed-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>

>  drivers/media/platform/mtk-vpu/mtk_vpu.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vpu/mtk_vpu.c b/drivers/media/platform/mtk-vpu/mtk_vpu.c
> index c9bf58c..41f31b2 100644
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
> @@ -533,6 +533,8 @@ int vpu_load_firmware(struct platform_device *pdev)
>  		dev_err(dev, "VPU platform device is invalid\n");
>  		return -EINVAL;
>  	}
> +	vpu = platform_get_drvdata(pdev);
> +	run = &vpu->run;
>  
>  	mutex_lock(&vpu->vpu_mutex);
>  	if (vpu->fw_loaded) {


