Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35963 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751023AbdCOJM0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 05:12:26 -0400
Received: by mail-lf0-f54.google.com with SMTP id y193so4151997lfd.3
        for <linux-media@vger.kernel.org>; Wed, 15 Mar 2017 02:12:25 -0700 (PDT)
Subject: Re: [PATCH 03/16] rcar-vin: fix how pads are handled for v4l2
 subdevice operations
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <20170314185957.25253-1-niklas.soderlund+renesas@ragnatech.se>
 <20170314185957.25253-4-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <1fcdfc89-6c85-3863-6fd0-e6db4ec9072c@cogentembedded.com>
Date: Wed, 15 Mar 2017 12:12:21 +0300
MIME-Version: 1.0
In-Reply-To: <20170314185957.25253-4-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 3/14/2017 9:59 PM, Niklas Söderlund wrote:

> The rcar-vin driver only uses one pad, pad number 0.
>
> - All v4l2 operations that did not check that the requested operation
>   was for pad 0 have been updated with a check to enforce this.
>
> - All v4l2 operations that stored (and later restore) the requested pad

    Restored?

>   before substituting it for the subdevice pad number have been updated
>   to not store the incoming pad and simply restore it to 0 after the
>   subdevice operation is complete.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 7ca27599b9982ffc..610f59e2a9142622 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -550,14 +550,16 @@ static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
>  {
>  	struct rvin_dev *vin = video_drvdata(file);
>  	struct v4l2_subdev *sd = vin_to_source(vin);
> -	int pad, ret;
> +	int ret;
> +
> +	if (timings->pad)
> +		return -EINVAL;
>
> -	pad = timings->pad;
>  	timings->pad = vin->sink_pad_idx;
>
>  	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);

    Does this still compile after you removed 'pad'?

>
> -	timings->pad = pad;
> +	timings->pad = 0;
>
>  	return ret;
>  }
> @@ -600,14 +602,16 @@ static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
>  {
>  	struct rvin_dev *vin = video_drvdata(file);
>  	struct v4l2_subdev *sd = vin_to_source(vin);
> -	int pad, ret;
> +	int ret;
> +
> +	if (cap->pad)
> +		return -EINVAL;
>
> -	pad = cap->pad;
>  	cap->pad = vin->sink_pad_idx;
>
>  	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);

    And this?

>
> -	cap->pad = pad;
> +	cap->pad = 0;
>
>  	return ret;
>  }
[...]

MBR, Sergei
