Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:39886 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbZDWJBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2009 05:01:30 -0400
Date: Thu, 23 Apr 2009 11:00:38 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mike Isely <isely@pobox.com>
Cc: isely@isely.net, LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/6] ir-kbd-i2c: Switch to the new-style device binding
   model
Message-ID: <20090423110038.59554982@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.0904180842110.19718@cnc.isely.net>
References: <20090417222927.7a966350@hyperion.delvare>
	<20090417223105.28b8957e@hyperion.delvare>
	<Pine.LNX.4.64.0904171831300.19718@cnc.isely.net>
	<20090418112519.774e0dae@hyperion.delvare>
	<20090418151625.254e466b@hyperion.delvare>
	<Pine.LNX.4.64.0904180842110.19718@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

Sorry for the late answer.

On Sat, 18 Apr 2009 08:53:35 -0500 (CDT), Mike Isely wrote:
> On Sat, 18 Apr 2009, Jean Delvare wrote:
> > On Sat, 18 Apr 2009 11:25:19 +0200, Jean Delvare wrote:
> > > Hmm, I thought that our latest discussions had (at least partly)
> > > obsoleted your patches. Remember that we want to always instantiate
> > > ir_video I2C devices even when ir-kbd-i2c can't driver them, otherwise
> > > lirc won't be able to bind to the devices in question as soon as the
> > > legacy binding model is gone. So the conditionals in your second patch
> > > (which is all that makes it differ from mine) are no longer desirable.
> 
> Jean:
> 
> The differences between my patch(es) and yours are:
> 
> 1. My patch only attempts to bind the driver if the hardware actually 
> supports it.

That's not clear to me. I seem to understand that your patch
instantiates the ir_video device if and only if the ir-kbd-i2c driver
supports it. This is not what we want to do. We want to create the
ir_video device if an IR receiver exists, even if ir-kbd-i2c doesn't
support it. The reason is that ir-kbd-i2c could be extended to support
the IR receiver in question in the future, and that alternative drivers
(lirc_i2c comes to mind) could also be used.

I also don't understand why you use i2c_new_probed_device() rather than
i2c_new_device() if you already know for sure that the IR receiver
device is present?

> 2. My patch selects the right I2C address for the case(s) where it makes 
> sense to bind.

This is a good thing, although your implementation isn't exactly what I
would expect. The address list should depend on the value of
hdw->ir_scheme_active. At the moment you support only 2 schemes and
they happen to use the same I2C address, but I presume this will change
in the future.

> 3. My patch provides a module option to completely disable binding.

I agree this can be useful, as discussed earlier, although I still
object to the name you chose (disable_autoload_ir_kbd). This module
option is only remotely related to the i2c binding model change.

> You are probably thinking about (3) but you forgot that I had also taken 
> care of (1).  Difference (1) is why I don't want your patch.  If your 
> patch gets merged I will have to partially redo my patch to make (1) 
> work again.

This is correct. But if your second patch is merged before my own
changes, then IR support will be broken for all pvrusb2 users, unless
they temporarily load the driver with disable_autoload_ir_kbd=1. But
they will have to remove the parameter as soon as my own patches are
merged. This approach doesn't strike me as the best user experience.

If my patches are merged first and yours go second (which I admit means
you'll have to adjust your patches a bit) then everything will keep
working for the user. This is the reason why I was proposing this order.

> When I had issued my pull request to Mauro (which he didn't pull), there 
> were actually 2 patches.  The first one dealt with (1) and the second 
> dealt with (2) and (3), while taking advantage of (1).  Had Mauro pulled 
> those patches at that time then you could have made further changes on 
> top without losing (1).  But since he didn't, it's best just to leave 
> the pvrusb2 driver alone and I'll make the needed additional change(s) 
> there after your stuff is merged.

I can't "leave the pvrusb2 driver alone", unless you consider it
acceptable that your users lose IR support between my patches and
yours. When ir-kbd-i2c is converted to the new-style i2c binding, all
bridge drivers must be updated too.

> > > I'll work on lirc patches today or tomorrow, so that lirc doesn't break
> > > when my patches hit mainline.
> > 
> > Speaking of this: do you know all the I2C addresses that can host IR
> > devices on pvrusb2 cards? I understand that the only address supported
> > by ir-kbd-i2c is 0x18, but I also need to know the addresses supported
> > by lirc_i2c and possibly lirc_zilog, if you happen to know this.
> 
> Right now I only care about 0x18 (for 29xxx and early 24xxx devices).

I've seen this, but this isn't my question. If lirc_i2c supports other
IR devices that are present on pvrusb2 devices, we must declare them as
well so that we don't break lirc_i2c. So, once again: do you know all
the I2C addresses where pvrusb2 cards can have IR devices?

> I noticed the thread where Andy got IR reception to work with ir-kbd-i2c 
> using 0x71 (lirc_zilog type) and I suspect that same set of ir-kbd-i2c 
> changes will probably work with the pvrusb2 driver for MCE 24xxx and 
> HVR-1900/HVR-1950 devices.  But I figured once Andy's stuff gets into 
> ir-kbd-i2c I'd simply test for this and if it worked I would make the 
> appropriate adjustments in the pvrusb2 driver to enable ir-kbd-i2c 
> binding in those cases as well (an easy change).  However even with that 
> change, there are other pvrusb2-driven devices that cannot support 
> ir-kbd-i2c.

I'm worried that this means doing several changes first and only then
converting ir-kbd-i2c to the new i2c binding model. Similar to Mauro
who was suggesting that we should merge lirc in the kernel first and
only the convert to the new i2c model. There is really no good reason to
delay the i2c binding model change, and I would like to remind everyone
that my point here was to take care of that quickly because it is
delaying other i2c changes.

I am willing to collaborate with you v4l-dvb people, but if your answer
is "we'll do many unrelated changes first and then we'll look at your
patches", this isn't acceptable. I would hate to push the changes to
Linus' tree directly without going through the v4l-dvb tree, as I know
this means more work for you, but if you do not give me any other
choice, it might happen.

-- 
Jean Delvare
