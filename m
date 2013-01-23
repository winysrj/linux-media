Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab3AWSSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 13:18:21 -0500
Date: Wed, 23 Jan 2013 16:18:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130123161801.764495e5@redhat.com>
In-Reply-To: <50FFFD0B.30701@iki.fi>
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
	<20130122101626.006d2d87@redhat.com>
	<50FFFD0B.30701@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Jan 2013 17:08:59 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 01/22/2013 02:16 PM, Mauro Carvalho Chehab wrote:
> > Em Thu, 17 Jan 2013 21:11:08 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >
> > DTV_STAT_BIT_ERROR_COUNT
> > ========================
> >
> > Measures the number of bit errors before Viterbi.
> 
> It is not Viterbi, it is inner code (aka inner FEC)! Viterbi is old and 
> legacy algorithm and not used for new systems. It was replaced mostly by 
> LDPC algorithm (low-density parity-check).

Yes, on newer standards. However, the API spec still mentions Viterbi as
one or the frontend possible status.

Anyway, I agree: it is better to use the generic term. However, as calling it
as pre-Viterbi BER is common, I opted to keep the Viterbi nomenclature in
parenthesis.

While here, I'll also fix the status documentation at the DVB API:

 <entry align="char">FE_HAS_VITERBI</entry>
-<entry align="char">The frontend FEC code is stable</entry>
+<entry align="char">The frontend FEC inner coding (Viterbi, LDPC or other inner code) is stable</entry>

> Also, I have changed a little bit of my mind and I think it is better to 
> offer post-BER rather than pre-BER (VBER, or Viterbi BER, is same as 
> post-BER, BER measured after the Viterbi coding). From the post-BER we 
> could make some estimation what is possibility of uncorrected packets 
> (after the outer coding). I am not against to offer both pre-BER and 
> post-BER.

Ok, I'll add both then. I have already coded the pre-BER code for mb86a20s.
I'll later code a post-BER logic there at the driver.

> But the biggest problem is that you speak Viterbi algorithm, as we has 
> some others too! Use general terms instead.
> 
> >
> > This measure is taken during the same interval as DTV_STAT_TOTAL_BITS_COUNT.
> >
> > In order to get the BER (Bit Error Rate) measurement, it should be divided by DTV_STAT_TOTAL_BITS_COUNT.
> >
> > This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.
> >
> > Possible scales for this metric are:
> >
> >      FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
> >      FE_SCALE_COUNTER - Number of error bits counted before Viterbi.
> 
> The rest in that section are OK.
> 
> >
> > DTV_STAT_TOTAL_BITS_COUNT
> > =========================
> 
> This sounds wrong in my ears. I am not native English speaker, but for 
> me DTV_STAT_TOTAL_BIT_COUNT sounds correct.
> 
> >
> > Measures the amount of bits received before the Viterbi block, during the same period as DTV_STAT_BIT_ERROR_COUNT measurement was taken.
> >
> > It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream, as the frontend may need to manually restart the measurement, loosing some data between each measurement interval.
> >
> > This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.
> >
> > Possible scales for this metric are:
> >
> >      FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
> >      FE_SCALE_COUNTER - Number of bits counted while measuring DTV_STAT_BIT_ERROR_COUNT.
> 
> The rest in that section are OK.

I think it is not incorrect to say bits count, but the better is to use
singular on all measures.

Ok, This is how those measures are now shown after the fixes:

DTV_STAT_PRE_BIT_ERROR_COUNT
============================

Measures the number of bit errors before the forward error correction (FEC) on the inner coding block (before Viterbi, LDPC or other inner code).

This measure is taken during the same interval as DTV_STAT_PRE_TOTAL_BIT_COUNT.

In order to get the BER (Bit Error Rate) measurement, it should be divided by DTV_STAT_PRE_TOTAL_BIT_COUNT.

This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_COUNTER - Number of error bits counted before the inner coding.

DTV_STAT_PRE_TOTAL_BIT_COUNT
============================

Measures the amount of bits received before the inner code block, during the same period as DTV_STAT_PRE_BIT_ERROR_COUNT measurement was taken.

