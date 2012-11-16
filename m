Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1037 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2KPNxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 08:53:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 2/4] v4l: Helper function for obtaining timestamps
Date: Fri, 16 Nov 2012 14:52:30 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
References: <20121115220627.GB29863@valkosipuli.retiisi.org.uk> <1353017207-370-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1353017207-370-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161452.30489.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu November 15 2012 23:06:45 Sakari Ailus wrote:
> v4l2_get_timestamp() produces a monotonic timestamp but unlike
> ktime_get_ts(), it uses struct timeval instead of struct timespec, saving
> the drivers the conversion job when getting timestamps for v4l2_buffer's
> timestamp field.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/v4l2-core/v4l2-common.c |   10 ++++++++++
>  include/media/v4l2-common.h           |    2 ++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index 380ddd8..614316f 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -978,3 +978,13 @@ const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
>  	return best;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_find_nearest_format);
> +
> +void v4l2_get_timestamp(struct timeval *tv)
> +{
> +	struct timespec ts;
> +
> +	ktime_get_ts(&ts);
> +	tv->tv_sec = ts.tv_sec;
> +	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 1a0b2db..ec7c9c0 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -225,4 +225,6 @@ bool v4l2_detect_gtf(unsigned frame_height, unsigned hfreq, unsigned vsync,
>  
>  struct v4l2_fract v4l2_calc_aspect_ratio(u8 hor_landscape, u8 vert_portrait);
>  
> +void v4l2_get_timestamp(struct timeval *tv);
> +
>  #endif /* V4L2_COMMON_H_ */
> 

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
