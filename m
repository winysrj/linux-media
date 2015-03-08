Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:46941 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbbCHRV3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Mar 2015 13:21:29 -0400
Received: by oiav63 with SMTP id v63so25555468oia.13
        for <linux-media@vger.kernel.org>; Sun, 08 Mar 2015 10:21:28 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 8 Mar 2015 13:21:28 -0400
Message-ID: <CADzA9onE2YOWzMQ9yN-5oj9h1j+QT7VkwnBT9qi-ZioHAjnJ1w@mail.gmail.com>
Subject: cx23885: Missing device_caps
From: Joseph Yasi <joe.yasi@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I started getting a warning in the kernel log when initializing a
Hauppauge HVR-1800 after I upgraded from 3.18.9 to 3.19.1. It is
triggering this warning:
WARN_ON(!(cap->capabilities & V4L2_CAP_DEVICE_CAPS) ||
                !cap->device_caps);
It looks like drivers/media/pci/cx23885/cx23885-417.c for the MPEG2
encoder doesn't set device_caps or V4L2_CAP_DEVICE_CAPS on
capabilities in vidioc_querycap. Any idea what these should be set to?

Thanks,
Joe

Mar  8 11:51:31 conky kernel: [   10.387440] cx23885[0]: registered
device video0 [v4l2]
Mar  8 11:51:31 conky kernel: [   10.387935] cx23885[0]: registered device vbi0
Mar  8 11:51:31 conky kernel: [   10.392058] cx23885[0]: registered
ALSA audio device
Mar  8 11:51:31 conky kernel: [   10.392675] cx23885[0]: registered
device video1 [mpeg]
Mar  8 11:51:31 conky kernel: [   10.392711] Firmware and/or mailbox
pointer not initialized or corrupted, signature = 0xa7effff7, cmd =
PING_FW
Mar  8 11:51:36 conky kernel: [   14.723356] cx23885_dvb_register()
allocating 1 frontend(s)
Mar  8 11:51:36 conky kernel: [   14.723366] cx23885[0]: cx23885 based dvb card
Mar  8 11:51:36 conky kernel: [   14.768506] MT2131: successfully
identified at address 0x61
Mar  8 11:51:36 conky kernel: [   14.770336] DVB: registering new
adapter (cx23885[0])
Mar  8 11:51:36 conky kernel: [   14.770354] cx23885 0000:01:00.0:
DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB
Frontend)...
Mar  8 11:51:36 conky kernel: [   14.771521]
cx23885_dev_checkrevision() Hardware revision = 0xb1
Mar  8 11:51:36 conky kernel: [   14.771535] cx23885[0]/0: found at
0000:01:00.0, rev: 15, irq: 16, latency: 0, mmio: 0xdb200000
Mar  8 11:51:36 conky kernel: [   14.797887] ------------[ cut here
]------------
Mar  8 11:51:36 conky kernel: [   14.797942] WARNING: CPU: 3 PID: 1972
at drivers/media/v4l2-core/v4l2-ioctl.c:1025 v4l_querycap+0x3b/0x70
[videodev]()
Mar  8 11:51:36 conky kernel: [   14.797947] Modules linked in: mt2131
s5h1409 ir_xmp_decoder ir_lirc_codec lirc_dev ir_sharp_decoder
ir_mce_kbd_decoder ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder
tda8290 ir_rc6_decoder ir_rc5_decoder ir_nec_decoder tuner rc_rc6_mce
mceusb cx25840 snd_hda_codec_hdmi ipv6 snd_hda_codec_realtek
snd_hda_codec_generic coretemp hwmon microcode serio_raw bnep
snd_seq_dummy snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep
btusb rfcomm snd_seq_oss ehci_pci ehci_hcd bluetooth lpc_ich cx23885
snd_seq_midi snd_seq_midi_event tveeprom nvidia(PO) altera_ci cx2341x
tda18271 snd_pcm_oss snd_rawmidi snd_mixer_oss snd_pcm arc4
altera_stapl videobuf2_dvb videobuf2_core videobuf2_dma_sg
videobuf2_memops dvb_core rc_core iwldvm snd_seq v4l2_common mac80211
snd_seq_device videodev video snd_timer xhci_pci media iwlwifi
xhci_hcd cfg80211 drm rfkill agpgart snd soundcore nfsd auth_rpcgss
oid_registry nfs_acl nfs lockd grace sunrpc fscache btrfs xor raid6_pq
sg r8169 mii uhci_hcd
Mar  8 11:51:36 conky kernel: [   14.798055] CPU: 3 PID: 1972 Comm:
v4l_id Tainted: P           O   3.19.1-customatom #1
Mar  8 11:51:36 conky kernel: [   14.798059] Hardware name:
Motherboard by ZOTAC Motherboard D2700ITXS-A-E/D2700ITXS-A-E, BIOS
A212P010 09/21/2012
Mar  8 11:51:36 conky kernel: [   14.798063]  0000000000000000
ffffffffc061a548 ffffffff8151d204 0000000000000000
Mar  8 11:51:36 conky kernel: [   14.798070]  ffffffff81048109
ffff8800caa27dd0 0000000000000000 ffffffffc061c140
Mar  8 11:51:36 conky kernel: [   14.798076]  0000000000000000
ffff880036311498 ffffffffc0606b8b ffff8800caa27e58
Mar  8 11:51:36 conky kernel: [   14.798082] Call Trace:
Mar  8 11:51:36 conky kernel: [   14.798095]  [<ffffffff8151d204>] ?
dump_stack+0x40/0x50
Mar  8 11:51:36 conky kernel: [   14.798103]  [<ffffffff81048109>] ?
warn_slowpath_common+0x79/0xb0
Mar  8 11:51:36 conky kernel: [   14.798119]  [<ffffffffc0606b8b>] ?
v4l_querycap+0x3b/0x70 [videodev]
Mar  8 11:51:36 conky kernel: [   14.798133]  [<ffffffffc0606e35>] ?
__video_do_ioctl+0x275/0x2f0 [videodev]
Mar  8 11:51:36 conky kernel: [   14.798141]  [<ffffffff810ff25c>] ?
do_read_fault.isra.85+0x1bc/0x2c0
Mar  8 11:51:36 conky kernel: [   14.798155]  [<ffffffffc0606bc0>] ?
v4l_querycap+0x70/0x70 [videodev]
Mar  8 11:51:36 conky kernel: [   14.798169]  [<ffffffffc060944f>] ?
video_usercopy+0x2ff/0x470 [videodev]
Mar  8 11:51:36 conky kernel: [   14.798177]  [<ffffffff81520372>] ?
__mutex_lock_interruptible_slowpath+0x22/0x120
Mar  8 11:51:36 conky kernel: [   14.798191]  [<ffffffffc06036dd>] ?
v4l2_ioctl+0x15d/0x180 [videodev]
Mar  8 11:51:36 conky kernel: [   14.798199]  [<ffffffff81148599>] ?
do_vfs_ioctl+0x2e9/0x4f0
Mar  8 11:51:36 conky kernel: [   14.798206]  [<ffffffff81152125>] ?
__fd_install+0x15/0x50
Mar  8 11:51:36 conky kernel: [   14.798212]  [<ffffffff81148823>] ?
SyS_ioctl+0x83/0xa0
Mar  8 11:51:36 conky kernel: [   14.798219]  [<ffffffff81523d72>] ?
page_fault+0x22/0x30
Mar  8 11:51:36 conky kernel: [   14.798225]  [<ffffffff81522812>] ?
system_call_fastpath+0x12/0x17
Mar  8 11:51:36 conky kernel: [   14.798229] ---[ end trace
a1142e7d6a57d84a ]---
