Return-path: <mchehab@pedra>
Received: from qasl.de ([188.40.54.133]:40628 "EHLO mail.qasl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab0JUP3j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 11:29:39 -0400
Received: from [2a01:198:22e::2]
	by mail.qasl.de with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <idl0r@qasl.de>)
	id 1P8whx-0007fD-SK
	for linux-media@vger.kernel.org; Thu, 21 Oct 2010 17:05:34 +0200
Message-ID: <4CC056B6.7030502@qasl.de>
Date: Thu, 21 Oct 2010 17:05:26 +0200
From: Christian Ruppert <idl0r@qasl.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Technisat CableStar HD2 some issues/questions
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig80907B8B640E24FF676DE7A7"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig80907B8B640E24FF676DE7A7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hey guys,

I recently bought a Technisat CableStar HD2:
lspci -s 04:05.0 -vv -n
04:05.0 0480: 1822:4e35 (rev 01)
	Subsystem: 1ae4:0002
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-
<TAbort+ <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at f6fff000 (32-bit, prefetchable) [size=3D4K]
	Kernel driver in use: Mantis

So to question one:
I read the wiki article[1] to setup my new card and then noticed that
the following drivers are enough:

CONFIG_MEDIA_SUPPORT
CONFIG_VIDEO_DEV
CONFIG_DVB_CORE
CONFIG_MEDIA_ATTACH

CONFIG_MANTIS_CORE
CONFIG_DVB_MANTIS
CONFIG_DVB_FE_CUSTOMISE
CONFIG_DVB_TDA10023
and CONFIG_DVB_PLL (Auto selected)

So my question is now, do I really need for some reason the:
CONFIG_DVB_TDA10021 and CONFIG_DVB_B2C2_FLEXCOP /
CONFIG_DVB_B2C2_FLEXCOP_PCI drivers?

The cu1216 isn't available in 2.6.36 so I guess I don't need this one at
least..

It seems he uses the same card there but in my case just
CONFIG_DVB_TDA10021 seems to not work but I'll test it again later if I
get to it.

To my second question:
I saw two threads [2][3] (unfortunately German only) that I'd have to
patch the kernel drivers or I even have to use other[4]/non-kernel[5]
driver. Is it still necessary or has it been fixed in any of the 2.6.3x
kernels? I didn't test the IR stuff yet so I just ask...

The third thing I noticed is:
Get such a card (Might be even reproducible without the card)
Build the drivers above (at least CONFIG_DVB_TDA10023) as module
Boot and you'll get something like here:

[  161.383486] BUG: unable to handle kernel NULL pointer dereference at
0000000000000308
[  161.384004] IP: [<ffffffff8131a7ce>] dvb_unregister_frontend+0xe/0x100=

