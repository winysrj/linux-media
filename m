Return-path: <linux-media-owner@vger.kernel.org>
Received: from fortimail.online.lv ([81.198.164.220]:43462 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbbAKJdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2015 04:33:44 -0500
Received: from mailo-proxy3.online.lv (smtp.online.lv [81.198.164.193])
	by fortimail.online.lv  with ESMTP id t0B9XfxY026613-t0B9XfxZ026613
	for <linux-media@vger.kernel.org>; Sun, 11 Jan 2015 11:33:41 +0200
Message-ID: <54B24370.6010004@apollo.lv>
Date: Sun, 11 Jan 2015 11:33:36 +0200
From: Raimonds Cicans <ray@apollo.lv>
MIME-Version: 1.0
To: hans.verkuil@cisco.com
CC: linux-media@vger.kernel.org
Subject: [REGRESSION] media: cx23885 broken by commit 453afdd "[media]
 cx23885: convert to vb2"
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

I contacted you because I am hit by regression caused by your commit:
453afdd "[media] cx23885: convert to vb2"


My system:
AMD Athlon(tm) II X2 240e Processor on Asus M5A97 LE R2.0 motherboard
TBS6981 card (Dual DVB-S/S2 PCIe receiver, cx23885 in kernel driver)

After upgrade from kernel 3.13.10 (do not have commit) to 3.17.7
(have commit) I started receiving following IOMMU related messages:

1)
AMD-Vi: Event logged [IO_PAGE_FAULT device=0a:00.0 domain=0x001d 
address=0x000000000637c000 flags=0x0000]

where device=0a:00.0 is TBS6981 card

sometimes this message was followed by storm of following messages:
cx23885[0]: mpeg risc op code error
...

2)
  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 6946 at drivers/iommu/amd_iommu.c:2637 
dma_ops_domain_unmap.part.12+0x55/0x72()
  Modules linked in: ip6table_filter ip6_tables act_police cls_basic 
cls_flow cls_fw cls_u32 sch_fq_codel sch_tbf sch_prio sch_htb sch_hfsc 
sch_ingress sch_sfq xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT xt_realm 
xt_addrtype xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN 
ipt_CLUSTERIP ipt_ah xt_set nf_nat_ftp xt_time xt_TCPMSS xt_tcpmss 
xt_policy xt_pkttype xt_physdev br_netfilter xt_NFQUEUE xt_NFLOG xt_mark 
xt_mac xt_length xt_helper xt_hashlimit xt_DSCP xt_dscp xt_CLASSIFY 
xt_AUDIT iptable_raw iptable_nat nf_nat_ipv4 nf_nat iptable_mangle 
hwmon_vid bridge stp llc ipv6 cx24117 cx25840 snd_usb_audio snd_hwdep 
snd_usbmidi_lib uvcvideo snd_rawmidi videobuf2_vmalloc 
snd_hda_codec_hdmi ir_xmp_decoder ir_lirc_codec lirc_dev 
ir_mce_kbd_decoder ir_sharp_decoder ir_sanyo_decoder ir_sony_decoder 
ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder rc_rc6_mce 
microcode k10temp mceusb cx23885 tda18271 altera_stapl videobuf2_dvb 
videobuf2_core videobuf2_dma_sg videobuf2_memops tveeprom cx2341x 
rc_core v4l2_common videodev si2157 si2168 saa716x_budget saa716x_core 
dvb_core nouveau i2c_algo_bit ttm snd_hda_intel drm_kms_helper 
snd_hda_controller sp5100_tco r8169 i2c_piix4 snd_hda_codec drm mii
  CPU: 1 PID: 6946 Comm: w_scan Tainted: G        W 3.19.0-rc3-myrc01 #1
  Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 LE 
