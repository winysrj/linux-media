Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60364 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757564Ab2EGTCU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:02:20 -0400
Message-ID: <4FA81C3A.1020108@iki.fi>
Date: Mon, 07 May 2012 22:02:18 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Add fc0011 tuner driver
References: <20120402181432.74e8bd50@milhouse>
In-Reply-To: <20120402181432.74e8bd50@milhouse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02.04.2012 19:14, Michael Büsch wrote:
> This adds support for the Fitipower fc0011 DVB-t tuner.
>
> Signed-off-by: Michael Buesch<m@bues.ch>

> +	unsigned int i, vco_retries;
> +	u32 freq = p->frequency / 1000;
> +	u32 bandwidth = p->bandwidth_hz / 1000;
> +	u32 fvco, xin, xdiv, xdivr;
> +	u16 frac;
> +	u8 fa, fp, vco_sel, vco_cal;
> +	u8 regs[FC11_NR_REGS] = { };

> +
> +	dev_dbg(&priv->i2c->dev, "Tuned to "
> +		"fa=%02X fp=%02X xin=%02X%02X vco=%02X vcosel=%02X "
> +		"vcocal=%02X(%u) bw=%u\n",
> +		(unsigned int)regs[FC11_REG_FA],
> +		(unsigned int)regs[FC11_REG_FP],
> +		(unsigned int)regs[FC11_REG_XINHI],
> +		(unsigned int)regs[FC11_REG_XINLO],
> +		(unsigned int)regs[FC11_REG_VCO],
> +		(unsigned int)regs[FC11_REG_VCOSEL],
> +		(unsigned int)vco_cal, vco_retries,
> +		(unsigned int)bandwidth);

Just for the interest, is there any reason you use so much casting or is 
that only your style?

I removed some similar castings from the AF9035 log writings you added 
as I did not see need for those. I even think casting should be avoided 
as it can hide possible meaningful compiler warnings on bad case.

regards
Antti
-- 
http://palosaari.fi/
