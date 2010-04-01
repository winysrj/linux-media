Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1924 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab0DALLX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 07:11:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: V4L-DVB drivers and BKL
Date: Thu, 1 Apr 2010 13:11:51 +0200
Cc: linux-media@vger.kernel.org
References: <201004011001.10500.hverkuil@xs4all.nl> <201004011123.31080.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201004011123.31080.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011311.51505.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 April 2010 11:23:30 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 01 April 2010 10:01:10 Hans Verkuil wrote:
> > Hi all,
> > 
> > I just read on LWN that the core kernel guys are putting more effort into
> > removing the BKL. We are still using it in our own drivers, mostly V4L.
> > 
> > I added a BKL column to my driver list:
> > 
> > http://www.linuxtv.org/wiki/index.php/V4L_framework_progress#Bridge_Drivers
> > 
> > If you 'own' one of these drivers that still use BKL, then it would be nice
> > if you can try and remove the use of the BKL from those drivers.
> > 
> > The other part that needs to be done is to move from using the .ioctl file
> > op to using .unlocked_ioctl. Very few drivers do that, but I suspect
> > almost no driver actually needs to use .ioctl.
> 
> What about something like this patch as a first step ?

That doesn't fix anything. You just move the BKL from one place to another.
I don't see any benefit from that.

Regards,

	Hans

> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 7090699..14e1b1c 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -25,6 +25,7 @@
>  #include <linux/init.h>
>  #include <linux/kmod.h>
>  #include <linux/slab.h>
> +#include <linux/smp_lock.h>
>  #include <asm/uaccess.h>
>  #include <asm/system.h>
>  
> @@ -215,28 +216,22 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
>  	return vdev->fops->poll(filp, poll);
>  }
>  
> -static int v4l2_ioctl(struct inode *inode, struct file *filp,
> -		unsigned int cmd, unsigned long arg)
> -{
> -	struct video_device *vdev = video_devdata(filp);
> -
> -	if (!vdev->fops->ioctl)
> -		return -ENOTTY;
> -	/* Allow ioctl to continue even if the device was unregistered.
> -	   Things like dequeueing buffers might still be useful. */
> -	return vdev->fops->ioctl(filp, cmd, arg);
> -}
> -
>  static long v4l2_unlocked_ioctl(struct file *filp,
>  		unsigned int cmd, unsigned long arg)
>  {
>  	struct video_device *vdev = video_devdata(filp);
> +	int ret = -ENOTTY;
>  
> -	if (!vdev->fops->unlocked_ioctl)
> -		return -ENOTTY;
>  	/* Allow ioctl to continue even if the device was unregistered.
>  	   Things like dequeueing buffers might still be useful. */
> -	return vdev->fops->unlocked_ioctl(filp, cmd, arg);
> +	if (vdev->fops->ioctl) {
> +		lock_kernel();
> +		ret = vdev->fops->ioctl(filp, cmd, arg);
> +		unlock_kernel();
> +	} else if (vdev->fops->unlocked_ioctl)
> +		ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> +
> +	return ret;
>  }
>  
>  #ifdef CONFIG_MMU
> @@ -323,22 +318,6 @@ static const struct file_operations v4l2_unlocked_fops = {
>  	.llseek = no_llseek,
>  };
>  
> -static const struct file_operations v4l2_fops = {
> -	.owner = THIS_MODULE,
> -	.read = v4l2_read,
> -	.write = v4l2_write,
> -	.open = v4l2_open,
> -	.get_unmapped_area = v4l2_get_unmapped_area,
> -	.mmap = v4l2_mmap,
> -	.ioctl = v4l2_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl = v4l2_compat_ioctl32,
> -#endif
> -	.release = v4l2_release,
> -	.poll = v4l2_poll,
> -	.llseek = no_llseek,
> -};
> -
>  /**
>   * get_index - assign stream index number based on parent device
>   * @vdev: video_device to assign index number to, vdev->parent should be assigned
> @@ -517,10 +496,7 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
>  		ret = -ENOMEM;
>  		goto cleanup;
>  	}
> -	if (vdev->fops->unlocked_ioctl)
> -		vdev->cdev->ops = &v4l2_unlocked_fops;
> -	else
> -		vdev->cdev->ops = &v4l2_fops;
> +	vdev->cdev->ops = &v4l2_unlocked_fops;
>  	vdev->cdev->owner = vdev->fops->owner;
>  	ret = cdev_add(vdev->cdev, MKDEV(VIDEO_MAJOR, vdev->minor), 1);
>  	if (ret < 0) {
> 
> A second step would be to replace lock_kernel/unlock_kernel with a
> V4L-specific lock, and the third step to push the lock into drivers.
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
