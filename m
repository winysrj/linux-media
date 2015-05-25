Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:56171 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbbEYNie (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 09:38:34 -0400
Date: Mon, 25 May 2015 15:38:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, hverkuil@xs4all.nl,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 03/20] media: adv7604: chip info and formats for ADV7612
In-Reply-To: <1432139980-12619-4-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1505251536400.26358@axis700.grange>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
 <1432139980-12619-4-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

Just a nitpick:

On Wed, 20 May 2015, William Towle wrote:

> Add support for the ADV7612 chip as implemented on Renesas' Lager
> board to adv7604.c, including lists for formats/colourspace/timing
> selection and an IRQ handler.
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/i2c/adv7604.c |   83 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 81 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index be3f866..a2abb04 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c

[snip]

> @@ -2805,8 +2883,9 @@ static int adv76xx_probe(struct i2c_client *client,
>  	} else {
>  		val = (adv_smbus_read_byte_data_check(client, 0xea, false) << 8)
>  		    | (adv_smbus_read_byte_data_check(client, 0xeb, false) << 0);
> -		if (val != 0x2051) {
> -			v4l2_info(sd, "not an adv7611 on address 0x%x\n",
> +		if ((state->info->type == ADV7611 && val != 0x2051) ||
> +			(state->info->type == ADV7612 && val != 0x2041)) {
> +			v4l2_info(sd, "not an adv761x on address 0x%x\n",

A switch / case might look slightly better here.

Thanks
Guennadi

>  					client->addr << 1);
>  			return -ENODEV;
>  		}
> -- 
> 1.7.10.4
> 
