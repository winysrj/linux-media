Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49022 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752974AbZDZMKE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 08:10:04 -0400
Message-ID: <49F44F0D.9020908@gmx.at>
Date: Sun, 26 Apr 2009 14:09:49 +0200
From: Marco Praher <marco.praher@gmx.at>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Terratec Cinergy Hybrid XS FM stopped working with Kernel 2.6.29
Content-Type: multipart/mixed;
 boundary="------------090909010604060906060507"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090909010604060906060507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody!

Since upgrading my kernel to 2.6.29 my Terratec Cinergy Hybrid XS FM 
stopped working. I'm using the em28xx-new driver.Compiling the driver 
works as usual and my stick gets recognized. But if I try to use it 
(e.g. tvtime) it doesn't work. A simple "killed" is the only message i 
get in the console.

I'm using Arch linux x86_64:
Linux user-notebookng 2.6.29-ARCH #1 SMP PREEMPT Fri Apr 17 14:14:28 
CEST 2009 x86_64 Intel(R) Core(TM)2 Duo CPU L9400 @ 1.86GHz GenuineIntel 
GNU/Linux
Attached is the dmesg output.

What's the problem? Is this a known bug/problem?

Thanks for replies
Marco






--------------090909010604060906060507
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

usb 1-5.4: new high speed USB device using ehci_hcd and address 35
usb 1-5.4: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.0.1 loaded
em28xx: new video device (0ccd:0072): interface 0, class 255
em28xx: device is attached to a USB 2.0 bus
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
cx25843.c: starting probe for adapter SMBus I801 adapter at 1c60 (0x0)
cx25843.c: detecting cx25843 client on address 0x88
cx25843.c: starting probe for adapter em28xx #0 (0x1001f)
cx25843.c: detecting cx25843 client on address 0x88
attach_inform: msp34xx/cx25843 detected.
trying to attach xc5000
attaching xc5000 tuner module
successfully attached tuner
radio device registered as /dev/radio0
em28xx #0: V4L2 VBI device registered as /dev/vbi0
em28xx #0: V4L2 device registered as /dev/video0
input: em2880/em2870 remote control as /devices/virtual/input/input41
em28xx-input.c: remote control handler attached
em28xx #0: Found Terratec Hybrid XS FM (em2883)
usbcore: registered new interface driver em28xx
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Em28xx: Initialized (Em28xx Audio Extension) extension
em2880-dvb.c: DVB Init
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffffa05dfd75>] em28xx_v4l2_poll+0x25/0x270 [em28xx]
PGD 12ebea067 PUD 12ad81067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.4/1-5.4:1.0/bInterfaceProtocol
CPU 0 
Modules linked in: em28xx_dvb(+) dvb_core em28xx_audio tuner_xc5000 em28xx_cx25843 em28xx videodev v4l1_compat v4l2_compat_ioctl32 ipv6 aes_x86_64 aes_generic i915 drm i2c_algo_bit cpufreq_ondemand joydev hid_belkin usbhid hid btusb bluetooth snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device arc4 ecb snd_pcm_oss snd_mixer_oss serio_raw iwlagn snd_hda_codec_conexant psmouse iwlcore sg thinkpad_acpi rfkill nvram led_class mac80211 i2c_i801 i2c_core ide_pci_generic ide_core iTCO_wdt iTCO_vendor_support cfg80211 uhci_hcd wmi video output snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc ehci_hcd pata_acpi e1000e usbcore ata_generic intel_agp evdev thermal fan button battery ac vboxdrv acpi_cpufreq freq_table processor rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sd_mod ahci libata scsi_mod
Pid: 7948, comm: hald-probe-vide Not tainted 2.6.29-ARCH #1 7469WA2
RIP: 0010:[<ffffffffa05dfd75>]  [<ffffffffa05dfd75>] em28xx_v4l2_poll+0x25/0x270 [em28xx]
RSP: 0018:ffff88012a6dfd48  EFLAGS: 00010296
RAX: ffffffffa05fb140 RBX: ffff88012aff6800 RCX: 2222222222222222
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88012a6db6c0
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88011ac03300
R10: ffff88012a6dfe68 R11: ffffffff80340630 R12: ffff88012a6db6c0
R13: 0000000000000000 R14: ffff88012eabc180 R15: ffffffff802cebb0
FS:  00007f13853d86f0(0000) GS:ffffffff8067c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000012ad1e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hald-probe-vide (pid: 7948, threadinfo ffff88012a6de000, task ffff88012a480000)
Stack:
 ffff88012aff6898 ffff88012aff6800 ffff88012a6db6c0 ffff88012aff6808
 ffff88012a6db6c0 ffffffffa05d0991 0000000000000000 ffff88012eabc180
 ffff88010597c738 ffffffff802cecf5 ffff88012a6db6c0 000000001ac03300
