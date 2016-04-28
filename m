Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47414 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbcD1Lrc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 07:47:32 -0400
Date: Thu, 28 Apr 2016 08:47:25 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
	<laurent.pinchart@ideasonboard.com>, <hans.verkuil@cisco.com>,
	<chehabrafael@gmail.com>, <sakari.ailus@iki.fi>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: fix media_ioctl use-after-free when driver
 unbinds
Message-ID: <20160428084725.1ee5d85c@recife.lan>
In-Reply-To: <57213591.3000109@osg.samsung.com>
References: <1461726512-9828-1-git-send-email-shuahkh@osg.samsung.com>
	<5720EC1A.8060101@metafoo.de>
	<57213591.3000109@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Apr 2016 15:56:33 -0600
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 04/27/2016 10:43 AM, Lars-Peter Clausen wrote:
> > Looks mostly good, a few comments.
> > 
> > On 04/27/2016 05:08 AM, Shuah Khan wrote:
> > [...]  
> >> @@ -428,7 +428,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
> >>  			       unsigned long arg)
> >>  {
> >>  	struct media_devnode *devnode = media_devnode_data(filp);
> >> -	struct media_device *dev = to_media_device(devnode);  
> > 
> > Can we keep the helper macro, means we don't need to touch this code.  
> 
> Yeah. I have been thinking about that as well. It avoids changes
> and abstracts it.

I don't like the idea of keeping the macro. It is used only on
two cases:

1) inside the core;
2) on two drivers that check if the media device is registered.

On the first case, if something changes, we want to be aware
about that. On the second case, IMHO, the best would be to have
a macro that would take struct media_device as argument, keeping
media_devnode hidden from drivers. 

> 
> >   
> >> +	struct media_device *dev = devnode->media_dev;  
> > 
> > You need a lock to protect this from running concurrently with
> > media_device_unregister() otherwise the struct might be freed while still in
> > use.
> >   
> 
> Right. This needs to be protected.
> 
> >>  	long ret;
> >>  
> >>  	switch (cmd) {  
> > [...]  
> >> @@ -725,21 +726,26 @@ int __must_check __media_device_register(struct media_device *mdev,
> >>  {
> >>  	int ret;
> >>  
> >> +	mdev->devnode = kzalloc(sizeof(struct media_devnode), GFP_KERNEL);  
> > 
> > sizeof(*mdev->devnode) is preferred kernel style,  
> 
> Yeah. Force of habit, I keep forgetting it.
> 
> >   
> >> +	if (!mdev->devnode)
> >> +		return -ENOMEM;
> >> +
> >>  	/* Register the device node. */
> >> -	mdev->devnode.fops = &media_device_fops;
> >> -	mdev->devnode.parent = mdev->dev;
> >> -	mdev->devnode.release = media_device_release;
> >> +	mdev->devnode->fops = &media_device_fops;
> >> +	mdev->devnode->parent = mdev->dev;
> >> +	mdev->devnode->media_dev = mdev;
> >> +	mdev->devnode->release = media_device_release;  
> > 
> > This should no longer be necessary. Just drop the release callback altogether.  
> 
> It does nothing at the moment. I believe the intent is for this routine
> to invoke any driver hooks if any at media_device level. It gets called
> from media_devnode_release() which is the media_devnode->dev.release.
> I will look into if it can be removed.

Right now, media_device_release callback is not used, except
to print that the device got removed, if debug enabled. Yet,
this is a separate change. Better to send such as a separate
patch.

> 
> >   
> >>  
> >>  	/* Set version 0 to indicate user-space that the graph is static */
> >>  	mdev->topology_version = 0;
> >>    
> > [...]  
> >> @@ -813,8 +819,10 @@ void media_device_unregister(struct media_device *mdev)
> >>  
> >>  	spin_unlock(&mdev->lock);
> >>  
> >> -	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
> >> -	media_devnode_unregister(&mdev->devnode);
> >> +	device_remove_file(&mdev->devnode->dev, &dev_attr_model);
> >> +	media_devnode_unregister(mdev->devnode);
> >> +	/* kfree devnode is done via kobject_put() handler */
> >> +	mdev->devnode = NULL;  
> > 
> > mdev->devnode->media_dev needs to be set to NULL.  
> 
> Yes. Thanks for catching it.
> 
> >   
> >>  
> >>  	dev_dbg(mdev->dev, "Media device unregistered\n");
> >>  }
> >> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> >> index 29409f4..9af9ba1 100644
> >> --- a/drivers/media/media-devnode.c
> >> +++ b/drivers/media/media-devnode.c
> >> @@ -171,6 +171,9 @@ static int media_open(struct inode *inode, struct file *filp)
> >>  		mutex_unlock(&media_devnode_lock);
> >>  		return -ENXIO;
> >>  	}
> >> +
> >> +	kobject_get(&mdev->kobj);  
> > 
> > This is not necessary, and if it was it would be prone to race condition as
> > the last reference could be dropped before this line. But assigning the cdev
> > parent makes sure that we always have a reference to the object while the
> > open() callback is running.  
> 
> I don't see cdev parent kobj get in cdev_get() which does kobject_get()
> on cdev->kobj. Is that enough to get the reference?
> 
> cdev_add() gets the cdev parent kobj and cdev_del() puts it back. That is
> the reason why I added a get here and put in media_release().
> 
> I can remove the get and put and test. Looks like I am not checking
> kobject_get() return value which isn't good?
> 
> >   
> >> +
> >>  	/* and increase the device refcount */
> >>  	get_device(&mdev->dev);
> >>  	mutex_unlock(&media_devnode_lock);
> >>  /*  
> > [...]  
> >> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> >> index fe42f08..ba4bdaa 100644
> >> --- a/include/media/media-devnode.h
> >> +++ b/include/media/media-devnode.h
> >> @@ -70,7 +70,9 @@ struct media_file_operations {
> >>   * @fops:	pointer to struct &media_file_operations with media device ops
> >>   * @dev:	struct device pointer for the media controller device
> >>   * @cdev:	struct cdev pointer character device
> >> + * @kobj:	struct kobject
> >>   * @parent:	parent device
> >> + * @media_dev:	media device
> >>   * @minor:	device node minor number
> >>   * @flags:	flags, combination of the MEDIA_FLAG_* constants
> >>   * @release:	release callback called at the end of media_devnode_release()
> >> @@ -87,7 +89,9 @@ struct media_devnode {
> >>  	/* sysfs */
> >>  	struct device dev;		/* media device */
> >>  	struct cdev cdev;		/* character device */
> >> +	struct kobject kobj;		/* set as cdev parent kobj */  
> > 
> > You don't need a extra kobj. Just use the struct dev kobj.  
> 
> Yeah I can use that as long as I can override the default release
> function with media_devnode_free(). media_devnode should stick around
> until the last app closes /dev/mediaX even if the media_device is no
> longer registered. i.e media_ioctl should be able to check if devnode
> is registered or not. I think I am missing something and don't understand
> how struct dev kobj can be used. 
> 
> >   
> >>  	struct device *parent;		/* device parent */
> >> +	struct media_device *media_dev; /* media device for the devnode */
> >>  
> >>  	/* device info */
> >>  	int minor;  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >   
> 


-- 
Thanks,
Mauro
