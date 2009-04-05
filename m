Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:36623 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZDESsH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 14:48:07 -0400
Date: Sun, 5 Apr 2009 13:48:02 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
In-Reply-To: <200904050746.47451.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0904051340570.32738@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net> <20090405010539.187e6268@hyperion.delvare>
 <200904050746.47451.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009, Hans Verkuil wrote:

   [...]

> 
> Let's keep it simple: add a 'load_ir_kbd_i2c' module option for those 
> drivers that did not autoload this module. The driver author can refine 
> things later (I'll definitely will do that for ivtv).

Yes, and I will do the same for pvrusb2.  Simple is good.


> 
> It will be interesting if someone can find out whether lirc will work at all 
> once autoprobing is removed from i2c. If it isn't, then perhaps that will 
> wake them up to the realization that they really need to move to the 
> kernel.

It's probably going to break, and that will wake them up.  There's no 
choice otherwise.


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

Yes, I know this is a possibility.  It sucks and long term the new 
mechanism is the solution.  I don't want anyone to think I am against 
the new mechanism.  I'm for it.  But I'd like to minimize the damage 
potential on the way there.


> 
> When this initial conversion is done I'm pretty sure we can improve 
> ir-kbd-i2c to make it easier to let the adapter driver tell it what to do. 
> So we don't need those horrible adapter ID tests and other magic that's 
> going on in that driver. But that's phase two.

My impression (at least for pvrusb2-driven devices) is that the later IR 
receivers require a completely different driver to work properly; one 
can't just bolt additional features into ir-kbd-i2c for this.  In lirc's 
case, a different driver is in fact used.  But you know this already.

I haven't looked at ir-kbd-i2c in a while, but one other thing I 
seriously did not like about it was that the mapping of IR codes to key 
events was effectively hardcoded in the driver.  That makes it difficult 
to make the same driver work with different kinds of remotes.  Even if 
the bridge driver (e.g. pvrusb2) were to supply such a map, that's still 
wrong because it's within the realm of possibility that the user might 
actually want to use a different remote transmitter (provided it is 
compatible enough to work with the receiver hardware).  The lirc 
architecture solves this easily via a conf file in userspace.  In fact, 
lirc can map multiple mappings to a single receiver, permitting it to 
work concurrently with more than one remote.  But is such a thing even 
possible with ir-kbd-i2c?  I know this is one reason people tend to 
choose lirc.

  -Mike

-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
