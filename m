Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:49683 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758149AbaISXvw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 19:51:52 -0400
Received: by mail-oi0-f42.google.com with SMTP id u20so2195325oif.1
        for <linux-media@vger.kernel.org>; Fri, 19 Sep 2014 16:51:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEVwYfiwkF8mYjYvj0gCmojm35reGKv-Hw25VVciAYbPpUf+Kg@mail.gmail.com>
References: <CAEVwYfiwkF8mYjYvj0gCmojm35reGKv-Hw25VVciAYbPpUf+Kg@mail.gmail.com>
Date: Sat, 20 Sep 2014 01:51:51 +0200
Message-ID: <CAEVwYfguLZNy-TdHqregwU+skYJP_kF=vc-3kE6+hhOBQ66aMw@mail.gmail.com>
Subject: Fwd: kernel BUG at mm/slub.c on cx23885
From: beta992 <beta992@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hauppauge HVR-5500 using the latest git build, keeps crashing with the
following error:

[ 2111.934790] kernel BUG at mm/slub.c:1416!
[ 2111.934877] invalid opcode: 0000 [#1] PREEMPT SMP
[ 2111.934993] Modules linked in: ftdi_sio usbserial xt_recent
si2165(O) a8293(O) tda10071(O) tea5767(O) tuner(O) cx23885(OF)
eeepc_wmi asus_wmi sparse_keymap led_class rfkill video kvm_amd kvm
nls_iso8859_1 altera_ci(O) ext4 tda18271(O) microcode crc16 mbcache
altera_stapl videobuf2_dvb(O) serio_raw videobuf2_dma_sg(O) jbd2
psmouse tveeprom(O) pcspkr cx2341x(O) k10temp evdev dvb_core(O)
ip6t_REJECT mac_hid r8169 rc_core(O) mii videobuf2_memops(O)
videobuf2_core(O) v4l2_common(O) xt_hl ip6t_rt radeon videodev(O)
media(O) nf_conntrack_ipv6 nf_defrag_ipv6 snd_hda_codec_via
snd_hda_codec_generic i2c_algo_bit snd_hda_intel ttm ipt_REJECT
snd_hda_controller drm_kms_helper xt_LOG snd_hda_codec drm xt_limit
snd_hwdep xt_tcpudp snd_pcm wmi sp5100_tco xt_addrtype snd_timer
i2c_piix4 acpi_cpufreq snd hwmon button
[ 2111.936816]  i2c_core shpchp soundcore processor nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack ip6table_filter ip6_tables
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables
crc32c_generic btrfs xor raid6_pq xts gf128mul algif_skcipher af_alg
dm_crypt dm_mod hid_generic usbhid hid sd_mod crct10dif_generic
crc_t10dif crct10dif_common atkbd libps2 ahci libahci libata ohci_pci
ohci_hcd ehci_pci ehci_hcd usbcore scsi_mod usb_common i8042 serio
vfat fat nls_cp437
[ 2111.938018] CPU: 1 PID: 2404 Comm: tvheadend Tainted: GF          O
 3.16.3-1-ARCH #1
[ 2111.938174] Hardware name: System manufacturer System Product
Name/C60M1-I, BIOS 0305 08/07/2012
[ 2111.938350] task: ffff88009fff3d20 ti: ffff880229768000 task.ti:
ffff880229768000
[ 2111.938499] RIP: 0010:[<ffffffff811a3120>]  [<ffffffff811a3120>]
new_slab+0x2e0/0x330
[ 2111.938673] RSP: 0018:ffff88022976b928  EFLAGS: 00010002
[ 2111.938782] RAX: ffff88009fff3d20 RBX: 0000000000000001 RCX: ffff88022976b9d0
[ 2111.938924] RDX: 00000000ffffffff RSI: 0000000000000004 RDI: ffff880236801c00
[ 2111.939065] RBP: ffff88022976ba48 R08: 0000000000000000 R09: 0000000000000004
[ 2111.939206] R10: ffff88022c7e41b0 R11: 0000000000000000 R12: ffff880236800f40
[ 2111.939346] R13: 0000000000000004 R14: ffff880236801c00 R15: ffff88023eff9c38
[ 2111.939489] FS:  00007fa986c47780(0000) GS:ffff88023ed00000(0000)
knlGS:0000000000000000
[ 2111.939649] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2111.939765] CR2: 00007f123d2bd4a0 CR3: 00000002294d8000 CR4: 00000000000007e0
[ 2111.939905] Stack:
[ 2111.939951]  ffffffff811a56a4 0000000000000000 ffff88023ed17380
ffff88009fff3d20
[ 2111.940123]  0000000000001c00 ffff88009fff3d20 ffff88023ed17390
0000000000000000
[ 2111.940293]  0000000000000000 0000000100000000 ffff8802ffffffff
ffffffff812b2469
[ 2111.940463] Call Trace:
[ 2111.940527]  [<ffffffff811a56a4>] ? __slab_alloc.isra.53+0x4f4/0x5e0
[ 2111.940664]  [<ffffffff812b2469>] ? sg_kmalloc+0x19/0x30
[ 2111.940779]  [<ffffffff811558a0>] ? __alloc_pages_nodemask+0x180/0xc20
[ 2111.940916]  [<ffffffff811a5f93>] __kmalloc+0x163/0x1c0
[ 2111.941028]  [<ffffffff812b2469>] ? sg_kmalloc+0x19/0x30
[ 2111.941142]  [<ffffffff812b2469>] sg_kmalloc+0x19/0x30
[ 2111.941252]  [<ffffffff812b2330>] __sg_alloc_table+0x70/0x160
[ 2111.941372]  [<ffffffff812b2450>] ? sg_kfree+0x30/0x30
[ 2111.941484]  [<ffffffff812b277f>] sg_alloc_table+0x1f/0x60
[ 2111.941600]  [<ffffffff812b2844>] sg_alloc_table_from_pages+0x84/0x1c0
[ 2111.941744]  [<ffffffffa068e751>] vb2_dma_sg_alloc+0x161/0xa10
[videobuf2_dma_sg]
[ 2111.941906]  [<ffffffffa063333a>] __vb2_queue_alloc+0x10a/0x600
[videobuf2_core]
[ 2111.942065]  [<ffffffffa06364eb>] __reqbufs.isra.13+0x1ab/0x3f0
[videobuf2_core]
[ 2111.942221]  [<ffffffffa06f3200>] ? vb2_dvb_start_feed+0xc0/0xc0
[videobuf2_dvb]
[ 2111.942379]  [<ffffffffa06372a7>] __vb2_init_fileio+0xc7/0x370
[videobuf2_core]
[ 2111.948071]  [<ffffffffa06f3200>] ? vb2_dvb_start_feed+0xc0/0xc0
[videobuf2_dvb]
[ 2111.953792]  [<ffffffffa0638ffe>] vb2_thread_start+0xae/0x10b0
[videobuf2_core]
[ 2111.959554]  [<ffffffffa06f31c8>] vb2_dvb_start_feed+0x88/0xc0
[videobuf2_dvb]
[ 2111.965285]  [<ffffffffa0673b82>]
dmx_section_feed_start_filtering+0xe2/0x190 [dvb_core]
[ 2111.971032]  [<ffffffffa0670eee>]
dvb_dmxdev_filter_start+0x20e/0x3d0 [dvb_core]
[ 2111.976802]  [<ffffffffa0671a20>] dvb_demux_do_ioctl+0x4e0/0x640 [dvb_core]
[ 2111.982414]  [<ffffffffa066f985>] dvb_usercopy+0x115/0x190 [dvb_core]
[ 2111.987846]  [<ffffffffa0671540>] ?
dvb_dmxdev_ts_callback+0xf0/0xf0 [dvb_core]
[ 2111.993136]  [<ffffffff810b65c4>] ? add_wait_queue+0x44/0x50
[ 2111.998236]  [<ffffffff81206a80>] ? ep_ptable_queue_proc+0x60/0xa0
[ 2112.003169]  [<ffffffffa066fe35>] dvb_demux_ioctl+0x15/0x20 [dvb_core]
[ 2112.007948]  [<ffffffff811d4af0>] do_vfs_ioctl+0x2d0/0x4b0
[ 2112.012531]  [<ffffffff811df22e>] ? __fget+0x6e/0xb0
[ 2112.016918]  [<ffffffff811d4d51>] SyS_ioctl+0x81/0xa0
[ 2112.021107]  [<ffffffff81531129>] system_call_fastpath+0x16/0x1b
[ 2112.025245] Code: 00 00 20 00 4c 89 f6 48 c1 ee 10 e8 fb 6f ff ff
49 89 c5 83 e3 10 0f 84 f2 fd ff ff e9 e6 fd ff ff 66 2e 0f 1f 84 00
00 00 00 00 <0f> 0b ba 00 10 00 00 be 5a 00 00 00 48 89 df 48 d3 e2 e8
69 bb
[ 2112.034327] RIP  [<ffffffff811a3120>] new_slab+0x2e0/0x330
[ 2112.038633]  RSP <ffff88022976b928>
[ 2112.086908] ---[ end trace 3027fe21b48c2303 ]---

It seems to be coming up when the TV-card has to tune to multiple
channels, but don't know for sure.

If more debug info is needed, please let me know.
