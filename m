Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45656 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752003AbeCXL0I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Mar 2018 07:26:08 -0400
Date: Sat, 24 Mar 2018 13:26:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH v2] media: ov5640: fix frame interval enumeration
Message-ID: <20180324112605.uycgdfzuighpnnsj@valkosipuli.retiisi.org.uk>
References: <1520521634-29089-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520521634-29089-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Thu, Mar 08, 2018 at 04:07:14PM +0100, Hugues Fruchet wrote:
> Driver must reject frame interval enumeration of unsupported resolution.
> This was detected by v4l2-compliance format ioctl test:
> v4l2-compliance Format ioctls:
>     info: found 2 frameintervals for pixel format 4745504a and size 176x144
>   fail: v4l2-test-formats.cpp(123):
>                            found frame intervals for invalid size 177x144
>     test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
> version 2:
>   - revisit patch according to Mauro comments:
>     See https://www.mail-archive.com/linux-media@vger.kernel.org/msg127380.html
> 
>  drivers/media/i2c/ov5640.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 676f635..5c08124 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -1397,8 +1397,12 @@ static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
>  			break;
>  	}
>  
> -	if (nearest && i < 0)
> +	if (i < 0) {
> +		/* no match */
> +		if (!nearest)
> +			return NULL;
>  		mode = &ov5640_mode_data[fr][0];

I looked at the ov5640_find_mode() and its implementation is somewhat
different from what many other drivers use. Could you switch to
v4l2_find_nearest_size() instead?

There was a problem in my earlier pull request to Mauro but that should be
going in as it was intended Very Soon now.

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-common-size2>

If you need additional checks, you could put them to enum_frame_interval
itself.

What do you think?

> +	}
>  
>  	return mode;
>  }
> @@ -2381,8 +2385,14 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
>  
>  	sensor->current_fr = frame_rate;
>  	sensor->frame_interval = fi->interval;
> -	sensor->current_mode = ov5640_find_mode(sensor, frame_rate, mode->width,
> -						mode->height, true);
> +	mode = ov5640_find_mode(sensor, frame_rate, mode->width,
> +				mode->height, true);
> +	if (!mode) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	sensor->current_mode = mode;
>  	sensor->pending_mode_change = true;
>  out:
>  	mutex_unlock(&sensor->lock);

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
