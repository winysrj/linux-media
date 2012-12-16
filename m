Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51095 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2LPMA4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 07:00:56 -0500
Message-ID: <50CDB7D7.5030100@iki.fi>
Date: Sun, 16 Dec 2012 14:00:23 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrice Chotard <patrice.chotard@sfr.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	=?ISO-8859-1?Q?Fr=E9d=E9ric?= <frederic.mantegazza@gbiloba.org>
Subject: Re: [PATCH 1/2] [media] drxd: allow functional gate control after,
 attach
References: <50CD03A0.602@sfr.fr>
In-Reply-To: <50CD03A0.602@sfr.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/2012 01:11 AM, Patrice Chotard wrote:
> Previously, gate control didn't work until drxd_init()
> execution. Migrate necessary set of commands in drxd_attach
> to allow gate control to be used by tuner which are
> accessible through i2c gate.
>
> Reported-by: frederic.mantegazza@gbiloba.org
> Signed-off-by: Patrice Chotard <patricechotard@free.fr>
> ---
>   drivers/media/dvb-frontends/drxd_hard.c |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/media/dvb-frontends/drxd_hard.c
> b/drivers/media/dvb-frontends/drxd_hard.c
> index 6d98537..b2ab1e8 100644
> --- a/drivers/media/dvb-frontends/drxd_hard.c
> +++ b/drivers/media/dvb-frontends/drxd_hard.c
> @@ -2978,6 +2978,10 @@ struct dvb_frontend *drxd_attach(const struct
> drxd_config *config,
>   	       sizeof(struct dvb_frontend_ops));
>   	state->frontend.demodulator_priv = state;
>   	ConfigureMPEGOutput(state, 0);
> +	/* add few initialization to allow gate control */
> +	CDRXD(state, state->config.IF ? state->config.IF : 36000000);
> +	InitHI(state);
> +
>   	return &state->frontend;
>
>   error:
>

Reviewed-by: Antti Palosaari <crope@iki.fi>



I looked it quite carefully. Comments could be nice, but as far as I 
understood:

ConfigureMPEGOutput(state, 0);
* that puts device sleeping, mostly configures MPEG TS IF (set pins to 
some state eg. Hi-Z to prevent current leakage, I can guess).

CDRXD(state, state->config.IF ? state->config.IF : 36000000);
* that just initializes state - no I/O

InitHI(state);
* there is comment: port/bridge/power down ctrl
* HI == host interface ?
* that is normally done during init(),
* only one command => not much I/O


Looks fine, thank you!

regards
Antti

-- 
http://palosaari.fi/
