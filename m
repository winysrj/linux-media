Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34451 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932395AbcAMKkI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 05:40:08 -0500
MIME-Version: 1.0
In-Reply-To: <1452530844-30609-6-git-send-email-javier@osg.samsung.com>
References: <1452530844-30609-1-git-send-email-javier@osg.samsung.com> <1452530844-30609-6-git-send-email-javier@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Wed, 13 Jan 2016 10:39:37 +0000
Message-ID: <CA+V-a8sEh5kc9GB9_HjuzDiNOUyBnN+4JEYPx6EuoqAGik7w=Q@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] [media] tvp514x: Check v4l2_of_parse_endpoint()
 return value
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
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
>  drivers/media/i2c/tvp514x.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> index 7fa5f1e4fe37..7cdd94842938 100644
> --- a/drivers/media/i2c/tvp514x.c
> +++ b/drivers/media/i2c/tvp514x.c
> @@ -1001,7 +1001,7 @@ static struct tvp514x_decoder tvp514x_dev = {
>  static struct tvp514x_platform_data *
>  tvp514x_get_pdata(struct i2c_client *client)
>  {
> -       struct tvp514x_platform_data *pdata;
> +       struct tvp514x_platform_data *pdata = NULL;
>         struct v4l2_of_endpoint bus_cfg;
>         struct device_node *endpoint;
>         unsigned int flags;
> @@ -1013,11 +1013,13 @@ tvp514x_get_pdata(struct i2c_client *client)
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
