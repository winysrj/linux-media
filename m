Return-path: <linux-media-owner@vger.kernel.org>
Received: from swclan.homelinux.org ([209.180.175.100]:60656 "EHLO
	swclan.homelinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1KGC5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 21:57:49 -0500
Received: from basement.swclan.homelinux.org ([192.168.0.2] helo=basement)
	by swclan.homelinux.org with esmtps (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <andrew@swclan.homelinux.org>)
	id 1RNEul-0006f1-M7
	for linux-media@vger.kernel.org; Sun, 06 Nov 2011 18:26:24 -0800
Received: from andrew by basement with local (Exim 4.76)
	(envelope-from <andrew@swclan.homelinux.org>)
	id 1RNEul-0005hm-Gz
	for linux-media@vger.kernel.org; Sun, 06 Nov 2011 18:26:23 -0800
Date: Sun, 6 Nov 2011 18:26:23 -0800
From: Andrew Sackville-West <andrew@swclan.homelinux.org>
To: linux-media@vger.kernel.org
Subject: Pinnacle PCTV HD 800i dvb problems
Message-ID: <20111107022623.GA2600@basement.swclan.homelinux.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi list,=20

I've got 2 Pinnacle PCTV HD 800i cards in my mythtv system running on
debian machines with stock kernels. The usual output is at the end of
this email: uname -a, lspci, pertinent logs.

Both cards are recognized and work fine for analog, but fail to
initialize properly for digital (dvb). They produce errors in
/var/log/syslog and fail to create device nodes. Hardware problems
have been ruled out for one card as it has been tested and works fully
in windows vista (caveat, I am not able to test audio over digital
input due to crappy licensing stuff, but the video works very well).

I've investigated a bit in the code and determined that the probing is
failing in cx88-dvb.c dvb_register(), specifically it fails to attach
the front end. I dug into the frontend, s5h1409.c and determined it's
failing in the existence check for the demod in s5h1409_attach(). The
return value from s5h1409_readreg(state 0x04) is 0x00 instead of the
magic values.

These cards were purchased about a year ago, so is it possible they
are some later revision that the kernel doesn't handle?

I'd like to help in whatever way I can. I'm no kernel hacker, though
I've mucked around with a little module writing, and can certainly
follow instructions to do diagnostics, apply patches, test and so
forth.

Thanks

A

The details for the two machines are pretty much identical except
kernel version and device numbering, so I'll only include one for the
moment.

andrew@basement:~$ uname -a
Linux basement 3.0.0-1-amd64 #1 SMP Sat Aug 27 16:21:11 UTC 2011 x86_64 GNU=
/Linux


andrew@basement:~$ sudo lspci -s 05:00 -vvx
05:00.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 P=
CI Video and Audio Decoder (rev 05)
        Subsystem: Pinnacle Systems Inc. Device 0051
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at ea000000 (32-bit, non-prefetchable) [size=3D16M]
        Capabilities: [44] Vital Product Data
                      Unknown small resource type 00, will not decode more.
                      Capabilities: [4c] Power Management version 2
                                    Flags: PMEClk- DSI+ D1- D2- AuxCurrent=
=3D0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                                           Status: D0 NoSoftRst- PME-Enable=
- DSel=3D0 DScale=3D0 PME-
                                           Kernel driver in use: cx8800
00: f1 14 00 88 06 00 90 02 05 00 00 04 08 20 80 00
10: 00 00 00 ea 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 51 00
30: 00 00 00 00 44 00 00 00 00 00 00 00 0c 01 14 37

05:00.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Vid=
eo and Audio Decoder [Audio Port] (rev 05)
        Subsystem: Pinnacle Systems Inc. Device 0051
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at eb000000 (32-bit, non-prefetchable) [size=3D16M]
        Capabilities: [4c] Power Management version 2
                      Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,=
D1-,D2-,D3hot-,D3cold-)
                             Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DSc=
