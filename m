Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out114.alice.it ([85.37.17.114]:3245 "EHLO
	smtp-out114.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbZGASxo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jul 2009 14:53:44 -0400
Date: Wed, 1 Jul 2009 20:43:25 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <kernel@pengutronix.de>
Subject: pxa_camera: Oops in pxa_camera_probe.
Message-Id: <20090701204325.2a277884.ospite@studenti.unina.it>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jul_2009_20_43_25_+0200_Cr3+M=AejwF7J_Uc"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Signature=_Wed__1_Jul_2009_20_43_25_+0200_Cr3+M=AejwF7J_Uc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I get this with pxa-camera in mainline linux (from today).
I haven't touched my board code which used to work in 2.6.30

Linux video capture interface: v2.00
Unable to handle kernel NULL pointer dereference at virtual address 00000060
pgd =3D c0004000
[00000060] *pgd=3D00000000
Internal error: Oops: f5 [#1] PREEMPT
Modules linked in:
CPU: 0    Tainted: G        W   (2.6.31-rc1-ezxdev #1)
PC is at dev_driver_string+0x0/0x38
LR is at pxa_camera_probe+0x144/0x428
pc : [<c0168090>]    lr : [<c028d598>]    psr: 20000013
sp : cc81feb0  ip : cc81e000  fp : c0382360
r10: c0381d20  r9 : 00000000  r8 : c0381d28
r7 : 0632ea00  r6 : 018cba80  r5 : 02faf080  r4 : cc8dea60
r3 : 00000020  r2 : 000028a0  r1 : 0632ea00  r0 : 00000000
Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 0000397f  Table: a0004000  DAC: 00000017
Process swapper (pid: 1, stack limit =3D 0xcc81e278)
Stack: (0xcc81feb0 to 0xcc820000)
fea0:                                     00000001 c00e55e4 cc84f878 000000=
21=20
fec0: 00000000 c0381d28 c039ba68 c039ba68 c039ba68 00000000 00000000 c0398c=
88=20
fee0: 00000000 c016c588 c039ba68 c016b740 c0381d28 c039ba68 c0381d5c c016b8=
54=20
ff00: 00000000 cc81ff10 c016b7f4 c016ab58 cc823eb4 cc865b8c 00000000 c039ba=
68=20
ff20: c039ba68 cc9204c0 00000000 c016b118 c0312e28 c012e1d8 c039ba68 000000=
00=20
ff40: 00000000 00000000 00000000 00000001 c001cb98 c016bb50 00000000 c03a4e=
4c=20
ff60: 00000000 00000000 00000000 00000000 c001cb98 c00282f4 00000000 cc81ff=
88=20
ff80: c00de15c c028ed7c cc81ffc6 c0319370 c0888e00 00000140 cc81ffc6 cc8471=
40=20
ffa0: cc81ffc6 000000b8 c0888ef4 c00de2bc c00754f0 cc8471c0 c038df54 c00755=
10=20
ffc0: 00000000 38312c20 00000034 00000000 c00245ac 00000000 00000000 000000=
00=20
ffe0: 00000000 00000000 00000000 c00086fc 00000000 c0029e9c 55aa55aa 55aa55=
aa=20
[<c0168090>] (dev_driver_string+0x0/0x38) from [<c028d598>] (pxa_camera_pro=
be+0x144/0x428)
[<c028d598>] (pxa_camera_probe+0x144/0x428) from [<c016c588>] (platform_drv=
_probe+0x1c/0x24)
[<c016c588>] (platform_drv_probe+0x1c/0x24) from [<c016b740>] (driver_probe=
_device+0xc0/0x174)
[<c016b740>] (driver_probe_device+0xc0/0x174) from [<c016b854>] (__driver_a=
ttach+0x60/0x84)
[<c016b854>] (__driver_attach+0x60/0x84) from [<c016ab58>] (bus_for_each_de=
v+0x48/0x80)
[<c016ab58>] (bus_for_each_dev+0x48/0x80) from [<c016b118>] (bus_add_driver=
+0xa0/0x224)
[<c016b118>] (bus_add_driver+0xa0/0x224) from [<c016bb50>] (driver_register=
+0xac/0x138)
[<c016bb50>] (driver_register+0xac/0x138) from [<c00282f4>] (do_one_initcal=
l+0x4c/0x184)
[<c00282f4>] (do_one_initcall+0x4c/0x184) from [<c00086fc>] (kernel_init+0x=
8c/0x104)
[<c00086fc>] (kernel_init+0x8c/0x104) from [<c0029e9c>] (kernel_thread_exit=
+0x0/0x8)
Code: e8bd80f0 00002710 0001a36e 000f423f (e5903060)=20
---[ end trace 1b75b31a2719ed1d ]---

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Wed__1_Jul_2009_20_43_25_+0200_Cr3+M=AejwF7J_Uc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpLrk0ACgkQ5xr2akVTsAHl5wCeOmTdR8tGCIEobxrDH0hzAch9
D3sAnj1OwSaTM+MFvZEcSqXofBBMpt2l
=mko3
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jul_2009_20_43_25_+0200_Cr3+M=AejwF7J_Uc--