[  161.384004] PGD 9f731067 PUD a051a067 PMD 0
[  161.384004] Oops: 0000 [#1] SMP
[  161.384004] last sysfs file:
/sys/devices/pci0000:00/0000:00:11.0/host1/target1:0:0/1:0:0:0/block/sdb/=
uevent
[  161.384004] CPU 3
[  161.384004] Modules linked in: mantis(+) nvidia(P) k10temp
asus_atk0110 hwmon pata_atiixp
[  161.384004]
[  161.384004] Pid: 4992, comm: modprobe Tainted: P
2.6.36-gentoo #9 M4A79XTD EVO/System Product Name
[  161.384004] RIP: 0010:[<ffffffff8131a7ce>]  [<ffffffff8131a7ce>]
dvb_unregister_frontend+0xe/0x100
[  161.384004] RSP: 0018:ffff88009ff77c38  EFLAGS: 00010282
[  161.384004] RAX: 0000000000000023 RBX: ffff8800ab127000 RCX:
ffff88012fccf1c0
[  161.384004] RDX: 0000000000000022 RSI: 0000000000000009 RDI:
0000000000000000
[  161.384004] RBP: ffff88009ff77c78 R08: 0000000000000000 R09:
0000000000000001
[  161.384004] R10: ffffffff816ecaee R11: 0000000000000001 R12:
0000000000000000
[  161.384004] R13: 00000000ffffffff R14: ffff8800ab127450 R15:
ffff8800ab127740
[  161.384004] FS:  00007f4d1092d700(0000) GS:ffff880001b80000(0000)
knlGS:0000000000000000
[  161.384004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  161.384004] CR2: 0000000000000308 CR3: 000000009f73e000 CR4:
00000000000006e0
[  161.384004] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  161.384004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  161.498034] Process modprobe (pid: 4992, threadinfo ffff88009ff76000,
task ffff88012c358690)
[  161.498034] Stack:
[  161.498034]  ffff88012c358690 0000000000000000 0000000000000000
ffff88012b6c0000
[  161.498034] <0> ffff88009ff77c78 ffff8800ab127000 ffff8800ab127000
ffff8800ab1273c0
[  161.498034] <0> ffff88009ff77ce8 ffffffff8142e865 ffff88009ff77ce8
ffff8800ab127818
[  161.498034] Call Trace:
[  161.498034]  [<ffffffff8142e865>] mantis_dvb_init+0x3a6/0x3fb
[  161.498034]  [<ffffffffa000a3dd>] mantis_pci_probe+0x192/0x2a0 [mantis=
]
[  161.498034]  [<ffffffff811dcb7a>] local_pci_probe+0x5a/0xd0
[  161.498034]  [<ffffffff811dcfe0>] pci_device_probe+0x80/0xb0
[  161.498034]  [<ffffffff8125e15a>] ? driver_sysfs_add+0x7a/0xb0
[  161.498034]  [<ffffffff8125e29e>] driver_probe_device+0x8e/0x1b0
[  161.498034]  [<ffffffff8125e453>] __driver_attach+0x93/0xa0
[  161.498034]  [<ffffffff8125e3c0>] ? __driver_attach+0x0/0xa0
[  161.498034]  [<ffffffff8125d97c>] bus_for_each_dev+0x5c/0x90
[  161.498034]  [<ffffffff8125e0d9>] driver_attach+0x19/0x20
[  161.498034]  [<ffffffff8125d298>] bus_add_driver+0x1c8/0x250
[  161.498034]  [<ffffffffa000a4eb>] ? mantis_init+0x0/0x20 [mantis]
[  161.498034]  [<ffffffff8125e758>] driver_register+0x78/0x140
[  161.498034]  [<ffffffffa000a4eb>] ? mantis_init+0x0/0x20 [mantis]
[  161.498034]  [<ffffffff811dd251>] __pci_register_driver+0x51/0xd0
[  161.498034]  [<ffffffffa000a509>] mantis_init+0x1e/0x20 [mantis]
[  161.498034]  [<ffffffff810001de>] do_one_initcall+0x3e/0x180
[  161.498034]  [<ffffffff81073cb2>] sys_init_module+0xb2/0x200
[  161.498034]  [<ffffffff81002d82>] system_call_fastpath+0x16/0x1b
[  161.498034] Code: 00 eb 84 48 c7 c7 30 5d 70 81 31 c0 e8 da 65 11 00
eb d2 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 54 49 89 fc 53 48 83
ec 30 <48> 8b 9f 08 03 00 00 8b 3d fd 67 64 00 85 ff 0f 85 c0 00 00 00
[  161.498034] RIP  [<ffffffff8131a7ce>] dvb_unregister_frontend+0xe/0x10=
0
[  161.498034]  RSP <ffff88009ff77c38>
[  161.498034] CR2: 0000000000000308
[  161.499140] ---[ end trace 83c836f040b99d2c ]---
[1]    4992 killed     modprobe mantis

That was just a modprobe in this case because I've no serial cable
attached currently so I wasn't able to save the kernel trace.
This also happened with 2.6.{35,34} and IIRC .33 too.
Its the same with TDA10021.

I just saw it has been reported already [6]

The kernel/udev doesn't even load the drivers automatically for some
reason.. if CONFIG_DVB_TDA10023 has been build solid into the kernel
while the rest has been built as module.

[1] http://www.linuxtv.org/wiki/index.php/Technisat_CableStar_HD2
[2]
http://www.vdr-portal.de/board/thread.php?threadid=3D83798&hilight=3Dcabl=
estar+fernbedienung
[3]
http://www.vdr-portal.de/board/thread.php?threadid=3D90757&hilight=3Dcabl=
estar+fernbedienung
[4] http://jusst.de/hg/mantis-v4l-dvb/
[5] http://vdr-portal.de/board/thread.php?postid=3D870722#post870722
[6] https://bugzilla.kernel.org/show_bug.cgi?id=3D16473

--=20
Regards,
Christian Ruppert


--------------enig80907B8B640E24FF676DE7A7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJMwFa5AAoJEMOx0zmdw4Z121kH/3gqoaDuhClgpKyQ5E0Valh0
6Jn89bUO13+JXoEXd6C97HptHow05cexUM+TTW9Cug3TuhibEfEYZpvBkk0nafjm
U2s+HwCXLxJS6xkM3jB4LPsIRmv3P9AN9GUlqt8xPoU9X7pqIrZqk+R1QbYwWVVP
HTxnjTsfysCA49A4z3crG0M28PSHzS7ZJTMLOSzW3WRBQrOXbHvy+CTciasEuWzH
s+tRwrBni0XvildlvFTPAzj7873zpL6BZcZjaioCCSaGRaoiTnBa0Ah7l9R2YJEg
u2+FzEZkHlglFbF7eIJY/0FExRtmWaQjCFLvgcB1pOmidO7RWA3vMQxVM2SDLA8=
=b8ph
-----END PGP SIGNATURE-----

--------------enig80907B8B640E24FF676DE7A7--
