Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:42746 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751947AbdCaIkj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 04:40:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Helen Koike <helen.koike@collabora.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, jgebben@codeaurora.org
Subject: Re: [PATCH RFC 1/2] [media] v4l2: add V4L2_INPUT_TYPE_DEFAULT
Date: Fri, 31 Mar 2017 11:41:21 +0300
Message-ID: <1528696.yNy6IkbhZk@avalon>
In-Reply-To: <edfc014d-3b5e-53f9-04f0-95ae4fd4017e@xs4all.nl>
References: <1490889738-30009-1-git-send-email-helen.koike@collabora.com> <edfc014d-3b5e-53f9-04f0-95ae4fd4017e@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 31 Mar 2017 10:29:04 Hans Verkuil wrote:
> On 30/03/17 18:02, Helen Koike wrote:
> > Add V4L2_INPUT_TYPE_DEFAULT and helpers functions for input ioctls to be
> > used when no inputs are available in the device
> > 
> > Signed-off-by: Helen Koike <helen.koike@collabora.com>
> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-ioctl.c | 27 +++++++++++++++++++++++++++
> >  include/media/v4l2-ioctl.h           | 26 ++++++++++++++++++++++++++
> >  include/uapi/linux/videodev2.h       |  1 +
> >  3 files changed, 54 insertions(+)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> > b/drivers/media/v4l2-core/v4l2-ioctl.c index 0c3f238..ccaf04b 100644
> > --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> > +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> > @@ -2573,6 +2573,33 @@ struct mutex *v4l2_ioctl_get_lock(struct
> > video_device *vdev, unsigned cmd)> 
> >  	return vdev->lock;
> >  
> >  }
> > 
> > +int v4l2_ioctl_enum_input_default(struct file *file, void *priv,
> > +				  struct v4l2_input *i)
> > +{
> > +	if (i->index > 0)
> > +		return -EINVAL;
> > +
> > +	memset(i, 0, sizeof(*i));
> > +	i->type = V4L2_INPUT_TYPE_DEFAULT;
> > +	strlcpy(i->name, "Default", sizeof(i->name));
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(v4l2_ioctl_enum_input_default);
> > +
> > +int v4l2_ioctl_g_input_default(struct file *file, void *priv, unsigned
> > int *i)
> > +{
> > +	*i = 0;
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(v4l2_ioctl_g_input_default);
> > +
> > +int v4l2_ioctl_s_input_default(struct file *file, void *priv, unsigned
> > int i)
> > +{
> > +	return i ? -EINVAL : 0;
> > +}
> > +EXPORT_SYMBOL(v4l2_ioctl_s_input_default);
> > +
> >  /* Common ioctl debug function. This function can be used by
> >     external ioctl messages as well as internal V4L ioctl */
> >  void v4l_printk_ioctl(const char *prefix, unsigned int cmd)
> > diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> > index 6cd94e5..accc470 100644
> > --- a/include/media/v4l2-ioctl.h
> > +++ b/include/media/v4l2-ioctl.h
> > @@ -652,6 +652,32 @@ struct video_device;
> >   */
> >  
> >  struct mutex *v4l2_ioctl_get_lock(struct video_device *vdev, unsigned int
> >  cmd);
> > +
> > +/**
> > + * v4l2_ioctl_enum_input_default - v4l2 ioctl helper for
> > VIDIOC_ENUM_INPUT ioctl + *
> > + * Plug this function in vidioc_enum_input field of the struct
> > v4l2_ioctl_ops to + * enumerate a single input as V4L2_INPUT_TYPE_DEFAULT
> > + */
> > +int v4l2_ioctl_enum_input_default(struct file *file, void *priv,
> > +				  struct v4l2_input *i);
> > +
> > +/**
> > + * v4l2_ioctl_g_input_default - v4l2 ioctl helper for VIDIOC_G_INPUT
> > ioctl
> > + *
> > + * Plug this function in vidioc_g_input field of the struct
> > v4l2_ioctl_ops
> > + * when using v4l2_ioctl_enum_input_default
> > + */
> > +int v4l2_ioctl_g_input_default(struct file *file, void *priv, unsigned
> > int *i); +
> > +/**
> > + * v4l2_ioctl_s_input_default - v4l2 ioctl helper for VIDIOC_S_INPUT
> > ioctl
> > + *
> > + * Plug this function in vidioc_s_input field of the struct
> > v4l2_ioctl_ops
> > + * when using v4l2_ioctl_enum_input_default
> > + */
> > +int v4l2_ioctl_s_input_default(struct file *file, void *priv, unsigned
> > int i); +
> > 
> >  /* names for fancy debug output */
> >  extern const char *v4l2_field_names[];
> >  extern const char *v4l2_type_names[];
> > 
> > diff --git a/include/uapi/linux/videodev2.h
> > b/include/uapi/linux/videodev2.h index 316be62..c10bbde 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -1477,6 +1477,7 @@ struct v4l2_input {
> > 
> >  };
> >  
> >  /*  Values for the 'type' field */
> > 
> > +#define V4L2_INPUT_TYPE_DEFAULT		0
> 
> I don't think we should add a new type here. The whole point of this
> exercise is to allow existing apps to work, and existing apps expect a
> TYPE_CAMERA.
> 
> BTW, don't read to much in the term 'CAMERA': it's really a catch all for
> any video stream, whether it is from a sensor, composite input, HDMI, etc.
> 
> The description for V4L2_INPUT_TYPE_CAMERA in the spec is hopelessly out of
> date :-(
> 
> Rather than creating a new type I would add a new V4L2_IN_CAP_MC capability
> that indicates that this input is controlled via the media controller. That
> makes much more sense and it wouldn't potentially break applications.
> 
> Exactly the same can be done for outputs as well: add V4L2_OUT_CAP_MC and
> use V4L2_OUTPUT_TYPE_ANALOG as the output type (again, a horrible outdated
> name and the spec is again out of date).

What would those capabilities be used for ? Applications can already know 
whether the MC API is used by a driver. Furthermore, if we really need such a 
flag, I wouldn't add it at the input/output level but as a video node 
capability flag.

> Regarding the name: should we use the name stored in struct video_device
> instead? That might be more descriptive. Alternatively use something like
> "Media Controller Input".
> 
> More helpful (perhaps) than just "Default" or "Unknown".

If the purpose of the name field is to be displayed as-is to the end-user, 
then "Media Controller Input" is as useless as "Unknown". "Default" would be 
slightly better.

> I'll make a patch to update the input/output type description in the spec.
> 
> >  #define V4L2_INPUT_TYPE_TUNER		1
> >  #define V4L2_INPUT_TYPE_CAMERA		2
> >  #define V4L2_INPUT_TYPE_TOUCH		3

-- 
Regards,

Laurent Pinchart
