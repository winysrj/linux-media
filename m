Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:52370 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713AbZJDWf2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 18:35:28 -0400
Subject: Re: [2.6.31] ir-kbd-i2c oops.
From: Hermann Pitton <hermann-pitton@arcor.de>
To: =?UTF-8?Q?Pawe=C5=82?= Sikora <pluto@agmk.net>
Cc: Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>
In-Reply-To: <200910040908.05864.pluto@agmk.net>
References: <200909160300.28382.pluto@agmk.net>
	 <200910032109.01674.pluto@agmk.net> <1254610338.11623.46.camel@localhost>
	 <200910040908.05864.pluto@agmk.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Oct 2009 00:34:41 +0200
Message-Id: <1254695681.8731.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

Am Sonntag, den 04.10.2009, 09:08 +0200 schrieb Paweł Sikora:
> On Sunday 04 October 2009 00:52:18 Hermann Pitton wrote:
> > Hi,
> > 
> > Am Samstag, den 03.10.2009, 21:09 +0200 schrieb Paweł Sikora:
> > > On Saturday 03 October 2009 20:15:27 Jean Delvare wrote:
> > > > > moreover, with this patch i'm observing a flood in dmesg:
> > > > >
> > > > > [  938.313245] i2c IR (Pinnacle PCTV): unknown key: key=0x12 raw=0x12
> > > > > down=1 [  938.419914] i2c IR (Pinnacle PCTV): unknown key: key=0x12
> > > > > raw=0x12 down=0 [  939.273249] i2c IR (Pinnacle PCTV): unknown key:
> > > > > key=0x24 raw=0x24 down=1 [  939.379955] i2c IR (Pinnacle PCTV):
> > > > > unknown key: key=0x24 raw=0x24 down=0
> > > >
> > > > Different issue, and I don't know much about IR support, but these keys
> > > > aren't listed in ir_codes_pinnacle_color. Maybe you have a different
> > > > variant of this remote control with more keys and we need to add their
> > > > definitions.
> > >
> > > i have such one: http://imgbin.org/index.php?page=image&id=812
> > 
> > hm, maybe it is some fake Pinnacle stuff, at least that remote is very
> > different from the supported ones with gray only or colored keys and
> > looks very poor.
> 
> i have pinnacle pctv analog pci 110i:
> 
> http://imgbin.org/index.php?page=image&id=813
> 
> 05:00.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
>         Video Broadcast Decoder (rev d1)
>         Subsystem: Pinnacle Systems Inc. PCTV 110i (saa7133)                                          
>         Flags: bus master, medium devsel, latency 64, IRQ 16                                          
>         Memory at febff800 (32-bit, non-prefetchable) [size=2K]                                       
>         Capabilities: [40] Power Management version 2                                                 
>         Kernel driver in use: saa7134                                                                 
>         Kernel modules: saa7134
> 
> 05:00.0 0480: 1131:7133 (rev d1)

that does not make much difference.

On recent 310i variants is no response from 0x47 and they must use a
different solution.

Ricardo added support for the remote with the blue arrow buttons on a
110i that time, I tried with others on the new IRQ remote on Asus
devices.

Best information can be found on http://www.bttv-gallery.de

You can also see a PCTV 50i with remote with gray buttons. These two are
supported currently. The 40i is supposed to have no remote support.There
is also a comment about the i2c troubles on the 300i, obviously from
Gerd, and that they are assumed to be caused by a firmware bug.

We can also see your kind of transmitter on other Pinnacle devices and
likely it is already supported there.

Until we would have eeprom detection for different devices with the same
PCI subsystem, a new card entry with dedicated support for that remote
might be a workaround.

Cheers,
Hermann







