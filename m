Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZKZV2L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 16:28:11 -0500
Message-ID: <4B0EF2E3.3020006@redhat.com>
Date: Thu, 26 Nov 2009 19:28:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Christoph Bartelmus <lirc@bartelmus.de>, jarod@wilsonet.com,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDcbizrJjFB@christoph> <4B0EABF8.9000902@redhat.com>	<m3r5rlupcb.fsf@intrepid.localdomain> <4B0ECF1B.1090103@redhat.com> <m3tywhrpy9.fsf@intrepid.localdomain>
In-Reply-To: <m3tywhrpy9.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>> The removal of the existing keymaps from kernel depends on having an
>> application
>> to be called from udev to load the proper keymaps when a device is probed.
>>
>> After having it for a while, we should deprecate the in-kernel keymaps
>> and move them to userspace.
> 
> Sounds like a plan.
> 
>> I also think that it is important to remove the 7 bits limitation from
>> all drivers
>> and re-generate the keymaps, since they'll change after it.
> 
> I think the existing space/mark media drivers need to be reworked
> completely.

Nah. the changes aren't big. The first part of the change were already done
for 2.6.32: instead of having a vector of 128 elements, where the element order
used to be the masked scancode, we now have a table of scancode x keycode, defined
as:

struct ir_scancode {
        u16     scancode;
        u32     keycode;
};

Changing scancode to u32 is as easy as edit a file - it is currently 16 just because
all currently supported IR's and protocols have 16 bits only - there's no in-kernel
implementation for RC6 mode 6 yet. However, increasing it above to 64 bits will break on
32 bits kernels (and above 64 bits, on all architectures), due to the current API limits.

this change is currently limited to the ir keytables, but I have a patch already done
extending this change for the drivers to work directly with the new table.

The next step is to replace the ir->mask_keycode at the drivers to a value that
gets the entire scancode. We may still need a mask there, since not all drivers output
a 32 bits scancode.

Also, there's no single "space/mark" media driver. All drivers that support 
pulse/space also support in-hardware IR decoding, in order to support the 
different types of devices. They generally support several ways to get keys:
	- serial pulse/space decoding on one GPIO pin (most pci hardware have);
	- serial pulse/space decoding via a IRQ enabled GPIO pin (several saa7134 IR's use this way);
	- i2c IR's (common on several popular devices);
	- parallel scancode output via gpio pins several cx88 IR's use this way);
	- direct IR hardware decoding done by the video chipset 
		(DibCom and newer em28xx hardware, for example).

So, the driver input complexity is needed to support all those different ways. 

So, rewriting it would likely cause regressions.

I agree that there are some cleanups that should be done for the serial pulse/space raw
decoding. By adding a lirc interface, we'll need to have a common code for handling
those events anyway.

Cheers,
Mauro.