It should be noticed that this measurement can be smaller than the total amount of bits on the transport stream, as the frontend may need to manually restart the measurement, loosing some data between each measurement interval.

This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_COUNTER - Number of bits counted while measuring DTV_STAT_PRE_BIT_ERROR_COUNT.

DTV_STAT_POST_BIT_ERROR_COUNT
=============================

Measures the number of bit errors after the forward error correction (FEC) done by inner code block (after Viterbi, LDPC or other inner code).

This measure is taken during the same interval as DTV_STAT_POST_TOTAL_BIT_COUNT.

In order to get the BER (Bit Error Rate) measurement, it should be divided by DTV_STAT_POST_TOTAL_BIT_COUNT.

This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_COUNTER - Number of error bits counted after the inner coding.

DTV_STAT_POST_BIT_ERROR_COUNT
=============================

Measures the number of bit errors after the forward error correction (FEC) done by inner code block (after Viterbi, LDPC or other inner code).

This measure is taken during the same interval as DTV_STAT_POST_TOTAL_BIT_COUNT.

In order to get the BER (Bit Error Rate) measurement, it should be divided by DTV_STAT_POST_TOTAL_BIT_COUNT.

This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_COUNTER - Number of error bits counted after the inner coding

> 
> >
> > DTV_STAT_ERROR_BLOCK_COUNT
> > ==========================
> >
> > Measures the number of block errors.
> 
> Block errors after the outer coding. OK, maybe better to leave it out 
> and keep that doc less technical. But on the other hand, you mention 
> Viterbi (inner coding) on BER measurement, so these two are not 
> documented consistent. Also, it is easier to say during review that this 
> is wrong if there is clearly documented what all the measurements are 
> (even those are something like defacto terms in digital transmission). 
> Not so much stupid yes/no discussion and explaining.

IMO, it is better to be more technical, to avoid implementation mistakes.

Changed it to:

DTV_STAT_ERROR_BLOCK_COUNT
==========================

Measures the number of block errors after the outer forward error correction coding (after Reed-Solomon or other outer code).

This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.

Possible scales for this metric are:

    FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
    FE_SCALE_COUNTER - Number of error blocks counted after the outer coding.
> 
> >
> > This measurement is monotonically increased, as the frontend gets more bit count measurements. The frontend may reset it when a channel/transponder is tuned.
> >
> > Possible scales for this metric are:
> >
> >      FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
> >      FE_SCALE_COUNTER - Number of error blocks counted after Red Salomon.
> 
> It is Reed–Solomon != Red Salomon

Yes, I know. My brain trapped me on that ;)

> Also same for that than Viterbi. There is other algorithms used 
> nowadays. Better to use some generic term like outer coding or outer FEC.
> 
> Packet or block? I think packet is more generic, whilst block is used 
> more in certain cases like Reed-Solomon.

I think both terms are almost synonymous. Packet reminds more like an
IP-based variable-length sequence, where block sounds more like a 
fixed-length.

As those measures can be used either for UCB (blocks) or PER (packet),
both terms sound correct, IMHO.

I would keep block, as UCB is a more common measurement than PER.

> >
> > DTV-STAT_TOTAL_BLOCKS_COUNT
> > ===========================
> 
> DTV-STAT_TOTAL_BLOCK_COUNT ?

OK.

> 
> >
> > Measures the total number of blocks received during the same period as DTV_STAT_ERROR_BLOCK_COUNT measurement was taken.
> >
> > It can be used to calculate the PER indicator, by dividing DTV_STAT_ERROR_BLOCK_COUNT by DTV-STAT-TOTAL-BLOCKS-COUNT.
> >
> > Possible scales for this metric are:
> >
> >      FE_SCALE_NOT_AVAILABLE - it failed to measure it, or the measurement was not complete yet.
> >      FE_SCALE_COUNTER - Number of blocks counted while measuring DTV_STAT_ERROR_BLOCK_COUNT.
> >
> The rest in that section are OK.

Ok, thanks for your review!

I'll soon post patches 1 and 2 after those changes. The remaining 4 patches
don't likely need any change.

Regards,
Mauro
