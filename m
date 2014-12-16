Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:44921 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaLPOxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 09:53:10 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so12787926wid.6
        for <linux-media@vger.kernel.org>; Tue, 16 Dec 2014 06:53:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417686899-30149-3-git-send-email-hverkuil@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl> <1417686899-30149-3-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 16 Dec 2014 20:22:39 +0530
Message-ID: <CA+V-a8vqJLeEojgWsZWdcQUo1OT0xaJF+4Gye4-5wi9P94OBDA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/8] v4l2-subdev: drop get/set_crop pad ops
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	laurent pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 4, 2014 at 3:24 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Drop the duplicate get/set_crop pad ops and only use get/set_selection.
> It makes no sense to have two duplicate ops in the internal subdev API.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 8 --------
>  include/media/v4l2-subdev.h           | 4 ----
>  2 files changed, 12 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 543631c..19a034e 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -283,10 +283,6 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>                 if (rval)
>                         return rval;
>
> -               rval = v4l2_subdev_call(sd, pad, get_crop, subdev_fh, crop);
> -               if (rval != -ENOIOCTLCMD)
> -                       return rval;
> -
>                 memset(&sel, 0, sizeof(sel));
>                 sel.which = crop->which;
>                 sel.pad = crop->pad;
> @@ -308,10 +304,6 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>                 if (rval)
>                         return rval;
>
> -               rval = v4l2_subdev_call(sd, pad, set_crop, subdev_fh, crop);
> -               if (rval != -ENOIOCTLCMD)
> -                       return rval;
> -
>                 memset(&sel, 0, sizeof(sel));
>                 sel.which = crop->which;
>                 sel.pad = crop->pad;
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 5860292..b052184 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -503,10 +503,6 @@ struct v4l2_subdev_pad_ops {
>                        struct v4l2_subdev_format *format);
>         int (*set_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>                        struct v4l2_subdev_format *format);
> -       int (*set_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> -                      struct v4l2_subdev_crop *crop);
> -       int (*get_crop)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> -                      struct v4l2_subdev_crop *crop);
>         int (*get_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>                              struct v4l2_subdev_selection *sel);
>         int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> --
> 2.1.3
>
