Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379Ab1KNSIU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 13:08:20 -0500
Message-ID: <4EC1590E.8040302@redhat.com>
Date: Mon, 14 Nov 2011 16:08:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <alpine.DEB.2.01.1111111759060.6676@localhost.localdomain> <4EBD6B61.7020605@redhat.com> <CAHFNz9JSk+TeptBZ8F9SEiyaa8q5OO8qwBiBxR9KEsOT8o_J-w@mail.gmail.com> <4EBFC6F3.50404@redhat.com> <CAHFNz9+Gia40gQkW_VtRrwpawqhLDzwL5Qf_AGW4zQSJ3yj1Yg@mail.gmail.com> <4EC0FFCA.6060006@redhat.com> <CAHFNz9KRGwcPwfndg322Fso_i=zuArJDijoP2evLjJuaOFviDA@mail.gmail.com> <4EC1445C.4030503@redhat.com> <CAHFNz9JLmqVO-ViK_22vrcpSN3sz82dKtwo6yepgUooHZ5qn9A@mail.gmail.com>
In-Reply-To: <CAHFNz9JLmqVO-ViK_22vrcpSN3sz82dKtwo6yepgUooHZ5qn9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-11-2011 15:09, Manu Abraham escreveu:
> On Mon, Nov 14, 2011 at 10:09 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 14-11-2011 13:02, Manu Abraham escreveu:
>>> On Mon, Nov 14, 2011 at 5:17 PM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com> wrote:
>>>> Em 13-11-2011 13:27, Manu Abraham escreveu:
>>>>> On Sun, Nov 13, 2011 at 7:02 PM, Mauro Carvalho Chehab
>>>>> <mchehab@redhat.com> wrote:
>>>>>> Em 11-11-2011 20:34, Manu Abraham escreveu:
>>>>>>> On Sat, Nov 12, 2011 at 12:07 AM, Mauro Carvalho Chehab
>>>>>>> <mchehab@redhat.com> wrote:
>>>>>>>> Em 11-11-2011 15:43, BOUWSMA Barry escreveu:
>>>>>>>>>
>>>>>>>>> On Do (Donnerstag) 10.Nov (November) 2011, 22:20,  Mauro Carvalho Chehab wrote:
>>>>>>>>>
>>>>>>>>>> We should also think on a way to enumerate the supported values for each DVB $
>>>>>>>>>> the enum fe_caps is not enough anymore to store everything. It currently has $
>>>>>>>>>> filled (of a total of 32 bits), and we currently have:
>>>>>>>>>>      12 code rates (including AUTO/NONE);
>>>>>>>>>
>>>>>>>>> I'm probably not looking at the correct source, but the numbers
>>>>>>>>> seem to match, so I'll just note that in what I'm looking at,
>>>>>>>>> there are missing the values  1/3  and  2/5 .
>>>>>>>>
>>>>>>>> Those were not added yet, as no driver currently uses it.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> But I have to apologise in that I've also not been paying
>>>>>>>>> attention to this conversation, and haven't even been trying
>>>>>>>>> to follow recent developments.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>>      13 modulation types;
>>>>>>>>>
>>>>>>>>> Here I see missing  QAM1024  and  QAM4096 .
>>>>>>>>
>>>>>>>> Same here.
>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>>      7 transmission modes;
>>>>>>>>>>      7 bandwidths;
>>>>>>>>>
>>>>>>>>> Apparently DVB-C2 allows us any bandwidth from 8MHz to 450MHz,
>>>>>>>>> rather than the discrete values used by the other systems.
>>>>>>>>> If this is also applicable to other countries with 6MHz rasters,
>>>>>>>>> would it be necessary in addition to specify carrier spacing,
>>>>>>>>> either 2,232kHz or 1,674kHz as opposed to getting this from the
>>>>>>>>> channel bandwidth?
>>>>>>>>
>>>>>>>> There are 3 parameters for Satellite and Cable systems:
>>>>>>>>        - Roll off factor;
>>>>>>>>        - Symbol Rate;
>>>>>>>>        - Bandwidth.
>>>>>>>>
>>>>>>>> Only two of the tree are independent, as the spec defines:
>>>>>>>>        Bandwidth = symbol rate * (1  + roll off).
>>>>>>>>
>>>>>>>> For DVB-C Annex A and C, roll off is fixed (0.15 and 0.13, respectively).
>>>>>>>>
>>>>>>>> ITU-T J 83 Annex B doesn't say anything about it, but the ANSI SCTE07 spec
>>>>>>>> says that the roll-off is approx. 0.18 for 256-QAM and approx. 0.12 for
>>>>>>>> 256-QAM.
>>>>>>>>
>>>>>>>> DVB-S also has a fixed roll-off of 0.35, while DVB-S2 allows configuring it.
>>>>>>>
>>>>>>>
>>>>>>> DVB-S uses 3 different rolloffs just like DVB-S2. In fact the rolloff
>>>>>>> doesn't have anything to do with the delivery system at all, but
>>>>>>> something that which is independant and physical to the channel,
>>>>>>> rather than something logical such as a delivery system, looking at a
>>>>>>> satellite transponder's viewpoint.
>>>>>>>
>>>>>>> For general (home) broadcast purposes, we use only 0.35. There are
>>>>>>> many other usages, which is not yet applicable with especially Linux
>>>>>>> DVB with regards to narrow band operations such as DVB feeds and DSNG.
>>>>>>
>>>>>> Ok.
>>>>>>
>>>>>>>
>>>>>>> There are many usages for the second generation delivery systems,
>>>>>>> which will likely realize only a very small part.
>>>>>>>
>>>>>>> Eg: there are other aspects to DVB-S2 such as ACM and VCM, which most
>>>>>>> likely we wouldn't cover. the reason is that the users of it are most
>>>>>>> likely propreitary users of it and neither would they prefer to have
>>>>>>> an open source version for it, nor would any Open Source users be
>>>>>>> likely to implement it. Eg: Ericson's Director CA system, where they
>>>>>>> have complete control over the box, rather than the user. As far as I
>>>>>>> am aware they have a return path as well.
>>>>>>>
>>>>>>>>
>>>>>>>> Not 100% sure, but ISDB-S also seems to use a per-modulation roll-off factor.
>>>>>>>>
>>>>>>>> Anyway, when the roll-off is known, only symbol rate is needed, in order
>>>>>>>> to know the needed bandwidth.
>>>>>>>
>>>>>>>
>>>>>>> You need to know FEC, modulation too .. Eg: If you have 16APSK where
>>>>>>> you have 4 bits, in comparison to 3 bits as with 8PSK, then you
>>>>>>> require lesser bandwidth.
>>>>>>
>>>>>> Manu, you're probably thinking in terms of the TS bit rate, and not the
>>>>>> modulator symbol rate.
>>>>>>
>>>>>> The number of bits don't matter here, as the symbol rate is specified
>>>>>> in bauds (e. g. symbols per second), and not in bits/s.
>>>>>
>>>>>
>>>>> A PSK modulator is a state machine:
>>>>> where states/symbols are logically represented by bits, given that the
>>>>> state can either be a 0 or 1
>>>>>
>>>>> BPSK  states=2    bits=1
>>>>> QPSK  states=4    bits=2
>>>>> 8PSK  states=8     bits=3
>>>>> 16PSK states=16  bits=4
>>>>> 32PSK states=32  bits=5
>>>>>
>>>>> http://en.wikipedia.org/wiki/Constellation_diagram
>>>>> http://en.wikipedia.org/wiki/Gray_code
>>>>>
>>>>> Symbol Rate is generally specified in SPS, ie Symbols/sec, or in
>>>>> Bauds. AFAICS, We generally use Symbols Per Second rather than bauds.
>>>>>
>>>>> http://www.asiasat.com/asiasat/contentView.php?section=69&lang=0
>>>>> http://www.b4utv.com/subs/technology.shtml
>>>>> http://www.skynewsinternational.com/watch/satellite-information
>>>>>
>>>>> I haven't seen a demodulator specification which states Mbaud, but
>>>>> have seen them stated as MSPS or kSPS.
>>>>>
>>>>> Now, assuming a 36MHz TP as an example: The given bandwidth is better
>>>>> or efficiently used by a higher order modulation. This is the reason
>>>>> why DVB.org states that DVB-S2 saves 30% bandwidth.
>>>>>
>>>>> Quoting you: "Anyway, when the roll-off is known, only symbol rate is
>>>>> needed, in order to know the needed bandwidth."
>>>>>
>>>>> Given a fixed TP CHBW, according to you: Channel Bandwidth can be
>>>>> calculated by knowing Symbol Rate alone, with a known rolloff.
>>>>>
>>>>> I say that this is not possible. Since the number of states/symbols
>>>>> for any given channel depends on the modulation order as well.
>>>>>
>>>>> I hope that clears up things for you.
>>>>>
>>>>>
>>>>>> The conversion from bauds to bits/s is to multiply the number of bits per
>>>>>> symbol by the rate, in bauds.
>>>>>>
>>>>>> A higher number of bits for a given modulation just increase the number of
>>>>>> possible states that the modulation will use. So, it will require a higher
>>>>>> signal to noise relation at the demod, to avoid miss-detection, but this is
>>>>>> a separate issue.
>>>>>
>>>>>
>>>>> That's why for higher order modulations, demodulators use better Error
>>>>> Correction Schemes (eg: BCH/Turbo) when the modulation order is
>>>>> higher.
>>>>>
>>>>> http://en.wikipedia.org/wiki/Modulation_order
>>>>> http://en.wikipedia.org/wiki/BCH_code
>>>>>
>>>>>
>>>>>> The roll-off, minimal bandwidth (referred as "Nyquist frequency" by the DVB-C
>>>>>> specs) and symbol rate are related by this equation:
>>>>>>        f = symbol_rate * (1 + roll_off)
>>>>>>
>>>>>> The f value is the Nyquist frequency, and it will dictate the low-pass filter
>>>>>> needed to confine the entire signal of the channel (with is, basically, the
>>>>>> amount of bandwidth required by the channel).
>>>>>>
>>>>>>> Also, higher the Error correction information bits set in (redundant),
>>>>>>> the more bandwidth it needs to occupy.
>>>>>>
>>>>>> The error correction algorithm will reduce the bit rate of the TS stream,
>>>>>> but won't affect the symbol rate at the modulator.
>>>>>
>>>>>
>>>>> No. That's an incorrect statement. FEC gives the receiver the ability
>>>>> to correct errors without needing a reverse channel to request
>>>>> retransmission of data, but at the cost of a fixed, higher forward
>>>>> channel bandwidth.
>>>>>
>>>>> http://en.wikipedia.org/wiki/Forward_error_correction
>>>>
>>>> Manu,
>>>>
>>>> A good reference for working with those stuff is the Symon Haykin book:
>>>>        http://www.amazon.com/Communication-Systems-4th-Simon-Haykin/dp/0471178691
>>>>
>>>> I used it a lot during the time I was studying Electrical Engineering it at University,
>>>> and during my post-graduation.
>>>
>>>
>>> Mauro,
>>>
>>> Well, if the discussion is about know the person whom you are talking
>>> to: I did my Engineering degree in Electronics and Communication;
>>> Simon and Haykin was just one among them in one of the semesters. I
>>> still have those college books somewhere in an old dusty shelf. Later
>>> on, I worked at the (Remote Sensing and CVAI labs) Indian Institute of
>>> Sciences, Bangalore. Further down the lane, did work with media
>>> broadcast organizations.
>>>
>>> I am not going to get into an argument session, where you keep on
>>> changing the topic, with unrelated or incorrect stuff altogether.
>>
>> I'm not changing topic. All I'm saying since the beginning is that
>> there's no need to add Bandwidth at the DVB API for cable/satellite, as,
>> for the supported delivery systems, the symbol rate + roll-off can be used
>> for bandwidth estimation, where needed,
> 
> What you stated:
> 
> "Anyway, when the roll-off is known, only symbol rate is needed, in
> order to know the needed bandwidth."
> 
> What I stated:
> 
> "the number of states/symbols for any given channel depends on the
> modulation order as well."

