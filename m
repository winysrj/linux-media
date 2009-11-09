Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZKIAnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 19:43:55 -0500
Date: Sun, 8 Nov 2009 22:43:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 10/75] V4L/DVB: declare MODULE_FIRMWARE for modules
 using  XC2028 and XC3028L tuners
Message-ID: <20091108224313.705ec3cc@pedra.chehab.org>
In-Reply-To: <1257723149.3249.50.camel@pc07.localdom.local>
References: <1257630476.15927.400.camel@localhost>
	<1257644240.6895.5.camel@palomino.walls.org>
	<829197380911071744q50fc6e18o527322e1120b9689@mail.gmail.com>
	<1257645834.15927.634.camel@localhost>
	<20091108012042.798835dd@pedra.chehab.org>
	<1257723149.3249.50.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 09 Nov 2009 00:32:29 +0100
hermann pitton <hermann-pitton@arcor.de> escreveu:

> > I agree. An interesting case happens with devices that uses tda10046 DVB demods.
> > They have the firmware stored internally on their eeprom. Those firmwares can be
> > replaced by a different version loaded in ram, but, in general, they work
> > properly with the eeprom one. So, even having the firmware load code there,
> > the firmware at /lib/firmware is optional.
> 
> Mauro, that could lead to some misunderstanding of the current use
> conditions, at least on saa7134.
> 
> Minor annotations, the tda10046 does not store firmware internally, but
> there are cards which have an extra eeprom to store such firmware.
> 
> If such a firmware eeprom is found and correctly configured, the driver
> in all cases will load the firmware from that eeprom and all other
> firmware in /lib/firmware is ignored.
> 
> If not, the firmware will be loaded from /lib/firmware.
> 
> For all what I know, firmware revisions 26 and 29 are both valid
> "enough", correspondents to what we can load either from TechnoTrend or
> LifeView with the getfirmware script, and might be either stored in an
> extra eeprom or loaded from host/file.
> 
> Prior revisions had issues with missing freqs, in what combination ever.
> 
> We also can't totally exclude, given the whole mass of such, that in
> some cases firmware eeproms might exist on some boards, but are not
> correctly configured and load from host only because of that.
> 
> The tendency seen overall is that competitors save the few cents for an
> extra firmware eeprom these days ...

Yes, I know. I have myself a Cardbus device with such eeprom (I think it has
revision 29 stored at the eeprom).

The point is that it is not mandatory for such devices to have a firmware
at the filesystem for the device to work. So, a static indication that
devices with tda10046 need firmware is wrong, since some devices don't need
it.

Cheers,
Mauro
