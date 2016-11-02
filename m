Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34700 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932421AbcKBRPJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 13:15:09 -0400
Received: by mail-lf0-f43.google.com with SMTP id b81so18589689lfe.1
        for <linux-media@vger.kernel.org>; Wed, 02 Nov 2016 10:15:09 -0700 (PDT)
Subject: Re: [PATCH 20/32] media: rcar-vin: expose a sink pad if we are on
 Gen3
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <20161102132329.436-1-niklas.soderlund+renesas@ragnatech.se>
 <20161102132329.436-21-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <9a2477ff-4a96-5bfa-e4fe-6a52e1f4db0b@cogentembedded.com>
Date: Wed, 2 Nov 2016 20:15:05 +0300
MIME-Version: 1.0
In-Reply-To: <20161102132329.436-21-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/02/2016 04:23 PM, Niklas Söderlund wrote:

> Refactor the probe code path to look for the digital subdevice, if one
> is found use it just like the driver did before (Gen2 mode) but if it's
> not found prepare for a Gen3 mode by registering a pad for the media
> controller API to use.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 21 ++++++++++++++++++++-
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  9 +++++++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index f961957..ce8b59a 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -308,6 +308,25 @@ static const struct of_device_id rvin_of_id_table[] = {
>  };
>  MODULE_DEVICE_TABLE(of, rvin_of_id_table);
>
> +static int rvin_graph_init(struct rvin_dev *vin)
> +{
> +	int ret;
> +
> +	/* Try to get digital video pipe */
> +	ret = rvin_digital_graph_init(vin);
> +
> +	/* No digital pipe and we are on Gen3 try to joint CSI2 group */
> +	if (ret == -ENODEV && vin->info->chip == RCAR_GEN3) {
> +
> +		vin->pads[RVIN_SINK].flags = MEDIA_PAD_FL_SINK;
> +		ret = media_entity_pads_init(&vin->vdev.entity, 1, vin->pads);
> +		if (ret)
> +			return ret;

    This *if* is not necessary, you'll return below anyway.

> +	}
> +
> +	return ret;
> +}
> +
>  static int rcar_vin_probe(struct platform_device *pdev)
>  {
>  	const struct of_device_id *match;
[...]

MBR, Sergei

