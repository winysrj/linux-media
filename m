Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287AbZKWRjp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 12:39:45 -0500
Message-ID: <4B0AC8C9.6080504@redhat.com>
Date: Mon, 23 Nov 2009 15:39:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain> <4B0AB60B.2030006@s5r6.in-berlin.de>
In-Reply-To: <4B0AB60B.2030006@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote:
> Krzysztof Halasa wrote:
>> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
>>
>>> Event input has the advantage that the keystrokes will provide an unique
>>> representation that is independent of the device.
>> This can hardly work as the only means, the remotes have different keys,
>> the user almost always has to provide customized key<>function mapping.
> 
> Modern input drivers in the mainline kernel have a scancode-to-keycode
> translation table (or equivalent) which can be overwritten by userspace.
> The mechanism to do that is the EVIOCSKEYCODE ioctl.

This mechanism is already used by all V4L drivers and several DVB drivers.

> (This is no recommendation for lirc.  I have no idea whether a
> pulse/space -> scancode -> keycode translation would be practical there.)

pulse/space -> scancode translation is already done by several existing drivers.

For example, there are several bttv and saa7134 devices that polls (or receive
IRQ interrupts) to detect pulses (and the absense of them) in order to create
a pulse/space code. The conversion from pulse/space to scancode is done inside
the driver, with the help of some generic routines and based on the protocol
specifications.

The conversion from the scancode to a keycode is done based on in-kernel keycode
tables that can be changed from userspace with EVIOCSKEYCODE ioctl.

I can't see any technical reason why not doing the same for the lirc drivers,
except for one issue:

Those devices where the decoding is done by software can support any IR protocols.
So, it is possible to buy a device with a NEC IR, and use a RC5 IR to control it.

However, currently, there's no way to inform the kernel to use a different algorithm
to translate the kernel.

This can be solved by adding a few ioctls to enumerate the supported protocols and
to select the one(s) that will be handled by the kernel driver.

Cheers,
Mauro
