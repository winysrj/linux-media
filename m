Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:55321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1AITYW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jan 2011 14:24:22 -0500
Date: Sun, 9 Jan 2011 20:24:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Qing Xu <qingx@marvell.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kassey Lee <ygli@marvell.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] [media] v4l: soc-camera: add enum-frame-size ioctl
In-Reply-To: <Pine.LNX.4.64.1101071515410.32550@axis700.grange>
Message-ID: <Pine.LNX.4.64.1101092023510.833@axis700.grange>
References: <1294368595-2518-1-git-send-email-qingx@marvell.com>
 <Pine.LNX.4.64.1101071515410.32550@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 7 Jan 2011, Guennadi Liakhovetski wrote:

> On Fri, 7 Jan 2011, Qing Xu wrote:
> 
> > pass VIDIOC_ENUM_FRAMESIZES down to sub device drivers. So far no
> > special handling in soc-camera core.
> 
> Hm, no, guess what? I don't think this can work. The parameter, that this 
> routine gets from the user struct v4l2_frmsizeenum contains a member 
> pixel_format, which is a fourcc code. Whereas subdevices don't deal with 
> them, they deal with mediabus codes. It is the same problem as with old 
> s/g/try/enum_fmt, which we replaced with respective mbus variants. So, we 
> either have to add our own .enum_mbus_framesizes video subdevice 
> operation, or we abuse this one, but interpret the pixel_format field as a 
> media-bus code.
> 
> Currently I only see one subdev driver, that implements this API: 
> ov7670.c, and it just happily ignores the pixel_format altogether...
> 
> Hans, Laurent, what do you think?
> 
> In the soc-camera case you will have to use soc_camera_xlate_by_fourcc() 
> to convert to media-bus code from fourcc. A nit-pick: please, follow the 
> style of the file, that you patch and don't add double empty lines between 
> functions.
> 
> A side question: why do you need this format at all? Is it for some custom 

Sorry, I meant to ask - what do you need this operation / ioctl() for?

Thanks
Guennadi

> application? What is your use-case, that makes try_fmt / s_fmt 
> insufficient for you and how does enum_framesizes help you?
> 
> Thanks
> Guennadi
> 
> > 
> > Signed-off-by: Kassey Lee <ygli@marvell.com>
> > Signed-off-by: Qing Xu <qingx@marvell.com>
> > ---
> >  drivers/media/video/soc_camera.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> > index 052bd6d..11715fb 100644
> > --- a/drivers/media/video/soc_camera.c
> > +++ b/drivers/media/video/soc_camera.c
> > @@ -145,6 +145,16 @@ static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
> >  	return v4l2_subdev_call(sd, core, s_std, *a);
> >  }
> >  
> > +static int soc_camera_enum_framesizes(struct file *file, void *fh,
> > +					 struct v4l2_frmsizeenum *fsize)
> > +{
> > +	struct soc_camera_device *icd = file->private_data;
> > +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> > +
> > +	return v4l2_subdev_call(sd, video, enum_framesizes, fsize);
> > +}
> > +
> > +
> >  static int soc_camera_reqbufs(struct file *file, void *priv,
> >  			      struct v4l2_requestbuffers *p)
> >  {
> > @@ -1302,6 +1312,7 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
> >  	.vidioc_g_input		 = soc_camera_g_input,
> >  	.vidioc_s_input		 = soc_camera_s_input,
> >  	.vidioc_s_std		 = soc_camera_s_std,
> > +	.vidioc_enum_framesizes  = soc_camera_enum_framesizes,
> >  	.vidioc_reqbufs		 = soc_camera_reqbufs,
> >  	.vidioc_try_fmt_vid_cap  = soc_camera_try_fmt_vid_cap,
> >  	.vidioc_querybuf	 = soc_camera_querybuf,
> > -- 
> > 1.6.3.3
> > 
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
