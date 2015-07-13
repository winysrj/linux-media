Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:37366 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbbGMLAW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 07:00:22 -0400
Message-ID: <55A39A0E.50809@xs4all.nl>
Date: Mon, 13 Jul 2015 12:59:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Mats Randgaard <matrandg@cisco.com>
CC: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH 2/5] [media] tc358743: enable v4l2 subdevice devnode
References: <1436533897-3060-1-git-send-email-p.zabel@pengutronix.de> <1436533897-3060-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436533897-3060-2-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/10/2015 03:11 PM, Philipp Zabel wrote:
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/i2c/tc358743.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index 48d1575..0be6d9f 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1668,7 +1668,7 @@ static int tc358743_probe(struct i2c_client *client,
>  	state->i2c_client = client;
>  	sd = &state->sd;
>  	v4l2_i2c_subdev_init(sd, client, &tc358743_ops);
> -	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;

Note: HAS_EVENTS won't do much since there are no .subscribe_event or
.unsubscribe_event ops. You should add those.

Regards,

	Hans

>  
>  	/* i2c access */
>  	if ((i2c_rd16(sd, CHIPID) & MASK_CHIPID) != 0) {
> 

