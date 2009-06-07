Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:36309 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755679AbZFGVGj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2009 17:06:39 -0400
Subject: Re: RFC: proposal for new i2c.h macro to initialize i2c address
	lists  on the fly
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
Cc: Jon Smirl <jonsmirl@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-i2c@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <1244404831.3141.33.camel@palomino.walls.org>
References: <200906061500.49338.hverkuil@xs4all.nl>
	 <9e4733910906061520o7b0b2858wf4530cf672b1adc9@mail.gmail.com>
	 <200906070835.46989.hverkuil@xs4all.nl>
	 <9e4733910906070625i74477c9ma422b061eb61449d@mail.gmail.com>
	 <1244404831.3141.33.camel@palomino.walls.org>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 23:01:22 +0200
Message-Id: <1244408482.9764.33.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 07.06.2009, 16:00 -0400 schrieb Andy Walls:
> On Sun, 2009-06-07 at 09:25 -0400, Jon Smirl wrote:
> > On Sun, Jun 7, 2009 at 2:35 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> > > On Sunday 07 June 2009 00:20:26 Jon Smirl wrote:
> > >> On Sat, Jun 6, 2009 at 9:00 AM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> > >> > Hi all,
> > >> >
> > >> > For video4linux we sometimes need to probe for a single i2c address.
> > >> > Normally you would do it like this:
> > >>
> > >> Why does video4linux need to probe to find i2c devices? Can't the
> > >> address be determined by knowing the PCI ID of the board?
> > >
> > > There are two reasons we need to probe: it is either because when the board
> > > was added no one bothered to record which chip was on what address (this
> > > happened in particular with old drivers like bttv) or because there is
> > > simply no other way to determine the presence or absence of an i2c device.
> > 
> > Unrecorded boards could be handled by adding a printk at driver init
> > time asking people to email you the needed information. Then remove
> > the printks as soon as you get the answer.
> > 
> > >
> > > E.g. there are three versions of one card: without upd64083 (Y/C separation
> > > device) and upd64031a (ghost reduction device), with only the upd64031a and
> > > one with both. Since they all have the same PCI ID the only way to
> > > determine the model is to probe.
> > 
> > Did they happen to change the subsystem device_id? There are two pairs
> > of PCI IDs on each card. Most of the time the subsystem vendor/device
> > isn't set.
> > 
> > Getting rid of the probes altogether is the most reliable solution.
> > There is probably a way to identify these boards more specifically
> > that you haven't discovered yet.  PCI subsystem device ID is worth
> > checking.
> 
> Jon,
> 
> This really is a well beaten topic for v4l-dvb devices.
> 
> 1. Device IDs are used to identify the bridge chip.
> 2. Subsystem IDs are used to identify the specfic card.
> 3. Vendor provided serial EEPROMs (sitting at 8-bit I2C address 0xA0)
> can provide some amplifying information about the board layout.
> 
> There is variation in the I2C peripherals used on a video card PCB per
> any Subsystem ID.  It's not a granular enough descriptor.
> 
> The data from serial EEPROMs, if the vendor was nice enough to even
> include one, may not have a known decoding.  
> 
> I agree that I2C probing is bad/undesirable.  But for some video boards,
> there is no other way than probing without each end user having expert
> knowledge of the PCB layout.
> 
> Not probing, for cases where there is no other automated means to divine
> the I2C devices used, would likely require an annoying or unsutainable
> level of end user support be provided from a volunteer community.
> 
> Regards,
> Andy

about detecting and identifying i2c devices on a TV card it is really a
long story ...

Everybody talking about such should have at least a look at the bttv
driver before announcing RFC stuff.

It should make wonder, what all is used to come around.
(resistors on unused gpios for example)

On later drivers, like the saa7134, there were really high hopes to get
out of that previous total misery, highest respect to all sorting it
however possible and did it well then, by reliable PCI subsystem stuff.

But to give one more example, Asus, by far not the worst, did force the
users to uninstall all other TV card drivers on their m$ systems in
2005, if the tda8275a hybrid should be in use. (don't work anymore ...)

On that we have always been much better!

Jon's suggestions are on the level of 2002 and he is not in any details.

Cheers,
Hermann

 

> > > Regards,
> > >
> > >        Hans
> > >
> > >>
> > >> > static const unsigned short addrs[] = {
> > >> >        addr, I2C_CLIENT_END
> > >> > };
> > >> >
> > >> > client = i2c_new_probed_device(adapter, &info, addrs);
> > >> >
> > >> > This is a bit awkward and I came up with this macro:
> > >> >
> > >> > #define V4L2_I2C_ADDRS(addr, addrs...) \
> > >> >        ((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })
> > >> >
> > >> > This can construct a list of one or more i2c addresses on the fly. But
> > >> > this is something that really belongs in i2c.h, renamed to I2C_ADDRS.
> > >> >
> > >> > With this macro we can just do:
> > >> >
> > >> > client = i2c_new_probed_device(adapter, &info, I2C_ADDRS(addr));
> > >> >
> > >> > Comments?
> > >> >
> > >> > Regards,
> > >> >
> > >> >        Hans
> > >> >


