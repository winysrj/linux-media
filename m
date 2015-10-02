Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.paranoids.at ([92.63.218.99]:49415 "EHLO mail.paranoids.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbbJBILs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2015 04:11:48 -0400
Received: from mail.paranoids.at (localhost [127.0.0.1])
	by mail.paranoids.at (Postfix) with ESMTPS id 3CDE140838
	for <linux-media@vger.kernel.org>; Fri,  2 Oct 2015 10:06:40 +0200 (CEST)
Received: from [IPv6:2a01:100:1034:1::2] (tv.tuxstef.org [IPv6:2a01:100:1034:1::2])
	(Authenticated sender: tuxstef@tuxstef.org)
	by mail.paranoids.at (Postfix) with ESMTPSA id 17138407F4
	for <linux-media@vger.kernel.org>; Fri,  2 Oct 2015 10:06:39 +0200 (CEST)
To: linux-media@vger.kernel.org
From: Stefan Breitegger <tuxstef@tuxstef.org>
Subject: Satix S2 driver bug report - kernel tried to execute NX-protected
 page - exploit attempt?
Message-ID: <560E3B0E.6080203@tuxstef.org>
Date: Fri, 2 Oct 2015 10:06:38 +0200
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070907010909030507060508"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070907010909030507060508
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Dear Sir or Madam!

After upgrading to Ubuntu mainline kernel 4.2.2-040202-generic the
cx23885 module is not working any more.
A dmesg here:

[  247.320554] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
[  261.359682] media: Linux media interface: v0.10
[  261.364715] Linux video capture interface: v2.00
[  261.364718] WARNING: You are using an experimental version of the
media stack.
    As the driver is backported to an older kernel, it doesn't offer
    enough quality for its usage in production.
    Use it with care.
Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
    ca739eb086155007d7264be7ccc07f894d5a7bbe Revert [media] rcar_vin:
call g_std() instead of querystd()
    d383b57911c8a6c3da1af7b3f72dfecfcd5633d0 [media] DocBook: Remove a
warning at videobuf2-v4l2.h
    32d81b41cd4f2021ef1b6378b4f6029307687df2 [media] DocBook: fix most
of warnings at videobuf2-core.h
[  261.381875] cx23885 driver version 0.0.4 loaded
[  261.381996] CORE cx23885[0]: subsystem: 4254:0952, board: DVBSky S952
[card=50,autodetected]
[  261.613345] cx25840 15-0044: cx23885 A/V decoder found @ 0x88
(cx23885[0])
[  262.235583] cx25840 15-0044: loaded v4l-cx23885-avcore-01.fw firmware
(16382 bytes)
[  262.252095] cx23885_dvb_register() allocating 1 frontend(s)
[  262.252099] cx23885[0]: cx23885 based dvb card
[  262.252495] kernel tried to execute NX-protected page - exploit
attempt? (uid: 0)
[  262.252497] BUG: unable to handle kernel paging request at
ffffffffc1040189
[  262.252500] IP: [<ffffffffc1040189>]
__param_str_disable_analog_audio+0x3fa9/0xffffffffffffce20 [cx23885]
[  262.252513] PGD 1c10067 PUD 1c12067 PMD 6aa0f067 PTE 8000000123307161
[  262.252516] Oops: 0011 [#1] SMP
[  262.252518] Modules linked in: cx25840(OE) cx23885(OE+) altera_ci(OE)
tda18271(OE) altera_stapl(OE) videobuf2_dvb(OE) m88ds3103(OE)
tveeprom(OE) cx2341x(OE) i2c_mux videobuf2_dma_sg(OE)
videobuf2_memops(OE) frame_vector(POE) videobuf2_core(OE)
v4l2_common(OE) videodev(OE) media(OE) ngene(OE) rc_dib0700_rc5(OE)
dvb_usb_dib0700(OE) dib9000(OE) dib7000m(OE) dib0090(OE) dib0070(OE)
dib3000mc(OE) dibx000_common(OE) dvb_usb(OE) dvb_core(OE) rc_core(OE)
mt2060(OE) xt_CHECKSUM iptable_mangle ipt_MASQUERADE
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 ebtable_filter ebtables
xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 af_key
xfrm_algo binfmt_misc bridge stp llc ppdev snd_hda_codec_via
snd_hda_codec_generic nvidia(POE) snd_hda_intel snd_hda_codec
snd_hda_core snd_hwdep snd_pcm input_leds kvm_amd
[  262.252547]  kvm snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq
serio_raw edac_core snd_seq_device edac_mce_amd k10temp snd_timer snd
drm soundcore parport_pc 8250_fintek wmi parport shpchp i2c_piix4
asus_atk0110 mac_hid ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 xt_hl
ip6t_rt nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4
nf_log_ipv4 nf_log_common xt_LOG xt_limit xt_tcpudp xt_addrtype
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack ip6table_filter ip6_tables
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables nvram
autofs4 pata_acpi raid10 raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor hid_generic usbhid hid psmouse raid6_pq raid1
pata_atiixp raid0 multipath ahci r8169 libahci mii linear

[  262.252580] CPU: 0 PID: 4771 Comm: modprobe Tainted: P           OE  
4.2.2-040202-generic #201509291435
[  262.252582] Hardware name: System manufacturer System Product
Name/M4A785TD-V EVO, BIOS 2105    07/23/2010
[  262.252584] task: ffff880117538000 ti: ffff88007a6b4000 task.ti:
ffff88007a6b4000
[  262.252586] RIP: 0010:[<ffffffffc1040189>]  [<ffffffffc1040189>]
__param_str_disable_analog_audio+0x3fa9/0xffffffffffffce20 [cx23885]
[  262.252594] RSP: 0018:ffff88007a6b7820  EFLAGS: 00010282
[  262.252595] RAX: ffff880119c3d800 RBX: ffff880119c3d800 RCX:
0000000000000000
[  262.252596] RDX: ffff880128c39db0 RSI: ffff880128c39da8 RDI:
ffff880119c3d800
[  262.252598] RBP: ffff88007a6b78b8 R08: 0000000000000000 R09:
ffff88012abf3200
[  262.252599] R10: 00000000000082ae R11: 0000000000000010 R12:
ffff88006abe8810
[  262.252600] R13: ffff88007a6b78e8 R14: ffff88007a6b7850 R15:
ffffffffc103b260
[  262.252602] FS:  00007f7b955c2700(0000) GS:ffff88012fc00000(0000)
knlGS:00000000f71f2b40
[  262.252604] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  262.252605] CR2: ffffffffc1040189 CR3: 000000006ab28000 CR4:
00000000000006f0
[  262.252606] Stack:
[  262.252607]  ffffffffc0ff720b fffe0021019bfcc0 ffe099fd00003e80
0000000000000106
[  262.252609]  ffffffffc1040189 ffffffff81ef0101 303133736438386d
0000000000000033
[  262.252612]  0068000000000000 ffff88007a6b7828 0000000000000000
0000000000000000
[  262.252614] Call Trace:
[  262.252618]  [<ffffffffc0ff720b>] ? m88ds3103_attach+0x13b/0x170
[m88ds3103]
[  262.252626]  [<ffffffffc102e14d>] dvb_register+0x52d/0x36c0 [cx23885]
[  262.252632]  [<ffffffffc102d7b0>] ?
dvbsky_s952_portc_set_voltage+0xb0/0xb0 [cx23885]
[  262.252636]  [<ffffffff810cbdb2>] ? wake_up_klogd+0x32/0x40
[  262.252639]  [<ffffffff810cbf98>] ? console_unlock+0x1d8/0x4c0
[  262.252641]  [<ffffffff810cc5f4>] ? vprintk_emit+0x374/0x4f0
[  262.252643]  [<ffffffff810cc8c9>] ? vprintk_default+0x29/0x40
[  262.252646]  [<ffffffff8179bf1d>] ? printk+0x46/0x48
[  262.252653]  [<ffffffffc10316d7>] cx23885_dvb_register+0x117/0x160
[cx23885]
[  262.252658]  [<ffffffffc102a01b>] cx23885_initdev+0xf5b/0x1230 [cx23885]
[  262.252662]  [<ffffffff813e2ff5>] local_pci_probe+0x45/0xa0
[  262.252665]  [<ffffffff813e41b4>] ? pci_match_device+0xf4/0x120
[  262.252667]  [<ffffffff813e42ea>] pci_device_probe+0xca/0x110
[  262.252671]  [<ffffffff814e521d>] driver_probe_device+0x1ed/0x430
[  262.252673]  [<ffffffff814e54f0>] __driver_attach+0x90/0xa0
[  262.252675]  [<ffffffff814e5460>] ? driver_probe_device+0x430/0x430
[  262.252677]  [<ffffffff814e308d>] bus_for_each_dev+0x5d/0x90
[  262.252679]  [<ffffffff814e4bde>] driver_attach+0x1e/0x20
[  262.252681]  [<ffffffff814e4750>] bus_add_driver+0x1d0/0x290
[  262.252683]  [<ffffffffc1050000>] ? 0xffffffffc1050000
[  262.252685]  [<ffffffff814e5eb0>] driver_register+0x60/0xe0
[  262.252688]  [<ffffffff813e295c>] __pci_register_driver+0x4c/0x50
[  262.252693]  [<ffffffffc1050033>] cx23885_init+0x33/0x1000 [cx23885]
[  262.252696]  [<ffffffff8100213d>] do_one_initcall+0xcd/0x1f0
[  262.252698]  [<ffffffff811b279e>] ? __vunmap+0xae/0xf0
[  262.252701]  [<ffffffff811ccb2f>] ? kmem_cache_alloc_trace+0x17f/0x1f0
[  262.252704]  [<ffffffff8179c50e>] ? do_init_module+0x28/0x1ea
[  262.252706]  [<ffffffff8179c547>] do_init_module+0x61/0x1ea
[  262.252709]  [<ffffffff810fa6d1>] load_module+0x1401/0x1b20
[  262.252712]  [<ffffffff810f6c30>] ? __symbol_put+0x40/0x40
[  262.252715]  [<ffffffff810fafd0>] SyS_finit_module+0x80/0xb0
[  262.252718]  [<ffffffff817a9472>] entry_SYSCALL_64_fastpath+0x16/0x75
[  262.252719] Code: 31 00 61 38 32 39 33 00 73 69 32 31 36 35 5f 61 74
74 61 63 68 00 73 79 6d 62 6f 6c 3a 73 69 32 31 36 35 5f 61 74 74 61 63
68 00 <6d> 38 38 64 73 33 31 30 33 5f 61 74 74 61 63 68 00 73 79 6d 62
[  262.252739] RIP  [<ffffffffc1040189>]
__param_str_disable_analog_audio+0x3fa9/0xffffffffffffce20 [cx23885]
[  262.252746]  RSP <ffff88007a6b7820>
[  262.252747] CR2: ffffffffc1040189
[  262.252749] ---[ end trace e5e7d4edcd42cc5d ]---

Yours sincerely,
Stefan

--------------070907010909030507060508
Content-Type: text/x-vcard; charset=utf-8;
 name="tuxstef.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tuxstef.vcf"

begin:vcard
fn:Stefan Breitegger
n:Breitegger;Stefan
adr;quoted-printable:;;Gabelsbergerstr. 8/4;Villach;K=C3=A4rnten;9500;AT
email;internet:tuxstef@tuxstef.org
tel;home:0720 597 427
tel;cell:0680 233 13 04
x-mozilla-html:FALSE
url:http://www.tuxstef.org
version:2.1
end:vcard


--------------070907010909030507060508--
