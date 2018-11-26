Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:42451 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbeKZPHF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 10:07:05 -0500
Received: by mail-yb1-f195.google.com with SMTP id o204-v6so6933740yba.9
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2018 20:14:15 -0800 (PST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id 205-v6sm15348963ywd.1.2018.11.25.20.14.13
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Nov 2018 20:14:14 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id o204-v6so6933713yba.9
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2018 20:14:13 -0800 (PST)
MIME-Version: 1.0
References: <20181123171958.17614-1-ezequiel@collabora.com>
In-Reply-To: <20181123171958.17614-1-ezequiel@collabora.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 26 Nov 2018 13:14:02 +0900
Message-ID: <CAAFQd5Aub8AmM-U9FM-UhOYPtMP=MbGwuX0svkVP-4p0H8MejA@mail.gmail.com>
Subject: Re: [PATCH] v4l2-ioctl: Zero v4l2_pix_format_mplane reserved fields
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On Sat, Nov 24, 2018 at 2:20 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
>
> Make the core set the reserved fields to zero in
> v4l2_pix_format_mplane and v4l2_plane_pix_format structs,
> for _MPLANE queue types.
>
> Moving this to the core avoids having to do so in each
> and every driver.
>
> Suggested-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-ioctl.c | 51 ++++++++++++++++++++++++----
>  1 file changed, 45 insertions(+), 6 deletions(-)
>

Thanks for the patch. Please see my comments inline.

> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 10b862dcbd86..3858fffc3e68 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1420,6 +1420,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>  {
>         struct v4l2_format *p = arg;
>         int ret = check_fmt(file, p->type);
> +       int i;
>
>         if (ret)
>                 return ret;
> @@ -1458,7 +1459,13 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>                 p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>                 return ret;
>         case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> -               return ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
> +               ret = ops->vidioc_g_fmt_vid_cap_mplane(file, fh, arg);
> +               memset(p->fmt.pix_mp.reserved, 0,
> +                      sizeof(p->fmt.pix_mp.reserved));
> +               for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> +                       memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
> +                              sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
> +               return ret;
>         case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>                 return ops->vidioc_g_fmt_vid_overlay(file, fh, arg);
>         case V4L2_BUF_TYPE_VBI_CAPTURE:
> @@ -1474,7 +1481,13 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
>                 p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
>                 return ret;
>         case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> -               return ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
> +               ret = ops->vidioc_g_fmt_vid_out_mplane(file, fh, arg);
> +               memset(p->fmt.pix_mp.reserved, 0,
> +                      sizeof(p->fmt.pix_mp.reserved));
> +               for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> +                       memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
> +                              sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
> +               return ret;

I wonder if we need this for G_FMT. The driver can just memset() the
whole struct itself and then just initialize the fields it cares
about, but actually in many cases the driver will just include an
instance of the pix_fmt(_mp) struct in its internal state (which has
the reserved fields already zeroed) and just copy it to the target
struct in the callback.

>         case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>                 return ops->vidioc_g_fmt_vid_out_overlay(file, fh, arg);
>         case V4L2_BUF_TYPE_VBI_OUTPUT:
> @@ -1512,6 +1525,7 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>         struct v4l2_format *p = arg;
>         struct video_device *vfd = video_devdata(file);
>         int ret = check_fmt(file, p->type);
> +       int i;
>
>         if (ret)
>                 return ret;
> @@ -1536,7 +1550,13 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>                 if (unlikely(!ops->vidioc_s_fmt_vid_cap_mplane))
>                         break;
>                 CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> -               return ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
> +               ret = ops->vidioc_s_fmt_vid_cap_mplane(file, fh, arg);
> +               memset(p->fmt.pix_mp.reserved, 0,
> +                      sizeof(p->fmt.pix_mp.reserved));

Note that we're already zeroing this field before calling driver's callback.

> +               for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> +                       memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
> +                              sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));

Should we use the CLEAR_AFTER_FIELD() macro? Also, should we do before
calling the driver, as with pix_mp.reserved?

> +               return ret;
>         case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>                 if (unlikely(!ops->vidioc_s_fmt_vid_overlay))
>                         break;
> @@ -1564,7 +1584,13 @@ static int v4l_s_fmt(const struct v4l2_ioctl_ops *ops,
>                 if (unlikely(!ops->vidioc_s_fmt_vid_out_mplane))
>                         break;
>                 CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> -               return ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
> +               ret = ops->vidioc_s_fmt_vid_out_mplane(file, fh, arg);
> +               memset(p->fmt.pix_mp.reserved, 0,
> +                      sizeof(p->fmt.pix_mp.reserved));
> +               for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> +                       memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
> +                              sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
> +               return ret;

Ditto.

>         case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>                 if (unlikely(!ops->vidioc_s_fmt_vid_out_overlay))
>                         break;
> @@ -1604,6 +1630,7 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>  {
>         struct v4l2_format *p = arg;
>         int ret = check_fmt(file, p->type);
> +       int i;
>
>         if (ret)
>                 return ret;
> @@ -1623,7 +1650,13 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>                 if (unlikely(!ops->vidioc_try_fmt_vid_cap_mplane))
>                         break;
>                 CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> -               return ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
> +               ret = ops->vidioc_try_fmt_vid_cap_mplane(file, fh, arg);
> +               memset(p->fmt.pix_mp.reserved, 0,
> +                      sizeof(p->fmt.pix_mp.reserved));
> +               for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> +                       memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
> +                              sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
> +               return ret;

Ditto.

>         case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>                 if (unlikely(!ops->vidioc_try_fmt_vid_overlay))
>                         break;
> @@ -1651,7 +1684,13 @@ static int v4l_try_fmt(const struct v4l2_ioctl_ops *ops,
>                 if (unlikely(!ops->vidioc_try_fmt_vid_out_mplane))
>                         break;
>                 CLEAR_AFTER_FIELD(p, fmt.pix_mp.xfer_func);
> -               return ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
> +               ret = ops->vidioc_try_fmt_vid_out_mplane(file, fh, arg);
> +               memset(p->fmt.pix_mp.reserved, 0,
> +                      sizeof(p->fmt.pix_mp.reserved));
> +               for (i = 0; i < p->fmt.pix_mp.num_planes; i++)
> +                       memset(p->fmt.pix_mp.plane_fmt[i].reserved, 0,
> +                              sizeof(p->fmt.pix_mp.plane_fmt[i].reserved));
> +               return ret;

Ditto.

Best regards,
Tomasz
