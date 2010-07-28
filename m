Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab0G1P3b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 11:29:31 -0400
Date: Wed, 28 Jul 2010 11:18:58 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: Can I expect in-kernel decoding to work out of box?
Message-ID: <20100728151858.GA26480@redhat.com>
References: <1280269990.21278.15.camel@maxim-laptop>
 <1280273550.32216.4.camel@maxim-laptop>
 <AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
 <AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
 <1280298606.6736.15.camel@maxim-laptop>
 <AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>
 <4C502CE6.80106@redhat.com>
 <1280327080.9175.58.camel@maxim-laptop>
 <AANLkTi=Ww9yvN5RWaXEi+cB2QaDWn34nSVGAvKxbJ2k2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=Ww9yvN5RWaXEi+cB2QaDWn34nSVGAvKxbJ2k2@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 10:41:27AM -0400, Jon Smirl wrote:
> On Wed, Jul 28, 2010 at 10:24 AM, Maxim Levitsky
...
> > You are right that my remote has  JVC protocol. (at least I am sure now
> > it hasn't NEC, because repeat looks differently).
> >
> > My remote now actually partially works with JVC decoder, it decodes
> > every other keypress.
> >
> > Still, no repeat is supported.
> 
> It probably isn't implemented yet. Jarod has been focusing more on
> getting the basic decoders to work.

More specifically, getting the basic decoders to work with very specific
hardware -- i.e., the mceusb transceivers, and primarily focused only on
RC-6(A) decode w/the mceusb bundled remotes. That, and getting the lirc
bridge driver working for both rx and tx.

Basically, my plan of attack has been to get enough bits in place that we
have a "reference implementation", if you will, of a driver that supports
all in-kernel decoders and the lirc interface, complete with the ability
to do tx[*], and from there, then we can really dig into the in-kernel
decoders and/or work on porting additional drivers to ir-core. I'm more
focused on porting additional drivers to ir-core at the moment than I am
on testing all of the protocol decoders right now.

[*] we still don't have an ir-core "native" tx method, but tx on the
mceusb works quite well using the lirc bridge plugin

-- 
Jarod Wilson
jarod@redhat.com

