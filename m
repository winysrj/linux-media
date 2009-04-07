Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:38220 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbZDGATk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 20:19:40 -0400
Subject: Re: [RFC] Anticipating lirc breakage
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>, Janne Grunau <j@jannau.net>,
	Jarod Wilson <jarod@redhat.com>
In-Reply-To: <20090406174448.118f574e@hyperion.delvare>
References: <20090406174448.118f574e@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 21:20:37 -0400
Message-Id: <1239067237.3852.40.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-04-06 at 17:44 +0200, Jean Delvare wrote:
> Hi all,
> 
> In the light of recent discussions and planed changes to the i2c
> subsystem and the ir-kbd-i2c driver, I will try to summarize the
> situation and make some proposals. Note that I am really not sure what
> we want to do, so this is a true request for opinions.



> The bottom line is that we have to instantiate I2C devices for IR
> components regardless of the driver which will handle them (ir-kbd-i2c,
> lirc_i2c or another one). I can think of two different strategies here:
> 
> 1* Instantiate driver-neutral I2C devices, named for example
>   "ir_video". Let both ir-kbd-i2c and lirc_i2c (and possibly others)
>   bind to them. The first loaded driver gets to bind to the device.
>   This isn't so different from the current situation, the only
>   difference being that the choice of addresses to probe is moved to
>   the bridge drivers. We can even go with separate names for some
>   devices (for example "ir_zilog"), as each I2C driver can list which
>   devices it supports.
> 
> 2* Let the bridge drivers decide whether ir-kbd-i2c or lirc_i2c
>    should drive any given device, by instantiating I2C devices with
>    different names, for example "ir_kbd" for ir-kbd-i2c and "lirc" for
>    lirc_i2c. This might give better out-of-the-box results for some
>    devices and would make it possible to let the device drivers auto-load.
>    There's a problem though for IR devices which are supported by both
>    ir-kbd-i2c and lirc_i2c: not every user installs lirc, so it's not
>    clear what devices should be created. We could default to "ir_kbd"
>    and switch to "lirc" using a module parameter, as Mike Isely
>    proposed for pvrusb2.
> 
> I have a clear preference for the first strategy. I feel that creating
> devices for a specific driver is the wrong way to go, as we will
> certainly want to merge ir-kbd-i2c and lirc_i2c into a single driver in
> the future. However, I am not familiar enough with IR receivers to know
> for sure if the first strategy will work. I would welcome comments on
> this. Does anyone see a problem with strategy #1? Does anyone see
> notable advantages in strategy #2?

I have a preference for #1.

Strategy #1 gives flexibility and control for *every* user.

Strategy #2 has better turn-key operation for *most* users.

So strategy #1 gives better flexibility to the user to fix problems at
the cost of some base complexity to get up and running (maybe).  More
problems, but hopefully all resolvable with moderate effort.

So strategy #2 gives most users a no-brainer experience, but to fix
problems, steps of dauting complexity or risk for the inexperienced user
may be needed (maybe).  Fewer problems, more effort to resolve the
problem cases.


I don't mind talking a user through a problem with strategy #1 in place.
All the pieces are there, it's just a matter of troubleshooting the
configuration: lsmod, dmesg, service lircd stop, modprobe -r lirc_i2c
lirc_dev, ....


I wouldn't want to talk a user through problems with strategy #2 in
place:

Me: "Ok, so download the latest v4l-dvb/lirc tarball, edit this string
in this file, compile, install, unload, reload, and viola!"

User: "I've done all that.  It says something about unresolved symbol.
What does that mean?  I'm using
$DISTRO_OTHER_THAN_ANDYS_PREFERRED_DISTRO..."

Me: (begin attempting to remove the wall with my forehead...)


> If we go with strategy #1 then my original patch set is probably very
> similar to the solution. The only differences would be the name of the
> I2C devices being created ("ir_video" instead of "ir-kbd") and the list
> of addresses being probed (we'd need to add the addresses lirc_i2c
> supports but ir-kbd-i2c does not.)

May I ask, why the virtual chip names like "ir_video"?  Almost every I2C
IR chip should have a unique part number on it.  Maybe just use the name
of the chip as - well - the name of the I2C chip at the address:
"KS003", "Z8F0811", "PIC64xx", "CX2584x IR", etc.  That way it is almost
unambiguous what the IR chip part is at the I2C address, and also what
the IR chip driver module needs to support.

I suppose this is a bit problematic for micrcontroller chips with
different controller code images, but slight additions to the name can
take care of that: "Z8F0811 Hauppauge", "Z8F0811 Acme".
                                                 ^^^^
                                                  +-- ficticious company

It seems obvious to me.  (So there must be something wrong with it. ;] )





>  We would also need to ensure that
> ir-kbd-i2c doesn't crash when it sees a device at an address it doesn't
> support.

Yes, because when that module crashes, a short time later one's keyboard
will be unusable.  I guess that's a consequence of oopsing in a module
hooked into the input event system.


Regards,
Andy

