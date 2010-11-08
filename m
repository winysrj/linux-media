Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44126 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0KHJ7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Nov 2010 04:59:52 -0500
Received: by iwn41 with SMTP id 41so3892447iwn.19
        for <linux-media@vger.kernel.org>; Mon, 08 Nov 2010 01:59:52 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 8 Nov 2010 17:59:51 +0800
Message-ID: <AANLkTikrdLO3NcNX-WTkf32uTMjWTE8CZ_ReVFXKuvk3@mail.gmail.com>
Subject: [Bug Report]
From: hbomb ustc <hbomb.ustc@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi All

I find a bug when I use the USB TV receiver(WinTV-HVR 950) on kernel
v2.6.37-rc1. The bug appearances when the WinTV-HVR 950 plug out from
the USB interface. The dmesg informations and testing environment are
below here.  The bug never be found before the kernel v2.6.37-rc1. Are
there someone else saw this bug?



==============================================================================

Testing  Environment :

OS:                                       Ubuntu10.04

Kernel:                                  v2.6.37-rc1

SouthBridge/EHCI:                 AMD SB800


==============================================================================

[13578.141708] hub 3-0:1.0: state 7 ports 4 chg 0000 evt 0002

[13578.141776] ehci_hcd 0000:00:16.2: GetStatus port:1 status 001002 0
 ACK POWER sig=se0 CSC

[13578.141799] hub 3-0:1.0: port 1, status 0100, change 0001, 12 Mb/s

[13578.141810] usb 3-1: USB disconnect, address 4

[13578.141818] usb 3-1: unregistering device

[13578.141827] usb 3-1: unregistering interface 3-1:1.0

[13578.142005] em28xx #0: disconnecting em28xx #0 video

[13578.148258] BUG: unable to handle kernel NULL pointer dereference at 00000174

[13578.148273] IP: [<f818b0c2>] ir_close+0x12/0x20 [ir_core]

[13578.148296] *pde = 00000000

[13578.148305] Oops: 0000 [#1] SMP

[13578.148315] last sysfs file:
/sys/devices/pci0000:00/0000:00:16.2/usb3/3-1/sound/card2/uevent

[13578.148326] Modules linked in: lgdt330x em28xx_dvb dvb_core
em28xx_alsa rc_rc5_hauppauge_new tuner_xc2028 tuner tvp5150
ir_lirc_codec lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder
em28xx ir_rc5_decoder v4l2_common ir_nec_decoder videodev v4l1_compat
ir_core videobuf_vmalloc videobuf_core tveeprom nls_iso8859_1
nls_cp437 vfat fat usb_storage snd_usb_audio snd_usbmidi_lib
binfmt_misc ppdev snd_hda_codec_idt snd_hda_codec_hdmi snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
snd_seq snd_timer snd_seq_device snd soundcore i2c_piix4 video
snd_page_alloc output psmouse lp serio_raw parport usbhid hid ahci
libahci tg3

[13578.148462]

[13578.148474] Pid: 22, comm: khubd Not tainted 2.6.37-rc1-alex #13
Inagua/Brazos

[13578.148484] EIP: 0060:[<f818b0c2>] EFLAGS: 00010286 CPU: 0

[13578.148497] EIP is at ir_close+0x12/0x20 [ir_core]

[13578.148505] EAX: 00000000 EBX: f0544008 ECX: 00000000 EDX: f818b0b0

[13578.148514] ESI: efc3a000 EDI: efc3a19c EBP: f49afd80 ESP: f49afd80

[13578.148523]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068

[13578.148533] Process khubd (pid: 22, ti=f49ae000 task=f48abf20
task.ti=f49ae000)

[13578.148539] Stack:

[13578.148544]  f49afd94 c04812c0 f0544028 f054403c f0544008 f49afdb0
c0485458 00000000

[13578.148565]  f0544044 f054405c f0544008 f0544000 f49afdc4 c048548b
efc3a304 efc3a000

[13578.148584]  efc3a2f0 f49afddc c0482c90 f38d9000 f1bc2200 efc3a000
efc3a1b8 f49afdf0

[13578.148603] Call Trace:

[13578.148623]  [<c04812c0>] ? input_close_device+0x50/0x80

[13578.148638]  [<c0485458>] ? evdev_cleanup+0xc8/0xd0

[13578.148650]  [<c048548b>] ? evdev_disconnect+0x2b/0x50

[13578.148662]  [<c0482c90>] ? input_unregister_device+0xb0/0x150

[13578.148678]  [<f818bf25>] ? ir_unregister_class+0x45/0x70 [ir_core]

[13578.148693]  [<f818b069>] ? ir_input_unregister+0x69/0xb0 [ir_core]

[13578.148715]  [<f83f9cfe>] ? em28xx_ir_fini+0x2e/0x50 [em28xx]

[13578.148733]  [<f83f58cb>] ? em28xx_release_resources+0x2b/0x70 [em28xx]

[13578.148751]  [<f83f59a8>] ? em28xx_usb_disconnect+0x98/0x140 [em28xx]

[13578.148766]  [<c045b8d0>] ? usb_unbind_interface+0x40/0x150

[13578.148778]  [<c03ecd91>] ? __device_release_driver+0x51/0xb0

[13578.148788]  [<c03eceb5>] ? device_release_driver+0x25/0x40

[13578.148803]  [<c03ec16b>] ? bus_remove_device+0x7b/0xa0

[13578.148814]  [<c03ea1b7>] ? device_del+0xf7/0x180

[13578.148825]  [<c04584c2>] ? usb_disable_device+0x72/0x1a0

[13578.148838]  [<c04515e6>] ? usb_disconnect+0x96/0x130

[13578.148851]  [<c0452d71>] ? hub_thread+0x4a1/0x11d0

[13578.148863]  [<c0101f22>] ? __switch_to+0xd2/0x190

[13578.148877]  [<c0168440>] ? autoremove_wake_function+0x0/0x50

[13578.148890]  [<c04528d0>] ? hub_thread+0x0/0x11d0

[13578.148900]  [<c0168014>] ? kthread+0x74/0x80

[13578.148911]  [<c0167fa0>] ? kthread+0x0/0x80

[13578.148921]  [<c0103706>] ? kernel_thread_helper+0x6/0x10

[13578.148927] Code: d2 18 f8 c7 04 24 08 d4 18 f8 e8 a8 dc 42 c8 eb
81 90 8d b4 26 00 00 00 00 55 89 e5 3e 8d 74 26 00 05 b8 01 00 00 e8
ee 1b 26 c8 <8b> 90 74 01 00 00 8b 42 20 ff 52 2c 5d c3 55 89 e5 3e 8d
74 26

[13578.149033] EIP: [<f818b0c2>] ir_close+0x12/0x20 [ir_core] SS:ESP
0068:f49afd80

[13578.149050] CR2: 0000000000000174

[13578.149060] ---[ end trace 0c6296eef2304b6c ]---

=================================================================================
