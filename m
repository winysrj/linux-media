Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:52207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1ATHfX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jan 2011 02:35:23 -0500
Date: Thu, 20 Jan 2011 08:35:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Qing Xu <qingx@marvell.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] [media] v4l: soc-camera: add enum-frame-size ioctl
In-Reply-To: <Pine.LNX.4.64.1101191639180.620@axis700.grange>
Message-ID: <Pine.LNX.4.64.1101200831400.1425@axis700.grange>
References: <1295404602-9730-1-git-send-email-qingx@marvell.com>
 <7BAC95F5A7E67643AAFB2C31BEE662D014040BF547@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1101191639180.620@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hm, sorry! My below comment:

On Wed, 19 Jan 2011, Guennadi Liakhovetski wrote:

> On Tue, 18 Jan 2011, Qing Xu wrote:

[snip]

> > @@ -1160,6 +1169,28 @@ static int default_s_parm(struct soc_camera_device *icd,
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
> > +       struct v4l2_frmsizeenum *fsize_mbus = fsize;
> 
> Please, test your patches before posting! The above should have been

was certainly wrong! Your line was correct syntactically, still, I'd like 
to have a slightly different version, please see my last mail to you.

Sorry again!
Guennadi

> 
> +       struct v4l2_frmsizeenum *fsize_mbus = *fsize;
> 
> > +
> > +       xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> > +       if (!xlate)
> > +               return -EINVAL;
> > +       /* map xlate-code to pixel_format, sensor only handle xlate-code*/
> > +       fsize_mbus->pixel_format = xlate->code;
> > +
> > +       ret = v4l2_subdev_call(sd, video, enum_mbus_fsizes, fsize_mbus);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       return 0;
> 
> Yes, almost. You're still missing one important point though: you're not 
> returning the result to the user... So, before your "return 0;" you have 
> to add two more lines:
> 
> +	*fsize = *fsize_mbus;
> +	fsize->pixel_format = pixfmt;
> 
> Thanks
> Guennadi
> 
> > +}
> > +
> >  static void soc_camera_device_init(struct device *dev, void *pdata)
> >  {
> >         dev->platform_data      = pdata;
> > @@ -1195,6 +1226,8 @@ int soc_camera_host_register(struct soc_camera_host *ici)
> >                 ici->ops->set_parm = default_s_parm;
> >         if (!ici->ops->get_parm)
> >                 ici->ops->get_parm = default_g_parm;
> > +       if (!ici->ops->enum_fsizes)
> > +               ici->ops->enum_fsizes = default_enum_fsizes;
> > 
> >         mutex_lock(&list_lock);
> >         list_for_each_entry(ix, &hosts, list) {
> > @@ -1302,6 +1335,7 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
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
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index b0316a7..0d482c9 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -275,6 +275,8 @@ struct v4l2_subdev_video_ops {
> >                         struct v4l2_dv_timings *timings);
> >         int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
> >                              enum v4l2_mbus_pixelcode *code);
> > +       int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
> > +                            struct v4l2_frmsizeenum *fsize);
> >         int (*g_mbus_fmt)(struct v4l2_subdev *sd,
> >                           struct v4l2_mbus_framefmt *fmt);
> >         int (*try_mbus_fmt)(struct v4l2_subdev *sd,
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

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
