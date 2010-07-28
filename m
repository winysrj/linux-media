Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab0G1SPv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 14:15:51 -0400
Date: Wed, 28 Jul 2010 14:05:16 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: Can I expect in-kernel decoding to work out of box?
Message-ID: <20100728180516.GG26480@redhat.com>
References: <AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
 <AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
 <1280298606.6736.15.camel@maxim-laptop>
 <AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>
 <4C502CE6.80106@redhat.com>
 <1280327080.9175.58.camel@maxim-laptop>
 <AANLkTi=Ww9yvN5RWaXEi+cB2QaDWn34nSVGAvKxbJ2k2@mail.gmail.com>
 <4C505313.2010904@redhat.com>
 <AANLkTi=Ms0saB5b3+o9qQQYFNT96XStKCkVivB65q_33@mail.gmail.com>
 <4C50720D.5000301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C50720D.5000301@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 03:08:13PM -0300, Mauro Carvalho Chehab wrote:
> Em 28-07-2010 14:04, Jon Smirl escreveu:
> > On Wed, Jul 28, 2010 at 11:56 AM, Mauro Carvalho Chehab
> > <mchehab@redhat.com> wrote:
> >> Em 28-07-2010 11:41, Jon Smirl escreveu:
> >>
> >>> It's possible to build a Linux IR decoder engine that can be loaded
> >>> with the old LIRC config files.
> >>
> >> I think it is a good idea to have a decoder that works with such files anyway.
> > 
> > The recorder should use the Linux IR system to record the data. It
> > would confusing to mix the systems. Users need to be really sure that
> > the standard protocol decoders don't understand their protocol before
> > resorting to this. Any one in this situation should post their
> > recorded data so we can check for driver implementation errors.
> > 
> > An example: if you use irrecord on Sony remotes lirc always records
> > them in raw mode. The true problem here is that irrecord doesn't
> > understand that Sony remotes mix different flavors of the Sony
> > protocol on a single remote. This leads you to think that the Sony
> > protocol engine is broken when it really isn't. It's the irrecord tool
> > that is broken.  The kernel IR system will decode these remotes
> > correctly without resorting to raw mode.
> 
> A decoder like that should be a last-resort decoder, only in the
> cases where there's no other option.
> 
> >> There are some good reasons for that, as it would allow in-kernel support for
> >> protocols that may have some patent restrictions on a few countries that allow
> >> patents on software.
> > 
> > Are there any IR protocols less than 20 (or 17) years old?
> 
> Yes. This protocol is brand new:
> 	https://www.smkusa.com/usa/technologies/qp/
> 
> And several new devices are starting to accept it.

The US patent appears to have been filed in 1995 and granted in 1997, so
"brand new" is relative. ;)

http://www.freepatentsonline.com/5640160.html

We do have a few more years of being encumbered by it here in the US
though. :(

-- 
Jarod Wilson
jarod@redhat.com

