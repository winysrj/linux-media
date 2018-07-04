Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:44334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752568AbeGDQ6L (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 12:58:11 -0400
Date: Wed, 4 Jul 2018 13:58:06 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Cc: linux-media@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] media: dvb-frontends: add Socionext SC1501A ISDB-S/T
 demodulator driver
Message-ID: <20180704135657.3fd607cb@coco.lan>
In-Reply-To: <20180621031748.21703-1-suzuki.katsuhiro@socionext.com>
References: <20180621031748.21703-1-suzuki.katsuhiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Katsuhiro-san,

Em Thu, 21 Jun 2018 12:17:48 +0900
Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com> escreveu:

> This patch adds a frontend driver for the Socionext SC1501A series
> and Socionext MN88443x ISDB-S/T demodulators.

Sorry for taking so long to review it. We're missing a sub-maintainer
for DVB, with would otherwise speed up reviews of DVB patches.
> 
> The maximum and minimum frequency of Socionext SC1501A comes from
> ISDB-S and ISDB-T so frequency range is the following:
>   - ISDB-S (BS/CS110 IF frequency in kHz, Local freq 10.678GHz)
>     - Min: BS-1: 1032000 => 1032.23MHz
>     - Max: ND24: 2701000 => 2070.25MHz
>   - ISDB-T (in Hz)
>     - Min: ch13: 470000000 => 470.357857MHz
>     - Max: ch62: 770000000 => 769.927857MHz

There is actually an error on that part of the driver. Right now,
the DVB core expects Satellite frequencies (DVB-S, ISDB-S, ...)
in kHz. For all other delivery systems, it is in Hz.

It is this way due to historic reasons. While it won't be hard to
change the core, that would require to touch all Satellite drivers.

As there are very few frontend drivers that accept both Satellite
and Terrestrial standards, what we do, instead, is to setup
two frontends. See, for example, drivers/media/dvb-frontends/helene.c.

...
> +static const struct dvb_frontend_ops sc1501a_ops = {
> +	.delsys = { SYS_ISDBS, SYS_ISDBT },
> +	.info = {
> +		.name          = "Socionext SC1501A",
> +		.frequency_min = 1032000,
> +		.frequency_max = 770000000,
> +		.caps = FE_CAN_INVERSION_AUTO | FE_CAN_FEC_AUTO |
> +			FE_CAN_QAM_AUTO | FE_CAN_TRANSMISSION_MODE_AUTO |
> +			FE_CAN_GUARD_INTERVAL_AUTO | FE_CAN_HIERARCHY_AUTO,
> +	},
> +
> +	.sleep                   = sc1501a_sleep,
> +	.set_frontend            = sc1501a_set_frontend,
> +	.get_tune_settings       = sc1501a_get_tune_settings,
> +	.read_status             = sc1501a_read_status,
> +};

In other words, you'll need to declare two structs here, one for ISDB-T
and another one for ISDB-S.

Yeah, I know that this sucks. If you are in the mood of touching the
DVB core, I'm willing to consider a patch that would fix this, provided
that it won't break backward compatibility with other drivers (or would
convert the other satellite drivers to use the new way).

Thanks,
Mauro
