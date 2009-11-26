Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235AbZKZNyq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 08:54:46 -0500
Message-ID: <4B0E889C.9060405@redhat.com>
Date: Thu, 26 Nov 2009 11:54:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <6D934408-B713-49B6-A197-46CE663455AC@wilsonet.com>
In-Reply-To: <6D934408-B713-49B6-A197-46CE663455AC@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:
> On Nov 23, 2009, at 7:53 PM, Andy Walls wrote:
> 
>> On Mon, 2009-11-23 at 22:11 +0100, Christoph Bartelmus wrote:
> ...
>> I generally don't understand the LIRC aversion I perceive in this thread
>> (maybe I just have a skewed perception).  Aside for a video card's
>> default remote setup, the suggestions so far don't strike me as any
>> simpler for the end user than LIRC -- maybe I'm just used to LIRC.  LIRC
>> already works for both transmit and receive and has existing support in
>> applications such as MythTV and mplayer.
> 
> There's one gripe I agree with, and that is that its still not plug-n-play. 
> Something where udev auto-loads a sane default remote config for say, 
> mceusb transceivers, and the stock mce remote Just Works would be nice, 
> but auto-config is mostly out the window the second you involve transmitters 
> and universal remotes anyway. 

For several devices, an udev rule that auto-loads a sane default keymap does work.
Of course, this won't cover 100% of the usages, and I lirc is a very good way
of covering the holes.

> But outside of that, I think objections are largely philosophical -- 
> in a nutshell, the kernel has an input layer, remotes are input devices, 
> and lirc doesn't conform to input layer standards. 

Yes. I think this is mainly the issue. 

The other issue is how to migrate the existing drivers to a new API without 
causing regressions. If we decide that IR's that receive raw pulse/code
should use the raw input interface, this means that a large task force will be
needed to convert the existing drivers to use it.

> I do understand that argument, I just don't currently agree that all IR must
> go through the input layer before the drivers are acceptable for upstream -- 
> especially since lircd can reinject decoded key presses into the input layer via uinput.

IMHO, there are some scenarios for an upcoming kernel IR raw input interface:

1) as a temporary solution for merging lirc drivers, knowing in advance that it will
be later converted to the standard input API;

2) as a raw interface for some weird usages, with its usage limited to just a
few device drivers;

3) as the solution for all IR's that produces pulse/code raw sequences;

For (1), while it may make sense, we'll be creating an userspace API that is
meant to be stable, knowing in advance that it will be removed in a close
future.

IMHO, we should avoid (2), since it will be hard to define what is the "limited
usage", and I bet that it will evolute to (3) in a long term.

For (3), we need to consider the migration of the existing drivers.

By discarding scenario (2), this means that, in the long term, we'll need to either
migrate all existing out-of-tree lirc drivers to the standard input API interface 
(scenario 1) or to migrate the existing drivers to the raw input interface (scenario 3).

For me, scenario (1) is fine if we add the lirc drivers at drivers/staging.

>> I believe Jarod's intent is to have the LIRC components, that need to be
>> in kernel modules, moved into kernel mainline to avoid the headaches of
>> out of kernel driver maintenance.  I'm not sure it is time well spent
>> for developers, or end users, to develop yet another IR receive
>> implementation in addition to the ones we suffer with now.
> 
> Yeah, a fairly relevant factor in all this is that, despite not being in the linux 
> kernel source tree proper-like, the lirc drivers and lirc have been in use for many
> years by lots of users. The likes of Fedora, Debian, Ubuntu, SUSE, Mandriva, etc. 
> have all been shipping lirc drivers for years now. While lirc certainly isn't 
> perfect (its not always the easiest thing for users to set up), it has actually 
> proven itself pretty robust and useful in the field, once set up. The bulk of 
> breakage in lirc I've personally had to deal with has mostly come in the 
> form of kernel interface changes, which would definitely be mitigated by 
> not having to maintain the drivers out-of-tree any longer.
> 
> Now, I'm all for "improving" things and integrating better with the input 
> subsystem, but what I don't really want to do is break compatibility with the 
> existing setups on thousands (and thousands?) of MythTV boxes around the globe. 
> The lirc userspace can be pretty nimble. If we can come up with a shiny new way 
> that raw IR can be passed out through an input device, I'm pretty sure lirc 
> userspace can be adapted to handle that. If a new input-layer-based transmit 
> interface is developed, we can take advantage of that too. But there's already 
> a very mature lirc interface for doing all of this. So why not start with adding 
> things more or less as they exist right now and evolve the drivers into an 
> idealized form? Getting *something* into the kernel in the first place is a 
> huge step in that direction.

I agree. We should really move forward and add it to kernel as soon as possible,
and start to work on improving the IR support at the upstream kernel.

Jarold,

What do you think of adding lirc at staging while we discuss/improve the API's and lircd
support for the input event interface? Do you think this would work?

Cheers,
Mauro.
