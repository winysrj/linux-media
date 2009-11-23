Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:33326 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094AbZKWUX1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 15:23:27 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	<4B0AB60B.2030006@s5r6.in-berlin.de> <4B0AC8C9.6080504@redhat.com>
Date: Mon, 23 Nov 2009 21:23:30 +0100
In-Reply-To: <4B0AC8C9.6080504@redhat.com> (Mauro Carvalho Chehab's message of
	"Mon, 23 Nov 2009 15:39:21 -0200")
Message-ID: <m34oolrnwd.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

>> (This is no recommendation for lirc.  I have no idea whether a
>> pulse/space -> scancode -> keycode translation would be practical
>> there.)

It would, but not exactly in the present shape.

> For example, there are several bttv and saa7134 devices that polls (or receive
> IRQ interrupts) to detect pulses (and the absense of them) in order to create
> a pulse/space code. The conversion from pulse/space to scancode is done inside
> the driver, with the help of some generic routines and based on the protocol
> specifications.

Right. There are currently several problems (I'm quite familiar with
saa713x RC5 code): the one that it barely works and is not implemented
for most such "GPIO/IRQ-driven" cards (as of 2.6.29 or so). This could
be fixed, I even have a working though quick&dirty patch. Another: the
RC5 allows for groups and codes within groups. The mapping can only use
one group, and there can only be one mapping. These design limitations
mean it's unusable in many cases.

> Those devices where the decoding is done by software can support any
> IR protocols.

Yes, and there can be multiple remote controllers, and multiple code
groups within a remote.

> This can be solved by adding a few ioctls to enumerate the supported
> protocols and to select the one(s) that will be handled by the kernel
> driver.

The driver may have to handle many protocols simultaneously. This is not
a problem from a technical POV.
-- 
Krzysztof Halasa
