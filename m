Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2105 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZKRHG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 02:06:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: v4l: Add video_device_node_name function
Date: Wed, 18 Nov 2009 08:06:22 +0100
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com> <1258504731-8430-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911180806.22428.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 November 2009 01:38:42 Laurent Pinchart wrote:
> Many drivers access the device number (video_device::v4l2_devnode::num)
> in order to print the video device node name. Add and use a helper
> function to retrieve the video_device node name.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Can you also add a bit of documentation for this function in
Documentation/video4linux/v4l2-framework.txt? It should go in the section
"video_device helper functions".

And update that file as well when the num and minor fields go away.

The same is also true for the new registration function.

Thanks,

	Hans

> 
> Index: v4l-dvb-mc-uvc/linux/drivers/media/video/v4l2-dev.c
> ===================================================================
> --- v4l-dvb-mc-uvc.orig/linux/drivers/media/video/v4l2-dev.c
> +++ v4l-dvb-mc-uvc/linux/drivers/media/video/v4l2-dev.c
> @@ -619,8 +619,8 @@ static int __video_register_device(struc
>  	vdev->dev.release = v4l2_device_release;
>  
>  	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
> -		printk(KERN_WARNING "%s: requested %s%d, got %s%d\n",
> -				__func__, name_base, nr, name_base, vdev->num);
> +		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
> +			name_base, nr, video_device_node_name(vdev));
>  
>  	/* Part 5: Activate this minor. The char device can now be used. */
>  	mutex_lock(&videodev_lock);
> Index: v4l-dvb-mc-uvc/linux/include/media/v4l2-dev.h
> ===================================================================
> --- v4l-dvb-mc-uvc.orig/linux/include/media/v4l2-dev.h
> +++ v4l-dvb-mc-uvc/linux/include/media/v4l2-dev.h
> @@ -153,6 +153,15 @@ static inline void *video_drvdata(struct
>  	return video_get_drvdata(video_devdata(file));
>  }
>  
> +static inline const char *video_device_node_name(struct video_device *vdev)
> +{
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
> +	return vdev->dev.class_id;
> +#else
> +	return dev_name(&vdev->dev);
> +#endif
> +}
> +
>  static inline int video_is_unregistered(struct video_device *vdev)
>  {
>  	return test_bit(V4L2_FL_UNREGISTERED, &vdev->flags);
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
