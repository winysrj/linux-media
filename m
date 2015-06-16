Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50910 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746AbbFPKQr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2015 06:16:47 -0400
Date: Tue, 16 Jun 2015 12:16:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	kernel@pengutronix.de, Alexandre Courbot <gnurou@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: i2c/adp1653: set enable gpio to output
Message-ID: <20150616101644.GB25899@amd>
References: <1434095248-31057-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1434095248-31057-1-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 2015-06-12 09:47:28, Uwe Kleine-König wrote:
> Without setting the direction of a gpio to output a call to
> gpiod_set_value doesn't have a defined outcome.
> 
> Furthermore this is one caller less that stops us making the flags
> argument to gpiod_get*() mandatory.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Pavel Machek <pavel@ucw.cz>

> diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
> index c70ababce954..5dd39775d6ca 100644
> --- a/drivers/media/i2c/adp1653.c
> +++ b/drivers/media/i2c/adp1653.c
> @@ -465,7 +465,7 @@ static int adp1653_of_init(struct i2c_client *client,
>  
>  	of_node_put(child);
>  
> -	pd->enable_gpio = devm_gpiod_get(&client->dev, "enable");
> +	pd->enable_gpio = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
>  	if (!pd->enable_gpio) {
>  		dev_err(&client->dev, "Error getting GPIO\n");
>  		return -EINVAL;

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
