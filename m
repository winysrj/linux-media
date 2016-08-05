Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:64569 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161157AbcHEK7L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 06:59:11 -0400
Subject: Re: [RFC 05/16] media: devnode: Refcount the media devnode
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
 <1468535711-13836-6-git-send-email-sakari.ailus@linux.intel.com>
 <8fc0fda7-ea09-2520-c536-228b2c03a93e@xs4all.nl>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <57A47177.5000706@linux.intel.com>
Date: Fri, 5 Aug 2016 13:59:03 +0300
MIME-Version: 1.0
In-Reply-To: <8fc0fda7-ea09-2520-c536-228b2c03a93e@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> 
> 
> On 07/15/2016 12:35 AM, Sakari Ailus wrote:
>> Add reference count to the media devnode. The media_devnode is intended to
>> be embedded in another struct such as media_device.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  drivers/media/media-device.c  |   7 +--
>>  drivers/media/media-devnode.c | 114 +++++++++++++++++++++++++++++++++---------
>>  include/media/media-devnode.h |  47 +++++++++++++----
>>  3 files changed, 133 insertions(+), 35 deletions(-)
>>
>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>> index 8bdc316..a11b3be 100644
>> --- a/drivers/media/media-device.c
>> +++ b/drivers/media/media-device.c
>> @@ -531,7 +531,8 @@ static const struct media_file_operations media_device_fops = {
>>  static ssize_t show_model(struct device *cd,
>>  			  struct device_attribute *attr, char *buf)
>>  {
>> -	struct media_device *mdev = to_media_device(to_media_devnode(cd));
>> +	struct media_device *mdev = to_media_device(
>> +		to_media_devnode_cdev(cd)->devnode);
>>  
>>  	return sprintf(buf, "%.*s\n", (int)sizeof(mdev->model), mdev->model);
>>  }
>> @@ -717,7 +718,7 @@ int __must_check __media_device_register(struct media_device *mdev,
>>  	if (ret < 0)
>>  		return ret;
>>  
>> -	ret = device_create_file(&mdev->devnode.dev, &dev_attr_model);
>> +	ret = device_create_file(&mdev->devnode.mdc->dev, &dev_attr_model);
>>  	if (ret < 0) {
>>  		media_devnode_unregister(&mdev->devnode);
>>  		return ret;
>> @@ -793,7 +794,7 @@ void media_device_unregister(struct media_device *mdev)
>>  
>>  	mutex_unlock(&mdev->graph_mutex);
>>  
>> -	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
>> +	device_remove_file(&mdev->devnode.mdc->dev, &dev_attr_model);
>>  	dev_dbg(mdev->dev, "Media device unregistering\n");
>>  	media_devnode_unregister(&mdev->devnode);
>>  }
>> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
>> index 7481c96..566ef08 100644
>> --- a/drivers/media/media-devnode.c
>> +++ b/drivers/media/media-devnode.c
>> @@ -57,25 +57,54 @@ static DEFINE_MUTEX(media_devnode_lock);
>>  static DECLARE_BITMAP(media_devnode_nums, MEDIA_NUM_DEVICES);
>>  
>>  /* Called when the last user of the media device exits. */
>> -static void media_devnode_release(struct device *cd)
>> +static void media_devnode_device_release(struct device *cd)
>>  {
>> -	struct media_devnode *devnode = to_media_devnode(cd);
>> +	struct media_devnode_cdev *mdc = to_media_devnode_cdev(cd);
>>  
>> -	mutex_lock(&media_devnode_lock);
>> +	dev_dbg(cd, "release media devnode device\n");
>>  
>>  	/* Delete the cdev on this minor as well */
>> -	cdev_del(&devnode->cdev);
>> +	cdev_del(&mdc->cdev);
>>  
>>  	/* Mark device node number as free */
>> -	clear_bit(devnode->minor, media_devnode_nums);
>> -
>> +	mutex_lock(&media_devnode_lock);
>> +	clear_bit(MINOR(mdc->cdev.dev), media_devnode_nums);
>>  	mutex_unlock(&media_devnode_lock);
>> +}
>> +
>> +static void media_devnode_release(struct kref *kref)
>> +{
>> +	struct media_devnode *devnode =
>> +		container_of(kref, struct media_devnode, kref);
>> +
>> +	dev_dbg(&devnode->mdc->dev, "release media devnode\n");
>> +
>> +	put_device(&devnode->mdc->dev);
>>  
>>  	/* Release media_devnode and perform other cleanups as needed. */
>>  	if (devnode->release)
>>  		devnode->release(devnode);
>>  }
>>  
>> +void media_devnode_init(struct media_devnode *devnode)
>> +{
>> +	kref_init(&devnode->kref);
>> +	devnode->use_kref = true;
>> +}
>> +EXPORT_SYMBOL_GPL(media_devnode_init);
>> +
>> +void media_devnode_get(struct media_devnode *devnode)
>> +{
>> +	kref_get(&devnode->kref);
>> +}
>> +EXPORT_SYMBOL_GPL(media_devnode_get);
>> +
>> +void media_devnode_put(struct media_devnode *devnode)
>> +{
>> +	kref_put(&devnode->kref, media_devnode_release);
>> +}
>> +EXPORT_SYMBOL_GPL(media_devnode_put);
>> +
>>  static struct bus_type media_bus_type = {
>>  	.name = MEDIA_NAME,
>>  };
>> @@ -164,7 +193,8 @@ static int media_open(struct inode *inode, struct file *filp)
>>  	 * a crash.
>>  	 */
>>  	mutex_lock(&media_devnode_lock);
>> -	devnode = container_of(inode->i_cdev, struct media_devnode, cdev);
>> +	devnode = container_of(inode->i_cdev,
>> +			       struct media_devnode_cdev, cdev)->devnode;
>>  	/* return ENXIO if the media device has been removed
>>  	   already or if it is not registered anymore. */
>>  	if (!media_devnode_is_registered(devnode)) {
>> @@ -172,7 +202,10 @@ static int media_open(struct inode *inode, struct file *filp)
>>  		return -ENXIO;
>>  	}
>>  	/* and increase the device refcount */
>> -	get_device(&devnode->dev);
>> +	if (devnode->use_kref)
>> +		media_devnode_get(devnode);
>> +	else
>> +		get_device(&devnode->mdc->dev);
>>  	mutex_unlock(&media_devnode_lock);
>>  
>>  	filp->private_data = devnode;
>> @@ -180,7 +213,10 @@ static int media_open(struct inode *inode, struct file *filp)
>>  	if (devnode->fops->open) {
>>  		ret = devnode->fops->open(filp);
>>  		if (ret) {
>> -			put_device(&devnode->dev);
>> +			if (devnode->use_kref)
>> +				media_devnode_put(devnode);
>> +			else
>> +				put_device(&devnode->mdc->dev);
>>  			filp->private_data = NULL;
>>  			return ret;
>>  		}
>> @@ -201,7 +237,11 @@ static int media_release(struct inode *inode, struct file *filp)
>>  
>>  	/* decrease the refcount unconditionally since the release()
>>  	   return value is ignored. */
>> -	put_device(&devnode->dev);
>> +	if (devnode->use_kref)
>> +		media_devnode_put(devnode);
>> +	else
>> +		put_device(&devnode->mdc->dev);
>> +
>>  	return 0;
>>  }
>>  
>> @@ -222,14 +262,20 @@ static const struct file_operations media_devnode_fops = {
>>  int __must_check media_devnode_register(struct media_devnode *devnode,
>>  					struct module *owner)
>>  {
>> +	struct media_devnode_cdev *mdc;
>>  	int minor;
>>  	int ret;
>>  
>> +	mdc = kzalloc(sizeof(*mdc), GFP_KERNEL);
> 
> Why is this no longer embedded in struct media_devnode? I see no reason for that
> change.

The lifetime of the cdev can be different from the media_devnode.

> 
>> +	if (!mdc)
>> +		return -ENOMEM;
>> +
>>  	/* Part 1: Find a free minor number */
>>  	mutex_lock(&media_devnode_lock);
>>  	minor = find_next_zero_bit(media_devnode_nums, MEDIA_NUM_DEVICES, 0);
>>  	if (minor == MEDIA_NUM_DEVICES) {
>>  		mutex_unlock(&media_devnode_lock);
>> +		kfree(mdc);
>>  		pr_err("could not get a free minor\n");
>>  		return -ENFILE;
>>  	}
>> @@ -240,23 +286,26 @@ int __must_check media_devnode_register(struct media_devnode *devnode,
>>  	devnode->minor = minor;
>>  
>>  	/* Part 2: Initialize and register the character device */
>> -	cdev_init(&devnode->cdev, &media_devnode_fops);
>> -	devnode->cdev.owner = owner;
>> +	cdev_init(&mdc->cdev, &media_devnode_fops);
>> +	mdc->cdev.owner = owner;
>> +	mdc->devnode = devnode;
>> +	devnode->mdc = mdc;
>>  
>> -	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
>> +	ret = cdev_add(&mdc->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor),
>> +		       1);
>>  	if (ret < 0) {
>>  		pr_err("%s: cdev_add failed\n", __func__);
>>  		goto error;
>>  	}
>>  
>>  	/* Part 3: Register the media device */
>> -	devnode->dev.bus = &media_bus_type;
>> -	devnode->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
>> -	devnode->dev.release = media_devnode_release;
>> +	devnode->mdc->dev.bus = &media_bus_type;
>> +	devnode->mdc->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
>> +	devnode->mdc->dev.release = media_devnode_device_release;
>>  	if (devnode->parent)
>> -		devnode->dev.parent = devnode->parent;
>> -	dev_set_name(&devnode->dev, "media%d", devnode->minor);
>> -	ret = device_register(&devnode->dev);
>> +		devnode->mdc->dev.parent = devnode->parent;
>> +	dev_set_name(&devnode->mdc->dev, "media%d", devnode->minor);
>> +	ret = device_register(&devnode->mdc->dev);
>>  	if (ret < 0) {
>>  		pr_err("%s: device_register failed\n", __func__);
>>  		goto error;
>> @@ -265,14 +314,19 @@ int __must_check media_devnode_register(struct media_devnode *devnode,
>>  	/* Part 4: Activate this minor. The char device can now be used. */
>>  	set_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
>>  
>> +	/* For us, reference released in media_devnode_release(). */
>> +	get_device(&devnode->mdc->dev);
>> +
> 
> I would really like to see this synced with what drivers/staging/media/cec/cec-core.c is
> doing. That code is similar to what other subsystems are doing and seems to be according
> to best practices. What we do in v4l2-dev.c is certainly NOT according to best practices.
> 
> One of the things I'd like to do is to fix v4l2-dev.c as well, but that will take time.
> 
> Ideally all the code that registers device nodes should all use the same method. That makes
> it easier to review and to fix issues in the future.

Good point. Let me check this and update the set accordingly.

> 
>>  	return 0;
>>  
>>  error:
>>  	mutex_lock(&media_devnode_lock);
>> -	cdev_del(&devnode->cdev);
>> +	cdev_del(&mdc->cdev);
>>  	clear_bit(devnode->minor, media_devnode_nums);
>>  	mutex_unlock(&media_devnode_lock);
>>  
>> +	kfree(mdc);
>> +
>>  	return ret;
>>  }
>>  
>> @@ -282,16 +336,30 @@ void media_devnode_unregister(struct media_devnode *devnode)
>>  	if (!media_devnode_is_registered(devnode))
>>  		return;
>>  
>> +	dev_dbg(&devnode->mdc->dev, "unregister media devnode\n");
>> +
>> +	device_unregister(&devnode->mdc->dev);
>> +
>>  	mutex_lock(&media_devnode_lock);
>>  	clear_bit(MEDIA_FLAG_REGISTERED, &devnode->flags);
>>  	mutex_unlock(&media_devnode_lock);
>> -	device_unregister(&devnode->dev);
>> +
>> +	if (!devnode->use_kref) {
>> +		media_devnode_device_release(&devnode->mdc->dev);
>> +
>> +		if (devnode->release)
>> +			devnode->release(devnode);
>> +
>> +		return;
>> +	}
>> +
>> +	media_devnode_put(devnode);
>>  }
>>  
>>  /*
>>   *	Initialise media for linux
>>   */
>> -static int __init media_devnode_init(void)
>> +static int __init __media_devnode_init(void)
>>  {
>>  	int ret;
>>  
>> @@ -319,7 +387,7 @@ static void __exit media_devnode_exit(void)
>>  	unregister_chrdev_region(media_dev_t, MEDIA_NUM_DEVICES);
>>  }
>>  
>> -subsys_initcall(media_devnode_init);
>> +subsys_initcall(__media_devnode_init);
>>  module_exit(media_devnode_exit)
>>  
>>  MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
>> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
>> index a0f6823..4e9d066 100644
>> --- a/include/media/media-devnode.h
>> +++ b/include/media/media-devnode.h
>> @@ -28,10 +28,11 @@
>>  #ifndef _MEDIA_DEVNODE_H
>>  #define _MEDIA_DEVNODE_H
>>  
>> -#include <linux/poll.h>
>> -#include <linux/fs.h>
>> -#include <linux/device.h>
>>  #include <linux/cdev.h>
>> +#include <linux/device.h>
>> +#include <linux/fs.h>
>> +#include <linux/kref.h>
>> +#include <linux/poll.h>
>>  
>>  /*
>>   * Flag to mark the media_devnode struct as registered. Drivers must not touch
>> @@ -65,15 +66,24 @@ struct media_file_operations {
>>  	int (*release) (struct file *);
>>  };
>>  
>> +struct media_devnode_cdev {
>> +	struct device dev;		/* media device */
>> +	struct cdev cdev;		/* character device */
>> +	struct media_devnode *devnode;	/* pointer to media_devnode */
>> +};
>> +
>> +#define to_media_devnode_cdev(cd) \
>> +	container_of(cd, struct media_devnode_cdev, dev)
>> +
>>  /**
>>   * struct media_devnode - Media device node
>>   * @media_dev:	pointer to struct &media_device
>>   * @fops:	pointer to struct &media_file_operations with media device ops
>> - * @dev:	pointer to struct &device containing the media controller device
>> - * @cdev:	struct cdev pointer character device
>>   * @parent:	parent device
>>   * @minor:	device node minor number
>>   * @flags:	flags, combination of the MEDIA_FLAG_* constants
>> + * @kref:	kref to this object
>> + * @use_kref:	tell whether we're using kref or not (TEMPORARY)
> 
> You say this is temporary, but it is never removed. I don't see why you need
> a kref at all, usually you just use put/get_device(&devnode->dev).

Well, that's perhaps worded badly. It's required as long as there are
drivers that haven't been converted yet. The set currently converts only
omap3isp driver. I think it'd be good to review the framework changes
before making more changes to the drivers.

Converting all the drivers so that they would actually be safe to remove
whilst in use would require a lot of driver changes, requiring e.g. the
removal of devm_() usage. I don't think that should be done by this
patchset.

> 
>>   * @release:	release callback called at the end of media_devnode_release()
>>   *
>>   * This structure represents a media-related device node.
>> @@ -86,20 +96,39 @@ struct media_devnode {
>>  	const struct media_file_operations *fops;
>>  
>>  	/* sysfs */
>> -	struct device dev;		/* media device */
>> -	struct cdev cdev;		/* character device */
>>  	struct device *parent;		/* device parent */
>>  
>>  	/* device info */
>>  	int minor;
>>  	unsigned long flags;		/* Use bitops to access flags */
>> +	struct media_devnode_cdev *mdc;
>> +	struct kref kref;
>> +	bool use_kref;
>>  
>>  	/* callbacks */
>>  	void (*release)(struct media_devnode *devnode);
>>  };
>>  
>> -/* dev to media_devnode */
>> -#define to_media_devnode(cd) container_of(cd, struct media_devnode, dev)
>> +/**
>> + * media_devnode_init - initialise a media device node (with kref)
>> + *
>> + * devnode: the device node to be initialised
>> + */
>> +void media_devnode_init(struct media_devnode *devnode);
>> +
>> +/**
>> + * media_devnode_get - get a reference to a media device node
>> + *
>> + * @devnode: the device node to get a reference to
>> + */
>> +void media_devnode_get(struct media_devnode *devnode);
>> +
>> +/**
>> + * media_devnode_put - put a reference to a media device node
>> + *
>> + * @devnode: the device node to put a reference from
>> + */
>> +void media_devnode_put(struct media_devnode *devnode);
>>  
>>  /**
>>   * media_devnode_register - register a media device node
>>
> 
> Regards,
> 
> 	Hans
> 


-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
