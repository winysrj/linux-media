Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34444 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbcGMNwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 09:52:13 -0400
Received: by mail-wm0-f66.google.com with SMTP id q128so1534493wma.1
        for <linux-media@vger.kernel.org>; Wed, 13 Jul 2016 06:52:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467621142-8064-8-git-send-email-hverkuil@xs4all.nl>
References: <1467621142-8064-1-git-send-email-hverkuil@xs4all.nl> <1467621142-8064-8-git-send-email-hverkuil@xs4all.nl>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 13 Jul 2016 14:51:08 +0100
Message-ID: <CA+V-a8uNEyshoDA+qRESXs+EROpborBWe9m4CLF-hf+JYQnryA@mail.gmail.com>
Subject: Re: [PATCH 7/9] vpbe_display: convert g/s_crop to g/s_selection.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 4, 2016 at 9:32 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This is part of a final push to convert all drivers to g/s_selection.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
>  drivers/media/platform/davinci/vpbe_display.c | 65 +++++++++++++++------------
>  1 file changed, 37 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
> index 0abcdfe..b4a8cd2 100644
> --- a/drivers/media/platform/davinci/vpbe_display.c
> +++ b/drivers/media/platform/davinci/vpbe_display.c
> @@ -441,7 +441,7 @@ vpbe_disp_calculate_scale_factor(struct vpbe_display *disp_dev,
>         /*
>          * Application initially set the image format. Current display
>          * size is obtained from the vpbe display controller. expected_xsize
> -        * and expected_ysize are set through S_CROP ioctl. Based on this,
> +        * and expected_ysize are set through S_SELECTION ioctl. Based on this,
>          * driver will calculate the scale factors for vertical and
>          * horizontal direction so that the image is displayed scaled
>          * and expanded. Application uses expansion to display the image
> @@ -650,24 +650,23 @@ static int vpbe_display_querycap(struct file *file, void  *priv,
>         return 0;
>  }
>
> -static int vpbe_display_s_crop(struct file *file, void *priv,
> -                            const struct v4l2_crop *crop)
> +static int vpbe_display_s_selection(struct file *file, void *priv,
> +                            struct v4l2_selection *sel)
>  {
>         struct vpbe_layer *layer = video_drvdata(file);
>         struct vpbe_display *disp_dev = layer->disp_dev;
>         struct vpbe_device *vpbe_dev = disp_dev->vpbe_dev;
>         struct osd_layer_config *cfg = &layer->layer_info.config;
>         struct osd_state *osd_device = disp_dev->osd_device;
> -       struct v4l2_rect rect = crop->c;
> +       struct v4l2_rect rect = sel->r;
>         int ret;
>
>         v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> -               "VIDIOC_S_CROP, layer id = %d\n", layer->device_id);
> +               "VIDIOC_S_SELECTION, layer id = %d\n", layer->device_id);
>
> -       if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> -               v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buf type\n");
> +       if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT ||
> +           sel->target != V4L2_SEL_TGT_CROP)
>                 return -EINVAL;
> -       }
>
>         if (rect.top < 0)
>                 rect.top = 0;
> @@ -715,32 +714,45 @@ static int vpbe_display_s_crop(struct file *file, void *priv,
>         else
>                 osd_device->ops.set_interpolation_filter(osd_device, 0);
>
> +       sel->r = rect;
>         return 0;
>  }
>
> -static int vpbe_display_g_crop(struct file *file, void *priv,
> -                            struct v4l2_crop *crop)
> +static int vpbe_display_g_selection(struct file *file, void *priv,
> +                                   struct v4l2_selection *sel)
>  {
>         struct vpbe_layer *layer = video_drvdata(file);
>         struct osd_layer_config *cfg = &layer->layer_info.config;
>         struct vpbe_device *vpbe_dev = layer->disp_dev->vpbe_dev;
>         struct osd_state *osd_device = layer->disp_dev->osd_device;
> -       struct v4l2_rect *rect = &crop->c;
> +       struct v4l2_rect *rect = &sel->r;
>
>         v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev,
> -                       "VIDIOC_G_CROP, layer id = %d\n",
> +                       "VIDIOC_G_SELECTION, layer id = %d\n",
>                         layer->device_id);
>
> -       if (crop->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> -               v4l2_err(&vpbe_dev->v4l2_dev, "Invalid buf type\n");
> +       if (sel->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +               return -EINVAL;
> +
> +       switch (sel->target) {
> +       case V4L2_SEL_TGT_CROP:
> +               osd_device->ops.get_layer_config(osd_device,
> +                                                layer->layer_info.id, cfg);
> +               rect->top = cfg->ypos;
> +               rect->left = cfg->xpos;
> +               rect->width = cfg->xsize;
> +               rect->height = cfg->ysize;
> +               break;
> +       case V4L2_SEL_TGT_CROP_DEFAULT:
> +       case V4L2_SEL_TGT_CROP_BOUNDS:
> +               rect->left = 0;
> +               rect->top = 0;
> +               rect->width = vpbe_dev->current_timings.xres;
> +               rect->height = vpbe_dev->current_timings.yres;
> +               break;
> +       default:
>                 return -EINVAL;
>         }
> -       osd_device->ops.get_layer_config(osd_device,
> -                               layer->layer_info.id, cfg);
> -       rect->top = cfg->ypos;
> -       rect->left = cfg->xpos;
> -       rect->width = cfg->xsize;
> -       rect->height = cfg->ysize;
>
>         return 0;
>  }
> @@ -753,13 +765,10 @@ static int vpbe_display_cropcap(struct file *file, void *priv,
>
>         v4l2_dbg(1, debug, &vpbe_dev->v4l2_dev, "VIDIOC_CROPCAP ioctl\n");
>
> -       cropcap->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> -       cropcap->bounds.left = 0;
> -       cropcap->bounds.top = 0;
> -       cropcap->bounds.width = vpbe_dev->current_timings.xres;
> -       cropcap->bounds.height = vpbe_dev->current_timings.yres;
> +       if (cropcap->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +               return -EINVAL;
> +
>         cropcap->pixelaspect = vpbe_dev->current_timings.aspect;
> -       cropcap->defrect = cropcap->bounds;
>         return 0;
>  }
>
> @@ -1252,8 +1261,8 @@ static const struct v4l2_ioctl_ops vpbe_ioctl_ops = {
>         .vidioc_expbuf           = vb2_ioctl_expbuf,
>
>         .vidioc_cropcap          = vpbe_display_cropcap,
> -       .vidioc_g_crop           = vpbe_display_g_crop,
> -       .vidioc_s_crop           = vpbe_display_s_crop,
> +       .vidioc_g_selection      = vpbe_display_g_selection,
> +       .vidioc_s_selection      = vpbe_display_s_selection,
>
>         .vidioc_s_std            = vpbe_display_s_std,
>         .vidioc_g_std            = vpbe_display_g_std,
> --
> 2.8.1
>
