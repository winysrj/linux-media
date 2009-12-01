Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZLATBN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Dec 2009 14:01:13 -0500
Message-ID: <4B1567D8.7080007@redhat.com>
Date: Tue, 01 Dec 2009 17:00:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com> <1259682428.18599.10.camel@maxim-laptop> <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com> <4B154C54.5090906@redhat.com> <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com> <4B155288.1060509@redhat.com> <20091201175400.GA19259@core.coreip.homeip.net>
In-Reply-To: <20091201175400.GA19259@core.coreip.homeip.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov wrote:
> On Tue, Dec 01, 2009 at 03:29:44PM -0200, Mauro Carvalho Chehab wrote:
>> For sure we need to add an EVIOSETPROTO ioctl to allow the driver 
>> to change the protocol in runtime.
>>
> 
> Mauro,
> 
> I think this kind of confuguration belongs to lirc device space,
> not input/evdev. This is the same as protocol selection for psmouse
> module: while it is normally auto-detected we have sysfs attribute to
> force one or another and it is tied to serio device, not input
> device.

Dmitry,

This has nothing to do with the raw interface nor with lirc. This problem 
happens with the evdev interface and already affects the in-kernel drivers.

In this case, psmouse is not a good example. With a mouse, when a movement
occurs, you'll receive some data from its port. So, a software can autodetect
the protocol. The same principle can be used also with a raw pulse/space
interface, where software can autodetect the protocol.

However, with hardware decoded IR's, when the hardware detects a code
from the wrong protocol, it simply discards the unknown protocol code 
without any advice. So, there's no way to autodetect. 

You need to set the right protocol before enabling the hardware decoder,
or no scan code will be produced at all.

Also, the same hardware can work with more than one protocol, on several cases,
but the list is generally limited to a few different protocols. So, a way
to enumerate what protocols are supported by the hardware is needed.

Let me give you a practical example: I have here a a Pixelview SBTVD USB stick,
for ISDB-T digital TV standard.

Pixelview provides a very inexpensive and limited NEC protocol-based IR, with a dozen
of keys. 

However, the hardware of the stick has the same components that are also present
on similar devices made by other manufacturers, with are shipped with different IR's,
running different protocols.

The same hardware design is also used with other models that work with DVB or ATSC
video standards.

For example, the same dib0700 driver supports this ISDB-T device and, for example,
a Hauppauge Nova-T DVB stick, that used a Hauppauge Grey IR, based on RC5 protocol.

Due to the lack of an evdev API call to select the IR protocol, an ugly modprobe 
parameter is provided to select the protocol at module boot time.

So, if people want to use the original NEC protocol-based IR, they need to do:
	modprobe dvb_usb_dib0700 dvb_usb_dib0700_ir_proto=0

But, if they want to use a decent IR, even having the keycodes for the RC5
remotes there, the driver needs to be reloaded with a different parameter, to
change the hardware to use a different decoder.

This is not an isolated case of this driver. The same problem happens will all other
in-kernel drivers at drivers/media.

Due to the lack of an API for it, each driver has their own way to handle the
protocols, but basically, on almost all drivers, even supporting different protocols,
the driver limits the usage of just the protocol provided by the shipped remote.

To solve this, we really need to extend evdev API to do 3 things: enumberate the
supported protocols, get the current protocol(s), and select the protocol(s) that
will be used by a newer table.

Cheers,
Mauro.
