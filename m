Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41561 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbeCMQmb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 12:42:31 -0400
Subject: Re: [PATCH 1/3] rcar-vin: remove duplicated check of state in irq
 handler
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com
References: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
 <20180310000953.25366-2-niklas.soderlund+renesas@ragnatech.se>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <a6fa3bbf-52e5-5576-fbea-3a280a1c8bb1@ideasonboard.com>
Date: Tue, 13 Mar 2018 17:42:25 +0100
MIME-Version: 1.0
In-Reply-To: <20180310000953.25366-2-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

Thanks for the patch series :) - I've been looking forward to seeing this one !

On 10/03/18 01:09, Niklas Söderlund wrote:
> This is an error from when the driver where converted from soc-camera.
> There is absolutely no gain to check the state variable two times to be
> extra sure if the hardware is stopped.

I'll not say this isn't a redundant check ... but isn't the check against two
different states, and thus the remaining check doesn't actually catch the case
now where state == STOPPED ?

(Perhaps state != RUNNING would be better ?, but I haven't checked the rest of
the code)

--
Kieran


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
