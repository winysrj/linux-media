Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:65369 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731025AbeITU7v (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 16:59:51 -0400
Date: Thu, 20 Sep 2018 17:15:49 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, slongerbeam@gmail.com
Subject: Re: [PATCH v3 1/2] media: v4l2-subdev.h: allow
        V4L2_FRMIVAL_TYPE_CONTINUOUS & _STEPWISE
Message-ID: <20180920151549.GA8832@frolo.macqel>
References: <1536685593-27512-2-git-send-email-phdm@macqel.be> <1715501.OtfZWGH4Dz@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1715501.OtfZWGH4Dz@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 20, 2018 at 05:11:50PM +0300, Laurent Pinchart wrote:
> Hi Philippe,
> 
> Thank you for the patch.
> 
> On Tuesday, 11 September 2018 20:06:32 EEST Philippe De Muyter wrote:
> > add V4L2_FRMIVAL_TYPE_CONTINUOUS and V4L2_FRMIVAL_TYPE_STEPWISE for
> > subdev's frame intervals in addition to implicit existing
> > V4L2_FRMIVAL_TYPE_DISCRETE type.  This needs three new fields in the
> > v4l2_subdev_frame_interval_enum struct :
> > - type
> > - max_interval
> > - step_interval
> > 
> > A helper function 'v4l2_fill_frmivalenum_from_subdev' is also added.
> > 
> > Subdevs must fill the 'type' field.  If they do not, the default
> > value (0) is used which is equal to V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE.
> > 
> > if type is set to V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE, or left untouched,
> > only the 'interval' field must be filled, just as before.
> > 
> > If type is set to V4L2_FRMIVAL_TYPE_CONTINUOUS, 'interval' must be set
> > to the minimum frame interval (highest framerate), and 'max_interval'
> > to the maximum frame interval.
> > 
> > If type is set to V4L2_FRMIVAL_TYPE_STEPWISE, 'step_interval' must be
> > set to the step between available intervals, in addition to 'interval'
> > and 'max_interval' which must be set as for V4L2_FRMIVAL_TYPE_CONTINUOUS
> 
> Continuous is a special case of stepwise with the step set to 1. Should we 
> merge the two types ?

I always wondered what that '1' meant; surely not 1/1.  I rather see
STEPWISE as a special case of CONTINUOUS, where the granularity of the
step is too big, making it more DISCRETE-like than CONTINUOUS-like.

I do not use STEPWISE.  It is only here for completeness compared to
the not-subdev case.

> 
> I'm curious, as there's nothing in this series, using the new types, what are 
> your use cases ?

I have drivers for industrial and even monochrome sensors, but that must
run in vendor-specific and old linux versions, and I must add this patch
each time, but I am not able to upstream the sensor drivers as they are
too tighted to the vendor-specific linux.

Adding that patch now increases the probability that the next vendor-specific
linux I'll get will contain it :)

> 
> > Old users which do not check the 'type' field will get the minimum frame
> > interval (highest framrate) just like before.
> > 
> > Callers who intend to check the 'type' field should zero it themselves,
> > in case an old subdev driver does not do zero it.
> > 
> > When filled correctly by the sensor driver, the new fields must be
> > used as follows by the caller :
> > 
> > 	 struct v4l2_frmivalenum * fival;
> > 	 struct v4l2_subdev_frame_interval_enum fie;
> > 
> > 	 if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE) {
> > 		 fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> > 		 fival->discrete = fie.interval;
> > 	 } else if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS) {
> > 		 fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
> > 		 fival->stepwise.min = fie.interval;
> > 		 fival->stepwise.max = fie.max_interval;
> > 	 } else {
> > 		 fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
> > 		 fival->stepwise.min = fie.interval;
> > 		 fival->stepwise.max = fie.max_interval;
> > 		 fival->stepwise.step = fie.step_interval;
> > 	 }
> > 
> > Kernel users should use the new 'v4l2_fill_frmivalenum_from_subdev'
> > helper function.
> > 
> > Signed-off-by: Philippe De Muyter <phdm@macqel.be>
> > ---
> >  .../uapi/v4l/vidioc-subdev-enum-frame-interval.rst | 69 ++++++++++++++++++-
> >  drivers/media/v4l2-core/v4l2-common.c              | 33 +++++++++++
> >  include/media/v4l2-common.h                        | 12 ++++
> >  include/uapi/linux/v4l2-subdev.h                   | 22 ++++++-
> >  4 files changed, 133 insertions(+), 3 deletions(-)
> > 
> > diff --git
> > a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
> > b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst index
> > 1bfe386..e14fa14 100644
> > --- a/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
> > +++ b/Documentation/media/uapi/v4l/vidioc-subdev-enum-frame-interval.rst
> > @@ -51,6 +51,41 @@ EINVAL error code if one of the input fields is invalid.
> > All frame intervals are enumerable by beginning at index zero and
> > incrementing by one until ``EINVAL`` is returned.
> > 
> > +If the sub-device can work only with a fixed set of frame intervals, then
> > +the driver must enumerate them with increasing indexes, by setting the
> > +``type`` field to ``V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE`` and only filling
> > +the ``interval`` field .  If the sub-device can work with a continuous
> > +range of frame intervals, then the driver must only return success for
> > +index 0, set the ``type`` field to ``V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS``,
> > +fill ``interval`` with the minimum interval and ``max_interval`` with
> > +the maximum interval.  If it is worth mentioning the step in the
> > +continuous interval, the driver must set the ``type`` field to
> > +``V4L2_SUBDEV_FRMIVAL_TYPE_STEPWISE`` and fill also the ``step_interval``
> > +field with the step between the possible intervals.
> > +
> > +Callers are expected to use the returned information as follows:
> > +
> > +.. code-block:: c
> > +
> > +        struct v4l2_frmivalenum *fival;
> > +        struct v4l2_subdev_frame_interval_enum fie;
> > +
> > +        if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE) {
> > +                fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> > +                fival->discrete = fie.interval;
> > +        } else if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS) {
> > +                fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
> > +                fival->stepwise.min = fie.interval;
> > +                fival->stepwise.max = fie.max_interval;
> > +        } else {
> > +                fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
> > +                fival->stepwise.min = fie.interval;
> > +                fival->stepwise.max = fie.max_interval;
> > +                fival->stepwise.step = fie.step_interval;
> > +        }
> > +
> > +.. code-block:: c
> > +
> >  Available frame intervals may depend on the current 'try' formats at
> >  other pads of the sub-device, as well as on the current active links.
> >  See :ref:`VIDIOC_SUBDEV_G_FMT` for more
> > @@ -93,11 +128,43 @@ multiple pads of the same sub-device is not defined.
> >        - Frame intervals to be enumerated, from enum
> > 
> >  	:ref:`v4l2_subdev_format_whence <v4l2-subdev-format-whence>`.
> > 
> >      * - __u32
> > -      - ``reserved``\ [8]
> > +      - ``type``
> > +      - Type of enumerated interval
> > +	:ref:`v4l2_subdev_frmival_type <v4l2-subdev-frmival-type>`.
> > +    * - struct :c:type:`v4l2_fract`
> > +      - ``max_interval``
> > +      - Maximum period, in seconds, between consecutive video frames, or 0.
> > +    * - struct :c:type:`v4l2_fract`
> > +      - ``step_interval``
> > +      - Frame interval step size, in seconds, or 0.
> 
> Having minimum and maximum values as fractions and a step as a fraction as 
> well will make the maths pretty fun... I think it was a mistake to go with 
> fractions in the first place, as it gives many ways to represent the same 
> value. It lead to gems such as https://elixir.bootlin.com/linux/latest/source/
> drivers/media/usb/uvc/uvc_driver.c#L263 (which I'm both proud and ashamed of).
> 
> Instead of repeating the mistake, is there a chance we could fix it and 
> express intervals as an integer (in nanoseconds for instance, or possibly 10s 
> or 100s of nanoseconds) for these new types ? Ideally I'd move to the same 
> unit for the discrete type as well but we can't change the API there. We could 
I'd rather keep the API coherent : all values expressed the same way.
And also coherent with the VIDIOC_ENUM_FRAMEINTERVALS API.

