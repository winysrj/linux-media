Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49923 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985Ab2AHShB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Jan 2012 13:37:01 -0500
Message-ID: <1326047805.13595.307.camel@deadeye>
Subject: Re: Bug#655109: linux-2.6: BUG in videobuf-core triggered by
 mplayer on HVR-1300
From: Ben Hutchings <ben@decadent.org.uk>
To: Rik Theys <Rik.Theys@gmail.com>, 655109@bugs.debian.org
Cc: linux-media@vger.kernel.org
Date: Sun, 08 Jan 2012 18:36:45 +0000
In-Reply-To: <20120108163343.2973.20888.reportbug@saturn.home.lan>
References: <20120108163343.2973.20888.reportbug@saturn.home.lan>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+4iq4p8pqlrO6ZLcyqDy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-+4iq4p8pqlrO6ZLcyqDy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-01-08 at 17:33 +0100, Rik Theys wrote:
> Source: linux-2.6
> Version: 3.1.6-1
> Severity: normal
>=20
> Dear Maintainer,
>=20
> Trying to watch TV using mplayer on a HVR-1300 card results in a BUG in
> videobuf-core.
>=20
> I'm trying to use the MPEG device of the HVR-1300. I can trigger the bug =
easily
> with mplayer using the following options in my ~/.mplayer/config:
>=20
> tv=3Ddriver=3Dv4l2:tdevice=3D/dev/vbi0:chanlist=3Deurope-west:alsa=3D1:ad=
evice=3Dhw.1,0:audiorate=3D48000:volume=3D60:immediatemode=3D0:norm=3DPAL-B=
G:channels=3DE5-ch1,E6-VTM,E7-EEN,E8-ch4,E9-NED1,E10-ch6,E11-ch7,E12-VT4,SE=
5-ch9,SE6-RTV,SE7-CNN,SE8-ch12,SE9-ch13,SE10-ch14,SE11-2BE,SE12-ch16,SE13-c=
h17,SE14-MTV,SE15-ch19,SE16-ch20,SE17-ch21,SE18-CANVAS,SE19-ch23,SE20-ch24,=
23-ch25,24-ch26,25-ch27,26-ch28,31-ch29,32-ch30,33-ch31,34-ch32,41-ch33,43-=
ch34,44-ch35,45-ch36,46-ch37,47-ch38,48-ch39,52-ch40,53-ch41,54-ch42:device=
=3D/dev/video1
>=20
> I start mplayer using 'mplayer tv://'.
>=20
> When using the nvidia driver, this triggers the bug 99% of the time.
>=20
> I tried using nouveau to prevent kernel taint and this also triggers the =
bug, but not
> as easily as the nvidia driver.

Perhaps this is due to differences in the speed of operations.

> Jan  8 17:12:52 saturn kernel: [ 1623.655341] ------------[ cut here ]---=
---------
> Jan  8 17:12:52 saturn kernel: [ 1623.655363] kernel BUG at /home/blank/d=
ebian/kernel/release/linux-2.6/linux-2.6-3.1.6/debian/build/source_amd64_no=
ne/drivers/media/video/videobuf-core.c:300!

The 'BUG' indicates that the video capture queue hasn't been initialised
properly or has been corrupted.  However, after looking at the driver
for a while I just can't see how that can happen.

