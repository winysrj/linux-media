Return-path: <linux-media-owner@vger.kernel.org>
Received: from swclan.homelinux.org ([209.180.175.100]:55770 "EHLO
	swclan.homelinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1KLThB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 14:37:01 -0500
Received: from basement.swclan.homelinux.org ([192.168.0.2] helo=basement)
	by swclan.homelinux.org with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <andrew@swclan.homelinux.org>)
	id 1RPJNr-0004Uk-7G
	for linux-media@vger.kernel.org; Sat, 12 Nov 2011 11:37:00 -0800
Received: from andrew by basement with local (Exim 4.76)
	(envelope-from <andrew@swclan.homelinux.org>)
	id 1RPJNq-0004mF-VW
	for linux-media@vger.kernel.org; Sat, 12 Nov 2011 11:36:58 -0800
Date: Sat, 12 Nov 2011 11:36:58 -0800
From: Andrew Sackville-West <andrew@swclan.homelinux.org>
To: linux-media@vger.kernel.org
Subject: Re: Pinnacle PCTV HD 800i dvb problems
Message-ID: <20111112193658.GD22346@basement.swclan.homelinux.org>
References: <20111107022623.GA2600@basement.swclan.homelinux.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uCPdOCrL+PnN2Vxy"
Content-Disposition: inline
In-Reply-To: <20111107022623.GA2600@basement.swclan.homelinux.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uCPdOCrL+PnN2Vxy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Anyone have any pointers on where I can start with this?

A


On Sun, Nov 06, 2011 at 06:26:23PM -0800, Andrew Sackville-West wrote:
> Hi list,=20
>=20
> I've got 2 Pinnacle PCTV HD 800i cards in my mythtv system running on
> debian machines with stock kernels. The usual output is at the end of
> this email: uname -a, lspci, pertinent logs.
>=20
> Both cards are recognized and work fine for analog, but fail to
> initialize properly for digital (dvb). They produce errors in
> /var/log/syslog and fail to create device nodes. Hardware problems
> have been ruled out for one card as it has been tested and works fully
> in windows vista (caveat, I am not able to test audio over digital
> input due to crappy licensing stuff, but the video works very well).
>=20
> I've investigated a bit in the code and determined that the probing is
> failing in cx88-dvb.c dvb_register(), specifically it fails to attach
> the front end. I dug into the frontend, s5h1409.c and determined it's
> failing in the existence check for the demod in s5h1409_attach(). The
> return value from s5h1409_readreg(state 0x04) is 0x00 instead of the
> magic values.
>=20
> These cards were purchased about a year ago, so is it possible they
> are some later revision that the kernel doesn't handle?
>=20
> I'd like to help in whatever way I can. I'm no kernel hacker, though
> I've mucked around with a little module writing, and can certainly
> follow instructions to do diagnostics, apply patches, test and so
> forth.
>=20
> Thanks
>=20
> A
>=20
> The details for the two machines are pretty much identical except
> kernel version and device numbering, so I'll only include one for the
> moment.
>=20
> andrew@basement:~$ uname -a
> Linux basement 3.0.0-1-amd64 #1 SMP Sat Aug 27 16:21:11 UTC 2011 x86_64 G=
NU/Linux
>=20
>=20
> andrew@basement:~$ sudo lspci -s 05:00 -vvx
> 05:00.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3=
 PCI Video and Audio Decoder (rev 05)
