Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab3APN4q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 08:56:46 -0500
Date: Wed, 16 Jan 2013 11:56:05 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130116115605.0fea6d03@redhat.com>
In-Reply-To: <CAHFNz9L9Lg-uttCVOk90UghM_WVbge44Ascxv4qrag3GvWetnQ@mail.gmail.com>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<50F522AD.8000109@iki.fi>
	<20130115111041.6b78a935@redhat.com>
	<50F56C63.7010503@iki.fi>
	<50F57519.5060402@iki.fi>
	<20130115151203.7221b1db@redhat.com>
	<50F5BE14.9000705@iki.fi>
	<CAHFNz9L9Lg-uttCVOk90UghM_WVbge44Ascxv4qrag3GvWetnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Jan 2013 09:56:12 +0530
Manu Abraham <abraham.manu@gmail.com> escreveu:

> On Wed, Jan 16, 2013 at 2:07 AM, Antti Palosaari <crope@iki.fi> wrote:
> > On 01/15/2013 07:12 PM, Mauro Carvalho Chehab wrote:
> >>
> >> Em Tue, 15 Jan 2013 17:26:17 +0200
> >> Antti Palosaari <crope@iki.fi> escreveu:
> >>
> >>> On 01/15/2013 04:49 PM, Antti Palosaari wrote:
> >>>>
> >>>> I am a little bit lazy to read all those patches, but I assume it is
> >>>> possible:
> >>>> * return SNR (CNR) as both dB and linear?
> >>>> * return signal strength as both dBm and linear?
> >>>>
> >>>> And what happens when when multiple statistics are queried, but fronted
> >>>> cannot perform all those?
> >>>>
> >>>> Lets say SS, SNR, BER, UCB are queried, but only SS and SNR are ready to
> >>>> be returned, whilst rest are not possible? As I remember DVBv5 API is
> >>>> broken by design and cannot return error code per request.
> >>>
> >>>
> >>> OK, I read that patch still. All these are OK as there is SCALE flag
> >>> used to inform if there is measurement or not available.
> >>> No anymore question about these.
> >>>
> >>> Issues what I still would like to raise now are:
> >>>
> >>> 1) How about change unit from dB/10 to dB/100 or even dB/1000, just for
> >>> the sure?
> >>
> >>
> >> I'm OK with that. I doubt that it would be practical, but we have 64
> >> bits for it, so db/1000 will fit.
> >>
> >>> 2) Counter are reset when DELIVERY SYSTEM is set, practically when
> >>> tuning attempt is done. There is new callback for that, but no API
> >>> command. Functionality is correct for my eyes, is that extra callback
> >>> needed?
> >>
> >>
> >> Not sure. It should be noticed that, at least on ISDB, some sort of
> >> reset may happen, for example if one layer disappears. The global BER
> >> will (with the current code) reflect the lack of the layer, by not summing
> >> up the data from the removed layer.
> >>
> >> Perhaps it makes more sense to, instead, add a way for the driver to flag
> >> when a counter reset happened.
> >>
> >>> 3) Post-BER. I don't need it, but is there someone else who thinks there
> >>> should be both pre-BER and post-BER? IMHO, just better to leave it out
> >>> to keep it simple. In practice both pre-BER and post-BER are running
> >>> relatively, lets say if pre-BER shows number 1000 then post-BER shows
> >>> only 10. Or pre-BER 600, post-BER 6. Due to that, I don't see much
> >>> interest to return it for userspace. Of course someone would like to
> >>> know how much inner coder is working and fixing error bits and in that
> >>> case both BERs are nice...
> >>
> >>
> >> I don't see any need for it. In the case of ISDB, I'll likely convert
> >> the post-BER error into per-layer CNR, as it might be useful for one.
> >>
> >> I don't have any strong opinion on that though.
> >>
> >>> 4) Returning bit counts as BER and UCB means also driver should start
> >>> polling work in order to keep driver internal counters up to date.
> >>> Returning BER as rate is cheaper in that mean, as driver could make
> >>> decision how often to poll and in which condition (and return values
> >>> from cache). Keeping track of total bit counts means continuous polling!
> >>
> >>
> >> The way it was specified, the bit count/block count is relative to the
> >> same period where bit error/block error count was taken, and are there
> >> to calculate BER and PER.
> >
> >
> > Eh, then this is functionality is against 2) what I asked about
> > functionality of the counter reset. You should make decision to increase
> > counters continuously and reset only given condition (on channel tune as it
> > is done now) OR leave whole counter reset and increase to responsibility of
> > the driver.
> >
> > Do you see conflict here???
> >
> > My opinion is to remove counter reset callback and leave all to
> > responsibility of the driver.
> 
> 
> This, Is exactly one of the arguments that I raised. All statistics
> measurements
> should be the responsibility of the driver. Anything other than that,
> such an API
> is broken.

