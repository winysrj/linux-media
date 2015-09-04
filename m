Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34293 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760032AbbIDQOE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 12:14:04 -0400
Date: Fri, 4 Sep 2015 13:13:58 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v8 53/55] [media] v4l2-core: create MC interfaces for
 devnodes
Message-ID: <20150904131358.6dc38cb5@recife.lan>
In-Reply-To: <55E4556F.4030801@xs4all.nl>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<51ba7f932951fb758e42c9cd93467b71668a8533.1440902901.git.mchehab@osg.samsung.com>
	<55E4556F.4030801@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2015 15:23:59 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/30/2015 05:07 AM, Mauro Carvalho Chehab wrote:
> > V4L2 device (and subdevice) nodes should create an
> > interface, if the Media Controller support is enabled.
> > 
> > Please notice that radio devices should not create an
> > entity, as radio input/output is either via wires or
> > via ALSA.
> 
> A general note: I think this patch (and any prerequisite patches) should come before
> the patches adding G_TOPOLOGY support.
> 
> What the G_TOPOLOGY ioctl returns only makes sense IMHO if this code is present as well,
> so it is a more logical order for this patch series.
> 
> In addition, since G_TOPOLOGY is a userspace API it is likely that that will create
> more discussions, whereas this is internal to the kernel and could be merged before
> G_TOPOLOGY.
> 
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> > index 44b330589787..427a5a32b3de 100644
> > --- a/drivers/media/v4l2-core/v4l2-dev.c
> > +++ b/drivers/media/v4l2-core/v4l2-dev.c
> > @@ -194,9 +194,12 @@ static void v4l2_device_release(struct device *cd)
> >  	mutex_unlock(&videodev_lock);
> >  
> >  #if defined(CONFIG_MEDIA_CONTROLLER)
> > -	if (v4l2_dev->mdev &&
> > -	    vdev->vfl_type != VFL_TYPE_SUBDEV)
> > -		media_device_unregister_entity(&vdev->entity);
> > +	if (v4l2_dev->mdev) {
> > +		/* Remove interfaces and interface links */
> > +		media_devnode_remove(vdev->intf_devnode);
> > +		if (vdev->vfl_type != VFL_TYPE_SUBDEV)
> > +			media_device_unregister_entity(&vdev->entity);
> 
> RADIO doesn't have an entity either, so this should probably check for both
> SUBDEV and RADIO.
> 
> I think it is cleaner if video_register_media_controller() sets a new video_device
> flag: V4L2_FL_CREATED_ENTITY, and if this release function would just check the
> flag.

I don't see the need for a new flag here. I guess this should do the job:

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 427a5a32b3de..298aaf6f4296 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -197,7 +197,7 @@ static void v4l2_device_release(struct device *cd)
 	if (v4l2_dev->mdev) {
 		/* Remove interfaces and interface links */
 		media_devnode_remove(vdev->intf_devnode);
-		if (vdev->vfl_type != VFL_TYPE_SUBDEV)
+		if (vdev->entity.type)
 			media_device_unregister_entity(&vdev->entity);
 	}
 #endif
@@ -775,6 +775,8 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 				__func__);
 			return ret;
 		}
+	} else {
+		vdev->entity.type = 0;
 	}
 
 	vdev->intf_devnode = media_devnode_create(vdev->v4l2_dev->mdev,

Regards,
Mauro