Call Trace:
 [<ffffffffa05d0991>] v4l2_open+0x91/0xb0 [videodev]
 [<ffffffff802cecf5>] chrdev_open+0x145/0x250
 [<ffffffff802c9761>] __dentry_open+0x131/0x360
 [<ffffffff802d9103>] do_filp_open+0x233/0x9c0
 [<ffffffff80492c43>] unix_stream_connect+0x473/0x4a0
 [<ffffffff804b3755>] _spin_unlock_irq+0x5/0x40
 [<ffffffff804b3835>] _spin_unlock+0x5/0x30
 [<ffffffff802e38a2>] alloc_fd+0x122/0x150
 [<ffffffff802c9560>] do_sys_open+0x80/0x110
 [<ffffffff8020c6aa>] system_call_fastpath+0x16/0x1b
Code: 84 00 00 00 00 00 48 83 ec 28 4c 89 64 24 18 4c 89 6c 24 20 49 89 fc 48 89 5c 24 08 48 89 6c 24 10 49 89 f5 48 8b af 98 00 00 00 <48> 8b 5d 00 8b 83 7c 0c 00 00 a8 02 74 2d 8b 2d 8f 4c 06 00 85 
RIP  [<ffffffffa05dfd75>] em28xx_v4l2_poll+0x25/0x270 [em28xx]
 RSP <ffff88012a6dfd48>
