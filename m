Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294Ab3ACWTg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jan 2013 17:19:36 -0500
Date: Thu, 3 Jan 2013 20:18:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>,
	linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [PATCH RFCv3] dvb: Add DVBv5 properties for
 quality parameters
Message-ID: <20130103201854.33563e23@redhat.com>
In-Reply-To: <50E5F93D.1000302@iki.fi>
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com>
	<CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com>
	<20130101130041.52dee65f@redhat.com>
	<CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com>
	<20130101152932.3873d4cc@redhat.com>
	<CAHFNz9LzBX0G9G0G_6C+WHooaQ1ridG1pkCcOPyzPG+FgOZKxw@mail.gmail.com>
	<20130103112044.4267b274@redhat.com>
	<50E5A142.2090807@tvdr.de>
	<20130103141429.03766540@redhat.com>
	<20130103142959.3d838015@redhat.com>
	<50E5F93D.1000302@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Jan 2013 23:33:49 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 01/03/2013 06:29 PM, Mauro Carvalho Chehab wrote:
> > Em Thu, 3 Jan 2013 14:14:29 -0200
> > Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> >
> >> Em Thu, 03 Jan 2013 16:18:26 +0100
> >> Klaus Schmidinger <Klaus.Schmidinger@tvdr.de> escreveu:
> >>
> >>> On 03.01.2013 14:20, Mauro Carvalho Chehab wrote:
> >>>> Em Wed, 2 Jan 2013 00:38:50 +0530
> >>>> Manu Abraham <abraham.manu@gmail.com> escreveu:
> >>>>
> >>>>> On Tue, Jan 1, 2013 at 10:59 PM, Mauro Carvalho Chehab
> >>>>> <mchehab@redhat.com> wrote:
> >>>>>> Em Tue, 1 Jan 2013 22:18:49 +0530
> >>>>>> Manu Abraham <abraham.manu@gmail.com> escreveu:
> >>>>>>
> >>>>>>> On Tue, Jan 1, 2013 at 8:30 PM, Mauro Carvalho Chehab
> >>>>>>> <mchehab@redhat.com> wrote:
> >>>>>>>
> >>>>>>>> [RFCv4] dvb: Add DVBv5 properties for quality parameters
> >>>>>>>>
> >>>>>>>> The DVBv3 quality parameters are limited on several ways:
> >>>>>>>>           - Doesn't provide any way to indicate the used measure;
> >>>>>>>>           - Userspace need to guess how to calculate the measure;
> >>>>>>>>           - Only a limited set of stats are supported;
> >>>>>>>>           - Doesn't provide QoS measure for the OFDM TPS/TMCC
> >>>>>>>>             carriers, used to detect the network parameters for
> >>>>>>>>             DVB-T/ISDB-T;
> >>>>>>>>           - Can't be called in a way to require them to be filled
> >>>>>>>>             all at once (atomic reads from the hardware), with may
> >>>>>>>>             cause troubles on interpreting them on userspace;
> >>>>>>>>           - On some OFDM delivery systems, the carriers can be
> >>>>>>>>             independently modulated, having different properties.
> >>>>>>>>             Currently, there's no way to report per-layer stats;
> >>>>>>>
> >>>>>>> per layer stats is a mythical bird, nothing of that sort does exist.
> >>>>>>
> >>>>>> Had you ever read or tried to get stats from an ISDB-T demod? If you
> >>>>>> had, you would see that it only provides per-layer stats. Btw, this is
> >>>>>> a requirement to follow the ARIB and ABNT ISDB specs.
> >>>>>
> >>>>> I understand you keep writing junk for ages, but nevertheless:
> >>>>>
> >>>>> Do you have any idea what's a BBHEADER (DVB-S2) or
> >>>>> PLHEADER (DVB-T2) ? The headers do indicate what MODCOD
> >>>>> (aka Modulation/Coding Standard follows, whatever mode ACM,
> >>>>> VCM or CCM) follows. These MODCOD foolows a TDM approach
> >>>>> with a hierarchial modulation principle. This is exactly what ISDB
> >>>>> does too.
> >>>>
> >>>> No, I didn't check DVB-S2/T2 specs deeply enough to understand
> >>>> if they're doing the same thing as ISDB.
> >>>>
> >>>> Yet, ISDB-T doesn't use a TDM approach for hierarchical modulation.
> >>>> It uses a FDM (OFDM is a type of Frequency Division Multiplexing).
> >>>>
> >>>> So, if you're saying that DVB-S2 uses TDM, it is very different than
> >>>> ISDB-T. As DVB-T2 uses an FDM type of modulation (OFDM), it would
> >>>> be possible to segment the carriers there, just like ISDB, or to
> >>>> use TDM hierarchical modulation techniques.
> >>>>
> >>>>>
> >>>>> And for your info:
> >>>>>
> >>>>> " The TMCC control information is
> >>>>> common to all TMCC carriers and
> >>>>> error correction is performed by using
> >>>>> difference-set cyclic code."
> >>>>
> >>>> Yes, TMCC carriers are equal and they are always modulated using DBPSK.
> >>>> That is done to make it possible to receive the TMCC carriers even under
> >>>> worse SNR conditions, where it may not be possible to decode the segment
> >>>> groups.
> >>>>
> >>>> It seems that you completely missed the point though. On ISDB-T, the
> >>>> carriers that belong to each group of segments (except for the control
> >>>> carriers - carriers 1 to 107) uses a completely independent modulation.
> >>>> Also, as they're spaced in frequency, the interference of each segment
> >>>> is different. So, error indications are different on each segment.
> >>>>
> >>>> Btw, in any case, the datasheets of ISDB-T demods clearly shows that
> >>>> the BER measures are per segment group (layer).
> >>>>
> >>>> For example, for the BER measures before Viterbi, those are the register
> >>>> names for a certain demod:
> >>>>
> >>>> 	VBERSNUMA Bit count of BER measurement before Viterbi in A layer
> >>>> 	VBERSNUMB Bit count of BER measurement before Viterbi in B layer
> >>>> 	VBERSNUMC Bit count of BER measurement before Viterbi in C layer
> >>>>
> >>>> It has another set of registers for BER after Viterbi, and for PER after
> >>>> Viterbi and RS, for bit count errors, etc.
> >>>>
> >>>> There's no way to get any type of "global" BER measure, simply because
> >>>> ISDB-T demods don't provide.
> >>>
> >>> Maybe we should put all this theoretical discussion aside for the moment and
> >>> think about what is *really* needed by real world applications. As with any
> >>> receiver, VDR simply wants to have some measure of the signal's "strength"
> >>> and "quality". These are just two values that should be delivered by each
> >>> frontend/demux, using the *same* defined and mandatory range. I don't care
> >>> what exactly that is, but it needs to be the same for all devices.
> >>> What values a particular driver uses internally to come up with these
> >>> is of no interest to VDR. The "signal strength" might just be what is
> >>> currently returned through FE_READ_SIGNAL_STRENGTH (however, normalized to
> >>> the same range in all drivers, which currently is not the case). The "signal
> >>> quality" might use flags like FE_HAS_SIGNAL, FE_HAS_CARRIER, FE_HAS_VITERBI,
> >>> FE_HAS_SYNC, as well as SNR, BER and UNC (if available) to form some
> >>> value where 0 means no quality at all, and 0xFFFF means excellent quality.
> >>> If a particular frontend/demux uses totally different concepts, it can
> >>> just use whatever it deems reasonable to form the "strength" and "quality"
> >>> values. The important thing here is just that all this needs to be hidden
> >>> inside the driver, and the only interface to an application are ioctl()
> >>> calls that return these two values.
> >>>
> >>> So I suggest that you define this minimal interface and allow applications
> >>> to retrieve what they really need. Once this is done, feel free to implement
> >>> whatever theoretical bells and whistles you fell like doing - that's all
> >>> fine with me, as long as the really important stuff keeps working ;-)
> >>
> >> Klaus,
> >>
> >> On ISDB-T, it splits the TS into (up to) three independent physical channels
> >> (called layers).
> >>
> >> Each channel has its own statistics, as they're completely independent:
> >> they use different inner FEC's, use different modulations, etc.
> >>
> >> The ISDB demods don't provide a single value for the 3 layers. They
> >> can't, as they're independent. So, signal-strengh and SNR measures are
> >> also independent for each of those 3 layers.
> >>
> >> A typical ISDB transmission uses 13 segments of carriers, each segment
> >> using a 4.28 kHz bandwidth, grouped into 3 layers. While it is up to
> >> the broadcaster to decide how to group the segments, it is typically
> >> arranged like that:
> >>
> >> 	layer A - 1 segment for LD programs - modulated using QPSK;
> >> 	layer B - 3 segments for SD programs - modulated using 16QAM;
> >> 	layer C - 9 segments for HD programs - modulated using 64QAM.
> >>
> >> The TDM TS packets from the Transport Stream are broken into those 3
> >> layers, each being an independent transmission channel.
> >>
> >> So, all channel level QoS measure are per-layer (SNR, signal strength,
> >> BER, MER, ...).
> >>
> >> While the demods I have datasheets here don't provide it, it would be
> >> possible to provide error counts for a given program ID, by summing
> >> the error count that applies to each PID.
> >>
> >> So, let's assume, for example, that the UCB count is:
> >> 	layer A = 0
> >> 	layer B = 12
> >> 	layer C = 30
> >>
> >> an 1-seg LD program will have 0 uncorrected blocks;
> >> an SD program will have 12 uncorrected error blocks;
> >> a HD program will have 42 uncorrected error blocks.
> >>
> >> It shouldn't be that hard to take it into account on userspace, but
> >> doing it at kernel level would be very painful, if possible, as
> >> kernelspace would be required to know what PID's are being shown, in
> >> order to estimate the error count measures for them. Also, it would
> >> require a much more complex kernelspace-userspace interface.
> >
> > Two additional notes:
> >
> > 1) If you want to get further information, it is available on ARIB
> > 	STD-B31 spec:
> >
> > 	http://www.arib.or.jp/english/html/overview/doc/6-STD-B31v1_6-E2.pdf
> >
> > There, table 3-2 shows the main characteristics of the modulation;
> > how the 3 independent channels are handled and fig. 3.4
> > shows a simplified diagram to give an idea on how the hierarchical TS
> > packets are broken into the 3 layers
> >
> > 2) There are in the market some narrow-band decoders. Those tunes only
> > 1 segment (440kHz), and are meant to be used on mobile devices that can
> > receive only LD programs. Only for those devices, it is possible to
> > offer a single set of statistics (SNR, strength, BER, UCB, etc),
> > because it can decode just one layer. I have a few of them here,
> > and we have 2 drivers for those 1-seg devices (s921 and siano).
> > The full-seg drivers currently provide crappy information or don't
> > provide any QoS stats at all due to the lack of a proper API.
> >
> > Regards,
> > Mauro
> 
> What I propose is quite near what Klaus wants. Just only new simple ways 
> to report current statistics with beforehand scale/values.
> 
> 1) Signal Strength
> * linear scale 0-0xffff
> 
> 2) Quality SNR
> * SNR in resolution 0.1dB
> 
> 3) Quality BER
> * ~like currently (no exact units)
> * measured from inner coding
> 
> 4) Quality UCB
> * ~like currently (no exact units)
> * measured from outer coding (naturally)
> * counter is increased over lifetime
> * tune resets counter?
> * driver is responsible of polling statistic in background and report 
> from cache

