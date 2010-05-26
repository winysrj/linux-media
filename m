Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33405 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab0EZGhn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 02:37:43 -0400
Received: by gwaa12 with SMTP id a12so540778gwa.19
        for <linux-media@vger.kernel.org>; Tue, 25 May 2010 23:37:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BFCAB05.4000104@gmail.com>
References: <4BF8D735.9070400@gmail.com>
	<4BF9717D.9080209@s5r6.in-berlin.de>
	<4BFA1F26.7070709@gmail.com>
	<4BFC2691.1040203@s5r6.in-berlin.de>
	<AANLkTikStvq6xhdS-e5skEy0LiTMSEBntIyBcb_AK7tc@mail.gmail.com>
	<4BFCA843.2080203@gmail.com>
	<4BFCAB05.4000104@gmail.com>
Date: Wed, 26 May 2010 08:37:40 +0200
Message-ID: <AANLkTilkwWVkHgUV2YBcpscsbeUt6GSCpudc0F7W-OSX@mail.gmail.com>
Subject: Re: ideal DVB-C PCI/e card? [linux-media]
From: Markus Rechberger <mrechberger@gmail.com>
To: Jed <jedi.theone@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 26, 2010 at 7:00 AM, Jed <jedi.theone@gmail.com> wrote:
>>>>>>> Ideally it'd be dual DVB-C, the only one I've found is more than dual
>>>>>>> DVB-C& is far too expensive.
>>>>>>
>>>>>> If you need two receivers but can only spare up to one PCI or PCIe
>>>>>> slot,
>>>>>> why not use two USB or FireWire attached receivers?
>>>>>>
>>>>>> FireWire ones seem to be out of production now though and weren't
>>>>>> exactly on the cheap side. OTOH one can drive up to 3 DVB FireWire
>>>>>> receivers on a single FireWire bus; and for those who need even more
>>>>>> there are dual link FireWire PCI and PCIe cards readily available.
>>>>>
>>>>> Thanks for offering your thoughts Stefan.
>>>>> Any specific recommendations?
>>>>>
>>>>> Ideally I want two or more dvb-c tuners in a pci/e form-factor.
>>>>>
>>>>> If there's FW or USB tuners that are mounted onto a PCI/e card, work
>>>>> well in Linux,& are relatively cheap, then I'd love to know!
>>>>
>>>> I don't have an overview over USB tuners.
>>>>
>>>
>>> We have USB DVB-C/T hybrid devices which are supported with Linux.
>>>
>>> http://support.sundtek.com/index.php/topic,4.0.html (the driver is
>>> mostly independent from
>>> Linux Kernels).
>>>
>>> Aside of that we just made it work on a Dreambox 800 (300 Mhz MIPS as
>>> well, and looking forward
>>> to support other platforms as well).
>>>
>>>
>>> http://sundtek.com/shop/Digital-TV-Sticks/Sundtek-MediaTV-Digital-Home-DVB-CT.html
>>>
>>>
>>> Best Regards,
>>> Markus
>>
>> Thanks but I'd prefer PCI/e form-factor...
>> If there's something fw or usb-based x2, & squeezed into that
>> form-factor, I'm very interested!
>
> I may only have room for 1x pci/e dvb-c card (hopefully one that has two
> single fw tuners mounted).
> So I may still look at USB based tuners like yours...
>

There are also MiniPCIe USB DVB-C/T solutions available, although we
have only seen single
PCIe - MiniPCIe solutions yet (and those required an additional
internal USB connection for the USB part)
Another option might be a PCI/PCIe USB Bridge +  USB DVB-C, we tested
3x USB DVB-C devices
with a notebook at the same time (maybe 4 are possible, our test PC
only had 3x USB Slots back then).

Markus
