Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:33542 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbdCOJhI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 05:37:08 -0400
Received: by mail-lf0-f54.google.com with SMTP id a6so4423076lfa.0
        for <linux-media@vger.kernel.org>; Wed, 15 Mar 2017 02:37:06 -0700 (PDT)
Subject: Re: [PATCH v3 06/27] rcar-vin: move max width and height information
 to chip information
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
 <20170314190308.25790-7-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <e30bf8c4-fc62-c216-15d6-b0349794c859@cogentembedded.com>
Date: Wed, 15 Mar 2017 12:37:04 +0300
MIME-Version: 1.0
In-Reply-To: <20170314190308.25790-7-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/14/2017 10:02 PM, Niklas Söderlund wrote:

> On Gen3 the max supported width and height will be different from Gen2.
> Move the limits to the struct chip_info to prepare for Gen3 support.

    Maybe rvin_info?

> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 6 ++++++
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 6 ++----
>  drivers/media/platform/rcar-vin/rcar-vin.h  | 6 ++++++
>  3 files changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index ec1eb723d401fda2..998617711f1ad045 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -257,14 +257,20 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
>
>  static const struct rvin_info rcar_info_h1 = {
>  	.chip = RCAR_H1,
> +	.max_width = 2048,
> +	.max_height = 2048,
>  };
>
>  static const struct rvin_info rcar_info_m1 = {
>  	.chip = RCAR_M1,
> +	.max_width = 2048,
> +	.max_height = 2048,
>  };
>
>  static const struct rvin_info rcar_info_gen2 = {
>  	.chip = RCAR_GEN2,
> +	.max_width = 2048,
> +	.max_height = 2048,
>  };
>
>  static const struct of_device_id rvin_of_id_table[] = {
[...]

MBR, Sergei
