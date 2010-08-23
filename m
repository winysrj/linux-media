Return-path: <mchehab@pedra>
Received: from server.klug.on.ca ([205.189.48.131]:2497 "EHLO
	server.klug.on.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0HWE6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 00:58:08 -0400
Received: from linux.interlinx.bc.ca (d67-193-197-208.home3.cgocable.net [67.193.197.208])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by server.klug.on.ca (Postfix) with ESMTP id 199C32803
	for <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 00:32:34 -0400 (EDT)
Received: from [10.75.22.1] (pc.ilinx [10.75.22.1])
	by linux.interlinx.bc.ca (Postfix) with ESMTP id F0201920B
	for <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 00:32:32 -0400 (EDT)
Subject: hvr950q stopped working: read of drv0 never returns
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
To: linux-media@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fJpX0mDNNvkQyMrr2eXL"
Date: Mon, 23 Aug 2010 00:32:31 -0400
Message-ID: <1282537951.32217.3874.camel@pc.interlinx.bc.ca>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>


--=-fJpX0mDNNvkQyMrr2eXL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I have an HVR 950Q on my Ubuntu 2.6.32 kernel.  I have in fact tried
several kernel versions on a couple of different machines with the same
behaviour.

What seems to be happening is that /dev/dvb/adapter0/dvr0 can be opened:

open("/dev/dvb/adapter0/dvr0", O_RDONLY|O_LARGEFILE) =3D 0

but a read from it never seems to return any data:

read(0,=20
[ process blocks waiting ]

Nothing abnormal in dmesg:

[916870.612154] usb 1-2: new high speed USB device using ehci_hcd and addre=
ss 27
[916870.772818] usb 1-2: configuration #1 chosen from 1 choice
[916876.064150] au0828 driver loaded
[916876.424163] au0828: i2c bus registered
[916876.747481] tveeprom 4-0050: Hauppauge model 72001, rev B3F0, serial# 6=
922999
[916876.747487] tveeprom 4-0050: MAC address is 00-0D-FE-69-A2-F7
[916876.747490] tveeprom 4-0050: tuner model is Xceive XC5000 (idx 150, typ=
e 76)
[916876.747494] tveeprom 4-0050: TV standards NTSC(M) ATSC/DVB Digital (eep=
rom 0x88)
[916876.747497] tveeprom 4-0050: audio processor is AU8522 (idx 44)
[916876.747500] tveeprom 4-0050: decoder processor is AU8522 (idx 42)
[916876.747503] tveeprom 4-0050: has no radio, has IR receiver, has no IR t=
ransmitter
[916876.747506] hauppauge_eeprom: hauppauge eeprom: model=3D72001
[916876.798021] au8522 4-0047: creating new instance
[916876.798025] au8522_decoder creating new instance...
[916877.127635] tuner 4-0061: chip found @ 0xc2 (au0828)
[916877.282505] xc5000 4-0061: creating new instance
[916877.287331] xc5000: Successfully identified at address 0x61
[916877.287336] xc5000: Firmware has not been loaded previously
[916877.287791] au8522 4-0047: attaching existing instance
[916877.296083] xc5000 4-0061: attaching existing instance
[916877.300826] xc5000: Successfully identified at address 0x61
[916877.300830] xc5000: Firmware has not been loaded previously
[916877.300835] DVB: registering new adapter (au0828)
[916877.300840] DVB: registering adapter 0 frontend 0 (Auvitek AU8522 QAM/8=
VSB Frontend)...
[916877.301421] Registered device AU0828 [Hauppauge HVR950Q]
[916877.302825] usbcore: registered new interface driver au0828
[916925.988585] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.=
fw)...
[916925.988595] usb 1-2: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[916926.076234] xc5000: firmware read 12401 bytes.
[916926.076238] xc5000: firmware uploading...
[916934.265042] xc5000: firmware upload complete...
[916934.972117] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.=
fw)...
[916934.972128] usb 1-2: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[916934.994581] xc5000: firmware read 12401 bytes.
[916934.994586] xc5000: firmware uploading...
[916943.981063] xc5000: firmware upload complete...
[917101.354372] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.=
fw)...
[917101.354388] usb 1-2: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[917101.394161] xc5000: firmware read 12401 bytes.
[917101.394165] xc5000: firmware uploading...
[917110.813119] xc5000: firmware upload complete...

This device was working just fine until I rebooted the machine it's
usually connected to earlier today.  Now I can't seem to get it working
anywhere.

I'm at a loss where to go from here in debugging.  Any hints?

Thanx,
b.


--=-fJpX0mDNNvkQyMrr2eXL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxx+dwACgkQl3EQlGLyuXAusQCg2yarDrcR0PinijwRexPL4sMH
ohEAoJVbTKvj7bbq5JDSEUGns73JrWzh
=+0Eq
-----END PGP SIGNATURE-----

--=-fJpX0mDNNvkQyMrr2eXL--