R2.0, BIOS 2501 04/09/2014
   0000000000000000 0000000000000009 ffffffffb0640fe8 0000000000000000
   ffffffffb00bcf46 0000000000d27000 ffffffffb04eb2a0 0000000000d46000
   0000000000d27000 ffff8800b8287938 0000000000000001 00000000000001f8
  Call Trace:
   [<ffffffffb0640fe8>] ? dump_stack+0x40/0x50
   [<ffffffffb00bcf46>] ? warn_slowpath_common+0x93/0xab
   [<ffffffffb04eb2a0>] ? dma_ops_domain_unmap.part.12+0x55/0x72
   [<ffffffffb04eb2a0>] ? dma_ops_domain_unmap.part.12+0x55/0x72
   [<ffffffffb04ecc8c>] ? __unmap_single.isra.15+0x7b/0xcf
   [<ffffffffb04ed43a>] ? free_coherent+0x46/0x7e
   [<ffffffffc05b064f>] ? __vb2_queue_cancel+0x1b8/0x1d6 [videobuf2_core]
   [<ffffffffc05b22e1>] ? __reqbufs+0x15b/0x334 [videobuf2_core]
   [<ffffffffc05b2647>] ? vb2_thread_stop+0x100/0x146 [videobuf2_core]
   [<ffffffffc05bc0ce>] ? vb2_dvb_stop_feed+0x41/0x58 [videobuf2_dvb]
   [<ffffffffc052b4ea>] ? dvb_dmxdev_filter_start+0x35/0x301 [dvb_core]
   [<ffffffffc052d12f>] ? dmx_section_feed_stop_filtering+0x40/0x7b 
[dvb_core]
   [<ffffffffc052b307>] ? dvb_dmxdev_feed_stop+0x5d/0x89 [dvb_core]
   [<ffffffffc052b60f>] ? dvb_dmxdev_filter_start+0x15a/0x301 [dvb_core]
   [<ffffffffc052bd3f>] ? dvb_demux_do_ioctl+0x1cc/0x4fe [dvb_core]
   [<ffffffffb016973d>] ? path_openat+0x44d/0x55d
   [<ffffffffc052bb73>] ? dvb_dmxdev_ts_callback+0xc2/0xc2 [dvb_core]
   [<ffffffffc052a6b9>] ? dvb_usercopy+0xa7/0x127 [dvb_core]
   [<ffffffffb016a38f>] ? do_filp_open+0x2b/0x6f
   [<ffffffffc052aa3f>] ? dvb_demux_ioctl+0xd/0x11 [dvb_core]
   [<ffffffffc052aa32>] ? dvb_dvr_ioctl+0x11/0x11 [dvb_core]
   [<ffffffffb016bf68>] ? do_vfs_ioctl+0x360/0x424
   [<ffffffffb0173706>] ? __fd_install+0x15/0x40
   [<ffffffffb015d5a9>] ? do_sys_open+0x1b3/0x1c5
   [<ffffffffb016c05f>] ? SyS_ioctl+0x33/0x58
   [<ffffffffb0646452>] ? system_call_fastpath+0x12/0x17
  ---[ end trace 2f92b32249912b0e ]---

3) after enabling debug in DMA API, I started receiving following message:

  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 6946 at lib/dma-debug.c:1093 
check_unmap+0x180/0x7c6()
  cx23885 0000:0a:00.0: DMA-API: device driver tries to free DMA memory 
it has not allocated [device address=0x0000000000d27000] [size=504 bytes]
  Modules linked in: ip6table_filter ip6_tables act_police cls_basic 
cls_flow cls_fw cls_u32 sch_fq_codel sch_tbf
   sch_prio sch_htb sch_hfsc sch_ingress sch_sfq xt_CHECKSUM 
