Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35168 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757193AbdJKNZQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 09:25:16 -0400
Subject: Re: [PATCH] [media] vimc: Fix return value check in
 vimc_add_subdevs()
To: Wei Yongjun <weiyongjun1@huawei.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
References: <1507720603-128932-1-git-send-email-weiyongjun1@huawei.com>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <8a810b75-c0d3-5bb9-9712-bf72f5daa200@collabora.com>
Date: Wed, 11 Oct 2017 10:25:09 -0300
MIME-Version: 1.0
In-Reply-To: <1507720603-128932-1-git-send-email-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,


On 2017-10-11 08:16 AM, Wei Yongjun wrote:
> In case of error, the function platform_device_register_data() returns
> ERR_PTR() and never returns NULL. The NULL test in the return value check
> should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/media/platform/vimc/vimc-core.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
> index 51c0eee..fe088a9 100644
> --- a/drivers/media/platform/vimc/vimc-core.c
> +++ b/drivers/media/platform/vimc/vimc-core.c
> @@ -267,11 +267,12 @@ static struct component_match *vimc_add_subdevs(struct vimc_device *vimc)
>  						PLATFORM_DEVID_AUTO,
>  						&pdata,
>  						sizeof(pdata));
> -		if (!vimc->subdevs[i]) {
> +		if (IS_ERR(vimc->subdevs[i])) {
> +			match = ERR_CAST(vimc->subdevs[i]);
>  			while (--i >= 0)
>  				platform_device_unregister(vimc->subdevs[i]);
>  
> -			return ERR_PTR(-ENOMEM);
> +			return match;
>  		}
>  
>  		component_match_add(&vimc->pdev.dev, &match, vimc_comp_compare,
> 
> 
> 

Nice catch, thanks, looks good to me

Acked-by: Helen Koike <helen.koike@collabora.com>
