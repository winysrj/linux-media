Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1521 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab1AUKG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jan 2011 05:06:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] [media] v4l: soc-camera: add enum-frame-size ioctl
Date: Fri, 21 Jan 2011 11:06:08 +0100
Cc: Qing Xu <qingx@marvell.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1295574498-8666-1-git-send-email-qingx@marvell.com> <7BAC95F5A7E67643AAFB2C31BEE662D014040BFA37@SC-VEXCH2.marvell.com> <Pine.LNX.4.64.1101210841190.14675@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1101210841190.14675@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101211106.08670.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, January 21, 2011 09:05:07 Guennadi Liakhovetski wrote:
> On Thu, 20 Jan 2011, Qing Xu wrote:
> 
> > Hi Guennadi, Hans,
> > 
> > I update this patch, I use enum_framesizes instead of
> > enum_mbus_fsizes, which is already defined in v4l2-subdev.h,
> > so, do not need to modify v4l2-subdev.h now.
> > 
> > Are you ok with it?
> 
> Hm, you see, this would mean, hijacking a "wrong" operation. This is one 
> of those "wrong" subdevice operations, using fourcc formats to specify a 
> data format on the video-bus between a subdevice (a sensor) and a sink (a 
> host). Previously there have been more of such "wrong" operations, like 
> .{g,s,try,enum}_fmt, all of those have been _gradually_ replaced by 
> respective mediabus counterparts. While doing that we first added new 
> operations with different names (with an extra "mbus_" in them), then 
> ported all existing users over to them, and eventually removed the old 
> "wrong" ones (Hans has done the dirtiest and most difficult part of that - 
> porting and removing;)). Now, the .enum_framesizes() video subdev 
> operation is also one such wrong API element. It has much fewer current 
> users (ov7670.c and cafe_ccic.c - the OLPC project).

Oops, I'd missed those. Those should be replaced with enum_mbus_framesizes.
Ditto for enum_frameintervals. via_camera.c uses it as well.

> If we just blatantly 
> re-use it with a media-bus code, it will be relatively harmless, imho, 
> still, it will introduce an ambiguity. Of the above two drivers the sensor 
> driver will not have to be changed at all, because it just ignores the 
> pixel_format field altogether, cafe_ccic.c will have to be trivially 
> ported, we'd just have to add a couple of lines, e.g.
> 
>  static int cafe_vidioc_enum_framesizes(struct file *filp, void *priv,
>  		struct v4l2_frmsizeenum *sizes)
>  {
>  	struct cafe_camera *cam = priv;
> +	__u32 fourcc = sizes->pixel_format;
>  	int ret;
>  
>  	mutex_lock(&cam->s_mutex);
> +	sizes->pixel_format = cam->mbus_code;
>  	ret = sensor_call(cam, video, enum_framesizes, sizes);
>  	mutex_unlock(&cam->s_mutex);
> +	sizes->pixel_format = fourcc;
>  	return ret;
>  }
>  
> 
> or something similar. So, that's certainly doable, still, I think, this 
> would introduce a precedent of inconsistent naming - we'll have an 
> operation, without an "mbus" in the name, operating at the media-bus 
> level, which is not a very good idea, imho. Hans?

I agree.

First add new enum_mbus_framesizes and enum_mbus_frameintervals functions.
Then convert the three drivers that use this (ov7670.c, cafe_ccic.c and
via_camera.c) to these new ops. Next remove the old ones since nobody should
use them anymore. And finally add support for this to soc_camera.

I can take your ov7670/cafe/via patches and test them and make a pull request
for them. I have other outstanding work for those drivers so I can take this
in as well. Since it is a big pain to test on the OLPC laptop I'd rather test
everything in one go :-)

Laurent, it is a good idea if you took a look at this as well. Especially since
you have similar patches in your media controller series:

http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/26821

The framesize struct is much simplified here and any new code should probably
be close to what is proposed here.

Regards,

	Hans

