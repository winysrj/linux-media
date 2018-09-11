Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:41488 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726761AbeIKR6Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 13:58:25 -0400
Subject: Re: [PATCH v2] media: v4l2-subdev.h: allow
 V4L2_FRMIVAL_TYPE_CONTINUOUS & _STEPWISE
To: Philippe De Muyter <phdm@macqel.be>, linux-media@vger.kernel.org
References: <067c2ad9-6216-d2d3-6004-3c69289a0c5b@xs4all.nl>
 <1536654988-27553-1-git-send-email-phdm@macqel.be>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5c2160cb-7cbb-b676-5819-e7ca936dc06e@xs4all.nl>
Date: Tue, 11 Sep 2018 14:59:05 +0200
MIME-Version: 1.0
In-Reply-To: <1536654988-27553-1-git-send-email-phdm@macqel.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/18 10:36, Philippe De Muyter wrote:
> add V4L2_FRMIVAL_TYPE_CONTINUOUS and V4L2_FRMIVAL_TYPE_STEPWISE for
> subdev's frame intervals in addition to implicit existing
> V4L2_FRMIVAL_TYPE_DISCRETE type.  This needs three new fields in the
> v4l2_subdev_frame_interval_enum struct :
> - type
> - max_interval
> - step_interval
> 
> A helper function 'v4l2_fill_frmivalenum_from_subdev' is also added.
> 
> Subdevs must fill the 'type' field.  If they do not, the default
> value (0) is used which is equal to V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE.
> 
> if type is set to V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE, or left untouched,
> only the 'interval' field must be filled, just as before.
> 
> If type is set to V4L2_FRMIVAL_TYPE_CONTINUOUS, 'interval' must be set
> to the minimum frame interval (highest framerate), and 'max_interval'
> to the maximum frame interval.
> 
> If type is set to V4L2_FRMIVAL_TYPE_STEPWISE, 'step_interval' must be
> set to the step between available intervals, in addition to 'interval'
> and 'max_interval' which must be set as for V4L2_FRMIVAL_TYPE_CONTINUOUS
> 
> Old users which do not check the 'type' field will get the minimum frame
> interval (highest framrate) just like before.
> 
> Callers who intend to check the 'type' field should zero it themselves,
> in case an old subdev driver does not do zero it.
> 
> When filled correctly by the sensor driver, the new fields must be
> used as follows by the caller :
> 
> 	 struct v4l2_frmivalenum * fival;
> 	 struct v4l2_subdev_frame_interval_enum fie;
> 
> 	 if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE) {
> 		 fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> 		 fival->discrete = fie.interval;
> 	 } else if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS) {
> 		 fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
> 		 fival->stepwise.min = fie.interval;
> 		 fival->stepwise.max = fie.max_interval;
> 	 } else {
> 		 fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
> 		 fival->stepwise.min = fie.interval;
> 		 fival->stepwise.max = fie.max_interval;
> 		 fival->stepwise.step = fie.step_interval;
> 	 }
> 
> Kernel users should use the new 'v4l2_fill_frmivalenum_from_subdev'
> helper function.
> 
> Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> ---
> v2:
> 	Add a 'type' field and a helper function, as asked by Hans
> 
>  .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst | 46 +++++++++++++++++++++-
>  drivers/media/v4l2-core/v4l2-common.c              | 32 +++++++++++++++
>  include/media/v4l2-common.h                        | 12 ++++++
>  include/uapi/linux/v4l2-subdev.h                   | 22 ++++++++++-
>  4 files changed, 109 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
> index 1bfe386..d3144b7 100644
> --- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
> @@ -51,6 +51,44 @@ EINVAL error code if one of the input fields is invalid. All frame
>  intervals are enumerable by beginning at index zero and incrementing by
>  one until ``EINVAL`` is returned.
>  
> +If the sub-device can work only at a fixed set of frame intervals,

at -> with

> +driver must enumerate them with increasing indexes, by setting the

driver -> then the driver

> +``type`` field to ``V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE`` and only filling
> +the ``interval`` field .  If the sub-device can work with a continuous
> +range of frame intervals, driver must only return success for index 0,
> +set the ``type`` field to ``V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS``,
> +fill ``interval`` with the minimum interval and ``max_interval`` with
> +the maximum interval.  If it is worth mentionning the step in the

mentionning -> mentioning

> +continuous interval, the driver must set the ``type`` field to
> +``V4L2_SUBDEV_FRMIVAL_TYPE_STEPWISE`` and fill also the ``step_interval``
> +field with the step between the possible intervals.
> +
> +Callers are expected to use the returned information as follows :

No space before :

> +
> +.. code-block:: c
> +
> +        struct v4l2_frmivalenum * fival;

No space after *

> +        struct v4l2_subdev_frame_interval_enum fie;
> +
> +        if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE) {
> +                fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> +                fival->discrete = fie.interval;
> +        } else if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS) {
> +                fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
> +                fival->stepwise.min = fie.interval;
> +                fival->stepwise.max = fie.max_interval;
> +        } else {
> +                fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
> +                fival->stepwise.min = fie.interval;
> +                fival->stepwise.max = fie.max_interval;
> +                fival->stepwise.step = fie.step_interval;
> +        }
> +
> +.. code-block:: c
> +
> +Kernel users may use the ``v4l2_fill_frmivalenum_from_subdev`` helper
> +function instead.

