Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZK3QTa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 11:19:30 -0500
Message-ID: <4B13F075.2090806@redhat.com>
Date: Mon, 30 Nov 2009 14:19:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Ray Lee <ray-lk@madrabbit.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jon Smirl <jonsmirl@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>	 <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>	 <m3aay6y2m1.fsf@intrepid.localdomain>	 <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>	 <1259469121.3125.28.camel@palomino.walls.org>	 <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>	 <1259515703.3284.11.camel@maxim-laptop>	 <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>	 <1259537732.5231.11.camel@palomino.walls.org> <4B13B2FA.4050600@redhat.com> <1259585852.3093.31.camel@palomino.walls.org>
In-Reply-To: <1259585852.3093.31.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:

> Nonetheless I'd still rather debug a problem with a dead process in
> userspace than an oops or panic (not that an end user cares) and avoid
> the risk of filesystem corruption.

Considering my experience adding in-kernel support for IR's, I'd say that
in general, a driver does some things:

1) it polls or waits IRQ's for an IR event. On raw IR devices, the read value
means a mark or a space;
2) it counts the timings between each pulse, and pulse/space duration;
3) it runs a protocol decoding logic that, based on pulse/space duration, one
   scancode is produced;
4) it does a table lookup to convert the scancode into the corresponding keycode;
5) it generates an evdev event.

Steps 2 and 3 happen only when the device doesn't have hardware decoding capabilities.
For devices with hardware decoding, the polling/IRQ process already retrieves a scancode.

Based on my experience, I can say that, from the above logic, the one
where you're more likely to generate an OOPS is at the first one, 
where you need to do the proper memory barriers for example to avoid
unregistering an IR while you're in the middle of an IRQ or pull handling.
In the case of IRQ, you'll also need to take care to not sleep, since you're
in interrupt mode.

If you're outputing raw pulse/space to userspace (a lirc-like raw interface), 
you'll still need to do steps (1) and (2) in kernel, and doing a logic close
to (5) to output an event to userspace.

So, the basic difference is that you won't run the decoder (3) nor do a table lookup (4).

The logic for (4) is trivial (a simple a table lookup). If you do a mistake
there, the bug will likely arise at the development time. Also, if you're not able
to write a proper code to get a value from a table, you shouldn't be trying
to write a driver anyway.

The logic for (3) is as simple as identifying the length of a pulse and the length of
the spaces. Depending on the length, it will produce a zero or one. Pure integer math.
The only risk of such logic is if you try to divide by zero. Except of that, this type
of code shouldn't cause any OOPS or panic.

Also, for (3) and (4), it is very easy to write it first on userspace (if you feel
more comfortable on doing so) and, after doing enough testing, add the same code to
kernelspace.

Cheers,
Mauro.



