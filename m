Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:32955 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753684AbcICSHg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2016 14:07:36 -0400
Received: by mail-lf0-f43.google.com with SMTP id b199so103553486lfe.0
        for <linux-media@vger.kernel.org>; Sat, 03 Sep 2016 11:07:35 -0700 (PDT)
Subject: Re: [PATCHv3 06/10] [media] rcar-vin: do not use
 v4l2_device_call_until_err()
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
        hverkuil@xs4all.nl
References: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
 <20160815150635.22637-7-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <b9fb37cc-fe75-f6e4-8d37-3eecea5d8fc8@cogentembedded.com>
Date: Sat, 3 Sep 2016 21:07:32 +0300
MIME-Version: 1.0
In-Reply-To: <20160815150635.22637-7-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/2016 06:06 PM, Niklas Söderlund wrote:

> Fix a error from the original driver where v4l2_device_call_until_err()
> where used for the pad specific v4l2 operation set_fmt.  Also fix up the
> error path from this fix so if there is an error it will be propagated
> to the caller.

> The error path label have also been renamed as a result from a
> nitpicking review comment since we are fixing other issues here.

    This looks like a material for the 2 or even 3 separate patches...

> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 72fe6bc..3f80a0b 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -114,10 +114,9 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
>
>  	format.pad = vin->src_pad_idx;
>
> -	ret = v4l2_device_call_until_err(sd->v4l2_dev, 0, pad, set_fmt,
> -					 pad_cfg, &format);
> -	if (ret < 0)
> -		goto cleanup;
> +	ret = v4l2_subdev_call(sd, pad, set_fmt, pad_cfg, &format);
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		goto done;
>
>  	v4l2_fill_pix_format(pix, &format.format);
>
> @@ -127,9 +126,9 @@ static int __rvin_try_format_source(struct rvin_dev *vin,
>  	vin_dbg(vin, "Source resolution: %ux%u\n", source->width,
>  		source->height);
>
> -cleanup:
> +done:
>  	v4l2_subdev_free_pad_config(pad_cfg);
> -	return 0;
> +	return ret;
>  }
>
>  static int __rvin_try_format(struct rvin_dev *vin,

MBR, Sergei