ale=3D0 PME-
                             Kernel driver in use: cx88_audio
00: f1 14 01 88 06 00 90 02 05 00 80 04 08 20 80 00
10: 00 00 00 eb 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 51 00
30: 00 00 00 00 4c 00 00 00 00 00 00 00 0c 01 04 ff

05:00.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Vid=
eo and Audio Decoder [MPEG Port] (rev 05)
        Subsystem: Pinnacle Systems Inc. Device 0051
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at ec000000 (32-bit, non-prefetchable) [size=3D16M]
        Capabilities: [4c] Power Management version 2
                      Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,=
D1-,D2-,D3hot-,D3cold-)
                             Status: D0 NoSoftRst- PME-Enable- DSel=3D0 DSc=
ale=3D0 PME-
                             Kernel driver in use: cx88-mpeg driver manager
00: f1 14 02 88 06 00 90 02 05 00 80 04 08 20 80 00
10: 00 00 00 ec 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 bd 11 51 00
30: 00 00 00 00 4c 00 00 00 00 00 00 00 0c 01 06 58


Syslog relevant lines:

[...]
Nov  6 05:02:49 basement kernel: [    4.405848] Linux video capture interfa=
ce: v2.00
Nov  6 05:02:49 basement kernel: [    4.545439] cx2388x alsa driver version=
 0.0.8 loaded
Nov  6 05:02:49 basement kernel: [    4.545483] cx88_audio 0000:05:00.1: PC=
I INT A -> GSI 20 (level, low) -> IRQ 20
Nov  6 05:02:49 basement kernel: [    4.546987] cx88[0]: subsystem: 11bd:00=
51, board: Pinnacle PCTV HD 800i [card=3D58,autodetected], frontend(s): 1
Nov  6 05:02:49 basement kernel: [    4.546989] cx88[0]: TV tuner type 76, =
Radio tuner type -1
Nov  6 05:02:49 basement kernel: [    4.689584] IR NEC protocol handler ini=
tialized
Nov  6 05:02:49 basement kernel: [    4.718437] IR RC5(x) protocol handler =
initialized
Nov  6 05:02:49 basement kernel: [    4.727139] i2c-core: driver [tuner] us=
ing legacy suspend method
Nov  6 05:02:49 basement kernel: [    4.727141] i2c-core: driver [tuner] us=
ing legacy resume method
Nov  6 05:02:49 basement kernel: [    4.736518] tuner 1-0064: Tuner -1 foun=
d with type(s) Radio TV.
[...]
Nov  6 05:02:49 basement kernel: [    4.907324] xc5000 1-0064: creating new=
 instance
Nov  6 05:02:49 basement kernel: [    4.908279] xc5000: Successfully identi=
fied at address 0x64
Nov  6 05:02:49 basement kernel: [    4.908280] xc5000: Firmware has not be=
en loaded previously
Nov  6 05:02:49 basement kernel: [    4.908283] cx88[0]: Calling XC5000 cal=
lback
Nov  6 05:02:49 basement kernel: [    4.964004] Registered IR keymap rc-pin=
nacle-pctv-hd
Nov  6 05:02:49 basement kernel: [    4.964071] input: cx88 IR (Pinnacle PC=
TV HD 800i) as /devices/pci0000:00/0000:00:1e.0/0000:05:00.1/rc/rc0/input5
Nov  6 05:02:49 basement kernel: [    4.964118] rc0: cx88 IR (Pinnacle PCTV=
 HD 800i) as /devices/pci0000:00/0000:00:1e.0/0000:05:00.1/rc/rc0
