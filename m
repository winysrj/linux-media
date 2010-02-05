Return-path: <linux-media-owner@vger.kernel.org>
Received: from psa.adit.fi ([217.112.250.17]:39968 "EHLO psa.adit.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0BEPo5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 10:44:57 -0500
Message-ID: <4B6C3D79.5080203@adit.fi>
Date: Fri, 05 Feb 2010 17:47:05 +0200
From: Pekka Sarnila <sarnila@adit.fi>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Kosina <jkosina@suse.cz>,
	Pekka Sarnila <pekka.sarnila@qvantel.com>, crope@iki.fi,
	linux-media@vger.kernel.org, pb@linuxtv.org, js@linuxtv.org
Subject: Re: dvb-usb-remote woes [was: HID: ignore afatech 9016]
References: <alpine.LNX.2.00.1001132111570.30977@pobox.suse.cz> <1263415146-26321-1-git-send-email-jslaby@suse.cz> <alpine.LNX.2.00.1001260156010.30977@pobox.suse.cz> <4B5EFD69.4080802@adit.fi> <alpine.LNX.2.00.1001262344200.30977@pobox.suse.cz> <4B671C31.3040902@qvantel.com> <alpine.LNX.2.00.1002011928220.15395@pobox.suse.cz> <4B672EB8.3010609@suse.cz>
In-Reply-To: <4B672EB8.3010609@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of the question here are already answered or no more actual, but 
for clarity:

Jiri Slaby wrote:
>>>The remote is visible to the system as a usb interrupt end point.
>>>Interrupt endpoint tells the system the polling interval (by endpoint
>>>report). From the USB specs on the interval:
>>>
>>>  The USB System Software will use this information during configuration
>>>  to determine a period that can be sustained. The period provided by
>>>  the system may be shorter than that desired by the device up to the
>>>  shortest period defined by the USB (125 µs microframe or 1 ms frame).
>>>  The client software and device can depend only on the fact that the
>>>  host will ensure that the time duration between two transaction
>>>  attempts with the endpoint will be no longer than the desired period.
>>>
>>>As I understand it, in plain English it means that the polling interval
>>>must not be longer than what the endpoint report says (in case of
>>>full-speed endpoint 1 to 255 ms). This device in question, assuming it
>>>gives the interval in full-speed mode even it really is high-speed
>>>device, gives 16ms interval period.
>>>
>>>However af9015.c/dvb-usb-remote.c accesses it as if it was a bulk
>>>endpoint and with 150ms interval. I did not look further on if this is
>>>the only reason or the reason for it not to work. But at least it is in
>>>clear contradiction of the USB-specs.
> 
> To what statement is it in contradiction? The statement above is for
> interrupt transfers.

The answer was that there is no contradiction since the 150 ms was for 
the bulk endpoint (0/81). When writing this I thought af9015.c used the 
HID endpoint (1/83), which is interrupt endpoint, as an bulk endpoint.

>>>I suspect, to make it work, much of the code from hid-driver should be
>>>copied to the device driver. 
> 
> Which code? I see no code being copied.

I meant that to make af9015.c to use HID endpoint past HID layer would 
require copying big parts from the HID layer to af9015.c. Again it was 
due to the above misunderstanding on my part.

>>>However I think that would be exactly the
>>>wrong way to go. I think the whole idea of making for every device a
>>>separated driver ignoring the common code already in the kernel is bad
>>>architecture.
> 
> Common code does not work well here. Don't you see weird key repetitions
> and similar?

No, it worked ok for me.

> Patrick, Johannes, why was not dvb-usb-remote implemented rather as a
> part of the HID layer?

Because it's for device specific drivers that uses vendor class endpoint 
instead of the HID class endpoint.

>>>Also it is wrong idea that you could/should detect the type of remote
>>>controller based on the tv-stick. E.g with Haupauge TV-NOVA nearly any
>>>remote works ok (e.g my panasonic tv remote). Every generic ir-receiver
>>>sends also the manufacturer and model codes. Remote ir-to-code
>>>translates should be based on that (there is a kind of generic layer for
>>>that in  linux kernel) and not on the tv-stick model at all (as in the
>>>af9015 driver). 
> 
> Sorry, I don't understand this paragraph. Could you rephrase?

This has been, it seems, the one of the very goals of IR input coding: 
to make remotes other than the ones provided with tv-stick to work with 
that same stick.

>>>BTW I now recall how I got Afateck remote work as should. The driver
>>>loads ir-to-code translate table to the stick. I changed the codes to
>>>what made more sense.
> 
> Why you didn't push this upstream?

Well the driver was at the time not part of the standard kernel 
(downloaded form Matti Palosaaris site). And I put there directly the 
keycodes that worked with command line mplayer. No standard solution.

>>>One problem here is that current HID layer is very sparse in the
>>>information it passes on, really only a code. It should also convey the
>>>precice id of the device so upper layer would be better able to deal
>>>with events. One of my hobbies is flight simulator flying. I use X-plane
>>>(excellent program). There is also a linux version. But the linux
>>>joystick driver is far from adequate for it (also some joysticks, yokes
>>>and pedals or some of their controls didn't work at all). So I use a
>>>special kernel for which I rewrote big parts of the HID-driver and
>>>input-driver and wrote completely new joystick driver. Now it works
>>>quite decently. One problem is the kernel->user joystick driver
>>>interface, but it can not be changed since that's what X-plane (and
>>>others use). One thing I got to change for that was that HID does less
>>>model specific processing and passes more event info to higher layer
>>>without breaking the old HID-devices (same with the input layer), so
>>>that the joystick layer could do more intelligent processing. I fixed
>>>also some bugs and one design omission in the HID driver (e.g. some
>>>force feedback joysticks uses that HID-specification, in standard kernel
>>>there is some ad-hoc code for that purpose).
> 
> Can't be HID bus with a specific driver used instead now?

Well it could, but this way it is much less work and more generic. I use 
many different joysticks, yokes and pedals. And with some generic 
modifications and improvements into generic HID layer and generic input 
layer all worked well. Only joystick layer got to be completely rewritten.

I did never put this upstream because by the time I got my own patches 
integrated to the (new) kernel, the hid/input layer had developed so 
much that the patches could no more be used in the latest kernel. So I 
hand applied them again, and again kernel had moved on, and so on. Also 
to argue for patches that cover several areas and several maintainers is 
difficult, and changing a lot at once is always risky. So I gave up.

If anyone is interested, I could take a look again and see if the 
changes could be argued and applied incrementally instead of one big bunch.

Pekka


