Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:59905 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaAOLgs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 06:36:48 -0500
Received: by mail-lb0-f175.google.com with SMTP id w6so665535lbh.20
        for <linux-media@vger.kernel.org>; Wed, 15 Jan 2014 03:36:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52D6579F.9080302@xs4all.nl>
References: <CACDDY7429te6a7cUQ0Z=sX6TELjn48FQHiuW=YtBsyOkzrCqZA@mail.gmail.com>
	<52D63B23.5000505@xs4all.nl>
	<CACDDY76oeFxv7P_yBQeVosae4sRrMCyveRzUHUXewB2Xn3d-jw@mail.gmail.com>
	<52D6579F.9080302@xs4all.nl>
Date: Wed, 15 Jan 2014 19:36:47 +0800
Message-ID: <CACDDY75x94C=8d8t4mo3eoZeFnreZDiNuCvBgg8qjZ842FNNNw@mail.gmail.com>
Subject: Re: how can I get compat_ioctl support for v4l2_subdev_fops
From: Jianle Wang <victure86@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans:
    Thanks for your help. It can work at my side.

BTW: There is a warning during compiling
drivers/media/v4l2-core/v4l2-subdev.c: In function 'subdev_compat_ioctl32':
drivers/media/v4l2-core/v4l2-subdev.c:379:2: warning: passing argument
3 of 'sd->ops->core->compat_ioctl32' makes pointer from integer
without a cast [enabled by default]
drivers/media/v4l2-core/v4l2-subdev.c:379:2: note: expected 'void *'
but argument is of type 'long unsigned int'

2014/1/15 Hans Verkuil <hverkuil@xs4all.nl>:
> On 01/15/14 09:02, Jianle Wang wrote:
>> Hi Hans:
>>     Thanks for your patch.
>> How do we handle the private ioctl defined in struct v4l2_subdev_core.ioctl?
>> These ioctls are also not supported for compat_ioctl.
>
> There is currently no support for that, but try the patch below. That should
> allow you to add compat_ioctl32 support for your custom ioctls.
>
> Regards,
>
>         Hans
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 996c248..60d2550 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -368,6 +368,17 @@ static long subdev_ioctl(struct file *file, unsigned int cmd,
>         return video_usercopy(file, cmd, arg, subdev_do_ioctl);
>  }
>
> +#ifdef CONFIG_COMPAT
> +static long subdev_compat_ioctl32(struct file *file, unsigned int cmd,
> +       unsigned long arg)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> +
> +       return v4l2_subdev_call(sd, core, compat_ioctl32, cmd, arg);
> +}
> +#endif
> +
>  static unsigned int subdev_poll(struct file *file, poll_table *wait)
>  {
>         struct video_device *vdev = video_devdata(file);
> @@ -389,6 +400,9 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
>         .owner = THIS_MODULE,
>         .open = subdev_open,
>         .unlocked_ioctl = subdev_ioctl,
> +#ifdef CONFIG_COMPAT
> +       .compat_ioctl32 = subdev_compat_ioctl32,
> +#endif
>         .release = subdev_close,
>         .poll = subdev_poll,
>  };
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index d67210a..3fd91a5 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -162,6 +162,9 @@ struct v4l2_subdev_core_ops {
>         int (*g_std)(struct v4l2_subdev *sd, v4l2_std_id *norm);
>         int (*s_std)(struct v4l2_subdev *sd, v4l2_std_id norm);
>         long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
> +#ifdef CONFIG_COMPAT
> +       long (*compat_ioctl32)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
> +#endif
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>         int (*g_register)(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg);
>         int (*s_register)(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg);
>
