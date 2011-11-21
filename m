Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56009 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab1KUW2T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 17:28:19 -0500
Message-ID: <4ECAD07F.9010708@iki.fi>
Date: Tue, 22 Nov 2011 00:28:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: PATCH 12/13: 0012-CXD2820r-Query-DVB-frontend-delivery-capabilities
References: <CAHFNz9KmxyBB4nRQZg1RdU+6wXHmaR9WHejuMqp6g9qrXykjQQ@mail.gmail.com>
In-Reply-To: <CAHFNz9KmxyBB4nRQZg1RdU+6wXHmaR9WHejuMqp6g9qrXykjQQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

On 11/21/2011 11:09 PM, Manu Abraham wrote:
>   	/* program tuner */
> -	if (fe->ops.tuner_ops.set_params)
> -		fe->ops.tuner_ops.set_params(fe, params);
> +	tstate.delsys = SYS_DVBC_ANNEX_AC;
> +	tstate.frequency = c->frequency;
> +
> +	if (fe->ops.tuner_ops.set_state) {
> +		fe->ops.tuner_ops.set_state(fe,
> +					    DVBFE_TUNER_DELSYS    |
> +					    DVBFE_TUNER_FREQUENCY,
> +					&tstate);

I want to raise that point, switch from .set_params() to .set_state() 
when programming tuner. I don't see it reasonable to introduce (yes, it 
have existed ages but not used) new way to program tuner.

Both demod and tuner got same params;
.set_frontend(struct dvb_frontend *, struct dvb_frontend_parameters *)
.set_params(struct dvb_frontend *, struct dvb_frontend_parameters *)

and can get access to APIv5 property_cache similarly. Both, demod and 
tuner, can read all those params that are now passed using .set_state()

There is some new tuner drivers which are already using APIv5.


regards
Antti

-- 
http://palosaari.fi/
