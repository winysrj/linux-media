Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:43819 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751528AbdIUJWC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 05:22:02 -0400
Message-ID: <1505985717.10081.4.camel@pengutronix.de>
Subject: Re: [PATCH 1/3] [media] tc358743: Correct clock mode reported in
 g_mbus_config
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Date: Thu, 21 Sep 2017 11:21:57 +0200
In-Reply-To: <f6e576dde2640bcf6a79d157f83c96ca13c453a3.1505826082.git.dave.stevenson@raspberrypi.org>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
         <f6e576dde2640bcf6a79d157f83c96ca13c453a3.1505826082.git.dave.stevenson@raspberrypi.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-09-19 at 14:08 +0100, Dave Stevenson wrote:
> Support for non-continuous clock had previously been added via
> device tree, but a comment and the value reported by g_mbus_config
> still stated that it wasn't supported.
> Remove the comment, and return the correct value in g_mbus_config.
> 
> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
> ---
>  drivers/media/i2c/tc358743.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/tc358743.c
> b/drivers/media/i2c/tc358743.c
> index e6f5c36..6b0fd07 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1461,8 +1461,9 @@ static int tc358743_g_mbus_config(struct
> v4l2_subdev *sd,
>  
>  	cfg->type = V4L2_MBUS_CSI2;
>  
> -	/* Support for non-continuous CSI-2 clock is missing in the
> driver */
> -	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
> +	cfg->flags = state->bus.flags &
> +			(V4L2_MBUS_CSI2_CONTINUOUS_CLOCK |
> +			 V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK);

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
