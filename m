Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39927 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705Ab1IMJpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 05:45:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3] V4L: dynamically allocate video_device nodes in subdevices
Date: Tue, 13 Sep 2011 11:45:42 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1109091701060.915@axis700.grange> <201109131116.35408.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1109131124590.17902@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109131124590.17902@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109131145.43199.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 13 September 2011 11:26:23 Guennadi Liakhovetski wrote:
> On Tue, 13 Sep 2011, Laurent Pinchart wrote:
> > On Monday 12 September 2011 12:55:46 Guennadi Liakhovetski wrote:
> > > Currently only very few drivers actually use video_device nodes,
> > > embedded in struct v4l2_subdev. Allocate these nodes dynamically for
> > > those drivers to save memory for the rest.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > > 
> > > v3: addressed comments from Laurent Pinchart - thanks
> > 
> > Thanks for the patch. Just one small comment below.
> > 
> > > 1. switch to using a device-release method, instead of freeing directly
> > > in v4l2_device_unregister_subdev()
> > > 
> > > 2. switch to using drvdata instead of a wrapper struct
> > > 
> > >  drivers/media/video/v4l2-device.c |   41
> > > 
> > > ++++++++++++++++++++++++++++++++---- include/media/v4l2-subdev.h      
> > > |
> > > 
> > >  4 +-
> > >  2 files changed, 38 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/v4l2-device.c
> > > b/drivers/media/video/v4l2-device.c index c72856c..9bf3d70 100644
> > > --- a/drivers/media/video/v4l2-device.c
> > > +++ b/drivers/media/video/v4l2-device.c
> > > @@ -21,6 +21,7 @@
> > > 
> > >  #include <linux/types.h>
> > >  #include <linux/ioctl.h>
> > >  #include <linux/i2c.h>
> > > 
> > > +#include <linux/slab.h>
> > > 
> > >  #if defined(CONFIG_SPI)
> > >  #include <linux/spi/spi.h>
> > >  #endif
> > > 
> > > @@ -191,6 +192,13 @@ int v4l2_device_register_subdev(struct v4l2_device
> > > *v4l2_dev, }
> > > 
> > >  EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
> > > 
> > > +void v4l2_device_release_subdev_node(struct video_device *vdev)
> > > +{
> > > +	struct v4l2_subdev *sd = video_get_drvdata(vdev);
> > > +	sd->devnode = NULL;
> > > +	kfree(vdev);
> > > +}
> > > +
> > > 
> > >  int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
> > >  {
> > >  
> > >  	struct video_device *vdev;
> > > 
> > > @@ -204,22 +212,42 @@ int v4l2_device_register_subdev_nodes(struct
> > > v4l2_device *v4l2_dev) if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
> > > 
> > >  			continue;
> > > 
> > > -		vdev = &sd->devnode;
> > > +		vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> > > +		if (!vdev) {
> > > +			err = -ENOMEM;
> > > +			goto clean_up;
> > > +		}
> > > +
> > > +		video_set_drvdata(vdev, sd);
> > > 
> > >  		strlcpy(vdev->name, sd->name, sizeof(vdev->name));
> > >  		vdev->v4l2_dev = v4l2_dev;
> > >  		vdev->fops = &v4l2_subdev_fops;
> > > 
> > > -		vdev->release = video_device_release_empty;
> > > +		vdev->release = v4l2_device_release_subdev_node;
> > > 
> > >  		vdev->ctrl_handler = sd->ctrl_handler;
> > >  		err = __video_register_device(vdev, VFL_TYPE_SUBDEV, -1, 1,
> > >  		
> > >  					      sd->owner);
> > > 
> > > -		if (err < 0)
> > > -			return err;
> > > +		if (err < 0) {
> > > +			kfree(vdev);
> > > +			goto clean_up;
> > > +		}
> > > +		get_device(&vdev->dev);
> > 
> > Is get_device() (and the corresponding put_device() calls below) required
> > ? I thought device_register() initialized the reference count to 1
> > (don't take my word for it though).
> 
> Indeed, I think, you're right. Will update.

Please test it as well :-)

-- 
Regards,

Laurent Pinchart
