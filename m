Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51079 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab2CUTMH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 15:12:07 -0400
Received: by eaaq12 with SMTP id q12so469342eaa.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 12:12:06 -0700 (PDT)
Message-ID: <4F6A2803.40208@gmail.com>
Date: Wed, 21 Mar 2012 20:12:03 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: Hans-Frieder Vogt <hfvogt@gmx.net>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] Fitipower fc0011 driver
References: <20120321160237.02193470@milhouse> <20120321165645.37ea9246@milhouse>
In-Reply-To: <20120321165645.37ea9246@milhouse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 21/03/2012 16:56, Michael Büsch ha scritto:
> This adds the Fitipower fc0011 tuner driver.
> 
> Note: The '#if 0' statements will be removed on the final submission.
> 
> Signed-off-by: Michael Buesch <m@bues.ch>
> 
> ---

......

> +
> +#if 0 //TODO 3.3
> +static int fc0011_set_params(struct dvb_frontend *fe)
> +#else
> +static int fc0011_set_params(struct dvb_frontend *fe,
> +        struct dvb_frontend_parameters *params)
> +#endif
> +{
> +        struct fc0011_priv *priv = fe->tuner_priv;
> +	int err;
> +	unsigned int i;
> +#if 0 //TODO 3.3
> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> +	u32 freq = p->frequency / 1000;
> +	u32 delsys = p->delivery_system;

The "delsys" variable is unused, you can delete it.

BTW, I only compiled the driver, as I don't have the hardware to test it.

Regards,
Gianluca


> +	u32 bandwidth = p->bandwidth_hz / 1000;
> +#else
> +	u32 freq = params->frequency / 1000;
> +	u32 bandwidth = params->u.ofdm.bandwidth / 1000;
> +#endif
