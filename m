Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:48776 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932352AbeE2JCG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 05:02:06 -0400
Subject: Re: [PATCH v5 04/10] media: rcar-vin: Cleanup notifier in error path
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527583688-314-5-git-send-email-jacopo+renesas@jmondi.org>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reply-To: kieran.bingham@ideasonboard.com
Message-ID: <d37e437a-81fa-2649-4659-5b0b05419c1f@ideasonboard.com>
Date: Tue, 29 May 2018 10:02:01 +0100
MIME-Version: 1.0
In-Reply-To: <1527583688-314-5-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thankyou for the patch,

On 29/05/18 09:48, Jacopo Mondi wrote:
> During the notifier initialization, memory for the list of associated async
> subdevices is reserved during the fwnode endpoint parsing from the v4l2-async
> framework. If the notifier registration fails, that memory should be released
> and the notifier 'cleaned up'.
> 
> Catch the notifier registration error and perform the cleanup both for the
> group and the parallel notifiers.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> ---
> v5:
> - new patch
> 
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index d3aadf3..f7a28e9 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -573,10 +573,15 @@ static int rvin_parallel_graph_init(struct rvin_dev *vin)
>  	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
>  	if (ret < 0) {
>  		vin_err(vin, "Notifier registration failed\n");
> -		return ret;
> +		goto error_notifier_cleanup;
>  	}
> 
>  	return 0;
> +
> +error_notifier_cleanup:
> +	v4l2_async_notifier_cleanup(&vin->group->notifier);

Wouldn't it be less lines to just call the cleanup before the return? Or do you
anticipate multiple paths needing to call through the clean up here ?

> +
> +	return ret;
>  }
> 
>  /* -----------------------------------------------------------------------------
> @@ -775,10 +780,15 @@ static int rvin_mc_parse_of_graph(struct rvin_dev *vin)
>  					   &vin->group->notifier);
>  	if (ret < 0) {
>  		vin_err(vin, "Notifier registration failed\n");
> -		return ret;
> +		goto error_notifier_cleanup;
>  	}
> 
>  	return 0;
> +
> +error_notifier_cleanup:
> +	v4l2_async_notifier_cleanup(&vin->group->notifier);
> +

Same here...

> +	return ret;
>  }
> 
>  static int rvin_mc_init(struct rvin_dev *vin)
> --
> 2.7.4
> 
