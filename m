Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56940 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab1APPDx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jan 2011 10:03:53 -0500
Received: by eye27 with SMTP id 27so2163817eye.19
        for <linux-media@vger.kernel.org>; Sun, 16 Jan 2011 07:03:52 -0800 (PST)
From: Alexey Chernov <4ernov@gmail.com>
To: linux-media@vger.kernel.org
Subject: BUG: unable to handle kernel NULL pointer dereference when using radio_usb_si470x
Date: Sun, 16 Jan 2011 18:03:47 +0300
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101161803.47482.4ernov@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello, I've recently faced kernel boo-boo using driver radio_usb_si470x with SI chipset device, according to info in module I think I should post it here.

Here's crash report in syslog:

Jan 16 00:53:14 aclex kernel: usb 1-2.3: new full speed USB device using ehci_hcd and address 9
Jan 16 00:53:14 aclex kernel: radio-si470x 1-2.3:1.2: DeviceID=0x1242 ChipID=0x060f
Jan 16 00:53:14 aclex kernel: radio-si470x 1-2.3:1.2: software version 1, hardware version 4
Jan 16 00:53:14 aclex kernel: radio-si470x 1-2.3:1.2: This driver is known to work with software version 7,
Jan 16 00:53:14 aclex kernel: radio-si470x 1-2.3:1.2: but the device has software version 1.
Jan 16 00:53:14 aclex kernel: radio-si470x 1-2.3:1.2: If you have some trouble using this driver,
Jan 16 00:53:14 aclex kernel: radio-si470x 1-2.3:1.2: please report to V4L ML at linux-media@vger.kernel.org
Jan 16 00:53:22 aclex kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
Jan 16 00:53:22 aclex kernel: IP: [<ffffffffa0036ea8>] si470x_vidioc_querycap+0x58/0x90 [radio_usb_si470x]
Jan 16 00:53:22 aclex kernel: PGD 256f7f067 PUD 252a96067 PMD 0 
Jan 16 00:53:22 aclex kernel: Oops: 0000 [#1] PREEMPT SMP 
Jan 16 00:53:22 aclex kernel: last sysfs file: /sys/devices/platform/coretemp.0/temp1_label
Jan 16 00:53:22 aclex kernel: CPU 7 
Jan 16 00:53:22 aclex kernel: Modules linked in: radio_usb_si470x zl10353 xc5000 option tuner cx25840 cx23885 usb_wwan cx2341x videobuf_dma_sg videobuf_dvb tpm_tis dvb_core tpm tpm_bios usbserial videobuf_core btcx_risc tveeprom acpi_cpufreq mperf tun
Jan 16 00:53:22 aclex kernel: 
Jan 16 00:53:22 aclex kernel: Pid: 3222, comm: gst-launch-0.10 Not tainted 2.6.36.1 #2 S5000XVN/S5000XVN
Jan 16 00:53:22 aclex kernel: RIP: 0010:[<ffffffffa0036ea8>]  [<ffffffffa0036ea8>] si470x_vidioc_querycap+0x58/0x90 [radio_usb_si470x]
Jan 16 00:53:22 aclex kernel: RSP: 0018:ffff880210829c58  EFLAGS: 00010296
Jan 16 00:53:22 aclex kernel: RAX: ffff880252b50000 RBX: ffff880210829db8 RCX: 0000000000000000
Jan 16 00:53:22 aclex kernel: RDX: 0000000000000000 RSI: ffffffffa0038097 RDI: ffff880210829de8
Jan 16 00:53:22 aclex kernel: RBP: ffff880210829c68 R08: ffff880252b50004 R09: ffff880210829db8
Jan 16 00:53:22 aclex kernel: R10: 0000000000000000 R11: 0000000000000000 R12: ffff880258ad9ec0
Jan 16 00:53:22 aclex kernel: R13: 0000000080685600 R14: ffff880259319780 R15: ffffffffa0037a40
Jan 16 00:53:22 aclex kernel: FS:  00007fbcef316700(0000) GS:ffff880001bc0000(0000) knlGS:0000000000000000
Jan 16 00:53:22 aclex kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 16 00:53:22 aclex kernel: CR2: 0000000000000010 CR3: 0000000255a24000 CR4: 00000000000006e0
Jan 16 00:53:22 aclex kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 16 00:53:22 aclex kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jan 16 00:53:22 aclex kernel: Process gst-launch-0.10 (pid: 3222, threadinfo ffff880210828000, task ffff88025894c710)
Jan 16 00:53:22 aclex kernel: Stack:
Jan 16 00:53:22 aclex kernel:  ffff880252b86c00 ffff880210829db8 ffff880210829d78 ffffffff8146a54d
Jan 16 00:53:22 aclex kernel: <0> ffff880210829ca8 ffffffff810ebe23 ffff88024596bd98 ffff880210829d28
Jan 16 00:53:22 aclex kernel: <0> ffff880259319780 ffff880252b7aa30 ffffea0008487860 ffffea0000000000
Jan 16 00:53:22 aclex kernel: Call Trace:
Jan 16 00:53:22 aclex kernel:  [<ffffffff8146a54d>] __video_do_ioctl+0x46d/0x4bd0
Jan 16 00:53:22 aclex kernel:  [<ffffffff810ebe23>] ? cdev_get+0x63/0xa0
Jan 16 00:53:22 aclex kernel:  [<ffffffff810b20e5>] ? unlock_page+0x25/0x30
Jan 16 00:53:22 aclex kernel:  [<ffffffff810c8409>] ? __do_fault+0x409/0x540
Jan 16 00:53:22 aclex kernel:  [<ffffffff810ec000>] ? chrdev_open+0x0/0x200
Jan 16 00:53:22 aclex kernel:  [<ffffffff8146edf1>] video_ioctl2+0x141/0x590
Jan 16 00:53:22 aclex kernel:  [<ffffffff8146933e>] v4l2_ioctl+0x9e/0xc0
Jan 16 00:53:22 aclex kernel:  [<ffffffff810f7cdf>] do_vfs_ioctl+0x9f/0x550
Jan 16 00:53:22 aclex kernel:  [<ffffffff81100d72>] ? alloc_fd+0xf2/0x140
Jan 16 00:53:22 aclex kernel:  [<ffffffff810f8211>] sys_ioctl+0x81/0xa0
Jan 16 00:53:22 aclex kernel:  [<ffffffff8102ce82>] system_call_fastpath+0x16/0x1b
Jan 16 00:53:22 aclex kernel: Code: 20 e1 48 8d 7b 10 ba 20 00 00 00 48 c7 c6 78 80 03 a0 e8 9c d6 20 e1 49 8b 84 24 80 00 00 00 48 8d 7b 30 48 8b 50 40 4c 8d 40 04 <48> 8b 4a 10 be 20 00 00 00 48 c7 c2 ff 7e 03 a0 31 c0 e8 41 fd 
Jan 16 00:53:22 aclex kernel: RIP  [<ffffffffa0036ea8>] si470x_vidioc_querycap+0x58/0x90 [radio_usb_si470x]
Jan 16 00:53:22 aclex kernel:  RSP <ffff880210829c58>
Jan 16 00:53:22 aclex kernel: CR2: 0000000000000010
Jan 16 00:53:23 aclex kernel: ---[ end trace 6e0f9403fadb7548 ]---
Jan 16 00:53:50 aclex kernel: usb 1-2.3: USB disconnect, address 9

The device is Silicon Labs USBFMRADIO-RD and chipset seems to be Si4701.

How I reproduced it (was 100% reproducible for me):
1. Connect the device, start playing from its ALSA card and send several ioctl commands to control it. (I used gstreamer for it).
2. Connect USB-flash to the next USB port and mention that the radio device stopped receiving the signal (audio stream is still goes but with silence).
3. Send some more ioctl commands. You can reconnect the radio device or keep it connected before this step.
4. See the crash similar to printed above.

My 'uname -a' is:
Linux aclex 2.6.36.1 #2 SMP PREEMPT Sat Dec 4 02:24:39 MSK 2010 x86_64 x86_64 x86_64 GNU/Linux
