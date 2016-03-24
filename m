Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:41070 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823AbcCXUpM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 16:45:12 -0400
Subject: Re: [PATCH] [media] media-devnode: Alloc cdev dynamically
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <3cfd380703d0fb2b756c96729ef417fa2a7a343d.1458849586.git.mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56F451CF.5060604@xs4all.nl>
Date: Thu, 24 Mar 2016 21:45:03 +0100
MIME-Version: 1.0
In-Reply-To: <3cfd380703d0fb2b756c96729ef417fa2a7a343d.1458849586.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/24/2016 08:59 PM, Mauro Carvalho Chehab wrote:
> Currently, cdev is embedded inside media_devnode. This causes
> a problem with the fs core, as __fput() will try to release
> its access by calling cdev_put():
> 
> [  399.653545] BUG: KASAN: use-after-free in media_release+0xe1/0xf0 [media] at addr ffff88036a9ba4e0
> [  399.653550] Read of size 8 by task mc_nextgen_test/19761
> [  399.653554] page:ffffea000daa6e80 count:0 mapcount:0 mapping:          (null) index:0xffff88036a9bad20
> [  399.653559] flags: 0x2ffff8000000000()
> [  399.653562] page dumped because: kasan: bad access detected
> [  399.653567] CPU: 1 PID: 19761 Comm: mc_nextgen_test Tainted: G    B           4.5.0+ #62
> [  399.653570] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
> [  399.653574]  ffff88036a9ba4e0 ffff8803c465fd10 ffffffff819447c1 ffff88036a9ba4e0
> [  399.653582]  ffff8803c465fda8 ffff8803c465fd98 ffffffff8156ef05 0000000800000001
> [  399.653591]  ffff8803c689fa10 0000000000000292 0000000041b58ab3 ffffffff82813e00
> [  399.653599] Call Trace:
> [  399.653604]  [<ffffffff819447c1>] dump_stack+0x85/0xc4
> [  399.653609]  [<ffffffff8156ef05>] kasan_report_error+0x525/0x550
> [  399.653615]  [<ffffffff81685d10>] ? __fsnotify_inode_delete+0x20/0x20
> [  399.653620]  [<ffffffff8124acd0>] ? debug_check_no_locks_freed+0x290/0x290
> [  399.653626]  [<ffffffff8156f063>] __asan_report_load8_noabort+0x43/0x50
> [  399.653633]  [<ffffffffa11f53b1>] ? media_release+0xe1/0xf0 [media]
> [  399.653640]  [<ffffffffa11f53b1>] media_release+0xe1/0xf0 [media]
> [  399.653646]  [<ffffffff815c2c4f>] __fput+0x20f/0x6d0
> [  399.653651]  [<ffffffff815c317e>] ____fput+0xe/0x10
> [  399.653656]  [<ffffffff811acde7>] task_work_run+0x137/0x200
> [  399.653662]  [<ffffffff81005d54>] exit_to_usermode_loop+0x154/0x180
> [  399.653667]  [<ffffffff8124a1b6>] ? trace_hardirqs_on_caller+0x16/0x590
> [  399.653672]  [<ffffffff810073a6>] syscall_return_slowpath+0x186/0x1c0
> [  399.653678]  [<ffffffff822e7a1c>] entry_SYSCALL_64_fastpath+0xbf/0xc1
> 
> There are two alternatives to solve it: we could either use a static
> var for cdev or to dynamically allocate it. Let's choose the last one,
> as this is the same solution at v4l2 core, from where this code seems
> to have originated.

For reference only: when I posted my CEC framework code it was based on what
v4l2-dev.c did, and I got yelled at by Russell King. I took his advice and
the new approach seems to work well without having to allocate cdev.

The code is here:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/100380/focus=100378

Search for cec_devnode_register.

Russell's mail is here:

http://www.spinics.net/lists/dri-devel/msg88417.html

However, the struct cec_adapter itself does have to be allocated, otherwise you
will get nasty lifetime issues. This seems to be a common theme: allocate the
main struct (cec_adapter, video_device, rc_device), then register the character
device as a separate step. On advantage of this is that a driver can allocate
everything first and do the registration of the devices as the last step when
it knows everything is consistent and initialized properly.

We've been embedding video_device/media_device in top-level structs and that looks
like it was a bad idea.

