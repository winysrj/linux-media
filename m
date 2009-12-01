Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:54925 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZLAUSt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 15:18:49 -0500
Received: by pzk1 with SMTP id 1so4038838pzk.33
        for <linux-media@vger.kernel.org>; Tue, 01 Dec 2009 12:18:55 -0800 (PST)
Date: Tue, 1 Dec 2009 12:11:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, lirc-list@lists.sourceforge.net,
	superm1@ubuntu.com, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
Message-ID: <20091201201158.GA20335@core.coreip.homeip.net>
References: <9e4733910912010708u1064e2c6mbc08a01293c3e7fd@mail.gmail.com> <1259682428.18599.10.camel@maxim-laptop> <9e4733910912010816q32e829a2uce180bfda69ef86d@mail.gmail.com> <4B154C54.5090906@redhat.com> <829197380912010909m59cb1078q5bd2e00af0368aaf@mail.gmail.com> <4B155288.1060509@redhat.com> <20091201175400.GA19259@core.coreip.homeip.net> <4B1567D8.7080007@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1567D8.7080007@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 01, 2009 at 05:00:40PM -0200, Mauro Carvalho Chehab wrote:
> Dmitry Torokhov wrote:
> > On Tue, Dec 01, 2009 at 03:29:44PM -0200, Mauro Carvalho Chehab wrote:
> >> For sure we need to add an EVIOSETPROTO ioctl to allow the driver 
> >> to change the protocol in runtime.
> >>
> > 
> > Mauro,
> > 
> > I think this kind of confuguration belongs to lirc device space,
> > not input/evdev. This is the same as protocol selection for psmouse
> > module: while it is normally auto-detected we have sysfs attribute to
> > force one or another and it is tied to serio device, not input
> > device.
> 
> Dmitry,
> 
> This has nothing to do with the raw interface nor with lirc. This problem 
> happens with the evdev interface and already affects the in-kernel drivers.
> 
> In this case, psmouse is not a good example. With a mouse, when a movement
> occurs, you'll receive some data from its port. So, a software can autodetect
> the protocol. The same principle can be used also with a raw pulse/space
> interface, where software can autodetect the protocol.

Or, in certain cases, it can not.

> 
[... skipped rationale for adding a way to control protocol (with which
I agree) ...]

> 
> To solve this, we really need to extend evdev API to do 3 things: enumberate the
> supported protocols, get the current protocol(s), and select the protocol(s) that
> will be used by a newer table.
> 

And here we start disagreeing. My preference would be for adding this
API on lirc device level (i.e. /syc/class/lirc/lircX/blah namespace),
since it only applicable to IR, not to input devices in general.

Once you selected proper protocol(s) and maybe instantiated several
input devices then udev (by examining input device capabilities and
optionally looking up at the parent device properties) would use
input evdev API to load proper keymap. Because translation of
driver-specific codes into standard key definitions is in the input
realm. Reading these driver-specific codes from hardware is outside of
input layer domain.

Just as psmouse ability to specify protocol is not shoved into evdev;
just as atkbd quirks (force release key list and other driver-specific
options) are not in evdev either; we should not overload evdev interface
with IR-specific items.

-- 
Dmitry
