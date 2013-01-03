Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:58132 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab3ACPSe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jan 2013 10:18:34 -0500
Received: from dolphin.tvdr.de (dolphin.tvdr.de [192.168.100.2])
	by racoon.tvdr.de (8.14.5/8.14.5) with ESMTP id r03FIWcr008174
	for <linux-media@vger.kernel.org>; Thu, 3 Jan 2013 16:18:32 +0100
Received: from [192.168.100.11] (falcon.tvdr.de [192.168.100.11])
	by dolphin.tvdr.de (8.14.4/8.14.4) with ESMTP id r03FIQPb022347
	for <linux-media@vger.kernel.org>; Thu, 3 Jan 2013 16:18:26 +0100
Message-ID: <50E5A142.2090807@tvdr.de>
Date: Thu, 03 Jan 2013 16:18:26 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [PATCH RFCv3] dvb: Add DVBv5 properties for
 quality parameters
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com> <CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com> <20130101130041.52dee65f@redhat.com> <CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com> <20130101152932.3873d4cc@redhat.com> <CAHFNz9LzBX0G9G0G_6C+WHooaQ1ridG1pkCcOPyzPG+FgOZKxw@mail.gmail.com> <20130103112044.4267b274@redhat.com>
In-Reply-To: <20130103112044.4267b274@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.01.2013 14:20, Mauro Carvalho Chehab wrote:
> Em Wed, 2 Jan 2013 00:38:50 +0530
> Manu Abraham <abraham.manu@gmail.com> escreveu:
>
>> On Tue, Jan 1, 2013 at 10:59 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Em Tue, 1 Jan 2013 22:18:49 +0530
>>> Manu Abraham <abraham.manu@gmail.com> escreveu:
>>>
>>>> On Tue, Jan 1, 2013 at 8:30 PM, Mauro Carvalho Chehab
>>>> <mchehab@redhat.com> wrote:
>>>>
>>>>> [RFCv4] dvb: Add DVBv5 properties for quality parameters
>>>>>
>>>>> The DVBv3 quality parameters are limited on several ways:
>>>>>          - Doesn't provide any way to indicate the used measure;
>>>>>          - Userspace need to guess how to calculate the measure;
>>>>>          - Only a limited set of stats are supported;
>>>>>          - Doesn't provide QoS measure for the OFDM TPS/TMCC
>>>>>            carriers, used to detect the network parameters for
>>>>>            DVB-T/ISDB-T;
>>>>>          - Can't be called in a way to require them to be filled
>>>>>            all at once (atomic reads from the hardware), with may
>>>>>            cause troubles on interpreting them on userspace;
>>>>>          - On some OFDM delivery systems, the carriers can be
>>>>>            independently modulated, having different properties.
>>>>>            Currently, there's no way to report per-layer stats;
>>>>
>>>> per layer stats is a mythical bird, nothing of that sort does exist.
>>>
>>> Had you ever read or tried to get stats from an ISDB-T demod? If you
>>> had, you would see that it only provides per-layer stats. Btw, this is
>>> a requirement to follow the ARIB and ABNT ISDB specs.
>>
>> I understand you keep writing junk for ages, but nevertheless:
>>
>> Do you have any idea what's a BBHEADER (DVB-S2) or
>> PLHEADER (DVB-T2) ? The headers do indicate what MODCOD
>> (aka Modulation/Coding Standard follows, whatever mode ACM,
>> VCM or CCM) follows. These MODCOD foolows a TDM approach
>> with a hierarchial modulation principle. This is exactly what ISDB
>> does too.
>
> No, I didn't check DVB-S2/T2 specs deeply enough to understand
> if they're doing the same thing as ISDB.
>
> Yet, ISDB-T doesn't use a TDM approach for hierarchical modulation.
> It uses a FDM (OFDM is a type of Frequency Division Multiplexing).
>
> So, if you're saying that DVB-S2 uses TDM, it is very different than
> ISDB-T. As DVB-T2 uses an FDM type of modulation (OFDM), it would
> be possible to segment the carriers there, just like ISDB, or to
> use TDM hierarchical modulation techniques.
>
>>
>> And for your info:
>>
>> " The TMCC control information is
>> common to all TMCC carriers and
>> error correction is performed by using
>> difference-set cyclic code."
>
> Yes, TMCC carriers are equal and they are always modulated using DBPSK.
> That is done to make it possible to receive the TMCC carriers even under
> worse SNR conditions, where it may not be possible to decode the segment
> groups.
>
> It seems that you completely missed the point though. On ISDB-T, the
> carriers that belong to each group of segments (except for the control
> carriers - carriers 1 to 107) uses a completely independent modulation.
> Also, as they're spaced in frequency, the interference of each segment
> is different. So, error indications are different on each segment.
>
> Btw, in any case, the datasheets of ISDB-T demods clearly shows that
> the BER measures are per segment group (layer).
>
> For example, for the BER measures before Viterbi, those are the register
> names for a certain demod:
>
> 	VBERSNUMA Bit count of BER measurement before Viterbi in A layer
> 	VBERSNUMB Bit count of BER measurement before Viterbi in B layer
> 	VBERSNUMC Bit count of BER measurement before Viterbi in C layer
>
> It has another set of registers for BER after Viterbi, and for PER after
> Viterbi and RS, for bit count errors, etc.
>
> There's no way to get any type of "global" BER measure, simply because
> ISDB-T demods don't provide.

Maybe we should put all this theoretical discussion aside for the moment and
think about what is *really* needed by real world applications. As with any
receiver, VDR simply wants to have some measure of the signal's "strength"
and "quality". These are just two values that should be delivered by each
frontend/demux, using the *same* defined and mandatory range. I don't care
what exactly that is, but it needs to be the same for all devices.
What values a particular driver uses internally to come up with these
is of no interest to VDR. The "signal strength" might just be what is
currently returned through FE_READ_SIGNAL_STRENGTH (however, normalized to
the same range in all drivers, which currently is not the case). The "signal
quality" might use flags like FE_HAS_SIGNAL, FE_HAS_CARRIER, FE_HAS_VITERBI,
FE_HAS_SYNC, as well as SNR, BER and UNC (if available) to form some
value where 0 means no quality at all, and 0xFFFF means excellent quality.
If a particular frontend/demux uses totally different concepts, it can
just use whatever it deems reasonable to form the "strength" and "quality"
values. The important thing here is just that all this needs to be hidden
inside the driver, and the only interface to an application are ioctl()
calls that return these two values.

So I suggest that you define this minimal interface and allow applications
to retrieve what they really need. Once this is done, feel free to implement
whatever theoretical bells and whistles you fell like doing - that's all
fine with me, as long as the really important stuff keeps working ;-)

Klaus
