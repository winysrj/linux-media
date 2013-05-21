Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:46702 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3EUJgO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 05:36:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v3] adv7180: add more subdev video ops
Date: Tue, 21 May 2013 11:35:59 +0200
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	vladimir.barinov@cogentembedded.com, linux-sh@vger.kernel.org,
	matsu@igel.co.jp
References: <201305132321.39495.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201305132321.39495.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305211135.59706.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 13 May 2013 21:21:39 Sergei Shtylyov wrote:
> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> Add subdev video ops for ADV7180 video decoder.  This makes decoder usable on
> the soc-camera drivers.
> 
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo.
> 
> Changes from version 2:
> - set the field format depending on video standard in try_mbus_fmt() method;
> - removed querystd() method calls from try_mbus_fmt() and cropcap() methods;
> - removed g_crop() method.
> 
>  drivers/media/i2c/adv7180.c |   86 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> Index: media_tree/drivers/media/i2c/adv7180.c
> ===================================================================
> --- media_tree.orig/drivers/media/i2c/adv7180.c
> +++ media_tree/drivers/media/i2c/adv7180.c


> +
> +static int adv7180_try_mbus_fmt(struct v4l2_subdev *sd,
> +				struct v4l2_mbus_framefmt *fmt)
> +{
> +	struct adv7180_state *state = to_state(sd);
> +
> +	fmt->code = V4L2_MBUS_FMT_YUYV8_2X8;
> +	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +	fmt->field = state->curr_norm & V4L2_STD_525_60 ?
> +		     V4L2_FIELD_INTERLACED_BT : V4L2_FIELD_INTERLACED_TB;

Just noticed this: use V4L2_FIELD_INTERLACED as that does the right thing.
No need to split in _BT and _TB.

> +	fmt->width = 720;
> +	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> +
> +	return 0;
> +}

Actually, all this code can be simplified substantially: the try/g/s_mbus_fmt
functions are really all identical since the data returned is only dependent
on the current standard. So this means you can use just a single function for
all three ops, and you can do away with adding struct v4l2_mbus_framefmt to
adv7180_state.

Regards,

	Hans
