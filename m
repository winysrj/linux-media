Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:57318 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZDESd4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 14:33:56 -0400
Date: Sun, 5 Apr 2009 13:33:52 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>, Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
In-Reply-To: <20090405161803.70810455@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904051315490.32738@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
 <20090404142837.3e12824c@hyperion.delvare> <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
 <20090405010539.187e6268@hyperion.delvare> <Pine.LNX.4.64.0904041807300.32720@cnc.isely.net>
 <20090405161803.70810455@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Jean:

More comments interspersed below...

On Sun, 5 Apr 2009, Jean Delvare wrote:

   [...]

> 
> > Remember 
> > that the pvrusb2 driver did not autoload ir-kbd-i2c before this patch.  
> > Before this change, a user could elect not to use ir-i2c-kbd simply by 
> > not loading it.
> 
> Which was pretty fragile because another bridge driver could still have
> loaded it.

Well I didn't say it was perfect.  But this has been a valid use-case 
and I know people have been using this it this way.

> 
> > The pvrusb2 driver didn't request it, because the 
> > intent all along there is that the user makes the choice by loading the 
> > desired driver.
> 
> Which simply underlines how weird the current situation is... Forcing
> the choice on the user is pretty bad from a usability perspective.

What's worse is taking away a choice when the alternatives are not 
interchangeable.  In this case we have two different drivers with two 
different interfaces which do not cover the same range of hardware.  
The lirc case happens to work quite well in MythTV.  In addition, lirc 
covers hardware situations involving the pvrusb2 driver that ir-kbd-i2c 
does not.  Also, lirc makes it possible to userspace map the underlying 
IR codes to keybindings and associate multiple different remotes - all 
of that is apparently hardcoded in ir-kbd-i2c.  Wierd or not, your 
change makes it hard(er) on those who legitimately wish to use lirc.  
Here's an interesting summary:

If fact, the only pvrusb2-driven hardware from Hauppauge that is known 
to work with ir-kbd-i2c are the old 29xxx and 24xxx model series (not 
the "MCE" series).  Those devices are out of production, AFAIK.  The 
current devices being sold by Hauppauge don't work at all with 
ir-kbd-i2c and probably never will.

Perhaps one can conclude that there hasn't been a lot of pressure (that 
I know about) to deal with updating / enhancing / replacing ir-kbd-i2c 
because lirc happens to be filling the niche better in many cases.


> 
> >  Now with this change, the pvrusb2 driver is going to 
> > attempt to load ir-kbd-i2c where asked for or not.
> 
> Not exactly, only the device will be the instantiated, the drivers
> won't be loaded, but the result is indeed the same: it's getting in
> lirc_i2c's way if that's what the user wants to use.

Well yes.  The binding of the address is enough to mess things up.


> 
> >  And if not, the 
> > resulting binding will prevent lirc_i2c from later on loading.  If the 
> > user had been loading lirc_i2c previously, this will cause his/her usage 
> > of IR to break.  No, it's not perfect, but it worked.  I'm all for 
> > improving things, but not by removing an ability that people are using.
> 
> I have just added a disable_ir module parameter to work around this
> issue. Set it to 1 and no "ir-kbd" device will be instantiated, letting
> lirc_i2c do whatever it wants with the IR receiver device.
> 
> You might argue that this is still a regression because the user now
> has to pass an extra parameter to get the same result as before, but
> OTOH lirc_i2c will need changes pretty soon anyway, its behavior will
> have to be changed and the users will notice. There's no way we can go
> from the current weird situation to a sane situation without changing
> the (unfortunate) user habits.

Yes, I would argue that this is still a regression.  I really think this 
should be an *enable* switch in order to match previous behavior.  In 
the long term I agree that this is less than optimal / undesirable, 
however in the long term none of it is going to matter anyway, since it 
looks like lirc without further changes is going to have problems here.  
Once (if) lirc is changed to use the new binding model then this whole 
argument becomes moot.  Given that, then anything done here is a short 
term strategy, designed to avoid a regression, so I would much rather 
this be an enable not a disable switch.


> 
> > (...)
> > I really don't want to throw rocks here; it's always better to work out 
> > the solution than simply block any changes at all.  I realize that 
> > something has to be done here in order to keep ir-kbd-i2c viable as a 
> > choice for users of the pvrusb2 driver.  To that end, how about this 
> > strategy:
> > 
> > 1. Just drop the part of the patch for the pvrusb2 driver and get the 
> > rest merged.  Yes, I realize that this will break use of ir-kbd-i2c in 
> > cooperation with the pvrusb2 driver.
> 
> As Mauro already said: not acceptable. Breaking an in-tree driver
> (ir-kbd-i2c) is worse than breaking an out-of-tree driver (lirc_i2c)
> regardless of the respective number of users or usefulness of these
> drivers.

*I* didn't break ir-kbd-i2c.  And now because of what has effectively 
"broken" (viewed in just the wrong light) you are asking me to accept 
changes in the pvrusb2 driver to make up the difference?  Normally I 
wouldn't object, except those proposed changes in turn will break 
another driver (lirc).  That is why I nacked the change.  I don't care 
if the driver is in-tree or out of tree, I am not going to accept a 
change that breaks without recourse a known use-case that people are 
using.  I consider Mauro's reasoning flawed here.

What I am suggesting for (1) does not "break" ir-kbd-i2c.  Yes, it 
impacts its use but only within the pvrusb2 driver, and only until I get 
(2) implemented, which unless something comes up I plan on dealing with 
today.  So (1) should be acceptable.


> 
> > 2. Once ir-kbd-i2c has been updated, I will push another set of changes 
> > into the pvrusb2 driver that will make it usable there.  Basically what 
> > I have in mind is similar to what you tried but I'm going to integrate 
> > it with the device profiles so that it can be appropriately loaded based 
> > on device model, with the correct I2C address in each case.  And most 
> > importantly, I will add a module option to enable/disable loading or 
> > ir-kbd-i2c.  This will fix my main objection, since then it will still 
> > allow lirc to be usable, for now...
> 
> This sounds like a good idea.
> 
> > 3. I'd like to fix the "abuse" you mention regarding I2C_HW_B_BT848.  
> > I'm unclear on what the cleanest solution is there, but if you like to 
> > (a) point at some documentation, (b) describe what I should do, or (c) 
> > suggest a patch, I will work to deal with the problem.
> 
> Ideally these adapter IDs will no longer be needed within a couple
> weeks, so it's probably better to leave this alone and just let it die
> in silence.
> 

OK, no problem.  I'm happy with letting it die :-)

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
