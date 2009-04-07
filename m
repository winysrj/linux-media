Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:46727 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZDGGTI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Apr 2009 02:19:08 -0400
Date: Tue, 7 Apr 2009 01:19:02 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>, Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>, Jarod Wilson <jarod@redhat.com>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: [RFC] Anticipating lirc breakage
In-Reply-To: <20090406174448.118f574e@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904070049470.2076@cnc.isely.net>
References: <20090406174448.118f574e@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 6 Apr 2009, Jean Delvare wrote:

> Hi all,
> 
> In the light of recent discussions and planed changes to the i2c
> subsystem and the ir-kbd-i2c driver, I will try to summarize the
> situation and make some proposals. Note that I am really not sure what
> we want to do, so this is a true request for opinions.
> 
> First of all, the original reason for these changes is that I want to
> get rid of the legacy i2c binding model. As far as IR support is
> concerned, this means two things:
> * The ir-kbd-i2c driver must be converted to the new i2c binding model.
>   I have been working on this already.
> * The removal of the legacy model will break lirc_i2c and possibly
>   other lirc drivers. These will have to be converted to the new i2c
>   binding model as well.
> 
> While discussing my changes to ir-kbd-i2c, I received objections that
> these would adversely affect lirc users, and proposals were made to
> work around this problem, either by the means of module parameters, or
> by adding per-card logic in the bridge drivers. While this temporarily
> addresses the conflict with lirc, I feel like it is wasted energy
> because the second point is much more critical for lirc users. I'm
> going to remove the legacy i2c model pretty soon now and lirc_i2c and
> friends will have to be updated. This means two things:

It wasn't really wasting that much energy for me.  The change was simple 
and now that you made me look at this issue more closely, I realize I 
need to do something more serious in the pvrusb2 driver anyway to enable 
better control over which IR receiver(s) are to be enabled when the user 
has multiple devices.  So in the end for me at least, it wasn't a waste.


> * There is no point in refining the ir-kbd-i2c conversion for users of
>   the current lirc drivers, because the removal of the legacy i2c model
>   will break these drivers a lot more anyway.
> * We need to come up with a strategy that makes it possible for lirc
>   modules to still work afterwards. This is not trivial because the new
>   i2c binding model makes life much harder for rogue/out-of-tree i2c
>   drivers (note, this is just a side effect, the new model was not
>   designed with this in mind.)
> 
> The main technical problems I see as far as converting lirc to the new
> i2c binding model is concerned are:
> * Going the .detect() route is not as flexible as it was beforehand. In
>   particular, having per-board probed address lists is no longer
>   possible. It is possible to filter the addresses on a per-board basis
>   after the fact, but the probes will still be issued for all addresses.
>   I seem to remember that probing random addresses did cause trouble in
>   the past on some boards, so I doubt we want to go that route. This is
>   the reason why I decided to NOT go the .detect() route for ir-kbd-i2c
>   conversion.
> * If we don't use .detect(), the bridge drivers must instantiate the
>   devices themselves. That's what my ir-kbd-i2c patches do. One
>   requirement is then that the bridge drivers and the chip drivers agree
>   on the i2c device name(s). This was true for ir-kbd-i2c, it is true for
>   lirc as well. Where it becomes difficult is that lirc lives outside of
>   the kernel, while bridge drivers live inside the kernel. This will make
>   the changes more difficult to synchronize. Probably a good incentive
>   for lirc developers to merge their drivers into the kernel tree.
> 
> While I think we all agree that lirc drivers should be merged in the
> kernel tree, it is pretty clear that it won't happen tomorrow. And,
> more importantly, it won't happen before I get rid of the legacy i2c
> binding model. So we need to come up with a design which makes it
> possible to keep using out-of-tree lirc drivers. It doesn't need to be
> perfect, but it has to somewhat work for now.

Yup.  Totally agree.


> 
> My initial proposal made bridge drivers create "ir-kbd" [1] I2C devices
> for the ir-kbd-i2c driver to use. Mike Isely changed this in the pvrusb2
> bridge driver to only instantiate the devices for boards on which
> ir-kbd-i2c is known to work. While this makes sense for the current
> situation (lirc_i2c is a legacy i2c driver) it will break as soon as
> lirc_i2c is converted to a new-style i2c driver: the converted lirc_i2c
> driver will need I2C devices to bind to, and the pvrusb2 driver won't
> create them.

Right, because we haven't addressed the question of still making 
possible the choice of which actual driver to load.  The change I 
proposed and implemented (within the pvrusb2 driver) was just a simple 
low-risk attempt to allow for the status quo to still be possible within 
the pvrusb2 driver.  That will work for _right this moment_, but once 
you've removed the legacy i2c binding mechanism, there's no longer any 
status quo to maintain.


