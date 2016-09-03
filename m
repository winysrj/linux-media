Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:34319 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753168AbcICSgW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2016 14:36:22 -0400
Received: by mail-lf0-f48.google.com with SMTP id p41so85059227lfi.1
        for <linux-media@vger.kernel.org>; Sat, 03 Sep 2016 11:36:22 -0700 (PDT)
Subject: Re: [PATCHv3 05/10] [media] rcar-vin: return correct error from
 platform_get_irq()
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
        hverkuil@xs4all.nl
References: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
 <20160815150635.22637-6-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <50ff0f14-f11a-043d-11e4-7d2a06ae698f@cogentembedded.com>
Date: Sat, 3 Sep 2016 21:36:18 +0300
MIME-Version: 1.0
In-Reply-To: <20160815150635.22637-6-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/2016 06:06 PM, Niklas Söderlund wrote:

> Fix a error from the original driver where the wrong error code is
> returned if the driver fails to get a IRQ number from
> platform_get_irq().
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index a1eb26b..3941134 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -282,8 +282,8 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  		return PTR_ERR(vin->base);
>
>  	irq = platform_get_irq(pdev, 0);
> -	if (irq <= 0)
> -		return ret;
> +	if (irq < 0)

    You don't explain this change. It's OK however (my patch fixing this 
function not to return 0 on error is in GregKH's driver-core-next tree).

> +		return irq;
>
>  	ret = rvin_dma_probe(vin, irq);
>  	if (ret)

MBR, Sergei

