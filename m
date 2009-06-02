Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:2454 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212AbZFBHMp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2009 03:12:45 -0400
Date: Tue, 2 Jun 2009 09:12:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-next@vger.kernel.org,
	linux-media@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Simplified CONFIG_I2C=n interface.
Message-ID: <20090602091229.0810f54b@hyperion.delvare>
In-Reply-To: <20090527120140.GC1970@sirena.org.uk>
References: <20090527070850.GA11221@linux-sh.org>
	<20090527091831.26b60d6d@hyperion.delvare>
	<20090527120140.GC1970@sirena.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mark,

On Wed, 27 May 2009 13:01:40 +0100, Mark Brown wrote:
> On Wed, May 27, 2009 at 09:18:31AM +0200, Jean Delvare wrote:
> 
> > Violent nack. Drivers which optionally use I2C are a minority.
> 
> It's extremely common for devices like the CODECs and PMICs used in
> embedded systems to have both I2C and SPI interfaces, selectable via a
> pin strap at power on.  It's less common to have the SPI option for
> things like hardware monitoring chips found in PCs but for anything that
> might be I/O bound the high speed interface is a very common option.

Can you please point me at a couple of affected drivers?

> > Designing them in such a way that a single #ifdef CONFIG_I2C will make
> > them work can't be that hard, really. Not to mention that having a
> > dozen stubs in i2c.h in the CONFIG_I2C=n case won't save you much work
> > at the driver level anyway, because you certainly need to run different
> > code paths depending on how the device is connected, and you also have
> > to differentiate between the "I2C support is missing" case and the "I2C
> > device registration failed" case, etc.
> 
> For the devices I've dealt with there's very little work at the driver
> level - the various interfaces that can be used each probe using the
> normal device model, set some register read/write operations and
> possibly some other things and then call into the bulk of the driver
> which has all the I/O abstracted away from it.

It might make sense to define stubs for the CONFIG_I2C=n case for a few
of the i2c API functions, which are called from common driver parts, in
particular i2c_add/del_driver(), and as a matter of fact we already do
this for i2c_register_board_info(). But for lower-level functions, this
sounds wrong. The lower-level functions will only ever be called in
functions which should be completely discarded if I2C support is
missing from the kernel, and I would not count on gcc to be smart
enough to really discard all the code thanks to the i2c API being all
stubs. Meaning you end up with drivers larger than they should be -
which is no good for embedded systems.

I would really expect all I2C-related code to be in one place of the
driver (or even in a separate source file) and same for SPI-related
code. Then surrounding one big block of code with an ifdef doesn't
sound that difficult to read.

> The error handling is already an issue with the current situation since
> people are just silently building out the I2C support when I2C is not
> enabled.  At the minute the main problem is with people not remembering
> to do the #ifdef (a lot of platforms really need I2C enabled to be
> useful so people never think to do the build without).

I can't think of a way to solve this, other than what you do today
(build without I2C support from times to times and fix what needs to
be.) At least today you have a link breakage that tells you a given
driver needs to be reviewed for the CONFIG_I2C=n case. If we add stubs
all around to workaround the link breakage, this means the review never
happens, so the code might as well build and link but not work properly
or at least not be optimal. I wouldn't call this progress.

What could be done, OTOH, is to surround all the function declarations
in <linux/i2c.h> with a simple #ifdef CONFIG_I2C, so that mistakes are
caught earlier (build time instead of link time.)

-- 
Jean Delvare
