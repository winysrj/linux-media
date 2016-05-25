Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:32932 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbcEYTgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 15:36:08 -0400
Received: by mail-lf0-f50.google.com with SMTP id e131so22653115lfb.0
        for <linux-media@vger.kernel.org>; Wed, 25 May 2016 12:36:07 -0700 (PDT)
Subject: Re: [PATCH 8/8] [media] rcar-vin: add Gen2 and Gen3 fallback
 compatibility strings
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
	linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
	hverkuil@xs4all.nl
References: <1464203409-1279-1-git-send-email-niklas.soderlund@ragnatech.se>
 <1464203409-1279-9-git-send-email-niklas.soderlund@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org,
	=?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <26f0ba3a-2324-23ce-0933-452fe7e16542@cogentembedded.com>
Date: Wed, 25 May 2016 22:36:02 +0300
MIME-Version: 1.0
In-Reply-To: <1464203409-1279-9-git-send-email-niklas.soderlund@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/25/2016 10:10 PM, Niklas Söderlund wrote:

> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>
> These are present in the soc-camera version of this driver and it's time
> to add them to this driver as well.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 520690c..87041db 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -33,6 +33,8 @@ static const struct of_device_id rvin_of_id_table[] = {
>  	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
>  	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
>  	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> +	{ .compatible = "renesas,rcar-gen3-vin", .data = (void *)RCAR_GEN3 },
> +	{ .compatible = "renesas,rcar-gen2-vin", .data = (void *)RCAR_GEN2 },

    What's the point of adding the H3 specific compatibility string in the 
previous patch then? The fallback stings were added not have to updated the 
driver for every new SoC exactly.

MBR, Sergei

