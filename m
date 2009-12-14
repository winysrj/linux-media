Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:48186 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbZLNNc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 08:32:26 -0500
Subject: Re: New ASUS P3-100 DVB-T/DVB-S device (1043:48cd)
From: hermann pitton <hermann-pitton@arcor.de>
To: dvblinux <dvblinux@free.fr>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1260775612.2294.11.camel@hercules.rochet.org>
References: <200912111456.45947.amlopezalonso@gmail.com>
	 <1260543775.4b225f1f4cec9@imp.free.fr>
	 <1260754580.3275.20.camel@pc07.localdom.local>
	 <1260775612.2294.11.camel@hercules.rochet.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 14 Dec 2009 14:23:38 +0100
Message-Id: <1260797018.3231.27.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 14.12.2009, 08:26 +0100 schrieb dvblinux:
> The complete name of the board is:
> 
> "ASUS My Cinema PS3-100/PTS/FM/AV/RC" ouch :-)
> 
> You're right:
> 
> It features the same features than the "ASUS My Cinema P7131 Hybrid"
> that is: S-Video in, Composite and audio in with a special splitter
> cord, an FM tuner and IR remote control. All connectors are the same for
> both cards, but the additionnal DVB-S.
> 
> The remote control seems to behave exactely the same as P7131, i.e new
> entries in /dev/input/ as a regular keyboard.
> 
> I'll post additionnal stuff later, thanks for your answer.
> 
> Regards.

the card is a little different than the OEM 3in1 it seems.

Just some hints for your further testing.

On card=147 the DVB-T demod is at 0x0b, but on P7131 Hybrid LNA on 0x08.
You might want to change it in saa7134-dvb.c in the 3in1_config and in
saa7134-cards.c for analog initialization.

To test on DVB-S you need to pass "use_frontend=1" to the saa7134-dvb
module. That tuner is at 0x60, might be different for you.

On later P7131 type of cards, like Dual and Hybrid LNA, there is a
female antenna input connector _also_ for radio on the board. The DVB-T
RF input is switched to that shared radio/DVB-T input with
antenna_switch = 2 and gpio 0x0200000 for analog radio. Analog TV
remains on the other RF input.

The 3in1 OEM version has a male radio antenna input on the card, so with
antenna_switch = 1 analog TV and DVB-T are on the same single female
connector on that one, only for radio we switch to the other.

Good luck,
Hermann

> 
> Le lundi 14 décembre 2009 à 02:36 +0100, hermann pitton a écrit :
> > Hi,
> > 
> > sorry for delay, no time for the list during the last days.
> > 
> > Am Freitag, den 11.12.2009, 16:02 +0100 schrieb dvblinux@free.fr:
> > > Hi all, I'm new on this list.
> > > 
> > > I modified on my own the SAA driver to manage an ASUS PS3-100 combo card not
> > > supported yet in current version.
> > > 
> > > It features two DVB-S and DVB-T receivers packed on the same PCI card.
> > 
> > I'm not aware of such an Asus PCI card with two DVB-S and DVB-T
> > receivers. We might hang in wording ...
> > 
> > Maybe one DVB-S, one DVB-T/analog hybrid tuner/demod and also support
> > for analog radio and external S-Video/Composite and analog audio in?
> > 
> > > The DVB-T part is identical to ASUS P7131 Hybrid and therefore is managed thru
> > > the existing driver after a light patch in the driver source (and card.c):
> > > copying relevant stuff from (1043:4876) to (1043:48cd).
> > > 
> > > I'm not a developper, how to share my successfull experiments ?
> > 
> > We have support for the Asus Tiger 3in1 since last summer.
> > This board was OEM only and also does not come with a remote, but your
> > stuff is very likely based on that one.
> > 
> > Please try all functions and inputs and post related "dmesg" output
> > loading the saa7134 driver with "card=147 i2c_scan=1".
> > 
> > It has the same LNA config like the ASUS P7131 Hybrid LNA too.
> > 
> > I can't tell anything about a possible remote, but last on Asus was a
> > transmitter labeled PC-39 that far and that one we do support.
> > 
> > Cheers,
> > Hermann
> > 
> > 
> > 
> >

