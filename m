Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-ip-85-25-59-232.inaddr.intergenia.de ([85.25.59.232]:34216
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880AbZLEXZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2009 18:25:27 -0500
Date: Sun, 6 Dec 2009 00:05:10 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <255535957.20091206000510@eikelenboom.it>
To: linux-media@vger.kernel.org
CC: mchehab@redhat.com
Subject: [em28xx] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000 IP: [<ffffffffa00997be>] :ir_common:ir_input_free+0x26/0x3e
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

Tried to update my v4l-dvb modules today, but got a bug with my pinnacle card, seems to be related to the recent changes in the ir code.
I have added dmesg output of the bug (changeset a871d61b614f tip), and dmesg output of the previous modules (working).

--
Sander

Dec  5 23:30:25 security kernel: [    5.596128] em28xx: New device Pinnacle Systems GmbH PCTV USB2 PAL @ 480 Mbps (2304:0208, interface 0, class 0)
Dec  5 23:30:25 security kernel: [    5.596535] em28xx #1: chip ID is em2820 (or em2710)
Dec  5 23:30:25 security kernel: [    5.726154] em28xx #1: i2c eeprom 00: 1a eb 67 95 04 23 08 02 10 00 1e 03 98 1e 6a 2e
Dec  5 23:30:25 security kernel: [    5.726181] em28xx #1: i2c eeprom 10: 00 00 06 57 6e 00 00 00 8e 00 00 00 07 00 00 00
Dec  5 23:30:25 security kernel: [    5.726203] em28xx #1: i2c eeprom 20: 16 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:30:25 security kernel: [    5.726226] em28xx #1: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00 00 00 00 00
Dec  5 23:30:25 security kernel: [    5.726247] em28xx #1: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:30:25 security kernel: [    5.726270] em28xx #1: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:30:25 security kernel: [    5.726290] em28xx #1: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 2e 03 50 00 69 00
Dec  5 23:30:25 security kernel: [    5.726312] em28xx #1: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
Dec  5 23:30:25 security kernel: [    5.726333] em28xx #1: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 20 00 47 00
Dec  5 23:30:25 security kernel: [    5.726354] em28xx #1: i2c eeprom 90: 6d 00 62 00 48 00 00 00 1e 03 50 00 43 00 54 00
Dec  5 23:30:25 security kernel: [    5.726376] em28xx #1: i2c eeprom a0: 56 00 20 00 55 00 53 00 42 00 32 00 20 00 50 00
Dec  5 23:30:25 security kernel: [    5.726397] em28xx #1: i2c eeprom b0: 41 00 4c 00 00 00 06 03 31 00 00 00 00 00 00 00
Dec  5 23:30:25 security kernel: [    5.726420] em28xx #1: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:30:25 security kernel: [    5.726440] em28xx #1: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:30:25 security kernel: [    5.726461] em28xx #1: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:30:25 security kernel: [    5.726484] em28xx #1: i2c eeprom f0: 00 00 00 00 00 00 00 00 07 56 d9 35 01 ed 0b f8
Dec  5 23:30:25 security kernel: [    5.726506] em28xx #1: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x0fd77740
Dec  5 23:30:25 security kernel: [    5.726513] em28xx #1: EEPROM info:
Dec  5 23:30:25 security kernel: [    5.726517] em28xx #1:      AC97 audio (5 sample rates)
Dec  5 23:30:25 security kernel: [    5.726522] em28xx #1:      500mA max power
Dec  5 23:30:25 security kernel: [    5.726528] em28xx #1:      Table at 0x06, strings=0x1e98, 0x2e6a, 0x0000
Dec  5 23:30:25 security kernel: [    5.726534] em28xx #1: Identified as Pinnacle PCTV USB 2 (card=3)
Dec  5 23:30:25 security kernel: [    5.735698] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
Dec  5 23:30:25 security kernel: [    5.735716] IP: [<ffffffffa00997be>] :ir_common:ir_input_free+0x26/0x3e
Dec  5 23:30:25 security kernel: [    5.735736] PGD 1fdcb067 PUD 1f65d067 PMD 0 
Dec  5 23:30:25 security kernel: [    5.735744] Oops: 0000 [1] SMP 
Dec  5 23:30:25 security kernel: [    5.735750] CPU 0 
Dec  5 23:30:25 security kernel: [    5.735754] Modules linked in: ir_kbd_i2c(+) saa7115 usbhid(+) hid ff_memless em28xx(+) v4l2_common videodev v4l1_compat v4l2_compat_ioctl32 ir_common videobuf_vmalloc videobuf_core tveeprom i2c_core evdev ext3 jbd mbcache ohci_hcd ohci1394 ieee1394 ehci_hcd uhci_hcd thermal_sys
Dec  5 23:30:25 security kernel: [    5.735793] Pid: 1091, comm: modprobe Not tainted 2.6.26-2-xen-amd64 #1
Dec  5 23:30:25 security kernel: [    5.735798] RIP: e030:[<ffffffffa00997be>]  [<ffffffffa00997be>] :ir_common:ir_input_free+0x26/0x3e
Dec  5 23:30:25 security kernel: [    5.735812] RSP: e02b:ffff88001e12fd28  EFLAGS: 00010246
Dec  5 23:30:25 security kernel: [    5.735817] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
Dec  5 23:30:25 security kernel: [    5.735823] RDX: 0000000000000202 RSI: 7fffffffffffffff RDI: ffff88001f6b9000
Dec  5 23:30:25 security kernel: [    5.735829] RBP: 00000000ffffffed R08: ffff8800016c9270 R09: ffff88001f6bca50
Dec  5 23:30:25 security kernel: [    5.735835] R10: 0000000000000000 R11: ffffffffa0080ec6 R12: 0000000000000063
Dec  5 23:30:25 security kernel: [    5.735840] R13: ffff88001f6b9000 R14: ffff8800016c9008 R15: ffff88001f65e1a8
Dec  5 23:30:25 security kernel: [    5.735848] FS:  00007fe1b4eb76e0(0000) GS:ffffffff80539000(0000) knlGS:0000000000000000
Dec  5 23:30:25 security kernel: [    5.735855] CS:  e033 DS: 0000 ES: 0000
Dec  5 23:30:25 security kernel: [    5.735860] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Dec  5 23:30:25 security kernel: [    5.735866] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Dec  5 23:30:25 security kernel: [    5.735872] Process modprobe (pid: 1091, threadinfo ffff88001e12e000, task ffff88001fc4a080)
Dec  5 23:30:25 security kernel: [    5.735880] Stack:  ffff8800016c9000 ffffffffa01054bc ffff8800016c900c ffffffffa0105ba4
Dec  5 23:30:25 security kernel: [    5.735891]  ffff88001f65e1a8 0000000000000000 ffffffffa0105ba0 0000000000000001
Dec  5 23:30:25 security kernel: [    5.735901]  0000000000000001 ffffffffa0105760 0000000000000001 ffffffff80378997
Dec  5 23:30:25 security kernel: [    5.735909] Call Trace:
Dec  5 23:30:25 security kernel: [    5.735919]  [<ffffffffa01054bc>] ? :ir_kbd_i2c:ir_attach+0x339/0x357
Dec  5 23:30:25 security kernel: [    5.735927]  [<ffffffffa0105760>] ? :ir_kbd_i2c:ir_probe+0x286/0x295
Dec  5 23:30:25 security kernel: [    5.735935]  [<ffffffff80378997>] ? bus_add_driver+0x1a7/0x1e4
Dec  5 23:30:25 security kernel: [    5.735947]  [<ffffffffa00810ab>] ? :i2c_core:i2c_register_driver+0x91/0xd8
Dec  5 23:30:25 security kernel: [    5.735956]  [<ffffffff8024c5a2>] ? sys_init_module+0x191b/0x1ab1
Dec  5 23:30:25 security kernel: [    5.735969]  [<ffffffff8020b528>] ? system_call+0x68/0x6d
Dec  5 23:30:25 security kernel: [    5.735976]  [<ffffffff8020b4c0>] ? system_call+0x0/0x6d
Dec  5 23:30:25 security kernel: [    5.735981] 
Dec  5 23:30:25 security kernel: [    5.735984] 
Dec  5 23:30:25 security kernel: [    5.735988] Code: 41 5c 41 5d c3 83 3d 61 e0 00 00 00 53 48 8b 9f 68 08 00 00 7e 15 48 c7 c6 20 9d 09 a0 48 c7 c7 bc 9f 09 a0 31 c0 e8 e6 3e 19 e0 <48> 8b 3b c7 43 08 00 00 00 00 e8 7b d1 1e e0 48 c7 03 00 00 00 
Dec  5 23:30:25 security kernel: [    5.736027] RIP  [<ffffffffa00997be>] :ir_common:ir_input_free+0x26/0x3e
Dec  5 23:30:25 security kernel: [    5.736027]  RSP <ffff88001e12fd28>
Dec  5 23:30:25 security kernel: [    5.736027] CR2: 0000000000000000
Dec  5 23:30:25 security kernel: [    5.736078] ---[ end trace 59c23791d0b58b9f ]---
Dec  5 23:30:25 security kernel: [    6.101226] saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #1)







Dec  5 23:02:38 security kernel: [    5.965935] em28xx: New device Pinnacle Systems GmbH PCTV USB2 PAL @ 480 Mbps (2304:0208, interface 0, class 0)
Dec  5 23:02:38 security kernel: [    5.965949] em28xx #1: Identified as Pinnacle PCTV USB 2 (card=3)
Dec  5 23:02:38 security kernel: [    5.966350] em28xx #1: chip ID is em2710 or em2820
Dec  5 23:02:38 security kernel: [    6.095385] em28xx #1: i2c eeprom 00: 1a eb 67 95 04 23 08 02 10 00 1e 03 98 1e 6a 2e
Dec  5 23:02:38 security kernel: [    6.095410] em28xx #1: i2c eeprom 10: 00 00 06 57 6e 00 00 00 8e 00 00 00 07 00 00 00
Dec  5 23:02:38 security kernel: [    6.095428] em28xx #1: i2c eeprom 20: 16 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:02:38 security kernel: [    6.095448] em28xx #1: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00 00 00 00 00
Dec  5 23:02:38 security kernel: [    6.095468] em28xx #1: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:02:38 security kernel: [    6.095487] em28xx #1: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:02:38 security kernel: [    6.095507] em28xx #1: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 2e 03 50 00 69 00
Dec  5 23:02:38 security kernel: [    6.095526] em28xx #1: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00
Dec  5 23:02:38 security kernel: [    6.095545] em28xx #1: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 20 00 47 00
Dec  5 23:02:38 security kernel: [    6.095564] em28xx #1: i2c eeprom 90: 6d 00 62 00 48 00 00 00 1e 03 50 00 43 00 54 00
Dec  5 23:02:38 security kernel: [    6.095584] em28xx #1: i2c eeprom a0: 56 00 20 00 55 00 53 00 42 00 32 00 20 00 50 00
Dec  5 23:02:38 security kernel: [    6.095604] em28xx #1: i2c eeprom b0: 41 00 4c 00 00 00 06 03 31 00 00 00 00 00 00 00
Dec  5 23:02:38 security kernel: [    6.095623] em28xx #1: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:02:38 security kernel: [    6.095641] em28xx #1: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:02:38 security kernel: [    6.095662] em28xx #1: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Dec  5 23:02:38 security kernel: [    6.095681] em28xx #1: i2c eeprom f0: 00 00 00 00 00 00 00 00 07 56 d9 35 01 ed 0b f8
Dec  5 23:02:38 security kernel: [    6.095701] em28xx #1: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x0fd77740
Dec  5 23:02:38 security kernel: [    6.095708] em28xx #1: EEPROM info:
Dec  5 23:02:38 security kernel: [    6.095712] em28xx #1:      AC97 audio (5 sample rates)
Dec  5 23:02:38 security kernel: [    6.095717] em28xx #1:      500mA max power
Dec  5 23:02:38 security kernel: [    6.095723] em28xx #1:      Table at 0x06, strings=0x1e98, 0x2e6a, 0x0000
Dec  5 23:02:38 security kernel: [    6.462303] saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #1)
Dec  5 23:02:38 security kernel: [    7.222804] tuner 1-0043: chip found @ 0x86 (em28xx #1)
Dec  5 23:02:38 security kernel: [    7.238412] tda9887 1-0043: creating new instance
Dec  5 23:02:38 security kernel: [    7.238427] tda9887 1-0043: tda988[5/6/7] found
Dec  5 23:02:38 security kernel: [    7.257841] tuner 1-0063: chip found @ 0xc6 (em28xx #1)
Dec  5 23:02:38 security kernel: [    7.278190] tuner-simple 1-0063: creating new instance
Dec  5 23:02:38 security kernel: [    7.278206] tuner-simple 1-0063: type set to 37 (LG PAL (newer TAPC series))
Dec  5 23:02:38 security kernel: [    7.326028] em28xx #1: Config register raw data: 0x10
Dec  5 23:02:38 security kernel: [    7.350029] em28xx #1: AC97 vendor ID = 0xffffffff
Dec  5 23:02:38 security kernel: [    7.362030] em28xx #1: AC97 features = 0x6a90
Dec  5 23:02:38 security kernel: [    7.362038] em28xx #1: Empia 202 AC97 audio processor detected
Dec  5 23:02:38 security kernel: [    7.821837] em28xx #1: v4l2 driver version 0.1.2
Dec  5 23:02:38 security kernel: [    8.665909] em28xx #1: V4L2 device registered as /dev/video1 and /dev/vbi1
Dec  5 23:02:38 security kernel: [    8.677859] em28xx audio device (2304:0208): interface 1, class 1
Dec  5 23:02:38 security kernel: [    8.677887] em28xx audio device (2304:0208): interface 2, class 1
Dec  5 23:02:38 security kernel: [    8.677920] usbcore: registered new interface driver em28xx
Dec  5 23:02:38 security kernel: [    8.677928] em28xx driver loaded














