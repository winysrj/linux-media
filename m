Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60322 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab1LWWd4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Dec 2011 17:33:56 -0500
Message-ID: <4EF501C5.90006@iki.fi>
Date: Sat, 24 Dec 2011 00:33:41 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv1] add DTMB support for DVB API
References: <4EF3A171.3030906@iki.fi> <4EF48473.3020207@linuxtv.org>
In-Reply-To: <4EF48473.3020207@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/23/2011 03:38 PM, Andreas Oberritter wrote:
> On 22.12.2011 22:30, Antti Palosaari wrote:
>> @@ -201,6 +205,9 @@ typedef enum fe_guard_interval {
>>       GUARD_INTERVAL_1_128,
>>       GUARD_INTERVAL_19_128,
>>       GUARD_INTERVAL_19_256,
>> +    GUARD_INTERVAL_PN420,
>> +    GUARD_INTERVAL_PN595,
>> +    GUARD_INTERVAL_PN945,
>>   } fe_guard_interval_t;
>
> What does PN mean in this context?

It stays for pseudo noise.

Generally those are rather same as PN420 = GI 1/4, PN595 = GI 1/6, PN945 
= GI 1/9. But as a old DVB-T GI, cyclic prefix, is rather likely some 
static data without any real payload meaning, the PN GI is enchanted 
inserting some data that have meaning. Also PN GI is boosted, like 
doubled TX power in order to easy sync.

Here is the one good research paper which compares DVB-T and DTMB [1]
And this Wikipedia page is rather helful too [2]


As I have read much more docs today I have now some changes I want to do:

CARRIER
=======
typedef enum fe_transmit_mode {
	TRANSMISSION_MODE_C=1,
	TRANSMISSION_MODE_C=3780,
} fe_transmit_mode_t;

(If not "=" mark is not possible then use C1, C3780)

Instead of adding new carrier param, just use exiting one since it seems 
to be just suitable. Extend DTMB modes C=1 and C=3780.



GUARD INTERVAL (PN-mode)
========================
typedef enum fe_guard_interval {
	GUARD_INTERVAL_PN420,
	GUARD_INTERVAL_PN595,
	GUARD_INTERVAL_PN945,
} fe_guard_interval_t;



CODE RATE
=========
typedef enum fe_code_rate {
	FEC_04,
	FEC_06,
	FEC_08,
} fe_code_rate_t;

I have strong feeling old FECs, 1 over 2, are 100% suitable only for the 
Reed-Solomon coding. For BCH + LDPC coding those are not so suitable as 
code rate is not exact and thus with LDPC 0.4/0.6/0.8 is used. I have 
mentioned that earlier too, but after I read that [1] I think it is just 
like that. It is not big issue but still I would like to use those 
instead old.

Otherwise FEC_2_5 for code rate 0.4 should be defined.



MODULATION (constellation)
==========================
typedef enum fe_modulation {
	QAM_4_NR,
} fe_modulation_t;

I feel QAM4-NR fits here too, since it is mentioned every document just 
one more supported modulation like QAM32, QAM16, QAM4...


INTERLEAVING
============
typedef enum fe_interleaving {
	INTERLEAVING_240,
	INTERLEAVING_720,
} fe_interleaving_t;

I think better to add enum for all possible interleavers we can have. I 
suspect there will be very limited amount of interleave settings 
supported by each DTV modulation, thus enum is good choice.



That's all. I will wait comments maybe tomorrow night and make new 
propose or RFC. I hope comments. And all those comments given are taken 
accepted unless I replied something back. And please look research paper 
[1], it is very good. Happy Xmas!


[1] Analysis and Performance Comparison of DVB-T and DTMB Systems for 
Terrestrial Digital TV
http://hal.archives-ouvertes.fr/docs/00/32/58/24/PDF/MLIU_ICCS2008.pdf

[2] OFDM system comparison table
http://en.wikipedia.org/wiki/OFDM#OFDM_system_comparison_table

regards
Antti
-- 
http://palosaari.fi/
