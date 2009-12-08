Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbZLHLon (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 06:44:43 -0500
Message-ID: <4B1E3C1D.7070704@redhat.com>
Date: Tue, 08 Dec 2009 09:44:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Andy Walls <awalls@radix.net>, Jarod Wilson <jarod@wilsonet.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <m3k4xe7dtz.fsf@intrepid.localdomain> <4B0E8B32.3020509@redhat.com> <1259264614.1781.47.camel@localhost> <6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com> <1260240142.3086.14.camel@palomino.walls.org> <20091208042210.GA11147@core.coreip.homeip.net>
In-Reply-To: <20091208042210.GA11147@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Mon, Dec 07, 2009 at 09:42:22PM -0500, Andy Walls wrote:
>> On Mon, 2009-12-07 at 13:19 -0500, Jarod Wilson wrote:
>>> On Nov 26, 2009, at 2:43 PM, Andy Walls wrote:
>>>
>>>> On Thu, 2009-11-26 at 12:05 -0200, Mauro Carvalho Chehab wrote:
>>>>> Krzysztof Halasa wrote:
>>>>>> Andy Walls <awalls@radix.net> writes:
>>>>>>
>>>>>>> I would also note that RC-6 Mode 6A, used by most MCE remotes, was
>>>>>>> developed by Philips, but Microsoft has some sort of licensing interest
>>>>>>> in it and it is almost surely encumbered somwhow:
>>>>>> I don't know about legal problems in some countries but from the
>>>>>> technical POV handling the protocol in the kernel is more efficient
>>>>>> or (/and) simpler.
>>>>> A software licensing from Microsoft won't apply to Linux kernel, so I'm
>>>>> assuming that you're referring to some patent that they could be filled
>>>>> about RC6 mode 6A.
>>>>>
>>>>> I don't know if is there any US patent pending about it (AFAIK, only US
>>>>> accepts software patents), but there are some prior-art for IR key
>>>>> decoding. So, I don't see what "innovation" RC6 would be adding. 
>>>>> If it is some new way to transmit waves, the patent issues
>>>>> aren't related to software, and the device manufacturer had already handled
>>>>> it when they made their devices.
>>>>>
>>>>> If it is just a new keytable, this issue 
>>>>> could be easily solved by loading the keytable via userspace.
>>>>>
>>>>> Also, assuming that you can use the driver only with a hardware that comes
>>>>> with a licensed software, the user has already the license for using it.
>>>>>
>>>>> Do you have any details on what patents they are claiming?
>>>> The US Philips RC-6 patent is US Patent 5,877,702
>>>>
>>>> http://www.google.com/patents?vid=USPAT5877702
>>>>
>>>> Click on download PDF to get a copy of the whole patent.
>>>>
>>>> I am not a lawyer.  Philips claims' all appear to tie to a transmitter
>>>> or receiver as part of a system, but most of the claims are about
>>>> information and bit positions and lengths.
>>> ...
>>>> IMO, given
>>>>
>>>> a. the dearth of public information about RC-6, indicating someone
>>>> thinks it's their trade secret or intellectual property
>>>>
>>>> b. Microsoft claiming to license something related to the MCE remote
>>>> protocols (which are obviously RC-6 Mode 6A),
>>>>
>>>> c. my inability to draw a "clear, bright line" that RC-6 Mode 6A
>>>> encoding and decoding, as needed by MCE remotes, implemented in software
>>>> doesn't violate anyone's government granted rights to exclusivity.
>>>>
>>>> I think it's much better to implement software RC-6 Mode 6A encoding and
>>>> decoding in user space, doing only the minimum needed to get the
>>>> hardware setup and going in the kernel.  
>>>>
>>>> Encoding/decoding of RC-6 by microcontrollers with firmware doesn't
>>>> worry me. 
>>>>
>>>>
>>>> Maybe I'm being too conservative here, but I have a personal interest in
>>>> keeping Linux free and unencumbered even in the US which, I cannot deny,
>>>> has a patent system that is screwed up.
>>> So I had one of the people who does all the license and patent audits
>>> for Fedora packages look at the Philips patent on RC-6. He's 100%
>>> positive that the patent *only* covers hardware, there should be no
>>> problem whatsoever writing a software decoder for RC-6.
>> OK.  Thanks for having some professionals take a look.  (I'm assuming
>> that's the only patent.)
>>
>> So I'll whip up an RC-6 Mode 6A decoder for cx23885-input.c before the
>> end of the month.
>>
>> I can setup the CX2388[58] hardware to look for both RC-5 and RC-6 with
>> a common set of parameters, so I may be able to set up the decoders to
>> handle decoding from two different remote types at once.  The HVR boards
>> can ship with either type of remote AFAIK.
>>
>> I wonder if I can flip the keytables on the fly or if I have to create
>> two different input devices?
>>
> 
> Can you distinguish between the 2 remotes (not receivers)? Like I said,
> I think the preferred way is to represent every remote that can be
> distinguished from each other as a separate input device. Applications
> expect to query device capabilities and expect them to stay somewhat
> stable (we do support keymap change but I don't think anyone expectes
> flip-flopping).
> 
With RC-5, you have no fields describing the remote. So, all the driver could
do is an educated guess.

>From a quick look I did at the RC-6 Mode 6A docs I found, I suspect that
you can distinguish two different remotes when someone press a key there.

However, I don't think it is a good idea to automatically create a new interface
every time a different vendor is detected. Maybe the user simply have a
RC-6 IR to control his TV and doesn't have any intention on using that
device on his computer.

IMO, the better is to have an API to allow creation of multiple interfaces
per IR receiver, based on some scancode matching table and/or on some
matching mask.

It should be possible to use the filter API to match different IR's by
vendor/product on protocols that supports it, or to match address/command
tuples on protocols where you just have those fields.

Cheers,
Mauro.
