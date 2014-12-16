Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64571 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaLPOyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 09:54:54 -0500
Received: by mail-wg0-f49.google.com with SMTP id n12so17619837wgh.36
        for <linux-media@vger.kernel.org>; Tue, 16 Dec 2014 06:54:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1417686899-30149-4-git-send-email-hverkuil@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl> <1417686899-30149-4-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 16 Dec 2014 20:24:22 +0530
Message-ID: <CA+V-a8tiK9abYuy_SRM0HDbg223XRRvkeUd1_ds1DS5wqipJJA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/8] v4l2-subdev: drop unused op enum_mbus_fmt
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
> Weird, this op isn't used at all. Seems to be orphaned code.
> Remove it.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>  include/media/v4l2-subdev.h | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index b052184..5beeb87 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -342,8 +342,6 @@ struct v4l2_subdev_video_ops {
>                         struct v4l2_dv_timings *timings);
>         int (*enum_mbus_fmt)(struct v4l2_subdev *sd, unsigned int index,
>                              u32 *code);
> -       int (*enum_mbus_fsizes)(struct v4l2_subdev *sd,
> -                            struct v4l2_frmsizeenum *fsize);
>         int (*g_mbus_fmt)(struct v4l2_subdev *sd,
>                           struct v4l2_mbus_framefmt *fmt);
>         int (*try_mbus_fmt)(struct v4l2_subdev *sd,
> --
> 2.1.3
>
