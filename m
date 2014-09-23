Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37261 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbaIWUHf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 16:07:35 -0400
Date: Tue, 23 Sep 2014 17:07:30 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 3/4] tc90522: add driver for Toshiba TC90522 quad
 demodulator
Message-ID: <20140923170730.4d5d167e@recife.lan>
In-Reply-To: <1410196843-26168-4-git-send-email-tskd08@gmail.com>
References: <1410196843-26168-1-git-send-email-tskd08@gmail.com>
	<1410196843-26168-4-git-send-email-tskd08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue,  9 Sep 2014 02:20:42 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> This patch adds driver for tc90522 demodulator chips.
> The chip contains 4 demod modules that run in parallel and are independently
> controllable via separate I2C addresses.
> Two of the modules are for ISDB-T and the rest for ISDB-S.
> It is used in earthsoft pt3 cards.
> 
> Note that this driver does not init the chip,
> because the initilization sequence / register setting is not disclosed.
> Thus, the driver assumes that the chips are initilized externally
> by its parent board driver before fe->ops->init() are called.
> Earthsoft PT3 PCIe card, for example, contains the init sequence
> in its private memory and provides a command to trigger the sequence.

I applied this series, as we're discussing it already for a long time,
and it seems in a good shape...

Yet, I got some minor issues with FE status. See below.

PS.: could you also test (and send us patches as needed) for ISDB-S
support at libdvbv5 and dvbv5-utils[1]?

[1] http://linuxtv.org/wiki/index.php/DVBv5_Tools

Thanks!
Mauro


> +static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
> +{
> +	struct tc90522_state *state;
> +	int ret;
> +	u8 reg;
> +
> +	state = fe->demodulator_priv;
> +	ret = reg_read(state, 0xc3, &reg, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	*status = 0;
> +	if (reg & 0x80) /* input level under min ? */
> +		return 0;
> +	*status |= FE_HAS_SIGNAL;
> +
> +	if (reg & 0x60) /* carrier? */
> +		return 0;

Sure about that? Wouldn't it be, instead, reg & 0x60 == 0x60?

> +	*status |= FE_HAS_CARRIER | FE_HAS_VITERBI | FE_HAS_SYNC;
> +
> +	if (reg & 0x10)
> +		return 0;
> +	if (reg_read(state, 0xc5, &reg, 1) < 0 || !(reg & 0x03))
> +		return 0;
> +	*status |= FE_HAS_LOCK;
> +	return 0;
> +}
> +
> +static int tc90522t_read_status(struct dvb_frontend *fe, fe_status_t *status)
> +{
> +	struct tc90522_state *state;
> +	int ret;
> +	u8 reg;
> +
> +	state = fe->demodulator_priv;
> +	ret = reg_read(state, 0x96, &reg, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	*status = 0;
> +	if (reg & 0xe0) {
> +		*status = FE_HAS_SIGNAL | FE_HAS_CARRIER | FE_HAS_VITERBI
> +				| FE_HAS_SYNC | FE_HAS_LOCK;
> +		return 0;
> +	}
> +
> +	ret = reg_read(state, 0x80, &reg, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (reg & 0xf0)
> +		return 0;
> +	*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER;
> +
> +	if (reg & 0x0c)
> +		return 0;
> +	*status |= FE_HAS_SYNC | FE_HAS_VITERBI;

The entire series of checks above seems wrong on my eyes too.

For example, if reg = 0x20 or 0x40 or 0x80 or ..., it will return
FE_HAS_LOCK.

Regards,
Mauro
