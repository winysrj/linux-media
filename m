Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41303 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaHQTas (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Aug 2014 15:30:48 -0400
Received: by mail-pd0-f173.google.com with SMTP id w10so6179910pde.4
        for <linux-media@vger.kernel.org>; Sun, 17 Aug 2014 12:30:48 -0700 (PDT)
Message-ID: <53F0F35D.2090702@gmail.com>
Date: Mon, 18 Aug 2014 03:24:29 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, james.hogan@imgtec.com
Subject: Re: [PATCH 3/4] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1405352627-22677-1-git-send-email-tskd08@gmail.com> <1405352627-22677-2-git-send-email-tskd08@gmail.com> <1405352627-22677-3-git-send-email-tskd08@gmail.com> <1405352627-22677-4-git-send-email-tskd08@gmail.com> <20140815130924.72029bfd.m.chehab@samsung.com>
In-Reply-To: <20140815130924.72029bfd.m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014年08月16日 01:09, Mauro Carvalho Chehab wrote:
>> +++ b/drivers/media/dvb-frontends/tc90522.c
............
>> +static int tc90522s_get_frontend(struct dvb_frontend *fe)
>> +{
.............
>> +	c->delivery_system = SYS_ISDBS;
>> +	c->symbol_rate = 28860000;
> 
> Hmm... symbol rate is fixed? That looks weird on my eyes.

Though I may be totally wrong,
I set it to 28.86M because ARIB STD B20 (section 2.3) defines
the speed of the modulated carrier signal be 28.860Mbaud.

But carrier is splitted into 48 slots and
they are assigned to multiple TS's, which are modulated with
(one of or a combination of) either 8PSK or QPSK or BPSK. 
Dummy slots are included in the case of QPSK/BPSK.
The output TS is chosen by TS_ID.

Should I set c->symbol_rate to
   (# of slots assigned to the output TS)/48 * 28.86Mbaud
?

>> +static int tc90522t_get_frontend(struct dvb_frontend *fe)
>> +{
>> +	static const fe_transmit_mode_t tm_conv[] = {
>> +		TRANSMISSION_MODE_2K,
>> +		TRANSMISSION_MODE_4K,
>> +		TRANSMISSION_MODE_8K, 0
> 
> Better to put the final 0 on a separate line, to be consistent.
> 
> I would also move those tables out of get_frontend, as this improves
> readability.

Do "those tables" include generally other "static const" tables in other functions?
there are lots of small, function-scoped const tables which define register values
and just used in one function, like the following ones.

>> +static int tc90522_set_frontend(struct dvb_frontend *fe)
>> +{
>> +	static const struct reg_val reset_sat = { 0x03, 0x01 };
>> +	static const struct reg_val reset_ter = { 0x01, 0x40 };


>> +	state = fe->demodulator_priv;
>> +
>> +	if (fe->ops.tuner_ops.set_params)
>> +		ret = fe->ops.tuner_ops.set_params(fe);
> 
> Hmm... I'm not seeing any part of the driver parsing the ISDB
> parameters (except for the frequency).
(and TS_ID, layers).
As this demod looks into TMCC and adjusts lots of parameters automatically,
with preset defaults (for Japanese ISDB-S/T).
Thus the frequency is the minimum and sufficient parameter to demodulate.
