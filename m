Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:39059 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZK1SqA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 13:46:00 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Christoph Bartelmus <christoph@bartelmus.de>,
	jarod@wilsonet.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <9e4733910911280845y5cf06836l1640e9fc8b1740cf@mail.gmail.com>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	 <4B104971.4020800@s5r6.in-berlin.de>
	 <1259370501.11155.14.camel@maxim-laptop>
	 <m37hta28w9.fsf@intrepid.localdomain>
	 <1259419368.18747.0.camel@maxim-laptop>
	 <m3zl66y8mo.fsf@intrepid.localdomain>
	 <1259422559.18747.6.camel@maxim-laptop>
	 <9e4733910911280845y5cf06836l1640e9fc8b1740cf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 20:45:59 +0200
Message-ID: <1259433959.3658.0.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-11-28 at 11:45 -0500, Jon Smirl wrote: 
> On Sat, Nov 28, 2009 at 10:35 AM, Maxim Levitsky
> <maximlevitsky@gmail.com> wrote:
> > On Sat, 2009-11-28 at 16:25 +0100, Krzysztof Halasa wrote:
> >> Maxim Levitsky <maximlevitsky@gmail.com> writes:
> >>
> >> >> And that's good. Especially for a popular and simple protocol such as
> >> >> RC5.
> >> >> Actually, it's not about adding the decoder. It's about fixing it.
> >> >> I can fix it.
> >> >
> >> > This is nonsense.
> >>
> >> You forgot to say why do you think so.
> >
> > Because frankly, I am sick of this discussion.
> > Generic decoder that lirc has is actually much better and more tolerant
> > that protocol specific decoders that you propose,
> 
> Porting the decoder engine from lirc into the kernel is also a possibility.
> 
> I'm asking to have an architecture design discussion, not to pick one
> of the various implementations. This is something that we have to live
> with for twenty years and it is a giant pain to change if we get wrong
> initially.
> 
> > You claim you 'fix' the decoder, right?
> > But what about all these lirc userspace drivers?
> > How they are supposed to use that 'fixed' decoder.
> 
> Some of that user space hardware belongs in the trash can and will
> never work reliably in a modern system. For example - sitting in a
> tight user space loop reading the DTS bit from a serial port or
> parallel port and then using the system clock to derive IR timings.
> That process is going to be inaccurate or it is going to make video
> frames drop. Big banging from user space is completely unreliable.
> 
> If you really want to use your microphone input as a DAC channel, run
> a little app that reads the ALSA input and converts it to a timing
> stream and then inject this data into the kernel input system using
> uevent.
> 
> Both of these are hobbyist class solutions. They are extremely cheap
> but they are unreliable and create large CPU loads.  But some people
> want to use a $300 CPU to eliminate $2 worth of IR hardware. This type
> of hardware will continue to work via event injection. But neither of
> these solutions belong in the kernel.


> 
> What are other examples of user space IR drivers?
> 

many libusb based drivers?

Regards,
Maxim Levitsky

