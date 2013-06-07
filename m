Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64148 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3FGJGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 05:06:54 -0400
Date: Fri, 7 Jun 2013 11:06:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Steven Toth <stoth@kernellabs.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] v4l2: remove g_chip_ident where it is easy to do so.
In-Reply-To: <201305231336.10889.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1306071100080.11277@axis700.grange>
References: <201305231336.10889.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Thu, 23 May 2013, Hans Verkuil wrote:

> With the introduction in 3.10 of the new superior VIDIOC_DBG_G_CHIP_INFO
> ioctl there is no longer any need for the DBG_G_CHIP_IDENT ioctl or the
> v4l2-chip-ident.h header.
> 
> Remove it in those bridge drivers where it is easy to do so.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

[snip]

>  drivers/media/platform/sh_vou.c                  |   31 ----------
>  drivers/media/platform/soc_camera/soc_camera.c   |   34 -----------

Ok, I'll bite :) First, obviously, I don't think it's good to do two 
things in one patch with only one of them mentioned in the patch 
description. I'm talking about removal of .vidioc_g_register() / 
.vidioc_s_register() in _some_ of the drivers, that are touched here, 
notably in sh_vou.c and soc_camera.c. I think I read we want to remove 
those too, but I'm not sure what the exact status of that work is? 
Besides, to do that I'd rather accompany that change with the removal of 
the respective subdev operations from, say, soc-camera subdevice drivers.

[snip]

> diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
> index 7d02350..fa8ae72 100644
> --- a/drivers/media/platform/sh_vou.c
> +++ b/drivers/media/platform/sh_vou.c
> @@ -1248,32 +1248,6 @@ static unsigned int sh_vou_poll(struct file *file, poll_table *wait)
>  	return res;
>  }
>  
> -static int sh_vou_g_chip_ident(struct file *file, void *fh,
> -				   struct v4l2_dbg_chip_ident *id)
> -{
> -	struct sh_vou_device *vou_dev = video_drvdata(file);
> -
> -	return v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, core, g_chip_ident, id);
> -}
> -
> -#ifdef CONFIG_VIDEO_ADV_DEBUG
> -static int sh_vou_g_register(struct file *file, void *fh,
> -				 struct v4l2_dbg_register *reg)
> -{
> -	struct sh_vou_device *vou_dev = video_drvdata(file);
> -
> -	return v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, core, g_register, reg);
> -}
> -
> -static int sh_vou_s_register(struct file *file, void *fh,
> -				 const struct v4l2_dbg_register *reg)
> -{
> -	struct sh_vou_device *vou_dev = video_drvdata(file);
> -
> -	return v4l2_device_call_until_err(&vou_dev->v4l2_dev, 0, core, s_register, reg);
> -}
> -#endif
> -
>  /* sh_vou display ioctl operations */
>  static const struct v4l2_ioctl_ops sh_vou_ioctl_ops = {
>  	.vidioc_querycap        	= sh_vou_querycap,
> @@ -1292,11 +1266,6 @@ static const struct v4l2_ioctl_ops sh_vou_ioctl_ops = {
>  	.vidioc_cropcap			= sh_vou_cropcap,
>  	.vidioc_g_crop			= sh_vou_g_crop,
>  	.vidioc_s_crop			= sh_vou_s_crop,
> -	.vidioc_g_chip_ident		= sh_vou_g_chip_ident,
> -#ifdef CONFIG_VIDEO_ADV_DEBUG
> -	.vidioc_g_register		= sh_vou_g_register,
> -	.vidioc_s_register		= sh_vou_s_register,
> -#endif
>  };
>  
>  static const struct v4l2_file_operations sh_vou_fops = {
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index eea832c..68efade 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1036,35 +1036,6 @@ static int soc_camera_s_parm(struct file *file, void *fh,
>  	return -ENOIOCTLCMD;
>  }
>  
> -static int soc_camera_g_chip_ident(struct file *file, void *fh,
> -				   struct v4l2_dbg_chip_ident *id)
> -{
> -	struct soc_camera_device *icd = file->private_data;
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -
> -	return v4l2_subdev_call(sd, core, g_chip_ident, id);
> -}
> -
> -#ifdef CONFIG_VIDEO_ADV_DEBUG
> -static int soc_camera_g_register(struct file *file, void *fh,
> -				 struct v4l2_dbg_register *reg)
> -{
> -	struct soc_camera_device *icd = file->private_data;
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -
> -	return v4l2_subdev_call(sd, core, g_register, reg);
> -}
> -
> -static int soc_camera_s_register(struct file *file, void *fh,
> -				 const struct v4l2_dbg_register *reg)
> -{
> -	struct soc_camera_device *icd = file->private_data;
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -
> -	return v4l2_subdev_call(sd, core, s_register, reg);
> -}
> -#endif
> -
>  static int soc_camera_probe(struct soc_camera_device *icd);
>  
>  /* So far this function cannot fail */
> @@ -1495,11 +1466,6 @@ static const struct v4l2_ioctl_ops soc_camera_ioctl_ops = {
>  	.vidioc_s_selection	 = soc_camera_s_selection,
>  	.vidioc_g_parm		 = soc_camera_g_parm,
>  	.vidioc_s_parm		 = soc_camera_s_parm,
> -	.vidioc_g_chip_ident     = soc_camera_g_chip_ident,
> -#ifdef CONFIG_VIDEO_ADV_DEBUG
> -	.vidioc_g_register	 = soc_camera_g_register,
> -	.vidioc_s_register	 = soc_camera_s_register,
> -#endif
>  };
>  
>  static int video_dev_create(struct soc_camera_device *icd)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
