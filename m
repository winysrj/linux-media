Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:19925 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751052AbeAVK2p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 05:28:45 -0500
Date: Mon, 22 Jan 2018 12:28:42 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/9] v4l2-common: create v4l2_g/s_parm_cap helpers
Message-ID: <20180122102842.sfny35juufqj5o6m@paasikivi.fi.intel.com>
References: <20180122101857.51401-1-hverkuil@xs4all.nl>
 <20180122101857.51401-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180122101857.51401-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 22, 2018 at 11:18:49AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Create helpers to handle VIDIOC_G/S_PARM by querying the
> g/s_frame_interval v4l2_subdev ops.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-common.c | 49 +++++++++++++++++++++++++++++++++++
>  include/media/v4l2-common.h           | 26 +++++++++++++++++++
>  2 files changed, 75 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index 8650ad92b64d..4e371ae4aed7 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -392,3 +392,52 @@ void v4l2_get_timestamp(struct timeval *tv)
>  	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
> +
> +int v4l2_g_parm_cap(struct video_device *vdev,
> +		    struct v4l2_subdev *sd, struct v4l2_streamparm *a)
> +{
> +	struct v4l2_subdev_frame_interval ival = { 0 };
> +	int ret;
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	    a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;
> +
> +	if (vdev->device_caps & V4L2_CAP_READWRITE)
> +		a->parm.capture.readbuffers = 2;
> +	if (v4l2_subdev_has_op(sd, video, g_frame_interval))
> +		a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> +	ret = v4l2_subdev_call(sd, video, g_frame_interval, &ival);
> +	if (!ret)
> +		a->parm.capture.timeperframe = ival.interval;
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_g_parm_cap);
> +
> +int v4l2_s_parm_cap(struct video_device *vdev,
> +		    struct v4l2_subdev *sd, struct v4l2_streamparm *a)
> +{
> +	struct v4l2_subdev_frame_interval ival = {
> +		0,
> +		a->parm.capture.timeperframe

I'd explicitly specify which members are assigned here. It looks cleaner
and does not depend on field order in the struct definition. It won't be
changed as it's part of uAPI but then again people take examples from
existing code and could do this where it's not safe.

> +	};
> +	int ret;
> +
> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	    a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +		return -EINVAL;
> +
> +	memset(&a->parm, 0, sizeof(a->parm));
> +	if (vdev->device_caps & V4L2_CAP_READWRITE)
> +		a->parm.capture.readbuffers = 2;
> +	else
> +		a->parm.capture.readbuffers = 0;
> +
> +	if (v4l2_subdev_has_op(sd, video, g_frame_interval))
> +		a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> +	ret = v4l2_subdev_call(sd, video, s_frame_interval, &ival);
> +	if (!ret)
> +		a->parm.capture.timeperframe = ival.interval;
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index e0d95a7c5d48..f3aa1d728c0b 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -341,4 +341,30 @@ v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,
>   */
>  void v4l2_get_timestamp(struct timeval *tv);
>  
> +/**
> + * v4l2_g_parm_cap - helper routine for vidioc_g_parm to fill this in by
> + *      calling the g_frame_interval op of the given subdev. It only works
> + *      for V4L2_BUF_TYPE_VIDEO_CAPTURE(_MPLANE), hence the _cap in the
> + *      function name.
> + *
> + * @vdev: the struct video_device pointer. Used to determine the device caps.
> + * @sd: the sub-device pointer.
> + * @a: the VIDIOC_G_PARM argument.
> + */
> +int v4l2_g_parm_cap(struct video_device *vdev,
> +		    struct v4l2_subdev *sd, struct v4l2_streamparm *a);
> +
> +/**
> + * v4l2_s_parm_cap - helper routine for vidioc_s_parm to fill this in by
> + *      calling the s_frame_interval op of the given subdev. It only works
> + *      for V4L2_BUF_TYPE_VIDEO_CAPTURE(_MPLANE), hence the _cap in the
> + *      function name.
> + *
> + * @vdev: the struct video_device pointer. Used to determine the device caps.
> + * @sd: the sub-device pointer.
> + * @a: the VIDIOC_S_PARM argument.
> + */
> +int v4l2_s_parm_cap(struct video_device *vdev,
> +		    struct v4l2_subdev *sd, struct v4l2_streamparm *a);
> +
>  #endif /* V4L2_COMMON_H_ */

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
