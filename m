Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50805 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbZH0T20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 15:28:26 -0400
Date: Thu, 27 Aug 2009 16:28:21 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Peter Brouwer <pb.maillists@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
Message-ID: <20090827162821.5344c2b2@pedra.chehab.org>
In-Reply-To: <829197380908271134q26b2d44eg2e8c87a844d2b0b5@mail.gmail.com>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	<4A96BD05.1080205@googlemail.com>
	<829197380908271017x4247a550t44155a46c7e23c79@mail.gmail.com>
	<Pine.LNX.4.58.0908271124470.11911@shell2.speakeasy.net>
	<829197380908271134q26b2d44eg2e8c87a844d2b0b5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I recognize that lirc can support multiple remotes.  However, at a
> minimum the lirc receiver should work out of the box with the remote
> the product comes with.  And that means there needs to be some way in
> the driver to associate the tuner with some remote control profile
> that has its layout defined in lirc.  Sure, if the user wants to then
> say "I want to use this different remote instead..." then that should
> be supported as well if the user does the appropriate configuration.

No doubt that lirc has its usage, but its usage requires either an out-of-tree
kernel module, whose setup is not trivial, especially if the distro comes
without support for it, or its event interface.

>From what I've found looking at a few lirc kernel modules, they also need a
better glue with the device drivers, to do some needed locks.

Either way, lirc setup is not that easy, since you need to properly configure
the /etc/lirc*conf, in order to match your board, your IR and your desired
applications.

The event interface also requires that you need to have your device connected
before calling the daemon, and that the user discover what's the event
interface used by a device, to fill its command line:

$ lircd -H devinput -d /dev/input/event6

IMHO, this has practical usage only with non-hotpluggable (e. g. PCI) devices.

Yet, if we provide a standard set of defined keys for IR, it would be possible
to have standard configurations for event interface on lirc that will work with the
IR that is provided together with the device, since the keycodes for starting
TV, changing channels, etc will be the same no matter what video board you're using.

So, it would be easier for distros to find some ways for it to work
out-of-the-box with their systems, provided that someone invest some time
improving the lirc event interface to better work with hot-pluggable devices or
on create some udev rules to start/stop lircd when an IR event interface is
created.

> While I can appreciate the desire to support all sorts of advanced
> configurations, this shouldn't be at the cost of the simple
> configurations not working out-of-the-box.

Agreed. The usage of lirc should be optional, not mandatory.



Cheers,
Mauro
