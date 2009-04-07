Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:15864 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbZDGJJF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 05:09:05 -0400
Date: Tue, 7 Apr 2009 11:08:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>, Janne Grunau <j@jannau.net>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC] Anticipating lirc breakage
Message-ID: <20090407110849.1ec089b8@hyperion.delvare>
In-Reply-To: <1239067237.3852.40.camel@palomino.walls.org>
References: <20090406174448.118f574e@hyperion.delvare>
	<1239067237.3852.40.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Mon, 06 Apr 2009 21:20:37 -0400, Andy Walls wrote:
> On Mon, 2009-04-06 at 17:44 +0200, Jean Delvare wrote:
> > The bottom line is that we have to instantiate I2C devices for IR
> > components regardless of the driver which will handle them (ir-kbd-i2c,
> > lirc_i2c or another one). I can think of two different strategies here:
> > 
> > 1* Instantiate driver-neutral I2C devices, named for example
> >   "ir_video". Let both ir-kbd-i2c and lirc_i2c (and possibly others)
> >   bind to them. The first loaded driver gets to bind to the device.
> >   This isn't so different from the current situation, the only
> >   difference being that the choice of addresses to probe is moved to
> >   the bridge drivers. We can even go with separate names for some
> >   devices (for example "ir_zilog"), as each I2C driver can list which
> >   devices it supports.
> > 
> > 2* Let the bridge drivers decide whether ir-kbd-i2c or lirc_i2c
> >    should drive any given device, by instantiating I2C devices with
> >    different names, for example "ir_kbd" for ir-kbd-i2c and "lirc" for
> >    lirc_i2c. This might give better out-of-the-box results for some
> >    devices and would make it possible to let the device drivers auto-load.
> >    There's a problem though for IR devices which are supported by both
> >    ir-kbd-i2c and lirc_i2c: not every user installs lirc, so it's not
> >    clear what devices should be created. We could default to "ir_kbd"
> >    and switch to "lirc" using a module parameter, as Mike Isely
> >    proposed for pvrusb2.
> > 
> > I have a clear preference for the first strategy. I feel that creating
> > devices for a specific driver is the wrong way to go, as we will
> > certainly want to merge ir-kbd-i2c and lirc_i2c into a single driver in
> > the future. However, I am not familiar enough with IR receivers to know
> > for sure if the first strategy will work. I would welcome comments on
> > this. Does anyone see a problem with strategy #1? Does anyone see
> > notable advantages in strategy #2?
> 
> I have a preference for #1.
> 
> Strategy #1 gives flexibility and control for *every* user.
> 
> Strategy #2 has better turn-key operation for *most* users.

Note that strategy #1 is also what we have at the moment, incidentally.

> > If we go with strategy #1 then my original patch set is probably very
> > similar to the solution. The only differences would be the name of the
> > I2C devices being created ("ir_video" instead of "ir-kbd") and the list
> > of addresses being probed (we'd need to add the addresses lirc_i2c
> > supports but ir-kbd-i2c does not.)
> 
> May I ask, why the virtual chip names like "ir_video"?  Almost every I2C
> IR chip should have a unique part number on it.  Maybe just use the name
> of the chip as - well - the name of the I2C chip at the address:
> "KS003", "Z8F0811", "PIC64xx", "CX2584x IR", etc.  That way it is almost
> unambiguous what the IR chip part is at the I2C address, and also what
> the IR chip driver module needs to support.
> 
> I suppose this is a bit problematic for micrcontroller chips with
> different controller code images, but slight additions to the name can
> take care of that: "Z8F0811 Hauppauge", "Z8F0811 Acme".
>                                                  ^^^^
>                                                   +-- ficticious company
> 
> It seems obvious to me.  (So there must be something wrong with it. ;] )

No, in theory you are perfectly right, it would be much better to name
devices by their actual name. I decided to go with a virtual name
merely because of the current structure of the ir-kbd-i2c code. I
wanted to make the conversion as direct as possible. But in the future,
adding separate names for specific IR devices would be nice.

As you found out though, this becomes a little bit more complex when
the IR device in question is a generic micro-controller. Not only the
same chip can be used differently as different IR devices, but
virtually the same chip can also be used somewhere else in the kernel
for completely different function. In this case I think it is better to
either suffix the I2C device name to distinguish between
implementations, or go with a plain virtual name right ahead.

Keep in mind that we are relatively free as to what I2C device names we
use. All that matters is uniqueness and relevance. And to stick to the
convention to use only lowercase letters, digits and underscores in the
names.

-- 
Jean Delvare
