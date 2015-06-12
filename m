Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44217 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750840AbbFLVOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 17:14:07 -0400
Date: Sat, 13 Jun 2015 00:13:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Cc: Pavel Machek <pavel@ucw.cz>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	kernel@pengutronix.de, Alexandre Courbot <gnurou@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: i2c/adp1653: set enable gpio to output
Message-ID: <20150612211358.GU5904@valkosipuli.retiisi.org.uk>
References: <1434095248-31057-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1434095248-31057-1-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo Uwe,

Thanks for the patch!

On Fri, Jun 12, 2015 at 09:47:28AM +0200, Uwe Kleine-König wrote:
> Without setting the direction of a gpio to output a call to
> gpiod_set_value doesn't have a defined outcome.
> 
> Furthermore this is one caller less that stops us making the flags
> argument to gpiod_get*() mandatory.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> this patch applies to next and is only necessary on top of 074c57a25fa2
> ([media] media: i2c/adp1653: Devicetree support for adp1653).
> 
> Note I plan to make the flags parameter mandatory for 4.3. So unless
> this change gets into 4.2, would it be ok to let it go in via the gpio
> tree?

Fine for me.

For the patch,

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Freundliche hilsen,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
