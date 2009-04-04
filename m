Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:50921 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbZDDX3q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2009 19:29:46 -0400
Date: Sat, 4 Apr 2009 18:29:35 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>, Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
In-Reply-To: <20090405010539.187e6268@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904041807300.32720@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
 <20090404142837.3e12824c@hyperion.delvare> <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
 <20090405010539.187e6268@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009, Jean Delvare wrote:

> Hi Mike,
> 
> On Sat, 4 Apr 2009 10:51:01 -0500 (CDT), Mike Isely wrote:
> > 
> > Nacked-by: Mike Isely <isely@pobox.com>
> > 
> > This will interfere with the alternative use of LIRC drivers (which work 
> > in more cases that ir-kbd).
> 
> Why then is ir-kbd in the kernel tree and not LIRC drivers?
> 

How should I know?  I don't maintain either.  But I know they are both 
used and it's not my place to force usage of one over the other.


> > It will thus break some peoples' use of the driver.
> 
> Do you think it will, or did you test and it actually does? If it
> indeed breaks, please explain why, so that a solution can be found.

As I interpret this, your patch will cause the pvrusb2 to probe for the 
IR receiver's I2C address and bind ir-kbd-i2c to what it finds.  That 
will break anyone's usage of the driver where another IR driver (e.g. 
something from LIRC) is used instead.


> 
> > Also we have better information on what i2c addresses needed to 
> > be probed based on the model of the device
> 
> This is excellent news. As I said in the header comment of the patch,
> avoiding probing when we know what the IR receiver is and at which
> address it sits is the way to go. Please send me all the information
> you have and I'll be happy to add a patch to the series, that skips
> probing whenever possible. Or write that patch yourself if you prefer.

I have samples of most of the devices in question and can code proper 
I2C addresses for each of those for each resident I2C client.  The 
pvrusb2 driver's device attribute structure already has allowance for 
specification of the correct I2C addresses to use for chips specific to 
each device (part of the v4l2-subdev rework I recently did).  Right now 
the driver has built in defaults, and if a particular model needs 
something else, it can be overridden as part of the device's profile in 
pvrusb2-devattr.c.


> 
> > - and some devices supported 
> > by this device are not from Hauppauge so you are making a too-strong 
> > assumption that IR should be probed this way in all cases.
> 
> I didn't make any assumption, sorry. I simply copied the code from
> ir-kbd-i2c. If my code does the wrong thing for some devices, that was
> already the case before. And this will certainly be easier to fix after
> my changes than before.

No, I think the point you are missing is that by moving that logic from 
ir-kbd-i2c into each driver (e.g. pvrusb2) you are moving logic that 
*might* be executed into a spot where it *will* be executed.  Remember 
that the pvrusb2 driver did not autoload ir-kbd-i2c before this patch.  
Before this change, a user could elect not to use ir-i2c-kbd simply by 
not loading it.  The pvrusb2 driver didn't request it, because the 
intent all along there is that the user makes the choice by loading the 
desired driver.  Now with this change, the pvrusb2 driver is going to 
attempt to load ir-kbd-i2c where asked for or not.  And if not, the 
resulting binding will prevent lirc_i2c from later on loading.  If the 
user had been loading lirc_i2c previously, this will cause his/her usage 
of IR to break.  No, it's not perfect, but it worked.  I'm all for 
improving things, but not by removing an ability that people are using.



> 
> On top of that, the "Hauppauge trick" is really only the order in which
> the addresses are probed. Just because a specific order is better for
> Hauppauge boards, doesn't mean it won't work for non-Hauppauge boards.

"Hauppauge trick"?


> 
> > Also, unless 
> > ir-kbd has suddenly improved, this will not work at all for HVR-1950 
> > class devices nor MCE type PVR-24xxx devices (different incompatible IR 
> > receiver).
> 
> I'm sorry but you can't blame me for ir-kbd-i2c not supporting some
> devices. I updated the driver to make use of the new binding model, but
> that's about all I did.

Yes, but I can point out that this change now will cause ir-kbd-i2c to 
be loaded in cases where the user didn't want it and will risk 
interference with the driver that the user *did* want.


> 
> > This is why the pvrusb2 driver has never directly attempted to load 
> > ir-kbd.
> 
> The pvrusb2 driver however abuses the bttv driver's I2C adapter ID
> (I2C_HW_B_BT848) and was thus affected when ir-kbd-i2c is loaded. This
> is the only reason why my patch touches the pvrusb2 driver. If you tell
> me you want the ir-kbd-i2c driver to leave pvrusb2 alone, I can drop
> all the related changes from my patch, that's very easy.

That "abuse" is a separate issue.  The pvrusb2 driver started a long 
time ago out-of-tree and at that time it was the only way to get IR to 
work at all.  Personally I forgot all about it back in 2005 and was only 
recently reminded that this situation still exists.  It should be fixed 
and I'd welcome the correct patch to fix this.  I haven't fixed it 
myself, because, well I've had much bigger fish to fry here.

I really don't want to throw rocks here; it's always better to work out 
the solution than simply block any changes at all.  I realize that 
something has to be done here in order to keep ir-kbd-i2c viable as a 
choice for users of the pvrusb2 driver.  To that end, how about this 
strategy:

1. Just drop the part of the patch for the pvrusb2 driver and get the 
rest merged.  Yes, I realize that this will break use of ir-kbd-i2c in 
cooperation with the pvrusb2 driver.

2. Once ir-kbd-i2c has been updated, I will push another set of changes 
into the pvrusb2 driver that will make it usable there.  Basically what 
I have in mind is similar to what you tried but I'm going to integrate 
it with the device profiles so that it can be appropriately loaded based 
on device model, with the correct I2C address in each case.  And most 
importantly, I will add a module option to enable/disable loading or 
ir-kbd-i2c.  This will fix my main objection, since then it will still 
allow lirc to be usable, for now...

3. I'd like to fix the "abuse" you mention regarding I2C_HW_B_BT848.  
I'm unclear on what the cleanest solution is there, but if you like to 
(a) point at some documentation, (b) describe what I should do, or (c) 
suggest a patch, I will work to deal with the problem.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