Digging into this mess is time consuming, but I thought I should at least share
this advice from Russell as an example.

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/media-devnode.c | 39 ++++++++++++++++++++++++++-------------
>  include/media/media-devnode.h |  4 ++--
>  2 files changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
> index db47063d8801..7f9a7e65df20 100644
> --- a/drivers/media/media-devnode.c
> +++ b/drivers/media/media-devnode.c
> @@ -56,6 +56,7 @@ static dev_t media_dev_t;
>   */
>  static DEFINE_MUTEX(media_devnode_lock);
>  static DECLARE_BITMAP(media_devnode_nums, MEDIA_NUM_DEVICES);
> +static struct media_devnode *media_minors[MEDIA_NUM_DEVICES];
>  
>  /* Called when the last user of the media device exits. */
>  static void media_devnode_release(struct device *cd)
> @@ -65,7 +66,9 @@ static void media_devnode_release(struct device *cd)
>  	mutex_lock(&media_devnode_lock);
>  
>  	/* Delete the cdev on this minor as well */
> -	cdev_del(&devnode->cdev);
> +	cdev_del(devnode->cdev);
> +	devnode->cdev = NULL;
> +	media_minors[devnode->minor] = NULL;
>  
>  	/* Mark device node number as free */
>  	clear_bit(devnode->minor, media_devnode_nums);
> @@ -167,9 +170,7 @@ static int media_open(struct inode *inode, struct file *filp)
>  	 * a crash.
>  	 */
>  	mutex_lock(&media_devnode_lock);
> -	devnode = container_of(inode->i_cdev, struct media_devnode, cdev);
> -	/* return ENXIO if the media device has been removed
> -	   already or if it is not registered anymore. */
> +	devnode = media_minors[iminor(inode)];
>  	if (!media_devnode_is_registered(devnode)) {
>  		mutex_unlock(&media_devnode_lock);
>  		return -ENXIO;
> @@ -227,6 +228,7 @@ int __must_check media_devnode_register(struct media_device *mdev,
>  {
>  	int minor;
>  	int ret;
> +	dev_t devt;
>  
>  	/* Part 1: Find a free minor number */
>  	mutex_lock(&media_devnode_lock);
> @@ -238,28 +240,35 @@ int __must_check media_devnode_register(struct media_device *mdev,
>  	}
>  
>  	set_bit(minor, media_devnode_nums);
> +	media_minors[minor] = devnode;
>  	mutex_unlock(&media_devnode_lock);
>  
> -	devnode->minor = minor;
> -	devnode->media_dev = mdev;
> -
>  	/* Part 2: Initialize and register the character device */
> -	cdev_init(&devnode->cdev, &media_devnode_fops);
> -	devnode->cdev.owner = owner;
> +	devnode->cdev = cdev_alloc();
> +	if (!devnode->cdev) {
> +		ret = -ENOMEM;
> +		goto error;
> +	}
>  
> -	ret = cdev_add(&devnode->cdev, MKDEV(MAJOR(media_dev_t), devnode->minor), 1);
> +	cdev_init(devnode->cdev, &media_devnode_fops);
> +	devnode->cdev->owner = owner;
> +
> +	devt = MKDEV(MAJOR(media_dev_t), minor);
> +	ret = cdev_add(devnode->cdev, devt, 1);
>  	if (ret < 0) {
>  		pr_err("%s: cdev_add failed\n", __func__);
>  		goto error;
>  	}
>  
>  	/* Part 3: Register the media device */
> +	devnode->minor = minor;
> +	devnode->media_dev = mdev;
>  	devnode->dev.bus = &media_bus_type;
> -	devnode->dev.devt = MKDEV(MAJOR(media_dev_t), devnode->minor);
> +	devnode->dev.devt = devt;
>  	devnode->dev.release = media_devnode_release;
>  	if (devnode->parent)
>  		devnode->dev.parent = devnode->parent;
> -	dev_set_name(&devnode->dev, "media%d", devnode->minor);
> +	dev_set_name(&devnode->dev, "media%d", minor);
>  	ret = device_register(&devnode->dev);
>  	if (ret < 0) {
>  		pr_err("%s: device_register failed\n", __func__);
> @@ -273,8 +282,12 @@ int __must_check media_devnode_register(struct media_device *mdev,
>  
>  error:
>  	mutex_lock(&media_devnode_lock);
> -	cdev_del(&devnode->cdev);
> +	if (devnode->cdev) {
> +		cdev_del(devnode->cdev);
> +		devnode->cdev = NULL;
> +	}
>  	clear_bit(devnode->minor, media_devnode_nums);
> +	media_minors[minor] = NULL;
>  	mutex_unlock(&media_devnode_lock);
>  
>  	return ret;
> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> index cc2b3155593c..9fe627ca5ec9 100644
> --- a/include/media/media-devnode.h
> +++ b/include/media/media-devnode.h
> @@ -71,7 +71,7 @@ struct media_file_operations {
>   * struct media_devnode - Media device node
>   * @fops:	pointer to struct &media_file_operations with media device ops
>   * @dev:	struct device pointer for the media controller device
> - * @cdev:	struct cdev pointer character device
> + * @cdev:      struct cdev pointer character device
>   * @parent:	parent device
>   * @minor:	device node minor number
>   * @flags:	flags, combination of the MEDIA_FLAG_* constants
> @@ -90,7 +90,7 @@ struct media_devnode {
>  
>  	/* sysfs */
>  	struct device dev;		/* media device */
> -	struct cdev cdev;		/* character device */
> +	struct cdev *cdev;		/* character device */
>  	struct device *parent;		/* device parent */
>  
>  	/* device info */
> 

