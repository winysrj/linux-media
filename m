Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52088 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757686Ab2BYTfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 14:35:45 -0500
Received: by vbbff1 with SMTP id ff1so142176vbb.19
        for <linux-media@vger.kernel.org>; Sat, 25 Feb 2012 11:35:44 -0800 (PST)
MIME-Version: 1.0
Reply-To: martin@herrman.nl
In-Reply-To: <CADR1r6jR+zrWMJoq9zKKVw+ucjFCc4BshfxZxhPoKfNduiFx-w@mail.gmail.com>
References: <CADR1r6jbuGD5hecgC-gzVda1G=vCcOn4oMsf5TxcyEVWsWdVuQ@mail.gmail.com>
	<01cc01ccce54$4f9e9770$eedbc650$@coexsi.fr>
	<CADR1r6iKj7MrTVx4aObbMUVswwT-8LMgGR=BVtpX9r+PKWzw9g@mail.gmail.com>
	<4F0B6480.30900@kaiser-linux.li>
	<CADR1r6jR+zrWMJoq9zKKVw+ucjFCc4BshfxZxhPoKfNduiFx-w@mail.gmail.com>
Date: Sat, 25 Feb 2012 20:35:43 +0100
Message-ID: <CADR1r6jSO7c-k-31t730s8ozx8Z8jJHhK4-xXH+RmcZz7qE=iQ@mail.gmail.com>
Subject: Re: [DVB Digital Devices Cine CT V6] status support
From: Martin Herrman <martin@herrman.nl>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 10 januari 2012 09:12 schreef Martin Herrman
<martin.herrman@gmail.com> het volgende:
>
> 2012/1/9 Thomas Kaiser <linux-dvb@kaiser-linux.li>:
>
> > Hello Martin
> >
> > I use the DD Cine CT V6 with DVB-C. It works without problems.
> > I got the driver before Oliver integrated it in his tree. Therefor I did
> > not
> > compile Olivers tree, yet.
> >
> > At the moment I run the card on Ubuntu 11.10 with kernel 3.0.0-14.
> >
> > Hope this helps.
> >
> > Thomas
>
> Hi Thomas,
>
> that is very good news, thanks a lot for the confirmation. Time to
> order one myself!
>
> Regards,
>
> Martin

So.. couple of weeks later, the card arrived, and I have some time to
play with it.

Note that I'm running latest stable Ubuntu 64-bit with kernel 3.0.0-16-generic.

First I tried the drivers from
http://linuxtv.org/hg/~endriss/media_build_experimental/. In that
case, dmesg output is:

[   11.728370] WARNING: You are using an experimental version of the
media stack.
[   11.728372]  As the driver is backported to an older kernel, it doesn't offer
[   11.728373]  enough quality for its usage in production.
[   11.728373]  Use it with care.
[   11.728374] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[   11.728375]  59b30294e14fa6a370fdd2bc2921cca1f977ef16 Merge branch
'v4l_for_linus' into staging/for_v3.4
[   11.728376]  72565224609a23a60d10fcdf42f87a2fa8f7b16d [media]
cxd2820r: sleep on DVB-T/T2 delivery system switch
[   11.728377]  46de20a78ae4b122b79fc02633e9a6c3d539ecad [media]
anysee: fix CI init
[   11.728852] ddbridge: disagrees about version of symbol cxd2099_attach
[   11.728856] ddbridge: Unknown symbol cxd2099_attach (err -22)

So I started to try the build instructions found here:

http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

And after compile, install and a reboot, dmesg output is:

(..)
[   11.592959] Adding 976892k swap on /dev/sdb2.  Priority:-2
extents:1 across:976892k
[   11.628781] WARNING: You are using an experimental version of the
media stack.
[   11.628784]  As the driver is backported to an older kernel, it doesn't offer
[   11.628785]  enough quality for its usage in production.
[   11.628785]  Use it with care.
[   11.628786] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[   11.628787]  a3db60bcf7671cc011ab4f848cbc40ff7ab52c1e [media]
xc5000: declare firmware configuration structures as static const
[   11.628788]  6fab81dfdc7b48c2e30ab05e9b30afb0c418bbbe [media]
xc5000: drivers should specify chip revision rather than firmware
[   11.628790]  ddea427fb3e64d817d4432e5efd2abbfc4ddb02e [media]
xc5000: remove static dependencies on xc5000 created by previous
changesets
[   11.629238] Digital Devices PCIE bridge driver, Copyright (C)
2010-11 Digital Devices GmbH
[   11.629298] DDBridge 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   11.629306] DDBridge driver detected: Digital Devices PCIe bridge
[   11.629331] HW 00010007 FW 00010003
[   11.632593] cfg80211: Calling CRDA to update world regulatory domain
[   11.643411] rt2800pci 0000:05:01.0: PCI INT A -> GSI 19 (level,
low) -> IRQ 19
(..)
[   11.781023] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[   11.844516] skipping empty audio interface (v1)
[   11.844528] snd-usb-audio: probe of 1-3:1.0 failed with error -5
[   11.844540] skipping empty audio interface (v1)
[   11.844546] snd-usb-audio: probe of 1-3:1.1 failed with error -5
[   11.845406] Linux media interface: v0.10
[   11.868177] Linux video capture interface: v2.00
[   11.868181] WARNING: You are using an experimental version of the
media stack.
[   11.868182]  As the driver is backported to an older kernel, it doesn't offer
[   11.868183]  enough quality for its usage in production.
[   11.868184]  Use it with care.
[   11.868184] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[   11.868185]  a3db60bcf7671cc011ab4f848cbc40ff7ab52c1e [media]
xc5000: declare firmware configuration structures as static const
[   11.868187]  6fab81dfdc7b48c2e30ab05e9b30afb0c418bbbe [media]
xc5000: drivers should specify chip revision rather than firmware
[   11.868188]  ddea427fb3e64d817d4432e5efd2abbfc4ddb02e [media]
xc5000: remove static dependencies on xc5000 created by previous
changesets
[   12.110903] EXT4-fs (md1): re-mounted. Opts: errors=remount-ro,user_xattr
[   12.213875] usbcore: registered new interface driver snd-usb-audio
[   12.213906] uvcvideo: Found UVC 1.00 device <unnamed> (046d:0990)
[   12.229795] input: UVC Camera (046d:0990) as
/devices/pci0000:00/0000:00:1a.7/usb1/1-3/1-3:1.0/input/input6
[   12.229904] usbcore: registered new interface driver uvcvideo
[   12.229906] USB Video Class driver (1.1.1)
(..)

lsmod shows that ddbridge and dvb_core are loaded. /dev/ddbrigde/card0
is created. My webcam is available as a device below /dev/v4l/, but no
entries exist for the tv-tuner card.

I can manually load cxd2820r, which loads succesfully, but has no effect.

Which driver should be used?

Any hints are grealy appreciated!

Martin
