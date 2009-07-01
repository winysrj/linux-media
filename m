Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out28.alice.it ([85.33.2.28]:3473 "EHLO
	smtp-out28.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZGAJ0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jul 2009 05:26:10 -0400
Date: Wed, 1 Jul 2009 11:25:31 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <kernel@pengutronix.de>
Subject: pxa_camera: Oops in pxa_camera_probe.
Message-Id: <20090701112531.ed736b30.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jul_2009_11_25_31_+0200_4PWlp/xOMi0lbXW0"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Wed__1_Jul_2009_11_25_31_+0200_4PWlp/xOMi0lbXW0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I get this with pxa-camera in linux-2.6.31-rc1.
If this could be useful, I haven't converted my board code to the new platf=
orm_data
style yet.

i2c /dev entries driver
Linux video capture interface: v2.00
Unable to handle kernel NULL pointer dereference at virtual address 00000060
pgd =3D c0004000
[00000060] *pgd=3D00000000
Internal error: Oops: f5 [#1] PREEMPT
Modules linked in:
CPU: 0    Tainted: G        W   (2.6.31-rc1-ezxdev #34)
PC is at dev_driver_string+0x0/0x38
LR is at pxa_camera_probe+0x144/0x428
pc : [<c0167fa8>]    lr : [<c028d440>]    psr: 20000013
sp : cc81feb0  ip : cc81e000  fp : c0382400
r10: c0381dc0  r9 : 00000000  r8 : c0381dc8
r7 : 0632ea00  r6 : 018cba80  r5 : 02faf080  r4 : cc878a60
r3 : 00000020  r2 : 000028a0  r1 : 0632ea00  r0 : 00000000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0000397f  Table: a0004000  DAC: 00000017
Process swapper (pid: 1, stack limit =3D 0xcc81e278)
Stack: (0xcc81feb0 to 0xcc820000)
fea0:                                     00000001 c00e5528 cc871878 000000=
21=20
fec0: 00000000 c0381dc8 c039bb08 c039bb08 c039bb08 00000000 00000000 c0398d=
28=20
fee0: 00000000 c016c4a0 c039bb08 c016b658 c0381dc8 c039bb08 c0381dfc c016b7=
6c=20
ff00: 00000000 cc81ff10 c016b70c c016aa70 cc823eb4 cc865b8c 00000000 c039bb=
08=20
ff20: c039bb08 cc9784c0 00000000 c016b030 c0312ba0 c012e0f8 c039bb08 000000=
00=20
ff40: 00000000 00000000 00000000 00000001 c001cb98 c016ba68 00000000 c03a4e=
ec=20
ff60: 00000000 00000000 00000000 00000000 c001cb98 c00282d4 00000000 cc81ff=
88=20
ff80: c00de0a0 c028ec24 cc81ffc6 c03190e8 c0888f00 00000140 cc81ffc6 cc8471=
40=20
ffa0: cc81ffc6 000000b8 c0888f94 c00de200 c00754d0 cc8471c0 c038dff4 c00754=
f0=20
ffc0: 00000000 38312c20 00000034 00000000 c00245ac 00000000 00000000 000000=
00=20
ffe0: 00000000 00000000 00000000 c00086fc 00000000 c0029e7c 41e5ced4 c1a4d9=
f9=20
[<c0167fa8>] (dev_driver_string+0x0/0x38) from [<c028d440>] (pxa_camera_pro=
be+0x144/0x428)
[<c028d440>] (pxa_camera_probe+0x144/0x428) from [<c016c4a0>] (platform_drv=
_probe+0x1c/0x24)
[<c016c4a0>] (platform_drv_probe+0x1c/0x24) from [<c016b658>] (driver_probe=
_device+0xc0/0x174)
[<c016b658>] (driver_probe_device+0xc0/0x174) from [<c016b76c>] (__driver_a=
ttach+0x60/0x84)
[<c016b76c>] (__driver_attach+0x60/0x84) from [<c016aa70>] (bus_for_each_de=
v+0x48/0x80)
[<c016aa70>] (bus_for_each_dev+0x48/0x80) from [<c016b030>] (bus_add_driver=
+0xa0/0x224)
[<c016b030>] (bus_add_driver+0xa0/0x224) from [<c016ba68>] (driver_register=
+0xac/0x138)
[<c016ba68>] (driver_register+0xac/0x138) from [<c00282d4>] (do_one_initcal=
l+0x4c/0x184)
[<c00282d4>] (do_one_initcall+0x4c/0x184) from [<c00086fc>] (kernel_init+0x=
8c/0x104)
[<c00086fc>] (kernel_init+0x8c/0x104) from [<c0029e7c>] (kernel_thread_exit=
+0x0/0x8)
Code: e8bd80f0 00002710 0001a36e 000f423f (e5903060)=20
---[ end trace 1b75b31a2719ed1d ]---

Regards,
   Antonio

--=20
A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

--Signature=_Wed__1_Jul_2009_11_25_31_+0200_4PWlp/xOMi0lbXW0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpLK4sACgkQ5xr2akVTsAGT0ACePlWRwKEO//vVCmyroEtvPsRT
jncAoIcS17vuFAO+P/CHFgVzO9SOFFuM
=JtQD
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jul_2009_11_25_31_+0200_4PWlp/xOMi0lbXW0--