Nov  6 05:02:49 basement kernel: [    4.964208] cx88[0]/1: CX88x/0: ALSA su=
pport for cx2388x boards
[...]
Nov  6 05:02:49 basement kernel: [    5.079027] IR JVC protocol handler ini=
tialized
Nov  6 05:02:49 basement kernel: [    5.102307] IR Sony protocol handler in=
itialized
Nov  6 05:02:49 basement kernel: [    5.109710] cx88/2: cx2388x MPEG-TS Dri=
ver Manager version 0.0.8 loaded
Nov  6 05:02:49 basement kernel: [    5.109740] cx88[0]/2: cx2388x 8802 Dri=
ver Manager
Nov  6 05:02:49 basement kernel: [    5.109752] cx88-mpeg driver manager 00=
00:05:00.2: PCI INT A -> GSI 20 (level, low) -> IRQ 20
Nov  6 05:02:49 basement kernel: [    5.109759] cx88[0]/2: found at 0000:05=
:00.2, rev: 5, irq: 20, latency: 32, mmio: 0xec000000
Nov  6 05:02:49 basement kernel: [    5.203240] cx88/0: cx2388x v4l2 driver=
 version 0.0.8 loaded
Nov  6 05:02:49 basement kernel: [    5.203277] cx8800 0000:05:00.0: PCI IN=
T A -> GSI 20 (level, low) -> IRQ 20
Nov  6 05:02:49 basement kernel: [    5.203283] cx88[0]/0: found at 0000:05=
:00.0, rev: 5, irq: 20, latency: 32, mmio: 0xea000000
Nov  6 05:02:49 basement kernel: [    5.203621] cx88/2: cx2388x dvb driver =
version 0.0.8 loaded
Nov  6 05:02:49 basement kernel: [    5.203623] cx88/2: registering cx8802 =
driver, type: dvb access: shared
Nov  6 05:02:49 basement kernel: [    5.203626] cx88[0]/2: subsystem: 11bd:=
0051, board: Pinnacle PCTV HD 800i [card=3D58]
Nov  6 05:02:49 basement kernel: [    5.205339] xc5000: waiting for firmwar=
e upload (dvb-fe-xc5000-1.6.114.fw)...
Nov  6 05:02:49 basement kernel: [    5.305509] lirc_dev: IR Remote Control=
 driver registered, major 249=20
Nov  6 05:02:49 basement kernel: [    5.314597] rc rc0: lirc_dev: driver ir=
-lirc-codec (cx88xx) registered at minor =3D 0
Nov  6 05:02:49 basement kernel: [    5.314600] IR LIRC bridge handler init=
ialized
Nov  6 05:02:49 basement kernel: [    5.346979] xc5000: firmware read 12401=
 bytes.
Nov  6 05:02:49 basement kernel: [    5.346982] xc5000: firmware uploading.=
=2E.
Nov  6 05:02:49 basement kernel: [    5.346985] cx88[0]: Calling XC5000 cal=
lback
Nov  6 05:02:49 basement kernel: [    7.328027] xc5000: firmware upload com=
plete...
Nov  6 05:02:49 basement kernel: [    8.000111] cx88[0]/0: registered devic=
e video0 [v4l2]
Nov  6 05:02:49 basement kernel: [    8.000146] cx88[0]/0: registered devic=
e vbi0
Nov  6 05:02:49 basement kernel: [    8.000175] cx88[0]/2: cx2388x based DV=
B/ATSC card
Nov  6 05:02:49 basement kernel: [    8.000179] cx8802_alloc_frontends() al=
locating 1 frontend(s)
Nov  6 05:02:49 basement kernel: [    8.058779] cx88[0]/2: frontend initial=
ization failed
Nov  6 05:02:49 basement kernel: [    8.058819] cx88[0]/2: dvb_register fai=
led (err =3D -22)
Nov  6 05:02:49 basement kernel: [    8.058855] cx88[0]/2: cx8802 probe fai=
led, err =3D -22
Nov  6 05:02:49 basement kernel: [    8.058928] cx88[0]: Calling XC5000 cal=
lback
[...]

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk63QcoACgkQaIeIEqwil4a9bACeKZBV0XNVduVxBBYZ0gs91SvI
ohAAnAkm9umWqMeWVekQ/nMmRY4zmk+b
=gIFN
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
