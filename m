Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:44944 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934916Ab0HFNZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Aug 2010 09:25:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH/RFC] V4L2: add a generic function to find the nearest discrete format
Date: Fri, 6 Aug 2010 15:25:28 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1008051959330.26127@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1008051959330.26127@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008061525.30646.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 05 August 2010 20:03:46 Guennadi Liakhovetski wrote:
> Many video drivers implement a discrete set of frame formats and thus face
> a task of finding the best match for a user-requested format. Implementing
> this in a generic function has also an advantage, that different drivers
> with similar supported format sets will select the same format for the
> user, which improves consistency across drivers.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> I'm currently away from my hardware, so, this is only compile tested and
> run-time tested with a test application. In any case, reviews and
> suggestions welcome.
> 
>  drivers/media/video/v4l2-common.c |   26 ++++++++++++++++++++++++++
>  include/linux/videodev2.h         |   10 ++++++++++
>  2 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-common.c
> b/drivers/media/video/v4l2-common.c index 4e53b0b..90727e6 100644
> --- a/drivers/media/video/v4l2-common.c
> +++ b/drivers/media/video/v4l2-common.c
> @@ -1144,3 +1144,29 @@ int v4l_fill_dv_preset_info(u32 preset, struct
> v4l2_dv_enum_preset *info) return 0;
>  }
>  EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
> +
> +struct v4l2_frmsize_discrete *v4l2_find_nearest_format(struct
> v4l2_discrete_probe *probe, +						       s32 width, s32 height)
> +{
> +	int i;
> +	u32 error, min_error = ~0;
> +	struct v4l2_frmsize_discrete *size, *best = NULL;
> +
> +	if (!probe)
> +		return best;
> +
> +	for (i = 0, size = probe->sizes; i < probe->num_sizes; i++, size++) {
> +		if (probe->probe && !probe->probe(probe))

What's this call for ?

> +			continue;
> +		error = abs(size->width - width) + abs(size->height - height);
> +		if (error < min_error) {
> +			min_error = error;
> +			best = size;
> +		}
> +		if (!error)
> +			break;
> +	}
> +
> +	return best;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_find_nearest_format);
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 047f7e6..f622bba 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -394,6 +394,16 @@ struct v4l2_frmsize_discrete {
>  	__u32			height;		/* Frame height [pixel] */
>  };
> 
> +struct v4l2_discrete_probe {
> +	struct v4l2_frmsize_discrete	*sizes;
> +	int				num_sizes;
> +	void				*priv;
> +	bool				(*probe)(struct v4l2_discrete_probe *);
> +};
> +
> +struct v4l2_frmsize_discrete *v4l2_find_nearest_format(struct
> v4l2_discrete_probe *probe, +						       s32 width, s32 height);
> +
>  struct v4l2_frmsize_stepwise {
>  	__u32			min_width;	/* Minimum frame width [pixel] */
>  	__u32			max_width;	/* Maximum frame width [pixel] */

-- 
Regards,

Laurent Pinchart
