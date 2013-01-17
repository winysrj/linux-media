Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584Ab3AQSvV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 13:51:21 -0500
Date: Thu, 17 Jan 2013 16:50:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130117165037.6ed80366@redhat.com>
In-Reply-To: <CAHFNz9JDqYnrmNDt0_nBJMgzAymZSCXBbwY5MHR8AkMopPPQOA@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Jan 2013 00:07:17 +0530
Manu Abraham <abraham.manu@gmail.com> escreveu:

> On Thu, Jan 17, 2013 at 11:57 PM, Antti Palosaari <crope@iki.fi> wrote:
> 
> >
> >
> > Resetting counters when user tunes channel sounds the only correct option.
> >
> 
> This might not be correct, especially when we have true Multiple Input Streams.
> The tune might be single, but the filter setup would be different. In
> which case it
> wouldn't correct to do a reset of the counters ona tune. Resetting the counters
> should be the responsibility of the driver.

I moved the counters reset to the driver's logic on v11. I'm posting the
patches in a few.

> As I said in an earlier
> post, anything
> other than the driver handling any statistical event monitoring, such an API is
> broken for sure, without even reading single line of code for that API for which
>  it is written for.

Yes, driver should have full control on it.

> > OK, maybe we will see in near future if that works well or not. I think that
> > for calculating of PER it is required to start continuous polling to keep up
> > total block counters. Maybe updating UCB counter continously needs that too,
> > so it should work.
> 
> 
> With multi-standard demodulators, some of them PER compute is a by-product
> of some internal demodulator algorithmic operation. In some cases, it might
> require a loop in the driver. As I said, again; It is very hard/wrong
> to do basic
> generalizations.

Agreed.

-- 

Cheers,
Mauro
