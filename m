Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:65522 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaCKHV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 03:21:59 -0400
Received: by mail-vc0-f170.google.com with SMTP id hu8so8163681vcb.15
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 00:21:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394493359-14115-40-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1394493359-14115-40-git-send-email-laurent.pinchart@ideasonboard.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 11 Mar 2014 12:51:38 +0530
Message-ID: <CA+V-a8u0Ez+ZP3zoM42VjCSMJtAw4imcx-3E-tUXhE5Kmi=Zng@mail.gmail.com>
Subject: Re: [PATCH v2 39/48] v4l: subdev: Remove deprecated video-level DV
 timings operations
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 11, 2014 at 4:45 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> The video enum_dv_timings and dv_timings_cap operations are deprecated
> and unused. Remove them.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar lad

> ---
>  include/media/v4l2-subdev.h | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 2b5ec32..ab2b59d 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -330,12 +330,8 @@ struct v4l2_subdev_video_ops {
>                         struct v4l2_dv_timings *timings);
>         int (*g_dv_timings)(struct v4l2_subdev *sd,
>                         struct v4l2_dv_timings *timings);
> -       int (*enum_dv_timings)(struct v4l2_subdev *sd,
> -                       struct v4l2_enum_dv_timings *timings);
>         int (*query_dv_timings)(struct v4l2_subdev *sd,
>                         struct v4l2_dv_timings *timings);
> -       int (*dv_timings_cap)(struct v4l2_subdev *sd,
> -                       struct v4l2_dv_timings_cap *cap);
>         int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
>                              enum v4l2_mbus_pixelcode *code);
>         int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
