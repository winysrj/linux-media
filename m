Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:63867 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3DTVFr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 17:05:47 -0400
Message-ID: <51730324.8090403@gmail.com>
Date: Sat, 20 Apr 2013 23:05:40 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH 1/5] V4L2: I2C: ML86V7667 video decoder driver
References: <201304210013.46110.sergei.shtylyov@cogentembedded.com> <201304210016.33720.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304210016.33720.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/20/2013 10:16 PM, Sergei Shtylyov wrote:
> From: Vladimir Barinov<vladimir.barinov@cogentembedded.com>
>
> Add OKI Semiconductor ML86V7667 video decoder driver.
>
> Signed-off-by: Vladimir Barinov<vladimir.barinov@cogentembedded.com>
> [Sergei: added v4l2_device_unregister_subdev() call to the error cleanup path of
> ml86v7667_probe(); some cleanup.]
> Signed-off-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
>
> ---
>   drivers/media/i2c/Kconfig     |    9
>   drivers/media/i2c/Makefile    |    1
>   drivers/media/i2c/ml86v7667.c |  504 ++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 514 insertions(+)

> +static int ml86v7667_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
> +{
> +	struct ml86v7667_priv *priv = to_ml86v7667(sd);
> +
> +	ml86v7667_querystd(sd,&priv->std);
> +
> +	a->bounds.left = 0;
> +	a->bounds.top = 0;
> +	a->bounds.width = 720;
> +	a->bounds.height = priv->std&  V4L2_STD_525_60 ? 480 : 576;
> +	a->defrect = a->bounds;
> +	a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	a->pixelaspect.numerator = 1;
> +	a->pixelaspect.denominator = 1;
> +
> +	return 0;
> +}

> +static struct v4l2_subdev_video_ops ml86v7667_subdev_video_ops = {
> +	.querystd = ml86v7667_querystd,
> +	.g_input_status = ml86v7667_g_input_status,
> +	.enum_mbus_fmt = ml86v7667_enum_mbus_fmt,
> +	.try_mbus_fmt = ml86v7667_try_mbus_fmt,
> +	.g_mbus_fmt = ml86v7667_g_mbus_fmt,
> +	.s_mbus_fmt = ml86v7667_s_mbus_fmt,
> +	.cropcap = ml86v7667_cropcap,
> +	.g_mbus_config = ml86v7667_g_mbus_config,
> +};

Why do you need .cropcap when there is no s_crop/g_crop ops ? Is it
only for pixel aspect ratio ?

Also, new drivers are supposed to use the selections API instead
(set/get_selection ops). However this requires pad level ops support
in your host driver, hence might be a bigger issue.

Regards,
Sylwester