Drop this line. This file documents the userspace API, so this is irrelevant.

> +
>  Available frame intervals may depend on the current 'try' formats at
>  other pads of the sub-device, as well as on the current active links.
>  See :ref:`VIDIOC_SUBDEV_G_FMT` for more
> @@ -92,8 +130,14 @@ multiple pads of the same sub-device is not defined.
>        - ``which``
>        - Frame intervals to be enumerated, from enum
>  	:ref:`v4l2_subdev_format_whence <v4l2-subdev-format-whence>`.

I'm missing the documentation for the new 'type' field here.

> +    * - struct :c:type:`v4l2_fract`
> +      - ``max_interval``
> +      - Maximum period, in seconds, between consecutive video frames, or 0.
> +    * - struct :c:type:`v4l2_fract`
> +      - ``step_interval``
> +      - Frame interval step size, in seconds, or 0.
>      * - __u32
> -      - ``reserved``\ [8]
> +      - ``reserved``\ [4]

4 -> 3

>        - Reserved for future extensions. Applications and drivers must set
>  	the array to zero.
>  
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index b062111..d652dd3 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -445,3 +445,35 @@ int v4l2_s_parm_cap(struct video_device *vdev,
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
> +
> +int v4l2_fill_frmivalenum_from_subdev(struct v4l2_subdev *sd, struct v4l2_frmivalenum *fival, int code)
> +{
> +	struct v4l2_subdev_frame_interval_enum fie;
> +	int ret;
> +
> +	fie.index = fival->index;
> +	fie.code = code;
> +	fie.width = fival->width;
> +	fie.height = fival->height;
> +	fie.type = V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE; /* for old subdev drivers */
> +
> +	ret = v4l2_subdev_call(sd, pad, enum_frame_interval, NULL, &fie);
> +
> +	if (!ret) {
> +		if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE) {
> +			fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> +			fival->discrete = fie.interval;
> +		} else if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS) {
> +			fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
> +			fival->stepwise.min = fie.interval;
> +			fival->stepwise.max = fie.max_interval;
> +		} else {
> +			fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
> +			fival->stepwise.min = fie.interval;
> +			fival->stepwise.max = fie.max_interval;
> +			fival->stepwise.step = fie.step_interval;
> +		}
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_frmivalenum_from_subdev);
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index cdc87ec..3c62403 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -384,4 +384,16 @@ int v4l2_g_parm_cap(struct video_device *vdev,
>  int v4l2_s_parm_cap(struct video_device *vdev,
>  		    struct v4l2_subdev *sd, struct v4l2_streamparm *a);
>  
> +/**
> + * v4l2_fill_frmivalenum_from_subdev - helper for vidioc_enum_frameintervals
> + *      calling the enum_frame_interval op of the given subdev.
> + *
> + * @sd: the sub-device pointer.
> + * @fival: the VIDIOC_ENUM_FRAMEINTERVALS argument.
> + * @code: the MEDIA_BUS_FMT_ code (not fival->pixel_format !)
> + */
> +int v4l2_fill_frmivalenum_from_subdev(struct v4l2_subdev *sd,
> +	       			      struct v4l2_frmivalenum *fival,
> +				      int code);
> +

It would be very nice if you can use this helper in a driver as well.
We prefer to see helpers being used somewhere.

>  #endif /* V4L2_COMMON_H_ */
> diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
> index 03970ce..3faae35 100644
> --- a/include/uapi/linux/v4l2-subdev.h
> +++ b/include/uapi/linux/v4l2-subdev.h
> @@ -100,6 +100,16 @@ struct v4l2_subdev_frame_size_enum {
>  };
>  
>  /**
> + * enum v4l2_subdev_frmival_type - Frame interval type
> + */
> +enum v4l2_subdev_frmival_type {
> +	V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE = 0,
> +	V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS = 1,
> +	V4L2_SUBDEV_FRMIVAL_TYPE_STEPWISE = 2,
> +};
> +
> +
> +/**
>   * struct v4l2_subdev_frame_interval - Pad-level frame rate
>   * @pad: pad number, as reported by the media API
>   * @interval: frame interval in seconds
> @@ -117,8 +127,13 @@ struct v4l2_subdev_frame_interval {
>   * @code: format code (MEDIA_BUS_FMT_ definitions)
>   * @width: frame width in pixels
>   * @height: frame height in pixels
> - * @interval: frame interval in seconds
> + * @interval: minimum frame interval in seconds
>   * @which: format type (from enum v4l2_subdev_format_whence)
> + * @type: frame interval type (from enum v4l2_subdev_frmival_type)
> + * @max_interval: maximum frame interval in seconds,
> + *                if type != V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE
> + * @step_interval: step between frame intervals, in seconds,
> + *                 if type == V4L2_SUBDEV_FRMIVAL_TYPE_STEPWISE
>   */
>  struct v4l2_subdev_frame_interval_enum {
>  	__u32 index;
> @@ -128,7 +143,10 @@ struct v4l2_subdev_frame_interval_enum {
>  	__u32 height;
>  	struct v4l2_fract interval;
>  	__u32 which;
> -	__u32 reserved[8];
> +	__u32 type;
> +	struct v4l2_fract max_interval;
> +	struct v4l2_fract step_interval;
> +	__u32 reserved[3];
>  };
>  
>  /**
> 

This is shaping up nicely!

Regards,

	Hans