> 
> Thanks
> Guennadi
> 
> > 
> > -Qing
> > 
> > -----Original Message-----
> > From: Qing Xu [mailto:qingx@marvell.com]
> > Sent: 2011Äê1ÔÂ21ÈÕ 9:48
> > To: g.liakhovetski@gmx.de
> > Cc: linux-media@vger.kernel.org; Qing Xu
> > Subject: [PATCH] [media] v4l: soc-camera: add enum-frame-size ioctl
> > 
> > add vidioc_enum_framesizes implementation, follow default_g_parm()
> > and g_mbus_fmt() method
> > 
> > Signed-off-by: Qing Xu <qingx@marvell.com>
> > ---
> >  drivers/media/video/soc_camera.c |   37 +++++++++++++++++++++++++++++++++++++
> >  include/media/soc_camera.h       |    1 +
> >  2 files changed, 38 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> > index 052bd6d..7290107 100644
> > --- a/drivers/media/video/soc_camera.c
> > +++ b/drivers/media/video/soc_camera.c
> > @@ -145,6 +145,15 @@ static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
> >         return v4l2_subdev_call(sd, core, s_std, *a);
> >  }
> > 
> > +static int soc_camera_enum_fsizes(struct file *file, void *fh,
> > +                                        struct v4l2_frmsizeenum *fsize)
> > +{
> > +       struct soc_camera_device *icd = file->private_data;
> > +       struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> > +
> > +       return ici->ops->enum_fsizes(icd, fsize);
> > +}
> > +
> >  static int soc_camera_reqbufs(struct file *file, void *priv,
> >                               struct v4l2_requestbuffers *p)
> >  {
> > @@ -1160,6 +1169,31 @@ static int default_s_parm(struct soc_camera_device *icd,
> >         return v4l2_subdev_call(sd, video, s_parm, parm);
> >  }
> > 
> > +static int default_enum_fsizes(struct soc_camera_device *icd,
> > +                         struct v4l2_frmsizeenum *fsize)
> > +{
> > +       int ret;
> > +       struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > +       const struct soc_camera_format_xlate *xlate;
> > +       __u32 pixfmt = fsize->pixel_format;
> > +       struct v4l2_frmsizeenum fsize_mbus = *fsize;
> > +
> > +       xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> > +       if (!xlate)
> > +               return -EINVAL;
> > +       /* map xlate-code to pixel_format, sensor only handle xlate-code*/
> > +       fsize_mbus.pixel_format = xlate->code;
> > +
> > +       ret = v4l2_subdev_call(sd, video, enum_framesizes, &fsize_mbus);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       *fsize = fsize_mbus;
> > +       fsize->pixel_format = pixfmt;
> > +
> > +       return 0;
> > +}
> > +
> >  static void soc_camera_device_init(struct device *dev, void *pdata)
> >  {
> >         dev->platform_data      = pdata;
> > @@ -1195,6 +1229,8 @@ int soc_camera_host_register(struct soc_camera_host *ici)
> >                 ici->ops->set_parm = default_s_parm;
> >         if (!ici->ops->get_parm)
> >                 ici->ops->get_parm = default_g_parm;
> > +       if (!ici->ops->enum_fsizes)
> > +               ici->ops->enum_fsizes = default_enum_fsizes;
> > 
> >         mutex_lock(&list_lock);
> >         list_for_each_entry(ix, &hosts, list) {
> > @@ -1302,6 +1338,7 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
> >         .vidioc_g_input          = soc_camera_g_input,
> >         .vidioc_s_input          = soc_camera_s_input,
> >         .vidioc_s_std            = soc_camera_s_std,
> > +       .vidioc_enum_framesizes  = soc_camera_enum_fsizes,
> >         .vidioc_reqbufs          = soc_camera_reqbufs,
> >         .vidioc_try_fmt_vid_cap  = soc_camera_try_fmt_vid_cap,
> >         .vidioc_querybuf         = soc_camera_querybuf,
> > diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > index 86e3631..6e4800c 100644
> > --- a/include/media/soc_camera.h
> > +++ b/include/media/soc_camera.h
> > @@ -85,6 +85,7 @@ struct soc_camera_host_ops {
> >         int (*set_ctrl)(struct soc_camera_device *, struct v4l2_control *);
> >         int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
> >         int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
> > +       int (*enum_fsizes)(struct soc_camera_device *, struct v4l2_frmsizeenum *);
> >         unsigned int (*poll)(struct file *, poll_table *);
> >         const struct v4l2_queryctrl *controls;
> >         int num_controls;
> > --
> > 1.6.3.3
> > 
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
