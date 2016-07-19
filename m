Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34302 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbcGSQsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 12:48:32 -0400
Received: by mail-lf0-f47.google.com with SMTP id l69so19418947lfg.1
        for <linux-media@vger.kernel.org>; Tue, 19 Jul 2016 09:48:31 -0700 (PDT)
Subject: Re: [PATCHv2 04/16] [media] rcar-vin: return correct error from
 platform_get_irq
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
References: <20160719142107.22358-1-niklas.soderlund+renesas@ragnatech.se>
 <20160719142107.22358-5-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <d08dada8-1ff2-de7f-aaac-7193a283102e@cogentembedded.com>
Date: Tue, 19 Jul 2016 19:48:27 +0300
MIME-Version: 1.0
In-Reply-To: <20160719142107.22358-5-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 07/19/2016 05:20 PM, Niklas Söderlund wrote:

> Fix a error from the original driver where the wrong error code is
> returned if the driver fails to get a IRQ number from
> platform_get_irq().
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 481d82a..ff27d75 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -318,7 +318,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
>
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq <= 0)
> -		return ret;
> +		return irq;

    This is still wrong, i.e. it'll return 0 from the probe() method if 'irq' 
is 0 (and you consider that an error).

[...]

MBR, Sergei

