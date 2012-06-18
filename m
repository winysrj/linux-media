Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35215 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab2FRKBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 06:01:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 29/32] v4l2-dev.c: also add debug support for the fops.
Date: Mon, 18 Jun 2012 12:01:47 +0200
Message-ID: <7168376.Vf6x0R8Nod@avalon>
In-Reply-To: <5b43d9cfe9cf989cc2fd23140b7d76d2255b49f3.1339321562.git.hans.verkuil@cisco.com>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl> <5b43d9cfe9cf989cc2fd23140b7d76d2255b49f3.1339321562.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 10 June 2012 12:25:51 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-dev.c |   41 ++++++++++++++++++++++++++-----------
>  1 file changed, 29 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 5c0bb18..54f387d 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -305,6 +305,9 @@ static ssize_t v4l2_read(struct file *filp, char __user
> *buf, ret = vdev->fops->read(filp, buf, sz, off);
>  	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
>  		mutex_unlock(vdev->lock);
> +	if (vdev->debug)

As vdev->debug is a bitmask, shouldn't we add an fops debug bit ?

> +		pr_info("%s: read: %zd (%d)\n",
> +			video_device_node_name(vdev), sz, ret);

Shouldn't we use KERN_DEBUG instead of KERN_INFO ? BTW, what about replacing 
the pr_* calls with dev_* calls ?

>  	return ret;
>  }
> 
> @@ -323,6 +326,9 @@ static ssize_t v4l2_write(struct file *filp, const char
> __user *buf, ret = vdev->fops->write(filp, buf, sz, off);
>  	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
>  		mutex_unlock(vdev->lock);
> +	if (vdev->debug)
> +		pr_info("%s: write: %zd (%d)\n",
> +			video_device_node_name(vdev), sz, ret);
>  	return ret;
>  }
> 
> @@ -339,6 +345,9 @@ static unsigned int v4l2_poll(struct file *filp, struct
> poll_table_struct *poll) ret = vdev->fops->poll(filp, poll);
>  	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
>  		mutex_unlock(vdev->lock);
> +	if (vdev->debug)
> +		pr_info("%s: poll: %08x\n",
> +			video_device_node_name(vdev), ret);
>  	return ret;
>  }
> 
> @@ -348,20 +357,14 @@ static long v4l2_ioctl(struct file *filp, unsigned int
> cmd, unsigned long arg) int ret = -ENODEV;
> 
>  	if (vdev->fops->unlocked_ioctl) {
> -		bool locked = false;
> +		struct mutex *lock = v4l2_ioctl_get_lock(vdev, cmd);
> 
> -		if (vdev->lock) {
> -			/* always lock unless the cmd is marked as "don't use lock" */
> -			locked = !v4l2_is_known_ioctl(cmd) ||
> -				 !test_bit(_IOC_NR(cmd), vdev->disable_locking);
> -
> -			if (locked && mutex_lock_interruptible(vdev->lock))
> -				return -ERESTARTSYS;
> -		}
> +		if (lock && mutex_lock_interruptible(lock))
> +			return -ERESTARTSYS;
>  		if (video_is_registered(vdev))
>  			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> -		if (locked)
> -			mutex_unlock(vdev->lock);
> +		if (lock)
> +			mutex_unlock(lock);
>  	} else if (vdev->fops->ioctl) {
>  		/* This code path is a replacement for the BKL. It is a major
>  		 * hack but it will have to do for those drivers that are not
> @@ -409,12 +412,17 @@ static unsigned long v4l2_get_unmapped_area(struct
> file *filp, unsigned long flags)
>  {
>  	struct video_device *vdev = video_devdata(filp);
> +	int ret;
> 
>  	if (!vdev->fops->get_unmapped_area)
>  		return -ENOSYS;
>  	if (!video_is_registered(vdev))
>  		return -ENODEV;
> -	return vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
> +	ret = vdev->fops->get_unmapped_area(filp, addr, len, pgoff, flags);
> +	if (vdev->debug)
> +		pr_info("%s: get_unmapped_area (%d)\n",
> +			video_device_node_name(vdev), ret);
> +	return ret;
>  }
>  #endif
> 
> @@ -432,6 +440,9 @@ static int v4l2_mmap(struct file *filp, struct
> vm_area_struct *vm) ret = vdev->fops->mmap(filp, vm);
>  	if (test_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags))
>  		mutex_unlock(vdev->lock);
> +	if (vdev->debug)
> +		pr_info("%s: mmap (%d)\n",
> +			video_device_node_name(vdev), ret);
>  	return ret;
>  }
> 
> @@ -470,6 +481,9 @@ err:
>  	/* decrease the refcount in case of an error */
>  	if (ret)
>  		video_put(vdev);
> +	if (vdev->debug)
> +		pr_info("%s: open (%d)\n",
> +			video_device_node_name(vdev), ret);
>  	return ret;
>  }
> 
> @@ -489,6 +503,9 @@ static int v4l2_release(struct inode *inode, struct file
> *filp) /* decrease the refcount unconditionally since the release()
>  	   return value is ignored. */
>  	video_put(vdev);
> +	if (vdev->debug)
> +		pr_info("%s: release\n",
> +			video_device_node_name(vdev));
>  	return ret;
>  }
-- 
Regards,

Laurent Pinchart

