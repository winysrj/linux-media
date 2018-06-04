Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35654 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbeFDMnI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:43:08 -0400
Received: by mail-lf0-f68.google.com with SMTP id y72-v6so24962726lfd.2
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:43:07 -0700 (PDT)
Date: Mon, 4 Jun 2018 14:43:05 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v5 04/10] media: rcar-vin: Cleanup notifier in error path
Message-ID: <20180604124305.GJ19674@bigcity.dyn.berto.se>
References: <1527583688-314-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527583688-314-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1527583688-314-5-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work.

On 2018-05-29 10:48:02 +0200, Jacopo Mondi wrote:
> During the notifier initialization, memory for the list of associated async
> subdevices is reserved during the fwnode endpoint parsing from the v4l2-async
> framework. If the notifier registration fails, that memory should be released
> and the notifier 'cleaned up'.
> 
> Catch the notifier registration error and perform the cleanup both for the
> group and the parallel notifiers.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

I agree with Kieran's review comment that it's better to call 
v4l2_async_notifier_cleanup() directly instead of adding a goto. With 
that fixed feel free to add

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

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
> +	return ret;
>  }
> 
>  static int rvin_mc_init(struct rvin_dev *vin)
> --
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
