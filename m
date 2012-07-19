Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38744 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2GSVFs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 17:05:48 -0400
Received: by yhmm54 with SMTP id m54so3289996yhm.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 14:05:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207192245.49852.hverkuil@xs4all.nl>
References: <201207192245.49852.hverkuil@xs4all.nl>
Date: Thu, 19 Jul 2012 18:05:47 -0300
Message-ID: <CALF0-+UD-+L4AcN8BkTrjoXq4m78sV3eeTiLgY0Q1B1Y==_5sg@mail.gmail.com>
Subject: Re: [PATCH] vivi: remove pointless video_nr++
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 19, 2012 at 5:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Remove the pointless video_nr++. It doesn't do anything useful and it has
> the unexpected side-effect of changing the video_nr module option, so
> cat /sys/module/vivi/parameters/video_nr gives a different value back
> then what was specified with modprobe.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> index 1e8c4f3..679e329 100644
> --- a/drivers/media/video/vivi.c
> +++ b/drivers/media/video/vivi.c
> @@ -1330,9 +1330,6 @@ static int __init vivi_create_instance(int inst)
>         /* Now that everything is fine, let's add it to device list */
>         list_add_tail(&dev->vivi_devlist, &vivi_devlist);
>
> -       if (video_nr != -1)
> -               video_nr++;
> -
>         v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
>                   video_device_node_name(vfd));
>         return 0;
> --

Hans,

I think you forgot to *also* remove the video_nr module parameter.
(and, of course, pass a '-1' to video_register_device)

Regards,
Ezequiel.
