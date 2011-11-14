Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab1KNLr0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 06:47:26 -0500
Message-ID: <4EC0FFCA.6060006@redhat.com>
Date: Mon, 14 Nov 2011 09:47:22 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: BOUWSMA Barry <freebeer.bouwsma@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <alpine.DEB.2.01.1111111759060.6676@localhost.localdomain> <4EBD6B61.7020605@redhat.com> <CAHFNz9JSk+TeptBZ8F9SEiyaa8q5OO8qwBiBxR9KEsOT8o_J-w@mail.gmail.com> <4EBFC6F3.50404@redhat.com> <CAHFNz9+Gia40gQkW_VtRrwpawqhLDzwL5Qf_AGW4zQSJ3yj1Yg@mail.gmail.com>
In-Reply-To: <CAHFNz9+Gia40gQkW_VtRrwpawqhLDzwL5Qf_AGW4zQSJ3yj1Yg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-11-2011 13:27, Manu Abraham escreveu:
> On Sun, Nov 13, 2011 at 7:02 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 11-11-2011 20:34, Manu Abraham escreveu:
>>> On Sat, Nov 12, 2011 at 12:07 AM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com> wrote:
>>>> Em 11-11-2011 15:43, BOUWSMA Barry escreveu:
>>>>>
>>>>> On Do (Donnerstag) 10.Nov (November) 2011, 22:20,  Mauro Carvalho Chehab wrote:
>>>>>
>>>>>> We should also think on a way to enumerate the supported values for each DVB $
>>>>>> the enum fe_caps is not enough anymore to store everything. It currently has $
>>>>>> filled (of a total of 32 bits), and we currently have:
>>>>>>      12 code rates (including AUTO/NONE);
>>>>>
>>>>> I'm probably not looking at the correct source, but the numbers
>>>>> seem to match, so I'll just note that in what I'm looking at,
>>>>> there are missing the values  1/3  and  2/5 .
>>>>
>>>> Those were not added yet, as no driver currently uses it.
>>>>
>>>>>
>>>>> But I have to apologise in that I've also not been paying
>>>>> attention to this conversation, and haven't even been trying
>>>>> to follow recent developments.
>>>>>
>>>>>
>>>>>>      13 modulation types;
>>>>>
>>>>> Here I see missing  QAM1024  and  QAM4096 .
>>>>
>>>> Same here.
>>>>
>>>>>
>>>>>
>>>>>>      7 transmission modes;
>>>>>>      7 bandwidths;
>>>>>
>>>>> Apparently DVB-C2 allows us any bandwidth from 8MHz to 450MHz,
>>>>> rather than the discrete values used by the other systems.
>>>>> If this is also applicable to other countries with 6MHz rasters,
>>>>> would it be necessary in addition to specify carrier spacing,
>>>>> either 2,232kHz or 1,674kHz as opposed to getting this from the
>>>>> channel bandwidth?
>>>>
>>>> There are 3 parameters for Satellite and Cable systems:
>>>>        - Roll off factor;
>>>>        - Symbol Rate;
>>>>        - Bandwidth.
>>>>
>>>> Only two of the tree are independent, as the spec defines:
>>>>        Bandwidth = symbol rate * (1  + roll off).
>>>>
>>>> For DVB-C Annex A and C, roll off is fixed (0.15 and 0.13, respectively).
>>>>
>>>> ITU-T J 83 Annex B doesn't say anything about it, but the ANSI SCTE07 spec
>>>> says that the roll-off is approx. 0.18 for 256-QAM and approx. 0.12 for
>>>> 256-QAM.
>>>>
>>>> DVB-S also has a fixed roll-off of 0.35, while DVB-S2 allows configuring it.
>>>
>>>
>>> DVB-S uses 3 different rolloffs just like DVB-S2. In fact the rolloff
>>> doesn't have anything to do with the delivery system at all, but
>>> something that which is independant and physical to the channel,
>>> rather than something logical such as a delivery system, looking at a
>>> satellite transponder's viewpoint.
>>>
>>> For general (home) broadcast purposes, we use only 0.35. There are
>>> many other usages, which is not yet applicable with especially Linux
>>> DVB with regards to narrow band operations such as DVB feeds and DSNG.
>>
>> Ok.
>>
>>>
>>> There are many usages for the second generation delivery systems,
>>> which will likely realize only a very small part.
>>>
>>> Eg: there are other aspects to DVB-S2 such as ACM and VCM, which most
>>> likely we wouldn't cover. the reason is that the users of it are most
>>> likely propreitary users of it and neither would they prefer to have
>>> an open source version for it, nor would any Open Source users be
>>> likely to implement it. Eg: Ericson's Director CA system, where they
>>> have complete control over the box, rather than the user. As far as I
>>> am aware they have a return path as well.
>>>
>>>>
>>>> Not 100% sure, but ISDB-S also seems to use a per-modulation roll-off factor.
>>>>
>>>> Anyway, when the roll-off is known, only symbol rate is needed, in order
>>>> to know the needed bandwidth.
>>>
>>>
>>> You need to know FEC, modulation too .. Eg: If you have 16APSK where
>>> you have 4 bits, in comparison to 3 bits as with 8PSK, then you
>>> require lesser bandwidth.
>>
>> Manu, you're probably thinking in terms of the TS bit rate, and not the
>> modulator symbol rate.
>>
>> The number of bits don't matter here, as the symbol rate is specified
>> in bauds (e. g. symbols per second), and not in bits/s.
> 
> 
> A PSK modulator is a state machine:
> where states/symbols are logically represented by bits, given that the
> state can either be a 0 or 1
> 
> BPSK  states=2    bits=1
> QPSK  states=4    bits=2
> 8PSK  states=8     bits=3
> 16PSK states=16  bits=4
> 32PSK states=32  bits=5
> 
> http://en.wikipedia.org/wiki/Constellation_diagram
> http://en.wikipedia.org/wiki/Gray_code
> 
> Symbol Rate is generally specified in SPS, ie Symbols/sec, or in
> Bauds. AFAICS, We generally use Symbols Per Second rather than bauds.
> 
> http://www.asiasat.com/asiasat/contentView.php?section=69&lang=0
> http://www.b4utv.com/subs/technology.shtml
> http://www.skynewsinternational.com/watch/satellite-information
> 
> I haven't seen a demodulator specification which states Mbaud, but
> have seen them stated as MSPS or kSPS.
> 
> Now, assuming a 36MHz TP as an example: The given bandwidth is better
> or efficiently used by a higher order modulation. This is the reason
> why DVB.org states that DVB-S2 saves 30% bandwidth.
> 
> Quoting you: "Anyway, when the roll-off is known, only symbol rate is
> needed, in order to know the needed bandwidth."
> 
> Given a fixed TP CHBW, according to you: Channel Bandwidth can be
> calculated by knowing Symbol Rate alone, with a known rolloff.
> 
> I say that this is not possible. Since the number of states/symbols
> for any given channel depends on the modulation order as well.
> 
> I hope that clears up things for you.
> 
> 
>> The conversion from bauds to bits/s is to multiply the number of bits per
>> symbol by the rate, in bauds.
>>
>> A higher number of bits for a given modulation just increase the number of
>> possible states that the modulation will use. So, it will require a higher
>> signal to noise relation at the demod, to avoid miss-detection, but this is
>> a separate issue.
> 
> 
> That's why for higher order modulations, demodulators use better Error
> Correction Schemes (eg: BCH/Turbo) when the modulation order is
> higher.
> 
> http://en.wikipedia.org/wiki/Modulation_order
> http://en.wikipedia.org/wiki/BCH_code
> 
> 
>> The roll-off, minimal bandwidth (referred as "Nyquist frequency" by the DVB-C
>> specs) and symbol rate are related by this equation:
>>        f = symbol_rate * (1 + roll_off)
>>
>> The f value is the Nyquist frequency, and it will dictate the low-pass filter
>> needed to confine the entire signal of the channel (with is, basically, the
>> amount of bandwidth required by the channel).
>>
>>> Also, higher the Error correction information bits set in (redundant),
>>> the more bandwidth it needs to occupy.
>>
>> The error correction algorithm will reduce the bit rate of the TS stream,
>> but won't affect the symbol rate at the modulator.
> 
> 
> No. That's an incorrect statement. FEC gives the receiver the ability
> to correct errors without needing a reverse channel to request
> retransmission of data, but at the cost of a fixed, higher forward
> channel bandwidth.
> 
> http://en.wikipedia.org/wiki/Forward_error_correction

