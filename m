Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:35629 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752852AbcICSiX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 3 Sep 2016 14:38:23 -0400
Received: by mail-lf0-f48.google.com with SMTP id l131so9744740lfl.2
        for <linux-media@vger.kernel.org>; Sat, 03 Sep 2016 11:38:22 -0700 (PDT)
Subject: Re: [PATCHv3 09/10] [media] rcar-vin: rework how subdeivce is found
 and bound
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org, ulrich.hecht@gmail.com,
        hverkuil@xs4all.nl
References: <20160815150635.22637-1-niklas.soderlund+renesas@ragnatech.se>
 <20160815150635.22637-10-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <a6fe8385-c91a-11bd-8692-699c6b999754@cogentembedded.com>
Date: Sat, 3 Sep 2016 21:38:19 +0300
MIME-Version: 1.0
In-Reply-To: <20160815150635.22637-10-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 08/15/2016 06:06 PM, Niklas Söderlund wrote:

> The original drivers code to find a subdevice by looking in the DT grpah

    s/grpah/graph/.

> and how the callbacks to the v4l2 async bind framework where poorly
> written. The most obvious example of badness was the duplication of data
> in the struct rvin_graph_entity.
>
> This patch removes the data duplication, simplifies the parsing of the
> DT graph and add checks to the v4l2 callbacks.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 232 +++++++++++++---------------
>  drivers/media/platform/rcar-vin/rcar-vin.h  |   8 +-
>  2 files changed, 111 insertions(+), 129 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 3941134..39bf6fc 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
[...]
> @@ -94,89 +102,111 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
>
> -	vin_dbg(vin, "subdev %s bound\n", subdev->name);
> +	v4l2_set_subdev_hostdata(subdev, vin);
>
> -	vin->digital.entity = &subdev->entity;
> -	vin->digital.subdev = subdev;
> +	if (vin->digital.asd.match.of.node == subdev->dev->of_node) {
> +		vin_dbg(vin, "bound digital subdev %s\n", subdev->name);
> +		vin->digital.subdev = subdev;
> +		return 0;
> +	}
>
> -	return 0;
> +	vin_err(vin, "no entity for subdev %s to bind\n", subdev->name);
> +	return -EINVAL;
>  }
>
> -static int rvin_digital_parse(struct rvin_dev *vin,
> -			      struct device_node *node)
> +static int rvin_digitial_parse_v4l2(struct rvin_dev *vin,

    s/digitial/digital/.

[...]
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 93daa05..edfe658 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -70,10 +70,12 @@ struct rvin_video_format {
>  	u8 bpp;
>  };
>
> +/**
> + * struct rvin_graph_entity - Video endpoint from async framework
> + * @asd:	sub-device descriptor for async framework
> + * @subdev:	subdevice matched using async framework
> + */

     Looks like a materia for a separate patch...

>  struct rvin_graph_entity {
> -	struct device_node *node;
> -	struct media_entity *entity;
> -
>  	struct v4l2_async_subdev asd;
>  	struct v4l2_subdev *subdev;
>  };

MBR, Sergei

