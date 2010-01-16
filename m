Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:41953 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab0APBeO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 20:34:14 -0500
Date: Fri, 15 Jan 2010 17:27:34 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: hermann pitton <hermann-pitton@arcor.de>
cc: Gordon Smith <spider.karma+linux-media@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: How to use saa7134 gpio via gpio-sysfs?
In-Reply-To: <1263602137.3184.23.camel@pc07.localdom.local>
Message-ID: <Pine.LNX.4.58.1001151650410.4729@shell2.speakeasy.net>
References: <2df568dc1001111012u627f07b8p9ec0c2577f14b5d9@mail.gmail.com>
 <2df568dc1001111059p54de8635k6c207fb3f4d96a14@mail.gmail.com>
 <1263266020.3198.37.camel@pc07.localdom.local> <1263602137.3184.23.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 16 Jan 2010, hermann pitton wrote:
> Am Dienstag, den 12.01.2010, 04:13 +0100 schrieb hermann pitton:
> > > gpio-sysfs creates
> > >     /sys/class/gpio/export
> > >     /sys/class/gpio/import
> > > but no gpio<n> entries so far.

You have to explictly export the GPIO lines to get them to appear.  Either
in the kernel with gpio_export() or from sysfs.  You also can't export
GPIOs that something in the kernel is using.  My original design didn't
have this restriction.  I felt there were valid debug and development
reasons for doing so, having used them myself for debug and development of
embedded systems, but David Brownell felt otherwise.  I didn't even have
the concept of export originally, all the gpios would show up.  After all,
all your PCI and USB devices, I2C chips or busses, etc.  show up in sysfs.
Nothing else does this "must be exported to show up" business.  You can
memory map the saa7133 PCI address space and modify the gpios, and anything
else, with direct register access from userspace, and that's just fine.
But being able to observe and modify the gpios with a gpio-only interface
is just way too dangerous.  Doesn't make sense.  But I'm digressing.

This sysfs interface only works with the gpio using the generic gpio layer.
This was designed for generic gpios on SoCs that would be providing by some
kind of platform driver or I2C gpio extenders.  The gpios get and used by
various other drivers.  Like say write protects on memory cards, or system
LEDs.  I wrote a JTAG driver that used it.  The point of the gpio layer is
to interface drivers the provide gpios with other, different, drivers that
use the gpio.  It was introduced in the mid 2.6.20s IIRC.

The saa713x driver predates the generic gpio layer by years and years, so
it doesn't use it.  It also doesn't need to use it.  Since the gpios are
managed by the saa713x driver, and they also used by the saa713x driver,
there is no need to interface two different drivers together.  There are
tons of drivers for devices that have gpios like this, but they don't use
the gpio layer.

But with gpio access via sysfs for generic gpios, there is something useful
about having the saa713x driver support generic gpios.  IIRC, somehow wrote
a gpio only bt848 driver that didn't do anything but export gpios.

In order to do this, you'll have to write code for the saa7134 driver to
have it register with the gpio layer.  I think you could still have the
saa7134 driver itself use its gpio directly.  That would avoid a
performance penalty in the driver.
