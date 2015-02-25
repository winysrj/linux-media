Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43039 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813AbbBYNqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2015 08:46:07 -0500
Message-ID: <54EDD216.9030806@xs4all.nl>
Date: Wed, 25 Feb 2015 14:45:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 3/3] smiapp: Use __v4l2_ctrl_grab() to grab controls
References: <1424867607-4082-1-git-send-email-sakari.ailus@iki.fi> <1424867607-4082-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1424867607-4082-4-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch series, but I have one question, see below.

On 02/25/15 13:33, Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Instead of returning -EBUSY in s_ctrl(), use __v4l2_ctrl_grab() to mark the
> controls grabbed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |   20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index e534f1b..6658f61 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -423,9 +423,6 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
>  
>  	case V4L2_CID_HFLIP:
>  	case V4L2_CID_VFLIP:
> -		if (sensor->streaming)
> -			return -EBUSY;
> -
>  		if (sensor->hflip->val)
>  			orient |= SMIAPP_IMAGE_ORIENTATION_HFLIP;
>  
> @@ -469,9 +466,6 @@ static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
>  			+ ctrl->val);
>  
>  	case V4L2_CID_LINK_FREQ:
> -		if (sensor->streaming)
> -			return -EBUSY;
> -
>  		return smiapp_pll_update(sensor);
>  
>  	case V4L2_CID_TEST_PATTERN: {
> @@ -1535,15 +1529,15 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
>  	if (sensor->streaming == enable)
>  		goto out;
>  
> -	if (enable) {
> -		sensor->streaming = true;
> +	if (enable)
>  		rval = smiapp_start_streaming(sensor);
> -		if (rval < 0)
> -			sensor->streaming = false;
> -	} else {
> +	else
>  		rval = smiapp_stop_streaming(sensor);
> -		sensor->streaming = false;
> -	}
> +
> +	sensor->streaming = enable;
> +	__v4l2_ctrl_grab(sensor->hflip, enable);
> +	__v4l2_ctrl_grab(sensor->vflip, enable);
> +	__v4l2_ctrl_grab(sensor->link_freq, enable);

Just checking: is it really not possible to change these controls
while streaming? Most devices I know of allow changing this on the fly.

If it is really not possible, then you can add my Ack for this series:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

>  
>  out:
>  	mutex_unlock(&sensor->mutex);
> 

