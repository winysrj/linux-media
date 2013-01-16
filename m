Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757245Ab3APWCh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jan 2013 17:02:37 -0500
Date: Wed, 16 Jan 2013 20:01:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Simon Farnsworth <simon.farnsworth@onelan.com>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
Message-ID: <20130116200153.3ec3ee7d@redhat.com>
In-Reply-To: <2817386.vHx2V41lNt@f17simon>
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com>
	<20130116152151.5461221c@redhat.com>
	<CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com>
	<2817386.vHx2V41lNt@f17simon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Jan 2013 19:29:28 +0000
Simon Farnsworth <simon.farnsworth@onelan.com> escreveu:

> On Wednesday 16 January 2013 23:56:48 Manu Abraham wrote:
> > On Wed, Jan 16, 2013 at 10:51 PM, Mauro Carvalho Chehab
> <snip>
> > >
> > > It is a common sense that the existing API is broken. If my proposal
> > > requires adjustments, please comment on each specific patchset, instead
> > > of filling this thread of destructive and useless complains.
> > 
> > 
> > No, the concept of such a generalization is broken, as each new device will
> > be different and trying to make more generalization is a waste of developer
> > time and effort. The simplest approach would be to do a coarse approach,
> > which is not a perfect world, but it will do some good results for all the
> > people who use Linux-DVB. Still, repeating myself we are not dealing with
> > high end professional devices. If we have such devices, then it makes sense
> > to start such a discussion. Anyway professional devices will need a lot of
> > other API extensions, so your arguments on the need for professional
> > devices that do not exist are pointless and not agreeable to.
> > 
> Let's step back a bit. As a sophisticated API user, I want to be able to give
> my end-users the following information:
> 
>  * Signal strength in dBm
>  * Signal quality as "poor", "OK" and "good".
>  * Ideally, "increase signal strength to improve things" or "attenuate signal
> to improve things"
> 
> In a DVBv3 world, "poor" equates to UNC != 0, "OK" is UNC == 0, BER != 0,
> and "good" is UNC == BER == 0. The idea is that a user seeing "poor" knows
> that they will see glitches in the output; a user seeing "OK" knows that
> there's no glitching right now, but that the setup is marginal and may
> struggle if anything changes, and a user seeing "good" knows that they've got
> high quality signal. 
> 
> VDR wants even simpler - it just wants strength and quality on a 0 to 100
> scale, where 100 is perfect, and 0 is nothing present.
> 
> In both cases, we want per-layer quality for ISDB-T, for the reasons you've
> already outlined.
> 
> So, how do you provide such information? Is it enough to simply provide
> strength in dBm, and quality as 0 to 100, where anything under 33 indicates
> uncorrected errors, and anything under 66 indicates that quality is marginal?

Unfortunately, not all devices can provide strength in dBm. 

On this RFC proposal, the driver will report if the device is providing
it either in dBm or on a 0% to 100% scale.

UNC, BER and S/N ratio (actually, C/N) measures are provided. Again, S/N
can either be in dB or on a 0% to 100% scale.

A high S/N ratio means low UNC/BER counts, so S/N is probably what VDR would
use for a quality indicator.

Assuming that is_isdb is true for ISDB, and that pid_layer is equal
to the ISDB layer for a given program (determined elsewhere in the
code), In order to get the QoS properties, I would code it like the 
following (untested) code:

...
       if (parms->version >= 0x510) {
               struct dtv_property dvb_prop[6];
               struct dtv_properties props;
               int j, layer;

               dvb_prop[0].cmd = DTV_QOS_SIGNAL_STRENGTH;
               dvb_prop[1].cmd = DTV_QOS_CNR;
               dvb_prop[2].cmd = DTV_QOS_BIT_ERROR_COUNT;
               dvb_prop[3].cmd = DTV_QOS_TOTAL_BITS_COUNT;
               dvb_prop[4].cmd = DTV_QOS_ERROR_BLOCK_COUNT;
               dvb_prop[5].cmd = DTV_QOS_TOTAL_BLOCKS_COUNT;

               props.num = 6;
               props.props = dvb_prop;

		if (is_isdb)
			layer = pid_layer;
		else
			layer = 0;

               /* Do a DVBv5.10 stats call */
               if (ioctl(parms->fd, FE_GET_PROPERTY, &props) == 0)
			display_statistics(dvb_prop, layer);
       } else
		/* DVBv3 fallback */
...

Where a display_statistics() that just shows every available measure
would be:

void display_statistics(struct dtv_property dvb_prop[6], unsigned layer)
{
	printf("Signal strength: ");
	if (dvb_prop[0].u.st.len && dvb_prop[0].u.st.stat[0].scale == FE_SCALE_DECIBEL)
		printf("%d dBm\n", (int)dvb_prop[0].u.st.stat[0].svalue);
	else if (dvb_prop[0].u.st.len && dvb_prop[0].u.st.stat[0].scale == FE_SCALE_DECIBEL)
		printf("%03.2f %\n", 100.*dvb_prop[0].u.st.stat[0].uvalue / 65535);
	} else {
		printf("not available\n");
	}

	printf("Carrier to Noise ratio: ");
	if (dvb_prop[1].u.st.len > layer && dvb_prop[1].u.st.stat[layer].scale == FE_SCALE_DECIBEL)
		printf("%d dB\n", (int)dvb_prop[1].u.st.stat[layer].svalue);
	else if (dvb_prop[1].u.st.len > layer&& dvb_prop[1].u.st.stat[layer].scale == FE_SCALE_DECIBEL)
		printf("%03.2f %\n", 100.*dvb_prop[1].u.st.stat[layer].uvalue / 65535);
	} else {
		printf("not available\n");
	}

	if (dvb_prop[2].u.st.len > layer && dvb_prop[2].u.st.stat[layer].scale == FE_SCALE_COUNTER &&
	    dvb_prop[3].u.st.len > layer && dvb_prop[3].u.st.stat[layer].scale == FE_SCALE_COUNTER) {
		float ber = ((float)dvb_prop[2].u.st.stat[layer].uvalue) / dvb_prop[3].u.st.stat[layer].uvalue;
		printf("BER = %e\n", ber);
	}

	if (dvb_prop[4].u.st.len > layer && dvb_prop[4].u.st.stat[layer].scale == FE_SCALE_COUNTER) {
		printf("UCB = %lld\n", dvb_prop[4].u.st.stat[layer].uvalue);
	}

	if (dvb_prop[4].u.st.len > layer && dvb_prop[4].u.st.stat[layer].scale == FE_SCALE_COUNTER &&
	    dvb_prop[5].u.st.len > layer && dvb_prop[5].u.st.stat[layer].scale == FE_SCALE_COUNTER) {
		float per = ((float)dvb_prop[4].u.st.stat[layer].uvalue) / dvb_prop[5].u.st.stat[layer].uvalue;
		printf("PER = %e\n", per);
	}
}

-

Btw, I just finished the implementation of S/N on mb86a20s:
	http://git.linuxtv.org/mchehab/experimental.git/commit/3640dcff0a6028dbf461f7f1e7b4ea0514eab20e

The only stats left on my TODO list on mb86a20s is UCB/PER measurement, as
I probably won't implement BER after Viterbi there.

-- 

Cheers,
Mauro
