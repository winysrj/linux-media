Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:51464 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaBCL4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Feb 2014 06:56:42 -0500
Received: from si-imac.home.simonszu.de (ip-109-90-166-172.unitymediagroup.de [109.90.166.172])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.14.8/8.14.8) with ESMTP id s13Bub81004264
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-media@vger.kernel.org>; Mon, 3 Feb 2014 12:56:43 +0100 (CET)
From: Simon Szustkowski <simon.szustkowski@tu-dortmund.de>
Content-Type: multipart/signed; boundary="Apple-Mail=_4F5960E6-8D99-42EF-AE0F-AAB6C406943C"; protocol="application/pgp-signature"; micalg=pgp-sha512
Subject: HVR 930c - no /dev/dvb
Message-Id: <59AA076D-E4DA-477C-96F4-9BF41DA08DE3@tu-dortmund.de>
Date: Mon, 3 Feb 2014 12:56:33 +0100
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Apple-Mail=_4F5960E6-8D99-42EF-AE0F-AAB6C406943C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi,

i hope this is the right mailing list and not developers only.

I am trying to install a Hauppauge HVR 930c Stick on a Ubuntu 12.04 box. =
My problem is: I have no /dev/dvb/ created, but instead a =
/dev/v4l/by-path/pci-0000\:00\:14.0-usb-0\:2-video-index1, although i =
followed exactly the instructions from the wiki. =
http://www.linux-hardware-guide.de/2012-11-02-hauppauge-wintv-hvr-930c-dvb=
-c-dvb-t-analog-usb-2-0

My system info is:
$ uname -a
Linux xbmc-desktop 3.5.0-45-generic #68-Ubuntu SMP Mon Dec 2 22:02:00 =
UTC 2013 i686 i686 i686 GNU/Linux


$ lsusb
Bus 001 Device 002: ID 8087:8008 Intel Corp.
Bus 002 Device 002: ID 8087:8000 Intel Corp.
Bus 003 Device 002: ID 05a4:9881 Ortek Technology, Inc.
Bus 003 Device 003: ID 2040:1605 Hauppauge
Bus 003 Device 004: ID 046d:c52b Logitech, Inc. Unifying Receiver
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub


