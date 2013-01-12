Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:46795 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813Ab3ALLmm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Jan 2013 06:42:42 -0500
Date: Sat, 12 Jan 2013 11:42:40 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] iguanair: intermittent initialization
 failure
Message-ID: <20130112114240.GA1784@pequod.mess.org>
References: <1357492785-30966-1-git-send-email-sean@mess.org>
 <1357492785-30966-3-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357492785-30966-3-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 06, 2013 at 05:19:45PM +0000, Sean Young wrote:
> Sometimes the first version request is sent before the device has fully
> initialized. This seems to happen on some hardware during boot when the
> iguanair is plugged into a root hub.
> 
> Signed-off-by: Sean Young <sean@mess.org>

Mauro, please ignore this patch. I've found the cause in the firmware and
I've got a better way of solving this.

Thanks
Sean

> ---
>  drivers/media/rc/iguanair.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
> index a569c69..bc3557b 100644
> --- a/drivers/media/rc/iguanair.c
> +++ b/drivers/media/rc/iguanair.c
> @@ -224,6 +224,14 @@ static int iguanair_get_features(struct iguanair *ir)
>  	ir->packet->header.cmd = CMD_GET_VERSION;
>  
>  	rc = iguanair_send(ir, sizeof(ir->packet->header));
> +
> +	/*
> +	 * We might have sent the command before the device had time to
> +	 * initialize. Retry if we got no response.
> +	 */
> +	if (rc == -ETIMEDOUT)
> +		rc = iguanair_send(ir, sizeof(ir->packet->header));
> +
>  	if (rc) {
>  		dev_info(ir->dev, "failed to get version\n");
>  		goto out;
> @@ -255,19 +263,14 @@ static int iguanair_get_features(struct iguanair *ir)
>  	ir->packet->header.cmd = CMD_GET_FEATURES;
>  
>  	rc = iguanair_send(ir, sizeof(ir->packet->header));
> -	if (rc) {
> +	if (rc)
>  		dev_info(ir->dev, "failed to get features\n");
> -		goto out;
> -	}
> -
>  out:
>  	return rc;
>  }
>  
>  static int iguanair_receiver(struct iguanair *ir, bool enable)
>  {
> -	int rc;
> -
>  	ir->packet->header.start = 0;
>  	ir->packet->header.direction = DIR_OUT;
>  	ir->packet->header.cmd = enable ? CMD_RECEIVER_ON : CMD_RECEIVER_OFF;
> @@ -275,9 +278,7 @@ static int iguanair_receiver(struct iguanair *ir, bool enable)
>  	if (enable)
>  		ir_raw_event_reset(ir->rc);
>  
> -	rc = iguanair_send(ir, sizeof(ir->packet->header));
> -
> -	return rc;
> +	return iguanair_send(ir, sizeof(ir->packet->header));
>  }
>  
>  /*
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