ipt_rpfilter xt_statistic xt_CT xt_realm xt_addrtype xt_nat 
ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN ipt_CLUSTERIP ipt_ah 
xt_set nf_nat_ftp xt_time xt_TCPMSS xt_tcpmss xt_policy xt_pkttype 
xt_physdev br_netfilter xt_NFQUEUE xt_NFLOG xt_mark xt_mac xt_length 
xt_helper xt_hashlimit xt_DSCP xt_dscp xt_CLASSIFY xt_AUDIT iptable_raw 
iptable_nat nf_nat_ipv4 nf_nat iptable_mangle hwmon_vid bridge stp llc 
ipv6 cx24117 cx25840 snd_usb_audio snd_hwdep snd_usbmidi_lib uvcvideo 
snd_rawmidi videobuf2_vmalloc snd_hda_codec_hdmi ir_xmp_decoder 
ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sharp_decoder 
ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder 
ir_rc5_decoder ir_nec_decoder rc_rc6_mce microcode k10temp mceusb 
cx23885 tda18271 altera_stapl videobuf2_dvb videobuf2_core 
videobuf2_dma_sg videobuf2_memops tveeprom cx2341x rc_core v4l2_common 
videodev si2157 si2168 saa716x_budget saa716x_core dvb_core nouveau 
i2c_algo_bit ttm snd_hda_intel drm_kms_helper snd_hda_controller 
sp5100_tco r8169 i2c_piix4 snd_hda_codec drm mii
  CPU: 1 PID: 6946 Comm: w_scan Not tainted 3.19.0-rc3-myrc01 #1
  Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 LE 
R2.0, BIOS 2501 04/09/2014
   0000000000000000 0000000000000009 ffffffffb0640fe8 ffff8800b2003ae8
   ffffffffb00bcf46 0000000000000000 ffffffffb0353f3b 0000000000000206
   ffff8800b2003bc8 00000000000001f8 0000000000d27000 ffffffffb0c789d0
  Call Trace:
   [<ffffffffb0640fe8>] ? dump_stack+0x40/0x50
   [<ffffffffb00bcf46>] ? warn_slowpath_common+0x93/0xab
   [<ffffffffb0353f3b>] ? check_unmap+0x180/0x7c6
   [<ffffffffb00bcfa3>] ? warn_slowpath_fmt+0x45/0x4a
   [<ffffffffb0353f3b>] ? check_unmap+0x180/0x7c6
   [<ffffffffb035466d>] ? debug_dma_free_coherent+0x85/0x8a
   [<ffffffffc05d9be1>] ? cx23885_free_buffer+0x80/0xab [cx23885]
   [<ffffffffc05b064f>] ? __vb2_queue_cancel+0x1b8/0x1d6 [videobuf2_core]
   [<ffffffffc05b22e1>] ? __reqbufs+0x15b/0x334 [videobuf2_core]
   [<ffffffffc05b2647>] ? vb2_thread_stop+0x100/0x146 [videobuf2_core]
   [<ffffffffc05bc0ce>] ? vb2_dvb_stop_feed+0x41/0x58 [videobuf2_dvb]
   [<ffffffffc052b4ea>] ? dvb_dmxdev_filter_start+0x35/0x301 [dvb_core]
   [<ffffffffc052d12f>] ? dmx_section_feed_stop_filtering+0x40/0x7b 
[dvb_core]
   [<ffffffffc052b307>] ? dvb_dmxdev_feed_stop+0x5d/0x89 [dvb_core]
   [<ffffffffc052b60f>] ? dvb_dmxdev_filter_start+0x15a/0x301 [dvb_core]
   [<ffffffffc052bd3f>] ? dvb_demux_do_ioctl+0x1cc/0x4fe [dvb_core]
   [<ffffffffb016973d>] ? path_openat+0x44d/0x55d
   [<ffffffffc052bb73>] ? dvb_dmxdev_ts_callback+0xc2/0xc2 [dvb_core]
   [<ffffffffc052a6b9>] ? dvb_usercopy+0xa7/0x127 [dvb_core]
   [<ffffffffb016a38f>] ? do_filp_open+0x2b/0x6f
   [<ffffffffc052aa3f>] ? dvb_demux_ioctl+0xd/0x11 [dvb_core]
   [<ffffffffc052aa32>] ? dvb_dvr_ioctl+0x11/0x11 [dvb_core]
   [<ffffffffb016bf68>] ? do_vfs_ioctl+0x360/0x424
   [<ffffffffb0173706>] ? __fd_install+0x15/0x40
   [<ffffffffb015d5a9>] ? do_sys_open+0x1b3/0x1c5
   [<ffffffffb016c05f>] ? SyS_ioctl+0x33/0x58
   [<ffffffffb0646452>] ? system_call_fastpath+0x12/0x17
  ---[ end trace 2f92b32249912b0d ]---

