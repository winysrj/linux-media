Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab1KKMoR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 07:44:17 -0500
Message-ID: <4EBD1892.8020603@redhat.com>
Date: Fri, 11 Nov 2011 10:44:02 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: FE_CAN-bits
References: <CAHFNz9Lf8CXb2pqmO0669VV2HAqxCpM9mmL9kU=jM19oNp0dbg@mail.gmail.com> <CAHFNz9JNLAFnjd14dviJJDKcN3cxgB+MFrZ72c1MVXPLDsuT0Q@mail.gmail.com> <4EBC402E.20208@redhat.com> <201111111055.12496.pboettcher@kernellabs.com> <4EBD08D0.6030701@iki.fi>
In-Reply-To: <4EBD08D0.6030701@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-11-2011 09:36, Antti Palosaari escreveu:
> On 11/11/2011 11:55 AM, Patrick Boettcher wrote:
>> On Thursday, November 10, 2011 10:20:46 PM Mauro Carvalho Chehab wrote:
>>>
>>> We should also think on a way to enumerate the supported values for each
>>> DVB properties, the enum fe_caps is not enough anymore to store
>>> everything. It currently has 30 bits filled (of a total of 32 bits), and
>>> we currently have:
>>>     12 code rates (including AUTO/NONE);
>>>     13 modulation types;
>>>     7 transmission modes;
>>>     7 bandwidths;
>>>     8 guard intervals (including AUTO);
>>>     5 hierarchy names;
>>>     4 rolloff's (probably, we'll need to add 2 more, to distinguish between
>>> DVB-C Annex A and Annex C).
>>>
>>> So, if we would need to add one CAN_foo for each of the above, we would
>>> need 56 to 58 bits, plus 5-6 bits to the other capabilities that
>>> currently exists there. So, even 64 bits won't be enough for the current
>>> needs (even having the delivery system caps addressed by something
>>> else).
>>
>> IMHO, we don't need such a fine FE_CAN_-bit distinguishing for most
>> standards. A well defined sub-standard definition is sufficient, which can be
>> handled with a delivery-system-like query as proposed in the original patch.
>> This also will be much simpler for most user-space applications and users.
> 
> I agree that. Those are totally useless in general. Let driver return error to userspace if it cannot handle.
> 
>> DVB-T means:
>> - 8K or 2K,
>> - 1/4-1/32 Guard,
>> - 1/2, 2/3, 3/4, 5/6 and 7/8 coderate,
>> - QPSK, 64QAM or 16QAM
>>
>> DVB-H (RIP as Remi wrote somewhere) would have meant:
>> - DVB-T + 4K + in-depth-interleaver mode
>>
>> The same applies to ISDB-T and ISDB-T 1seg. And for CMMB, CTTB, DVB-SH.
>>
>> If there are demods which can't do one particular thing, we should forget
>> about them. At least this is what almost all applications I have seen so far
>> are doing implicitly.
> 
> I know only one case where device cannot support all standard parameters. It is one TDA10023 device and looks like stream goes too wide when QAM256 is used.
> 
>> Though, I see at least one inconvenience is if someone is using linux-dvb
>> for developping dsp-software and wants to deliver things which aren't done.
>> But is this a case we want to "support" within the official API.
> 

If you take a look at DVB-C, for example, The reference used by the DVB subsystem
seems to be the ITU-T J.83, as the delivery systems are named according to
ITU-T J.83 annexes:
	Annex A - European DVB-C (also defined on EN 300 429)
	Annex B - American DOCSYS
	Annex C - Japanese variant of Annex A, optimized for 6 MHz Bw

According with ITU-T J.83/1997 (from where Annex A, B and C are referenced), we have:

Annex A:
	- modulation: QAM 16, 32 and 64
	  Mentions that QAM 128 and 256 could be used in future
	- rolloff: 0.15

Annex B:
	- Modulation: QAM 64, 256

Annex C:
	- Modulation: QAM 64
	- rolloff: 0.13

ITU-T Annex A is also defined at ETSI as EN 300 429/1998. There, we have:
	- modulation: QAM 16, 32, 64, 128 and 256
	- rolloff: 0.15

As the same delivery system is used for both Annex A and Annex C, the "minimum"
requirement for SYS_DVBC_ANNEX_AC is to support QAM64 (as it can be a device that 
implements only Annex C).

So, just assuming some default from the delivery system is dangerous. Also, as
specs may change with time (as J.83 -> EN 300 429 addition for QAM 128 and 256),
this may lead into troubles in the future.

Btw, DVB-C2, as defined on ITU-T J.122 is even more complex, offering a myriad of
mandatory and optional formats, as shown at item 6.2.3:
	The upstream demodulator MAY support QPSK and 16QAM differential modulation for TDMA.
	The upstream demodulator MUST support QPSK, 16QAM, and 64QAM modulations for TDMA and S-CDMA channels.
	The upstream demodulator MAY support 8QAM and 32QAM modulation for TDMA and S-CDMA channels.
	The upstream demodulator MAY support QPSK, 8QAM, 16QAM, 32QAM, 64QAM, and 128QAM TCM encoded modulations for S-CDMA channels.

What I think we can do is to provide macros for the capabilities, like:

#define FE_CAN_DVBT	FE_CAN_1_2 | FE_CAN_3_4 | ...

With regards to the idea of returning an error, this may not work on all cases.
For example, my 1seg stick is capable of retrieving channel info from 3-seg and full-seg
streams, even not being able of actually watching those. Ideally, userspace should
be capable of disabling the 3seg/full-seg channels if they aren't actually supported
by the plugged device.

Regards,
Mauro
