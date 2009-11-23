Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:49307 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZKWOOy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 09:14:54 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com>
Date: Mon, 23 Nov 2009 15:14:56 +0100
In-Reply-To: <4B0A81BF.4090203@redhat.com> (Mauro Carvalho Chehab's message of
	"Mon, 23 Nov 2009 10:36:15 -0200")
Message-ID: <m36391tjj3.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> Event input has the advantage that the keystrokes will provide an unique
> representation that is independent of the device.

This can hardly work as the only means, the remotes have different keys,
the user almost always has to provide customized key<>function mapping.

> Considering the common case
> where the lirc driver will be associated with a media input device, the
> IR type can be detected automatically on kernel. However, advanced users may
> opt to use other IR types than what's provided with the device they
> bought.

I think most users would want to do that, though I don't have hard
numbers of course. Why use a number of RCs simultaneously while one will
do?

> It should also be noticed that not all the already-existing IR drivers
> on kernel can provide a lirc interface, since several devices have
> their own IR decoding chips inside the hardware.

Right. I think they shouldn't use lirc interface, so it doesn't matter.

> 2) create a lirc kernel API, and have a layer there to decode IR
> protocols and output them via the already existing input layer. In
> this case, all we need to do, in terms of API, is to add a way to set
> the IR protocol that will be decoded, and to enumberate the
> capabilities. The lirc API, will be an in-kernel API to communicate
> with the devices that don't have IR protocols decoding capabilities
> inside the hardware.

I think this makes a lot of sense.
But: we don't need a database of RC codes in the kernel (that's a lot of
data, the user has to select the RC in use anyway so he/she can simply
provide mapping e.g. RC5<>keycode).

We do need RCx etc. protocols implementation in the kernel for the input
layer.

"lirc" interface: should we be sending time+on/off data to userspace, or
the RC5 etc. should be implemented in the kernel? There is (?) only
a handful of RC protocols, implementing them in the kernel and passing
only information such as proto+group+code+press/release etc. should be
more efficient.

Perhaps the raw RCx data could be sent over the input layer as well?
Something like the raw keyboard codes maybe?

We need to handle more than one RC at a time, of course.

> So, the basic question that should be decided is: should we create a new
> userspace API for raw IR pulse/space

I think so, doing the RCx proto handling in the kernel (but without
RCx raw code <> key mapping in this case due to multiple controllers
etc.). Though it could probably use the input layer as well(?).

> or it would be better to standardize it
> to always use the existing input layer?

I'd optionally provide a keyboard-alike input layer interface, with
mappings (proto + raw code <> key) provided by userspace program.
This should also work with multiple remotes.

Then the existing drivers (such as saa713x with GPIO+IRQ-driven IR
receiver (IR signal on/off generating IRQ)) should be converted.

I think we shouldn't at this time worry about IR transmitters.
-- 
Krzysztof Halasa
