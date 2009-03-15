Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f175.google.com ([209.85.218.175]:51014 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbZCOCDU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 22:03:20 -0400
Received: by bwz23 with SMTP id 23so548443bwz.37
        for <linux-media@vger.kernel.org>; Sat, 14 Mar 2009 19:03:17 -0700 (PDT)
Subject: Re: Pinnacle PCTV Hybrid Pro Card (310c)... once again...
From: Mateusz =?UTF-8?Q?J=C4=99drasik?= <m.jedrasik@gmail.com>
To: Ionic <ionic@ionic.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <49BC5788.50207@ionic.de>
References: <49BC3DEE.9050307@ionic.de>
	 <d9def9db0903141641g457b9cdar317b0d8e5f132150@mail.gmail.com>
	 <49BC4535.6090700@ionic.de>
	 <d9def9db0903141725q86476e9i7fdf97d9198484ac@mail.gmail.com>
	 <49BC5788.50207@ionic.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Mar 2009 03:03:13 +0100
Message-Id: <1237082593.1970.2.camel@compal>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please don't cc-flood (is that the correct way to name it?:)) your
recipients ;)

To answer any questions that were posed at me, I have not been using the
card much, but were able to get analog picture (no sound) with it using
Ubuntu 8.10 stock kernel - I'm guessing 2.6.27 at the time.

I might give it a try some time, once dvb becomes more popular over here
I believe.

Stay tuned.

