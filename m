Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:35039 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbZK1Qo1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 11:44:27 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <christoph@bartelmus.de>,
	jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 	system?
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	<4B104971.4020800@s5r6.in-berlin.de>
	<1259370501.11155.14.camel@maxim-laptop>
	<m37hta28w9.fsf@intrepid.localdomain>
	<1259419368.18747.0.camel@maxim-laptop>
	<m3zl66y8mo.fsf@intrepid.localdomain>
	<1259422559.18747.6.camel@maxim-laptop>
	<m3r5riy7py.fsf@intrepid.localdomain>
	<1259425575.19883.13.camel@maxim-laptop>
Date: Sat, 28 Nov 2009 17:44:30 +0100
In-Reply-To: <1259425575.19883.13.camel@maxim-laptop> (Maxim Levitsky's
	message of "Sat, 28 Nov 2009 18:26:15 +0200")
Message-ID: <m3k4xay4y9.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maxim Levitsky <maximlevitsky@gmail.com> writes:

>> Actually, it is not the case. Why do you think it's better (let alone
>> "much better")? Have you at least seen my RC5 decoder?
> Because userspace decoder is general, it doesn't depend on exact timing,
> as long as pulses vary in size it can distinguish between keys, and that
> is enough.
> I didn't use your decoder, so in that particular case I don't know.

I thought so.
FYI: a sane RC5 decoder doesn't depend on exact timing. Even seen
a multi-function remote can control many different devices like TV,
VCR, DVD and so on? From different manufacturers etc.

> Unless you put it againt an inaccurate decoder....
> Ask the lirc developers.

Not sure what do you mean.

> I have a VCR remote, ok?
> I have a pulse/space decoder in my notebook, I have created a config
> file for that, and I did a lot of customizations, because this remote
> isn't supposed to be used with PC.

There is no such thing as "being supposed to be used with PC".
A space/mark receiver can receive data from any remote.

> Now, I also have a desktop.
> I don't have a receiver there, but someday I arrange some sort of it.
> I have an IR dongle in the closed, its raw IR diode.
> Probably with few components I could connect it to soundcard (and I have
> 3 independent inputs, of which only one is used)
> And then I will use alsa input driver.
>
> Now I had ended up with 2 different configurations, one for the kernel,
> another for the lirc.
> Great, isn't it?

If you want such setup - why not?
If you don't - you can use lirc in both cases.

> The point is again, I *emphasize* that as long as lirc is used to decode
> all but ready to use scancodes, everything is kept in one place.
> Both decode algorithms and configuration.

Then keep it that way and let others use what they think is best for
them.

Now how hard is it to understand that?

> Also, I repeat again, that this discussion *IS NOT* about userspace api,
> its about who decodes the input, kernel or lirc.

That could be the case if you were limited to "or". But we can do both.
-- 
Krzysztof Halasa
