Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51209 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab3ACUkI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jan 2013 15:40:08 -0500
Message-ID: <50E5EC7E.4020508@iki.fi>
Date: Thu, 03 Jan 2013 22:39:26 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Subject: Re: [PATCH RFCv3] dvb: Add DVBv5 properties for quality parameters
References: <1356739006-22111-1-git-send-email-mchehab@redhat.com> <CAGoCfix=2-pXmTE149XvwT+f7j1F29L3Q-dse0y_Rc-3LKucsQ@mail.gmail.com> <20130101130041.52dee65f@redhat.com> <CAHFNz9+hwx9Bpd5ZJC5RRchpvYzKUzzKv43PSzDunr403xiOsQ@mail.gmail.com> <50E5A515.4050500@iki.fi> <CAHFNz9+-ixyYpAE1egC_s=MSk+t+si-tLTR=T8GK9QoK=vdf5A@mail.gmail.com> <20130103172735.0aa1db6d@redhat.com> <CAHFNz9J1ziYfSb8zZbxsNoFfCC5SyW9iJKEA3y7HA__zU9oqpA@mail.gmail.com> <20130103175359.5fc157eb@redhat.com>
In-Reply-To: <20130103175359.5fc157eb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2013 09:53 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 4 Jan 2013 01:02:02 +0530
> Manu Abraham <abraham.manu@gmail.com> escreveu:
>
>> On Fri, Jan 4, 2013 at 12:57 AM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Em Fri, 4 Jan 2013 00:39:25 +0530
>>> Manu Abraham <abraham.manu@gmail.com> escreveu:
>>>
>>>> Hi Antti,
>>>>
>>>> On Thu, Jan 3, 2013 at 9:04 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>>> On 01/01/2013 06:48 PM, Manu Abraham wrote:
>>>>>>
>>>>>> On Tue, Jan 1, 2013 at 8:30 PM, Mauro Carvalho Chehab
>>>>>> <mchehab@redhat.com> wrote:
>>>>>>
>>>>>>> [RFCv4] dvb: Add DVBv5 properties for quality parameters
>>>>>>>
>>>>>>> The DVBv3 quality parameters are limited on several ways:
>>>>>>>           - Doesn't provide any way to indicate the used measure;
>>>>>>>           - Userspace need to guess how to calculate the measure;
>>>>>>>           - Only a limited set of stats are supported;
>>>>>>>           - Doesn't provide QoS measure for the OFDM TPS/TMCC
>>>>>>>             carriers, used to detect the network parameters for
>>>>>>>             DVB-T/ISDB-T;
>>>>>>>           - Can't be called in a way to require them to be filled
>>>>>>>             all at once (atomic reads from the hardware), with may
>>>>>>>             cause troubles on interpreting them on userspace;
>>>>>>>           - On some OFDM delivery systems, the carriers can be
>>>>>>>             independently modulated, having different properties.
>>>>>>>             Currently, there's no way to report per-layer stats;
>>>>>>
>>>>>>
>>>>>> per layer stats is a mythical bird, nothing of that sort does exist. If
>>>>>> some
>>>>>> driver states that it is simply due to lack of knowledge at the coding
>>>>>> side.
>>>>>>
>>>>>> ISDB-T uses hierarchial modulation, just like DVB-S2 or DVB-T2
>>>>>
>>>>>
>>>>> Manu, you confused now two concept (which are aimed to resolve same real
>>>>> life problem) - hierarchical coding and multiple transport stream. Both are
>>>>> quite similar on lower level of radio channel, but differs on upper levels.
>>>>>
>>>>> Hierarchical is a little bit weird baby as it remuxes those lower lever
>>>>> radio channels (called layers in case of ISDB-T) to one single mux!
>>>>
>>>> That is not really correct. There is one single OFDM channel, the layers
>>>> are processed via hierarchial separation. Stuffing exists, to maintain
>>>> constant rate.
>>>>
>>>> http://farm9.staticflickr.com/8077/8343296328_e1e375b519_b_d.jpg
>>>>
>>>> When rate is constant within the same channel..
>>>> (The only case what I can think parameters could be different with a
>>>> constant rate,
>>>> is that stuffing frames are unaccounted for. Most likely a bug ?)
>>>
>>> What did you smoke? That picture has nothing to do with ISDB!
>>>
>>
>> ARIB STD – B31
>> Version 1.6-E2
>> －17－
>> Fig. 3-2 shows the basic configuration of the channel coding.
>>
>> It just shows, you understand crap.
>
> That is the picture you need to look, not the random one you picked.
> It clearly shows there that, after the hierarchical coding done by
> the "Division of TS into hierarchical levels", the TS packets are
> split into 3 independent channels, each with its own convolutional
> coding, carrier modulation, etc.
>
> This picture shows how each program is split at the FDM sub-carriers:
> 	http://en.wikipedia.org/wiki/File:ISDB-T_CH_Seg_Prog_allocation.jpg.svg
>
> There, LD programs are at segment 0 (S0). HD programs use 12 segments
> and SD programs use 4 segments.
>
> As each segment group has a different spectrum (as they're using FDM),
> and are modulated with different encoding schemas (modulation type, FEC,
> etc), they have different QoS measures.
>
> Segment 0 (the one at the center of the spectrum) is less sensitive to
> inter-channel interference. That's why it is used for LD programs.
>
>
> Cheers,
> Mauro
>


Manu, here is manual of the professional ISDB-T signal analyzer. Look 
especially BER measurement picture from "Slide 10".

I think you don't bother to say Anritsu MS8901A ISDB-T Digital Broadcast 
Signal Analyzer, which street price is $20,000, does not know how to 
measure ISDB-T statistics....

http://downloadfiles.anritsu.com/Files/en-US/Product-Introductions/Product-Introduction/MS8901A_EL1100.pdf


Antti

-- 
http://palosaari.fi/
