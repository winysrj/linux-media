Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbZLHLdH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 06:33:07 -0500
Message-ID: <4B1E394A.1090807@redhat.com>
Date: Tue, 08 Dec 2009 09:32:26 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>	 <1259024037.3871.36.camel@palomino.walls.org>	 <m3k4xe7dtz.fsf@intrepid.localdomain>  <4B0E8B32.3020509@redhat.com>	 <1259264614.1781.47.camel@localhost>	 <6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com> <1260240142.3086.14.camel@palomino.walls.org>
In-Reply-To: <1260240142.3086.14.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Mon, 2009-12-07 at 13:19 -0500, Jarod Wilson wrote:
>> On Nov 26, 2009, at 2:43 PM, Andy Walls wrote:
>>
>>> On Thu, 2009-11-26 at 12:05 -0200, Mauro Carvalho Chehab wrote:
>>>> Krzysztof Halasa wrote:
>>>>> Andy Walls <awalls@radix.net> writes:
>>>>>
>>>>>> I would also note that RC-6 Mode 6A, used by most MCE remotes, was
>>>>>> developed by Philips, but Microsoft has some sort of licensing interest
>>>>>> in it and it is almost surely encumbered somwhow:
>>>>> I don't know about legal problems in some countries but from the
>>>>> technical POV handling the protocol in the kernel is more efficient
>>>>> or (/and) simpler.
>>>> A software licensing from Microsoft won't apply to Linux kernel, so I'm
>>>> assuming that you're referring to some patent that they could be filled
>>>> about RC6 mode 6A.
>>>>
>>>> I don't know if is there any US patent pending about it (AFAIK, only US
>>>> accepts software patents), but there are some prior-art for IR key
>>>> decoding. So, I don't see what "innovation" RC6 would be adding. 
>>>> If it is some new way to transmit waves, the patent issues
>>>> aren't related to software, and the device manufacturer had already handled
>>>> it when they made their devices.
>>>>
>>>> If it is just a new keytable, this issue 
>>>> could be easily solved by loading the keytable via userspace.
>>>>
>>>> Also, assuming that you can use the driver only with a hardware that comes
>>>> with a licensed software, the user has already the license for using it.
>>>>
>>>> Do you have any details on what patents they are claiming?
>>> The US Philips RC-6 patent is US Patent 5,877,702
>>>
>>> http://www.google.com/patents?vid=USPAT5877702
>>>
>>> Click on download PDF to get a copy of the whole patent.
>>>
>>> I am not a lawyer.  Philips claims' all appear to tie to a transmitter
>>> or receiver as part of a system, but most of the claims are about
>>> information and bit positions and lengths.
>> ...
>>> IMO, given
>>>
>>> a. the dearth of public information about RC-6, indicating someone
>>> thinks it's their trade secret or intellectual property
>>>
>>> b. Microsoft claiming to license something related to the MCE remote
>>> protocols (which are obviously RC-6 Mode 6A),
>>>
>>> c. my inability to draw a "clear, bright line" that RC-6 Mode 6A
>>> encoding and decoding, as needed by MCE remotes, implemented in software
>>> doesn't violate anyone's government granted rights to exclusivity.
>>>
>>> I think it's much better to implement software RC-6 Mode 6A encoding and
>>> decoding in user space, doing only the minimum needed to get the
>>> hardware setup and going in the kernel.  
>>>
>>> Encoding/decoding of RC-6 by microcontrollers with firmware doesn't
>>> worry me. 
>>>
>>>
>>> Maybe I'm being too conservative here, but I have a personal interest in
>>> keeping Linux free and unencumbered even in the US which, I cannot deny,
>>> has a patent system that is screwed up.
>> So I had one of the people who does all the license and patent audits
>> for Fedora packages look at the Philips patent on RC-6. He's 100%
>> positive that the patent *only* covers hardware, there should be no
>> problem whatsoever writing a software decoder for RC-6.
> 
> OK.  Thanks for having some professionals take a look.  (I'm assuming
> that's the only patent.)
> 
> So I'll whip up an RC-6 Mode 6A decoder for cx23885-input.c before the
> end of the month.

Good! Please, try to design the decoder as an independent module that gets
data from a kfifo and generate scancodes for the input API.
 
> I can setup the CX2388[58] hardware to look for both RC-5 and RC-6 with
> a common set of parameters, so I may be able to set up the decoders to
> handle decoding from two different remote types at once.  The HVR boards
> can ship with either type of remote AFAIK.
> 
> I wonder if I can flip the keytables on the fly or if I have to create
> two different input devices?

IMO, the better is, by default, to open just one input device per IR receiver.
>From what I understand from our discussions, if the user wants to filter IR
commands into several input interfaces, some userspace interface will be 
provided to allow the creation of other input interfaces for that purpose.

Cheers,
Mauro.
