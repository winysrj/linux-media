Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33344 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275AbcHCOWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2016 10:22:08 -0400
Received: by mail-lf0-f49.google.com with SMTP id b199so162567440lfe.0
        for <linux-media@vger.kernel.org>; Wed, 03 Aug 2016 07:21:49 -0700 (PDT)
Subject: Re: [PATCHv2 1/7] media: rcar-vin: make V4L2_FIELD_INTERLACED
 standard dependent
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	slongerbeam@gmail.com
References: <20160802145107.24829-1-niklas.soderlund+renesas@ragnatech.se>
 <20160802145107.24829-2-niklas.soderlund+renesas@ragnatech.se>
Cc: lars@metafoo.de, mchehab@kernel.org, hans.verkuil@cisco.com
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <c1fc233e-6ab6-7338-adab-5a32bc1f8e16@cogentembedded.com>
Date: Wed, 3 Aug 2016 16:58:50 +0300
MIME-Version: 1.0
In-Reply-To: <20160802145107.24829-2-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2016 05:51 PM, Niklas Söderlund wrote:

> The field V4L2_FIELD_INTERLACED is standard dependent and should not
> unconditionally be equivalent to V4L2_FIELD_INTERLACED_TB.
>
> This patch adds a check to see if the video standard can be obtained and
> if it's a 60 Hz format. If the condition is meet V4L2_FIELD_INTERLACED

    s/meet/met/.

> is treated as V4L2_FIELD_INTERLACED_BT if not as
> V4L2_FIELD_INTERLACED_TB.
>
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index 496aa97..4063775 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -131,6 +131,7 @@ static u32 rvin_read(struct rvin_dev *vin, u32 offset)
>  static int rvin_setup(struct rvin_dev *vin)
>  {
>  	u32 vnmc, dmr, dmr2, interrupts;
> +	v4l2_std_id std;
>  	bool progressive = false, output_is_yuv = false, input_is_yuv = false;
>
>  	switch (vin->format.field) {
> @@ -141,6 +142,13 @@ static int rvin_setup(struct rvin_dev *vin)
>  		vnmc = VNMC_IM_EVEN;
>  		break;
>  	case V4L2_FIELD_INTERLACED:
> +		/* Default to TB */
> +		vnmc = VNMC_IM_FULL;
> +		/* Use BT if video standard can be read and is 60 Hz format */
> +		if (!v4l2_subdev_call(vin_to_source(vin), video, g_std, &std))
> +			if (std & V4L2_STD_525_60)
> +				vnmc = VNMC_IM_FULL | VNMC_FOC;

    I think you either need to fold 2 *if* statements, or add {} in the 1st one.

[...]

MBR, Sergei

