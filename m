Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.cooptel.qc.ca ([216.144.115.12]:58967 "EHLO
	amy.cooptel.qc.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751952Ab0BIEtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2010 23:49:49 -0500
Message-ID: <4B70E7DB.7060101@cooptel.qc.ca>
Date: Mon, 08 Feb 2010 23:43:07 -0500
From: Richard Lemieux <rlemieu@cooptel.qc.ca>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Driver crash on kernel 2.6.32.7.  Interaction between cx8800 (DVB-S)
 and USB HVR Hauppauge 950q
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I got some driver crashes after upgrading to kernel 2.6.32.7.  It seems that
activating either TBS8920 (DVB-S) and HVR950Q (ATSC) after the other one has
run (and is no longer in use by an application) triggers a driver crash.

Each device individually works fine (as long as the other one does not run).

I don't know how to investigate this by myself, but I am available to help.
This is not critical.  The system is otherwise stable.

Here is the last event recorded in syslog.  I activated the DVBS after
turning off applications running ATSC.

Feb  8 16:18:16 pc3 kernel: DVB: registering adapter 1 frontend 0 (Auvitek 
AU8522 QAM/8VSB Frontend)...
Feb  8 21:37:17 pc3 kernel: cx88[0]/0: unknown tv audio mode [0]
Feb  8 23:00:45 pc3 kernel: cx88[0]/0: unknown tv audio mode [0]
Feb  8 23:01:24 pc3 last message repeated 2 times
Feb  8 23:04:00 pc3 kernel: BUG: unable to handle kernel NULL pointer 
dereference at 00000004
Feb  8 23:04:00 pc3 kernel: IP: [<c11ae628>] firmware_loading_store+0x68/0x1a0
Feb  8 23:04:00 pc3 kernel: *pdpt = 000000003650e001 *pde = 0000000000000000
Feb  8 23:04:00 pc3 kernel: Oops: 0000 [#1] SMP
Feb  8 23:04:00 pc3 kernel: last sysfs file: 
/sys/class/firmware/0000:08:00.0/loading
Feb  8 23:04:00 pc3 kernel: Modules linked in: xc5000 tuner au8522 au0828 
videobuf_vmalloc snd_seq rtc hid_logitech ext4 jbd2 crc16 nls_iso8859_1 
nls_cp437 bsd_comp ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc 
parport_pc lp parport joydev usb_storage usblp snd_usb_audio snd_usb_lib 
snd_rawmidi snd_seq_device usbhid snd_hwdep cx24116 cx88_dvb cx88_vp3054_i2c 
videobuf_dvb dvb_core snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_pcm_oss cx8802 snd_mixer_oss cx8800 cx88xx snd_pcm ir_common i2c_i801 
i2c_algo_bit v4l2_common snd_timer tveeprom ohci1394 sky2 ehci_hcd snd videodev 
v4l1_compat videobuf_dma_sg btcx_risc ieee1394 8250_pnp 8250 serial_core 
uhci_hcd bitrev nvidia(P) crc32 agpgart videobuf_core soundcore snd_page_alloc 
i2c_core usbcore sg evdev
Feb  8 23:04:00 pc3 kernel:
Feb  8 23:04:00 pc3 kernel: Pid: 6390, comm: firmware.agent Tainted: P 
  (2.6.32.7 #1) P5E WS Pro
Feb  8 23:04:00 pc3 kernel: EIP: 0060:[<c11ae628>] EFLAGS: 00010296 CPU: 1
Feb  8 23:04:00 pc3 kernel: EIP is at firmware_loading_store+0x68/0x1a0
Feb  8 23:04:00 pc3 kernel: EAX: 00000000 EBX: f66a1140 ECX: 00000002 EDX: 2f1dc161
Feb  8 23:04:00 pc3 kernel: ESI: f7513440 EDI: f05b8380 EBP: 00000002 ESP: f0c15f1c
Feb  8 23:04:00 pc3 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb  8 23:04:00 pc3 kernel: Process firmware.agent (pid: 6390, ti=f0c14000 
task=f6e65850 task.ti=f0c14000)
Feb  8 23:04:00 pc3 kernel: Stack:
Feb  8 23:04:00 pc3 kernel:  00000161 80000000 0810b408 c430ed60 c10713d2 
c11ae5c0 00000002 c13ab7c0
Feb  8 23:04:00 pc3 kernel: <0> 00000002 c11a6965 00000002 f66dc940 f75242f8 
c10cc0d9 00000002 0810b408
Feb  8 23:04:00 pc3 kernel: <0> f66dc954 f7513448 f0c6cac0 00000002 0810b408 
c10cc040 c1086ff0 f0c15f9c
Feb  8 23:04:00 pc3 kernel: Call Trace:
Feb  8 23:04:00 pc3 kernel:  [<c10713d2>] ? handle_mm_fault+0x612/0x9f0
Feb  8 23:04:00 pc3 kernel:  [<c11ae5c0>] ? firmware_loading_store+0x0/0x1a0
Feb  8 23:04:00 pc3 kernel:  [<c11a6965>] ? dev_attr_store+0x25/0x40
Feb  8 23:04:00 pc3 kernel:  [<c10cc0d9>] ? sysfs_write_file+0x99/0x100
Feb  8 23:04:00 pc3 kernel:  [<c10cc040>] ? sysfs_write_file+0x0/0x100
Feb  8 23:04:00 pc3 kernel:  [<c1086ff0>] ? vfs_write+0xa0/0x160
Feb  8 23:04:00 pc3 kernel:  [<c1087171>] ? sys_write+0x41/0x70
Feb  8 23:04:00 pc3 kernel:  [<c1002e08>] ? sysenter_do_call+0x12/0x26
Feb  8 23:04:00 pc3 kernel: Code: 04 e8 dd c8 ec ff 8b 53 40 31 c9 8b 43 3c 8b 
7b 34 c7 04 24 61 01 00 00 c7 44 24 04 00 00 00 80 e8 8e cf ec ff 89 47 04 8b 43 
34 <8b> 78 04 85 ff 0f 84 f4 00 00 00 c7 43 44 00 00 00 00 8d 43 04
Feb  8 23:04:00 pc3 kernel: EIP: [<c11ae628>] firmware_loading_store+0x68/0x1a0 
SS:ESP 0068:f0c15f1c
Feb  8 23:04:00 pc3 kernel: CR2: 0000000000000004
Feb  8 23:04:00 pc3 kernel: ---[ end trace c07258db2013e403 ]---


Here is another event.  I booted in between.  The system is stable otherwise.


Feb  7 14:15:06 pc3 kernel: DVB: registering adapter 1 frontend 0 (Auvitek
AU8522 QAM/8VSB Frontend)...
Feb  7 14:15:30 pc3 udevd-event[15971]: run_program: '/lib/udev/firmware.sh'
abnormal exit
Feb  7 14:15:30 pc3 kernel: BUG: unable to handle kernel NULL pointer
dereference at 00000004
Feb  7 14:15:30 pc3 kernel: IP: [<c11ae622>] firmware_loading_store+0x62/0x1a0
Feb  7 14:15:30 pc3 kernel: *pdpt = 0000000036bc4001 *pde = 0000000000000000
Feb  7 14:15:30 pc3 kernel: Oops: 0002 [#1] SMP
Feb  7 14:15:30 pc3 kernel: last sysfs file: /sys/class/firmware/7-4/loading
Feb  7 14:15:30 pc3 kernel: Modules linked in: snd_usb_audio snd_usb_lib
snd_rawmidi snd_hwdep xc5000 tuner au8522 au0828 videobuf_vmalloc nvidia(P)
snd_seq snd_seq_device rtc hid_logitech ext4 jbd2 crc16 nls_iso8859_1 nls_cp437
bsd_comp ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic slhc agpgart
parport_pc lp parport joydev usb_storage usbhid usblp cx24116 cx88_dvb
cx88_vp3054_i2c videobuf_dvb dvb_core snd_hda_codec_realtek snd_hda_intel cx8802
cx8800 snd_hda_codec cx88xx snd_pcm_oss ir_common snd_mixer_oss i2c_algo_bit
ohci1394 v4l2_common tveeprom i2c_i801 snd_pcm 8250_pnp 8250 serial_core
videodev v4l1_compat videobuf_dma_sg i2c_core sky2 videobuf_core ehci_hcd
ieee1394 btcx_risc snd_timer snd bitrev crc32 soundcore snd_page_alloc uhci_hcd
usbcore sg evdev [last unloaded: nvidia]
Feb  7 14:15:30 pc3 kernel:
Feb  7 14:15:30 pc3 kernel: Pid: 15972, comm: firmware.sh Tainted: P
(2.6.32.7 #1) P5E WS Pro
Feb  7 14:15:30 pc3 kernel: EIP: 0060:[<c11ae622>] EFLAGS: 00010296 CPU: 1
Feb  7 14:15:30 pc3 kernel: EIP is at firmware_loading_store+0x62/0x1a0
Feb  7 14:15:30 pc3 kernel: EAX: 00000000 EBX: f2428ac0 ECX: 00000000 EDX: e19bc000
Feb  7 14:15:30 pc3 kernel: ESI: ed92fe00 EDI: 00000000 EBP: 00000002 ESP: e19bdf1c
Feb  7 14:15:30 pc3 kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Feb  7 14:15:30 pc3 kernel: Process firmware.sh (pid: 15972, ti=e19bc000
task=f6fa2760 task.ti=e19bc000)
Feb  7 14:15:30 pc3 kernel: Stack:
Feb  7 14:15:30 pc3 kernel:  00000161 80000000 0810b408 c4ff6dc0 c10713d2
c11ae5c0 00000002 c13ab7c0
Feb  7 14:15:30 pc3 kernel: <0> 00000002 c11a6965 00000002 f3f387c0 f147d744
c10cc0d9 00000002 0810b408
Feb  7 14:15:30 pc3 kernel: <0> f3f387d4 ed92fe08 ed91d940 00000002 0810b408
c10cc040 c1086ff0 e19bdf9c
Feb  7 14:15:30 pc3 kernel: Call Trace:
Feb  7 14:15:30 pc3 kernel:  [<c10713d2>] ? handle_mm_fault+0x612/0x9f0
Feb  7 14:15:30 pc3 kernel:  [<c11ae5c0>] ? firmware_loading_store+0x0/0x1a0
Feb  7 14:15:30 pc3 kernel:  [<c11a6965>] ? dev_attr_store+0x25/0x40
Feb  7 14:15:30 pc3 kernel:  [<c10cc0d9>] ? sysfs_write_file+0x99/0x100
Feb  7 14:15:30 pc3 kernel:  [<c10cc040>] ? sysfs_write_file+0x0/0x100
Feb  7 14:15:30 pc3 kernel:  [<c1086ff0>] ? vfs_write+0xa0/0x160
Feb  7 14:15:30 pc3 kernel:  [<c1087171>] ? sys_write+0x41/0x70
Feb  7 14:15:30 pc3 kernel:  [<c1002e08>] ? sysenter_do_call+0x12/0x26
Feb  7 14:15:30 pc3 kernel: Code: 62 8b 43 34 8b 40 04 e8 dd c8 ec ff 8b 53 40
31 c9 8b 43 3c 8b 7b 34 c7 04 24 61 01 00 00 c7 44 24 04 00 00 00 80 e8 8e cf ec
ff <89> 47 04 8b 43 34 8b 78 04 85 ff 0f 84 f4 00 00 00 c7 43 44 00
Feb  7 14:15:30 pc3 kernel: EIP: [<c11ae622>] firmware_loading_store+0x62/0x1a0
SS:ESP 0068:e19bdf1c
Feb  7 14:15:30 pc3 kernel: CR2: 0000000000000004
Feb  7 14:15:30 pc3 kernel: ---[ end trace dfa955c34e6458e9 ]---

