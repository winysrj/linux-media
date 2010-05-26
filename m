Return-path: <linux-media-owner@vger.kernel.org>
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:46714 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934201Ab0EZHB0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 03:01:26 -0400
Message-ID: <4BFCC741.8070204@gmail.com>
Date: Wed, 26 May 2010 17:01:21 +1000
From: Jed <jedi.theone@gmail.com>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ideal DVB-C PCI/e card? [linux-media]
References: <4BF8D735.9070400@gmail.com>	<4BF9717D.9080209@s5r6.in-berlin.de>	<4BFA1F26.7070709@gmail.com>	<4BFC2691.1040203@s5r6.in-berlin.de>	<AANLkTikStvq6xhdS-e5skEy0LiTMSEBntIyBcb_AK7tc@mail.gmail.com>	<4BFCA843.2080203@gmail.com>	<4BFCAB05.4000104@gmail.com> <AANLkTilkwWVkHgUV2YBcpscsbeUt6GSCpudc0F7W-OSX@mail.gmail.com>
In-Reply-To: <AANLkTilkwWVkHgUV2YBcpscsbeUt6GSCpudc0F7W-OSX@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>>>>>>> Ideally it'd be dual DVB-C, the only one I've found is more than dual
>>>>>>>> DVB-C&  is far too expensive.
>>>>>>>
>>>>>>> If you need two receivers but can only spare up to one PCI or PCIe
>>>>>>> slot,
>>>>>>> why not use two USB or FireWire attached receivers?
>>>>>>>
>>>>>>> FireWire ones seem to be out of production now though and weren't
>>>>>>> exactly on the cheap side. OTOH one can drive up to 3 DVB FireWire
>>>>>>> receivers on a single FireWire bus; and for those who need even more
>>>>>>> there are dual link FireWire PCI and PCIe cards readily available.
>>>>>>
>>>>>> Thanks for offering your thoughts Stefan.
>>>>>> Any specific recommendations?
>>>>>>
>>>>>> Ideally I want two or more dvb-c tuners in a pci/e form-factor.
>>>>>>
>>>>>> If there's FW or USB tuners that are mounted onto a PCI/e card, work
>>>>>> well in Linux,&  are relatively cheap, then I'd love to know!
>>>>>
>>>>> I don't have an overview over USB tuners.
>>>>>
>>>>
>>>> We have USB DVB-C/T hybrid devices which are supported with Linux.
>>>>
>>>> http://support.sundtek.com/index.php/topic,4.0.html (the driver is
>>>> mostly independent from
>>>> Linux Kernels).
>>>>
>>>> Aside of that we just made it work on a Dreambox 800 (300 Mhz MIPS as
>>>> well, and looking forward
>>>> to support other platforms as well).
>>>>
>>>>
>>>> http://sundtek.com/shop/Digital-TV-Sticks/Sundtek-MediaTV-Digital-Home-DVB-CT.html
>>>>
>>>>
>>>> Best Regards,
>>>> Markus
>>>
>>> Thanks but I'd prefer PCI/e form-factor...
>>> If there's something fw or usb-based x2,&  squeezed into that
>>> form-factor, I'm very interested!
>>
>> I may only have room for 1x pci/e dvb-c card (hopefully one that has two
>> single fw tuners mounted).
>> So I may still look at USB based tuners like yours...
>>
>
> There are also MiniPCIe USB DVB-C/T solutions available, although we
> have only seen single
> PCIe - MiniPCIe solutions yet (and those required an additional
> internal USB connection for the USB part)
> Another option might be a PCI/PCIe USB Bridge +  USB DVB-C, we tested
> 3x USB DVB-C devices
> with a notebook at the same time (maybe 4 are possible, our test PC
> only had 3x USB Slots back then).

Not sure what you mean, I don't suppose you could clarify?

You mean I might be able to buy 2x mini-PCIe cards that can be mounted 
onto a PCIe <-> USB bridge & then that card (bridge) will have two usb 
cables that need to be connected to 2 USB headers on the motherboard?

If yes, that'd be fairly pricey wouldn't it?
