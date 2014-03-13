Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:61465 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbaCMI7Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 04:59:16 -0400
Received: by mail-ve0-f180.google.com with SMTP id jz11so754061veb.11
        for <linux-media@vger.kernel.org>; Thu, 13 Mar 2014 01:59:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394493359-14115-15-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1394493359-14115-15-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Thu, 13 Mar 2014 16:59:15 +0800
Message-ID: <CAHG8p1B0xeOupSmxXjMRE0AK5r3-yNW8bTD2MV68FyEYJB75Ww@mail.gmail.com>
Subject: Re: [PATCH v2 14/48] media: bfin_capture: Switch to pad-level DV operations
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2014-03-11 7:15 GMT+08:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> The video-level enum_dv_timings and dv_timings_cap operations are
> deprecated in favor of the pad-level versions. All subdev drivers
> implement the pad-level versions, switch to them.
>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/blackfin/bfin_capture.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 200bec9..22fb701 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -648,7 +648,9 @@ static int bcap_enum_dv_timings(struct file *file, void *priv,
>  {
>         struct bcap_device *bcap_dev = video_drvdata(file);
>
> -       return v4l2_subdev_call(bcap_dev->sd, video,
> +       timings->pad = 0;
> +
> +       return v4l2_subdev_call(bcap_dev->sd, pad,
>                         enum_dv_timings, timings);
>  }
>

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
