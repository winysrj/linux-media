Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:45651 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994Ab0AQA6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 19:58:35 -0500
Subject: Re: How to use saa7134 gpio via gpio-sysfs?
From: hermann pitton <hermann-pitton@arcor.de>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Gordon Smith <spider.karma+linux-media@gmail.com>,
	linux-media@vger.kernel.org
In-Reply-To: <1263686928.3394.4.camel@pc07.localdom.local>
References: <2df568dc1001111012u627f07b8p9ec0c2577f14b5d9@mail.gmail.com>
	 <2df568dc1001111059p54de8635k6c207fb3f4d96a14@mail.gmail.com>
	 <1263266020.3198.37.camel@pc07.localdom.local>
	 <1263602137.3184.23.camel@pc07.localdom.local>
	 <Pine.LNX.4.58.1001151650410.4729@shell2.speakeasy.net>
	 <1263622815.3178.31.camel@pc07.localdom.local>
	 <Pine.LNX.4.58.1001160400230.4729@shell2.speakeasy.net>
	 <1263686928.3394.4.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Sun, 17 Jan 2010 01:52:24 +0100
Message-Id: <1263689544.8899.3.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Sonntag, den 17.01.2010, 01:08 +0100 schrieb hermann pitton:
> Am Samstag, den 16.01.2010, 04:15 -0800 schrieb Trent Piepho:
> > On Sat, 16 Jan 2010, hermann pitton wrote:
> > > Am Freitag, den 15.01.2010, 17:27 -0800 schrieb Trent Piepho:
> > > > On Sat, 16 Jan 2010, hermann pitton wrote:
> > > > > Am Dienstag, den 12.01.2010, 04:13 +0100 schrieb hermann pitton:
> > > > > > > gpio-sysfs creates
> > > > > > >     /sys/class/gpio/export
> > > > > > >     /sys/class/gpio/import
> > > > > > > but no gpio<n> entries so far.
> > > >
> > > > The saa713x driver predates the generic gpio layer by years and years, so
> > > > it doesn't use it.  It also doesn't need to use it.  Since the gpios are
> > > > managed by the saa713x driver, and they also used by the saa713x driver,
> > > > there is no need to interface two different drivers together.  There are
> > > > tons of drivers for devices that have gpios like this, but they don't use
> > > > the gpio layer.
> > > >
> > > > But with gpio access via sysfs for generic gpios, there is something useful
> > > > about having the saa713x driver support generic gpios.  IIRC, somehow wrote
> > > > a gpio only bt848 driver that didn't do anything but export gpios.
> > > >
> > > > In order to do this, you'll have to write code for the saa7134 driver to
> > > > have it register with the gpio layer.  I think you could still have the
> > > > saa7134 driver itself use its gpio directly.  That would avoid a
> > > > performance penalty in the driver.
> > >
> > > Thanks for more details, but I'm still wondering what pins ever could be
> > > interesting in userland, given that they are all treated such different
> > > per device, and we count up to 200 different boards these days.
> > 
> > There are some cards for intended for survilence or embedded applications
> > that have headers on them to connect things to the GPIOs.  Like alarms or
> > camera controllers and stuff like that.
> > 
> > The GPIO only bttv driver was created by someone who just soldered a bunch
> > of wires on a cheap bt848 card, you can get them for just a few dollars, as
> > it was a cheap and easy way to get a bunch of gpios in a pc.  See his page
> > here http://www.bu3sch.de/joomla/index.php/bt8xx-based-gpio-card
> > 
> > There are cards you can get that just have GPIOs, but they end up being
> > rather expensive.  Here's one:
> > http://www.acromag.com/parts.cfm?Model_ID=317&Product_Function_ID=4&Category_ID=18&Group_ID=1
> > Way fancier than a tv card, but it's $600.
> > 
> > I think if I was doing the coding, I'd add a field in the card description
> > for what GPIOs should be exported.  I.e., which ones have an external
> > header.  Maybe in addition to, or instead of, I'd have a module option that
> > would cause GPIOs to be exported.  A bitmask of which to export would be
> > enough.
> 
> Cool stuff!
> 
> Are we aware of boards under mass production connecting unused gpios to
> a panel already, providing external gpio functionality?
> 
> The RTD one in question seems not to do so yet.
> 
> http://www.rtd.com/pc104/UM/video/VFG7350ER.htm

Damned, seems the opto-isolated I/Os might be in question.

For the RTD stuff we don't have any high resolution photographs or
anything else ...


