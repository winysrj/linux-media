Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48354 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab3AWPJk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 10:09:40 -0500
Message-ID: <50FFFD0B.30701@iki.fi>
Date: Wed, 23 Jan 2013 17:08:59 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com> <20130116152151.5461221c@redhat.com> <CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com> <2817386.vHx2V41lNt@f17simon> <20130116200153.3ec3ee7d@redhat.com> <CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com> <50F7C57A.6090703@iki.fi> <20130117145036.55745a60@redhat.com> <50F831AA.8010708@iki.fi> <20130117161126.6b2e809d@redhat.com> <50F84276.3080909@iki.fi> <CAHFNz9JDqYnrmNDt0_nBJMgzAymZSCXBbwY5MHR8AkMopPPQOA@mail.gmail.com> <20130117165037.6ed80366@redhat.com> <50F84CCC.5040103@iki.fi> <20130122101626.006d2d87@redhat.com>
In-Reply-To: <20130122101626.006d2d87@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/22/2013 02:16 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 17 Jan 2013 21:11:08 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 01/17/2013 08:50 PM, Mauro Carvalho Chehab wrote:
>>> Em Fri, 18 Jan 2013 00:07:17 +0530
>>> Manu Abraham <abraham.manu@gmail.com> escreveu:
>>>
>>>> On Thu, Jan 17, 2013 at 11:57 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>
>>>>>
>>>>>
>>>>> Resetting counters when user tunes channel sounds the only correct option.
>>>>>
>>>>
>>>> This might not be correct, especially when we have true Multiple Input Streams.
>>>> The tune might be single, but the filter setup would be different. In
>>>> which case it
>>>> wouldn't correct to do a reset of the counters ona tune. Resetting the counters
>>>> should be the responsibility of the driver.
>>>
>>> I moved the counters reset to the driver's logic on v11. I'm posting the
>>> patches in a few.
>>>
>>>> As I said in an earlier
>>>> post, anything
>>>> other than the driver handling any statistical event monitoring, such an API is
>>>> broken for sure, without even reading single line of code for that API for which
>>>>    it is written for.
>>>
>>> Yes, driver should have full control on it.
>>>
>>>>> OK, maybe we will see in near future if that works well or not. I think that
>>>>> for calculating of PER it is required to start continuous polling to keep up
>>>>> total block counters. Maybe updating UCB counter continously needs that too,
>>>>> so it should work.
>>>>
>>>>
>>>> With multi-standard demodulators, some of them PER compute is a by-product
>>>> of some internal demodulator algorithmic operation. In some cases, it might
>>>> require a loop in the driver. As I said, again; It is very hard/wrong
>>>> to do basic
>>>> generalizations.
>>>
>>> Agreed.
>>>
>>
>> I think we will have soon kinda consensus everyone could approve!
>> Anyhow, I didn't liked that kind of PATCH RFC process. That change was
>> too big for PATCH style RFC and it was hard to keep track what going on
>> looking those patches. Maybe requirement specification RFCs first and
>> when requirements are clear => PATCH RFC for implementation.
>>
>> What I know understand, requirements are:
>>
>> signal strength:
>> ==============
>> Offer both discussed methods.
>> Simple [0...n] scale and dB...
>> Driver must support simple scale over dB.
>>
>> CNR (SNR)
>> ==============
>> Offer both discussed methods.
>> Simple [0...n] scale and dB...
>> Driver must support simple scale over dB.
>>
>> BER
>> ==============
>> Offer global BER and per layer BER.
>> Measure is returned as two numbers, one for error bit count and one for
>> total bit count.
>>
>> uncorrected packets/blocks
>> ==============
>> Offer global UCB and per layer UCB.
>> Measure is returned as two numbers, one for uncorrected packet count and
>> one for total packet count.
>>
>> counter reset
>> ==============
>> counters are reset when channel is tuned
>>
>>
>>
>> And if we end up returning "simple" values over dB values, then I think
>> driver could be simple and implement only dB and dvb-core is responsible
>> to convert dB => simple. That should quite be possible as we know which
>> dB value is good signal and which is bad signal.
>>
>>
>> Are these requirements now in line what is spoken?
>
> Ok, I updated the DocBook to match what I understood from the above and from
> our discussions. Please check.
>
> ---
>
> Frontend statistics indicators
> ==============================
>
> The values are returned via dtv_property.stat. If the property is supported, dtv_property.stat.len is bigger than zero.
>
> For most delivery systems, dtv_property.stat.len will be 1 if the stats is supported, and the properties will return a single value for each parameter.
>
> It should be noticed, however, that new OFDM delivery systems like ISDB can use different modulation types for each group of carriers. On such standards, up to 3 groups of statistics can be provided, and dtv_property.stat.len is updated to reflect the "global" metrics, plus one metric per each carrier group (called "layer" on ISDB).
>
> So, in order to be consistent with other delivery systems, the first value at dtv_property.stat.dtv_stats array refers to the global metric. The other elements of the array represent each layer, starting from layer A(index 1), layer B (index 2) and so on.
>
> The number of filled elements are stored at dtv_property.stat.len.
>
> Each element of the dtv_property.stat.dtv_stats array consists on two elements:
>
>      svalue or uvalue: svalue is for signed values of the measure (dB measures) and uvalue is for unsigned values (counters, relative scale)
>
>      scale - Scale for the value. It can be:
>
>          FE_SCALE_NOT_AVAILABLE - The parameter is supported by the frontend, but it was not possible to collect it (could be a transitory or permanent condition)
>
>          FE_SCALE_DECIBEL - parameter is a signed value, measured in 1/1000 dB
>
>          FE_SCALE_RELATIVE - parameter is a unsigned value, where 0 means 0% and 65535 means 100%.
>
>          FE_SCALE_COUNTER - parameter is a unsigned value that counts the occurrence of an event, like bit error, block error, or lapsed time.