> deprecate it though (given that I expect very few users of that subdev 
> userspace API) and add a new type for discrete intervals using integers. 
> Subdev drivers would then implement the new API only, with the conversion 
> performed in core code.
> 
> > +    * - __u32
> > +      - ``reserved``\ [3]
> >        - Reserved for future extensions. Applications and drivers must set
> >  	the array to zero.
> > 
> > 
> > +
> > +.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
> > +
> > +.. _v4l2-subdev-frmival-type:
> > +
> > +.. flat-table:: enum v4l2_subdev_format_whence
> > +    :header-rows:  0
> > +    :stub-columns: 0
> > +    :widths:       3 1 4
> > +
> > +    * - V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE
> > +      - 0
> > +      - This frame interval is fixed
> > +    * - V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS
> > +      - 1
> > +      - Any frame interval between min and max is available
> > +    * - V4L2_SUBDEV_FRMIVAL_TYPE_STEPWISE
> > +      - 2
> > +      - Many frame intervals between min and max are available, with a
> > +        significant and constant step between them.
> > +
> > +
> >  Return Value
> >  ============
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-common.c
> > b/drivers/media/v4l2-core/v4l2-common.c index b062111..ec9b748 100644
> > --- a/drivers/media/v4l2-core/v4l2-common.c
> > +++ b/drivers/media/v4l2-core/v4l2-common.c
> > @@ -445,3 +445,36 @@ int v4l2_s_parm_cap(struct video_device *vdev,
> >  	return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
> > +
> > +int v4l2_fill_frmivalenum_from_subdev(struct v4l2_subdev *sd, struct
> > v4l2_frmivalenum *fival, int code) +{
> > +	struct v4l2_subdev_frame_interval_enum fie;
> > +	int ret;
> > +
> > +	fie.index = fival->index;
> > +	fie.code = code;
> > +	fie.width = fival->width;
> > +	fie.height = fival->height;
> > +	fie.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > +
> > +	fie.type = V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE; /* for old subdev drivers */
> > +	ret = v4l2_subdev_call(sd, pad, enum_frame_interval, NULL, &fie); +
> > +	if (!ret) {
> > +		if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE) {
> > +			fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> > +			fival->discrete = fie.interval;
> > +		} else if (fie.type == V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS) {
> > +			fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
> > +			fival->stepwise.min = fie.interval;
> > +			fival->stepwise.max = fie.max_interval;
> > +		} else {
> > +			fival->type = V4L2_FRMIVAL_TYPE_STEPWISE;
> > +			fival->stepwise.min = fie.interval;
> > +			fival->stepwise.max = fie.max_interval;
> > +			fival->stepwise.step = fie.step_interval;
> > +		}
> > +	}
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_fill_frmivalenum_from_subdev);
> > diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> > index cdc87ec..3c62403 100644
> > --- a/include/media/v4l2-common.h
> > +++ b/include/media/v4l2-common.h
> > @@ -384,4 +384,16 @@ int v4l2_g_parm_cap(struct video_device *vdev,
> >  int v4l2_s_parm_cap(struct video_device *vdev,
> >  		    struct v4l2_subdev *sd, struct v4l2_streamparm *a);
> > 
> > +/**
> > + * v4l2_fill_frmivalenum_from_subdev - helper for
> > vidioc_enum_frameintervals + *      calling the enum_frame_interval op of
> > the given subdev.
> > + *
> > + * @sd: the sub-device pointer.
> > + * @fival: the VIDIOC_ENUM_FRAMEINTERVALS argument.
> > + * @code: the MEDIA_BUS_FMT_ code (not fival->pixel_format !)
> > + */
> > +int v4l2_fill_frmivalenum_from_subdev(struct v4l2_subdev *sd,
> > +	       			      struct v4l2_frmivalenum *fival,
> > +				      int code);
> > +
> >  #endif /* V4L2_COMMON_H_ */
> > diff --git a/include/uapi/linux/v4l2-subdev.h
> > b/include/uapi/linux/v4l2-subdev.h index 03970ce..3faae35 100644
> > --- a/include/uapi/linux/v4l2-subdev.h
> > +++ b/include/uapi/linux/v4l2-subdev.h
> > @@ -100,6 +100,16 @@ struct v4l2_subdev_frame_size_enum {
> >  };
> > 
> >  /**
> > + * enum v4l2_subdev_frmival_type - Frame interval type
> > + */
> > +enum v4l2_subdev_frmival_type {
> > +	V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE = 0,
> > +	V4L2_SUBDEV_FRMIVAL_TYPE_CONTINUOUS = 1,
> > +	V4L2_SUBDEV_FRMIVAL_TYPE_STEPWISE = 2,
> > +};
> > +
> > +
> > +/**
> >   * struct v4l2_subdev_frame_interval - Pad-level frame rate
> >   * @pad: pad number, as reported by the media API
> >   * @interval: frame interval in seconds
> > @@ -117,8 +127,13 @@ struct v4l2_subdev_frame_interval {
> >   * @code: format code (MEDIA_BUS_FMT_ definitions)
> >   * @width: frame width in pixels
> >   * @height: frame height in pixels
> > - * @interval: frame interval in seconds
> > + * @interval: minimum frame interval in seconds
> >   * @which: format type (from enum v4l2_subdev_format_whence)
> > + * @type: frame interval type (from enum v4l2_subdev_frmival_type)
> > + * @max_interval: maximum frame interval in seconds,
> > + *                if type != V4L2_SUBDEV_FRMIVAL_TYPE_DISCRETE
> > + * @step_interval: step between frame intervals, in seconds,
> > + *                 if type == V4L2_SUBDEV_FRMIVAL_TYPE_STEPWISE
> >   */
> >  struct v4l2_subdev_frame_interval_enum {
> >  	__u32 index;
> > @@ -128,7 +143,10 @@ struct v4l2_subdev_frame_interval_enum {
> >  	__u32 height;
> >  	struct v4l2_fract interval;
> >  	__u32 which;
> > -	__u32 reserved[8];
> > +	__u32 type;
> > +	struct v4l2_fract max_interval;
> > +	struct v4l2_fract step_interval;
> > +	__u32 reserved[3];
> >  };
> > 
> >  /**
> 
> -- 
> Regards,
> 
> Laurent Pinchart

Best Regards

Philippe De Muyter
