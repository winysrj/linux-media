Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab3AQShd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 13:37:33 -0500
Date: Thu, 17 Jan 2013 16:36:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130117163649.519589f3@redhat.com>
In-Reply-To: <50F8333E.2020904@iki.fi>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
	<20130116200153.3ec3ee7d@redhat.com>
	<CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com>
	<50F7C57A.6090703@iki.fi>
	<CAHFNz9LRf0aYMR0nYCgtkatkjHgbCKJKovRaUsdQ1X=UmFEOLQ@mail.gmail.com>
	<50F8333E.2020904@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Jan 2013 19:22:06 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 01/17/2013 07:16 PM, Manu Abraham wrote:
> > On Thu, Jan 17, 2013 at 3:03 PM, Antti Palosaari <crope@iki.fi> wrote:
> >> On 01/17/2013 05:40 AM, Manu Abraham wrote:
> >>> MB86A20 is not the only demodulator driver with the Linux DVB.
> >>> And not all devices can output in dB scale proposed by you, But any device
> >>> output can be scaled in a relative way. So I don't see any reason why
> >>> userspace has to deal with cumbersome controls to deal with redundant
> >>> statistics, which is nonsense.
> >>
> >>
> >> What goes to these units in general, dB conversion is done by the driver
> >> about always. It is quite hard or even impossible to find out that formula
> >> unless you has adjustable test signal generator.
> >>
> >> Also we could not offer always dBm as signal strength. This comes to fact
> >> that only recent silicon RF-tuners are able to provide RF strength. More
> >> traditionally that estimation is done by demod from IF/RF AGC, which leads
> >> very, very, rough estimation.
> >
> > What I am saying is that, rather than sticking to a dB scale, it would be
> > better to fit it into a relative scale, ie loose dB altogether and use only the
> > relative scale. With that approach any device can be fit into that convention.
> > Even with an unknown device, it makes it pretty easy for anyone to fit
> > into that
> > scale. All you need is a few trial runs to get maxima/minima. When there
> > exists only a single convention that is simple, it makes it more easier for
> > people to stick to that convention, rather than for people to not support it.

As dB scale is never used for BER and UCB, I'm assuming that we're
talking about signal strength and S/N measures.

Get the maxima/minima for signal strength and S/N measures can be hard,
as it would require a signal generator and a noise generator that can
adjust the power levels for the signal and noise.

Also, if one has both, he/she can calibrate the scale to dB/dBm.

> That is true. I don't have really clear opinion whether to force all to 
> one scale, or return dBm those which could and that dummy scale for the 
> others. Maybe I will still vote for both relative and dBm.

>From the statistics you collected, most developers implemented dB scale,
especially with the new drivers. I also remember that most people mentioned
their preference to dB in the past.

> Shortly there is two possibilities:
> 1) support only relative scale

That doesn't solve, as a relative scale could still be logarithm or
linear. 

IMHO, a linear scale that doesn't much sense, as the effect 
of the signal power (or noise power) affects the quality
in a logarithm scale, but I'm pretty sure that some drivers 
report relative scales in a log scale, while others report
it with a linear scale.

> 2) support both dBm and relative scale (with dBm priority)

That seems to be the only choice if we want to improve from the current
status, e. g. explicitly saying what is the scale, when the developer
is able to discover it somehow (datasheets, empirical measurement,
reference drivers, etc).

Regards,
Mauro
