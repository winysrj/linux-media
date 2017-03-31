Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42759 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751947AbdCaIlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 04:41:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Helen Koike <helen.koike@collabora.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org
Subject: Re: [PATCH RFC 1/2] [media] v4l2: add V4L2_INPUT_TYPE_DEFAULT
Date: Fri, 31 Mar 2017 11:41:51 +0300
Message-ID: <1539709.tvRnEGTVFr@avalon>
In-Reply-To: <34146d93-6651-69a2-0997-aa3ae91b4fd3@collabora.com>
References: <1490889738-30009-1-git-send-email-helen.koike@collabora.com> <2926010.76lXoG2CJo@avalon> <34146d93-6651-69a2-0997-aa3ae91b4fd3@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

On Thursday 30 Mar 2017 23:39:01 Helen Koike wrote:
> On 2017-03-30 04:56 PM, Laurent Pinchart wrote:
> > On Thursday 30 Mar 2017 13:02:17 Helen Koike wrote:
> >> Add V4L2_INPUT_TYPE_DEFAULT and helpers functions for input ioctls to be
> >> used when no inputs are available in the device
> >> 
> >> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> >> ---
> >> 
> >>  drivers/media/v4l2-core/v4l2-ioctl.c | 27 +++++++++++++++++++++++++++
> >>  include/media/v4l2-ioctl.h           | 26 ++++++++++++++++++++++++++
> >>  include/uapi/linux/videodev2.h       |  1 +
> >>  3 files changed, 54 insertions(+)
> >> 
> >> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> >> b/drivers/media/v4l2-core/v4l2-ioctl.c index 0c3f238..ccaf04b 100644
> >> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> >> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> @@ -2573,6 +2573,33 @@ struct mutex *v4l2_ioctl_get_lock(struct
> >> video_device *vdev, unsigned cmd) return vdev->lock;
> >> 
> >>  }
> >> 
> >> +int v4l2_ioctl_enum_input_default(struct file *file, void *priv,
> >> +				  struct v4l2_input *i)
> >> +{
> >> +	if (i->index > 0)
> >> +		return -EINVAL;
> >> +
> >> +	memset(i, 0, sizeof(*i));
> >> +	i->type = V4L2_INPUT_TYPE_DEFAULT;
> >> +	strlcpy(i->name, "Default", sizeof(i->name));
> >> +
> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL(v4l2_ioctl_enum_input_default);
> > 
> > V4L2 tends to use EXPORT_SYMBOL_GPL.
> 
> The whole v4l2-ioctl.c file is using EXPORT_SYMBOL instead of
> EXPORT_SYMBOL_GPL, should we change it all to EXPORT_SYMBOL_GPL then (in
> another patch) ?

You're right, let's leave it as-is then.

> > What would you think about calling those default functions directly from
> > the core when the input ioctl handlers are not set ? You wouldn't need to
> > modify drivers.
> 
> Sure, I'll add them in ops inside __video_register_device when it
> validates the ioctls
> 
> >> +
> >> +int v4l2_ioctl_g_input_default(struct file *file, void *priv, unsigned
> >> int
> >> *i) +{
> >> +	*i = 0;
> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL(v4l2_ioctl_g_input_default);
> >> +
> >> +int v4l2_ioctl_s_input_default(struct file *file, void *priv, unsigned
> >> int
> >> i) +{
> >> +	return i ? -EINVAL : 0;
> >> +}
> >> +EXPORT_SYMBOL(v4l2_ioctl_s_input_default);
> >> +
> >> 
> >>  /* Common ioctl debug function. This function can be used by
> >>  
> >>     external ioctl messages as well as internal V4L ioctl */
> >>  
> >>  void v4l_printk_ioctl(const char *prefix, unsigned int cmd)
> >> 
> >> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> >> index 6cd94e5..accc470 100644
> >> --- a/include/media/v4l2-ioctl.h
> >> +++ b/include/media/v4l2-ioctl.h
> >> @@ -652,6 +652,32 @@ struct video_device;
> >> 
> >>   */
> >>  
> >>  struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned
> >>  int
> >> 
> >> cmd);
> >> 
> >> +
> >> +/**
> >> + * v4l2_ioctl_enum_input_default - v4l2 ioctl helper for
> >> VIDIOC_ENUM_INPUT
> >> ioctl + *
> >> + * Plug this function in vidioc_enum_input field of the struct
> >> v4l2_ioctl_ops to + * enumerate a single input as V4L2_INPUT_TYPE_DEFAULT
> >> + */
> >> +int v4l2_ioctl_enum_input_default(struct file *file, void *priv,
> >> +				  struct v4l2_input *i);
> >> +
> >> +/**
> >> + * v4l2_ioctl_g_input_default - v4l2 ioctl helper for VIDIOC_G_INPUT
> >> ioctl
> >> + *
> >> + * Plug this function in vidioc_g_input field of the struct
> >> v4l2_ioctl_ops
> >> + * when using v4l2_ioctl_enum_input_default
> >> + */
> >> +int v4l2_ioctl_g_input_default(struct file *file, void *priv, unsigned
> >> int
> >> *i); +
> >> +/**
> >> + * v4l2_ioctl_s_input_default - v4l2 ioctl helper for VIDIOC_S_INPUT
> >> ioctl
> >> + *
> >> + * Plug this function in vidioc_s_input field of the struct
> >> v4l2_ioctl_ops
> >> + * when using v4l2_ioctl_enum_input_default
> >> + */
> >> +int v4l2_ioctl_s_input_default(struct file *file, void *priv, unsigned
> >> int
> >> i); +
> >> 
> >>  /* names for fancy debug output */
> >>  extern const char *v4l2_field_names[];
> >>  extern const char *v4l2_type_names[];
> >> 
> >> diff --git a/include/uapi/linux/videodev2.h
> >> b/include/uapi/linux/videodev2.h index 316be62..c10bbde 100644
> >> --- a/include/uapi/linux/videodev2.h
> >> +++ b/include/uapi/linux/videodev2.h
> >> @@ -1477,6 +1477,7 @@ struct v4l2_input {
> >> 
> >>  };
> >>  
> >>  /*  Values for the 'type' field */
> >> 
> >> +#define V4L2_INPUT_TYPE_DEFAULT		0
> >> 
> >>  #define V4L2_INPUT_TYPE_TUNER		1
> >>  #define V4L2_INPUT_TYPE_CAMERA		2
> >>  #define V4L2_INPUT_TYPE_TOUCH		3
> 
> Helen

-- 
Regards,

Laurent Pinchart
