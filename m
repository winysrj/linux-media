Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:44908 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751824AbeCMSnL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:43:11 -0400
Subject: Re: [PATCH 1/3] rcar-vin: remove duplicated check of state in irq
 handler
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com
References: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
 <20180310000953.25366-2-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <17a2486d-5a99-3511-c7b6-a50001fd0e7e@xs4all.nl>
Date: Tue, 13 Mar 2018 11:43:03 -0700
MIME-Version: 1.0
In-Reply-To: <20180310000953.25366-2-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/2018 04:09 PM, Niklas Söderlund wrote:
> This is an error from when the driver where converted from soc-camera.

where -> was

> There is absolutely no gain to check the state variable two times to be
> extra sure if the hardware is stopped.

I'll wait for v2 before applying this.

Regards,

	Hans

> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index 23fdff7a7370842e..b4be75d5009080f7 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -916,12 +916,6 @@ static irqreturn_t rvin_irq(int irq, void *data)
>  	rvin_ack_interrupt(vin);
>  	handled = 1;
>  
> -	/* Nothing to do if capture status is 'STOPPED' */
> -	if (vin->state == STOPPED) {
> -		vin_dbg(vin, "IRQ while state stopped\n");
> -		goto done;
> -	}
> -
>  	/* Nothing to do if capture status is 'STOPPING' */
>  	if (vin->state == STOPPING) {
>  		vin_dbg(vin, "IRQ while state stopping\n");
> 
