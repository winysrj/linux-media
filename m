Return-path: <linux-media-owner@vger.kernel.org>
Received: from os.inf.tu-dresden.de ([141.76.48.99]:40475 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbZFKVi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 17:38:26 -0400
Date: Thu, 11 Jun 2009 23:38:17 +0200
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Message-ID: <20090611233817.757933aa@laptop.hypervisor.org>
In-Reply-To: <200906112218.11016.hverkuil@xs4all.nl>
References: <20090611221402.66709817@laptop.hypervisor.org>
	<200906112218.11016.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/uGuoxaXvHJPpNa44S/2qDz7";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/uGuoxaXvHJPpNa44S/2qDz7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Jun 2009 22:18:10 +0200 Hans Verkuil (HV) wrote:

HV> On Thursday 11 June 2009 22:14:02 Udo A. Steinberg wrote:
HV> > Hi all,
HV> >=20
HV> > With Linux 2.6.30 the BTTV driver for my WinTV card claims
HV> >=20
HV> > 	bttv0: audio absent, no audio device found!
HV> >=20
HV> > and audio does not work. This worked up to and including 2.6.29. Is
HV> > this a known issue? Does anyone have a fix or a patch for me to try?
HV>=20
HV> You've no doubt compiled the bttv driver into the kernel and not as a
HV> module.
HV>=20
HV> I've just pushed a fix for this to my tree:
HV> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb

Yes, I've compiled bttv into the kernel. I've (hopefully correctly) ported
the commit http://www.linuxtv.org/hg/~hverkuil/v4l-dvb/rev/820630b2b12f
to 2.6.30. Now I'm getting:

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
ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-1/1-0018/ir0 [bt878 #0 [sw]]
i2c-adapter i2c-1: sendbytes: NAK bailout.
tveeprom 1-0050: Huh, no eeprom present (err=3D-5)?
tveeprom 1-0050: Encountered bad packet header [00]. Corrupt or not a Haupp=
auge eeprom.
bttv0: Hauppauge eeprom indicates model#0
bttv0: tuner absent
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 =3D> 35468950

Cheers,

	- Udo

--Sig_/uGuoxaXvHJPpNa44S/2qDz7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoxeUkACgkQnhRzXSM7nSnpJwCeOWIlsvZMNrqOtmHgYdVtK0ia
ZBoAnivjPT2FyqlgpGtOSllJ5CYgoM3v
=1/37
-----END PGP SIGNATURE-----

--Sig_/uGuoxaXvHJPpNa44S/2qDz7--
