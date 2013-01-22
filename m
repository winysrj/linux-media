Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3AVMRN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 07:17:13 -0500
Date: Tue, 22 Jan 2013 10:16:26 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130122101626.006d2d87@redhat.com>
In-Reply-To: <50F84CCC.5040103@iki.fi>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<20130116200153.3ec3ee7d@redhat.com>
	<CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com>
	<50F7C57A.6090703@iki.fi>
	<20130117145036.55745a60@redhat.com>
	<50F831AA.8010708@iki.fi>
	<20130117161126.6b2e809d@redhat.com>
	<50F84276.3080909@iki.fi>
	<CAHFNz9JDqYnrmNDt0_nBJMgzAymZSCXBbwY5MHR8AkMopPPQOA@mail.gmail.com>
	<20130117165037.6ed80366@redhat.com>
	<50F84CCC.5040103@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Jan 2013 21:11:08 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 01/17/2013 08:50 PM, Mauro Carvalho Chehab wrote:
> > Em Fri, 18 Jan 2013 00:07:17 +0530
> > Manu Abraham <abraham.manu@gmail.com> escreveu:
> >
> >> On Thu, Jan 17, 2013 at 11:57 PM, Antti Palosaari <crope@iki.fi> wrote:
> >>
> >>>
> >>>
> >>> Resetting counters when user tunes channel sounds the only correct option.
> >>>
> >>
> >> This might not be correct, especially when we have true Multiple Input Streams.
> >> The tune might be single, but the filter setup would be different. In
> >> which case it
> >> wouldn't correct to do a reset of the counters ona tune. Resetting the counters
> >> should be the responsibility of the driver.
> >
> > I moved the counters reset to the driver's logic on v11. I'm posting the
> > patches in a few.
> >
> >> As I said in an earlier
> >> post, anything
> >> other than the driver handling any statistical event monitoring, such an API is
> >> broken for sure, without even reading single line of code for that API for which
> >>   it is written for.
> >
> > Yes, driver should have full control on it.
> >
> >>> OK, maybe we will see in near future if that works well or not. I think that
> >>> for calculating of PER it is required to start continuous polling to keep up
> >>> total block counters. Maybe updating UCB counter continously needs that too,
> >>> so it should work.
> >>
> >>
> >> With multi-standard demodulators, some of them PER compute is a by-product
> >> of some internal demodulator algorithmic operation. In some cases, it might
> >> require a loop in the driver. As I said, again; It is very hard/wrong
> >> to do basic
> >> generalizations.
> >
> > Agreed.
> >
> 
> I think we will have soon kinda consensus everyone could approve! 
> Anyhow, I didn't liked that kind of PATCH RFC process. That change was 
> too big for PATCH style RFC and it was hard to keep track what going on 
> looking those patches. Maybe requirement specification RFCs first and 
> when requirements are clear => PATCH RFC for implementation.
> 
> What I know understand, requirements are:
> 
> signal strength:
> ==============
> Offer both discussed methods.
> Simple [0...n] scale and dB...
> Driver must support simple scale over dB.
> 
> CNR (SNR)
> ==============
> Offer both discussed methods.
> Simple [0...n] scale and dB...
> Driver must support simple scale over dB.
> 
> BER
> ==============
> Offer global BER and per layer BER.
> Measure is returned as two numbers, one for error bit count and one for 
> total bit count.
> 
> uncorrected packets/blocks
> ==============
> Offer global UCB and per layer UCB.
> Measure is returned as two numbers, one for uncorrected packet count and 
> one for total packet count.
> 
> counter reset
> ==============
> counters are reset when channel is tuned
> 
> 
> 
> And if we end up returning "simple" values over dB values, then I think 
> driver could be simple and implement only dB and dvb-core is responsible 
> to convert dB => simple. That should quite be possible as we know which 
> dB value is good signal and which is bad signal.
> 
> 
> Are these requirements now in line what is spoken?

Ok, I updated the DocBook to match what I understood from the above and from
our discussions. Please check.

---

Frontend statistics indicators
==============================

The values are returned via dtv_property.stat. If the property is supported, dtv_property.stat.len is bigger than zero.

For most delivery systems, dtv_property.stat.len will be 1 if the stats is supported, and the properties will return a single value for each parameter.

It should be noticed, however, that new OFDM delivery systems like ISDB can use different modulation types for each group of carriers. On such standards, up to 3 groups of statistics can be provided, and dtv_property.stat.len is updated to reflect the "global" metrics, plus one metric per each carrier group (called "layer" on ISDB).

So, in order to be consistent with other delivery systems, the first value at dtv_property.stat.dtv_stats array refers to the global metric. The other elements of the array represent each layer, starting from layer A(index 1), layer B (index 2) and so on.

The number of filled elements are stored at dtv_property.stat.len.

Each element of the dtv_property.stat.dtv_stats array consists on two elements:

    svalue or uvalue: svalue is for signed values of the measure (dB measures) and uvalue is for unsigned values (counters, relative scale)

    scale - Scale for the value. It can be:

        FE_SCALE_NOT_AVAILABLE - The parameter is supported by the frontend, but it was not possible to collect it (could be a transitory or permanent condition)

        FE_SCALE_DECIBEL - parameter is a signed value, measured in 1/1000 dB

        FE_SCALE_RELATIVE - parameter is a unsigned value, where 0 means 0% and 65535 means 100%.

        FE_SCALE_COUNTER - parameter is a unsigned value that counts the occurrence of an event, like bit error, block error, or lapsed time.

DTV_STAT_SIGNAL_STRENGTH
========================

Indicates the signal strength level at the analog part of the tuner or of the demod.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_DECIBEL - signal strength is in 0.0001 dBm units, power measured in miliwatts. This value is generally negative.
    FE_SCALE_RELATIVE - The frontend provides a 0% to 100% measurement for power (actually, 0-65535).

DTV_STAT_CNR
============

Indicates the Signal to Noise ratio for the main carrier.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_DECIBEL - Signal/Noise ratio is in 0.0001 dB units.
    FE_SCALE_RELATIVE - The frontend provides a 0% to 100% measurement for Signal/Noise (actually, 0-65535).

DTV_STAT_BIT_ERROR_COUNT
========================

Measures the number of bit errors before Viterbi.

This measure is taken during the same interval as DTV_STAT_TOTAL_BITS_COUNT.

In order to get the BER (Bit Error Rate) measurement, it should be divided by DTV_STAT_TOTAL_BITS_COUNT.

This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_COUNTER - Number of error bits counted before Viterbi.

DTV_STAT_TOTAL_BITS_COUNT
=========================

Measures the amount of bits received before the Viterbi block, during the same period as DTV_STAT_BIT_ERROR_COUNT measurement was taken.

It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream, as the frontend may need to manually restart the measurement, loosing some data between each measurement interval.

This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_COUNTER - Number of bits counted while measuring DTV_STAT_BIT_ERROR_COUNT.

DTV_STAT_ERROR_BLOCK_COUNT
==========================

Measures the number of block errors.

This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_COUNTER - Number of error blocks counted after Red Salomon.

DTV-STAT_TOTAL_BLOCKS_COUNT
===========================

Measures the total number of blocks received during the same period as DTV_STAT_ERROR_BLOCK_COUNT measurement was taken.

It can be used to calculate the PER indicator, by dividing DTV_STAT_ERROR_BLOCK_COUNT by DTV-STAT-TOTAL-BLOCKS-COUNT.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_COUNTER - Number of blocks counted while measuring DTV_STAT_ERROR_BLOCK_COUNT.

