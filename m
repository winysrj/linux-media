Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37960 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180Ab1GDNUk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 09:20:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH] v4l: Don't register media entities for subdev device nodes
Date: Mon, 4 Jul 2011 15:21:09 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1302531990-5395-1-git-send-email-laurent.pinchart@ideasonboard.com> <4E11BBF9.4000201@matrix-vision.de>
In-Reply-To: <4E11BBF9.4000201@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041521.10191.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Monday 04 July 2011 15:11:21 Michael Jones wrote:
> On 04/11/2011 04:26 PM, Laurent Pinchart wrote:
> > Subdevs already have their own entity, don't register as second one when
> > registering the subdev device node.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/v4l2-dev.c |   15 ++++++++++-----
> >  1 files changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-dev.c
> > b/drivers/media/video/v4l2-dev.c index 498e674..6dc7196 100644
> > --- a/drivers/media/video/v4l2-dev.c
> > +++ b/drivers/media/video/v4l2-dev.c
> > @@ -389,7 +389,8 @@ static int v4l2_open(struct inode *inode, struct file
> > *filp)
> > 
> >  	video_get(vdev);
> >  	mutex_unlock(&videodev_lock);
> >  
> >  #if defined(CONFIG_MEDIA_CONTROLLER)
> > 
> > -	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
> > +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> > +	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
> > 
> >  		entity = media_entity_get(&vdev->entity);
> >  		if (!entity) {
> >  		
> >  			ret = -EBUSY;
> > 
> > @@ -415,7 +416,8 @@ err:
> >  	/* decrease the refcount in case of an error */
> >  	if (ret) {
> >  
> >  #if defined(CONFIG_MEDIA_CONTROLLER)
> > 
> > -		if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
> > +		if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> > +		    vdev->vfl_type != VFL_TYPE_SUBDEV)
> > 
> >  			media_entity_put(entity);
> >  
> >  #endif
> >  
> >  		video_put(vdev);
> > 
> > @@ -437,7 +439,8 @@ static int v4l2_release(struct inode *inode, struct
> > file *filp)
> > 
> >  			mutex_unlock(vdev->lock);
> >  	
> >  	}
> >  
> >  #if defined(CONFIG_MEDIA_CONTROLLER)
> > 
> > -	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
> > +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> > +	    vdev->vfl_type != VFL_TYPE_SUBDEV)
> > 
> >  		media_entity_put(&vdev->entity);
> >  
> >  #endif
> >  
> >  	/* decrease the refcount unconditionally since the release()
> > 
> > @@ -686,7 +689,8 @@ int __video_register_device(struct video_device
> > *vdev, int type, int nr,
> > 
> >  #if defined(CONFIG_MEDIA_CONTROLLER)
> >  
> >  	/* Part 5: Register the entity. */
> > 
> > -	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev) {
> > +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> > +	    vdev->vfl_type != VFL_TYPE_SUBDEV) {
> > 
> >  		vdev->entity.type = MEDIA_ENT_T_DEVNODE_V4L;
> >  		vdev->entity.name = vdev->name;
> >  		vdev->entity.v4l.major = VIDEO_MAJOR;
> > 
> > @@ -733,7 +737,8 @@ void video_unregister_device(struct video_device
> > *vdev)
> > 
> >  		return;
> >  
> >  #if defined(CONFIG_MEDIA_CONTROLLER)
> > 
> > -	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev)
> > +	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> > +	    vdev->vfl_type != VFL_TYPE_SUBDEV)
> > 
> >  		media_device_unregister_entity(&vdev->entity);
> >  
> >  #endif
> 
> Hi Laurent,
> 
> If v4l2_subdev has a 'struct media_entity' inside of its 'struct
> video_device' member, why does it need a media_entity of its own?
> Shouldn't we eliminate v4l2_subdev.entity and always just use
> v4l2_subdev.devnode.entity where it is needed?  Or do they have 2
> different purposes?

Not all subdevs have a devnode. struct video_device is embedded in struct 
v4l2_subdev, but it's not used for devnode-less subdevs.

-- 
Regards,

Laurent Pinchart
