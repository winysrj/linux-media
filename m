Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2EHRoP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 13:44:15 -0400
Date: Tue, 8 May 2012 19:44:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Aguirre, Sergio" <saaguirre@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: soc-camera: (cosmetic) use a more explicit name
 for a host handler
In-Reply-To: <CAKnK67Q8W-JB700qCBN_ma-JCQZXX19qi+PD9xW=kAjzMhYPTQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1205081941490.7085@axis700.grange>
References: <Pine.LNX.4.64.1205081856180.7085@axis700.grange>
 <CAKnK67Q8W-JB700qCBN_ma-JCQZXX19qi+PD9xW=kAjzMhYPTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio

On Tue, 8 May 2012, Aguirre, Sergio wrote:

> Hi Guennadi,
> 
> On Tue, May 8, 2012 at 12:00 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Use "enum_framesizes" instead of "enum_fsizes" to more precisely follow
> > the name of the respective ioctl().
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Looks good to me!

Thanks

> I'll redo my patch following this ioctl name matching.

Well, but naming was just one doubt about your patch - and in fact the 
least important one. What about the other one - the actually important one 
- do we really want to abuse struct v4l2_frmivalenum, or we want to switch 
to the one, used for pad operations or we want to invent something new? We 
still haven't got any opinions on that...

Thanks
Guennadi

> 
> Reviewed-by: Sergio Aguirre <sergio.a.aguirre@gmail.com>
> 
> Regards,
> Sergio
> 
> > ---
> >  drivers/media/video/soc_camera.c |   14 +++++++-------
> >  include/media/soc_camera.h       |    2 +-
> >  2 files changed, 8 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> > index eb25756..b980f99 100644
> > --- a/drivers/media/video/soc_camera.c
> > +++ b/drivers/media/video/soc_camera.c
> > @@ -257,13 +257,13 @@ static int soc_camera_g_std(struct file *file, void *priv, v4l2_std_id *a)
> >        return v4l2_subdev_call(sd, core, g_std, a);
> >  }
> >
> > -static int soc_camera_enum_fsizes(struct file *file, void *fh,
> > +static int soc_camera_enum_framesizes(struct file *file, void *fh,
> >                                         struct v4l2_frmsizeenum *fsize)
> >  {
> >        struct soc_camera_device *icd = file->private_data;
> >        struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> >
> > -       return ici->ops->enum_fsizes(icd, fsize);
> > +       return ici->ops->enum_framesizes(icd, fsize);
> >  }
> >
> >  static int soc_camera_reqbufs(struct file *file, void *priv,
> > @@ -1241,8 +1241,8 @@ static int default_s_parm(struct soc_camera_device *icd,
> >        return v4l2_subdev_call(sd, video, s_parm, parm);
> >  }
> >
> > -static int default_enum_fsizes(struct soc_camera_device *icd,
> > -                         struct v4l2_frmsizeenum *fsize)
> > +static int default_enum_framesizes(struct soc_camera_device *icd,
> > +                                  struct v4l2_frmsizeenum *fsize)
> >  {
> >        int ret;
> >        struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > @@ -1295,8 +1295,8 @@ int soc_camera_host_register(struct soc_camera_host *ici)
> >                ici->ops->set_parm = default_s_parm;
> >        if (!ici->ops->get_parm)
> >                ici->ops->get_parm = default_g_parm;
> > -       if (!ici->ops->enum_fsizes)
> > -               ici->ops->enum_fsizes = default_enum_fsizes;
> > +       if (!ici->ops->enum_framesizes)
> > +               ici->ops->enum_framesizes = default_enum_framesizes;
> >
> >        mutex_lock(&list_lock);
> >        list_for_each_entry(ix, &hosts, list) {
> > @@ -1386,7 +1386,7 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
> >        .vidioc_s_input          = soc_camera_s_input,
> >        .vidioc_s_std            = soc_camera_s_std,
> >        .vidioc_g_std            = soc_camera_g_std,
> > -       .vidioc_enum_framesizes  = soc_camera_enum_fsizes,
> > +       .vidioc_enum_framesizes  = soc_camera_enum_framesizes,
> >        .vidioc_reqbufs          = soc_camera_reqbufs,
> >        .vidioc_querybuf         = soc_camera_querybuf,
> >        .vidioc_qbuf             = soc_camera_qbuf,
> > diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > index b5c2b6c..00039d8 100644
> > --- a/include/media/soc_camera.h
> > +++ b/include/media/soc_camera.h
> > @@ -97,7 +97,7 @@ struct soc_camera_host_ops {
> >        int (*set_bus_param)(struct soc_camera_device *);
> >        int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
> >        int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
> > -       int (*enum_fsizes)(struct soc_camera_device *, struct v4l2_frmsizeenum *);
> > +       int (*enum_framesizes)(struct soc_camera_device *, struct v4l2_frmsizeenum *);
> >        unsigned int (*poll)(struct file *, poll_table *);
> >  };
> >
> > --
> > 1.7.2.5
> >
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
