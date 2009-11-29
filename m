Return-path: <linux-media-owner@vger.kernel.org>
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:48255 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbZK2C4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 21:56:31 -0500
From: Mike Lampard <mike@mtgambier.net>
Reply-To: mike@mtgambier.net
To: Jon Smirl <jonsmirl@gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR system?
Date: Sun, 29 Nov 2009 13:17:03 +1030
Cc: Christoph Bartelmus <christoph@bartelmus.de>, jarod@wilsonet.com,
	awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
References: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
In-Reply-To: <9e4733910911270757j648e39ecl7487b7e6c43db828@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911291317.03612.mike@mtgambier.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 28 Nov 2009 02:27:59 am Jon Smirl wrote:
> On Fri, Nov 27, 2009 at 2:45 AM, Christoph Bartelmus
> 
> <christoph@bartelmus.de> wrote:
> > Hi Mauro,
> >
> > on 26 Nov 09 at 14:25, Mauro Carvalho Chehab wrote:
> >> Christoph Bartelmus wrote:
> >
> > [...]
> >
> >>> But I'm still a bit hesitant about the in-kernel decoding. Maybe it's
> >>> just because I'm not familiar at all with input layer toolset.
> >
> > [...]
> >
> >> I hope it helps for you to better understand how this works.
> >
> > So the plan is to have two ways of using IR in the future which are
> > incompatible to each other, the feature-set of one being a subset of the
> > other?
> 
> Take advantage of the fact that we don't have a twenty year old legacy
> API already in the kernel. Design an IR API that uses current kernel
> systems. Christoph, ignore the code I wrote and make a design proposal
> that addresses these goals...
> 
> 1) Unified input in Linux using evdev. IR is on equal footing with
> mouse and keyboard.

I think this a case where automating setup can be over-emphasised (in the 
remote-as-keyboard case).

Apologies in advance if I've misunderstood the idea of utilising the 'input 
subsystem' for IR.  If the plan is to offer dedicated IR events via a yet-to-
be-announced input event subsystem and to optionally disallow acting as a 
keyboard via a module option or similar then please ignore the following.

Whilst having remotes come through the input subsystem might be 'the correct 
thing' from a purely technical standpoint, as an end-user I find the use-case 
for remotes completely different in one key aspect:  Keyboards and mice are 
generally foreground-app input devices, whereas remotes are often controlling 
daemons sitting in the background piping media through dedicated devices.  As 
an example I have a VDR instance running in the background on my desktop 
machine outputting to a TV in another room via a pci mpeg decoder - I 
certainly don't want the VDR remote control interacting with my X11 desktop in 
any way unless I go out of my way to set it up to do so, nor do I want it 
interacting with other applications (such as MPD piping music around the 
house) that are controlled via other remotes in other rooms unless specified.

Setting this up with Lircd was easy, how would a kernel-based proposal handle 
this?

Regards
Mike


> 2) plug and play for basic systems - you only need an external app for
>  scripting 
>  3) No special tools - use mkdir, echo, cat, shell scripts to
>  build maps 
>  4) Use of modern Linux features like sysfs, configfs and udev.
> 5) Direct multi-app support - no daemon
> 6) Hide timing data from user as much as possible.
> 
> What are other goals for this subsystem?
> 
> Maybe we decide to take the existing LIRC system as is and not
> integrate it into the input subsystem. But I think there is a window
> here to update the LIRC design to use the latest kernel features. We
> don't want to build another /dev/mouse and have to rip it out in five
> years.
> 
> > When designing the key mapping in the kernel you should be aware that
> > there are remotes out there that send a sequence of scan codes for some
> > buttons, e.g.
> > http://lirc.sourceforge.net/remotes/pioneer/CU-VSX159
> 
> This is good input.
> 
