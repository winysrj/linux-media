Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KOhUs-0007om-3d
	for linux-dvb@linuxtv.org; Fri, 01 Aug 2008 01:23:51 +0200
Received: from mail-in-11-z2.arcor-online.net (mail-in-11-z2.arcor-online.net
	[151.189.8.28])
	by mail-in-07.arcor-online.net (Postfix) with ESMTP id 36BE624ADB2
	for <linux-dvb@linuxtv.org>; Fri,  1 Aug 2008 01:23:45 +0200 (CEST)
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mail-in-11-z2.arcor-online.net (Postfix) with ESMTP id 229D73465A9
	for <linux-dvb@linuxtv.org>; Fri,  1 Aug 2008 01:23:45 +0200 (CEST)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-17.arcor-online.net (Postfix) with ESMTP id A26FF2BCE7A
	for <linux-dvb@linuxtv.org>; Fri,  1 Aug 2008 01:23:44 +0200 (CEST)
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <3a665c760807310720w8397a0ey8ff748df3a23df5@mail.gmail.com>
References: <3a665c760807310720w8397a0ey8ff748df3a23df5@mail.gmail.com>
Date: Fri, 01 Aug 2008 01:17:42 +0200
Message-Id: <1217546262.3272.117.camel@pc10.localdom.local>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Question about SAA7131e
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Donnerstag, den 31.07.2008, 22:20 +0800 schrieb loody:
> Dear all:
> I got a DTV card without knowing manufacturer's name but with the
> chip's name as saa7131e.
> I have check http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards and
> there is a MSI TV card which also use saa7131e.
> Does that mean all cards with saa7131e will be supported or there is
> something except chip name that I have to take care?

the saa7134 driver has support for lots of cards with saa7131e.

Some are for analog TV only, some only for DVB-T or DVB-S, most are
hybrid for analog and DVB-T, some have support for analog, DVB-T and
DVB-S. Some have dual tuners and can provide analog TV from tuner and
DVB-T at once or alternatively DVB-S.

The Medion Quad(ro) (CTX944) with two saa7131e can provide up to four
different TV streams from tuners at once, combinations of dual analog
TV, dual DVB-T and dual DVB-S and has also additionally external
composite and s-video inputs, but needs at least a dual PCI capable
slot. (blue colored on MSI motherboards, original slot is green and
supports also the modem it has)

To give some idea of the cards around so far.

The information of how the cards are configured is mostly stored in
saa7134-cards.c and saa7134-dvb.c. Most follow more or less closely
various Philips/NXP reference designs, some have special solutions which
might be difficult to discover.

The saa7131e is detected like also the saa7135 as an saa7133, but has an
build in tda8290 anaolg IF demodulator, usually at 0x96, which in most
hybrid cases also works as an i2c bridge for the tuner programming.
Most common these days are tda8275a hybrid silicon tuners and for DVB-T
tda10046a channel decoders.

A still popular reference design for these is card=81 (saa7134.h), the
Philips Tiger, but there is also already the Tiger-S, which has an
additional external LowNoiseAmplifier which needs to be properly
configured.

Please examine the card closely, even the smallest chip has its meaning
and also what is written on the clocks/xtals. The same goes for the
printings on the board, maybe it is some OEM version of an already known
board.

Also posting to the video4linux-list as well might bring you more
feedback.

A first try might be to modprobe -vr all related modules and
"modprobe -v saa7134 card=81 i2c_scan=1" , if it should be something in
the near of that one.

Read the v4l wiki at linuxtv.org about adding new cards.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
