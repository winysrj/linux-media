Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35299 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaHQTao (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Aug 2014 15:30:44 -0400
Received: by mail-pa0-f44.google.com with SMTP id eu11so6376769pac.17
        for <linux-media@vger.kernel.org>; Sun, 17 Aug 2014 12:30:44 -0700 (PDT)
Message-ID: <53F0DCA6.2090501@gmail.com>
Date: Mon, 18 Aug 2014 01:47:34 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, james.hogan@imgtec.com
Subject: Re: [PATCH 1/4] mxl301rf: add driver for MaxLinear MxL301RF OFDM
 tuner
References: <1405352627-22677-1-git-send-email-tskd08@gmail.com> <1405352627-22677-2-git-send-email-tskd08@gmail.com> <20140815125053.5cc901a6.m.chehab@samsung.com>
In-Reply-To: <20140815125053.5cc901a6.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,
thanks for the review.
I will update the patch and post it later.
Before doing so, I'd like to ask some questions.

>> +++ b/drivers/media/tuners/mxl301rf.c
>> +/* *strength : [1/1000 dBm] */
>> +static int mxl301rf_get_rf_strength(struct dvb_frontend *fe, u16 *strength)
>> +{
....... 
> Please implement it using DVBv5 API, e. g. using dBm scale.

Do you mean that fe->tuner_ops.get_rf_strength() is deprecated
and should not be used?
And as you pointed me out in the review of tc90522,
> The better is likely to add a new ops to get rf strength in dBm as s64,
> just like the way we use it on DVBv5.
should I add a new tuner_ops to the DVB core like get_rf_strength_v5(fe,&s64)?
Or should mxl301rf provide raw u16 value and tc90522 convert it to s64
like in dvb-frontends/dib7000p.c?


>> +static int mxl301rf_set_params(struct dvb_frontend *fe)
>> +{
........
>> +
>> +	/* spur shift function (for analog) */
>> +	for (i = 0; i < ARRAY_SIZE(shf_tab); i++) {
>> +		if (freq >= (shf_tab[i].freq - shf_tab[i].ofst_th) * 1000 &&
>> +		    freq <= (shf_tab[i].freq + shf_tab[i].ofst_th) * 1000) {
>> +			tune0[2 * 5 + 1] = shf_tab[i].shf_val;
>> +			tune0[2 * 6 + 1] = 0xa0 | shf_tab[i].shf_dir;
>> +			break;
>> +		}
>> +	}
> 
> Hmm... are you using a table to match the channels? If so, don't do that.
> Instead, just calculate the dividers based on the given frequency.

mxl301rf requires to set frequency instead of the dividers,
as in the following section.

>> +	/* convert freq to 10.6 fixed point float [MHz] */
>> +	f = freq / 1000000;
>> +	tmp = freq % 1000000;
>> +	div = 1000000;
>> +	for (i = 0; i < 6; i++) {
>> +		f <<= 1;
>> +		div >>= 1;
>> +		if (tmp > div) {
>> +			tmp -= div;
>> +			f |= 1;
>> +		}
>> +	}
>> +	if (tmp > 7812)
>> +		f++;
>> +	tune1[2 * 0 + 1] = f & 0xff;
>> +	tune1[2 * 1 + 1] = f >> 8;
>> +	ret = data_write(state, tune1, sizeof(tune1));
>> +	if (ret < 0)
>> +		goto failed;

shf_tab[] holds another parameters for another purpose ("spur shift"?),
whose values depend on the range of the input frequency.
This table is ported from the reference "SDK" source of PT3,
and no further info is disclosed.
I made an experiment that removes the code to set those parameters and
it worked fine without problems in my environment, but I kept the code
since I don't know what those parameter exactly mean.


>> +	},
>> +
>> +	.release = mxl301rf_release,
>> +	.init = mxl301rf_init,
>> +	.sleep = mxl301rf_sleep,
>> +
>> +	.set_params = mxl301rf_set_params,
>> +	.get_status = mxl301rf_get_status,
>> +	.get_rf_strength = mxl301rf_get_rf_strength,
> 
> Isn't it capable of providing more stats?
> 

I can add .get_frequency() or .get_bandwidth(),
but those are not used in DVB core and
frontends can get those info from its property cache.
Should those trivial funcs be implemented?

(As with .get_{if_freq,afc}(), necessary info is not disclosed.)

regards,
akihiro

