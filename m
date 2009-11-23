Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448AbZKWMgS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 07:36:18 -0500
Message-ID: <4B0A81BF.4090203@redhat.com>
Date: Mon, 23 Nov 2009 10:36:15 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: [RFC] Should we create a raw input interface for IR's ? - Was: Re:
 [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com> <200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
In-Reply-To: <4B0A765F.7010204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:

> Jarod Wilson wrote:
> 1) As I said before, this code adds a new input API. So, you should
> get input people's ack about it. It seems fine for me;

>> Index: b/drivers/input/lirc/lirc.h
>> ===================================================================
>> --- /dev/null
>> +++ b/drivers/input/lirc/lirc.h
> 
> Hmm... as you're defining the kernel userspace interface, it would
> be better to put the header under include/linux.

It seems that I ran away from one important discussion here...

In fact, it seemed better to start a thread to discuss the API issues in
separate, an then adequate the code to do whatever decided.

-

The way the out-of-tree lirc driver works is by outputing (and inputing)
a raw sequence of pulses and spaces that have several different IR protocols,
like NEC, RC4, RC5, RC6 and pulse-distance protocols. On the other hand,
the current Input event interface (and the IR drivers at V4L/DVB code) does
is to have in-kernel code that converts those sequences or pulse/space into
a keystroke representation, outputing it to userspace.

To make things a little more complicated, it is also possible for some devices
to output IR codes. Let's first discuss the IR input case. IMO, whatever we define
for input, we should do also for output.

There's some advantages and disadvantages of both strategies, being the most
notable ones:

Raw pulse/space allows reception of IR's from all different variations of
the IR protocols. However:
	it means a more complex setup at userspace, since the user must 
use a daemon to decode IR code;
	user must inform the IR type and the kernel driver that will receive
those keystrokes.

Event input has the advantage that the keystrokes will provide an unique
representation that is independent of the device. Considering the common case
where the lirc driver will be associated with a media input device, the
IR type can be detected automatically on kernel. However, advanced users may
opt to use other IR types than what's provided with the device they bought.

It should also be noticed that not all the already-existing IR drivers on kernel can
provide a lirc interface, since several devices have their own IR decoding chips
inside the hardware. On some cases, the hardware can be programmed to receive more
than one IR protocol type, where on others, the manufacturer provides IR decoding
capabilities only for the protocol they decided to provide together with their
hardware.

IMO, there are two different approaches that can be taken:

1) Just add lirc API as-is and let's have two different ways to get IR events
on kernel, and have two different API's for IR;

2) create a lirc kernel API, and have a layer there to decode IR protocols and
output them via the already existing input layer. In this case, all we need to do,
in terms of API, is to add a way to set the IR protocol that will be decoded, 
and to enumberate the capabilities. The lirc API, will be an in-kernel API to
communicate with the devices that don't have IR protocols decoding capabilities
inside the hardware.

So, the basic question that should be decided is: should we create a new
userspace API for raw IR pulse/space or it would be better to standardize it
to always use the existing input layer?

Comments?

Cheers,
Mauro