> 
> Same goes for cx18 boards, as Andy Walls and myself agreed to not
> create I2C devices for the IR receivers, because we know that
> ir-kbd-i2c doesn't support them. This made sense for the current
> situation, but the lirc_i2c conversion will break on these boards. And
> the same is also true for all board types where lirc_i2c (or other lirc
> modules for I2C IR receivers) support more devices than ir-kbd-i2c
> does: if the bridge drivers don't create the I2C devices, lirc_i2c
> won't have anything to bind to.
> 
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

I don't know if it will be possible or even make sense to merge 
ir-kbd-i2c and lirc_i2c.  For example, if lirc_i2c is effectively a 
complete superset of ir-kbd-i2c, then what's there to merge?  Seems to 
be in the end that ir-kbd-i2c will eventually go away, but certainly not 
until the question of merging lirc into the kernel is settled.  For now 
they must both continue to exist and so there must really be a way to 
ensure that the user can somehow control which is to be used - in cases 
where a legitimate choice exists.


> 
> If we go with strategy #1 then my original patch set is probably very
> similar to the solution. The only differences would be the name of the
> I2C devices being created ("ir_video" instead of "ir-kbd") and the list
> of addresses being probed (we'd need to add the addresses lirc_i2c
> supports but ir-kbd-i2c does not.) We would also need to ensure that
> ir-kbd-i2c doesn't crash when it sees a device at an address it doesn't
> support.

I think #2 only makes sense if there is a clear defined convention for 
allowing the override of the desired name from userspace.  For example, 
"modprobe pvrusb2 ir_driver=lirc_i2c".  I *definitely* would not want 
the bridge driver to force the user to one alternative in cases where 
two legitimate choices exist (which is what I first saw from your patch 
to the pvrusb2 driver and is partly why I nacked it so quickly).  If #2 
results in bridge drivers forcing the user to one IR driver, then I 
would not want to go that route.

I think #1 is easier, but it does leave one with the situation again 
where loading ir_kbd_i2c again will cause it to bind to all bridge 
drivers looking for, say "ir_video" when perhaps that's not the right 
answer for a particular driver.  (Right?  I'm not sure if I totally 
understand that aspect yet.)  I only point this out because it was 
considered to be one of the flaws of the previous scheme.  However with 
that said, #1 is certainly no worse than before.

Really in the end there must be a defined namespace for binding where 
someone looking for something I2C-ish (i.e. the bridge driver) and 
someone providing something (i.e. ir_kbd_i2c) can meet.  It just has to 
be there.  So it just comes down to how to manage that namespace.  
There's some merit to infering information about the hardware 
constraints from the name, as Andy suggests.  Rather than a single 
"ir_video" name, instead use names that correspond to the type of IR 
receiver that the bridge driver knows about.  It after all makes sense 
that the bridge driver will naturally tend to have more information 
about the type of IR receiver in use (and what I2C address it might live 
at) and can use that information to better tune exactly who binds to it.  
So with that said, #1 is probably a better choice (for now), and I think 
using Andy's suggestion of assigning binding names based on the IR 
receiver type (note: NOT the expected IR remote) would make this work a 
lot better.

There was another point made earlier about IR receivers that are not I2C 
based, i.e. something built with GPIO signals, some FPGA logic, or 
perhaps a vendor specific API in a microcontroller.  Those are certainly 
cases to be dealt with, but they are out of scope for this issue - since 
they are not I2C devices.  This to me is another reason that argues 
strongly for turning over all this IR silliness to an already built 
external-to-v4l-dvb framework such as lirc.  The lirc architecture is 
not tied to I2C and it already has drivers that work through other 
interfaces (e.g. serial, UDP, something over USB, custom hardware, etc).  
In the end it really makes better sense to separate the notion of 
driving the IR receiver hardware from the notion of programming for a 
specific remote.  And lirc already does this pretty well (IMHO).  So the 
focus here should remain on how to provide a sane path to preserve 
lirc's ability to iteract with the kernel I2C subsystem.

A somewhat related question, though off-topic:  Does lm-sensors have any 
I2C entangled drivers that are not in-tree?  Because if so, the same 
ugly issue(s) are going to arise there.  I honestly have no idea.  It 
just occurred to me as another example of something that relies heavily 
on the kernel I2C subsystem.


> 
> [1] The I2C device name "ir-kbd" is incorrect, BTW, as dashes aren't
> allowed in I2C device names. Not sure how I missed that while I wrote
> it half a dozen times in my patch. Oh well.

Oops :-)

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
