Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44628 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab1KNS7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 13:59:36 -0500
Received: by wwe5 with SMTP id 5so4841412wwe.1
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 10:59:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EC16133.8090300@redhat.com>
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com>
	<4EBBE336.8050501@linuxtv.org>
	<CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com>
	<4EBC402E.20208@redhat.com>
	<alpine.DEB.2.01.1111111759060.6676@localhost.localdomain>
	<4EBD6B61.7020605@redhat.com>
	<CAHFNz9JSk+TeptBZ8F9SEiyaa8q5OO8qwBiBxR9KEsOT8o_J-w@mail.gmail.com>
	<4EBFC6F3.50404@redhat.com>
	<CAHFNz9+Gia40gQkW_VtRrwpawqhLDzwL5Qf_AGW4zQSJ3yj1Yg@mail.gmail.com>
	<4EC0FFCA.6060006@redhat.com>
	<CAHFNz9KRGwcPwfndg322Fso_i=zuArJDijoP2evLjJuaOFviDA@mail.gmail.com>
	<4EC1445C.4030503@redhat.com>
	<CAHFNz9JLmqVO-ViK_22vrcpSN3sz82dKtwo6yepgUooHZ5qn9A@mail.gmail.com>
	<4EC1590E.8040302@redhat.com>
	<CAHFNz9KqYYtH4YdLwkROXN=94Fr8pbbvJspQLu6VM8LuSNNjKA@mail.gmail.com>
	<4EC16133.8090300@redhat.com>
Date: Tue, 15 Nov 2011 00:29:35 +0530
Message-ID: <CAHFNz9JQYLKDu_1TURzjUO5FBXmrh8M-f-tVickSN3YLm7=nBg@mail.gmail.com>
Subject: Re: PATCH: Query DVB frontend capabilities
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 15, 2011 at 12:12 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 14-11-2011 16:30, Manu Abraham escreveu:
>> On Mon, Nov 14, 2011 at 11:38 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Yet, this doesn't require any changes at DVB API, as all that the demodulator
>>> need to know is the sub-carrier parameters (frequency, roll-off, symbol
>>> rate, etc).
>>
>> You do: this is why there were changes to the V3 API to accomodate
>> DVB-S2, which eventually became V5. The major change that underwent is
>> the addition of newer modulations. The demodulator need to be
>> explicitly told of the modulation. With some demodulators, the
>> modulation order could be detected from the PL signaling, rather than
>> the user space application telling it.
>
> DVB-S2 doesn't require DVB bandwidth to be specified.


stb0899:
		switch (state->delsys) {
		case SYS_DVBS:
		case SYS_DSS:
                                  ......
			if (state->config->tuner_set_bandwidth)
				state->config->tuner_set_bandwidth(fe, (13 *
(stb0899_carr_width(state) + SearchRange)) / 10);
			if (state->config->tuner_get_bandwidth)
				state->config->tuner_get_bandwidth(fe, &internal->tuner_bw);
                               .......
    			break;
		case SYS_DVBS2:
                                  ......
			if (state->config->tuner_set_bandwidth)
				state->config->tuner_set_bandwidth(fe, (stb0899_carr_width(state)
+ SearchRange));
			if (state->config->tuner_get_bandwidth)
				state->config->tuner_get_bandwidth(fe, &internal->tuner_bw);
    			break;


cx24116:

	/* Set/Reset B/W */
	cmd.args[0x00] = CMD_BANDWIDTH;
	cmd.args[0x01] = 0x01;
	cmd.len = 0x02;
	ret = cx24116_cmd_execute(fe, &cmd);
	if (ret != 0)
		return ret;


stv090x does a lot of auto detection for almost everything, but still:

stv090x:
			if (state->algo == STV090x_COLD_SEARCH)
				state->tuner_bw = (15 * (stv090x_car_width(state->srate,
state->rolloff) + 10000000)) / 10;
			else if (state->algo == STV090x_WARM_SEARCH)
				state->tuner_bw = stv090x_car_width(state->srate, state->rolloff)
+ 10000000;
		}


Regards,
Manu
