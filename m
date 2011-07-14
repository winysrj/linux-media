Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53126 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab1GNPZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 11:25:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH 1/5] mt9m111: set inital return values to zero
Date: Thu, 14 Jul 2011 17:25:20 +0200
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
In-Reply-To: <1310485146-27759-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107141725.21401.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

There's no need to set initial return values to zero if they're assigned to in 
all code paths.

[snip]

> *client) static int mt9m111_enable(struct i2c_client *client)
>  {
>  	struct mt9m111 *mt9m111 = to_mt9m111(client);
> -	int ret;
> +	int ret = 0;
> 
>  	ret = reg_set(RESET, MT9M111_RESET_CHIP_ENABLE);
>  	if (!ret)

This is a clear example, ret will never be used uninitialized. Initializing it 
to 0 would be a waste of resources (although in this case it will probably be 
optimized out by the compiler).

-- 
Regards,

Laurent Pinchart