and the dmesg output when i connect the stick:
[ 6514.206805] usb 3-2: USB disconnect, device number 3
[ 6514.206944] em2884 #0: Disconnecting em2884 #0
[ 6514.206950] em2884 #0: Closing video extension
[ 6514.206956] em2884 #0: V4L2 device video0 deregistered
[ 6514.207076] em2884 #0: Closing audio extension
[ 6514.208271] em2884 #0: Closing input extension<6>[ 6516.576815] usb =
3-2: new high-speed USB device number 5 using xhci_hcd
[ 6516.594131] usb 3-2: New USB device found, idVendor=3D2040, =
idProduct=3D1605
[ 6516.594139] usb 3-2: New USB device strings: Mfr=3D0, Product=3D1, =
SerialNumber=3D2
[ 6516.594145] usb 3-2: Product: WinTV HVR-930C
[ 6516.594149] usb 3-2: SerialNumber: 4034722962
[ 6516.597157] em28xx: New device  WinTV HVR-930C @ 480 Mbps (2040:1605, =
interface 0, class 0)
[ 6516.597163] em28xx: Audio interface 0 found (Vendor Class)
[ 6516.597167] em28xx: Video interface 0 found: isoc
[ 6516.597170] em28xx: DVB interface 0 found: isoc
[ 6516.597258] em28xx: chip ID is em2884
[ 6516.658997] em2884 #0: EEPROM ID =3D 26 00 01 00, EEPROM hash =3D =
0x7ef008aa
[ 6516.659003] em2884 #0: EEPROM info:
[ 6516.659007] em2884 #0:       microcode start address =3D 0x0004, boot =
configuration =3D 0x01
[ 6516.665286] em2884 #0:       I2S audio, 5 sample rates
[ 6516.665293] em2884 #0:       500mA max power
[ 6516.665299] em2884 #0:       Table at offset 0x24, strings=3D0x1e82, =
0x186a, 0x0000
[ 6516.665371] em2884 #0: Identified as Hauppauge WinTV HVR 930C =
(card=3D81)
[ 6516.667726] tveeprom 1-0050: Hauppauge model 16009, rev B1F0, serial# =
8191122
[ 6516.667733] tveeprom 1-0050: MAC address is 00:0d:fe:7c:fc:92
[ 6516.667738] tveeprom 1-0050: tuner model is Xceive XC5000 (idx 150, =
type 76)
[ 6516.667744] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') =
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[ 6516.667749] tveeprom 1-0050: audio processor is unknown (idx 45)
[ 6516.667752] tveeprom 1-0050: decoder processor is unknown (idx 44)
[ 6516.667757] tveeprom 1-0050: has no radio, has IR receiver, has no IR =
transmitter
[ 6516.667761] em2884 #0: analog set to isoc mode.
[ 6516.667764] em2884 #0: dvb set to isoc mode.
[ 6516.667921] em2884 #0: Registering V4L2 extension
[ 6516.668003] em2884 #0: Config register raw data: 0x12
[ 6516.669846] em2884 #0: AC97 vendor ID =3D 0x04880488
[ 6516.669977] em2884 #0: AC97 features =3D 0x0488
[ 6516.669980] em2884 #0: Unknown AC97 audio processor detected!
[ 6516.782455] em2884 #0: V4L2 video device registered as video0
[ 6516.782458] em2884 #0: V4L2 extension successfully initialized
[ 6516.782459] em2884 #0: Binding audio extension
[ 6516.782460] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[ 6516.782461] em28xx-audio.c: Copyright (C) 2007-2014 Mauro Carvalho =
Chehab
[ 6516.782482] em2884 #0: Endpoint 0x83 high-speed on intf 0 alt 7 =
interval =3D 8, size 196
[ 6516.782483] em2884 #0: Number of URBs: 1, with 64 packets and 192 =
size
[ 6516.783258] em2884 #0: Audio extension successfully initialized
[ 6516.783260] em2884 #0: Registering input extension
[ 6516.784460] Registered IR keymap rc-hauppauge
[ 6516.784527] input: em28xx IR (em2884 #0) as =
/devices/pci0000:00/0000:00:14.0/usb3/3-2/rc/rc0/input12
[ 6516.784550] rc0: em28xx IR (em2884 #0) as =
/devices/pci0000:00/0000:00:14.0/usb3/3-2/rc/rc0
[ 6516.785091] em2884 #0: Input extension successfully initalized


It is strange that my dmesg output is not the same as in the wiki or in =
some other tutorials around the internet. Especially the isoc thing =
confuses me.

I have loaded the following firmware:
-rw-r--r-- 1 root root 42K Feb 2 23:12 dvb-usb-hauppauge-hvr930c-drxk.fw
-rw-r--r-- 1 root root 13K Feb 2 22:51 dvb-fe-xc5000-1.6.114.fw

It was also strange that lsmod showed me only the em28xx module, so i =
loaded the xc5000 and drxk module manually, but this makes no =
difference.=20

So without the /dev/dvb/ device, w_scan and other tools will fail. I =
have also installed a tvheadend server. It has a device called DRXK =
DVB-C DVB-T in it's selection dropdown menu, but it is showing with an =
empty vendor ID and an empty device path and won't scan the channels. In =
the config directory of tvheadend there is a configuration file for =
exactly this adapter, but from the filename it is clear that tvheadend =
assumes that it's an adapter localized  in /dev/dvb.

So i hope that i can get some help from you, the linux media experts. ;)

Simon Szustkowski
simon.szustkowski@tu-dortmund.de

--Apple-Mail=_4F5960E6-8D99-42EF-AE0F-AAB6C406943C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCgAGBQJS74PyAAoJEM2jBaBmUILpfH4P/RGmgHq8CrhU9VZanFQwGN9a
fEUuuzWb8gLauqiI/zyg5tPP+m/EBz5jC5cgzJtVtkcgSs0VTO7+lQ/xD57q0B0W
EHL1yyT8TlhMm1FZ1/Nd98p94FBP8MgQWoCPOZlwdD1B+m67V464en9yste+kkTP
k7EjXWh8Hy8vGNJ+zPFq4KVifqde9Q3ZRB92uz0mRCPjzNK2q2KzLB7qLR2hkM61
Vw1CwoNHtA1eLvA06ixjt3JD84NW58P3tay0iXvUrT8x2AQ5L5UzawCJowd8JG3A
OV69uRFzAVQI77mVmZAbcnhQEgiAMOJO6mhXcIRDt9uVHe7nqzIuCKiO+bO9gBcc
7acamYH1AxiTTcgX3wQy8vWakH8YnWQLeHF66SnBrPEPONuGsgwy7UwgP8fwwdG+
jkaHEGo6rT1IZuMLtQSLf70ZelJdgVz+j11cwKpn78UsCgQ7QfLxKFhl3jvt1Ms8
Cagv3ATT2gLD7I2NpvNGayRvi8zBpTh0l/rVl79hbJroPZhJDiDYrdvVQQuyvREd
M0asaLORVgP8XXTCKE3uj2elUPajxiDODhmfPZo19qfxY4vzHFROqHfbx/01e2k8
686FoEYXnmK7G/FEddKrFtU+MoldDQzVZ1n/DJ9KJek+fRtFeb7lny7mJHULItHj
SXk4gzZYNlsRxgOIOrXo
=TvC/
-----END PGP SIGNATURE-----

--Apple-Mail=_4F5960E6-8D99-42EF-AE0F-AAB6C406943C--
