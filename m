Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab3APRWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 12:22:33 -0500
Date: Wed, 16 Jan 2013 15:21:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130116152151.5461221c@redhat.com>
In-Reply-To: <CAHFNz9KniYSbfoDHOw+=x3aA0eWqpiQd9LxgQEt3fjm1RwUc7g@mail.gmail.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<50F522AD.8000109@iki.fi>
	<20130115111041.6b78a935@redhat.com>
	<50F56C63.7010503@iki.fi>
	<50F57519.5060402@iki.fi>
	<20130115151203.7221b1db@redhat.com>
	<50F5BE14.9000705@iki.fi>
	<CAHFNz9L9Lg-uttCVOk90UghM_WVbge44Ascxv4qrag3GvWetnQ@mail.gmail.com>
	<20130116115605.0fea6d03@redhat.com>
	<CAHFNz9KniYSbfoDHOw+=x3aA0eWqpiQd9LxgQEt3fjm1RwUc7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Jan 2013 20:49:05 +0530
Manu Abraham <abraham.manu@gmail.com> escreveu:

> On Wed, Jan 16, 2013 at 7:26 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Em Wed, 16 Jan 2013 09:56:12 +0530
> > Manu Abraham <abraham.manu@gmail.com> escreveu:
> >
> >> On Wed, Jan 16, 2013 at 2:07 AM, Antti Palosaari <crope@iki.fi> wrote:
> >> > On 01/15/2013 07:12 PM, Mauro Carvalho Chehab wrote:
> >> >>
> >> >> Em Tue, 15 Jan 2013 17:26:17 +0200
> >> >> Antti Palosaari <crope@iki.fi> escreveu:
> >> >>
> >> >>> On 01/15/2013 04:49 PM, Antti Palosaari wrote:
> >> >>>>

...

> >> No Error Rate measurement, ie BER, PER or FER measurement can/will be
> >> continuous on *any* demodulator.
> >
> > There's one of the above measure on mb86a20s that can be continuous (MER). On
> > continuous mode, the demod will automatically start the next measure when the
> > results got available. There's a lock bit that prevents the data to be
> > overridden during the time the value is being read.
> 
> 
> Please stop your bluffing of people.
> MER or Modulation Error Ratio is the Ratio between the RMS Signal Power to the
> RMS Error Power. When you state that *any* Home segment device which
> is supposed
> to be a cheap device doing demodulation, Error Correction and a
> plethora of other things:
> is doing real time RMS computations and generating ratios out of it,
> It makes me laugh.

Huh, can't you read my English? I never said *any* Home segment device.

I said, instead, that, on *mb86a20s*, for some measurements, like MER and CNR,
there are two operational modes: automatic and manual. 

On automatic mode, the demod is continuously updating the measurements,
and no data is discarded on such measures.

In manual mode, it measures just a certain amount of time and stops.
The kthread needs to manually start another measure. So, it is actually
taken samples of the measurement.

In manual mode, the measures are discrete in the sense that, if errors 
occur between outside the measurement intervals, those errors won't affect
the measurement report.

In the automatic mode, the measures are continuous in the sense that every
error bit will affect the measurement.

Yet, on both modes, the demod will wait for a given bit count (the
bit count is programmable) to update the corresponding I2C registers.

> 
> Now, that lock bit in that demodulator of yours expresses most likely
> what it is doing,
> It is most likely taking a snapshot of the parameters, doing
> computations and outputting
> the values to some shadowed registers.

Yes. I never said otherwise.

> As others have stated in various threads, please stop giving excuses
> to cause breaking
> stuff.

On my tests with the hardware, I can't see anything broken.

However, if you're seeing something broken, please point to the specific patch
and patch hunk.

> The old API is not dependent on any DVB standard, but it is purely a measure.

It is, as it assumes that there's just one physical channel per transponder.
ISDB doesn't fit on such concept, as it has 3 physical channels, each with
its own CNR, BER, etc.

As shown on the fist email of this series, measured with a real hardware,
the BER before viterbi on a given signal condition was:

Layer A BER:
	QOS_BIT_ERROR_COUNT[1] = 236
	QOS_TOTAL_BITS_COUNT[1] = 917490

Layer B BER:
	QOS_BIT_ERROR_COUNT[2] = 1087629
	QOS_TOTAL_BITS_COUNT[2] = 66125823

Clearly, the statistics for layer A is very different than the ones for
Layer B. With the above stats, layer B (12-segment) is unusable, as BER is just
too high.  However, Layer A (1-segment) is usable.

There are two programs being transmitted on the above ISDB-T channel. The
1-seg one works, as FEC 1/2 will likely fix most (or all) of the 236 errors there;
the 12-seg one doesn't, because of the low S/N ratio of layer B physical channel,
and the BER is just too high for FEC 7/8 to correct.

> If you have sufficient documentation, you can scale your demodulator statistics
> to fit in that window area. I had done something similarly with a MB86A16
> demodulator. IIRC, some effort was done on the STV0900 and STV0903
> demodulator support as well to fit into that convention.
> 
> All you need to do is scale the output of your demodulator to fit into
> that window.

To what scale? dB? linear? 0% to 100%?

As there's no way to tell what's the used scale, if some scale is required,
_all_ demods are required to be converted to that scale, otherwise, userspace
can't rely on the scale.

Are you capable of doing such change on _all demods? If not, please stop 
arguing that the existing API can be fixable.

Besides that, changing the existing stats to whatever scale breaks
userspace compatibility.

BREAKING USERSPACE IS A BIG NO.

> What you are stating are just excuses, that do not exist.
> 
> The same issue will exist, even with a new API and newer drivers not complying
> to that API. I don't understand, why you fail to accept that fact.

Newer drivers that don't implement an API right (being the a new one or an
existing one) need to be fixed before being merged. 

It is as simple as that.

> >> What is eventually wanted is a 0-100% scale, a self rotating counter etc scaled
> >> to a maxima minima, rather than adding in complexities. This already exists,
> >> all it needs to do is add some more devices to be scaled to that convention.
> >> And more importantly, one is not going to get that real professional
> >> measurements
> >>  from these *home segment* devices. One of the chipset manufacturers once told
> >> me that the PC segment never was interested in any real world performance
> >> oriented devices, it is all about cost and hence it is stuck with such
> >> low devices.
> >
> > The DVB API should be able to fit on both home and professional segment.
> 
> 
> I don't see any professional hardware drivers being written for the
> Linux DVB API.

>From the feedbacks we're getting during the media mini-summits, 
there are vendors that seem to be working on it. Anyway, what I'm saying
is that the API should not be bound to any specific market segment.

If drivers will be submitted upstream for professional hardware or not
is a separate issue.

...
> >
> > Anyway, the existing API will be kept. Userspace may opt to use the legacy
> > API if they're not interested on a scaled value.
> 
> 
> That is simply stating, that whatever other people like it or not, you
> will whack
> nonsense in.

No. I'm simply stating that removing the existing API is not an option.

Also, plese stop with fallacy: it is not me saying that the existing API
is broken. I'm just the poor guy that is trying to fix the already known
issue. Several users, userspace developers and kernelspace developers
complain about the existing stats API. Even _you_ submitted a proposal
years ago for a new stats API to try solving those issues.

It is a common sense that the existing API is broken. If my proposal
requires adjustments, please comment on each specific patchset, instead
of filling this thread of destructive and useless complains.

-- 

Cheers,
Mauro