Message appeared right before second message


This messages cause random consequences:
     nothing bad happens
     stop working one front end
     stop working both front ends


Yesterday I did git bisect on Linux media tree (v3.13 - HEAD)
and found that your commit is guilty in the first message.
Unfortunately I can not prove that your commit is guilty
in second message, because I received new message:

[  110.131892] ------------[ cut here ]------------
[  110.132808] kernel BUG at mm/slub.c:1394!
[  110.133722] invalid opcode: 0000 [#1] SMP
[  110.134645] Modules linked in: ipv6 cx24117(O) cx25840(O) 
snd_hda_codec_hdmi cx23885(O) tveeprom(O) cx2341x(O) tda18271(O) 
videobuf2_dvb(O) videobuf2_core(O) dvb_core(O) videobuf2_dma_sg(O) 
videobuf2_memops(O) rc_core(O) v4l2_common(O) videodev(O) microcode 
k10temp snd_hda_intel r8169 snd_hda_codec sp5100_tco mii i2c_piix4 tg3 
ptp pps_core libphy e1000 fuse nfs firewire_core hid_sunplus hid_sony 
hid_samsung hid_pl hid_petalynx hid_gyration usb_storage
[  110.136750] CPU: 0 PID: 4055 Comm: w_scan Tainted: G           O 
3.13.10-myrc08 #1
[  110.137749] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./M5A97 LE R2.0, BIOS 2501 04/09/2014
[  110.138737] task: ffff880232535cc0 ti: ffff8800b910c000 task.ti: 
ffff8800b910c000
[  110.139734] RIP: 0010:[<ffffffff810dbe47>] [<ffffffff810dbe47>] 
new_slab+0x8/0x1d3
[  110.140758] RSP: 0018:ffff8800b910daa0  EFLAGS: 00010002
[  110.141774] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
0000000000000004
[  110.142808] RDX: 00000000ffffffff RSI: 0000000000000004 RDI: 
ffff880236801cc0
[  110.143826] RBP: ffff8800b910db30 R08: 0000000000000000 R09: 
0000000000000001
[  110.144850] R10: 0000000000000000 R11: 0000000000003c83 R12: 
ffff880236801cc0
[  110.145890] R13: 0000000000000292 R14: 0000000000000000 R15: 
ffff88023fc14740
[  110.146947] FS:  00007f828c667700(0000) GS:ffff88023fc00000(0000) 
knlGS:0000000000000000
[  110.148003] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  110.149068] CR2: 00000000007d5278 CR3: 00000000b90f2000 CR4: 
00000000000007f0
[  110.150110] Stack:
[  110.151189]  ffffffff816daad5 000000013fc11a80 ffffffff812a64ac 
0000000400000000
[  110.152262]  ffffffff816da71b ffffffff81ca5a40 00000000000082d4 
0000000100800080
[  110.153378]  0000000000000004 0000000000000000 ffffffff81ca6d00 
0000000000000001
[  110.154452] Call Trace:
[  110.155526]  [<ffffffff816daad5>] ? __slab_alloc.constprop.69+0x199/0x296
[  110.156628]  [<ffffffff812a64ac>] ? __sg_alloc_table+0x66/0x126
[  110.157685]  [<ffffffff816da71b>] ? get_partial_node.isra.50+0x126/0x15b
[  110.158771]  [<ffffffff810b6443>] ? __alloc_pages_nodemask+0xf1/0x7a6
[  110.159868]  [<ffffffff812a64ac>] ? __sg_alloc_table+0x66/0x126
[  110.160957]  [<ffffffff810dcf3d>] ? __kmalloc+0x86/0xd5
[  110.162056]  [<ffffffff812a64ac>] ? __sg_alloc_table+0x66/0x126
[  110.163125]  [<ffffffff812a6581>] ? sg_kfree+0x15/0x15
[  110.164206]  [<ffffffff812a6708>] ? sg_alloc_table+0x18/0x3b
[  110.165295]  [<ffffffff812a6796>] ? sg_alloc_table_from_pages+0x6b/0x139
[  110.166405]  [<ffffffffa0182599>] ? vb2_dma_sg_alloc+0x178/0x1ee 
[videobuf2_dma_sg]
[  110.167493]  [<ffffffffa019e97f>] ? __vb2_queue_alloc+0xfb/0x33e 
[videobuf2_core]
[  110.168599]  [<ffffffffa01a0fa3>] ? __reqbufs+0x151/0x244 
[videobuf2_core]
[  110.169717]  [<ffffffffa01a12b8>] ? __vb2_init_fileio+0xea/0x250 
[videobuf2_core]
[  110.170794]  [<ffffffffa01ab157>] ? vb2_dvb_start_feed+0x7a/0x7a 
[videobuf2_dvb]
[  110.171921]  [<ffffffffa01a1eb0>] ? vb2_thread_start+0xa8/0x14c 
[videobuf2_core]
[  110.173042]  [<ffffffffa01ab12b>] ? vb2_dvb_start_feed+0x4e/0x7a 
[videobuf2_dvb]
[  110.174143]  [<ffffffffa01897cb>] ? 
dmx_section_feed_start_filtering+0xe9/0x13c [dvb_core]
[  110.175257]  [<ffffffffa0187615>] ? 
dvb_dmxdev_filter_start+0x226/0x301 [dvb_core]
[  110.176348]  [<ffffffffa0187c51>] ? dvb_demux_do_ioctl+0x1cc/0x4d8 
[dvb_core]
[  110.177486]  [<ffffffffa0187a85>] ? dvb_dmxdev_ts_callback+0xbb/0xbb 
[dvb_core]
[  110.178599]  [<ffffffffa018664e>] ? dvb_usercopy+0x94/0xfc [dvb_core]
[  110.179727]  [<ffffffffa01869b2>] ? dvb_demux_ioctl+0xc/0xf [dvb_core]
[  110.180866]  [<ffffffff810f3ac8>] ? do_vfs_ioctl+0x34f/0x41a
[  110.181971]  [<ffffffff810fb19a>] ? __fd_install+0x15/0x39
[  110.183085]  [<ffffffff810f3bcc>] ? SyS_ioctl+0x39/0x5e
[  110.184228]  [<ffffffff816e4822>] ? system_call_fastpath+0x16/0x1b
[  110.185323] Code: 43 0a 01 74 0b 48 89 ee 48 89 df e8 19 ff ff ff 48 
8b 43 48 48 85 c0 74 07 5b 48 89 ef 5d ff e0 5b 5d c3 f7 c6 06 00 00 fe 
74 02 <0f> 0b 41 56 23 35 77 f5 bc 00 41 55 41 54 81 e6 f0 3e 07 00 40
[  110.186796] RIP  [<ffffffff810dbe47>] new_slab+0x8/0x1d3
[  110.187983]  RSP <ffff8800b910daa0>
[  110.189218] ---[ end trace a037bdc618b75d87 ]---

which appeared much faster and often locked computer.
But I can prove that second message appeared at OR
after your commit.


How to reproduce bug(s):
requirements:
      computer with IOMMU (IMHO only third message can be obtained on 
system without IOMMU)
      digital TV/Sat card based on cx23885 (preferably with multiple 
front-ends)
      kernel >= 3.17 or driver from linux-media tree

reproducing bug(s): just run scan on all front-ends simultaneously (for 
example with w_scan)
                                 and wait. It take 5-15 minutes to hit bug


Thank you.

Raimonds Cicans







