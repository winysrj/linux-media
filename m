Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:43826 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaG0VQT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 17:16:19 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so6616643wes.0
        for <linux-media@vger.kernel.org>; Sun, 27 Jul 2014 14:16:17 -0700 (PDT)
Message-ID: <53D56C65.3020300@googlemail.com>
Date: Sun, 27 Jul 2014 23:17:25 +0200
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx vb2 warnings
References: <53D283B9.9080204@googlemail.com> <53D2AB04.6010907@xs4all.nl>
In-Reply-To: <53D2AB04.6010907@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 25.07.2014 21:07, schrieb Hans Verkuil:
> On 07/25/2014 06:20 PM, Frank Schäfer wrote:
>> Hi Hans,
>>
>> I'm getting the following warnings with the em28xx driver on streaming stop:
>>
>> [ 7597.346168] WARNING: CPU: 1 PID: 3730 at
>> drivers/media/v4l2-core/videobuf2-core.c:2126
>> __vb2_queue_cancel+0xf5/0x150 [videobuf2_core]()
>> [ 7597.346171] Modules linked in: em28xx_rc snd_usb_audio ov2640
>> soc_camera soc_mediabus em28xx_v4l videobuf2_core videobuf2_vmalloc
>> videobuf2_memops snd_usbmidi_lib snd_rawmidi em28xx xt_pkttype xt_LOG
>> xt_limit bnep af_packet bluetooth ip6t_REJECT xt_tcpudp
>> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw
>> xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns
>> nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
>> xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables
>> rc_hauppauge ir_kbd_i2c arc4 tuner_simple tuner_types rtl8187 mac80211
>> tda9887 fuse tda8290 snd_hda_codec_analog tuner snd_hda_codec_hdmi
>> snd_hda_codec_generic sr_mod cdrom snd_hda_intel snd_hda_controller
>> snd_hda_codec msp3400 snd_hwdep cfg80211 bttv snd_pcm v4l2_common
>> snd_seq ppdev powernow_k8
>> [ 7597.346230]  snd_timer snd_seq_device pcspkr videodev serio_raw snd
>> firewire_ohci firewire_core k8temp rfkill eeprom_93cx6 i2c_nforce2
>> usb_storage videobuf_dma_sg videobuf_core btcx_risc pata_jmicron rc_core
>> usblp soundcore forcedeth crc_itu_t tveeprom ata_generic floppy sata_nv
>> pata_amd asus_atk0110 parport_pc parport button sg dm_mod autofs4 radeon
>> ttm drm_kms_helper drm fan thermal processor thermal_sys i2c_algo_bit
>> scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh_alua scsi_dh
>> [ 7597.346268] CPU: 1 PID: 3730 Comm: qv4l2 Tainted: G        W    
>> 3.16.0-rc6-0.1-desktop+ #18
>> [ 7597.346271] Hardware name: System manufacturer System Product Name [...]
>> [ 7597.346273]  00000000 00000000 e09d9d3c c0780b62 00000000 e09d9d6c
>> c0243359 c091deec
>> [ 7597.346279]  00000001 00000e92 f870a4a4 0000084e f87054e5 f87054e5
>> e6905040 e2f61640
>> [ 7597.346285]  ef85f4c8 e09d9d7c c02433ed 00000009 00000000 e09d9d94
>> f87054e5 e2ef6550
>> [ 7597.346290] Call Trace:
>> [ 7597.346300]  [<c0780b62>] dump_stack+0x48/0x69
>> [ 7597.346305]  [<c0243359>] warn_slowpath_common+0x79/0x90
>> [ 7597.346312]  [<f87054e5>] ? __vb2_queue_cancel+0xf5/0x150
>> [videobuf2_core]
>> [ 7597.346318]  [<f87054e5>] ? __vb2_queue_cancel+0xf5/0x150
>> [videobuf2_core]
>> [ 7597.346322]  [<c02433ed>] warn_slowpath_null+0x1d/0x20
>> [ 7597.346327]  [<f87054e5>] __vb2_queue_cancel+0xf5/0x150 [videobuf2_core]
>> [ 7597.346333]  [<f8706b35>] vb2_internal_streamoff+0x35/0x90
>> [videobuf2_core]
>> [ 7597.346338]  [<c04b7cbb>] ? _copy_from_user+0x3b/0x50
>> [ 7597.346344]  [<f8706bc5>] vb2_streamoff+0x35/0x60 [videobuf2_core]
>> [ 7597.346350]  [<c0699433>] ? __sys_recvmsg+0x43/0x70
>> [ 7597.346356]  [<f8706c27>] vb2_ioctl_streamoff+0x37/0x40 [videobuf2_core]
>> [ 7597.346371]  [<f7c56805>] v4l_streamoff+0x15/0x20 [videodev]
>> [ 7597.346382]  [<f7c5962c>] __video_do_ioctl+0x1fc/0x280 [videodev]
>> [ 7597.346394]  [<f7c5908e>] video_usercopy+0x1ce/0x550 [videodev]
>> [ 7597.346399]  [<c038aac7>] ? fsnotify+0x1e7/0x2b0
>> [ 7597.346410]  [<f7c59422>] video_ioctl2+0x12/0x20 [videodev]
>> [ 7597.346421]  [<f7c59430>] ? video_ioctl2+0x20/0x20 [videodev]
>> [ 7597.346430]  [<f7c55615>] v4l2_ioctl+0xe5/0x120 [videodev]
>> [ 7597.346439]  [<f7c55530>] ? v4l2_open+0xf0/0xf0 [videodev]
>> [ 7597.346443]  [<c03668e2>] do_vfs_ioctl+0x2e2/0x4d0
>> [ 7597.346449]  [<c0356a3c>] ? vfs_write+0x13c/0x1c0
>> [ 7597.346452]  [<c03575df>] ? vfs_writev+0x2f/0x50
>> [ 7597.346455]  [<c0366b28>] SyS_ioctl+0x58/0x80
>> [ 7597.346460]  [<c07870ec>] sysenter_do_call+0x12/0x16
>> [ 7597.346463] ---[ end trace 16421a251cba8f63 ]---
>>
>>
>> There have been quite a few vb2 changes recently.
>> Any idea what's wrong ? Could you take a look at this ?
> What it means is that the driver appears not to have given back all
> buffers to the vb2 core. I do see that this doesn't happen in
> start_streaming if an error occurs there (queued buffers should be
> returned to state DEQUEUED in that case), but stop_streaming seems to
> return it perfectly fine. If in your test case start_streaming failed,
> then that would explain it.

