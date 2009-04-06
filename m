Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:54025 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbZDFEoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 00:44:06 -0400
Date: Sun, 5 Apr 2009 21:44:02 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Mike Isely <isely@pobox.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@radix.net>,
	hermann pitton <hermann-pitton@arcor.de>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
In-Reply-To: <Pine.LNX.4.64.0904052104010.2076@cnc.isely.net>
Message-ID: <Pine.LNX.4.58.0904052121540.5134@shell2.speakeasy.net>
References: <20090404142427.6e81f316@hyperion.delvare>
 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net> <20090405010539.187e6268@hyperion.delvare>
 <200904050746.47451.hverkuil@xs4all.nl> <20090405143748.GC10556@aniel>
 <1238953174.3337.12.camel@morgan.walls.org> <20090405183154.GE10556@aniel>
 <1238957897.3337.50.camel@morgan.walls.org> <20090405222250.64ed67ae@hyperion.delvare>
 <1238966523.6627.63.camel@pc07.localdom.local> <1238968804.4647.22.camel@morgan.walls.org>
 <20090405225102.531a2075@pedra.chehab.org> <Pine.LNX.4.64.0904052104010.2076@cnc.isely.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009, Mike Isely wrote:
> 1. The switch statement in ir-kbd-i2c.c:ir_attach() is apparently
> implicitly trying to assume a particular type of remote based on the I2C
> address of the IR receiver it's talking to.  Yuck.  That's really not
> right at all.  The IR receiver used does not automatically mean which
> remote is used.  What if the vendor switches remotes?  That's happened
> with the PVR-USB2 hardware in the past (based on photos I've seen).
> Who's to say the next remote to be supplied is compatible?

IMHO, the way the remote supported is compiled into the kernel is absurd.
The system I setup 12 years ago was better than this.  At least the remote
was compiled into a userspace daemon and multiple remotes were supported at
the same time.  The keycode system I used had a remote id/key id split, so
you could have volume up key on any remote control the mixer but make the
power buttons on different remotes turn on different apps.

> 3. A given IR remote may be described by much more than what 'scan
> codes' it produces.  I don't know a lot about IR, but looking at the
> typical lirc definition for a remote, there's obvious timing and
> protocol parameters as well.  Just being able to swap scan codes around
> is not always going to be enough.

A remote typically sends a header sequence of a long pulse and space before
the code.  The length of the pulse on the space varies greatly by remote
and makes a good way to identify the remote when multiple ones are
supported.

Then a pulse coded remote sends a sequence bits, usually 8 to 32.  The
length of the pulse identifies 1s or 0s.  Different remotes have different
pulse lengths and different spaces between them.  RC5 remotes use
Manchester encoding for this part.

When you hold a key down some remotes just repeat the same sequence over
and over again.  Some repeat the scan code but omit the header part.  Some
send out a special pulse sequence to indicate the last key is being held
down.  With the latter two methods you can tell the difference between a
key being held down and a key being pressed repeatedly.  With the first you
have guess based on how fast the repeats are coming in.  This is very
different than a keyboard, which sends a code when you press a key and
another when you release it.

The rate at which remotes repeat varies greatly.  You might find that one
remote makes your volume change annoying slowly while another is much too
fast to be usable.  Remote keys usually start repeating without delay, so
if you let a toggle like 'mute' repeat it becomes almost impossible to hit
it just once.  Entering numbers becomes impossible as well.
