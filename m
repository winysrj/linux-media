Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab3AQTf6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 14:35:58 -0500
Date: Thu, 17 Jan 2013 17:35:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130117173515.72db398b@redhat.com>
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

Works for me.

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

Yes. 

For simple scale, n = 65535 should be, as most drivers that
use the simple scale use 0 to 65535 range. So, this range means
less driver changes.

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

> And if we end up returning "simple" values over dB values, then I think 
> driver could be simple and implement only dB and dvb-core is responsible 
> to convert dB => simple. That should quite be possible as we know which 
> dB value is good signal and which is bad signal.
> 
> 
> Are these requirements now in line what is spoken?

Yes.

Regards,
Mauro
