Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:34080 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670AbZKICIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Nov 2009 21:08:45 -0500
Subject: Re: [PATCH 10/75] V4L/DVB: declare MODULE_FIRMWARE for modules
	using  XC2028 and XC3028L tuners
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
In-Reply-To: <20091108224313.705ec3cc@pedra.chehab.org>
References: <1257630476.15927.400.camel@localhost>
	 <1257644240.6895.5.camel@palomino.walls.org>
	 <829197380911071744q50fc6e18o527322e1120b9689@mail.gmail.com>
	 <1257645834.15927.634.camel@localhost>
	 <20091108012042.798835dd@pedra.chehab.org>
	 <1257723149.3249.50.camel@pc07.localdom.local>
	 <20091108224313.705ec3cc@pedra.chehab.org>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 03:02:49 +0100
Message-Id: <1257732169.3300.38.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Sonntag, den 08.11.2009, 22:43 -0200 schrieb Mauro Carvalho Chehab:
> Em Mon, 09 Nov 2009 00:32:29 +0100
> hermann pitton <hermann-pitton@arcor.de> escreveu:
> 
> > > I agree. An interesting case happens with devices that uses tda10046 DVB demods.
> > > They have the firmware stored internally on their eeprom. Those firmwares can be
> > > replaced by a different version loaded in ram, but, in general, they work
> > > properly with the eeprom one. So, even having the firmware load code there,
> > > the firmware at /lib/firmware is optional.
> > 
> > Mauro, that could lead to some misunderstanding of the current use
> > conditions, at least on saa7134.
> > 
> > Minor annotations, the tda10046 does not store firmware internally, but
> > there are cards which have an extra eeprom to store such firmware.
> > 
> > If such a firmware eeprom is found and correctly configured, the driver
> > in all cases will load the firmware from that eeprom and all other
> > firmware in /lib/firmware is ignored.
> > 
> > If not, the firmware will be loaded from /lib/firmware.
> > 
> > For all what I know, firmware revisions 26 and 29 are both valid
> > "enough", correspondents to what we can load either from TechnoTrend or
> > LifeView with the getfirmware script, and might be either stored in an
> > extra eeprom or loaded from host/file.
> > 
> > Prior revisions had issues with missing freqs, in what combination ever.
> > 
> > We also can't totally exclude, given the whole mass of such, that in
> > some cases firmware eeproms might exist on some boards, but are not
> > correctly configured and load from host only because of that.
> > 
> > The tendency seen overall is that competitors save the few cents for an
> > extra firmware eeprom these days ...
> 
> Yes, I know. I have myself a Cardbus device with such eeprom (I think it has
> revision 29 stored at the eeprom).
> 
> The point is that it is not mandatory for such devices to have a firmware
> at the filesystem for the device to work. So, a static indication that
> devices with tda10046 need firmware is wrong, since some devices don't need
> it.

There are of course lots of devices needing the firmware mandatory at
the file system. I try to tell that it is not a mistake, in case the
device has no firmware on an extra eeprom, to store latest revision
in /lib/firmware. Or tell me better ...

But also, OEMs a little bit more motivated on new hardware will not
count the costs of an extra firmware eeprom, if being first in having
substantial amounts of chips and get a good deal for such. But that was
the past.

> Cheers,
> Mauro

Else I do totally agree.

I do just point to some ambiguous conditions we should stay aware of.

It is very unlikely that we can "talk" them away.

Do we have all firmware loaded from eeproms possibly existing on cards
is only one minor question.

Maybe we miss some.

Should we not even better avoid such, since still no official update for
firmware eeprom flashing?

To restore the bridge eeprom we seem to be not such bad now, but also
the reasons for a possible corruption are far from clearly identified in
case we should be involved in it.

Despite of legal issues, we should have the latest revision of the
tda10046 firmware at the host. As said, those having it at an extra
eeprom will load it anyway from there.

Cheers,
Hermann
 

