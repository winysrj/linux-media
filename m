Return-path: <linux-media-owner@vger.kernel.org>
Received: from os.inf.tu-dresden.de ([141.76.48.99]:50555 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZFKWff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 18:35:35 -0400
Date: Fri, 12 Jun 2009 00:35:26 +0200
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Message-ID: <20090612003526.24f1213c@laptop.hypervisor.org>
In-Reply-To: <200906112346.48528.hverkuil@xs4all.nl>
References: <20090611221402.66709817@laptop.hypervisor.org>
	<200906112218.11016.hverkuil@xs4all.nl>
	<20090611233817.757933aa@laptop.hypervisor.org>
	<200906112346.48528.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/P57t4ACTa+OGDmgg/4N=r6w";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/P57t4ACTa+OGDmgg/4N=r6w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Jun 2009 23:46:48 +0200 Hans Verkuil (HV) wrote:

HV> Hmm, my patch needs a bit more work. But to get your setup working try =
to
HV> revert the change you made and do just this:
HV>=20
HV> Go to drivers/media/video/Makefile and move this line:
HV>=20
HV> obj-$(CONFIG_VIDEO_MSP3400) +=3D msp3400.o
HV>=20
HV> in front of this line:
HV>=20
HV> obj-$(CONFIG_VIDEO_BT848) +=3D bt8xx/
HV>=20
HV> Recompile and see if that is working.
HV>=20
HV> I got the tveeprom error as well when I tested with ivtv, but I thought
HV> that had something to do with the ivtv driver. Apparently not, so I need
HV> to dig a bit more into these dependencies.

Switching those two lines seems to improve the dependencies for my setup.
However, audio still does not work. Furthermore, switching channels in
tvtime now hangs for up to 5 seconds. strace -r shows that it spends a lot
of time in the second ioctl.

0.000085 ioctl(4, VIDIOC_G_TUNER, 0xbfef1d70) =3D 0
0.000385 select(5, [4], NULL, NULL, {3, 0}) =3D 1 (in [4], left {2, 988069})
0.012006 ioctl(4, VIDIOC_DQBUF, 0xbfef1dc4) =3D 0

The current dmesg output is as follows:

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
msp3400 1-0040: MSP3410D-B4 found @ 0x80 (bt878 #0 [sw])
msp3400 1-0040: msp3400 supports nicam, mode is autodetect
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0

Cheers,

	- Udo

--Sig_/P57t4ACTa+OGDmgg/4N=r6w
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoxhq4ACgkQnhRzXSM7nSlv3QCfdy86CJjdqFLPQivjE8jyDzBA
zTsAn2UOp0IS3GCUYapC0xU1axoNwLSn
=7SSq
-----END PGP SIGNATURE-----

--Sig_/P57t4ACTa+OGDmgg/4N=r6w--
