Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0077.hostedemail.com ([216.40.44.77]:44852 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751307AbdLKTec (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 14:34:32 -0500
Message-ID: <1513020868.3036.0.camel@perches.com>
Subject: Re: [PATCH] tuners: tda8290: reduce stack usage with kasan
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Dec 2017 11:34:28 -0800
In-Reply-To: <20171211120612.3775893-1-arnd@arndb.de>
References: <20171211120612.3775893-1-arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-12-11 at 13:06 +0100, Arnd Bergmann wrote:
> With CONFIG_KASAN enabled, we get a relatively large stack frame in one function
> 
> drivers/media/tuners/tda8290.c: In function 'tda8290_set_params':
> drivers/media/tuners/tda8290.c:310:1: warning: the frame size of 1520 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> With CONFIG_KASAN_EXTRA this goes up to
> 
> drivers/media/tuners/tda8290.c: In function 'tda8290_set_params':
> drivers/media/tuners/tda8290.c:310:1: error: the frame size of 3200 bytes is larger than 3072 bytes [-Werror=frame-larger-than=]
> 
> We can significantly reduce this by marking local arrays as 'static const', and
> this should result in better compiled code for everyone.
[]
> diff --git a/drivers/media/tuners/tda8290.c b/drivers/media/tuners/tda8290.c
[]
> @@ -63,8 +63,8 @@ static int tda8290_i2c_bridge(struct dvb_frontend *fe, int close)
>  {
>  	struct tda8290_priv *priv = fe->analog_demod_priv;
>  
> -	unsigned char  enable[2] = { 0x21, 0xC0 };
> -	unsigned char disable[2] = { 0x21, 0x00 };
> +	static unsigned char  enable[2] = { 0x21, 0xC0 };
> +	static unsigned char disable[2] = { 0x21, 0x00 };

Doesn't match commit message.

static const or just static?

> @@ -84,9 +84,9 @@ static int tda8295_i2c_bridge(struct dvb_frontend *fe, int close)
>  {
>  	struct tda8290_priv *priv = fe->analog_demod_priv;
>  
> -	unsigned char  enable[2] = { 0x45, 0xc1 };
> -	unsigned char disable[2] = { 0x46, 0x00 };
> -	unsigned char buf[3] = { 0x45, 0x01, 0x00 };
> +	static unsigned char  enable[2] = { 0x45, 0xc1 };
> +	static unsigned char disable[2] = { 0x46, 0x00 };

etc.
