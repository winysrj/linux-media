Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59638 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3FGJwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 05:52:07 -0400
Date: Fri, 7 Jun 2013 11:52:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 04/13] soc_camera: remove use of current_norm.
In-Reply-To: <201306071148.04794.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1306071151250.11277@axis700.grange>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
 <1370252210-4994-5-git-send-email-hverkuil@xs4all.nl>
 <Pine.LNX.4.64.1306071136100.11277@axis700.grange> <201306071148.04794.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 7 Jun 2013, Hans Verkuil wrote:

> On Fri June 7 2013 11:36:57 Guennadi Liakhovetski wrote:
> > Hi Hans
> > 
> > On Mon, 3 Jun 2013, Hans Verkuil wrote:
> > 
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > The current_norm field is deprecated, so don't set it. Since it is set to
> > > V4L2_STD_UNKNOWN which is 0 it didn't do anything anyway.
> > > 
> > > Also remove a few other unnecessary uses of V4L2_STD_UNKNOWN.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > I'd rather take this via my tree to avoid any conflicts, is this ok with 
> > you?
> 
> Ideally I would like to take this in myself since the last patch of the series
> removes current_norm support entirely. If you take it, then I have to leave off
> the last patch until both our trees are merged.
> 
> If you still prefer to take it yourself, then let me know and I'll leave this
> patch and the last patch out when I merge it.

Ok, take it via your tree, we'll resolve any conflicts afterwards.

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Thanks
> > Guennadi
> > 
> > > ---
> > >  drivers/media/platform/soc_camera/soc_camera.c |    3 ---
> > >  1 file changed, 3 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> > > index eea832c..96645e9 100644
> > > --- a/drivers/media/platform/soc_camera/soc_camera.c
> > > +++ b/drivers/media/platform/soc_camera/soc_camera.c
> > > @@ -235,7 +235,6 @@ static int soc_camera_enum_input(struct file *file, void *priv,
> > >  
> > >  	/* default is camera */
> > >  	inp->type = V4L2_INPUT_TYPE_CAMERA;
> > > -	inp->std  = V4L2_STD_UNKNOWN;
> > >  	strcpy(inp->name, "Camera");
> > >  
> > >  	return 0;
> > > @@ -1513,11 +1512,9 @@ static int video_dev_create(struct soc_camera_device *icd)
> > >  	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
> > >  
> > >  	vdev->parent		= icd->pdev;
> > > -	vdev->current_norm	= V4L2_STD_UNKNOWN;
> > >  	vdev->fops		= &soc_camera_fops;
> > >  	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
> > >  	vdev->release		= video_device_release;
> > > -	vdev->tvnorms		= V4L2_STD_UNKNOWN;
> > >  	vdev->ctrl_handler	= &icd->ctrl_handler;
> > >  	vdev->lock		= &ici->host_lock;
> > >  
> > 
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
