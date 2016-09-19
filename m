Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:26794 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751774AbcISJDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 05:03:12 -0400
Message-ID: <1474275785.11360.0.camel@mtksdaap41>
Subject: Re: [PATCH] mtk-mdp: fix double mutex_unlock
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Mon, 19 Sep 2016 17:03:05 +0800
In-Reply-To: <5125bca3-0dfa-2e56-d44f-d771af0b9ca8@xs4all.nl>
References: <5125bca3-0dfa-2e56-d44f-d771af0b9ca8@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2016-09-19 at 10:00 +0200, Hans Verkuil wrote:
> Fix smatch error:
> 
> media-git/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c:100 mtk_mdp_vpu_send_msg() error: double unlock 'mutex:&ctx->mdp_dev->vpulock'
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>


Reviewed-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>

> ---
> diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c b/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
> index 39188e5..4893825 100644
> --- a/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
> +++ b/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
> @@ -92,11 +92,9 @@ static int mtk_mdp_vpu_send_msg(void *msg, int len, struct mtk_mdp_vpu *vpu,
> 
>  	mutex_lock(&ctx->mdp_dev->vpulock);
>  	err = vpu_ipi_send(vpu->pdev, (enum ipi_id)id, msg, len);
> -	if (err) {
> -		mutex_unlock(&ctx->mdp_dev->vpulock);
> +	if (err)
>  		dev_err(&ctx->mdp_dev->pdev->dev,
>  			"vpu_ipi_send fail status %d\n", err);
> -	}
>  	mutex_unlock(&ctx->mdp_dev->vpulock);
> 
>  	return err;
> 


