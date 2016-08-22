Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36612 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753052AbcHVNw3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 09:52:29 -0400
Date: Mon, 22 Aug 2016 16:52:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, m.chehab@osg.samsung.com,
        shuahkh@osg.samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [RFC v2 08/17] media-device: Make devnode.dev->kobj parent of
 devnode.cdev
Message-ID: <20160822135224.GD12130@valkosipuli.retiisi.org.uk>
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-9-git-send-email-sakari.ailus@linux.intel.com>
 <d5315572-cd27-351c-0f39-d80f2974d652@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5315572-cd27-351c-0f39-d80f2974d652@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 22, 2016 at 02:17:28PM +0200, Hans Verkuil wrote:
> On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> > The struct cdev embedded in struct media_devnode contains its own kobj.
> > Instead of trying to manage its lifetime separately from struct
> > media_devnode, make the cdev kobj a parent of the struct media_device.dev
> > kobj.
> > 
> > The cdev will thus be released during unregistering the media_devnode, not
> > in media_devnode.dev kobj's release callback.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/media-devnode.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> > index aa8030b..69f84a7 100644
> > --- a/drivers/media/media-devnode.c
> > +++ b/drivers/media/media-devnode.c
> > @@ -63,9 +63,6 @@ static void media_devnode_release(struct device *cd)
> >  
> >  	mutex_lock(&media_devnode_lock);
> >  
> > -	/* Delete the cdev on this minor as well */
> > -	cdev_del(&devnode->cdev);
> > -
> >  	/* Mark device node number as free */
> >  	clear_bit(devnode->minor, media_devnode_nums);
> >  
> > @@ -246,6 +243,7 @@ int __must_check media_devnode_register(struct media_devnode *devnode,
> >  
> >  	/* Part 2: Initialize and register the character device */
> >  	cdev_init(&devnode->cdev, &media_devnode_fops);
> > +	devnode->cdev.kobj.parent = &devnode->dev.kobj;
> >  	devnode->cdev.owner = owner;
> >  
> >  	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
> > @@ -291,6 +289,7 @@ void media_devnode_unregister(struct media_devnode *devnode)
> >  	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
> >  	mutex_unlock(&media_devnode_lock);
> >  	device_unregister(&devnode->dev);
> > +	cdev_del(&devnode->cdev);
> 
> Are you sure about this order? Shouldn't cdev_del be called first?
> 
> The register() calls cdev_add() before device_add(), so I would expect the
> reverse order here. This is also what cec-core.c does.

Correct.

It's possible that device_unregister() releases the last reference to the
struct device, which in turn causes the memory to be released.

I'll fix that.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
