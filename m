Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49922 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbeG1TQs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Jul 2018 15:16:48 -0400
Subject: Re: [PATCH] media: vimc: Remove redundant free
To: Anton Vasilyev <vasilyev@ispras.ru>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
References: <20180727114759.10601-1-vasilyev@ispras.ru>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <653fb6f2-a7a6-c123-7df0-1b1c8ab34fbf@collabora.com>
Date: Sat, 28 Jul 2018 14:49:03 -0300
MIME-Version: 1.0
In-Reply-To: <20180727114759.10601-1-vasilyev@ispras.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anton,

Thanks for the patch

On 07/27/2018 08:47 AM, Anton Vasilyev wrote:
> Commit 4a29b7090749 ("[media] vimc: Subdevices as modules") removes
> vimc allocation from vimc_probe(), so corresponding deallocation
> on the error path tries to free static memory.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>

Acked-by: Helen Koike <helen.koike@collabora.com>

> ---
>  drivers/media/platform/vimc/vimc-core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
> index fe088a953860..9246f265de31 100644
> --- a/drivers/media/platform/vimc/vimc-core.c
> +++ b/drivers/media/platform/vimc/vimc-core.c
> @@ -328,7 +328,6 @@ static int vimc_probe(struct platform_device *pdev)
>  	if (ret) {
>  		media_device_cleanup(&vimc->mdev);
>  		vimc_rm_subdevs(vimc);
> -		kfree(vimc);
>  		return ret;
>  	}
>  
> 

Regards,
Helen