Sure. I never said otherwise.

> When you don't know the modulation, you don't know how many bits are
> packed into a given Digital channel. It is that simple. 

Yes.

> rolloff
> provides you only the slope (or 3dB cutoff) of the channel.

It specifies the slope, but the roll-off is not 3dB cutoff. 

 EN 300 429 v1.2.1 page 17 picture is very clear[1]:

The Nyquist frequency Fn is defined in terms of the -3dB cutoff, but (1 + roll-off) Fn is
defined with a -43dB cut off.

So, in the DVB-C case, where the roll-off is 0.15, we have, from Page 16 equation:
	H(f) = 0 for |f| > 1.15 Fn

[1] http://www.etsi.org/deliver/etsi_en/300400_300499/300429/01.02.01_60/en_300429v010201p.pdf

> Eg: A TP having a b/w of 36 MHz can contain more symbols with a higher
> order modulation.

Sure. The higher order, the bigger is the number of bits at the constellation
diagram.

Yet, a QPSK and a QAM-64 using the same bandwidth will send data
at the same symbols/sec rate. 

So, let's say that such rate is 1 Msymbol/sec (or 1 Mbaud).

A QPSK modulation (without FEC, on a perfect channel, no noise, etc), will
send 2 bits per symbol, so it will send data at 2 Mbps or 1 Mbaud.

A QAM-64 modulation (at the same conditions) will send 6 bits per symbol,
so it will send data at 64 Mbps or 1Mbaud [1].

[2] http://en.wikipedia.org/wiki/Baud#Relationship_to_gross_bit_rate

See? It seems that you're thinking in terms of bits per second, and not
symbols per second.

> (Bandwidth allocated to a media broadcaster, is fixed in terms of MHz
> alone. A media broadcaster, let's say "X", purchases a transponder
> with a fixed bandwidth of "Y" for "Z" thousand USD)
> 
> ie, bw = f(m) + f(sr)

Ok, if you have two sub-carriers, you need to sum the bandwidth
required for each, in order to estimate the total amount of bandwidth
for the transponder. As the modulation on each is independent, each
modulation may have a different roll-off factor.

Yet, this doesn't require any changes at DVB API, as all that the demodulator
need to know is the sub-carrier parameters (frequency, roll-off, symbol
rate, etc).

> Generally, the concept with a fixed modulation, it is bw = f(sr)
> alone. But this is not the case, when we are dealing with multiple
> modulations on the same device. I hope by now, you understand where
> you are going wrong.

Regards,
Mauro
