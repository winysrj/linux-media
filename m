Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:53112 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3AQShS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 13:37:18 -0500
Received: by mail-ob0-f173.google.com with SMTP id xn12so2831487obc.4
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 10:37:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50F84276.3080909@iki.fi>
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
Date: Fri, 18 Jan 2013 00:07:17 +0530
Message-ID: <CAHFNz9JDqYnrmNDt0_nBJMgzAymZSCXBbwY5MHR8AkMopPPQOA@mail.gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
From: Manu Abraham <abraham.manu@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 17, 2013 at 11:57 PM, Antti Palosaari <crope@iki.fi> wrote:

>
>
> Resetting counters when user tunes channel sounds the only correct option.
>

This might not be correct, especially when we have true Multiple Input Streams.
The tune might be single, but the filter setup would be different. In
which case it
wouldn't correct to do a reset of the counters ona tune. Resetting the counters
should be the responsibility of the driver. As I said in an earlier
post, anything
other than the driver handling any statistical event monitoring, such an API is
broken for sure, without even reading single line of code for that API for which
 it is written for.


> OK, maybe we will see in near future if that works well or not. I think that
> for calculating of PER it is required to start continuous polling to keep up
> total block counters. Maybe updating UCB counter continously needs that too,
> so it should work.


With multi-standard demodulators, some of them PER compute is a by-product
of some internal demodulator algorithmic operation. In some cases, it might
require a loop in the driver. As I said, again; It is very hard/wrong
to do basic
generalizations.

Manu
