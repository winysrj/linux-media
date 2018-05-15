Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60046 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752253AbeEOJ1E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 05:27:04 -0400
Subject: Re: [PATCH v2 2/2] rcar-vin: fix crop and compose handling for Gen3
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180511144126.24804-1-niklas.soderlund+renesas@ragnatech.se>
 <20180511144126.24804-3-niklas.soderlund+renesas@ragnatech.se>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <746b2859-b064-c91e-00a6-7f2537a24ab2@ideasonboard.com>
Date: Tue, 15 May 2018 10:27:00 +0100
MIME-Version: 1.0
In-Reply-To: <20180511144126.24804-3-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

This looks like quite the improvement :D

On 11/05/18 15:41, Niklas Söderlund wrote:
> When refactoring the Gen3 enablement series crop and compose handling
> where broken. This went unnoticed but can result in writing out side the

As well as Sergei's 'where/were', 'out side' is one word in this context.

'outside of the capture buffer'

> capture buffer. Fix this by restoring the crop and compose to reflect
> the format dimensions as we have not yet enabled the scaler for Gen3.
> 
> Fixes: 5e7c623632fcf8f5 ("media: rcar-vin: use different v4l2 operations in media controller mode")
> Reported-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 2fb8587116f25a4f..e78fba84d59028ef 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -702,6 +702,12 @@ static int rvin_mc_s_fmt_vid_cap(struct file *file, void *priv,
>  
>  	vin->format = f->fmt.pix;
>  
> +	vin->crop.top = 0;
> +	vin->crop.left = 0;
> +	vin->crop.width = vin->format.width;
> +	vin->crop.height = vin->format.height;
> +	vin->compose = vin->crop;
> +
>  	return 0;
>  }
>  
> 
