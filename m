Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:22222 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaJELeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Oct 2014 07:34:12 -0400
Date: Sun, 05 Oct 2014 08:33:58 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?0JHRg9C00Lgg0KDQvtC80LDQvdGC0L4s?= AreMa Inc
	<info@are.ma>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	crope@iki.fi, mchehab@osg.samsung.com, hdegoede@redhat.com,
	laurent.pinchart@ideasonboard.com, mkrufky@linuxtv.org,
	sylvester.nawrocki@gmail.com, g.liakhovetski@gmx.de,
	peter.senna@gmail.com
Subject: Re: [PATCH 02/11] tc90522 is a client
Message-id: <20141005083358.072f5909.m.chehab@samsung.com>
In-reply-to: <5bff3e029fe189f44222961dc04790d4f58a4659.1412497399.git.knightrider@are.ma>
References: <cover.1412497399.git.knightrider@are.ma>
 <5bff3e029fe189f44222961dc04790d4f58a4659.1412497399.git.knightrider@are.ma>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 05 Oct 2014 17:59:38 +0900
"Буди Романто, AreMa Inc" <info@are.ma> escreveu:

> tc90522 is an I2C client functioning as a frontend
> thus, it is enough to return the FE pointer.
> 
> Signed-off-by: Буди Романто, AreMa Inc <knightrider@are.ma>
> ---
>  drivers/media/dvb-frontends/tc90522.h | 41 ++++++++++++-----------------------
>  1 file changed, 14 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
> index b1cbddf..c78a5b0 100644
> --- a/drivers/media/dvb-frontends/tc90522.h
> +++ b/drivers/media/dvb-frontends/tc90522.h
> @@ -1,12 +1,12 @@
>  /*
> - * Toshiba TC90522 Demodulator
> + * Earthsoft PT3 demodulator frontend Toshiba TC90522XBG OFDM(ISDB-T)/8PSK(ISDB-S)
>   *
> - * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> + * Copyright (C) 2014 Budi Rachmanto, AreMa Inc. <info@are.ma>
>   *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
>   *
>   * This program is distributed in the hope that it will be useful,
>   * but WITHOUT ANY WARRANTY; without even the implied warranty of
> @@ -14,29 +14,16 @@
>   * GNU General Public License for more details.
>   */
>  
> -/*
> - * The demod has 4 input (2xISDB-T and 2xISDB-S),
> - * and provides independent sub modules for each input.
> - * As the sub modules work in parallel and have the separate i2c addr's,
> - * this driver treats each sub module as one demod device.
> - */

None of the above is related to the patch description. Also, we don't
remove copyrights from the driver. 

> -
> -#ifndef TC90522_H
> -#define TC90522_H
> +#ifndef	__TC90522_H__
> +#define	__TC90522_H__
>  
> -#include <linux/i2c.h>
> -#include "dvb_frontend.h"
> -
> -/* I2C device types */
> -#define TC90522_I2C_DEV_SAT "tc90522sat"
> -#define TC90522_I2C_DEV_TER "tc90522ter"
> +#define TC90522_DRVNAME "tc90522"

This would break the driver, as the two macros above are used at
tc90522.c.

>  struct tc90522_config {
> -	/* [OUT] frontend returned by driver */
> -	struct dvb_frontend *fe;
> -
> -	/* [OUT] tuner I2C adapter returned by driver */
> -	struct i2c_adapter *tuner_i2c;
> +	fe_delivery_system_t	type;	/* IN	SYS_ISDBS or SYS_ISDBT */
> +	bool			pwr;	/* IN	set only once after all demods initialized */
> +	struct dvb_frontend	*fe;	/* OUT	allocated frontend */
>  };

A change like that at the struct would break the driver.

There are several problems at the approach you're taking. It seems that
you're just doing a diff from the driver that it is committed from the
driver you have, without:
	- splitting one change par patch;
	- caring if a patch would break compilation.

Instead, if you need, for example, to add a new field at the config struct,
like "pwr", your patch would need to be touching both the header and the
tc90522 to use this new field.

For the same reasons, I can't apply the rest of your patch series, as it is
not splitting the changes as one patch per functional changes.

Regards,
Mauro
