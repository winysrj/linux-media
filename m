Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4807 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3FGK3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 06:29:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC PATCH 05/13] soc_camera: replace vdev->parent by vdev->v4l2_dev.
Date: Fri, 7 Jun 2013 12:29:39 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl> <Pine.LNX.4.64.1306071129580.11277@axis700.grange> <201306071141.30383.hverkuil@xs4all.nl>
In-Reply-To: <201306071141.30383.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306071229.39416.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri June 7 2013 11:41:30 Hans Verkuil wrote:
> On Fri June 7 2013 11:33:16 Guennadi Liakhovetski wrote:
> > On Mon, 3 Jun 2013, Hans Verkuil wrote:
> > 
> > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > 
> > > The parent field will eventually disappear to be replaced by v4l2_dev.
> > > soc_camera does provide a v4l2_device struct but did not point to it in
> > > struct video_device. This is now fixed.
> > > 
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > >  drivers/media/platform/soc_camera/soc_camera.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> > > index 96645e9..ea951ec 100644
> > > --- a/drivers/media/platform/soc_camera/soc_camera.c
> > > +++ b/drivers/media/platform/soc_camera/soc_camera.c
> > > @@ -524,7 +524,7 @@ static int soc_camera_open(struct file *file)
> > >  		return -ENODEV;
> > >  	}
> > >  
> > > -	icd = dev_get_drvdata(vdev->parent);
> > > +	icd = dev_get_drvdata(vdev->v4l2_dev->dev);
> > >  	ici = to_soc_camera_host(icd->parent);
> > >  
> > >  	ret = try_module_get(ici->ops->owner) ? 0 : -ENODEV;
> > > @@ -1511,7 +1511,7 @@ static int video_dev_create(struct soc_camera_device *icd)
> > >  
> > >  	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
> > >  
> > > -	vdev->parent		= icd->pdev;
> > > +	vdev->v4l2_dev		= &ici->v4l2_dev;
> > >  	vdev->fops		= &soc_camera_fops;
> > >  	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
> > >  	vdev->release		= video_device_release;
> > 
> > Doesn't it break soc-camera?... I think those are 2 absolutely different 
> > devices, so, you're not getting icd from 
> > dev_get_drvdata(vdev->v4l2_dev->dev).
> 
> I'm looking into this today. I managed to get my renesas board up and running
> again yesterday, so I have a decent soc-camera test environment.
> 
> This was the one patch that I wasn't sure about, so it definitely needs more
> analysis. I'll remove it from the patch series anyway, since it is unrelated
> to the current_norm changes.

Yes, it breaks soc_camera. I have a proper fix for this, but I'm postponing
this.

Stupid question perhaps, but why is soc_camera_device a platform_device?
It's weird. The camera host device is definitely a platform_device, and
the video nodes are childs of that platform_device, but soc_camera_device
doesn't map to any hardware.

Regards,

	Hans
