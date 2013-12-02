Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:38436 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3LBDnu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Dec 2013 22:43:50 -0500
Received: by mail-ve0-f182.google.com with SMTP id jy13so8597885veb.27
        for <linux-media@vger.kernel.org>; Sun, 01 Dec 2013 19:43:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385766094-29621-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1385766094-29621-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Mon, 2 Dec 2013 11:43:49 +0800
Message-ID: <CAHG8p1AVhSLs6BdHKvjgft1mckmh60VxmJEaJXubHo1foLKEdw@mail.gmail.com>
Subject: Re: [PATCH] v4l: vs6624: Fix warning due to unused function
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/11/30 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> vs6624_read() is only called in the conditionally-compiled
> vs6624_g_register() function. Make the former conditionally-compiled as
> well to silence build warnings.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/vs6624.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
> index 25bdd93..23f4f65 100644
> --- a/drivers/media/i2c/vs6624.c
> +++ b/drivers/media/i2c/vs6624.c
> @@ -503,6 +503,7 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
>         return &container_of(ctrl->handler, struct vs6624, hdl)->sd;
>  }
>
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>  static int vs6624_read(struct v4l2_subdev *sd, u16 index)
>  {
>         struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -515,6 +516,7 @@ static int vs6624_read(struct v4l2_subdev *sd, u16 index)
>
>         return buf[0];
>  }
> +#endif
>
>  static int vs6624_write(struct v4l2_subdev *sd, u16 index,
>                                 u8 value)

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