I still think that the better is to provide exact units where available.
Userspace can easily discard whatever scale it is, provided that they're
properly specified (including their typical range). Developers should only
implement the specific range when they're sure about that (e. g.
reverse-engineered drivers will be relative - even for SNR - devices based
on the datasheets can provide real values).

> I would not like to define exact units for BER and USB as those are 
> quite hard to implement and also non-sense. User would like just to see 
> if there is some (random) numbers and if those numbers are rising or 
> reducing when he changes antenna or adjusts gain. We are not making a 
> professional signal analyzers - numbers does not need to be 100% correctly.

No, but this API can be used by them or by STB's. So, it should have a way
to be used by professional applications.

> ISDB-T statistics are forced also to that simple API. Calculating 
> average value for example. Statistic differences between layers are so 
> minor that users does not even care to know.

There's no simple way to merge those values, especially for the error
counters, as it will depend on what program is being displayed. 

With regards to signal strength and SNR, Segment 0 information
(the central one) is probably the best shot.

What we can do is to estimate "global" value and put it at data[0] information
for GET_PROPERTIES. This way, simple applications can just use that info.

So, what we can do for ISDB-T "global" QoS measure is:

	- Strength and SNR: report the segment 0 value for the "global"
			    indicator;
	- BER, UCB: to sum up the error count of all active segments. This
	  is a worse case scenario, and the more likely one, as people tend
	  to watch to the HD program, when available (of course, if the
	  display hardware has enough resources to decode 1080p).

Keep reporting a per-layer stats. We do have enough space at the data
payload for that.

This way simple applications can just get the first value and don't care
if the standard is ISDB-T.

More sophisticated applications can get all data, and automatically switch
to a lower resolution stream if the QoS is not good enough for HD but
reliable enough for LD.

> 
> And as there is some persons who surely like to do QoS API like need of 
> $10k professional equipment, I propose to add more accurate reports as 
> alternative BUT that minimalist API should be offered even professional 
> API exits.

If you agree with this combined proposal, I can write a new patchset.

Regards,
Mauro
