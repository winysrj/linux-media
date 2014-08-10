Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51467 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaHJKvy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 06:51:54 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so2900754wib.14
        for <linux-media@vger.kernel.org>; Sun, 10 Aug 2014 03:51:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1407663691.6912.7.camel@phoenix>
References: <1407663691.6912.7.camel@phoenix>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 10 Aug 2014 11:51:22 +0100
Message-ID: <CA+V-a8uXLSC2AyOD3rF2Kc2zXoA_MzxYzr1Y3xyQnf1b9v+mHA@mail.gmail.com>
Subject: Re: [PATCH] [media] saa6752hs: Convert to devm_kzalloc()
To: Axel Lin <axel.lin@ingics.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 10, 2014 at 10:41 AM, Axel Lin <axel.lin@ingics.com> wrote:
> Using the managed function the kfree() calls can be removed from the
> probe error path and the remove handler.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad

> ---
>  drivers/media/i2c/saa6752hs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/i2c/saa6752hs.c b/drivers/media/i2c/saa6752hs.c
> index 04e9e55..4024ea6 100644
> --- a/drivers/media/i2c/saa6752hs.c
> +++ b/drivers/media/i2c/saa6752hs.c
> @@ -660,7 +660,7 @@ static const struct v4l2_subdev_ops saa6752hs_ops = {
>  static int saa6752hs_probe(struct i2c_client *client,
>                 const struct i2c_device_id *id)
>  {
> -       struct saa6752hs_state *h = kzalloc(sizeof(*h), GFP_KERNEL);
> +       struct saa6752hs_state *h;
>         struct v4l2_subdev *sd;
>         struct v4l2_ctrl_handler *hdl;
>         u8 addr = 0x13;
> @@ -668,6 +668,8 @@ static int saa6752hs_probe(struct i2c_client *client,
>
>         v4l_info(client, "chip found @ 0x%x (%s)\n",
>                         client->addr << 1, client->adapter->name);
> +
> +       h = devm_kzalloc(&client->dev, sizeof(*h), GFP_KERNEL);
>         if (h == NULL)
>                 return -ENOMEM;
>         sd = &h->sd;
> @@ -752,7 +754,6 @@ static int saa6752hs_probe(struct i2c_client *client,
>                 int err = hdl->error;
>
>                 v4l2_ctrl_handler_free(hdl);
> -               kfree(h);
>                 return err;
>         }
>         v4l2_ctrl_cluster(3, &h->video_bitrate_mode);
> @@ -767,7 +768,6 @@ static int saa6752hs_remove(struct i2c_client *client)
>
>         v4l2_device_unregister_subdev(sd);
>         v4l2_ctrl_handler_free(&to_state(sd)->hdl);
> -       kfree(to_state(sd));
>         return 0;
>  }
>
> --
> 1.9.1
>
>
>
