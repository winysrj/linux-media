Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:14586 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZDEOGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 10:06:02 -0400
Date: Sun, 5 Apr 2009 16:05:19 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
Message-ID: <20090405160519.629ee7d0@hyperion.delvare>
In-Reply-To: <200904050746.47451.hverkuil@xs4all.nl>
References: <20090404142427.6e81f316@hyperion.delvare>
	<Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	<20090405010539.187e6268@hyperion.delvare>
	<200904050746.47451.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, 5 Apr 2009 07:46:47 +0200, Hans Verkuil wrote:
> Let's keep it simple: add a 'load_ir_kbd_i2c' module option for those 
> drivers that did not autoload this module. The driver author can refine 
> things later (I'll definitely will do that for ivtv).

I'd rather name the parameter "disable_ir", to make it consistent with
what other bridge drivers already use, and also because what the
parameter really does is preventing I2C devices from being
instantiated, _not_ preventing the ir-kbd-i2c module from loading.

I have a patch doing that already, it's pretty simple, I'll post it in
a minute.

> It will be interesting if someone can find out whether lirc will work at all 
> once autoprobing is removed from i2c. If it isn't, then perhaps that will 
> wake them up to the realization that they really need to move to the 
> kernel.

lirc_i2c will break, it still uses the legacy binding model. That's
what you get for living outside the kernel tree... Upgrading it
shouldn't be too hard, given that the difficult part is to update the
bridge drivers and I've already taken care of this part (although
lirc_i2c might need to probe more addresses than ir-kbd-i2c does).

> The new mechanism is the right way to do it: the adapter driver has all the 
> information if, where and what IR is used and so should be the one to tell 
> the kernel what to do. Attempting to autodetect and magically figure out 
> what IR might be there is awkward and probably impossible to get right 
> 100%.

I wholeheartedly agree.

> Hell, it's wrong already: if you have another board that already loads 
> ir-kbd-i2c then if you load ivtv or pvrusb2 afterwards you get ir-kbd-i2c 
> whether you like it or not, because ir-kbd-i2c will connect to your i2c 
> adapter like a leech. So with the addition of a module option you at least 
> give back control of this to the user.

Totally correct. The current mess^Wmodel vaguely works when a single TV
card is present, but mixing different TV cards in the same system would
certainly break. Admittedly this is probably not a very common case, I
guess the vast majority of users have a single TV card.

> When this initial conversion is done I'm pretty sure we can improve 
> ir-kbd-i2c to make it easier to let the adapter driver tell it what to do. 
> So we don't need those horrible adapter ID tests and other magic that's 
> going on in that driver. But that's phase two.

Please note that my conversion _already_ no longer makes any use of
adapter IDs. What it still does is probing, except for a few selected
cards (AVerMedia Cardbus and MSI TV@nywhere Plus). The idea is clearly
to turn probing into a fallback and use per-card data for IR device
instantiation the first choice for as many cards as possible in the
future.

Updated patch set is available at:
http://jdelvare.pck.nerim.net/linux/ir-kbd-i2c/

Changes since previous version:
* Dropped cx18 changes on request by Andy Walls.
* Added disable_ir module parameter to all bridge drivers which didn't
  have it.

-- 
Jean Delvare