No, streaming start doesn't fail.
The test case is simple: start qv4l2, start streaming, stop streaming.


> Enable the VIDEO_ADV_DEBUG config option which will dump an overview of
> the vb2 ops: mismatched counts should be reported.

I also enabled em28xx core_debug:

...
[  165.248346] usbcore: registered new interface driver em28xx
[  170.832072] usb 1-8: new high-speed USB device number 7 using ehci-pci
[  170.950968] usb 1-8: New USB device found, idVendor=2040, idProduct=4200
[  170.950974] usb 1-8: New USB device strings: Mfr=0, Product=1,
SerialNumber=2
[  170.950976] usb 1-8: Product: WinTV USB2
[  170.950979] usb 1-8: SerialNumber: 0000000000
[  170.952094] em28xx: New device  WinTV USB2 @ 480 Mbps (2040:4200,
interface 0, class 0)
[  170.952098] em28xx: Video interface 0 found: bulk isoc
[  170.952212] em28xx: chip ID is em2840
[  171.048588] em2840 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x8e8a4a62
[  171.048593] em2840 #0: EEPROM info:
[  171.048595] em2840 #0:       I2S audio, sample rate=32k
[  171.048596] em2840 #0:       500mA max power
[  171.048598] em2840 #0:       Table at offset 0x24, strings=0x1882,
0x186a, 0x0000
[  171.048600] em2840 #0: Identified as Hauppauge WinTV USB 2 (card=4)
[  171.064236] tveeprom 10-0050: Hauppauge model 42014, rev D197,
serial# 8701574
[  171.064241] tveeprom 10-0050: tuner model is TCL 2002MB_3H (idx 97,
type 55)
[  171.064244] tveeprom 10-0050: TV standards PAL(B/G) PAL(D/D1/K)
(eeprom 0x44)
[  171.064246] tveeprom 10-0050: audio processor is MSP3415 (idx 6)
[  171.064247] tveeprom 10-0050: has radio
[  171.064250] em2840 #0: analog set to isoc mode.
[  171.085149] em2840 #0: Registering V4L2 extension
[  171.172093] msp3400 10-0044: MSP3415G-B8 found @ 0x88 (em2840 #0)
[  171.172098] msp3400 10-0044: msp3400 supports nicam and radio, mode
is autodetect and autoselect
[  171.219586] tvp5150 10-005c: chip found @ 0xb8 (em2840 #0)
[  171.219591] tvp5150 10-005c: tvp5150am1 detected.
[  171.291971] tuner 10-0063: Tuner -1 found with type(s) Radio TV.
[  171.293209] tuner-simple 10-0063: creating new instance
[  171.293214] tuner-simple 10-0063: type set to 55 (TCL 2002MB)
[  172.883164] em2840 #0: V4L2 video device registered as video1
[  172.883171] em2840 #0: V4L2 extension successfully initialized
[  172.883173] em28xx: Registered (Em28xx v4l2 Extension) extension
[  172.891837] em2840 #0: Registering input extension
[  172.891848] Registered IR keymap rc-hauppauge
[  172.895911] input: em28xx IR (em2840 #0) as
/devices/pci0000:00/0000:00:02.1/usb1/1-8/rc/rc1/input17
[  172.898121] rc1: em28xx IR (em2840 #0) as
/devices/pci0000:00/0000:00:02.1/usb1/1-8/rc/rc1
[  172.898126] em2840 #0: Input extension successfully initalized
[  172.898129] em28xx: Registered (Em28xx Input Extension) extension
[  188.609360] em2840 #0 em28xx_init_usb_xfer :em28xx: called
em28xx_init_usb_xfer in mode 1
[  188.609371] em2840 #0 em28xx_alloc_urbs :em28xx: called
em28xx_alloc_isoc in mode 1
[  188.609376] em2840 #0 em28xx_uninit_usb_xfer :em28xx: called
em28xx_uninit_usb_xfer in mode 1
[  191.772707] em2840 #0 em28xx_uninit_usb_xfer :em28xx: called
em28xx_uninit_usb_xfer in mode 1
[  191.827705] ------------[ cut here ]------------
[  191.827720] WARNING: CPU: 1 PID: 2802 at
drivers/media/v4l2-core/videobuf2-core.c:2126
__vb2_queue_cancel+0x180/0x220 [videobuf2_core]()
[  191.827722] Modules linked in: em28xx_rc em28xx_v4l em28xx tvp5150
videobuf2_core videobuf2_vmalloc videobuf2_memops snd_usb_audio
snd_usbmidi_lib snd_rawmidi xt_pkttype xt_LOG xt_limit bnep bluetooth
af_packet ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter ip6table_mangle
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4
nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter
ip6_tables x_tables fuse arc4 rtl8187 mac80211 snd_hda_codec_analog
snd_hda_codec_generic rc_hauppauge ir_kbd_i2c sr_mod cdrom
snd_hda_codec_hdmi tuner_simple tuner_types tda9887 snd_hda_intel
tda8290 tuner cfg80211 msp3400 ppdev snd_hda_controller rfkill
eeprom_93cx6 snd_hda_codec bttv powernow_k8 firewire_ohci firewire_core
serio_raw
[  191.827759]  pcspkr k8temp usb_storage usblp pata_jmicron v4l2_common
snd_hwdep snd_pcm snd_seq videodev videobuf_dma_sg crc_itu_t
videobuf_core snd_timer btcx_risc snd_seq_device ata_generic snd
forcedeth sata_nv pata_amd rc_core tveeprom i2c_nforce2 soundcore
asus_atk0110 floppy parport_pc parport button sg dm_mod autofs4 radeon
ttm drm_kms_helper drm processor thermal fan thermal_sys i2c_algo_bit
scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh_alua scsi_dh [last
unloaded: em28xx]
[  191.827788] CPU: 1 PID: 2802 Comm: qv4l2 Not tainted
3.16.0-rc6-0.1-desktop+ #2
[  191.827790] Hardware name: System manufacturer System Product Name [...]
[  191.827792]  00000000 00000000 e73efd24 c0780b62 00000000 e73efd54
c0243359 c091deec
[  191.827796]  00000001 00000af2 f8c72a08 0000084e f8c6d4e0 f8c6d4e0
e0137f40 e52fe8c8
[  191.827800]  00000001 e73efd64 c02433ed 00000009 00000000 e73efd94
f8c6d4e0 000000c3
[  191.827805] Call Trace:
[  191.827811]  [<c0780b62>] dump_stack+0x48/0x69
[  191.827821]  [<c0243359>] warn_slowpath_common+0x79/0x90
[  191.827826]  [<f8c6d4e0>] ? __vb2_queue_cancel+0x180/0x220
[videobuf2_core]
[  191.827831]  [<f8c6d4e0>] ? __vb2_queue_cancel+0x180/0x220
[videobuf2_core]
[  191.827834]  [<c02433ed>] warn_slowpath_null+0x1d/0x20
[  191.827838]  [<f8c6d4e0>] __vb2_queue_cancel+0x180/0x220 [videobuf2_core]
[  191.827842]  [<c026e9e0>] ? wake_up_state+0x10/0x10
[  191.827846]  [<f8c6ddc5>] vb2_internal_streamoff+0x35/0x90
[videobuf2_core]
[  191.827850]  [<c04b7cbb>] ? _copy_from_user+0x3b/0x50
[  191.827854]  [<f8c6de55>] vb2_streamoff+0x35/0x60 [videobuf2_core]
[  191.827859]  [<c0699433>] ? __sys_recvmsg+0x43/0x70
[  191.827863]  [<f8c6deb7>] vb2_ioctl_streamoff+0x37/0x40 [videobuf2_core]
[  191.827876]  [<f83aa815>] v4l_streamoff+0x15/0x20 [videodev]
[  191.827885]  [<f83ad92c>] __video_do_ioctl+0x1fc/0x280 [videodev]
[  191.827894]  [<f83ad38e>] video_usercopy+0x1ce/0x550 [videodev]
[  191.827899]  [<c038aac7>] ? fsnotify+0x1e7/0x2b0
[  191.827907]  [<f83ad722>] video_ioctl2+0x12/0x20 [videodev]
[  191.827915]  [<f83ad730>] ? video_ioctl2+0x20/0x20 [videodev]
[  191.827922]  [<f83a9615>] v4l2_ioctl+0xe5/0x120 [videodev]
[  191.827930]  [<f83a9530>] ? v4l2_open+0xf0/0xf0 [videodev]
[  191.827933]  [<c03668e2>] do_vfs_ioctl+0x2e2/0x4d0
[  191.827937]  [<c0356a3c>] ? vfs_write+0x13c/0x1c0
[  191.827939]  [<c03575df>] ? vfs_writev+0x2f/0x50
[  191.827942]  [<c0366b28>] SyS_ioctl+0x58/0x80
[  191.827945]  [<c07870ec>] sysenter_do_call+0x12/0x16
[  191.827948] ---[ end trace f29e276818570702 ]---

Regards,
Frank

>
> I'm not sure if I can test this this weekend: I have two em28xx devices,
> one is at work, the other is a Hauppauge 930C, but the analog support for
> that one is missing in the driver (even though it still creates a video
> node!).
>
> It will probably be Tuesday evening before I can test.
>
> Regards,
>
> 	Hans

