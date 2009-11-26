Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbZKZMRO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 07:17:14 -0500
Message-ID: <4B0E71B6.4080808@redhat.com>
Date: Thu, 26 Nov 2009 10:16:54 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>	<4B0AB60B.2030006@s5r6.in-berlin.de> <4B0AC8C9.6080504@redhat.com> <m34oolrnwd.fsf@intrepid.localdomain>
In-Reply-To: <m34oolrnwd.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>>> (This is no recommendation for lirc.  I have no idea whether a
>>> pulse/space -> scancode -> keycode translation would be practical
>>> there.)
> 
> It would, but not exactly in the present shape.
> 
>> For example, there are several bttv and saa7134 devices that polls (or receive
>> IRQ interrupts) to detect pulses (and the absense of them) in order to create
>> a pulse/space code. The conversion from pulse/space to scancode is done inside
>> the driver, with the help of some generic routines and based on the protocol
>> specifications.
> 
> Right. There are currently several problems (I'm quite familiar with
> saa713x RC5 code): the one that it barely works and is not implemented
> for most such "GPIO/IRQ-driven" cards (as of 2.6.29 or so). This could
> be fixed, I even have a working though quick&dirty patch. Another: the
> RC5 allows for groups and codes within groups. The mapping can only use
> one group, and there can only be one mapping. These design limitations
> mean it's unusable in many cases.

This is a current limitation, since the saa713x code converts the RC5 code into a 7bits
scancode, by applying a mask. One of the reasons for that conversion is that the two 
ioctls that allows reading/changing the keycode table (EVIOCSKEYCODE and EVIOCGKEYCODE)
were implemented via a table with a fixed size of 128 entries.

We already have an implementation at the dvb-usb driver that uses a table without
such limits, where the IR scancode is completely stored there. So, you can create
any arbitrary scancode <--> keycode table there.

Technically, it is not hard to port this solution to the other drivers, but the issue
is that we don't have all those IR's to know what is the complete scancode that
each key produces. So, the hardest part is to find a way for doing it without
causing regressions, and to find a group of people that will help testing the new way.

Maybe one alternative would be to add a modprobe parameter at the converted drivers
to allow them to work with the old behavior, after their migration.

>> Those devices where the decoding is done by software can support any
>> IR protocols.
> 
> Yes, and there can be multiple remote controllers, and multiple code
> groups within a remote.
> 
>> This can be solved by adding a few ioctls to enumerate the supported
>> protocols and to select the one(s) that will be handled by the kernel
>> driver.
> 
> The driver may have to handle many protocols simultaneously. This is not
> a problem from a technical POV.

There are 3 different situations:
	1) hardware where you can support multiple protocols at the same time;
	2) hardware that supports one programmable protocol;
	3) hardware that support just one (or a limited set) of protocols.

In general, (1) applies only to those devices that outputs a raw pulse/space code,
where they just connect the IR sensor to a generic I/O pin and let the software
to decode the code. This is the case of most of cheapest devices. Yet, you can
find some cheap devices with low-cost micro-controllers with a dedicated firmware
on its ROM, doing (2).

The most commonly found hardware, in general have a chip to decode IR pulse/space
sequences, converting it on a scancode and implementing (3).

That's said, a raw input interface, only fits on case (1). On the other hand, the
existing input API works for all types of IR. However, we need to add the ioctls
to allow protocol selection, to better handle (1) and (3).

Cheers,
Mauro.
