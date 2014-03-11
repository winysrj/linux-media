Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:37585 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaCKHMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 03:12:19 -0400
Received: by mail-ve0-f181.google.com with SMTP id oy12so8036491veb.26
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 00:12:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394493359-14115-13-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1394493359-14115-13-git-send-email-laurent.pinchart@ideasonboard.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 11 Mar 2014 12:41:58 +0530
Message-ID: <CA+V-a8v9C4NfhpcvF+f3Ggt7BST024m6yb2jnU6XYrhq1nA=7w@mail.gmail.com>
Subject: Re: [PATCH v2 12/48] ths8200: Add pad-level DV timings operations
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 11, 2014 at 4:45 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> The video enum_dv_timings and dv_timings_cap operations are deprecated.
> Implement the pad-level version of those operations to prepare for the
> removal of the video version.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar lad

> ---
>  drivers/media/i2c/ths8200.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
> index f72561e..c4ec8b2 100644
> --- a/drivers/media/i2c/ths8200.c
> +++ b/drivers/media/i2c/ths8200.c
> @@ -410,6 +410,9 @@ static int ths8200_g_dv_timings(struct v4l2_subdev *sd,
>  static int ths8200_enum_dv_timings(struct v4l2_subdev *sd,
>                                    struct v4l2_enum_dv_timings *timings)
>  {
> +       if (timings->pad != 0)
> +               return -EINVAL;
> +
>         return v4l2_enum_dv_timings_cap(timings, &ths8200_timings_cap,
>                         NULL, NULL);
>  }
> @@ -417,6 +420,9 @@ static int ths8200_enum_dv_timings(struct v4l2_subdev *sd,
>  static int ths8200_dv_timings_cap(struct v4l2_subdev *sd,
>                                   struct v4l2_dv_timings_cap *cap)
>  {
> +       if (cap->pad != 0)
> +               return -EINVAL;
> +
>         *cap = ths8200_timings_cap;
>         return 0;
>  }
> @@ -430,10 +436,16 @@ static const struct v4l2_subdev_video_ops ths8200_video_ops = {
>         .dv_timings_cap = ths8200_dv_timings_cap,
>  };
>
> +static const struct v4l2_subdev_pad_ops ths8200_pad_ops = {
> +       .enum_dv_timings = ths8200_enum_dv_timings,
> +       .dv_timings_cap = ths8200_dv_timings_cap,
> +};
> +
>  /* V4L2 top level operation handlers */
>  static const struct v4l2_subdev_ops ths8200_ops = {
>         .core  = &ths8200_core_ops,
>         .video = &ths8200_video_ops,
> +       .pad = &ths8200_pad_ops,
>  };
>
>  static int ths8200_probe(struct i2c_client *client,
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
