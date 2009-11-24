Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:46894
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858AbZKXNcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 08:32:51 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1259024037.3871.36.camel@palomino.walls.org>
Date: Tue, 24 Nov 2009 08:32:40 -0500
Cc: Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Content-Transfer-Encoding: 8BIT
Message-Id: <6D934408-B713-49B6-A197-46CE663455AC@wilsonet.com>
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org>
To: Andy Walls <awalls@radix.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 23, 2009, at 7:53 PM, Andy Walls wrote:

> On Mon, 2009-11-23 at 22:11 +0100, Christoph Bartelmus wrote:
...
> I generally don't understand the LIRC aversion I perceive in this thread
> (maybe I just have a skewed perception).  Aside for a video card's
> default remote setup, the suggestions so far don't strike me as any
> simpler for the end user than LIRC -- maybe I'm just used to LIRC.  LIRC
> already works for both transmit and receive and has existing support in
> applications such as MythTV and mplayer.

There's one gripe I agree with, and that is that its still not plug-n-play. Something where udev auto-loads a sane default remote config for say, mceusb transceivers, and the stock mce remote Just Works would be nice, but auto-config is mostly out the window the second you involve transmitters and universal remotes anyway. But outside of that, I think objections are largely philosophical -- in a nutshell, the kernel has an input layer, remotes are input devices, and lirc doesn't conform to input layer standards. I do understand that argument, I just don't currently agree that all IR must go through the input layer before the drivers are acceptable for upstream -- especially since lircd can reinject decoded key presses into the input layer via uinput.

> I believe Jarod's intent is to have the LIRC components, that need to be
> in kernel modules, moved into kernel mainline to avoid the headaches of
> out of kernel driver maintenance.  I'm not sure it is time well spent
> for developers, or end users, to develop yet another IR receive
> implementation in addition to the ones we suffer with now.

Yeah, a fairly relevant factor in all this is that, despite not being in the linux kernel source tree proper-like, the lirc drivers and lirc have been in use for many years by lots of users. The likes of Fedora, Debian, Ubuntu, SUSE, Mandriva, etc. have all been shipping lirc drivers for years now. While lirc certainly isn't perfect (its not always the easiest thing for users to set up), it has actually proven itself pretty robust and useful in the field, once set up. The bulk of breakage in lirc I've personally had to deal with has mostly come in the form of kernel interface changes, which would definitely be mitigated by not having to maintain the drivers out-of-tree any longer.

Now, I'm all for "improving" things and integrating better with the input subsystem, but what I don't really want to do is break compatibility with the existing setups on thousands (and thousands?) of MythTV boxes around the globe. The lirc userspace can be pretty nimble. If we can come up with a shiny new way that raw IR can be passed out through an input device, I'm pretty sure lirc userspace can be adapted to handle that. If a new input-layer-based transmit interface is developed, we can take advantage of that too. But there's already a very mature lirc interface for doing all of this. So why not start with adding things more or less as they exist right now and evolve the drivers into an idealized form? Getting *something* into the kernel in the first place is a huge step in that direction.

-- 
Jarod Wilson
jarod@wilsonet.com



