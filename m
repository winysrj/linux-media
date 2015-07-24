Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57654 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbbGXOUt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 10:20:49 -0400
Message-ID: <55B24978.1080109@xs4all.nl>
Date: Fri, 24 Jul 2015 16:19:36 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 03/13] media: adv7604: fix probe of ADV7611/7612
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk> <1437654103-26409-4-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-4-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2015 02:21 PM, William Towle wrote:
> Prior to commit f862f57d ("[media] media: i2c: ADV7604: Migrate to
> regmap"), the local variable 'val' contained the combined register
> reads used in the chipset version ID test. Restore this expectation
> so that the comparison works as it used to.
> ---
>  drivers/media/i2c/adv7604.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index bfb0b6a..0587d27 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -3108,7 +3108,7 @@ static int adv76xx_probe(struct i2c_client *client,
>  			v4l2_err(sd, "Error %d reading IO Regmap\n", err);
>  			return -ENODEV;
>  		}
> -		val2 |= val;
> +		val |= val2;
>  		if ((state->info->type == ADV7611 && val != 0x2051) ||
>  			(state->info->type == ADV7612 && val != 0x2041)) {
>  			v4l2_err(sd, "not an adv761x on address 0x%x\n",
> 

Oops. Added to my TODO list, I'll probably pick this up on Tuesday for a pull
request.

Regards,

	Hans
