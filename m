Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59385 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab3AFRnu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 12:43:50 -0500
Message-ID: <50E9B7AF.5080905@iki.fi>
Date: Sun, 06 Jan 2013 19:43:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>,
	linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [PATCH RFCv3] dvb: Add DVBv5 properties for
 quality parameters
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com> <CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com> <20130101130041.52dee65f@redhat.com> <CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com> <20130101152932.3873d4cc@redhat.com> <CAHFNz9LzBX0G9G0G_6C+WHooaQ1ridG1pkCcOPyzPG+FgOZKxw@mail.gmail.com> <20130103112044.4267b274@redhat.com> <50E5A142.2090807@tvdr.de> <20130103141429.03766540@redhat.com> <20130103142959.3d838015@redhat.com> <50E5F93D.1000302@iki.fi> <20130106150304.780e0289@redhat.com>
In-Reply-To: <20130106150304.780e0289@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/06/2013 07:03 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 03 Jan 2013 23:33:49 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 01/03/2013 06:29 PM, Mauro Carvalho Chehab wrote:
>>> Em Thu, 3 Jan 2013 14:14:29 -0200
>>> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
>>>
>>>> Em Thu, 03 Jan 2013 16:18:26 +0100
>>>> Klaus Schmidinger <Klaus.Schmidinger@tvdr.de> escreveu:
>>>>
>>>>> On 03.01.2013 14:20, Mauro Carvalho Chehab wrote:
>>>>>> Em Wed, 2 Jan 2013 00:38:50 +0530
>>>>>> Manu Abraham <abraham.manu@gmail.com> escreveu:
>>>>>>
>>>>>>> On Tue, Jan 1, 2013 at 10:59 PM, Mauro Carvalho Chehab
>>>>>>> <mchehab@redhat.com> wrote:
>>>>>>>> Em Tue, 1 Jan 2013 22:18:49 +0530
>>>>>>>> Manu Abraham <abraham.manu@gmail.com> escreveu:
>>>>>>>>
>>>>>>>>> On Tue, Jan 1, 2013 at 8:30 PM, Mauro Carvalho Chehab
>>>>>>>>> <mchehab@redhat.com> wrote:
>>>>>>>>>
>>>>>>>>>> [RFCv4] dvb: Add DVBv5 properties for quality parameters
>>>>>>>>>>
>>>>>>>>>> The DVBv3 quality parameters are limited on several ways:
>>>>>>>>>>            - Doesn't provide any way to indicate the used measure;
>>>>>>>>>>            - Userspace need to guess how to calculate the measure;
>>>>>>>>>>            - Only a limited set of stats are supported;
>>>>>>>>>>            - Doesn't provide QoS measure for the OFDM TPS/TMCC
>>>>>>>>>>              carriers, used to detect the network parameters for
>>>>>>>>>>              DVB-T/ISDB-T;
>>>>>>>>>>            - Can't be called in a way to require them to be filled
>>>>>>>>>>              all at once (atomic reads from the hardware), with may
>>>>>>>>>>              cause troubles on interpreting them on userspace;
>>>>>>>>>>            - On some OFDM delivery systems, the carriers can be
>>>>>>>>>>              independently modulated, having different properties.
>>>>>>>>>>              Currently, there's no way to report per-layer stats;
>>>>>>>>>
>>>>>>>>> per layer stats is a mythical bird, nothing of that sort does exist.
>>>>>>>>
>>>>>>>> Had you ever read or tried to get stats from an ISDB-T demod? If you
>>>>>>>> had, you would see that it only provides per-layer stats. Btw, this is
>>>>>>>> a requirement to follow the ARIB and ABNT ISDB specs.
>>>>>>>
>>>>>>> I understand you keep writing junk for ages, but nevertheless:
>>>>>>>
>>>>>>> Do you have any idea what's a BBHEADER (DVB-S2) or
>>>>>>> PLHEADER (DVB-T2) ? The headers do indicate what MODCOD
>>>>>>> (aka Modulation/Coding Standard follows, whatever mode ACM,
>>>>>>> VCM or CCM) follows. These MODCOD foolows a TDM approach
>>>>>>> with a hierarchial modulation principle. This is exactly what ISDB
>>>>>>> does too.
>>>>>>
>>>>>> No, I didn't check DVB-S2/T2 specs deeply enough to understand
>>>>>> if they're doing the same thing as ISDB.
>>>>>>
>>>>>> Yet, ISDB-T doesn't use a TDM approach for hierarchical modulation.
>>>>>> It uses a FDM (OFDM is a type of Frequency Division Multiplexing).
>>>>>>
>>>>>> So, if you're saying that DVB-S2 uses TDM, it is very different than
>>>>>> ISDB-T. As DVB-T2 uses an FDM type of modulation (OFDM), it would
>>>>>> be possible to segment the carriers there, just like ISDB, or to
>>>>>> use TDM hierarchical modulation techniques.
>>>>>>
>>>>>>>
>>>>>>> And for your info:
>>>>>>>
>>>>>>> " The TMCC control information is
>>>>>>> common to all TMCC carriers and
>>>>>>> error correction is performed by using
>>>>>>> difference-set cyclic code."
>>>>>>
>>>>>> Yes, TMCC carriers are equal and they are always modulated using DBPSK.
>>>>>> That is done to make it possible to receive the TMCC carriers even under
>>>>>> worse SNR conditions, where it may not be possible to decode the segment
>>>>>> groups.
>>>>>>
>>>>>> It seems that you completely missed the point though. On ISDB-T, the
>>>>>> carriers that belong to each group of segments (except for the control
>>>>>> carriers - carriers 1 to 107) uses a completely independent modulation.
>>>>>> Also, as they're spaced in frequency, the interference of each segment
>>>>>> is different. So, error indications are different on each segment.
>>>>>>
>>>>>> Btw, in any case, the datasheets of ISDB-T demods clearly shows that
>>>>>> the BER measures are per segment group (layer).
>>>>>>
>>>>>> For example, for the BER measures before Viterbi, those are the register
>>>>>> names for a certain demod:
>>>>>>
>>>>>> 	VBERSNUMA Bit count of BER measurement before Viterbi in A layer
>>>>>> 	VBERSNUMB Bit count of BER measurement before Viterbi in B layer
>>>>>> 	VBERSNUMC Bit count of BER measurement before Viterbi in C layer
>>>>>>
>>>>>> It has another set of registers for BER after Viterbi, and for PER after
>>>>>> Viterbi and RS, for bit count errors, etc.
>>>>>>
>>>>>> There's no way to get any type of "global" BER measure, simply because
>>>>>> ISDB-T demods don't provide.
>>>>>
>>>>> Maybe we should put all this theoretical discussion aside for the moment and
>>>>> think about what is *really* needed by real world applications. As with any
>>>>> receiver, VDR simply wants to have some measure of the signal's "strength"
>>>>> and "quality". These are just two values that should be delivered by each
>>>>> frontend/demux, using the *same* defined and mandatory range. I don't care
>>>>> what exactly that is, but it needs to be the same for all devices.
>>>>> What values a particular driver uses internally to come up with these
>>>>> is of no interest to VDR. The "signal strength" might just be what is
>>>>> currently returned through FE_READ_SIGNAL_STRENGTH (however, normalized to
>>>>> the same range in all drivers, which currently is not the case). The "signal
>>>>> quality" might use flags like FE_HAS_SIGNAL, FE_HAS_CARRIER, FE_HAS_VITERBI,
>>>>> FE_HAS_SYNC, as well as SNR, BER and UNC (if available) to form some
>>>>> value where 0 means no quality at all, and 0xFFFF means excellent quality.
>>>>> If a particular frontend/demux uses totally different concepts, it can
>>>>> just use whatever it deems reasonable to form the "strength" and "quality"
>>>>> values. The important thing here is just that all this needs to be hidden
>>>>> inside the driver, and the only interface to an application are ioctl()
>>>>> calls that return these two values.
>>>>>
>>>>> So I suggest that you define this minimal interface and allow applications
>>>>> to retrieve what they really need. Once this is done, feel free to implement
>>>>> whatever theoretical bells and whistles you fell like doing - that's all
>>>>> fine with me, as long as the really important stuff keeps working ;-)
>>>>
>>>> Klaus,
>>>>
>>>> On ISDB-T, it splits the TS into (up to) three independent physical channels
>>>> (called layers).
>>>>
>>>> Each channel has its own statistics, as they're completely independent:
>>>> they use different inner FEC's, use different modulations, etc.
>>>>
>>>> The ISDB demods don't provide a single value for the 3 layers. They
>>>> can't, as they're independent. So, signal-strengh and SNR measures are
>>>> also independent for each of those 3 layers.
>>>>
>>>> A typical ISDB transmission uses 13 segments of carriers, each segment
>>>> using a 4.28 kHz bandwidth, grouped into 3 layers. While it is up to
>>>> the broadcaster to decide how to group the segments, it is typically
>>>> arranged like that:
>>>>
>>>> 	layer A - 1 segment for LD programs - modulated using QPSK;
>>>> 	layer B - 3 segments for SD programs - modulated using 16QAM;
>>>> 	layer C - 9 segments for HD programs - modulated using 64QAM.
>>>>
>>>> The TDM TS packets from the Transport Stream are broken into those 3
>>>> layers, each being an independent transmission channel.
>>>>
>>>> So, all channel level QoS measure are per-layer (SNR, signal strength,
>>>> BER, MER, ...).
>>>>
>>>> While the demods I have datasheets here don't provide it, it would be
>>>> possible to provide error counts for a given program ID, by summing
>>>> the error count that applies to each PID.
>>>>
>>>> So, let's assume, for example, that the UCB count is:
>>>> 	layer A = 0
>>>> 	layer B = 12
>>>> 	layer C = 30
>>>>
>>>> an 1-seg LD program will have 0 uncorrected blocks;
>>>> an SD program will have 12 uncorrected error blocks;
>>>> a HD program will have 42 uncorrected error blocks.
>>>>
>>>> It shouldn't be that hard to take it into account on userspace, but
>>>> doing it at kernel level would be very painful, if possible, as
>>>> kernelspace would be required to know what PID's are being shown, in
>>>> order to estimate the error count measures for them. Also, it would
>>>> require a much more complex kernelspace-userspace interface.
>>>
>>> Two additional notes:
>>>
>>> 1) If you want to get further information, it is available on ARIB
>>> 	STD-B31 spec:
>>>
>>> 	http://www.arib.or.jp/english/html/overview/doc/6-STD-B31v1_6-E2.pdf
>>>
>>> There, table 3-2 shows the main characteristics of the modulation;
>>> how the 3 independent channels are handled and fig. 3.4
>>> shows a simplified diagram to give an idea on how the hierarchical TS
>>> packets are broken into the 3 layers
>>>
>>> 2) There are in the market some narrow-band decoders. Those tunes only
>>> 1 segment (440kHz), and are meant to be used on mobile devices that can
>>> receive only LD programs. Only for those devices, it is possible to
>>> offer a single set of statistics (SNR, strength, BER, UCB, etc),
>>> because it can decode just one layer. I have a few of them here,
>>> and we have 2 drivers for those 1-seg devices (s921 and siano).
>>> The full-seg drivers currently provide crappy information or don't
>>> provide any QoS stats at all due to the lack of a proper API.
>>>
>>> Regards,
>>> Mauro
>>
>> What I propose is quite near what Klaus wants. Just only new simple ways
>> to report current statistics with beforehand scale/values.
>
> Ok, just added a new RFC. I tried to put there everything discussed on both
> ML and on IRC:
> 	http://patchwork.linuxtv.org/patch/16145/
>
> It is also available on my experimental tree, at branch "stats":
> 	git://linuxtv.org/mchehab/experimental.git stats
>
> I didn't start coding yet. After we agree with that, I'll write a v7 with
> both DVB core changes and one driver implementation.
>
> Regards,
> Mauro.
>
> PS.: I'm enclosing the main documentation chapter of the specs, in order
> to help with discussions, as it is better do comment on a plain-text
> email, than to reply to an XML file. If you want to see it in HTML, just
> pull it from my tree, run "make htmldocs" and see it on your favorite
> browser, like:
> 	firefox file:///home/mchehab/stats/Documentation/DocBook/media_api/FE_GET_SET_PROPERTY.html
>
>
> ---
>
>
> - Frontend Quality of Service/Statistics indicators
>
>
> Except for DTV_QOS_ENUM, the values are returned via dtv_property.stat.
>
> For most delivery systems, this will return a single value for each parameter.
>
> It should be noticed, however, that new OFDM delivery systems like ISDB can use different modulation types for each group of carriers. On such standards, up to 8 groups of statistics can be provided, one for each carrier group (called "layer" on ISDB). In order to be consistent with other delivery systems, the first value at dtv_property.stat.dtv_stats array refers to a global indicator, if any. The other elements of the array represent each layer, starting from layer A(index 1), layer B (index 2) and so on

