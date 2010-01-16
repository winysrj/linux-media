Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:56448 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab0APGZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 01:25:09 -0500
Subject: Re: How to use saa7134 gpio via gpio-sysfs?
From: hermann pitton <hermann-pitton@arcor.de>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Gordon Smith <spider.karma+linux-media@gmail.com>,
	linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.58.1001151650410.4729@shell2.speakeasy.net>
References: <2df568dc1001111012u627f07b8p9ec0c2577f14b5d9@mail.gmail.com>
	 <2df568dc1001111059p54de8635k6c207fb3f4d96a14@mail.gmail.com>
	 <1263266020.3198.37.camel@pc07.localdom.local>
	 <1263602137.3184.23.camel@pc07.localdom.local>
	 <Pine.LNX.4.58.1001151650410.4729@shell2.speakeasy.net>
Content-Type: text/plain
Date: Sat, 16 Jan 2010 07:20:15 +0100
Message-Id: <1263622815.3178.31.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Freitag, den 15.01.2010, 17:27 -0800 schrieb Trent Piepho:
> On Sat, 16 Jan 2010, hermann pitton wrote:
> > Am Dienstag, den 12.01.2010, 04:13 +0100 schrieb hermann pitton:
> > > > gpio-sysfs creates
> > > >     /sys/class/gpio/export
> > > >     /sys/class/gpio/import
> > > > but no gpio<n> entries so far.
> 
> You have to explictly export the GPIO lines to get them to appear.  Either
> in the kernel with gpio_export() or from sysfs.  You also can't export
> GPIOs that something in the kernel is using.  My original design didn't
> have this restriction.  I felt there were valid debug and development
> reasons for doing so, having used them myself for debug and development of
> embedded systems, but David Brownell felt otherwise.  I didn't even have
> the concept of export originally, all the gpios would show up.  After all,
> all your PCI and USB devices, I2C chips or busses, etc.  show up in sysfs.
> Nothing else does this "must be exported to show up" business.  You can
> memory map the saa7133 PCI address space and modify the gpios, and anything
> else, with direct register access from userspace, and that's just fine.
> But being able to observe and modify the gpios with a gpio-only interface
> is just way too dangerous.  Doesn't make sense.  But I'm digressing.
> 
> This sysfs interface only works with the gpio using the generic gpio layer.
> This was designed for generic gpios on SoCs that would be providing by some
> kind of platform driver or I2C gpio extenders.  The gpios get and used by
> various other drivers.  Like say write protects on memory cards, or system
> LEDs.  I wrote a JTAG driver that used it.  The point of the gpio layer is
> to interface drivers the provide gpios with other, different, drivers that
> use the gpio.  It was introduced in the mid 2.6.20s IIRC.
> 
> The saa713x driver predates the generic gpio layer by years and years, so
> it doesn't use it.  It also doesn't need to use it.  Since the gpios are
> managed by the saa713x driver, and they also used by the saa713x driver,
> there is no need to interface two different drivers together.  There are
> tons of drivers for devices that have gpios like this, but they don't use
> the gpio layer.
> 
> But with gpio access via sysfs for generic gpios, there is something useful
> about having the saa713x driver support generic gpios.  IIRC, somehow wrote
> a gpio only bt848 driver that didn't do anything but export gpios.
> 
> In order to do this, you'll have to write code for the saa7134 driver to
> have it register with the gpio layer.  I think you could still have the
> saa7134 driver itself use its gpio directly.  That would avoid a
> performance penalty in the driver.

Thanks for more details, but I'm still wondering what pins ever could be
interesting in userland, given that they are all treated such different
per device, and we count up to 200 different boards these days.

For now, we should only allow user control over such pins above any
count from 0 to 27, what the m$ driver does rounding up nothing ;)

Or is there one single pin, potentially useful in userland?

They can all be ambiguous, multi purpose per device, for what I can see.

Cheers,
Hermann








