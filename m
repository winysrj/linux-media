Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64813 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbaGYQTF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 12:19:05 -0400
Received: by mail-wg0-f48.google.com with SMTP id x13so4454474wgg.19
        for <linux-media@vger.kernel.org>; Fri, 25 Jul 2014 09:19:03 -0700 (PDT)
Message-ID: <53D283B9.9080204@googlemail.com>
Date: Fri, 25 Jul 2014 18:20:09 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: em28xx vb2 warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I'm getting the following warnings with the em28xx driver on streaming stop:

[ 7597.346168] WARNING: CPU: 1 PID: 3730 at
drivers/media/v4l2-core/videobuf2-core.c:2126
__vb2_queue_cancel+0xf5/0x150 [videobuf2_core]()
[ 7597.346171] Modules linked in: em28xx_rc snd_usb_audio ov2640
soc_camera soc_mediabus em28xx_v4l videobuf2_core videobuf2_vmalloc
videobuf2_memops snd_usbmidi_lib snd_rawmidi em28xx xt_pkttype xt_LOG
xt_limit bnep af_packet bluetooth ip6t_REJECT xt_tcpudp
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw
xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables
rc_hauppauge ir_kbd_i2c arc4 tuner_simple tuner_types rtl8187 mac80211
tda9887 fuse tda8290 snd_hda_codec_analog tuner snd_hda_codec_hdmi
snd_hda_codec_generic sr_mod cdrom snd_hda_intel snd_hda_controller
snd_hda_codec msp3400 snd_hwdep cfg80211 bttv snd_pcm v4l2_common
snd_seq ppdev powernow_k8
[ 7597.346230]  snd_timer snd_seq_device pcspkr videodev serio_raw snd
firewire_ohci firewire_core k8temp rfkill eeprom_93cx6 i2c_nforce2
usb_storage videobuf_dma_sg videobuf_core btcx_risc pata_jmicron rc_core
usblp soundcore forcedeth crc_itu_t tveeprom ata_generic floppy sata_nv
pata_amd asus_atk0110 parport_pc parport button sg dm_mod autofs4 radeon
ttm drm_kms_helper drm fan thermal processor thermal_sys i2c_algo_bit
scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh_alua scsi_dh
[ 7597.346268] CPU: 1 PID: 3730 Comm: qv4l2 Tainted: G        W    
3.16.0-rc6-0.1-desktop+ #18
[ 7597.346271] Hardware name: System manufacturer System Product Name [...]
[ 7597.346273]  00000000 00000000 e09d9d3c c0780b62 00000000 e09d9d6c
c0243359 c091deec
[ 7597.346279]  00000001 00000e92 f870a4a4 0000084e f87054e5 f87054e5
e6905040 e2f61640
[ 7597.346285]  ef85f4c8 e09d9d7c c02433ed 00000009 00000000 e09d9d94
f87054e5 e2ef6550
[ 7597.346290] Call Trace:
[ 7597.346300]  [<c0780b62>] dump_stack+0x48/0x69
[ 7597.346305]  [<c0243359>] warn_slowpath_common+0x79/0x90
[ 7597.346312]  [<f87054e5>] ? __vb2_queue_cancel+0xf5/0x150
[videobuf2_core]
[ 7597.346318]  [<f87054e5>] ? __vb2_queue_cancel+0xf5/0x150
[videobuf2_core]
[ 7597.346322]  [<c02433ed>] warn_slowpath_null+0x1d/0x20
[ 7597.346327]  [<f87054e5>] __vb2_queue_cancel+0xf5/0x150 [videobuf2_core]
[ 7597.346333]  [<f8706b35>] vb2_internal_streamoff+0x35/0x90
[videobuf2_core]
[ 7597.346338]  [<c04b7cbb>] ? _copy_from_user+0x3b/0x50
[ 7597.346344]  [<f8706bc5>] vb2_streamoff+0x35/0x60 [videobuf2_core]
[ 7597.346350]  [<c0699433>] ? __sys_recvmsg+0x43/0x70
[ 7597.346356]  [<f8706c27>] vb2_ioctl_streamoff+0x37/0x40 [videobuf2_core]
[ 7597.346371]  [<f7c56805>] v4l_streamoff+0x15/0x20 [videodev]
[ 7597.346382]  [<f7c5962c>] __video_do_ioctl+0x1fc/0x280 [videodev]
[ 7597.346394]  [<f7c5908e>] video_usercopy+0x1ce/0x550 [videodev]
[ 7597.346399]  [<c038aac7>] ? fsnotify+0x1e7/0x2b0
[ 7597.346410]  [<f7c59422>] video_ioctl2+0x12/0x20 [videodev]
[ 7597.346421]  [<f7c59430>] ? video_ioctl2+0x20/0x20 [videodev]
[ 7597.346430]  [<f7c55615>] v4l2_ioctl+0xe5/0x120 [videodev]
[ 7597.346439]  [<f7c55530>] ? v4l2_open+0xf0/0xf0 [videodev]
[ 7597.346443]  [<c03668e2>] do_vfs_ioctl+0x2e2/0x4d0
[ 7597.346449]  [<c0356a3c>] ? vfs_write+0x13c/0x1c0
[ 7597.346452]  [<c03575df>] ? vfs_writev+0x2f/0x50
[ 7597.346455]  [<c0366b28>] SyS_ioctl+0x58/0x80
[ 7597.346460]  [<c07870ec>] sysenter_do_call+0x12/0x16
[ 7597.346463] ---[ end trace 16421a251cba8f63 ]---


There have been quite a few vb2 changes recently.
Any idea what's wrong ? Could you take a look at this ?

Regards,
Frank