Typo, it is up to 3 groups currently. However, I could guess DVB-T is 
also able to provide similar statistics but only max two layers (in 
hierarchical mode). I didn't check that from the specs yet, but I will do.


> The number of filled elements are stored at dtv_property.stat.len.
>
> Each element of the dtv_property.stat.dtv_stats array consists on two elements:
>
>      value - Value of the measure
>
>      scale - Scale for the value. It can be:
>
>          FE_SCALE_NOT_AVAILABLE - If it is not possible to collect a given parameter (could be a transitory or permanent condition)
>
>          FE_SCALE_DECIBEL - parameter is a signed value, measured in 0.1 dB
>
>          FE_SCALE_RELATIVE - parameter is a unsigned value, where 0 means 0% and 65535 means 100%.

I am not a big fan of that kind of unit complexity, but I can live with 
it. It is easy to be lazy and return some random register values without 
converting...


> - DTV_QOS_ENUM
>
> A frontend needs to advertise the statistics it provides. This property allows to enumerate all DTV QoS statistics that are supported by a given frontend.
>
> dtv_property.len indicates the number of supported DTV QoS statistics.
>
> dtv_property.data16 is an 16 bits array of the supported properties.
>
> - DTV_QOS_TUNER_SIGNAL
>
> Indicates the signal strength level at the analog part of the tuner.