>         Subsystem: Pinnacle Systems Inc. Device 0051
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 20
>         Region 0: Memory at ea000000 (32-bit, non-prefetchable) [size=3D1=
6M]
>         Capabilities: [44] Vital Product Data
>                       Unknown small resource type 00, will not decode mor=
e.
>                       Capabilities: [4c] Power Management version 2
>                                     Flags: PMEClk- DSI+ D1- D2- AuxCurren=
t=3D0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                                            Status: D0 NoSoftRst- PME-Enab=
le- DSel=3D0 DScale=3D0 PME-
>                                            Kernel driver in use: cx8800
> 00: f1 14 00 88 06 00 90 02 05 00 00 04 08 20 80 00
> 10: 00 00 00 ea 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 51 00
> 30: 00 00 00 00 44 00 00 00 00 00 00 00 0c 01 14 37
>=20
> 05:00.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI V=
ideo and Audio Decoder [Audio Port] (rev 05)
>         Subsystem: Pinnacle Systems Inc. Device 0051
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 20
>         Region 0: Memory at eb000000 (32-bit, non-prefetchable) [size=3D1=
6M]
>         Capabilities: [4c] Power Management version 2
>                       Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0=
-,D1-,D2-,D3hot-,D3cold-)
>                              Status: D0 NoSoftRst- PME-Enable- DSel=3D0 D=
Scale=3D0 PME-
>                              Kernel driver in use: cx88_audio
> 00: f1 14 01 88 06 00 90 02 05 00 80 04 08 20 80 00
> 10: 00 00 00 eb 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 51 00
> 30: 00 00 00 00 4c 00 00 00 00 00 00 00 0c 01 04 ff
>=20
> 05:00.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI V=
ideo and Audio Decoder [MPEG Port] (rev 05)
>         Subsystem: Pinnacle Systems Inc. Device 0051
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 20
>         Region 0: Memory at ec000000 (32-bit, non-prefetchable) [size=3D1=
6M]
>         Capabilities: [4c] Power Management version 2
>                       Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0=
-,D1-,D2-,D3hot-,D3cold-)
>                              Status: D0 NoSoftRst- PME-Enable- DSel=3D0 D=
Scale=3D0 PME-
>                              Kernel driver in use: cx88-mpeg driver manag=
er
> 00: f1 14 02 88 06 00 90 02 05 00 80 04 08 20 80 00
> 10: 00 00 00 ec 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 51 00
> 30: 00 00 00 00 4c 00 00 00 00 00 00 00 0c 01 06 58
>=20
>=20
> Syslog relevant lines:
>=20
> [...]
> Nov  6 05:02:49 basement kernel: [    4.405848] Linux video capture inter=
face: v2.00
> Nov  6 05:02:49 basement kernel: [    4.545439] cx2388x alsa driver versi=
on 0.0.8 loaded
> Nov  6 05:02:49 basement kernel: [    4.545483] cx88_audio 0000:05:00.1: =
PCI INT A -> GSI 20 (level, low) -> IRQ 20
> Nov  6 05:02:49 basement kernel: [    4.546987] cx88[0]: subsystem: 11bd:=
0051, board: Pinnacle PCTV HD 800i [card=3D58,autodetected], frontend(s): 1
> Nov  6 05:02:49 basement kernel: [    4.546989] cx88[0]: TV tuner type 76=
, Radio tuner type -1
> Nov  6 05:02:49 basement kernel: [    4.689584] IR NEC protocol handler i=
nitialized
> Nov  6 05:02:49 basement kernel: [    4.718437] IR RC5(x) protocol handle=
r initialized
> Nov  6 05:02:49 basement kernel: [    4.727139] i2c-core: driver [tuner] =
using legacy suspend method
> Nov  6 05:02:49 basement kernel: [    4.727141] i2c-core: driver [tuner] =
using legacy resume method
> Nov  6 05:02:49 basement kernel: [    4.736518] tuner 1-0064: Tuner -1 fo=
und with type(s) Radio TV.
> [...]
> Nov  6 05:02:49 basement kernel: [    4.907324] xc5000 1-0064: creating n=
ew instance
> Nov  6 05:02:49 basement kernel: [    4.908279] xc5000: Successfully iden=
tified at address 0x64
> Nov  6 05:02:49 basement kernel: [    4.908280] xc5000: Firmware has not =
been loaded previously
> Nov  6 05:02:49 basement kernel: [    4.908283] cx88[0]: Calling XC5000 c=
allback
> Nov  6 05:02:49 basement kernel: [    4.964004] Registered IR keymap rc-p=
innacle-pctv-hd
> Nov  6 05:02:49 basement kernel: [    4.964071] input: cx88 IR (Pinnacle =
PCTV HD 800i) as /devices/pci0000:00/0000:00:1e.0/0000:05:00.1/rc/rc0/input5
> Nov  6 05:02:49 basement kernel: [    4.964118] rc0: cx88 IR (Pinnacle PC=
TV HD 800i) as /devices/pci0000:00/0000:00:1e.0/0000:05:00.1/rc/rc0
> Nov  6 05:02:49 basement kernel: [    4.964208] cx88[0]/1: CX88x/0: ALSA =
support for cx2388x boards
> [...]
> Nov  6 05:02:49 basement kernel: [    5.079027] IR JVC protocol handler i=
nitialized
> Nov  6 05:02:49 basement kernel: [    5.102307] IR Sony protocol handler =
initialized
> Nov  6 05:02:49 basement kernel: [    5.109710] cx88/2: cx2388x MPEG-TS D=
river Manager version 0.0.8 loaded
> Nov  6 05:02:49 basement kernel: [    5.109740] cx88[0]/2: cx2388x 8802 D=
river Manager
> Nov  6 05:02:49 basement kernel: [    5.109752] cx88-mpeg driver manager =
0000:05:00.2: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> Nov  6 05:02:49 basement kernel: [    5.109759] cx88[0]/2: found at 0000:=
05:00.2, rev: 5, irq: 20, latency: 32, mmio: 0xec000000
> Nov  6 05:02:49 basement kernel: [    5.203240] cx88/0: cx2388x v4l2 driv=
er version 0.0.8 loaded
> Nov  6 05:02:49 basement kernel: [    5.203277] cx8800 0000:05:00.0: PCI =
INT A -> GSI 20 (level, low) -> IRQ 20
> Nov  6 05:02:49 basement kernel: [    5.203283] cx88[0]/0: found at 0000:=
05:00.0, rev: 5, irq: 20, latency: 32, mmio: 0xea000000
> Nov  6 05:02:49 basement kernel: [    5.203621] cx88/2: cx2388x dvb drive=
r version 0.0.8 loaded
> Nov  6 05:02:49 basement kernel: [    5.203623] cx88/2: registering cx880=
2 driver, type: dvb access: shared
> Nov  6 05:02:49 basement kernel: [    5.203626] cx88[0]/2: subsystem: 11b=
d:0051, board: Pinnacle PCTV HD 800i [card=3D58]
> Nov  6 05:02:49 basement kernel: [    5.205339] xc5000: waiting for firmw=
are upload (dvb-fe-xc5000-1.6.114.fw)...
> Nov  6 05:02:49 basement kernel: [    5.305509] lirc_dev: IR Remote Contr=
ol driver registered, major 249=20
> Nov  6 05:02:49 basement kernel: [    5.314597] rc rc0: lirc_dev: driver =
ir-lirc-codec (cx88xx) registered at minor =3D 0
> Nov  6 05:02:49 basement kernel: [    5.314600] IR LIRC bridge handler in=
itialized
> Nov  6 05:02:49 basement kernel: [    5.346979] xc5000: firmware read 124=
01 bytes.
> Nov  6 05:02:49 basement kernel: [    5.346982] xc5000: firmware uploadin=
g...
> Nov  6 05:02:49 basement kernel: [    5.346985] cx88[0]: Calling XC5000 c=
allback
> Nov  6 05:02:49 basement kernel: [    7.328027] xc5000: firmware upload c=
omplete...
> Nov  6 05:02:49 basement kernel: [    8.000111] cx88[0]/0: registered dev=
ice video0 [v4l2]
> Nov  6 05:02:49 basement kernel: [    8.000146] cx88[0]/0: registered dev=
ice vbi0
> Nov  6 05:02:49 basement kernel: [    8.000175] cx88[0]/2: cx2388x based =
DVB/ATSC card
> Nov  6 05:02:49 basement kernel: [    8.000179] cx8802_alloc_frontends() =
allocating 1 frontend(s)
> Nov  6 05:02:49 basement kernel: [    8.058779] cx88[0]/2: frontend initi=
alization failed
> Nov  6 05:02:49 basement kernel: [    8.058819] cx88[0]/2: dvb_register f=
ailed (err =3D -22)
> Nov  6 05:02:49 basement kernel: [    8.058855] cx88[0]/2: cx8802 probe f=
ailed, err =3D -22
> Nov  6 05:02:49 basement kernel: [    8.058928] cx88[0]: Calling XC5000 c=
allback
> [...]



--=20

--uCPdOCrL+PnN2Vxy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6+ytYACgkQaIeIEqwil4bTYgCdH12CCGVxml6YJfr0sQEMdMcN
1tQAnRfO60P2F6owCXpJvlkUFyQ0+l4h
=1/bV
-----END PGP SIGNATURE-----

--uCPdOCrL+PnN2Vxy--
