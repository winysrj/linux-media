Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab1C1Sqo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 14:46:44 -0400
Message-ID: <4D90D78F.7050308@redhat.com>
Date: Mon, 28 Mar 2011 15:46:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: handygewinnspiel@gmx.de
CC: linux-media@vger.kernel.org
Subject: Re: [w_scan PATCH] Add Brazil support on w_scan
References: <4D909B59.9040809@redhat.com> <20110328172045.64750@gmx.net>
In-Reply-To: <20110328172045.64750@gmx.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 28-03-2011 14:20, handygewinnspiel@gmx.de escreveu:
> Hi Mauro,
> 
>> This patch adds support for both ISDB-T and DVB-C @6MHz used in
>> Brazil, and adds a new bit rate of 5.2170 MSymbol/s, found on QAM256
>> transmissions at some Brazilian cable operators.
> 
> Good. :)
> 
>> While here, fix compilation with kernels 2.6.39 and later, where the
>> old V4L1 API were removed (so, linux/videodev.h doesn't exist anymore).
>> This is needed to compile it on Fedora 15 beta.
> 
> videodev.h should have never been in there. Was already reported and will be removed instead.
> 
>> @@ -1985,6 +1986,10 @@
>>  		dvbc_symbolrate_min=dvbc_symbolrate_max=0;
>>  		break;
>>  	case FE_QAM:
>> +		// 6MHz DVB-C uses lower symbol rates
>> +		if (freq_step(channel, this_channellist) == 6000000) {
>> +			dvbc_symbolrate_min=dvbc_symbolrate_max=17;
>> +		}
>>  		break;
>>  	case FE_QPSK:
>>  		// channel means here: transponder,
> 
> This one causes me headache, because this one has side-effects to all other DVB-C cases using 6MHz bandwidth.
> Are there *any cases* around, where some country may use DVB-C with symbolrates other than 5.217Mbit/s?

If you take a look at EN 300 429[1], The DVB-C roll-off factor (alpha) is defined as 0.15.

	[1] EN 300 429 V1.2.1 (1998-04), chapter 9, page 16, and table B.1

So, the amount of the needed bandwidth (e. g. the Nyquist cut-off frequency) is given by:
  Bw = Symbol_rate * (1 + 0.15)

E. g. the maximum symbol rate is given by:

	Symbol_rate(6MHz) = 6000000/1.15 = 5217391.30434782608695652173
	Symbol_rate(7MHz) = 7000000/1.15 = 6086956.52173913043478260869
	Symbol_rate(8MHz) = 8000000/1.15 = 6956521.73913043478260869565

As you see, for Countries using 6MHz bandwidth, the maximum value is about 5.127 Mbauds.
With the current w_scan logic of assuming 6.9 or 6.875 Mbauds by default for DVB-C, 
w_scan will never find any channel, if the channel bandwidth fits into a 6MHz (or 7MHz)
channel spacing.

So, the above change won't cause regressions, although it could be improved.

IMHO, a different logic could be used instead, if the user doesn't use the -S parameter, like:

int dvbc_symbolrate[] = {
	7000000,
	6956500,		/* Max Symbol rate for 8 MHz channel bandwidth */
	6956000,
	6952000,
	6950000,
	6900000,
	6875000,
	6811000,
	6790000,
	6250000,
	6111000,

	/* Weird: I would expect 6086 or 6086.5 here, as the max rate for 7MHz spacing */
			
	5900000,		/* Require at least 7 MHz channel bandwidth */
	5483000,
	5217000,		/* Max Symbol rate for 6 MHz channel bandwidth */
	5156000,
	5000000,
	4000000,
	3450000,
};

for (i = 0; i < ARRAY_SIZE(dvbc_symbolrate)) {
	if (freq_step(channel, this_channellist) / 1.15 > dvbc_symbolrate[i])
		next;

	/* Scan channel */
...
}

Btw, this looks weird to me:
static int dvbc_symbolrate(int index)
{
       	switch(index) {
...
		case 11:                return 7000000;
...

While it might work, the amount of bandwidth is 8.050 MHz. Yet, as tuner low-pass filter 
will probably not attenuate too much the extra 50kHz, I don't doubt that someone would
be tempted to use this rate, but probably some boards will have troubles with that.

> I know that for Europe there are many cases where low symbolrates are used, even if higher would be possible.
> 
> If there are any doubts, i would prefer a solution like this and add all countries know to use this srate:
> 
>   		dvbc_symbolrate_min=dvbc_symbolrate_max=0;
>   		break;
>   	case FE_QAM:
>  +		// 6MHz DVB-C uses lower symbol rates
>  +		switch (this_channellist) {
>  +                       case DVBC_BR:
>  +			      dvbc_symbolrate_min=dvbc_symbolrate_max=17;
>  +                            break;
>  +                       default:; 
>  +		}
>   		break;

Yeah, this would work for Brazil, provided that we won't find any other operator
here using a Symbol rate bellow the maximum allowed.

>   	case FE_QPSK:
>   		// channel means here: transponder,
> 
> 
> I need an valid answer which solution is better to accept this patch.
> 
> cheers,
> Winfried

