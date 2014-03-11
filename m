Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:40330 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaCKHQo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 03:16:44 -0400
Received: by mail-ve0-f171.google.com with SMTP id cz12so8359621veb.30
        for <linux-media@vger.kernel.org>; Tue, 11 Mar 2014 00:16:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394493359-14115-17-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1394493359-14115-17-git-send-email-laurent.pinchart@ideasonboard.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 11 Mar 2014 12:46:24 +0530
Message-ID: <CA+V-a8vZsNzogCu03dm-VM9SAq+h8bfqTYYXBSWPj6TEcSp3Uw@mail.gmail.com>
Subject: Re: [PATCH v2 16/48] media: staging: davinci: vpfe: Switch to
 pad-level DV operations
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch.

On Tue, Mar 11, 2014 at 4:45 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> The video-level enum_dv_timings and dv_timings_cap operations are
> deprecated in favor of the pad-level versions. All subdev drivers
> implement the pad-level versions, switch to them.
>
> Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar lad

> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 1f3b0f9..a1655a8 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -987,8 +987,10 @@ vpfe_enum_dv_timings(struct file *file, void *fh,
>         struct vpfe_device *vpfe_dev = video->vpfe_dev;
>         struct v4l2_subdev *subdev = video->current_ext_subdev->subdev;
>
> +       timings->pad = 0;
> +
>         v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_dv_timings\n");
> -       return v4l2_subdev_call(subdev, video, enum_dv_timings, timings);
> +       return v4l2_subdev_call(subdev, pad, enum_dv_timings, timings);
>  }
>
>  /*
> --
> 1.8.3.2
>
