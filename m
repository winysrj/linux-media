Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0G1S24 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 14:28:56 -0400
Message-ID: <4C5076EE.3080102@redhat.com>
Date: Wed, 28 Jul 2010 15:29:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: Can I expect in-kernel decoding to work out of box?
References: <1280269990.21278.15.camel@maxim-laptop>	 <1280273550.32216.4.camel@maxim-laptop>	 <AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>	 <AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>	 <1280298606.6736.15.camel@maxim-laptop>	 <AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>	 <4C502CE6.80106@redhat.com>	 <AANLkTinCs7f6zF-tYZqJ49CAjNWF=2MPGh0VRuU=VLzq@mail.gmail.com>	 <1280327929.11072.24.camel@morgan.silverblock.net>	 <AANLkTikFfXx4NBB2z2UXNt5Kt-2QrvTfvK0nQhSSqw8v@mail.gmail.com>	 <4C504FDB.4070400@redhat.com> <1280336530.19593.52.camel@morgan.silverblock.net>
In-Reply-To: <1280336530.19593.52.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-07-2010 14:02, Andy Walls escreveu:
> On Wed, 2010-07-28 at 12:42 -0300, Mauro Carvalho Chehab wrote:
>> Em 28-07-2010 11:53, Jon Smirl escreveu:
>>> On Wed, Jul 28, 2010 at 10:38 AM, Andy Walls <awalls@md.metrocast.net> wrote:
>>>> On Wed, 2010-07-28 at 09:46 -0400, Jon Smirl wrote:
> 
>>> I recommend that all decoders initially follow the strict protocol
>>> rules. That will let us find bugs like this one in the ENE driver.
>>
>> Agreed.
> 
> Well... 
> 
> I'd possibly make an exception for the protocols that have long-mark
> leaders.  The actual long mark measurement can be far off from the
> protocol's specification and needs a larger tolerance (IMO).
> 
> Only allowing 0.5 to 1.0 of a protocol time unit tolerance, for a
> protocol element that is 8 to 16 protocol time units long, doesn't make
> too much sense to me.  If the remote has the basic protocol time unit
> off from our expectation, the error will likely be amplified in a long
> protocol elements and very much off our expectation.

We may adjust it as we note problems on it, but relaxing rules may cause
bad effects, so the better is to be more strict.

>> I think that the better is to add some parameters, via sysfs, to relax the
>> rules at the current decoders, if needed.
> 
> Is that worth the effort?  It seems like only going half-way to an
> ultimate end state.

Well, let's see first if this is needed. Then, we take the decisions case by case.

> <crazy idea>
> If you go through the effort of implementing fine grained controls
> (tweaking tolerances for this pulse type here or there), why not just
> implement a configurable decoding engine that takes as input:
> 
> 	symbol definitions
> 		(pulse and space length specifications and tolerances)
> 	pulse train states
> 	allowed state transitions
> 	gap length
> 	decoded output data length
> 
> and instantiates a decoder that follows a user-space provided
> specification?
> 
> The user can write his own decoding engine specification in a text file,
> feed it into the kernel, and the kernel can implement it for him.
> </crazy idea>

It is not a crazy idea, and perhaps this is the only way to work with certain
protocols, like Quatro Pulse (see my previous email).

But I think that we should still have the proper decoders for common
protocols and that we won't have any legal restriction to implement
a decoder. A generic decoder will be less efficient than 

> OK, maybe that is a little too much time and effort. ;)

Good point. Well, we'll need some volunteer to write such driver ;)

Cheers,
Mauro