how about just SIGNAL_STRENGTH

> - DTV_QOS_CNR
>
> Indicates the signal to noise relation for the main carrier.
>
> - DTV_QOS_BIT_ERROR_COUNT
>
> Measures the number of bit errors since the last counter reset.
>
> In order to get the bit error rate, it should be divided by DTV_QOS_BIT_ERROR_COUNT_TIME, if available. Otherwise, it should be divided by the time lapsed since the previous call for DTV_QOS_BIT_ERROR_COUNT.
>
> - DTV_QOS_BIT_ERROR_COUNT_TIME
>
> measures the time since the last DTV_QOS_BIT_ERROR_COUNT reset.
>
> It might not be available on certain frontends, even when DTV_QOS_BIT_ERROR_COUNT is provided, due to the lack of frontend's documentation when the driver was developed.

I dind't like at all. IMHO it is driver job to calculate BER. Reporting 
BER as [BER = error_bits / total_bits] at the time is quite standard manner.

How you thought application calculates total bit stream needed to 
calculate BER? I think it is very hard.

Also, I would like to document that BER is measured from the inner 
coding and it is pre BER rather than post BER (because it is nice to see 
signal errors just before correction, after the inner coding numbers are 
quite small or even 0 all the time).


> - DTV_QOS_ERROR_BLOCK_COUNT
>
> Measures the number of block errors since the last counter reset.
>
> In order to get the bit error rate, it should be divided by DTV_QOS_ERROR_BLOCK_COUNT_TIME, if available. Otherwise, it should be divided by the time lapsed since the previous call for DTV_QOS_ERROR_BLOCK_COUNT.
>
> - DTV_QOS_ERROR_BLOCK_COUNT_TIME
>
> measures the time since the last DTV_QOS_ERROR_BLOCK_COUNT reset.
>
> It might not be available on certain frontends, even when DTV_QOS_BIT_ERROR_BLOCK_COUNT is provided, due to the lack of frontend's documentation when the driver was developed.

I think uncorrected blocks are not usually reported as rate, instead 
just blocks found to be faulty after outer coding. This is counter which 
very rarely increases, if you have picture it should remain 0 or at 
least near zero, otherwise your picture is totally garbage.


I hate you have added some time counting logic here (BER & UCB) which 
even should be done inside driver and report user space.

regards
Antti

-- 
http://palosaari.fi/
