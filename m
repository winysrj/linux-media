Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39973 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755722AbcKVJ6m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 04:58:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, mchehab@osg.samsung.com,
        shuahkh@osg.samsung.com
Subject: Re: [RFC v4 14/21] media device: Get the media device driver's device
Date: Tue, 22 Nov 2016 11:58:58 +0200
Message-ID: <2186924.rYqionKDuf@avalon>
In-Reply-To: <8ead9627-c333-6808-9aa6-571bff1d93ab@xs4all.nl>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk> <1478613330-24691-14-git-send-email-sakari.ailus@linux.intel.com> <8ead9627-c333-6808-9aa6-571bff1d93ab@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tuesday 22 Nov 2016 10:46:31 Hans Verkuil wrote:
> On 08/11/16 14:55, Sakari Ailus wrote:
> > The struct device of the media device driver (i.e. not that of the media
> > devnode) is pointed to by the media device. The struct device pointer is
> > mostly used for debug prints.
> > 
> > Ensure it will stay around as long as the media device does.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > 
> >  drivers/media/media-device.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> > index 2e52e44..648c64c 100644
> > --- a/drivers/media/media-device.c
> > +++ b/drivers/media/media-device.c
> > @@ -724,6 +724,7 @@ static void media_device_release(struct media_devnode
> > *devnode)
> >  	mdev->entity_internal_idx_max = 0;
> >  	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
> >  	mutex_destroy(&mdev->graph_mutex);
> > +	put_device(mdev->dev);
> >  	kfree(mdev);
> >  }
> > 
> > @@ -732,9 +733,15 @@ struct media_device *media_device_alloc(struct device
> > *dev)
> >  {
> >  	struct media_device *mdev;
> > 
> > +	dev = get_device(dev);
> > +	if (!dev)
> > +		return NULL;
> 
> I don't think this is right. When you allocate the media_device struct
> it should just be initialized, but not have any side effects until it is
> actually registered.
> 
> When the device is registered the device_add call will increase the parent's
> refcount as it should, thus ensuring it stays around for as long as is
> needed.

We're storing a pointer to dev in mdev a few lines below. As dev is 
refcounted, we need to ensure that we take a reference appropriately. We can 
either borrow a reference taken elsewhere or take our own reference.

Borrowing a reference is only valid if we know it will exist for at least as 
long as we need to borrow it. That might be the case when creating the media 
device as the driver performing the operation should hold a reference to the 
struct device instance (especially given that allocation and registration are 
usually - but not always - performed at probe time for that driver), but it's 
harder to guarantee at unregistration time, especially when userspace can keep 
device nodes open across unregistration. This patch ensures that the pointer 
always remains valid until we stop needing it.

> > +
> > 
> >  	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> > -	if (!mdev)
> > +	if (!mdev) {
> > +		put_device(dev);
> >  		return NULL;
> > +	}
> > 
> >  	mdev->dev = dev;

I would move the get_device() call here:

	mdev->dev = get_device(dev);
	if (!mdev->dev) {
		kfree(mdev);
		return NULL;
	}

I believe it makes the code more readable.

In theory we could even remove the error check, as we have a guarantee that 
the caller gives us a valid struct device reference, but I don't mind keeping 
it.

> >  	media_device_init(mdev);

-- 
Regards,

Laurent Pinchart

