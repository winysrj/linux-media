Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64700 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab2GKQKH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 12:10:07 -0400
Date: Wed, 11 Jul 2012 18:10:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: soc-camera: add selection API host operations
In-Reply-To: <2010732.dj1mZZWrvn@avalon>
Message-ID: <Pine.LNX.4.64.1207111755180.18999@axis700.grange>
References: <Pine.LNX.4.64.1206221749190.17552@axis700.grange>
 <2010732.dj1mZZWrvn@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Fri, 6 Jul 2012, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thanks for the patch.
> 
> On Friday 22 June 2012 18:40:08 Guennadi Liakhovetski wrote:
> > Add .get_selection() and .set_selection() soc-camera host driver
> > operations. Additionally check, that the user is not trying to change the
> > output sizes during a running capture.
> 
> How will that interact with the crop operations ? The goal is to move away 
> from crop operations to selection operations, so we need to establish clear 
> rules.

Nicely:-) My understanding is, that the V4L2 core now is doing a large 
part (all of?) compatibility / conversion work? As you know, soc-camera is 
a kind of a glue layer between the V4L2 core and host drivers with some 
helper functionality for client drivers. All V4L2 API calls go via the 
soc-camera core and most of them are passed, possibly after some 
preprocessing, to host drivers. Same holds for cropping and selection 
calls. They are passed on to host drivers. As long as drivers use the 
cropping API, the soc-camera core has to support it. Only after all host 
drivers have been ported over, the soc-camera core can abandon it too. I 
don't see another way out, do you?

Thanks
Guennadi

> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > diff --git a/drivers/media/video/soc_camera.c
> > b/drivers/media/video/soc_camera.c index 0421bf9..72798d2 100644
> > --- a/drivers/media/video/soc_camera.c
> > +++ b/drivers/media/video/soc_camera.c
> > @@ -902,6 +902,65 @@ static int soc_camera_s_crop(struct file *file, void
> > *fh, return ret;
> >  }
> > 
> > +static int soc_camera_g_selection(struct file *file, void *fh,
> > +				  struct v4l2_selection *s)
> > +{
> > +	struct soc_camera_device *icd = file->private_data;
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> > +
> > +	/* With a wrong type no need to try to fall back to cropping */
> > +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;
> > +
> > +	if (!ici->ops->get_selection)
> > +		return -ENOTTY;
> > +
> > +	return ici->ops->get_selection(icd, s);
> > +}
> > +
> > +static int soc_camera_s_selection(struct file *file, void *fh,
> > +				  struct v4l2_selection *s)
> > +{
> > +	struct soc_camera_device *icd = file->private_data;
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> > +	int ret;
> > +
> > +	/* In all these cases cropping emulation will not help */
> > +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> > +	    (s->target != V4L2_SEL_TGT_COMPOSE_ACTIVE &&
> > +	     s->target != V4L2_SEL_TGT_CROP_ACTIVE))
> > +		return -EINVAL;
> > +
> > +	if (s->target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
> > +		/* No output size change during a running capture! */
> > +		if (is_streaming(ici, icd) &&
> > +		    (icd->user_width != s->r.width ||
> > +		     icd->user_height != s->r.height))
> > +			return -EBUSY;
> > +
> > +		/*
> > +		 * Only one user is allowed to change the output format, touch
> > +		 * buffers, start / stop streaming, poll for data
> > +		 */
> > +		if (icd->streamer && icd->streamer != file)
> > +			return -EBUSY;
> > +	}
> > +
> > +	if (!ici->ops->set_selection)
> > +		return -ENOTTY;
> > +
> > +	ret = ici->ops->set_selection(icd, s);
> > +	if (!ret &&
> > +	    s->target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
> > +		icd->user_width = s->r.width;
> > +		icd->user_height = s->r.height;
> > +		if (!icd->streamer)
> > +			icd->streamer = file;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> >  static int soc_camera_g_parm(struct file *file, void *fh,
> >  			     struct v4l2_streamparm *a)
> >  {
> > @@ -1405,6 +1464,8 @@ static const struct v4l2_ioctl_ops
> > soc_camera_ioctl_ops = { .vidioc_cropcap		 = soc_camera_cropcap,
> >  	.vidioc_g_crop		 = soc_camera_g_crop,
> >  	.vidioc_s_crop		 = soc_camera_s_crop,
> > +	.vidioc_g_selection	 = soc_camera_g_selection,
> > +	.vidioc_s_selection	 = soc_camera_s_selection,
> >  	.vidioc_g_parm		 = soc_camera_g_parm,
> >  	.vidioc_s_parm		 = soc_camera_s_parm,
> >  	.vidioc_g_chip_ident     = soc_camera_g_chip_ident,
> > diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> > index d865dcf..f997d6a 100644
> > --- a/include/media/soc_camera.h
> > +++ b/include/media/soc_camera.h
> > @@ -86,6 +86,8 @@ struct soc_camera_host_ops {
> >  	int (*cropcap)(struct soc_camera_device *, struct v4l2_cropcap *);
> >  	int (*get_crop)(struct soc_camera_device *, struct v4l2_crop *);
> >  	int (*set_crop)(struct soc_camera_device *, struct v4l2_crop *);
> > +	int (*get_selection)(struct soc_camera_device *, struct v4l2_selection 
> *);
> > +	int (*set_selection)(struct soc_camera_device *, struct v4l2_selection
> > *); /*
> >  	 * The difference to .set_crop() is, that .set_livecrop is not allowed
> >  	 * to change the output sizes
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
