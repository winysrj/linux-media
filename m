Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33430 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751310AbdBLWbo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 17:31:44 -0500
Date: Mon, 13 Feb 2017 00:31:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH 1/4] media-ctl: add pad support to set/get_frame_interval
Message-ID: <20170212223108.GC16975@valkosipuli.retiisi.org.uk>
References: <20170207160850.10299-1-p.zabel@pengutronix.de>
 <20170207160850.10299-2-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170207160850.10299-2-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Tue, Feb 07, 2017 at 05:08:47PM +0100, Philipp Zabel wrote:
> This allows to set and get the frame interval on pads other than pad 0.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  utils/media-ctl/libv4l2subdev.c | 24 ++++++++++++++----------
>  utils/media-ctl/v4l2subdev.h    |  4 ++--
>  2 files changed, 16 insertions(+), 12 deletions(-)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index 3dcf943c..eadfc875 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -262,7 +262,8 @@ int v4l2_subdev_set_dv_timings(struct media_entity *entity,
>  }
>  
>  int v4l2_subdev_get_frame_interval(struct media_entity *entity,
> -				   struct v4l2_fract *interval)
> +				   struct v4l2_fract *interval,
> +				   unsigned int pad)
>  {
>  	struct v4l2_subdev_frame_interval ival;
>  	int ret;
> @@ -272,6 +273,7 @@ int v4l2_subdev_get_frame_interval(struct media_entity *entity,
>  		return ret;
>  
>  	memset(&ival, 0, sizeof(ival));
> +	ival.pad = pad;
>  
>  	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, &ival);
>  	if (ret < 0)
> @@ -282,7 +284,8 @@ int v4l2_subdev_get_frame_interval(struct media_entity *entity,
>  }
>  
>  int v4l2_subdev_set_frame_interval(struct media_entity *entity,
> -				   struct v4l2_fract *interval)
> +				   struct v4l2_fract *interval,
> +				   unsigned int pad)
>  {
>  	struct v4l2_subdev_frame_interval ival;
>  	int ret;
> @@ -292,6 +295,7 @@ int v4l2_subdev_set_frame_interval(struct media_entity *entity,
>  		return ret;
>  
>  	memset(&ival, 0, sizeof(ival));
> +	ival.pad = pad;
>  	ival.interval = *interval;
>  
>  	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, &ival);
> @@ -617,7 +621,7 @@ static int set_selection(struct media_pad *pad, unsigned int target,
>  	return 0;
>  }
>  
> -static int set_frame_interval(struct media_entity *entity,
> +static int set_frame_interval(struct media_pad *pad,
>  			      struct v4l2_fract *interval)
>  {
>  	int ret;
> @@ -625,20 +629,20 @@ static int set_frame_interval(struct media_entity *entity,
>  	if (interval->numerator == 0)
>  		return 0;
>  
> -	media_dbg(entity->media,
> -		  "Setting up frame interval %u/%u on entity %s\n",
> +	media_dbg(pad->entity->media,
> +		  "Setting up frame interval %u/%u on entity %s pad %u\n",

The usual notation for specifying the pad in debug messages has been
"%s/%u", entity, pad. Although the syntax appears to use %s:%u. So please
use %s/%u for now.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

>  		  interval->numerator, interval->denominator,
> -		  entity->info.name);
> +		  pad->entity->info.name, pad->index);
>  
> -	ret = v4l2_subdev_set_frame_interval(entity, interval);
> +	ret = v4l2_subdev_set_frame_interval(pad->entity, interval, pad->index);
>  	if (ret < 0) {
> -		media_dbg(entity->media,
> +		media_dbg(pad->entity->media,
>  			  "Unable to set frame interval: %s (%d)",
>  			  strerror(-ret), ret);
>  		return ret;
>  	}
>  
> -	media_dbg(entity->media, "Frame interval set: %u/%u\n",
> +	media_dbg(pad->entity->media, "Frame interval set: %u/%u\n",
>  		  interval->numerator, interval->denominator);
>  
>  	return 0;
> @@ -685,7 +689,7 @@ static int v4l2_subdev_parse_setup_format(struct media_device *media,
>  			return ret;
>  	}
>  
> -	ret = set_frame_interval(pad->entity, &interval);
> +	ret = set_frame_interval(pad, &interval);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
> index 9c8fee89..413094d5 100644
> --- a/utils/media-ctl/v4l2subdev.h
> +++ b/utils/media-ctl/v4l2subdev.h
> @@ -200,7 +200,7 @@ int v4l2_subdev_set_dv_timings(struct media_entity *entity,
>   */
>  
>  int v4l2_subdev_get_frame_interval(struct media_entity *entity,
> -	struct v4l2_fract *interval);
> +	struct v4l2_fract *interval, unsigned int pad);
>  
>  /**
>   * @brief Set the frame interval on a sub-device.
> @@ -217,7 +217,7 @@ int v4l2_subdev_get_frame_interval(struct media_entity *entity,
>   * @return 0 on success, or a negative error code on failure.
>   */
>  int v4l2_subdev_set_frame_interval(struct media_entity *entity,
> -	struct v4l2_fract *interval);
> +	struct v4l2_fract *interval, unsigned int pad);
>  
>  /**
>   * @brief Parse a string and apply format, crop and frame interval settings.
> -- 
> 2.11.0
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