These are OK

>
> DTV_STAT_SIGNAL_STRENGTH
> ========================
>
> Indicates the signal strength level at the analog part of the tuner or of the demod.
>
> Possible scales for this metric are:
>
>      FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
>      FE_SCALE_DECIBEL - signal strength is in 0.0001 dBm units, power measured in miliwatts. This value is generally negative.
>      FE_SCALE_RELATIVE - The frontend provides a 0% to 100% measurement for power (actually, 0-65535).

These are OK

>
> DTV_STAT_CNR
> ============
>
> Indicates the Signal to Noise ratio for the main carrier.
>
> Possible scales for this metric are:
>
>      FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
>      FE_SCALE_DECIBEL - Signal/Noise ratio is in 0.0001 dB units.
>      FE_SCALE_RELATIVE - The frontend provides a 0% to 100% measurement for Signal/Noise (actually, 0-65535).

These are OK

>
> DTV_STAT_BIT_ERROR_COUNT
> ========================
>
> Measures the number of bit errors before Viterbi.

It is not Viterbi, it is inner code (aka inner FEC)! Viterbi is old and 
legacy algorithm and not used for new systems. It was replaced mostly by 
LDPC algorithm (low-density parity-check).

Also, I have changed a little bit of my mind and I think it is better to 
offer post-BER rather than pre-BER (VBER, or Viterbi BER, is same as 
post-BER, BER measured after the Viterbi coding). From the post-BER we 
could make some estimation what is possibility of uncorrected packets 
(after the outer coding). I am not against to offer both pre-BER and 
post-BER.

But the biggest problem is that you speak Viterbi algorithm, as we has 
some others too! Use general terms instead.

>
> This measure is taken during the same interval as DTV_STAT_TOTAL_BITS_COUNT.
>
> In order to get the BER (Bit Error Rate) measurement, it should be divided by DTV_STAT_TOTAL_BITS_COUNT.
>
> This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.
>
> Possible scales for this metric are:
>
>      FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
>      FE_SCALE_COUNTER - Number of error bits counted before Viterbi.

The rest in that section are OK.

>
> DTV_STAT_TOTAL_BITS_COUNT
> =========================

This sounds wrong in my ears. I am not native English speaker, but for 
me DTV_STAT_TOTAL_BIT_COUNT sounds correct.

>
> Measures the amount of bits received before the Viterbi block, during the same period as DTV_STAT_BIT_ERROR_COUNT measurement was taken.
>
> It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream, as the frontend may need to manually restart the measurement, loosing some data between each measurement interval.
>
> This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.
>
> Possible scales for this metric are:
>
>      FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
>      FE_SCALE_COUNTER - Number of bits counted while measuring DTV_STAT_BIT_ERROR_COUNT.

The rest in that section are OK.

>
> DTV_STAT_ERROR_BLOCK_COUNT
> ==========================
>
> Measures the number of block errors.

Block errors after the outer coding. OK, maybe better to leave it out 
and keep that doc less technical. But on the other hand, you mention 
Viterbi (inner coding) on BER measurement, so these two are not 
documented consistent. Also, it is easier to say during review that this 
is wrong if there is clearly documented what all the measurements are 
(even those are something like defacto terms in digital transmission). 
Not so much stupid yes/no discussion and explaining.

>
> This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.
>
> Possible scales for this metric are:
>
>      FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
>      FE_SCALE_COUNTER - Number of error blocks counted after Red Salomon.

It is Reed–Solomon != Red Salomon

Also same for that than Viterbi. There is other algorithms used 
nowadays. Better to use some generic term like outer coding or outer FEC.

Packet or block? I think packet is more generic, whilst block is used 
more in certain cases like Reed-Solomon.


>
> DTV-STAT_TOTAL_BLOCKS_COUNT
> ===========================

DTV-STAT_TOTAL_BLOCK_COUNT ?

>
> Measures the total number of blocks received during the same period as DTV_STAT_ERROR_BLOCK_COUNT measurement was taken.
>
> It can be used to calculate the PER indicator, by dividing DTV_STAT_ERROR_BLOCK_COUNT by DTV-STAT-TOTAL-BLOCKS-COUNT.
>
> Possible scales for this metric are:
>
>      FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
>      FE_SCALE_COUNTER - Number of blocks counted while measuring DTV_STAT_ERROR_BLOCK_COUNT.
>
The rest in that section are OK.

regards
Antti

-- 
http://palosaari.fi/