Manu,

A good reference for working with those stuff is the Symon Haykin book:
	http://www.amazon.com/Communication-Systems-4th-Simon-Haykin/dp/0471178691

I used it a lot during the time I was studying Electrical Engineering it at University,
and during my post-graduation.

There are two ways of engineering with those parameters: 

1) giving that you need an effective bit rate of X, calculate the amount of bandwidth
that it is needed. If you go into this direction, FEC will require more bandwidth. This
is what you're saying. This is the direction used generally by engineers that aren't
limited by a previous bandwidth constraints (like the ones that work with satellite).

2) Work at the reverse way: giving that you have a limited bandwidh of Y, estimate the
effective bit rate that will be available on that channel.

This is the direction where the designers of standards like DVB-C and DVB-T took, as 
they needed to start with a channel with a bandwidth limited by the analog standard.

Assuming that an specific channel allows amount of symbols per second X (btw, Baud is just
an alias for symbols per second), there is a frequency greater than X from where the
entropy of the channel will be zero. Due to the Nyquist theorem, sampling at twice that
frequency is enough to completely recover the original signal, in the absence of noise.

All DVB specs define such frequency via a roll-off factor, as:

	H(freq) = 0 for freq > symbol_rate * (1 + roll_off)

So, the bandwidth is limited by symbol_rate * (1 + roll_off).

This equation is at ITU-T J.83 Annex A.7. The same equation is at on chapter 9 of the 
EN 300 429 v1.2.1 (page 16).

EN 300 429 Annex B estimates the channel bandwidth for a 8 MHz and roll-off factor 0.15
as about 6.96 MBaud.

With the above expression, we can get the same result:
	max_symbol_rate = Bw / (1 + roll_off)
	max_symbol_rate = 8000000 / (1 + 0.15)
	max_symbol_rate = 6956521

It should be noticed that the SNR of the channel and the modulation efficiency may require
using a lower channel rate for the channel. Annex B of EN 300 429 (informative only)
gives some examples on the effective maximum symbol rates for real systems.

For example, instead of using 8 MHz, it uses a guard interval, reducing the occupied bandwidth
to 7.92 MHz for 64-QAM, 7.96 for 32-QAM, and so on.

So, for a 64-QAM, at Annex B examples, using a 7.92 MHz with 0.15 rolloff, the max symbol
rate is 6,886,956 MBaud (7920000 / (1 + .15). as it uses 6 bits/symbol, total bitrate is
41,321,736 (6 * 6,886,956). Unfortunately, the annex B examples don't tell what FEC were used,
but the efficiency of the channel were 38.1/41.34 = 92 %. E. g. 8% of the total bit rate
were wasted by the error correction algorithm, meaning that such channel can transport
streams up to 38.1 Mbits/s.

Regards,
Mauro






