Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:34504 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162547AbdEXJBz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 05:01:55 -0400
Received: by mail-lf0-f49.google.com with SMTP id 99so63370439lfu.1
        for <linux-media@vger.kernel.org>; Wed, 24 May 2017 02:01:49 -0700 (PDT)
Subject: Re: [PATCH v2 17/17] rcar-vin: fix bug in pixelformat selection
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
 <20170524001540.13613-18-niklas.soderlund@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <9d780f84-ca1b-dda1-b5ec-36265d52c330@cogentembedded.com>
Date: Wed, 24 May 2017 12:01:45 +0300
MIME-Version: 1.0
In-Reply-To: <20170524001540.13613-18-niklas.soderlund@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 5/24/2017 3:15 AM, Niklas Söderlund wrote:

> From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>
> If the requested pixelformat is not supported fallback to the default
> format, do not revert the entire format.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index de71e5fa8b10cb5e..81ff59c3b4744075 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
[...]
> @@ -218,17 +217,11 @@ static int __rvin_try_format(struct rvin_dev *vin,
>  	if (pix->field == V4L2_FIELD_ANY)
>  		pix->field = vin->format.field;
>
> -	/*
> -	 * Retrieve format information and select the current format if the
> -	 * requested format isn't supported.
> -	 */
> -	info = rvin_format_from_pixel(pix->pixelformat);
> -	if (!info) {
> -		vin_dbg(vin, "Format %x not found, keeping %x\n",
> -			pix->pixelformat, vin->format.pixelformat);
> -		*pix = vin->format;
> -		pix->width = rwidth;
> -		pix->height = rheight;
> +	/* If requested format is not supported fallback to the default */
> +	if (!rvin_format_from_pixel(pix->pixelformat)) {
> +		vin_dbg(vin, "Format 0x%x not found, using default 0x%x\n",

     s/0x%x/%#x/, maybe?

> +			pix->pixelformat, RVIN_DEFAULT_FORMAT);
> +		pix->pixelformat = RVIN_DEFAULT_FORMAT;
>  	}
>
>  	/* Always recalculate */

MBR, Sergei
