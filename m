Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33968 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbcAMKlM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 05:41:12 -0500
MIME-Version: 1.0
In-Reply-To: <1452530844-30609-7-git-send-email-javier@osg.samsung.com>
References: <1452530844-30609-1-git-send-email-javier@osg.samsung.com> <1452530844-30609-7-git-send-email-javier@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 13 Jan 2016 10:40:41 +0000
Message-ID: <CA+V-a8sWa9zRamy4MLds5rkDVzeX5754kShhmC-cogeKiSwFEQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] [media] tvp7002: Check v4l2_of_parse_endpoint()
 return value
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 11, 2016 at 4:47 PM, Javier Martinez Canillas
<javier@osg.samsung.com> wrote:
> The v4l2_of_parse_endpoint() function can fail so check the return value.
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>
> Changes in v2:
> - Assign pdata to NULL in case v4l2_of_parse_endpoint() fails before kzalloc.
>   Suggested by Sakari Ailus.
>
>  drivers/media/i2c/tvp7002.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 83c79fa5f61d..4df640c3aa40 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -894,7 +894,7 @@ static struct tvp7002_config *
>  tvp7002_get_pdata(struct i2c_client *client)
>  {
>         struct v4l2_of_endpoint bus_cfg;
> -       struct tvp7002_config *pdata;
> +       struct tvp7002_config *pdata = NULL;
>         struct device_node *endpoint;
>         unsigned int flags;
>
> @@ -905,11 +905,13 @@ tvp7002_get_pdata(struct i2c_client *client)
>         if (!endpoint)
>                 return NULL;
>
> +       if (v4l2_of_parse_endpoint(endpoint, &bus_cfg))
> +               goto done;
> +
>         pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
>         if (!pdata)
>                 goto done;
>
> -       v4l2_of_parse_endpoint(endpoint, &bus_cfg);
>         flags = bus_cfg.bus.parallel.flags;
>
>         if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> --
> 2.4.3
>
