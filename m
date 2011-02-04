Return-path: <mchehab@pedra>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1426 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab1BDKcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Feb 2011 05:32:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v6 06/11] v4l: subdev: Add a new file operations class
Date: Fri, 4 Feb 2011 11:31:52 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1296131456-30000-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131456-30000-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131456-30000-7-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102041131.52913.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, January 27, 2011 13:30:51 Laurent Pinchart wrote:
> V4L2 sub-devices store pad formats and crop settings in the file handle.
> To let drivers initialize those settings properly, add a file::open
> operation that is called when the subdev is opened as well as a
> corresponding file::close operation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/v4l2-subdev.c |   13 ++++++++++---
>  include/media/v4l2-subdev.h       |   10 ++++++++++
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> index 15449fc..0f904e2 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -61,7 +61,7 @@ static int subdev_open(struct file *file)
>  	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
>  	struct v4l2_subdev_fh *subdev_fh;
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> -	struct media_entity *entity;
> +	struct media_entity *entity = NULL;
>  #endif
>  	int ret;
>  
> @@ -104,9 +104,17 @@ static int subdev_open(struct file *file)
>  	}
>  #endif
>  
> +	ret = v4l2_subdev_call(sd, file, open, subdev_fh);
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		goto err;
> +
>  	return 0;
>  
>  err:
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	if (entity)
> +		media_entity_put(entity);
> +#endif
>  	v4l2_fh_del(&subdev_fh->vfh);
>  	v4l2_fh_exit(&subdev_fh->vfh);
>  	subdev_fh_free(subdev_fh);
> @@ -117,13 +125,12 @@ err:
>  
>  static int subdev_close(struct file *file)
>  {
> -#if defined(CONFIG_MEDIA_CONTROLLER)
>  	struct video_device *vdev = video_devdata(file);
>  	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> -#endif
>  	struct v4l2_fh *vfh = file->private_data;
>  	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
>  
> +	v4l2_subdev_call(sd, file, close, subdev_fh);
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	if (sd->v4l2_dev->mdev)
>  		media_entity_put(&sd->entity);
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index f8704ff..af704df 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -175,6 +175,15 @@ struct v4l2_subdev_core_ops {
>  				 struct v4l2_event_subscription *sub);
>  };
>  
> +/* open: called when the subdev device node is opened by an application.
> +
> +   close: called when the subdev device node is close.

is close -> is closed

> + */
> +struct v4l2_subdev_file_ops {
> +	int (*open)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
> +	int (*close)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh);
> +};
> +
>  /* s_mode: switch the tuner to a specific tuner mode. Replacement of s_radio.
>  
>     s_radio: v4l device was opened in Radio mode, to be replaced by s_mode.
> @@ -416,6 +425,7 @@ struct v4l2_subdev_ir_ops {
>  
>  struct v4l2_subdev_ops {
>  	const struct v4l2_subdev_core_ops	*core;
> +	const struct v4l2_subdev_file_ops	*file;

This shouldn't be part of this struct, this should be part of struct v4l2_subdev.
These ops must *not* be called by master drivers, so they don't belong here.

>  	const struct v4l2_subdev_tuner_ops	*tuner;
>  	const struct v4l2_subdev_audio_ops	*audio;
>  	const struct v4l2_subdev_video_ops	*video;
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
