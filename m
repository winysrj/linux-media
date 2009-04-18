Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:48663 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZDRNxi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Apr 2009 09:53:38 -0400
Date: Sat, 18 Apr 2009 08:53:35 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/6] ir-kbd-i2c: Switch to the new-style device binding
  model
In-Reply-To: <20090418151625.254e466b@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904180842110.19718@cnc.isely.net>
References: <20090417222927.7a966350@hyperion.delvare>
 <20090417223105.28b8957e@hyperion.delvare> <Pine.LNX.4.64.0904171831300.19718@cnc.isely.net>
 <20090418112519.774e0dae@hyperion.delvare> <20090418151625.254e466b@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 18 Apr 2009, Jean Delvare wrote:

> Hi again Mike,
> 
> On Sat, 18 Apr 2009 11:25:19 +0200, Jean Delvare wrote:
> > On Fri, 17 Apr 2009 18:35:55 -0500 (CDT), Mike Isely wrote:
> > > I thought we were going to leave the pvrusb2 driver out of this since 
> > > I've already got a change ready that also includes additional logic to 
> > > take into account the properties of the hardware device (i.e. only 
> > > activate ir-kbd-i2c when we know it has a chance of working).
> > 
> > Hmm, I thought that our latest discussions had (at least partly)
> > obsoleted your patches. Remember that we want to always instantiate
> > ir_video I2C devices even when ir-kbd-i2c can't driver them, otherwise
> > lirc won't be able to bind to the devices in question as soon as the
> > legacy binding model is gone. So the conditionals in your second patch
> > (which is all that makes it differ from mine) are no longer desirable.

Jean:

The differences between my patch(es) and yours are:

1. My patch only attempts to bind the driver if the hardware actually 
supports it.

2. My patch selects the right I2C address for the case(s) where it makes 
sense to bind.

3. My patch provides a module option to completely disable binding.

You are probably thinking about (3) but you forgot that I had also taken 
care of (1).  Difference (1) is why I don't want your patch.  If your 
patch gets merged I will have to partially redo my patch to make (1) 
work again.

When I had issued my pull request to Mauro (which he didn't pull), there 
were actually 2 patches.  The first one dealt with (1) and the second 
dealt with (2) and (3), while taking advantage of (1).  Had Mauro pulled 
those patches at that time then you could have made further changes on 
top without losing (1).  But since he didn't, it's best just to leave 
the pvrusb2 driver alone and I'll make the needed additional change(s) 
there after your stuff is merged.


> > 
> > I'll work on lirc patches today or tomorrow, so that lirc doesn't break
> > when my patches hit mainline.
> 
> Speaking of this: do you know all the I2C addresses that can host IR
> devices on pvrusb2 cards? I understand that the only address supported
> by ir-kbd-i2c is 0x18, but I also need to know the addresses supported
> by lirc_i2c and possibly lirc_zilog, if you happen to know this.

Right now I only care about 0x18 (for 29xxx and early 24xxx devices).  
I noticed the thread where Andy got IR reception to work with ir-kbd-i2c 
using 0x71 (lirc_zilog type) and I suspect that same set of ir-kbd-i2c 
changes will probably work with the pvrusb2 driver for MCE 24xxx and 
HVR-1900/HVR-1950 devices.  But I figured once Andy's stuff gets into 
ir-kbd-i2c I'd simply test for this and if it worked I would make the 
appropriate adjustments in the pvrusb2 driver to enable ir-kbd-i2c 
binding in those cases as well (an easy change).  However even with that 
change, there are other pvrusb2-driven devices that cannot support 
ir-kbd-i2c.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
