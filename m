Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41567 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109AbZLOUTl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2009 15:19:41 -0500
Date: Tue, 15 Dec 2009 21:19:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
Message-ID: <20091215201933.GK24406@elf.ucw.cz>
References: <4B1B99A5.2080903@redhat.com>
 <m3638k6lju.fsf@intrepid.localdomain>
 <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
 <m3skbn6dv1.fsf@intrepid.localdomain>
 <20091207184153.GD998@core.coreip.homeip.net>
 <4B24DABA.9040007@redhat.com>
 <20091215115011.GB1385@ucw.cz>
 <4B279017.3080303@redhat.com>
 <20091215195859.GI24406@elf.ucw.cz>
 <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e4733910912151214n68161fc7tca0ffbf34c2c4e4@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 2009-12-15 15:14:02, Jon Smirl wrote:
> On Tue, Dec 15, 2009 at 2:58 PM, Pavel Machek <pavel@ucw.cz> wrote:
> > Hi!
> >
> >>       (11) if none is against renaming IR as RC, I'll do it on a next patch;
> >
> > Call it irc -- infrared remote control. Bluetooth remote controls will
> > have very different characteristics.
> 
> How are they different after the scancode is extracted from the
> network packet? The scancode still needs to be passed to the input
> system, go through a keymap, and end up on an evdev device.
> 
> I would expect the code for extracting the scancode to live in the
> networking stack, but after it is recovered the networking code would
> use the same API as IR to submit it to input.

For one thing,  bluetooth (etc) has concept of devices (and reliable
transfer). If you have two same bluetooth remotes, you can tell them
apart, unlike IR.

So yes, keymapping is the same, but that's pretty much it. Decoding
will not be the same (IR is special), etc...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