Dnia 2009-03-15, nie o godzinie 02:19 +0100, Ionic pisze:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
> 
> * On 15.03.2009 01:25, Markus Rechberger wrote:
> >> Hi Markus,
> >>
> >> that's cool... but which tree is the one you actually do speak about?
> >> v4l-dvb-experimental? As stated... I've already tried it without any
> >> success. :(
> >>
> >
> > this tree doesn't exist anymore it's just a symlink to the split out
> > em28xx driver on mcentral.de
> > you should try your luck with the linuxtv.org/hg/v4l-dvb repository
> Okay, thank you!
> 
> >> Other than this I am out of ideas... but you could mean
> >> userspace-drivers though, is this the tree to go?  The page the README
> >> file points to is outdated by the way...
> >>
> >
> > those things are not relevant for your device, no drivers on
> > mcentral.de are relevant for your device.
> Interesting... thought they'd be the right drivers to get the device
> working due to the (possibly outdated) information on it's wiki page...
> 
> > read your first dmesg log carefully and try to obtain the xc3028
> > firmware and put it to /lib/firmwar
> Well, that seems to be some sort of problem. I found this site (and
> several others during March, 14th)
> http://lists-archives.org/video4linux/20835-extract-tool-for-xc3028-firmware.html
> which shows how to extract the firmware file in question. It doesn't
> seem to fit my card though... I've done it anyways though.
> 
> No error messages printed by the drivers anymore, just the normal output:
> 
> [16398.130540] Linux video capture interface: v2.00
> [16398.176622] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
> [16398.177500] cx88[0]: subsystem: 12ab:1788, board: Pinnacle Hybrid
> PCTV [card=60,autodetected], frontend(s): 1
> [16398.177504] cx88[0]: TV tuner type 71, Radio tuner type 71
> [16398.185553] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> [16398.326195] tveeprom 4-0050: Huh, no eeprom present (err=-6)?
> [16398.326200] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
> [16398.326207] cx88[0]/2: cx2388x 8802 Driver Manager
> [16398.326221] cx88-mpeg driver manager 0000:07:00.2: enabling device
> (0000 -> 0002)
> [16398.326231] cx88-mpeg driver manager 0000:07:00.2: PCI INT A -> GSI
> 22 (level, low) -> IRQ 22
> [16398.326240] cx88-mpeg driver manager 0000:07:00.2: setting latency
> timer to 64
> [16398.326249] cx88[0]/2: found at 0000:07:00.2, rev: 5, irq: 22,
> latency: 64, mmio: 0x8e000000
> [16398.330880] cx8800 0000:07:00.0: enabling device (0000 -> 0002)
> [16398.330890] cx8800 0000:07:00.0: PCI INT A -> GSI 22 (level, low)
> - -> IRQ 22
> [16398.330899] cx88[0]/0: found at 0000:07:00.0, rev: 5, irq: 22,
> latency: 0, mmio: 0x8c000000
> [16398.330908] cx8800 0000:07:00.0: setting latency timer to 64
> [16398.331217] cx88[0]/0: registered device video0 [v4l2]
> [16398.331249] cx88[0]/0: registered device vbi0
> [16398.331284] cx88[0]/0: registered device radio0
> [16398.353479] cx88/2: cx2388x dvb driver version 0.0.6 loaded
> [16398.353483] cx88/2: registering cx8802 driver, type: dvb access: shared
> [16398.353486] cx88[0]/2: subsystem: 12ab:1788, board: Pinnacle Hybrid
> PCTV [card=60]
> [16398.353489] cx88[0]/2: cx2388x based DVB/ATSC card
> [16398.353491] cx8802_alloc_frontends() allocating 1 frontend(s)
> [16398.362618] xc2028 4-0061: creating new instance
> [16398.362621] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
> [16398.362624] cx88[0]/2: xc3028 attached
> [16398.362628] DVB: registering new adapter (cx88[0])
> [16398.362632] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353
> DVB-T)...
> 
> Here comes the interesting part, though: radio -s is finding no
> stations (this is not critical for me, but indicates some misbehavior)
> and dvbscan does only output "Unable to query frontend status" (Exit
> code 1.)
> 
> After running dvbcan, dmesg grows by following messages:
> 
> [16485.369819] i2c-adapter i2c-4: firmware: requesting xc3028-v27.fw
> [16485.374523] xc2028 4-0061: Loading 80 firmware images from
> xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [16485.374629] cx88[0]: Calling XC2028/3028 callback
> [16485.374632] cx88[0]: setting GPIO to radio!
> [16487.371046] xc2028 4-0061: Loading firmware for type=BASE F8MHZ MTS
> (7), id 0000000000000000.
> [16487.371053] cx88[0]: Calling XC2028/3028 callback
> [16487.371055] cx88[0]: setting GPIO to radio!
> [16491.995176] xc2028 4-0061: Loading firmware for type=D2633 DTV8
> (210), id 0000000000000000.
> [16492.039958] xc2028 4-0061: Loading SCODE for type=DTV6 QAM DTV7
> DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> [16492.080028] cx88[0]: Calling XC2028/3028 callback
> 
> I've also been curious about analog TV (which is my premier "want to
> get it working" aim)... with no luck. tvtime-scanner scanned and
> scanned and scanned without finding any station.
> 
> New messages after running tvtime-scanner:
> 
> [16491.995176] xc2028 4-0061: Loading firmware for type=D2633 DTV8
> (210), id 0000000000000000.
> [16492.039958] xc2028 4-0061: Loading SCODE for type=DTV6 QAM DTV7
> DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
> [16492.080028] cx88[0]: Calling XC2028/3028 callback
> 
> So... I guess nothing is working sadly...
> 
> I'm really not sure whether the correct firmware is used. This HVR
> firmware file is said to be "generic" (more or less), but your
> firmware package for Pinnacle devices does include a lot of other
> firmware files which seem not to include this "*-v27.fw" file either...
> 
> Thank you once again for helping out.
> 
> Best regards,
> 
> 
> Mihai
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.9 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
> 
> iQIcBAEBCgAGBQJJvFeHAAoJEB/WLtluJTqHQFgP/2mDAgLz28No8YwGu5TMu3eN
> s//kEu2G3bUp3gwQ/ijz8C2GTMO8Ioei+ptwyELetet3gUK/yBs0xf5jLTldw2iz
> BkvOQ0P+nPKcHQ87eB21TmRxSZOunju9fjQc/euMOY625QCFqsw7z6pru77ATOC/
> SpJHRVJpTrycFY6Xt67edO2URcrBJQuF+MDDkZhUec4CGMCxxxM/FmJ0KoohEMuI
> re1ci/Dh0untENo9Up4i1MkcpfUFQoKcXddZQj56FPovQFbmF7Wb2CoRToXnr6mR
> cVu3CTTJ64BKpBBqzq0nZu3bmvk5eo9Z3WpfvBZJ32d6umZzix53sOsSXk22Dko6
> D2hg78va/kKBw5YJ+fvwZmlBOJingZkH78VkTgzVNvO8O6fH+jPm0w1tou3oExxg
> 6tKixARkDrwF4KiFEXsEaP/e0D+A6FvfsS1CL5DxSiXe7XDLoWPZ+RGjOdoKx1jX
> Y3PoWV1plVHkiZOz22mgnQUuO7et96/gxpWUXkugYqSgvgG4D2d/j0t1WsS2yCfw
> pdJEyGvtwrMpiuokrp28TRqUaeqZAGCYyJs0xIzvs1sdz//3yX0aBZvv7DrBlGoZ
> 3POk1vXjdi0ECj9SAg/cnHfyvmDijUbVTMd+aRpqz9xos2WG5FHvZj0jsCLDAreE
> oDAr1qlnvbXj78ySD/eQ
> =SQzv
> -----END PGP SIGNATURE-----
> 
-- 
Mateusz Jędrasik <m.jedrasik@gmail.com>
tel. +48(79)022-9393, +48(51)69-444-90
http://imachine.szklo.eu.org

