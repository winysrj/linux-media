Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34889 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753834Ab0CWRzi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 13:55:38 -0400
Date: Tue, 23 Mar 2010 18:55:31 +0100
From: Steffen Pankratz <kratz00@gmx.de>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: em28xx - Your board has no unique USB ID and thus need a hint
 to  be detected
Message-ID: <20100323185531.10f9795e@hermes>
In-Reply-To: <829197381003221054h6624f4d6x648f844c54e51b37@mail.gmail.com>
References: <20100319180129.6fb65141@hermes>
	<829197381003191007r1055f3dbo58d7712cff7cf19b@mail.gmail.com>
	<20100319181333.3352a029@hermes>
	<829197381003191017k5adab45ejee5179bc66880cac@mail.gmail.com>
	<20100322184553.0433ae24@hermes>
	<829197381003221054h6624f4d6x648f844c54e51b37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/G0d_l9ONIasv2nnaDSCecbo";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/G0d_l9ONIasv2nnaDSCecbo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Mar 2010 13:54:16 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

Hi Devin,


> In the meantime, you can add "card=3D53" as a modprobe option to em28xx, =
and it
> should start working for you.

thanks that worked.
I was abled to tune to one DVB-T channel, back in the days
using Markus Rechberger's driver I had all of the available channels.
But this could also be a problem with my antenna setup,
I will recheck later.

With the old driver I also had support for the remote control,
what could be the problem on this topic?

I still have to check Analog TV.

And finally some dmesg output:

usb 1-4: new high speed USB device using ehci_hcd and address 13
em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, interface 0, class=
 0)
em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a 00
em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00
em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 00 5b 1e 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00
em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 5a 00 55 aa 71 74 54 03 00 17 98 01 00 00 00 00
em28xx #0: i2c eeprom f0: 02 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID=3D 0x9567eb1a, EEPROM hash =3D 0xb6a56b20
em28xx #0: EEPROM info:
em28xx #0:      AC97 audio (5 sample rates)
em28xx #0:      USB Remote wakeup capable
em28xx #0:      500mA max power
em28xx #0:      Table at 0x04, strings=3D0x206a, 0x006a, 0x0000
em28xx #0: Identified as Pinnacle Hybrid Pro (card=3D53)
tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
tuner 3-0061: chip found @ 0xc2 (em28xx #0)
xc2028 3-0061: creating new instance
xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
usb 1-4: firmware: requesting xc3028-v27.fw
xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 =
firmware, ver 2.7
xc2028 3-0061: Loading firmware for type=3DBASE (1), id 0000000000000000.
xc2028 3-0061: Loading firmware for type=3D(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 3-0061: Loading SCODE for type=3DMONO SCODE HAS_IF_4320 (60008000), =
id 0000000000008000.
em28xx #0: Config register raw data: 0x58
em28xx #0: AC97 vendor ID =3D 0xffffffff
em28xx #0: AC97 features =3D 0x6a90
em28xx #0: Empia 202 AC97 audio processor detected
tvp5150 3-005c: tvp5150am1 detected.
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as video0
em28xx #0: V4L2 VBI device registered as vbi0
xc2028 3-0061: attaching existing instance
xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
em28xx #0: em28xx #0/2: xc3028 attached
DVB: registering new adapter (em28xx #0)
DVB: registering adapter 0 frontend 0 (Zarlink MT352 DVB-T)...
em28xx #0: Successfully loaded em28xx-dvb
em28xx audio device (eb1a:2881): interface 1, class 1
em28xx audio device (eb1a:2881): interface 2, class 1

--=20
Hermes powered by LFS SVN-20070420 (Linux 2.6.33.1)

Best regards, Steffen Pankratz.

--Sig_/G0d_l9ONIasv2nnaDSCecbo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkupAJMACgkQqmIF0LCII9s9AwCggfL2ANH6KMoEf1DTtWk4OHKZ
GEQAn2tGmuFc9S9+ffzwQ2zTMYsknm3S
=5MFk
-----END PGP SIGNATURE-----

--Sig_/G0d_l9ONIasv2nnaDSCecbo--
