Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53228 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766AbaAAXwG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jan 2014 18:52:06 -0500
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id D00C120B90
	for <linux-media@vger.kernel.org>; Wed,  1 Jan 2014 18:52:04 -0500 (EST)
Message-ID: <52C4AA25.9050200@signal11.us>
Date: Wed, 01 Jan 2014 18:52:05 -0500
From: Alan Ott <alan@signal11.us>
MIME-Version: 1.0
To: Sander Smeenk <ssmeenk@freshdot.net>, linux-usb@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Sean Young <sean@mess.org>
Subject: Re: 0471:206c IR receiver, mceusb & NULL pointer dereference
References: <20140101221349.GA17348@dot.freshdot.net>
In-Reply-To: <20140101221349.GA17348@dot.freshdot.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/01/2014 05:13 PM, Sander Smeenk wrote:
> Plugging in a 0471:206c 'Spinel plusf0r Asus' IR receiver with the
> more recent mceusb module versions Oops'es the kernel with a null
> pointer deref. I'm currently seeing this in 3.12.0 (Ubuntu stock) but i
> recall seeing this problem since about 3.8+ kernels. I kinda hoped it'd
> go away over time but it's still there so i've dug deeper...
>
> For this Oops the IR receiver was plugged in after the system finished
> booting and a session was started for the user. After the Oops it was
> impossible to unload the module, rmmod and usb [for that device] would
> hang, replugging produced no further output, udev borked, reboot needed.
>
> Full dmesg output: https://8n1.org/9514/9621
> Excerpt:
> | BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
> | IP: [<ffffffffa06fef0c>] mce_request_packet+0x14c/0x240 [mceusb]
> | Oops: 0000 [#1] SMP
> | CPU: 1 PID: 1447 Comm: systemd-udevd Not tainted 3.12.0-7-generic #15-Ubuntu
> | [ .. ]
> | Call Trace:
> |  [<ffffffffa06ff05a>] mce_async_out+0x5a/0x70 [mceusb]
> |  [<ffffffffa06ff9cd>] mceusb_dev_probe+0x61d/0xcb0 [mceusb]
> |  [<ffffffff8136e43f>] ? idr_get_empty_slot+0x16f/0x3c0
> |  [<ffffffff81190053>] ? SyS_get_mempolicy+0x63/0x480
> |  [<ffffffff815458e4>] usb_probe_interface+0x1c4/0x2f0
> | [ .. ]
>
> In this (https://8n1.org/9516/836d) source file from 3.12.0 the Oops is
> triggered first time mce_request_packet() is run with urb_type ==
> MCEUSB_TX in mceusb_dev_probe() and ir->usb_ep_out is accessed.
>
> The actual problem is that the mceusb_dev_probe function and everything
> later on just assumes ep_out is set while ep_in is explicitly checked
> for null value in that same routine at line 1298.
>
> I'm no kernel hacker nor am i a USB expert so i'm not sure wether or not
> ep_out is mandatory but looking at the rest of the code it would seem the
> function should return -ENODEV as with ep_in == NULL.
> That's a bug, no?

It appears that way. Especially since the debug message says, "inbound 
and/or endpoint not found"

Your lsusb output shows no OUT endpoint (and bNumEndpoints 1).

> And why would there (suddenly) not be any 'out' endpoints? It still
> worked with 2.6 kernels and a hack[*].

Those 2.6 kernels used a completely different driver as you say below, 
so anything is possible.

> According to mceusb.c, mceusb.c changed a fair bit or was introduced
> since about Linux 3.6/3.8 which matches the fuzzy moment i remember this
> being broken. :)

The endpoint logic in the _probe function (ep_in == NULL, but not ep_out 
== NULL check), has been the same since the driver was introduced (see 
git annotate and commit 66e89522).

> The full lsusb output for this device is at https://8n1.org/9517/2163,
> Excerpt:
> | Device: ID 0471:206c Philips (or NXP) MCE IR Receiver - Spinel plusf0r ASUS
> |    Interface Descriptor:
> |      bInterfaceClass         3 Human Interface Device
> |      bInterfaceSubClass      1 Boot Interface Subclass
> |      bInterfaceProtocol      1 Keyboard
> |        HID Device Descriptor:
> |          bDescriptorType        33
> |          bNumDescriptors         1
> |          bDescriptorType        34 Report
> |         Report Descriptors:
> |           ** UNAVAILABLE **
> |      Endpoint Descriptor:
> |        bDescriptorType         5
> |        bEndpointAddress     0x81  EP 1 IN
>
> The '** UNAVAILABLE **'-bit seems alarming to me. Googling around
> indicates it's a common thing, though often it's in reports aparently
> about the same null pointer dereference. Which seems strange to me, but
> there's only a few threads in 2012 and i cant find much more than 'it
> does not work, help' with no real insightful answers.

The ** Unavailable ** will show if lsusb can't claim the interface, 
which it won't be able to do because It's claimed by the usbhid. If you 
rmmod usbhid, and then run lsusb (as root, or with proper permissions 
(udev)), you will see the report descriptor. (It pays to have a PS/2 KB 
around for this).

> [*]With the older 2.6 kernels i had a special 'driver' kernel module
> called hid-philips-asus.c (https://8n1.org/9519/bbf4) which seems fairly
> simple. Back then it was important to load it before usbhid.ko was
> loaded so it could claim the IR receiver before the kernels USBHID
> implementation would. There was no support from stock kernel, iirc.
> With 3.12.0 i dont see reason to assume this hackery is still necessary.

That driver uses the HID subsystem, and doesn't reference any endpoints 
directly, letting usbhid take care of it the right way (by sending 
Output reports on endpoint 0).

> Could someone nudge me in the right direction?

This may be a case of devices with the same PID behaving differently 
from one another (because manufacturers aren't always careful about such 
things). Your device doesn't have an OUT endpoint. It's as simple as 
that. There's no way it will work with this driver in this driver's 
current form. More curious is why it works for other people (and it 
clearly must work for someone).

I CC'd some people I found from scripts/get_maintainers.pl who will know 
more about it.

Alan.

