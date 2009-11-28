Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50236 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZK1Q0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 11:26:16 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <christoph@bartelmus.de>,
	jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <m3r5riy7py.fsf@intrepid.localdomain>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	 <4B104971.4020800@s5r6.in-berlin.de>
	 <1259370501.11155.14.camel@maxim-laptop>
	 <m37hta28w9.fsf@intrepid.localdomain>
	 <1259419368.18747.0.camel@maxim-laptop>
	 <m3zl66y8mo.fsf@intrepid.localdomain>
	 <1259422559.18747.6.camel@maxim-laptop>
	 <m3r5riy7py.fsf@intrepid.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 18:26:15 +0200
Message-ID: <1259425575.19883.13.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-11-28 at 16:44 +0100, Krzysztof Halasa wrote: 
> Maxim Levitsky <maximlevitsky@gmail.com> writes:
> 
> > Generic decoder that lirc has is actually much better and more tolerant
> > that protocol specific decoders that you propose,
> 
> Actually, it is not the case. Why do you think it's better (let alone
> "much better")? Have you at least seen my RC5 decoder?
Because userspace decoder is general, it doesn't depend on exact timing,
as long as pulses vary in size it can distinguish between keys, and that
is enough.
I didn't use your decoder, so in that particular case I don't know.


> 
> > You claim you 'fix' the decoder, right?
> 
> Sure.
Unless you put it againt an inaccurate decoder....
Ask the lirc developers.


> 
> > But what about all these lirc userspace drivers?
> 
> Nothing. They are not relevant and obviously have to use lircd.
> If you can have userspace driver, you can have lircd as well.
> 
> > How they are supposed to use that 'fixed' decoder.
> 
> They are not.
> 
> Is it a problem for you?
> How is your keyboard supposed to use scanner driver?
Another piece of off-topic nonsense.

I have a VCR remote, ok?
I have a pulse/space decoder in my notebook, I have created a config
file for that, and I did a lot of customizations, because this remote
isn't supposed to be used with PC.

Now, I also have a desktop.
I don't have a receiver there, but someday I arrange some sort of it.
I have an IR dongle in the closed, its raw IR diode.
Probably with few components I could connect it to soundcard (and I have
3 independent inputs, of which only one is used)
And then I will use alsa input driver.

Now I had ended up with 2 different configurations, one for the kernel,
another for the lirc.
Great, isn't it?

The point is again, I *emphasize* that as long as lirc is used to decode
all but ready to use scancodes, everything is kept in one place.
Both decode algorithms and configuration.

For ready to use scancode, a hardcoded table can be used in kernel to
translate to input events.

How hard to understand that?



Also, I repeat again, that this discussion *IS NOT* about userspace api,
its about who decodes the input, kernel or lirc.

Raw access to timing will be aviable this way or another, ether as
primary way of decoding for lirc, or as a debug measure.

Regards,
Maxim Levitsky


