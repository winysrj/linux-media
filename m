Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:41469 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab2AKPXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 10:23:04 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 1/3] v4l: Add custom compat_ioctl32 operation
Date: Wed, 11 Jan 2012 16:22:59 +0100
Cc: linux-media@vger.kernel.org
References: <1326295120-15391-1-git-send-email-laurent.pinchart@ideasonboard.com> <1326295120-15391-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1326295120-15391-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111622.59264.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 11 January 2012 16:18:38 Laurent Pinchart wrote:
> Drivers implementing custom ioctls need to handle 32-bit/64-bit
> compatibility themselves. Provide them with a way to do so.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/video/v4l2-compat-ioctl32.c |   13 ++++++++++---
>  include/media/v4l2-dev.h                  |    3 +++
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c
> b/drivers/media/video/v4l2-compat-ioctl32.c index c68531b..0340efc 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -16,6 +16,7 @@
>  #include <linux/compat.h>
>  #include <linux/videodev2.h>
>  #include <linux/module.h>
> +#include <media/v4l2-dev.h>
>  #include <media/v4l2-ioctl.h>
> 
>  #ifdef CONFIG_COMPAT
> @@ -937,6 +938,7 @@ static long do_video_ioctl(struct file *file, unsigned
> int cmd, unsigned long ar
> 
>  long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned
> long arg) {
> +	struct video_device *vdev = video_devdata(file);
>  	long ret = -ENOIOCTLCMD;
> 
>  	if (!file->f_op->unlocked_ioctl)
> @@ -1023,9 +1025,14 @@ long v4l2_compat_ioctl32(struct file *file, unsigned
> int cmd, unsigned long arg) break;
> 
>  	default:
> -		printk(KERN_WARNING "compat_ioctl32: "
> -			"unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
> -			_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd), cmd);
> +		if (vdev->fops->compat_ioctl32)
> +			ret = vdev->fops->compat_ioctl32(file, cmd, arg);
> +
> +		if (ret == -ENOIOCTLCMD)
> +			printk(KERN_WARNING "compat_ioctl32: "
> +				"unknown ioctl '%c', dir=%d, #%d (0x%08x)\n",
> +				_IOC_TYPE(cmd), _IOC_DIR(cmd), _IOC_NR(cmd),
> +				cmd);
>  		break;
>  	}
>  	return ret;
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index c7c40f1..96d2221 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -62,6 +62,9 @@ struct v4l2_file_operations {
>  	unsigned int (*poll) (struct file *, struct poll_table_struct *);
>  	long (*ioctl) (struct file *, unsigned int, unsigned long);
>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
> +#ifdef CONFIG_COMPAT
> +	long (*compat_ioctl32) (struct file *, unsigned int, unsigned long);
> +#endif
>  	unsigned long (*get_unmapped_area) (struct file *, unsigned long,
>  				unsigned long, unsigned long, unsigned long);
>  	int (*mmap) (struct file *, struct vm_area_struct *);
