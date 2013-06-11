Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40123 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3FKQxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 12:53:10 -0400
Received: by mail-ie0-f170.google.com with SMTP id e11so4621007iej.1
        for <linux-media@vger.kernel.org>; Tue, 11 Jun 2013 09:53:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370868518-19831-10-git-send-email-hverkuil@xs4all.nl>
References: <1370868518-19831-1-git-send-email-hverkuil@xs4all.nl>
	<1370868518-19831-10-git-send-email-hverkuil@xs4all.nl>
Date: Tue, 11 Jun 2013 13:53:10 -0300
Message-ID: <CALF0-+XM1FEaMBgHyC4N-TMQYwOvRHA6hFFmXRh8j_MeCDXBKQ@mail.gmail.com>
Subject: Re: [REVIEW PATCH 9/9] v4l2: remove parent from v4l2 core.
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jun 10, 2013 at 9:48 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-dev.c   |   34 +++++++++++++++-------------------
>  drivers/media/v4l2-core/v4l2-ioctl.c |    7 +------
>  include/media/v4l2-dev.h             |    2 --
>  3 files changed, 16 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 2f3fac5..61e82f8 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -495,8 +495,8 @@ static const struct file_operations v4l2_fops = {
>  };
>
>  /**
> - * get_index - assign stream index number based on parent device
> - * @vdev: video_device to assign index number to, vdev->parent should be assigned
> + * get_index - assign stream index number based on v4l2_dev
> + * @vdev: video_device to assign index number to, vdev->v4l2_dev should be assigned
>   *
>   * Note that when this is called the new device has not yet been registered
>   * in the video_device array, but it was able to obtain a minor number.
> @@ -514,15 +514,11 @@ static int get_index(struct video_device *vdev)
>         static DECLARE_BITMAP(used, VIDEO_NUM_DEVICES);
>         int i;
>
> -       /* Some drivers do not set the parent. In that case always return 0. */
> -       if (vdev->parent == NULL)
> -               return 0;
> -
>         bitmap_zero(used, VIDEO_NUM_DEVICES);
>
>         for (i = 0; i < VIDEO_NUM_DEVICES; i++) {
>                 if (video_device[i] != NULL &&
> -                   video_device[i]->parent == vdev->parent) {
> +                   video_device[i]->v4l2_dev == vdev->v4l2_dev) {
>                         set_bit(video_device[i]->index, used);
>                 }
>         }
> @@ -776,6 +772,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>         /* the release callback MUST be present */
>         if (WARN_ON(!vdev->release))
>                 return -EINVAL;
> +       /* the v4l2_dev pointer MUST be present */
> +       if (WARN_ON(!vdev->v4l2_dev))
> +               return -EINVAL;
>
>         /* v4l2_fh support */
>         spin_lock_init(&vdev->fh_lock);
> @@ -803,16 +802,13 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>
>         vdev->vfl_type = type;
>         vdev->cdev = NULL;
> -       if (vdev->v4l2_dev) {
> -               if (vdev->v4l2_dev->dev)
> -                       vdev->parent = vdev->v4l2_dev->dev;
> -               if (vdev->ctrl_handler == NULL)
> -                       vdev->ctrl_handler = vdev->v4l2_dev->ctrl_handler;
> -               /* If the prio state pointer is NULL, then use the v4l2_device
> -                  prio state. */
> -               if (vdev->prio == NULL)
> -                       vdev->prio = &vdev->v4l2_dev->prio;
> -       }
> +
> +       if (vdev->ctrl_handler == NULL)
> +               vdev->ctrl_handler = vdev->v4l2_dev->ctrl_handler;
> +       /* If the prio state pointer is NULL, then use the v4l2_device
> +          prio state. */
> +       if (vdev->prio == NULL)
> +               vdev->prio = &vdev->v4l2_dev->prio;
>
>         /* Part 2: find a free minor, device node number and device index. */
>  #ifdef CONFIG_VIDEO_FIXED_MINOR_RANGES
> @@ -897,8 +893,8 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
>         /* Part 4: register the device with sysfs */
>         vdev->dev.class = &video_class;
>         vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
> -       if (vdev->parent)
> -               vdev->dev.parent = vdev->parent;
> +       if (vdev->v4l2_dev->dev)
> +               vdev->dev.parent = vdev->v4l2_dev->dev;
>         dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
>         ret = device_register(&vdev->dev);
>         if (ret < 0) {
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 19e2988..3dcdaa3 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1845,12 +1845,7 @@ static int v4l_dbg_g_chip_info(const struct v4l2_ioctl_ops *ops,
>                         p->flags |= V4L2_CHIP_FL_WRITABLE;
>                 if (ops->vidioc_g_register)
>                         p->flags |= V4L2_CHIP_FL_READABLE;
> -               if (vfd->v4l2_dev)
> -                       strlcpy(p->name, vfd->v4l2_dev->name, sizeof(p->name));
> -               else if (vfd->parent)
> -                       strlcpy(p->name, vfd->parent->driver->name, sizeof(p->name));
> -               else
> -                       strlcpy(p->name, "bridge", sizeof(p->name));
> +               strlcpy(p->name, vfd->v4l2_dev->name, sizeof(p->name));
>                 if (ops->vidioc_g_chip_info)
>                         return ops->vidioc_g_chip_info(file, fh, arg);
>                 if (p->match.addr)
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index b2c3776..4d10e66 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -96,8 +96,6 @@ struct video_device
>         struct device dev;              /* v4l device */
>         struct cdev *cdev;              /* character device */
>
> -       /* Set either parent or v4l2_dev if your driver uses v4l2_device */
> -       struct device *parent;          /* device parent */
>         struct v4l2_device *v4l2_dev;   /* v4l2_device parent */
>
>         /* Control handler associated with this device node. May be NULL. */
> --
> 1.7.10.4
>

I know there's a cover letter for this changeset. However, for such an
intrusive change
as the one contained in this patch I think that not having any
description/changelog
for the commit might not be a good idea.

Thanks,
-- 
    Ezequiel
