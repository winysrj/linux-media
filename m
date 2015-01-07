Return-path: <linux-media-owner@vger.kernel.org>
Received: from fortimail.online.lv ([81.198.164.220]:53161 "EHLO
	fortimail.online.lv" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbbAGU0r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 15:26:47 -0500
Received: from mailo-proxy1.online.lv (smtp.online.lv [81.198.164.193])
	by fortimail.online.lv  with ESMTP id t07KBgu9018507-t07KBguA018507
	for <linux-media@vger.kernel.org>; Wed, 7 Jan 2015 22:11:42 +0200
Message-ID: <54AD92FE.6020602@apollo.lv>
Date: Wed, 07 Jan 2015 22:11:42 +0200
From: Raimonds Cicans <ray@apollo.lv>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TBS 6981 & IOMMU problems
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

After kernel upgrade 3.13 => 3.19 I started to receive different IOMMU 
related problems:


Problem #1:

AMD-Vi: Event logged [IO_PAGE_FAULT device=08:00.0 domain=0x001c 
address=0x00000000004b5000 flags=0x0000]


Problem #2:

  ------------[ cut here ]------------
  WARNING: CPU: 0 PID: 6588 at drivers/iommu/amd_iommu.c:2637 
dma_ops_domain_unmap.part.12+0x4d/0x56()
  Modules linked in: ip6table_filter ip6_tables act_police cls_basic 
cls_flow cls_fw cls_u32 sch_fq_codel sch_tbf sch_prio sch_htb sch_hfsc 
sch_ingress sch_sfq xt_CHECKSUM ipt_rpfilter xt_statistic xt_CT xt_realm 
xt_addrtype xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4 ipt_ECN 
ipt_CLUSTERIP ipt_ah xt_set nf_nat_ftp xt_time xt_TCPMSS xt_tcpmss 
xt_policy xt_pkttype xt_physdev br_netfilter xt_NFQUEUE xt_NFLOG xt_mark 
xt_mac xt_length xt_helper xt_hashlimit xt_DSCP xt_dscp xt_CLASSIFY 
xt_AUDIT iptable_raw iptable_nat nf_nat_ipv4 nf_nat iptable_mangle 
hwmon_vid bridge stp llc ipv6 cx24117 cx25840 uvcvideo snd_usb_audio 
videobuf2_vmalloc snd_hwdep snd_usbmidi_lib snd_rawmidi 
snd_hda_codec_hdmi ir_xmp_decoder ir_lirc_codec lirc_dev 
ir_mce_kbd_decoder ir_sharp_decoder ir_sanyo_decoder ir_sony_decoder 
ir_jvc_decoder ir_rc6_decoder ir_nec_decoder ir_rc5_decoder rc_rc6_mce 
microcode k10temp mceusb uas usb_storage usblp si2157 si2168 
saa716x_budget saa716x_core sp5100_tco i2c_piix4 nouveau cx23885 
i2c_algo_bit ttm tda18271 altera_stapl videobuf2_dvb videobuf2_core 
videobuf2_dma_sg videobuf2_memops drm_kms_helper tveeprom cx2341x 
dvb_core snd_hda_intel rc_core drm v4l2_common snd_hda_controller 
videodev snd_hda_codec r8169 mii
  CPU: 0 PID: 6588 Comm: w_scan Tainted: G        W 3.19.0-rc3-myrc00 #1
  Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 LE 
R2.0, BIOS 2501 04/09/2014
   0000000000000000 0000000000000009 ffffffffab636bd8 0000000000000000
   ffffffffab0bcd91 ffff880099d4a300 ffffffffab4e282b 0000000000000046
   ffff8800b87ccd88 00000000023b1000 0000000000000001 00000000000001f8
  Call Trace:
   [<ffffffffab636bd8>] ? dump_stack+0x40/0x50
   [<ffffffffab0bcd91>] ? warn_slowpath_common+0x93/0xab
   [<ffffffffab4e282b>] ? dma_ops_domain_unmap.part.12+0x4d/0x56
   [<ffffffffab4e282b>] ? dma_ops_domain_unmap.part.12+0x4d/0x56
   [<ffffffffab4e41d5>] ? __unmap_single.isra.15+0x7b/0xcf
   [<ffffffffab4e4983>] ? free_coherent+0x46/0x7e
   [<ffffffffc046a2e7>] ? __vb2_queue_cancel+0x11b/0x12d [videobuf2_core]
   [<ffffffffc046c0a2>] ? __reqbufs+0xf2/0x29d [videobuf2_core]
   [<ffffffffc046c345>] ? vb2_thread_stop+0x6b/0xb1 [videobuf2_core]
   [<ffffffffc04760ce>] ? vb2_dvb_stop_feed+0x41/0x58 [videobuf2_dvb]
   [<ffffffffab16b1bc>] ? poll_select_copy_remaining+0xf4/0xf4
   [<ffffffffc041e066>] ? dmx_section_feed_stop_filtering+0x40/0x7b 
[dvb_core]
   [<ffffffffc041cb0b>] ? dvb_dmxdev_ts_callback+0xc2/0xc2 [dvb_core]
   [<ffffffffc041c2bb>] ? dvb_dmxdev_feed_stop+0x5d/0x89 [dvb_core]
   [<ffffffffc041cb0b>] ? dvb_dmxdev_ts_callback+0xc2/0xc2 [dvb_core]
   [<ffffffffc041c401>] ? dvb_dmxdev_filter_stop+0x4e/0xb6 [dvb_core]
   [<ffffffffc041cb0b>] ? dvb_dmxdev_ts_callback+0xc2/0xc2 [dvb_core]
   [<ffffffffc041cc29>] ? dvb_demux_do_ioctl+0x11e/0x4d8 [dvb_core]
   [<ffffffffc041cb0b>] ? dvb_dmxdev_ts_callback+0xc2/0xc2 [dvb_core]
   [<ffffffffc041b66d>] ? dvb_usercopy+0xa7/0x127 [dvb_core]
   [<ffffffffc0423797>] ? dvb_ringbuffer_read_user+0x6d/0x8e [dvb_core]
   [<ffffffffc041bf97>] ? dvb_dmxdev_buffer_read.isra.2+0x5c/0x156 
[dvb_core]
   [<ffffffffab0e0c59>] ? __wake_up+0x33/0x44
   [<ffffffffc041b9f3>] ? dvb_demux_ioctl+0xd/0x11 [dvb_core]
   [<ffffffffc041b9e6>] ? dvb_dvr_ioctl+0x11/0x11 [dvb_core]
   [<ffffffffab16a8fb>] ? do_vfs_ioctl+0x360/0x424
   [<ffffffffab0ef6fb>] ? timespec_add_safe+0x1c/0x48
   [<ffffffffab16a9f2>] ? SyS_ioctl+0x33/0x58
   [<ffffffffab63be92>] ? system_call_fastpath+0x12/0x17
  ---[ end trace a7dc5ffa658175f6 ]---


Thoughts about above problems:

Hardware: AMD Athlon(tm) II X2 240e Processor on Asus M5A97 LE R2.0 
motherboard

This bugs cause random consequences:
     nothing bad happens
     stop working one front end
     stop working both front ends

This bugs are easily triggered if I run /w_scan/ on both front ends 
simultaneously

Theoretically it is possible to disable IOMMU but:
     it will just hide problem, not solve it
     some devices on my system do not work without IOMMU

Theoretically it is possible that there is bug in IOMMU code itself, 
because I had IOMMU related regression in kernels 3.14-3.17 which was 
solved in 3.17.7



Raimonds Cicans