All statistics measurements are already driver's responsibility on the 
proposed patches. The question is when to reset the counters.

> >> Not all frontends allow continuous measurement of BER and PER. In the
> >> case of mb86a20s, BER is currently not continuous. I think that there's
> >> a way to do continuous PER measurement, but I need to double-check
> >> it.
> >
> >
> > Personally I am going to implement that way it returns those bit counts from
> > the driver cache. Driver makes decision when to make measurements, like just
> > after channel is tuned and after that maybe once per minute or so.
> 
> 
> No Error Rate measurement, ie BER, PER or FER measurement can/will be
> continuous on *any* demodulator. 

There's one of the above measure on mb86a20s that can be continuous (MER). On
continuous mode, the demod will automatically start the next measure when the
results got available. There's a lock bit that prevents the data to be
overridden during the time the value is being read.

> First, there should be the minimum number of
> frames that should pass through the decision box, then for that number
> of frames
> to occur, depending upon the delivery system and the implementation type, the
> time required for this to be calculated on the demodulator FPGA will vary and
> cannot be expected that it will be available at this instance or at
> another instance.
> All demodulators vary from one to another the way it is implemented. On most
> demodulators, while trying to do computations within the decision box
> whil trying
> to acquire, or in some case while it has not acquired Synchronous Viterbi will
> result in acquisition failure, longer time for acquisition, or even sub-optimal
> acquisition etc, depending on a variety of factors. In short, only the
> algorithms
> used in a driver for the demodulator when it is safe to do measurements and no
> one else.
> 
> This API implementation assumes that someone else or the dvb-core or
> whomsoever does this role. Hence this QoS API is broken, not to forget
> that even
> while making it so complex to use, which should have been something so simple.

No, it seems you misread the code. The API doesn't make such assumption,
nor the implementation does.

If you take a look at the implementation, it just uses the get_frontend()
as a way to check if the already started measure already finished. If so,
it will update the cache and request a new data collect [1].

The simplified logic there is:

static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
					  unsigned layer,
					  u32 *error, u32 *count)
{
...
	/* Check if the BER measures are already available */
	rc = mb86a20s_readreg(state, 0x54);
	if (rc < 0)
		return rc;

	/*
	 * Check if data is available for that layer
	 * bit 0 means layer A, bit 1 means layer B, bit 2 means layer C
	 */
	if (!(rc & (1 << layer))) {
		dev_info(&state->i2c->dev,
			"%s: BER for layer %c is not available yet.\n",
			__func__, 'A' + layer);
		return -EBUSY;
	}
...
	/*
	 * Logic to read the BER registers for that layer and to
	 * start another measure
	 */
}

static int mb86a20s_get_stats(struct dvb_frontend *fe)
{
...
	/* Get per-layer stats */
	for (i = 0; i < 3; i++) {
		rc = mb86a20s_get_ber_before_vterbi(fe, i, &bit_error, &bit_count);
		if (rc >= 0) {
			/* Data is ready, update the cache */
		}
	}
...
}

The dvb-frontend thread is there to just:
	1) serialize the access to the cache;
	2) call the polling code that checks if the hardware already
calculated the measure.

[1] see: http://git.linuxtv.org/mchehab/experimental.git/blob/refs/heads/stats:/drivers/media/dvb-frontends/mb86a20s.c

> The simplest and easiest way to achieve commonality between the various
> demodulators is to use the existing API and scale whatever documented
> demodulators to that scacle, to best possible way, rather than adding more
> ambiguity and breakage.

This were largely discussed. The existing API is broken. Even adding a scale
there right now is impossible, as nobody knows what scale is used on several
old drivers. Also, the existing API doesn't support newer standards like ISDB.

> What is eventually wanted is a 0-100% scale, a self rotating counter etc scaled
> to a maxima minima, rather than adding in complexities. This already exists,
> all it needs to do is add some more devices to be scaled to that convention.
> And more importantly, one is not going to get that real professional
> measurements
>  from these *home segment* devices. One of the chipset manufacturers once told
> me that the PC segment never was interested in any real world performance
> oriented devices, it is all about cost and hence it is stuck with such
> low devices.

The DVB API should be able to fit on both home and professional segment.

Anyway, the existing API will be kept. Userspace may opt to use the legacy
API if they're not interested on a scaled value.

Regards,
Mauro
