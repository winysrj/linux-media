Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56665 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032656AbeBNQfh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 11:35:37 -0500
Date: Wed, 14 Feb 2018 14:35:31 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/9] v4l2-common: create v4l2_g/s_parm_cap helpers
Message-ID: <20180214143531.3643cc4e@vento.lan>
In-Reply-To: <dc7bebaa-48e8-1cbc-7a87-c3f35deebda9@xs4all.nl>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
        <20180122123125.24709-2-hverkuil@xs4all.nl>
        <20180214135018.356ee06d@vento.lan>
        <dc7bebaa-48e8-1cbc-7a87-c3f35deebda9@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 14 Feb 2018 17:23:51 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 14/02/18 16:50, Mauro Carvalho Chehab wrote:
> > Em Mon, 22 Jan 2018 13:31:17 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Create helpers to handle VIDIOC_G/S_PARM by querying the
> >> g/s_frame_interval v4l2_subdev ops.
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  drivers/media/v4l2-core/v4l2-common.c | 48 +++++++++++++++++++++++++++++++++++
> >>  include/media/v4l2-common.h           | 26 +++++++++++++++++++
> >>  2 files changed, 74 insertions(+)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> >> index 8650ad92b64d..96c1b31de9e3 100644
> >> --- a/drivers/media/v4l2-core/v4l2-common.c
> >> +++ b/drivers/media/v4l2-core/v4l2-common.c
> >> @@ -392,3 +392,51 @@ void v4l2_get_timestamp(struct timeval *tv)
> >>  	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
> >>  }
> >>  EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
> >> +
> >> +int v4l2_g_parm_cap(struct video_device *vdev,
> >> +		    struct v4l2_subdev *sd, struct v4l2_streamparm *a)
> >> +{
> >> +	struct v4l2_subdev_frame_interval ival = { 0 };
> >> +	int ret;
> >> +
> >> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> >> +	    a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> >> +		return -EINVAL;
> >> +
> >> +	if (vdev->device_caps & V4L2_CAP_READWRITE)
> >> +		a->parm.capture.readbuffers = 2;  
> > 
> > Hmm... why don't you also initialize readbuffers otherwise?  
> 
> It's specifically for read(). If read() is not supported, then this
> is meaningless and should just stay 0. v4l2-compliance checks for this.

Well, API states that:

"When an application requests zero buffers, drivers should just return the current setting rather than the minimum or an error code."

So, something should zero it, if not used and type is capture or
capture_mplane.

> The 'readbuffers' field is completely outdated and once this is in
> the next step is to see if we can come up with something better. I hate
> G/S_PARM.

Yes, it is a weird ioctl, but I'm not yet convinced that we should
increase API complexity by adding newer ioctls due to that.

Instead, I would just get rid of .g_parm/.s_parm callbacks, implementing
a better kAPI, without bothering adding more complexity to uAPI.

> 
> Regards,
> 
> 	Hans
> 
> >   
> >> +	if (v4l2_subdev_has_op(sd, video, g_frame_interval))
> >> +		a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> >> +	ret = v4l2_subdev_call(sd, video, g_frame_interval, &ival);
> >> +	if (!ret)
> >> +		a->parm.capture.timeperframe = ival.interval;
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(v4l2_g_parm_cap);
> >> +
> >> +int v4l2_s_parm_cap(struct video_device *vdev,
> >> +		    struct v4l2_subdev *sd, struct v4l2_streamparm *a)
> >> +{
> >> +	struct v4l2_subdev_frame_interval ival = {
> >> +		.interval = a->parm.capture.timeperframe
> >> +	};
> >> +	int ret;
> >> +
> >> +	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> >> +	    a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> >> +		return -EINVAL;
> >> +
> >> +	memset(&a->parm, 0, sizeof(a->parm));
> >> +	if (vdev->device_caps & V4L2_CAP_READWRITE)
> >> +		a->parm.capture.readbuffers = 2;
> >> +	else
> >> +		a->parm.capture.readbuffers = 0;
> >> +
> >> +	if (v4l2_subdev_has_op(sd, video, g_frame_interval))
> >> +		a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> >> +	ret = v4l2_subdev_call(sd, video, s_frame_interval, &ival);
> >> +	if (!ret)
> >> +		a->parm.capture.timeperframe = ival.interval;
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
> >> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> >> index e0d95a7c5d48..f3aa1d728c0b 100644
> >> --- a/include/media/v4l2-common.h
> >> +++ b/include/media/v4l2-common.h
> >> @@ -341,4 +341,30 @@ v4l2_find_nearest_format(const struct v4l2_frmsize_discrete *sizes,
> >>   */
> >>  void v4l2_get_timestamp(struct timeval *tv);
> >>  
> >> +/**
> >> + * v4l2_g_parm_cap - helper routine for vidioc_g_parm to fill this in by
> >> + *      calling the g_frame_interval op of the given subdev. It only works
> >> + *      for V4L2_BUF_TYPE_VIDEO_CAPTURE(_MPLANE), hence the _cap in the
> >> + *      function name.
> >> + *
> >> + * @vdev: the struct video_device pointer. Used to determine the device caps.
> >> + * @sd: the sub-device pointer.
> >> + * @a: the VIDIOC_G_PARM argument.
> >> + */
> >> +int v4l2_g_parm_cap(struct video_device *vdev,
> >> +		    struct v4l2_subdev *sd, struct v4l2_streamparm *a);
> >> +
> >> +/**
> >> + * v4l2_s_parm_cap - helper routine for vidioc_s_parm to fill this in by
> >> + *      calling the s_frame_interval op of the given subdev. It only works
> >> + *      for V4L2_BUF_TYPE_VIDEO_CAPTURE(_MPLANE), hence the _cap in the
> >> + *      function name.
> >> + *
> >> + * @vdev: the struct video_device pointer. Used to determine the device caps.
> >> + * @sd: the sub-device pointer.
> >> + * @a: the VIDIOC_S_PARM argument.
> >> + */
> >> +int v4l2_s_parm_cap(struct video_device *vdev,
> >> +		    struct v4l2_subdev *sd, struct v4l2_streamparm *a);
> >> +
> >>  #endif /* V4L2_COMMON_H_ */  
> > 
> > 
> > 
> > Thanks,
> > Mauro
> >   
> 



Thanks,
Mauro
