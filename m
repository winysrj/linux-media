Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab1KMNcj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 08:32:39 -0500
Message-ID: <4EBFC6F3.50404@redhat.com>
Date: Sun, 13 Nov 2011 11:32:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: BOUWSMA Barry <freebeer.bouwsma@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: PATCH: Query DVB frontend capabilities
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <4EBBE336.8050501@linuxtv.org> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <alpine.DEB.2.01.1111111759060.6676@localhost.localdomain> <4EBD6B61.7020605@redhat.com> <CAHFNz9JSk+TeptBZ8F9SEiyaa8q5OO8qwBiBxR9KEsOT8o_J-w@mail.gmail.com>
In-Reply-To: <CAHFNz9JSk+TeptBZ8F9SEiyaa8q5OO8qwBiBxR9KEsOT8o_J-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-11-2011 20:34, Manu Abraham escreveu:
> On Sat, Nov 12, 2011 at 12:07 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 11-11-2011 15:43, BOUWSMA Barry escreveu:
>>>
>>> On Do (Donnerstag) 10.Nov (November) 2011, 22:20,  Mauro Carvalho Chehab wrote:
>>>
>>>> We should also think on a way to enumerate the supported values for each DVB $
>>>> the enum fe_caps is not enough anymore to store everything. It currently has $
>>>> filled (of a total of 32 bits), and we currently have:
>>>>      12 code rates (including AUTO/NONE);
>>>
>>> I'm probably not looking at the correct source, but the numbers
>>> seem to match, so I'll just note that in what I'm looking at,
>>> there are missing the values  1/3  and  2/5 .
>>
>> Those were not added yet, as no driver currently uses it.
>>
>>>
>>> But I have to apologise in that I've also not been paying
>>> attention to this conversation, and haven't even been trying
>>> to follow recent developments.
>>>
>>>
>>>>      13 modulation types;
>>>
>>> Here I see missing  QAM1024  and  QAM4096 .
>>
>> Same here.
>>
>>>
>>>
>>>>      7 transmission modes;
>>>>      7 bandwidths;
>>>
>>> Apparently DVB-C2 allows us any bandwidth from 8MHz to 450MHz,
>>> rather than the discrete values used by the other systems.
>>> If this is also applicable to other countries with 6MHz rasters,
>>> would it be necessary in addition to specify carrier spacing,
>>> either 2,232kHz or 1,674kHz as opposed to getting this from the
>>> channel bandwidth?
>>
>> There are 3 parameters for Satellite and Cable systems:
>>        - Roll off factor;
>>        - Symbol Rate;
>>        - Bandwidth.
>>
>> Only two of the tree are independent, as the spec defines:
>>        Bandwidth = symbol rate * (1  + roll off).
>>
>> For DVB-C Annex A and C, roll off is fixed (0.15 and 0.13, respectively).
>>
>> ITU-T J 83 Annex B doesn't say anything about it, but the ANSI SCTE07 spec
>> says that the roll-off is approx. 0.18 for 256-QAM and approx. 0.12 for
>> 256-QAM.
>>
>> DVB-S also has a fixed roll-off of 0.35, while DVB-S2 allows configuring it.
> 
> 
> DVB-S uses 3 different rolloffs just like DVB-S2. In fact the rolloff
> doesn't have anything to do with the delivery system at all, but
> something that which is independant and physical to the channel,
> rather than something logical such as a delivery system, looking at a
> satellite transponder's viewpoint.
> 
> For general (home) broadcast purposes, we use only 0.35. There are
> many other usages, which is not yet applicable with especially Linux
> DVB with regards to narrow band operations such as DVB feeds and DSNG.

Ok.

> 
> There are many usages for the second generation delivery systems,
> which will likely realize only a very small part.
> 
> Eg: there are other aspects to DVB-S2 such as ACM and VCM, which most
> likely we wouldn't cover. the reason is that the users of it are most
> likely propreitary users of it and neither would they prefer to have
> an open source version for it, nor would any Open Source users be
> likely to implement it. Eg: Ericson's Director CA system, where they
> have complete control over the box, rather than the user. As far as I
> am aware they have a return path as well.
> 
>>
>> Not 100% sure, but ISDB-S also seems to use a per-modulation roll-off factor.
>>
>> Anyway, when the roll-off is known, only symbol rate is needed, in order
>> to know the needed bandwidth.
> 
> 
> You need to know FEC, modulation too .. Eg: If you have 16APSK where
> you have 4 bits, in comparison to 3 bits as with 8PSK, then you
> require lesser bandwidth.

Manu, you're probably thinking in terms of the TS bit rate, and not the
modulator symbol rate.

The number of bits don't matter here, as the symbol rate is specified
in bauds (e. g. symbols per second), and not in bits/s.

The conversion from bauds to bits/s is to multiply the number of bits per
symbol by the rate, in bauds.

A higher number of bits for a given modulation just increase the number of 
possible states that the modulation will use. So, it will require a higher
signal to noise relation at the demod, to avoid miss-detection, but this is
a separate issue.

The roll-off, minimal bandwidth (referred as "Nyquist frequency" by the DVB-C
specs) and symbol rate are related by this equation:
	f = symbol_rate * (1 + roll_off)

The f value is the Nyquist frequency, and it will dictate the low-pass filter
needed to confine the entire signal of the channel (with is, basically, the
amount of bandwidth required by the channel).

> Also, higher the Error correction information bits set in (redundant),
> the more bandwidth it needs to occupy.

The error correction algorithm will reduce the bit rate of the TS stream,
but won't affect the symbol rate at the modulator.

> This is the same with any
> Digital Channel whether it be Satellite/Cable/Terrestrial, whatever
> delivery system it is.

Yes.

> 
> Regards,
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