CR2: 0000000000000000
---[ end trace 096e6c1008b16068 ]---
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffffa05dfd75>] em28xx_v4l2_poll+0x25/0x270 [em28xx]
PGD 1396c8067 PUD 11af14067 PMD 0 
Oops: 0000 [#2] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.4/1-5.4:1.0/bInterfaceProtocol
CPU 0 
Modules linked in: em28xx_dvb(+) dvb_core em28xx_audio tuner_xc5000 em28xx_cx25843 em28xx videodev v4l1_compat v4l2_compat_ioctl32 ipv6 aes_x86_64 aes_generic i915 drm i2c_algo_bit cpufreq_ondemand joydev hid_belkin usbhid hid btusb bluetooth snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device arc4 ecb snd_pcm_oss snd_mixer_oss serio_raw iwlagn snd_hda_codec_conexant psmouse iwlcore sg thinkpad_acpi rfkill nvram led_class mac80211 i2c_i801 i2c_core ide_pci_generic ide_core iTCO_wdt iTCO_vendor_support cfg80211 uhci_hcd wmi video output snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc ehci_hcd pata_acpi e1000e usbcore ata_generic intel_agp evdev thermal fan button battery ac vboxdrv acpi_cpufreq freq_table processor rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sd_mod ahci libata scsi_mod
Pid: 7994, comm: hald-probe-vide Tainted: G      D    2.6.29-ARCH #1 7469WA2
RIP: 0010:[<ffffffffa05dfd75>]  [<ffffffffa05dfd75>] em28xx_v4l2_poll+0x25/0x270 [em28xx]
RSP: 0018:ffff88012ad91d48  EFLAGS: 00010296
RAX: ffffffffa05fb140 RBX: ffff88012aee1800 RCX: 2222222222222222
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88011afe1540
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88012a6dbd80
R10: ffff88012ad91e68 R11: ffffffff80340630 R12: ffff88011afe1540
R13: 0000000000000001 R14: ffff880138240280 R15: ffffffff802cebb0
FS:  00007f1694ce66f0(0000) GS:ffffffff8067c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000012ad9e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hald-probe-vide (pid: 7994, threadinfo ffff88012ad90000, task ffff88013a54b600)
Stack:
 ffff88012aee1898 ffff88012aee1800 ffff88011afe1540 ffff88012aee1808
 ffff88011afe1540 ffffffffa05d0991 0000000000000000 ffff880138240280
 ffff88010597f4f0 ffffffff802cecf5 ffff88011afe1540 000000002a6dbd80
Call Trace:
 [<ffffffffa05d0991>] v4l2_open+0x91/0xb0 [videodev]
 [<ffffffff802cecf5>] chrdev_open+0x145/0x250
 [<ffffffff802c9761>] __dentry_open+0x131/0x360
 [<ffffffff802d9103>] do_filp_open+0x233/0x9c0
 [<ffffffff80492c43>] unix_stream_connect+0x473/0x4a0
 [<ffffffff804b3755>] _spin_unlock_irq+0x5/0x40
 [<ffffffff804b3835>] _spin_unlock+0x5/0x30
 [<ffffffff802e38a2>] alloc_fd+0x122/0x150
 [<ffffffff802c9560>] do_sys_open+0x80/0x110
 [<ffffffff8020c6aa>] system_call_fastpath+0x16/0x1b
Code: 84 00 00 00 00 00 48 83 ec 28 4c 89 64 24 18 4c 89 6c 24 20 49 89 fc 48 89 5c 24 08 48 89 6c 24 10 49 89 f5 48 8b af 98 00 00 00 <48> 8b 5d 00 8b 83 7c 0c 00 00 a8 02 74 2d 8b 2d 8f 4c 06 00 85 
RIP  [<ffffffffa05dfd75>] em28xx_v4l2_poll+0x25/0x270 [em28xx]
 RSP <ffff88012ad91d48>
CR2: 0000000000000000
---[ end trace 096e6c1008b16069 ]---
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffffa05dfd75>] em28xx_v4l2_poll+0x25/0x270 [em28xx]
PGD 12a616067 PUD 138d13067 PMD 0 
Oops: 0000 [#3] PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-5/1-5.4/1-5.4:1.0/bInterfaceProtocol
CPU 0 
Modules linked in: em28xx_dvb(+) dvb_core em28xx_audio tuner_xc5000 em28xx_cx25843 em28xx videodev v4l1_compat v4l2_compat_ioctl32 ipv6 aes_x86_64 aes_generic i915 drm i2c_algo_bit cpufreq_ondemand joydev hid_belkin usbhid hid btusb bluetooth snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device arc4 ecb snd_pcm_oss snd_mixer_oss serio_raw iwlagn snd_hda_codec_conexant psmouse iwlcore sg thinkpad_acpi rfkill nvram led_class mac80211 i2c_i801 i2c_core ide_pci_generic ide_core iTCO_wdt iTCO_vendor_support cfg80211 uhci_hcd wmi video output snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd soundcore snd_page_alloc ehci_hcd pata_acpi e1000e usbcore ata_generic intel_agp evdev thermal fan button battery ac vboxdrv acpi_cpufreq freq_table processor rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sd_mod ahci libata scsi_mod
Pid: 7995, comm: hald-probe-vide Tainted: G      D    2.6.29-ARCH #1 7469WA2
RIP: 0010:[<ffffffffa05dfd75>]  [<ffffffffa05dfd75>] em28xx_v4l2_poll+0x25/0x270 [em28xx]
RSP: 0018:ffff88011ac3bd48  EFLAGS: 00010296
RAX: ffffffffa05fb140 RBX: ffff88012aff4400 RCX: 2222222222222222
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff88012a5af000
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88011ac02480
R10: ffff88011ac3be68 R11: ffffffff80340630 R12: ffff88012a5af000
R13: 0000000000000001 R14: ffff88012eabc880 R15: ffffffff802cebb0
FS:  00007f5afdb826f0(0000) GS:ffffffff8067c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000012ebea000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hald-probe-vide (pid: 7995, threadinfo ffff88011ac3a000, task ffff88013839ce00)
Stack:
 ffff88012aff4498 ffff88012aff4400 ffff88012a5af000 ffff88012aff4408
 ffff88012a5af000 ffffffffa05d0991 0000000000000000 ffff88012eabc880
 ffff880105aed5a8 ffffffff802cecf5 ffff88012a5af000 000000001ac02480
Call Trace:
 [<ffffffffa05d0991>] v4l2_open+0x91/0xb0 [videodev]
 [<ffffffff802cecf5>] chrdev_open+0x145/0x250
 [<ffffffff802c9761>] __dentry_open+0x131/0x360
 [<ffffffff802d9103>] do_filp_open+0x233/0x9c0
 [<ffffffff804b1173>] preempt_schedule+0x43/0x70
 [<ffffffff80492c43>] unix_stream_connect+0x473/0x4a0
 [<ffffffff804b3755>] _spin_unlock_irq+0x5/0x40
 [<ffffffff804b3835>] _spin_unlock+0x5/0x30
 [<ffffffff802e38a2>] alloc_fd+0x122/0x150
 [<ffffffff802c9560>] do_sys_open+0x80/0x110
 [<ffffffff8020c6aa>] system_call_fastpath+0x16/0x1b
Code: 84 00 00 00 00 00 48 83 ec 28 4c 89 64 24 18 4c 89 6c 24 20 49 89 fc 48 89 5c 24 08 48 89 6c 24 10 49 89 f5 48 8b af 98 00 00 00 <48> 8b 5d 00 8b 83 7c 0c 00 00 a8 02 74 2d 8b 2d 8f 4c 06 00 85 
RIP  [<ffffffffa05dfd75>] em28xx_v4l2_poll+0x25/0x270 [em28xx]
 RSP <ffff88011ac3bd48>
CR2: 0000000000000000
---[ end trace 096e6c1008b1606a ]---
DVB: registering new adapter (em2880 DVB-T)
DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
Em28xx: Initialized (Em2880 DVB Extension) extension


--------------090909010604060906060507--
