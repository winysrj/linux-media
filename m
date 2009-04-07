Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:13967 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbZDGKCW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 06:02:22 -0400
Date: Tue, 7 Apr 2009 12:02:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mike Isely <isely@pobox.com>
Cc: isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC] Anticipating lirc breakage
Message-ID: <20090407120209.1d42bacd@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0904070049470.2076@cnc.isely.net>
References: <20090406174448.118f574e@hyperion.delvare>
	<Pine.LNX.4.64.0904070049470.2076@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

Glad to see we all mostly agree on what to do now. I'll still answer
some of your questions below, to clarify things even more.

On Tue, 7 Apr 2009 01:19:02 -0500 (CDT), Mike Isely wrote:
> On Mon, 6 Apr 2009, Jean Delvare wrote:
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
> I don't know if it will be possible or even make sense to merge 
> ir-kbd-i2c and lirc_i2c.  For example, if lirc_i2c is effectively a 
> complete superset of ir-kbd-i2c, then what's there to merge?  Seems to 
> be in the end that ir-kbd-i2c will eventually go away, but certainly not 
> until the question of merging lirc into the kernel is settled.

I consider "lirc_i2c replaces ir-kbd-i2c" a valid implementation of
"merge ir-kbd-i2c and lirc_i2c into a single driver" ;) I really don't
care about the implementation details, as long as the outcome is that
there is a single driver for every type of I2C-based IR receiver
device, because then we can let udev load these drivers and the user
experience will be much better.

> For now 
> they must both continue to exist and so there must really be a way to 
> ensure that the user can somehow control which is to be used - in cases 
> where a legitimate choice exists.

I agree.

> > If we go with strategy #1 then my original patch set is probably very
> > similar to the solution. The only differences would be the name of the
> > I2C devices being created ("ir_video" instead of "ir-kbd") and the list
> > of addresses being probed (we'd need to add the addresses lirc_i2c
> > supports but ir-kbd-i2c does not.) We would also need to ensure that
> > ir-kbd-i2c doesn't crash when it sees a device at an address it doesn't
> > support.
> 
> I think #2 only makes sense if there is a clear defined convention for 
> allowing the override of the desired name from userspace.  For example, 
> "modprobe pvrusb2 ir_driver=lirc_i2c".  I *definitely* would not want 
> the bridge driver to force the user to one alternative in cases where 
> two legitimate choices exist (which is what I first saw from your patch 
> to the pvrusb2 driver and is partly why I nacked it so quickly).  If #2 
> results in bridge drivers forcing the user to one IR driver, then I 
> would not want to go that route.

I agree as well... which means that #2 would require extra work on
bridge drivers, which would all be reverted once lirc_i2c is merged.

> I think #1 is easier, but it does leave one with the situation again 
> where loading ir_kbd_i2c again will cause it to bind to all bridge 
> drivers looking for, say "ir_video" when perhaps that's not the right 
> answer for a particular driver.  (Right?  I'm not sure if I totally 
> understand that aspect yet.)

Yes, you are right.

>                               I only point this out because it was 
> considered to be one of the flaws of the previous scheme.  However with 
> that said, #1 is certainly no worse than before.

#1 is indeed exactly the same functionally-wise as the current
situation. It has the same limitations, but is also the easiest to
implement. And the limitations will go away later when lirc_i2c is
merged.

> Really in the end there must be a defined namespace for binding where 
> someone looking for something I2C-ish (i.e. the bridge driver) and 
> someone providing something (i.e. ir_kbd_i2c) can meet.  It just has to 
> be there.  So it just comes down to how to manage that namespace.  
> There's some merit to infering information about the hardware 
> constraints from the name, as Andy suggests.  Rather than a single 
> "ir_video" name, instead use names that correspond to the type of IR 
> receiver that the bridge driver knows about.  It after all makes sense 
> that the bridge driver will naturally tend to have more information 
> about the type of IR receiver in use (and what I2C address it might live 
> at) and can use that information to better tune exactly who binds to it.  
> So with that said, #1 is probably a better choice (for now), and I think 
> using Andy's suggestion of assigning binding names based on the IR 
> receiver type (note: NOT the expected IR remote) would make this work a 
> lot better.

As I wrote in my reply to Andy already: I fully agree, the ir-kbd-i2c's
way of guessing what the device is based on its I2C address sucks, and
its limitations can clearly be seen just by looking at the code. The
more information the bridge driver can provide, the better the
ir-kbd-i2c driver will look. The device name is one way to pass said
device information, the other way is the attached platform_data as
implemented by one of my proposed patches. And we can use both if we
want, in the long term.

For now I took the shortest path which was to keep a single name. This
can be improved later by anyone with more knowledge about the different
IR receivers.

> There was another point made earlier about IR receivers that are not I2C 
> based, i.e. something built with GPIO signals, some FPGA logic, or 
> perhaps a vendor specific API in a microcontroller.  Those are certainly 
> cases to be dealt with, but they are out of scope for this issue - since 
> they are not I2C devices.  This to me is another reason that argues 
> strongly for turning over all this IR silliness to an already built 
> external-to-v4l-dvb framework such as lirc.  The lirc architecture is 
> not tied to I2C and it already has drivers that work through other 
> interfaces (e.g. serial, UDP, something over USB, custom hardware, etc).  
> In the end it really makes better sense to separate the notion of 
> driving the IR receiver hardware from the notion of programming for a 
> specific remote.  And lirc already does this pretty well (IMHO).  So the 
> focus here should remain on how to provide a sane path to preserve 
> lirc's ability to iteract with the kernel I2C subsystem.

Yes, I agree. And the way to do this in the new I2C binding model is to
instantiate I2C devices for every device lirc_i2c supports so that it
can bind to them.

> A somewhat related question, though off-topic:  Does lm-sensors have any 
> I2C entangled drivers that are not in-tree?  Because if so, the same 
> ugly issue(s) are going to arise there.  I honestly have no idea.  It 
> just occurred to me as another example of something that relies heavily 
> on the kernel I2C subsystem.

No, all lm-sensors drivers (since then renamed to hwmon drivers) are
inside the kernel tree now. That being said, for I2C-based hardware
monitoring devices which can be reliably detected by probing, living
out of the kernel tree wouldn't be much of an issue. Hwmon devices are
essentially standalone, so they can just probe the relevant I2C
adapters for supported devices, auto-instantiate them and bind to them.
As long as the driver in question makes sure to not reuse a device name
that is already used by another I2C driver in the kernel, it would work
just fine.

This doesn't apply to IR receivers because in general they cannot be
reliably detected and you need board-specific information to drive them
properly.

I'll rework my patch set to implement strategy #1 and post it when I'm
done. As far as I can see this should be very similar to my original
attempt, with just "ir_video" devices instead or "ir-kbd" devices, and
also fixes for the minor issues that have been reported.

Do you want me to include pvrusb2 in my new patch set, or should I still
leave it to you?

-- 
Jean Delvare
