Return-path: <linux-media-owner@vger.kernel.org>
Received: from os.inf.tu-dresden.de ([141.76.48.99]:46096 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758693AbZFKUtd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 16:49:33 -0400
Date: Thu, 11 Jun 2009 22:14:02 +0200
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org
Subject: 2.6.30: missing audio device in bttv
Message-ID: <20090611221402.66709817@laptop.hypervisor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/K9i+fRkKf+lyYQzZKCK8UBa";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/K9i+fRkKf+lyYQzZKCK8UBa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi all,

With Linux 2.6.30 the BTTV driver for my WinTV card claims

	bttv0: audio absent, no audio device found!

and audio does not work. This worked up to and including 2.6.29. Is this a
known issue? Does anyone have a fix or a patch for me to try?

Cheers,

	- Udo


Output for 2.6.29:
------------------
Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:06:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
bttv0: Bt878 (rev 2) at 0000:06:00.0, irq: 21, latency: 32, mmio: 0x50001000
bttv0: detected: Hauppauge WinTV [card=3D10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=3D10,autodetected]
IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tuner' 0-0042: chip found @ 0x84 (bt878 #0 [sw])
tda9887 0-0042: creating new instance
tda9887 0-0042: tda988[5/6/7] found
tuner' 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
tveeprom 0-0050: Hauppauge model 37284, rev B221, serial# 3546046
tveeprom 0-0050: tuner model is Philips FM1216 (idx 21, type 5)
tveeprom 0-0050: TV standards PAL(B/G) (eeprom 0x04)
tveeprom 0-0050: audio processor is MSP3410D (idx 5)
tveeprom 0-0050: has radio
bttv0: Hauppauge eeprom indicates model#37284
bttv0: tuner type=3D5
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 =3D> 35468950 .. ok

Output for 2.6.30:
------------------
Linux video capture interface: v2.00
bttv: driver version 0.9.18 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
bttv 0000:06:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
bttv0: Bt878 (rev 2) at 0000:06:00.0, irq: 21, latency: 32, mmio: 0x50001000
bttv0: detected: Hauppauge WinTV [card=3D10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=3D10,autodetected]
IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
bttv0: gpio: en=3D00000000, out=3D00000000 in=3D00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
tveeprom 1-0050: Hauppauge model 37284, rev B221, serial# 3546046
tveeprom 1-0050: tuner model is Philips FM1216 (idx 21, type 5)
tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
tveeprom 1-0050: audio processor is MSP3410D (idx 5)
tveeprom 1-0050: has radio
bttv0: Hauppauge eeprom indicates model#37284
bttv0: tuner type=3D5
tuner 1-0042: chip found @ 0x84 (bt878 #0 [sw])
tda9887 1-0042: creating new instance
tda9887 1-0042: tda988[5/6/7] found
tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
bttv0: audio absent, no audio device found!
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0



--=20
Dipl.-Inf. Udo Steinberg
Technische Universit=E4t Dresden             http://os.inf.tu-dresden.de/~u=
s15
Institute for System Architecture          Tel: +49 351 463 38401
D-01062 Dresden                            Fax: +49 351 463 38284

--Sig_/K9i+fRkKf+lyYQzZKCK8UBa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoxZYsACgkQnhRzXSM7nSn+UwCfbQx6k/4zJWbiS/JN1Ko01JaS
XxQAnRqC6Iw8OWBH1+zydpd1FmRFC+Y4
=9Y4g
-----END PGP SIGNATURE-----

--Sig_/K9i+fRkKf+lyYQzZKCK8UBa--
