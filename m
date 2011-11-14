Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab1KNUb5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 15:31:57 -0500
Message-ID: <4EC17ABA.3010604@redhat.com>
Date: Mon, 14 Nov 2011 18:31:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <alpine.DEB.2.01.1111111759060.6676@localhost.localdomain> <4EBD6B61.7020605@redhat.com> <CAHFNz9JSk+TeptBZ8F9SEiyaa8q5OO8qwBiBxR9KEsOT8o_J-w@mail.gmail.com> <4EBFC6F3.50404@redhat.com> <CAHFNz9+Gia40gQkW_VtRrwpawqhLDzwL5Qf_AGW4zQSJ3yj1Yg@mail.gmail.com> <4EC0FFCA.6060006@redhat.com> <CAHFNz9KRGwcPwfndg322Fso_i=zuArJDijoP2evLjJuaOFviDA@mail.gmail.com> <4EC1445C.4030503@redhat.com> <CAHFNz9JLmqVO-ViK_22vrcpSN3sz82dKtwo6yepgUooHZ5qn9A@mail.gmail.com> <4EC1590E.8040302@redhat.com> <CAHFNz9KqYYtH4YdLwkROXN=94Fr8pbbvJspQLu6VM8LuSNNjKA@mail.gmail.com> <4EC16133.8090300@redhat.com> <CAHFNz9JQYLKDu_1TURzjUO5FBXmrh8M-f-tVickSN3YLm7=nBg@mail.gmail.com>
In-Reply-To: <CAHFNz9JQYLKDu_1TURzjUO5FBXmrh8M-f-tVickSN3YLm7=nBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-11-2011 16:59, Manu Abraham escreveu:
> On Tue, Nov 15, 2011 at 12:12 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 14-11-2011 16:30, Manu Abraham escreveu:
>>> On Mon, Nov 14, 2011 at 11:38 PM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com> wrote:
>>>> Yet, this doesn't require any changes at DVB API, as all that the demodulator
>>>> need to know is the sub-carrier parameters (frequency, roll-off, symbol
>>>> rate, etc).
>>>
>>> You do: this is why there were changes to the V3 API to accomodate
>>> DVB-S2, which eventually became V5. The major change that underwent is
>>> the addition of newer modulations. The demodulator need to be
>>> explicitly told of the modulation. With some demodulators, the
>>> modulation order could be detected from the PL signaling, rather than
>>> the user space application telling it.
>>
>> DVB-S2 doesn't require DVB bandwidth to be specified.

What I meant to say is that DVB-S2 doesn't require that the bandwidth to be
provided via DVBv5 API.

> stb0899:
> 		switch (state->delsys) {
> 		case SYS_DVBS:
> 		case SYS_DSS:
>                                   ......
> 			if (state->config->tuner_set_bandwidth)
> 				state->config->tuner_set_bandwidth(fe, (13 *
> (stb0899_carr_width(state) + SearchRange)) / 10);
> 			if (state->config->tuner_get_bandwidth)
> 				state->config->tuner_get_bandwidth(fe, &internal->tuner_bw);
>                                .......
>     			break;
> 		case SYS_DVBS2:
>                                   ......
> 			if (state->config->tuner_set_bandwidth)
> 				state->config->tuner_set_bandwidth(fe, (stb0899_carr_width(state)
> + SearchRange));
> 			if (state->config->tuner_get_bandwidth)
> 				state->config->tuner_get_bandwidth(fe, &internal->tuner_bw);
>     			break;
> 
> 
> cx24116:
> 
> 	/* Set/Reset B/W */
> 	cmd.args[0x00] = CMD_BANDWIDTH;
> 	cmd.args[0x01] = 0x01;
> 	cmd.len = 0x02;
> 	ret = cx24116_cmd_execute(fe, &cmd);
> 	if (ret != 0)
> 		return ret;
> 
> 
> stv090x does a lot of auto detection for almost everything, but still:
> 
> stv090x:
> 			if (state->algo == STV090x_COLD_SEARCH)
> 				state->tuner_bw = (15 * (stv090x_car_width(state->srate,
> state->rolloff) + 10000000)) / 10;
> 			else if (state->algo == STV090x_WARM_SEARCH)
> 				state->tuner_bw = stv090x_car_width(state->srate, state->rolloff)
> + 10000000;
> 		}

Frontends of course need it. The code at stv090x is clear:
	state->tuner_bw = stv090x_car_width(state->srate, state->rolloff)

...

static u32 stv090x_car_width(u32 srate, enum stv090x_rolloff rolloff)
{
	u32 ro;

	switch (rolloff) {
	case STV090x_RO_20:
		ro = 20;
		break;
	case STV090x_RO_25:
		ro = 25;
		break;
	case STV090x_RO_35:
	default:
		ro = 35;
		break;
	}

	return srate + (srate * ro) / 100;
}

Regards,
Mauro
