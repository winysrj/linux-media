Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:42919 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaCKHNR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 03:13:17 -0400
Received: by mail-ve0-f170.google.com with SMTP id pa12so8205972veb.15
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 00:13:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394493359-14115-14-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1394493359-14115-14-git-send-email-laurent.pinchart@ideasonboard.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 11 Mar 2014 12:42:56 +0530
Message-ID: <CA+V-a8vSC5AQmcd6G8r7eRSZKxRte1t+txB3X8m0-+q7ZtpRkQ@mail.gmail.com>
Subject: Re: [PATCH v2 13/48] tvp7002: Add pad-level DV timings operations
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 11, 2014 at 4:45 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> The video enum_dv_timings operation is deprecated. Implement the
> pad-level version of the operation to prepare for the removal of the
> video version.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar lad

> ---
>  drivers/media/i2c/tvp7002.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 912e1cc..9f56fd5 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -832,6 +832,9 @@ static int tvp7002_log_status(struct v4l2_subdev *sd)
>  static int tvp7002_enum_dv_timings(struct v4l2_subdev *sd,
>                 struct v4l2_enum_dv_timings *timings)
>  {
> +       if (timings->pad != 0)
> +               return -EINVAL;
> +
>         /* Check requested format index is within range */
>         if (timings->index >= NUM_TIMINGS)
>                 return -EINVAL;
> @@ -937,6 +940,7 @@ static const struct v4l2_subdev_pad_ops tvp7002_pad_ops = {
>         .enum_mbus_code = tvp7002_enum_mbus_code,
>         .get_fmt = tvp7002_get_pad_format,
>         .set_fmt = tvp7002_set_pad_format,
> +       .enum_dv_timings = tvp7002_enum_dv_timings,
>  };
>
>  /* V4L2 top level operation handlers */
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
