Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbZDEJO7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 05:14:59 -0400
Date: Sun, 5 Apr 2009 06:14:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jean Delvare <khali@linux-fr.org>, Mike Isely <isely@pobox.com>,
	isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
Message-ID: <20090405061432.4165eabf@pedra.chehab.org>
In-Reply-To: <200904050746.47451.hverkuil@xs4all.nl>
References: <20090404142427.6e81f316@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	<20090405010539.187e6268@hyperion.delvare>
	<200904050746.47451.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009 07:46:47 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Sunday 05 April 2009 01:05:39 Jean Delvare wrote:
> > Hi Mike,
> >
> > On Sat, 4 Apr 2009 10:51:01 -0500 (CDT), Mike Isely wrote:
> > > Nacked-by: Mike Isely <isely@pobox.com>
> > >
> > > This will interfere with the alternative use of LIRC drivers (which
> > > work in more cases that ir-kbd).
> >
> > Why then is ir-kbd in the kernel tree and not LIRC drivers?
> >
> > > It will thus break some peoples' use of the driver.
> >
> > Do you think it will, or did you test and it actually does? If it
> > indeed breaks, please explain why, so that a solution can be found.
> >
> > > Also we have better information on what i2c addresses needed to
> > > be probed based on the model of the device
> >
> > This is excellent news. As I said in the header comment of the patch,
> > avoiding probing when we know what the IR receiver is and at which
> > address it sits is the way to go. Please send me all the information
> > you have and I'll be happy to add a patch to the series, that skips
> > probing whenever possible. Or write that patch yourself if you prefer.
> >
> > > - and some devices supported
> > > by this device are not from Hauppauge so you are making a too-strong
> > > assumption that IR should be probed this way in all cases.
> >
> > I didn't make any assumption, sorry. I simply copied the code from
> > ir-kbd-i2c. If my code does the wrong thing for some devices, that was
> > already the case before. And this will certainly be easier to fix after
> > my changes than before.
> >
> > On top of that, the "Hauppauge trick" is really only the order in which
> > the addresses are probed. Just because a specific order is better for
> > Hauppauge boards, doesn't mean it won't work for non-Hauppauge boards.
> >
> > > Also, unless
> > > ir-kbd has suddenly improved, this will not work at all for HVR-1950
> > > class devices nor MCE type PVR-24xxx devices (different incompatible IR
> > > receiver).
> >
> > I'm sorry but you can't blame me for ir-kbd-i2c not supporting some
> > devices. I updated the driver to make use of the new binding model, but
> > that's about all I did.
> >
> > > This is why the pvrusb2 driver has never directly attempted to load
> > > ir-kbd.
> >
> > The pvrusb2 driver however abuses the bttv driver's I2C adapter ID
> > (I2C_HW_B_BT848) and was thus affected when ir-kbd-i2c is loaded. This
> > is the only reason why my patch touches the pvrusb2 driver. If you tell
> > me you want the ir-kbd-i2c driver to leave pvrusb2 alone, I can drop
> > all the related changes from my patch, that's very easy.
> 
> Let's keep it simple: add a 'load_ir_kbd_i2c' module option for those 
> drivers that did not autoload this module. The driver author can refine 
> things later (I'll definitely will do that for ivtv).
> 
> It will be interesting if someone can find out whether lirc will work at all 
> once autoprobing is removed from i2c. If it isn't, then perhaps that will 
> wake them up to the realization that they really need to move to the 
> kernel.
> 
> The new mechanism is the right way to do it: the adapter driver has all the 
> information if, where and what IR is used and so should be the one to tell 
> the kernel what to do. Attempting to autodetect and magically figure out 
> what IR might be there is awkward and probably impossible to get right 
> 100%.
> 
> Hell, it's wrong already: if you have another board that already loads 
> ir-kbd-i2c then if you load ivtv or pvrusb2 afterwards you get ir-kbd-i2c 
> whether you like it or not, because ir-kbd-i2c will connect to your i2c 
> adapter like a leech. So with the addition of a module option you at least 
> give back control of this to the user.
> 
> When this initial conversion is done I'm pretty sure we can improve 
> ir-kbd-i2c to make it easier to let the adapter driver tell it what to do. 
> So we don't need those horrible adapter ID tests and other magic that's 
> going on in that driver. But that's phase two.

IMO, doing all those tricks to support an out-of-tree driver is the wrong
approach. This is just postponing a more serious discussion about what should
be done in kernel, in order to better support IR's.

In the case of lirc, the userspace part has already an event interface. If the
drivers are doing the right thing with their IR part, lirc can just use the
event interface for all drivers. This seems to be the proper approach.

>From what I got from Andy and Mike's comments is that the real issue is that
the IR kernel code is incomplete, broken or bad designed. So, several users and
userspace apps don't rely on the kernel code but, instead, use lirc as an
alternative.

That's said, I propose a different approach:

1) Add some entry at feature-removal-schedule.txt posting a date to end support
   for out-of-tree I2C IR modules;

2) Start discussing with lirc people (and input/event maintainers if needed)
about what is needed to properly support the required functionalities for a
better lirc usage;

3) Propose a few API additions in order to support those functionalities;

4) apply IR patches on kernel to support the missing functionalities;

5) remove the support for out-of-tree i2c IR modules.


Cheers,
Mauro
