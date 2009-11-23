Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbZKWR3J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 12:29:09 -0500
Message-ID: <4B0AC65C.806@redhat.com>
Date: Mon, 23 Nov 2009 15:29:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Jarod Wilson <jarod@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200956.33391.jarod@redhat.com>	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
In-Reply-To: <m36391tjj3.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>> Event input has the advantage that the keystrokes will provide an unique
>> representation that is independent of the device.
> 
> This can hardly work as the only means, the remotes have different keys,
> the user almost always has to provide customized key<>function mapping.

Key mapping can be easily changed via input interface, as noticed by others.

>> Considering the common case
>> where the lirc driver will be associated with a media input device, the
>> IR type can be detected automatically on kernel. However, advanced users may
>> opt to use other IR types than what's provided with the device they
>> bought.
> 
> I think most users would want to do that, though I don't have hard
> numbers of course. Why use a number of RCs simultaneously while one will
> do?

If you're building a dedicated hardware to act as a MCE, it makes sense to
use just one IR to control your TV and your hardware, but the common usage
is to add a TV board or stick to your desktop to see TV. For this,
the standard IR fits well.

>> It should also be noticed that not all the already-existing IR drivers
>> on kernel can provide a lirc interface, since several devices have
>> their own IR decoding chips inside the hardware.
> 
> Right. I think they shouldn't use lirc interface, so it doesn't matter.

If you see patch 3/3, of the lirc submission series, you'll notice a driver
that has hardware decoding, but, due to lirc interface, the driver generates
pseudo pulse/space code for it to work via lirc interface.

It is very bad to have two interfaces for the same thing, because people
may do things like that.

Also, there are some cases where the same V4L driver can receive IR scancodes
directly for one board, while for others, it needs to get pulse/space decoding.

So, it makes sense to have an uniform way for doing it.

>> 2) create a lirc kernel API, and have a layer there to decode IR
>> protocols and output them via the already existing input layer. In
>> this case, all we need to do, in terms of API, is to add a way to set
>> the IR protocol that will be decoded, and to enumberate the
>> capabilities. The lirc API, will be an in-kernel API to communicate
>> with the devices that don't have IR protocols decoding capabilities
>> inside the hardware.
> 
> I think this makes a lot of sense.
> But: we don't need a database of RC codes in the kernel (that's a lot of
> data, the user has to select the RC in use anyway so he/she can simply
> provide mapping e.g. RC5<>keycode).

This is an interesting discussion. We currently have lots of such tables in
kernel, but it can be a good idea to have it loaded by udev during boot time.

> We do need RCx etc. protocols implementation in the kernel for the input
> layer.

Yes. We already have this. See bttv, saa7134 and cx88 for several of such
protocol decoding. 

> "lirc" interface: should we be sending time+on/off data to userspace, or
> the RC5 etc. should be implemented in the kernel? There is (?) only
> a handful of RC protocols, implementing them in the kernel and passing
> only information such as proto+group+code+press/release etc. should be
> more efficient.
> 
> Perhaps the raw RCx data could be sent over the input layer as well?
> Something like the raw keyboard codes maybe?
> 
> We need to handle more than one RC at a time, of course.

Are you meaning that we should do more than one RC per input event interface?
If so, why do you think we need to handle more than one IR protocol at the same time?
I think this will just make the driver more complex without need. Also, I'm
not sure if this would work well for all protocols.

>> So, the basic question that should be decided is: should we create a new
>> userspace API for raw IR pulse/space
> 
> I think so, doing the RCx proto handling in the kernel (but without
> RCx raw code <> key mapping in this case due to multiple controllers
> etc.). Though it could probably use the input layer as well(?).

Since the key mapping table can be changed anytime, I don't see this as an issue.
If we are doing protocol handling in kernel, we just need to add some extensions
to the existing input event API to properly handle the IR protocol type.

> I think we shouldn't at this time worry about IR transmitters.

Agreed. We can postpone this discussion after solving the IR receivers

Cheers,
Mauro.
