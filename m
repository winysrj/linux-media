Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:8430 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZDEOST (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 10:18:19 -0400
Date: Sun, 5 Apr 2009 16:18:03 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mike Isely <isely@pobox.com>
Cc: isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
  model
Message-ID: <20090405161803.70810455@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0904041807300.32720@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
	<20090404142837.3e12824c@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	<20090405010539.187e6268@hyperion.delvare>
	<Pine.LNX.4.64.0904041807300.32720@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

Selected answers, as most points have already been discussed elsewhere
meanwhile...

On Sat, 4 Apr 2009 18:29:35 -0500 (CDT), Mike Isely wrote:
> On Sun, 5 Apr 2009, Jean Delvare wrote:
> > This is excellent news. As I said in the header comment of the patch,
> > avoiding probing when we know what the IR receiver is and at which
> > address it sits is the way to go. Please send me all the information
> > you have and I'll be happy to add a patch to the series, that skips
> > probing whenever possible. Or write that patch yourself if you prefer.
> 
> I have samples of most of the devices in question and can code proper 
> I2C addresses for each of those for each resident I2C client.  The 
> pvrusb2 driver's device attribute structure already has allowance for 
> specification of the correct I2C addresses to use for chips specific to 
> each device (part of the v4l2-subdev rework I recently did).  Right now 
> the driver has built in defaults, and if a particular model needs 
> something else, it can be overridden as part of the device's profile in 
> pvrusb2-devattr.c.

Good. Declaring the right IR receiver device based on board information
is clearly the way to go.

> > I didn't make any assumption, sorry. I simply copied the code from
> > ir-kbd-i2c. If my code does the wrong thing for some devices, that was
> > already the case before. And this will certainly be easier to fix after
> > my changes than before.
> 
> No, I think the point you are missing is that by moving that logic from 
> ir-kbd-i2c into each driver (e.g. pvrusb2) you are moving logic that 
> *might* be executed into a spot where it *will* be executed.

Yes, you are right.

> Remember 
> that the pvrusb2 driver did not autoload ir-kbd-i2c before this patch.  
> Before this change, a user could elect not to use ir-i2c-kbd simply by 
> not loading it.

Which was pretty fragile because another bridge driver could still have
loaded it.

> The pvrusb2 driver didn't request it, because the 
> intent all along there is that the user makes the choice by loading the 
> desired driver.

Which simply underlines how weird the current situation is... Forcing
the choice on the user is pretty bad from a usability perspective.

>  Now with this change, the pvrusb2 driver is going to 
> attempt to load ir-kbd-i2c where asked for or not.

Not exactly, only the device will be the instantiated, the drivers
won't be loaded, but the result is indeed the same: it's getting in
lirc_i2c's way if that's what the user wants to use.

>  And if not, the 
> resulting binding will prevent lirc_i2c from later on loading.  If the 
> user had been loading lirc_i2c previously, this will cause his/her usage 
> of IR to break.  No, it's not perfect, but it worked.  I'm all for 
> improving things, but not by removing an ability that people are using.

I have just added a disable_ir module parameter to work around this
issue. Set it to 1 and no "ir-kbd" device will be instantiated, letting
lirc_i2c do whatever it wants with the IR receiver device.

You might argue that this is still a regression because the user now
has to pass an extra parameter to get the same result as before, but
OTOH lirc_i2c will need changes pretty soon anyway, its behavior will
have to be changed and the users will notice. There's no way we can go
from the current weird situation to a sane situation without changing
the (unfortunate) user habits.

> (...)
> I really don't want to throw rocks here; it's always better to work out 
> the solution than simply block any changes at all.  I realize that 
> something has to be done here in order to keep ir-kbd-i2c viable as a 
> choice for users of the pvrusb2 driver.  To that end, how about this 
> strategy:
> 
> 1. Just drop the part of the patch for the pvrusb2 driver and get the 
> rest merged.  Yes, I realize that this will break use of ir-kbd-i2c in 
> cooperation with the pvrusb2 driver.

As Mauro already said: not acceptable. Breaking an in-tree driver
(ir-kbd-i2c) is worse than breaking an out-of-tree driver (lirc_i2c)
regardless of the respective number of users or usefulness of these
drivers.

> 2. Once ir-kbd-i2c has been updated, I will push another set of changes 
> into the pvrusb2 driver that will make it usable there.  Basically what 
> I have in mind is similar to what you tried but I'm going to integrate 
> it with the device profiles so that it can be appropriately loaded based 
> on device model, with the correct I2C address in each case.  And most 
> importantly, I will add a module option to enable/disable loading or 
> ir-kbd-i2c.  This will fix my main objection, since then it will still 
> allow lirc to be usable, for now...

This sounds like a good idea.

> 3. I'd like to fix the "abuse" you mention regarding I2C_HW_B_BT848.  
> I'm unclear on what the cleanest solution is there, but if you like to 
> (a) point at some documentation, (b) describe what I should do, or (c) 
> suggest a patch, I will work to deal with the problem.

Ideally these adapter IDs will no longer be needed within a couple
weeks, so it's probably better to leave this alone and just let it die
in silence.

-- 
Jean Delvare
