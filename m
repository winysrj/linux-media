Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:51252 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbZKJABs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Nov 2009 19:01:48 -0500
Subject: Re: [PATCH 10/75] V4L/DVB: declare MODULE_FIRMWARE for modules
	using  XC2028 and XC3028L tuners
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
In-Reply-To: <20091109093702.1a74b709@pedra.chehab.org>
References: <1257630476.15927.400.camel@localhost>
	 <1257644240.6895.5.camel@palomino.walls.org>
	 <829197380911071744q50fc6e18o527322e1120b9689@mail.gmail.com>
	 <1257645834.15927.634.camel@localhost>
	 <20091108012042.798835dd@pedra.chehab.org>
	 <1257723149.3249.50.camel@pc07.localdom.local>
	 <20091108224313.705ec3cc@pedra.chehab.org>
	 <1257732169.3300.38.camel@pc07.localdom.local>
	 <20091109093702.1a74b709@pedra.chehab.org>
Content-Type: text/plain
Date: Tue, 10 Nov 2009 00:53:45 +0100
Message-Id: <1257810825.5540.8.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 09.11.2009, 09:37 -0200 schrieb Mauro Carvalho Chehab:
> Em Mon, 09 Nov 2009 03:02:49 +0100
> hermann pitton <hermann-pitton@arcor.de> escreveu:
> 
> > 
> > Am Sonntag, den 08.11.2009, 22:43 -0200 schrieb Mauro Carvalho Chehab:
> > > Em Mon, 09 Nov 2009 00:32:29 +0100
> > > hermann pitton <hermann-pitton@arcor.de> escreveu:
> > > 
> > > > > I agree. An interesting case happens with devices that uses tda10046 DVB demods.
> > > > > They have the firmware stored internally on their eeprom. Those firmwares can be
> > > > > replaced by a different version loaded in ram, but, in general, they work
> > > > > properly with the eeprom one. So, even having the firmware load code there,
> > > > > the firmware at /lib/firmware is optional.
> > > > 
> > > > Mauro, that could lead to some misunderstanding of the current use
> > > > conditions, at least on saa7134.
> > > > 
> > > > Minor annotations, the tda10046 does not store firmware internally, but
> > > > there are cards which have an extra eeprom to store such firmware.
> > > > 
> > > > If such a firmware eeprom is found and correctly configured, the driver
> > > > in all cases will load the firmware from that eeprom and all other
> > > > firmware in /lib/firmware is ignored.
> > > > 
> > > > If not, the firmware will be loaded from /lib/firmware.
> > > > 
> > > > For all what I know, firmware revisions 26 and 29 are both valid
> > > > "enough", correspondents to what we can load either from TechnoTrend or
> > > > LifeView with the getfirmware script, and might be either stored in an
> > > > extra eeprom or loaded from host/file.
> > > > 
> > > > Prior revisions had issues with missing freqs, in what combination ever.
> > > > 
> > > > We also can't totally exclude, given the whole mass of such, that in
> > > > some cases firmware eeproms might exist on some boards, but are not
> > > > correctly configured and load from host only because of that.
> > > > 
> > > > The tendency seen overall is that competitors save the few cents for an
> > > > extra firmware eeprom these days ...
> > > 
> > > Yes, I know. I have myself a Cardbus device with such eeprom (I think it has
> > > revision 29 stored at the eeprom).
> > > 
> > > The point is that it is not mandatory for such devices to have a firmware
> > > at the filesystem for the device to work. So, a static indication that
> > > devices with tda10046 need firmware is wrong, since some devices don't need
> > > it.
> > 
> > There are of course lots of devices needing the firmware mandatory at
> > the file system. I try to tell that it is not a mistake, in case the
> > device has no firmware on an extra eeprom, to store latest revision
> > in /lib/firmware. Or tell me better ...
> > 
> > But also, OEMs a little bit more motivated on new hardware will not
> > count the costs of an extra firmware eeprom, if being first in having
> > substantial amounts of chips and get a good deal for such. But that was
> > the past.
> > 
> > > Cheers,
> > > Mauro
> > 
> > Else I do totally agree.
> > 
> > I do just point to some ambiguous conditions we should stay aware of.
> > 
> > It is very unlikely that we can "talk" them away.
> > 
> > Do we have all firmware loaded from eeproms possibly existing on cards
> > is only one minor question.
> > 
> > Maybe we miss some.
> > 
> > Should we not even better avoid such, since still no official update for
> > firmware eeprom flashing?
> > 
> > To restore the bridge eeprom we seem to be not such bad now, but also
> > the reasons for a possible corruption are far from clearly identified in
> > case we should be involved in it.
> > 
> > Despite of legal issues, we should have the latest revision of the
> > tda10046 firmware at the host. As said, those having it at an extra
> > eeprom will load it anyway from there.
> 
> Hermann, maybe you missed the point here: the driver will keep dynamically
> loading the modules at the right place, for the devices that really need
> firmwares to run.
> 
> The issue I'm seeing is that the MODULE_FIRMWARE series of patches is adding an
> static meta-tag that indicates that the devices associated with a driver will
> need one or more firmwares, with the specified names at the tag.
> 
> While it is not clear on Ben's proposal how those userspace tools will be,
> considering that he is concerning about initramfs and that there are devices
> (like for example rtl8192u) that needs several firmwares to run, in order to
> properly work for initramfs, the tools should assume that all firmwares using
> the tag will be needed for that device, to be sure that the machine won't hang
> during the boot.
> 
> In the case of the v4l-dvb devices, the firmware needs are dynamic.
> 
> For example, in the case of tuner-xc2028, you need _OR_ xc3028 _OR_ xc3028l
> firmwares (and, if considering tm6000 devices, you may need firmware version 1
> for older devices). In the case of tda10046, some devices will need a firmware,
> while others won't need. 
> 
> So, you'll only know what firmware is really needed at runtime.
> 
> An alternative for a static table would be to associate the firmware needs
> to the USB and PCI ID's, but even the USB/PCI ID tables will also have some
> troubles. For example, the flexcop driver supports 7 different versions of a
> device, all sharing the same PCI ID, but each version requires a different
> frontend. The driver only knows what frontend is needed at runtime, after
> probing the i2c bus at the device.

sorry, if I did not follow up close enough. The flexcop driver is really
a good example.

> So, the main point here is that a tag like this is useless for the devices under
> drivers/media. The only way to really know for sure what firmware is needed on
> a particular hardware is to catch the firmware requests. If such check is
> really needed, the better is to add a hook at the userspace, catching all
> requests for firmwares for the detected hardware. Such usage will get 100% of
> the cases and won't require any kernel changes.
> 
> That's said, I can fully understand the utility of that having a tag like that
> for block and network devices that needs to load a firmware during boot time,
> at initramfs. As you need to access the hard disk or the network in order to
> mount the file system, having the proper firmware there is mandatory.
> 
> Except for those kind of devices, we shouldn't be adding MODULE_FIRMWARE to
> other random devices, especially where the firmware requirements cannot be
> specified by a static rule.
> 
> Cheers,
> Mauro

I for sure don't vote for having v4l-dvb firmware at boot available.

My maybe a little narrowed view is focused on the question, if we can
have latest tda10046 firmware at /lib/firmware and if there are any
cases known, like on other drivers, not to have it there.

If there are no known issues with latest, we should ask Philips/NXP if
we are allowed to distribute it with the kernel.

Cheers,
Hermann




