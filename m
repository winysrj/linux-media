Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:63863 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZK1Pf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 10:35:59 -0500
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
In-Reply-To: <m3zl66y8mo.fsf@intrepid.localdomain>
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
	 <4B104971.4020800@s5r6.in-berlin.de>
	 <1259370501.11155.14.camel@maxim-laptop>
	 <m37hta28w9.fsf@intrepid.localdomain>
	 <1259419368.18747.0.camel@maxim-laptop>
	 <m3zl66y8mo.fsf@intrepid.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 17:35:59 +0200
Message-ID: <1259422559.18747.6.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-11-28 at 16:25 +0100, Krzysztof Halasa wrote: 
> Maxim Levitsky <maximlevitsky@gmail.com> writes:
> 
> >> And that's good. Especially for a popular and simple protocol such as
> >> RC5.
> >> Actually, it's not about adding the decoder. It's about fixing it.
> >> I can fix it.
> >
> > This is nonsense.
> 
> You forgot to say why do you think so.

Because frankly, I am sick of this discussion.
Generic decoder that lirc has is actually much better and more tolerant
that protocol specific decoders that you propose,

You claim you 'fix' the decoder, right?
But what about all these lirc userspace drivers?
How they are supposed to use that 'fixed' decoder.