> Jan  8 17:12:52 saturn kernel: [ 1623.655391] invalid opcode: 0000 [#1] S=
MP=20
> Jan  8 17:12:52 saturn kernel: [ 1623.655406] CPU 1=20
> Jan  8 17:12:52 saturn kernel: [ 1623.655412] Modules linked in: ip6_tabl=
es ebtable_nat ebtables parport_pc ppdev lp parport rfcomm acpi_cpufreq mpe=
rf bnep bluetooth cpufreq_userspace cpufreq_powersave cpufreq_conservative =
cpufreq_stats fuse nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc bridge=
 stp xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptab=
le_filter ip_tables x_tables dm_crypt loop firewire_sbp2 kvm_intel kvm snd_=
hda_codec_hdmi cx88_blackbird cx2341x arc4 cx22702 cx88_dvb cx88_vp3054_i2c=
 videobuf_dvb dvb_core wm8775 tuner_simple tuner_types tda9887 tda8290 tune=
r snd_hda_codec_via cx88_alsa ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_=
sony_decoder ir_jvc_decoder ir_rc6_decoder snd_hda_intel rt2500pci rt2x00pc=
i rt2x00lib cx8800 cx8802 snd_hda_codec ir_rc5_decoder cx88xx ir_nec_decode=
r snd_hwdep rc_core tveeprom snd_pcm v4l2_common videodev nouveau ttm drm_k=
ms_helper drm snd_seq i2c_algo_bit joydev mac80211 cfg80211 snd_timer mxm_w=
mi wmi rfkill med
>  ia videobuf_dma_sg v4l2_compat_ioctl3
> Jan  8 17:12:52 saturn kernel: 2 snd_seq_device psmouse btcx_risc video e=
vdev videobuf_core snd eeprom_93cx6 serio_raw asus_atk0110 i7core_edac edac=
_core i2c_i801 i2c_core processor thermal_sys soundcore iTCO_wdt iTCO_vendo=
r_support snd_page_alloc button ext4 mbcache jbd2 crc16 btrfs zlib_deflate =
crc32c libcrc32c dm_mod raid1 raid0 md_mod sd_mod sr_mod crc_t10dif cdrom u=
sb_storage uas usbhid hid xhci_hcd firewire_ohci firewire_core crc_itu_t ah=
ci libahci ehci_hcd libata r8169 mii scsi_mod usbcore [last unloaded: scsi_=
wait_scan]
> Jan  8 17:12:52 saturn kernel: [ 1623.656025]=20
> Jan  8 17:12:52 saturn kernel: [ 1623.656033] Pid: 8039, comm: mplayer No=
t tainted 3.1.0-1-amd64 #1 System manufacturer System Product Name/P7P55D-E
> Jan  8 17:12:52 saturn kernel: [ 1623.656062] RIP: 0010:[<ffffffffa02d94c=
e>]  [<ffffffffa02d94ce>] videobuf_next_field+0x7/0x2b [videobuf_core]
> Jan  8 17:12:52 saturn kernel: [ 1623.656094] RSP: 0018:ffff8801f2a03b60 =
 EFLAGS: 00010246
> Jan  8 17:12:52 saturn kernel: [ 1623.656107] RAX: 0000000000000000 RBX: =
ffff8801d88c2608 RCX: ffffffffa05a155b
> Jan  8 17:12:52 saturn kernel: [ 1623.656123] RDX: 0000000000000000 RSI: =
0000000020070728 RDI: ffff8801d88c2608
> Jan  8 17:12:52 saturn kernel: [ 1623.656138] RBP: ffff880225d0e000 R08: =
0000000000000000 R09: 0000000000000000
> Jan  8 17:12:52 saturn kernel: [ 1623.656154] R10: ffff880223f22000 R11: =
ffff880223f22000 R12: ffff8801f2a03db0
> Jan  8 17:12:52 saturn kernel: [ 1623.656169] R13: ffffffffa05a38a0 R14: =
ffff8801b40ad680 R15: ffff8801d88c2600
> Jan  8 17:12:52 saturn kernel: [ 1623.656186] FS:  00007f5641bc77c0(0000)=
 GS:ffff88022fc20000(0000) knlGS:0000000000000000
> Jan  8 17:12:52 saturn kernel: [ 1623.656203] CS:  0010 DS: 0000 ES: 0000=
 CR0: 0000000080050033
> Jan  8 17:12:52 saturn kernel: [ 1623.656217] CR2: 00007f562769a000 CR3: =
00000002057ee000 CR4: 00000000000006e0
> Jan  8 17:12:52 saturn kernel: [ 1623.656232] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
> Jan  8 17:12:52 saturn kernel: [ 1623.656248] DR3: 0000000000000000 DR6: =
00000000ffff0ff0 DR7: 0000000000000400
> Jan  8 17:12:52 saturn kernel: [ 1623.656264] Process mplayer (pid: 8039,=
 threadinfo ffff8801f2a02000, task ffff88022319efa0)
> Jan  8 17:12:52 saturn kernel: [ 1623.656281] Stack:
> Jan  8 17:12:52 saturn kernel: [ 1623.656288]  ffffffffa02d97d3 ffff8801f=
2a03db0 0000000000000000 ffff880223191000
> Jan  8 17:12:52 saturn kernel: [ 1623.656314]  ffffffffa05a38a0 ffff8801b=
40ad680 ffffffffa046ab55 000000000000001f
> Jan  8 17:12:52 saturn kernel: [ 1623.656340]  0000000000000030 ffff88022=
fffcc08 0000000000000002 0000000000000000
> Jan  8 17:12:52 saturn kernel: [ 1623.656367] Call Trace:
> Jan  8 17:12:52 saturn kernel: [ 1623.656384]  [<ffffffffa02d97d3>] ? vid=
eobuf_qbuf+0x2e1/0x3cd [videobuf_core]
> Jan  8 17:12:52 saturn kernel: [ 1623.656409]  [<ffffffffa046ab55>] ? __v=
ideo_do_ioctl+0x1857/0x3cee [videodev]
> Jan  8 17:12:52 saturn kernel: [ 1623.656430]  [<ffffffffa05a155b>] ? vid=
ioc_dqbuf+0x18/0x18 [cx88_blackbird]
> Jan  8 17:12:52 saturn kernel: [ 1623.656451]  [<ffffffff810b6d89>] ? __a=
lloc_pages_nodemask+0x6e0/0x748
> Jan  8 17:12:52 saturn kernel: [ 1623.656470]  [<ffffffff8103539b>] ? sho=
uld_resched+0x5/0x23
> Jan  8 17:12:52 saturn kernel: [ 1623.656487]  [<ffffffff810f0961>] ? loo=
kup_page_cgroup+0x2d/0x42
> Jan  8 17:12:52 saturn kernel: [ 1623.656504]  [<ffffffff810ec570>] ? mem=
_cgroup_update_page_stat+0x17/0xd4
> Jan  8 17:12:52 saturn kernel: [ 1623.656521]  [<ffffffff8103539b>] ? sho=
uld_resched+0x5/0x23
> Jan  8 17:12:52 saturn kernel: [ 1623.656536]  [<ffffffff810ee6ab>] ? mem=
_cgroup_get_reclaim_stat_from_page+0xd/0x52
> Jan  8 17:12:52 saturn kernel: [ 1623.656554]  [<ffffffff810b8b74>] ? upd=
ate_page_reclaim_stat+0x17/0x44
> Jan  8 17:12:52 saturn kernel: [ 1623.656576]  [<ffffffffa0469009>] ? vid=
eo_usercopy+0x2e8/0x3a6 [videodev]
> Jan  8 17:12:52 saturn kernel: [ 1623.656599]  [<ffffffffa04692fe>] ? v4l=
_print_ext_ctrls.part.3+0xac/0xac [videodev]
> Jan  8 17:12:52 saturn kernel: [ 1623.656620]  [<ffffffff810c308d>] ? vma=
_prio_tree_insert+0x1d/0x35
> Jan  8 17:12:52 saturn kernel: [ 1623.656641]  [<ffffffffa04682d9>] ? v4l=
2_ioctl+0xe0/0x10e [videodev]
> Jan  8 17:12:52 saturn kernel: [ 1623.656658]  [<ffffffff81100fc0>] ? do_=
vfs_ioctl+0x452/0x493
> Jan  8 17:12:52 saturn kernel: [ 1623.656673]  [<ffffffff8103539b>] ? sho=
uld_resched+0x5/0x23
> Jan  8 17:12:52 saturn kernel: [ 1623.656688]  [<ffffffff8110104c>] ? sys=
_ioctl+0x4b/0x6f
> Jan  8 17:12:52 saturn kernel: [ 1623.656704]  [<ffffffff813327d2>] ? sys=
tem_call_fastpath+0x16/0x1b
> Jan  8 17:12:52 saturn kernel: [ 1623.656717] Code: a0 7e 10 eb d6 48 8d =
bb 70 01 00 00 31 ed e8 6c fe ff ff 48 89 df e8 67 fb ff ff 48 83 c4 18 89 =
e8 5b 5d c3 8b 47 5c 85 c0 75 02 <0f> 0b 83 f8 07 75 1c 83 7f 60 02 75 0a c=
7 47 60 03 00 00 00 b0=20
> Jan  8 17:12:52 saturn kernel: [ 1623.656904] RIP  [<ffffffffa02d94ce>] v=
ideobuf_next_field+0x7/0x2b [videobuf_core]
> Jan  8 17:12:52 saturn kernel: [ 1623.656928]  RSP <ffff8801f2a03b60>
> Jan  8 17:12:52 saturn kernel: [ 1623.664167] ---[ end trace 4977f1ea86d5=
af7d ]---
>=20
>=20
> I've experienced this bug with previous kernel versions as well but didn'=
t report it before.

Do you remember which was the first version where this bug appeared?

Ben.

> Here's the dmesg output from a boot of the system:
[removed; see http://bugs.debian.org/655109]

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n

--=-+4iq4p8pqlrO6ZLcyqDy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATwniPee/yOyVhhEJAQrv7g/6A22k2v+QOFjVb1t/PhhH63bSOScspFTU
SfqIf+wh7etae5XSzzLs1SypMWOvuBawIzQO1XS88c81n60mxsbWZ+zQGCY3vdWn
7CnuDVgdEaXTPjNogp452EvDCJSgYre2OtCpNSjP/P/lhOyR7iQMlHsv+EAcJlT8
gtCT008J+gvpP4p9lym0UUrS2B7iXli2zi2vzmKLlr7wh+HDIpaY2AUi+JralyWC
P3KfOJX/CQKI3Y1C9ADsJ/mboynI7FN2zDXMwfCjHpPeWXtzc3vMiBNlIQcp5hVx
pVS16z0SUW+6GSygLwL3Q4Qh2qH5MXYOR0XFMIJrKmYypBF9Ej8vda2T5TXvBR4b
vSTZXItoOrOZSB435t8ImbKjQUSP1o3VR6Oz8OX25xEIC5axJ3Yuvf/Twlh2xxKK
BwPrMRoLFQOcdLjc3pbf0Eph2JU6k/lrUj1NQIrDHCeXaw+Abbkf5poKRKBo8v/A
ynW6E3gzWQSoT1i5cDojy0IgaH2IirJNJ0qDVAYjkdsGJTnsmQ2wu58Y4dvWx7fM
BqMAtMgRg8D6TZz4P6WWFII5KKsccPxDH7fPoSwofgo2YhGg5/JmKJ6AKxclt6Q8
J0/PlRIXdzt+Gv4NRwNUuwyO1C0aQdD+FJcLmR0lRZlLyehtDZhdlMcokpbnbuQv
T8WbuUHykEU=
=LF+p
-----END PGP SIGNATURE-----

--=-+4iq4p8pqlrO6ZLcyqDy--
