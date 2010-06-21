Return-path: <linux-media-owner@vger.kernel.org>
Received: from server.klug.on.ca ([205.189.48.131]:1917 "EHLO
	server.klug.on.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535Ab0FUO2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 10:28:05 -0400
Received: from linux.interlinx.bc.ca (d67-193-197-208.home3.cgocable.net [67.193.197.208])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by server.klug.on.ca (Postfix) with ESMTP id 14B272803
	for <linux-media@vger.kernel.org>; Mon, 21 Jun 2010 09:59:02 -0400 (EDT)
Received: from [10.75.22.1] (pc.ilinx [10.75.22.1])
	by linux.interlinx.bc.ca (Postfix) with ESMTP id 7D8048777
	for <linux-media@vger.kernel.org>; Mon, 21 Jun 2010 09:59:01 -0400 (EDT)
Subject: page allocation failures with Hauppauge 950Q
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
To: linux-media@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8M6fPocjedRtRINciai7"
Date: Mon, 21 Jun 2010 09:59:01 -0400
Message-ID: <1277128741.2774.459.camel@pc.interlinx.bc.ca>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-8M6fPocjedRtRINciai7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[ resend due to subscription complications.  apologies if this winds up
becoming a duplicate. ]

Hi there.

I have a Hauppauge HVR 950Q.  I am mostly successful with it, but lately
I have=20
been seeing a lot of these:

usb 1-4: new high speed USB device using ehci_hcd and address 9
usb 1-4: configuration #1 chosen from 1 choice
au0828 driver loaded
au0828: i2c bus registered
tveeprom 5-0050: Hauppauge model 72001, rev B3F0, serial# 6922999
tveeprom 5-0050: MAC address is 00-0D-FE-69-A2-F7
tveeprom 5-0050: tuner model is Xceive XC5000 (idx 150, type 76)
tveeprom 5-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
tveeprom 5-0050: audio processor is AU8522 (idx 44)
tveeprom 5-0050: decoder processor is AU8522 (idx 42)
tveeprom 5-0050: has no radio, has IR receiver, has no IR transmitter
hauppauge_eeprom: hauppauge eeprom: model=3D72001
au8522 5-0047: creating new instance
au8522_decoder creating new instance...
tuner 5-0061: chip found @ 0xc2 (au0828)
xc5000 5-0061: creating new instance
xc5000: Successfully identified at address 0x61
xc5000: Firmware has not been loaded previously
au8522 5-0047: attaching existing instance
xc5000 5-0061: attaching existing instance
xc5000: Successfully identified at address 0x61
xc5000: Firmware has not been loaded previously
DVB: registering new adapter (au0828)
DVB: registering adapter 0 frontend 0 (Auvitek AU8522 QAM/8VSB Frontend)...
Registered device AU0828 [Hauppauge HVR950Q]
usbcore: registered new interface driver au0828
xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
usb 1-4: firmware: requesting dvb-fe-xc5000-1.6.114.fw
xc5000: firmware read 12401 bytes.
xc5000: firmware uploading...
xc5000: firmware upload complete...
mythbackend: page allocation failure. order:4, mode:0xc0d0
Pid: 15154, comm: mythbackend Tainted: P           2.6.32-22-generic #36-Ub=
untu
Call Trace:
 [<c0588f92>] ? printk+0x1d/0x23
 [<c01cf82e>] __alloc_pages_slowpath+0x46e/0x4a0
 [<c01cf99a>] __alloc_pages_nodemask+0x13a/0x170
 [<c01cf9ec>] __get_free_pages+0x1c/0x30
 [<f87d6bdf>] start_urb_transfer+0x7f/0x1e0 [au0828]
 [<f87d6e03>] au0828_dvb_start_feed+0xc3/0xe0 [au0828]
 [<f877ec44>] ? dmx_ts_feed_set+0x104/0x130 [dvb_core]
 [<f877ecc8>] dmx_ts_feed_start_filtering+0x58/0xe0 [dvb_core]
 [<f877badb>] dvb_dmxdev_start_feed+0xab/0x110 [dvb_core]
 [<f877cf01>] dvb_dmxdev_filter_start+0x2a1/0x380 [dvb_core]
 [<c020b295>] ? chrdev_open+0xf5/0x200
 [<f877d487>] dvb_demux_do_ioctl+0x4a7/0x550 [dvb_core]
 [<c0205f3f>] ? __dentry_open+0x1af/0x290
 [<f877b926>] dvb_usercopy+0x96/0x140 [dvb_core]
 [<f877cfe0>] ? dvb_demux_do_ioctl+0x0/0x550 [dvb_core]
 [<c0201dd5>] ? mem_cgroup_update_mapped_file_stat+0x35/0x90
 [<f877bfff>] dvb_demux_ioctl+0x1f/0x30 [dvb_core]
 [<f877cfe0>] ? dvb_demux_do_ioctl+0x0/0x550 [dvb_core]
 [<c021628b>] vfs_ioctl+0x7b/0x90
 [<c0216519>] do_vfs_ioctl+0x79/0x310
 [<c0216817>] sys_ioctl+0x67/0x80
 [<c0205d4e>] ? sys_open+0x2e/0x40
 [<c01033ec>] syscall_call+0x7/0xb
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
CPU    1: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:   0
CPU    1: hi:  186, btch:  31 usd:   0
HighMem per-cpu:
CPU    0: hi:  186, btch:  31 usd:   2
CPU    1: hi:  186, btch:  31 usd:   0
active_anon:238741 inactive_anon:92054 isolated_anon:88
 active_file:46091 inactive_file:47629 isolated_file:65
 unevictable:35 dirty:18690 writeback:500 unstable:207
 free:233580 slab_reclaimable:13718 slab_unreclaimable:10001
 mapped:19061 shmem:3609 pagetables:4972 bounce:0
DMA free:3508kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0=
kB active_file:1904kB inactive_file:2024kB unevictable:0kB isolated(anon):0=
kB isolated(file):0kB present:15804kB mlocked:0kB dirty:96kB writeback:0kB =
mapped:0kB shmem:0kB slab_reclaimable:44kB slab_unreclaimable:616kB kernel_=
stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_sc=
anned:0 all_unreclaimable? no
lowmem_reserve[]: 0 865 2777 2777
Normal free:410632kB min:3728kB low:4660kB high:5592kB active_anon:59376kB =
inactive_anon:61132kB active_file:80984kB inactive_file:84656kB unevictable=
:0kB isolated(anon):220kB isolated(file):236kB present:885944kB mlocked:0kB=
 dirty:46268kB writeback:292kB mapped:5692kB shmem:348kB slab_reclaimable:5=
4828kB slab_unreclaimable:39388kB kernel_stack:4856kB pagetables:1084kB uns=
table:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? n=
o
lowmem_reserve[]: 0 0 15295 15295
HighMem free:520180kB min:512kB low:2572kB high:4632kB active_anon:895588kB=
 inactive_anon:307084kB active_file:101476kB inactive_file:103836kB unevict=
able:140kB isolated(anon):132kB isolated(file):24kB present:1957776kB mlock=
ed:136kB dirty:28396kB writeback:1708kB mapped:70552kB shmem:14088kB slab_r=
eclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:18804kB u=
nstable:828kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimabl=
e? no
lowmem_reserve[]: 0 0 0 0
DMA: 5*4kB 30*8kB 15*16kB 30*32kB 24*64kB 2*128kB 1*256kB 0*512kB 0*1024kB =
0*2048kB 0*4096kB =3D 3508kB
Normal: 5376*4kB 27467*8kB 10527*16kB 26*32kB 0*64kB 1*128kB 0*256kB 0*512k=
B 0*1024kB 0*2048kB 0*4096kB =3D 410632kB
HighMem: 2277*4kB 45032*8kB 9358*16kB 28*32kB 3*64kB 0*128kB 0*256kB 0*512k=
B 0*1024kB 0*2048kB 0*4096kB =3D 520180kB
148793 total pagecache pages
51452 pages in swap cache
Swap cache stats: add 4720177, delete 4668725, find 3791881/4313248
Free swap  =3D 1501312kB
Total swap =3D 3145720kB
720608 pages RAM
493298 pages HighMem
11342 pages reserved
184002 pages shared
402390 pages non-shared

This machine has ~3G of memory and is an i686 2.6.32-22-generic Ubuntu
kernel.

I don't know if that helps you understand the version of the stack I am
running for this card or not.  If not, let me know how else I can
determine software versions for you.

Is this a known issue?

Cheers,
b.


--=-8M6fPocjedRtRINciai7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkwfcCMACgkQl3EQlGLyuXB5GACgklEZ/FrNopvA0XDn8S2we54O
pAMAoPDtfHQ/jZFS4bP3hp7uSnq1np6p
=K4ZQ
-----END PGP SIGNATURE-----

--=-8M6fPocjedRtRINciai7--

