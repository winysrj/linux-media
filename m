Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:40337 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3G2JQ6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 05:16:58 -0400
Received: by mail-ea0-f173.google.com with SMTP id g10so2789672eak.32
        for <linux-media@vger.kernel.org>; Mon, 29 Jul 2013 02:16:56 -0700 (PDT)
Message-ID: <51F63305.5030503@gmail.com>
Date: Mon, 29 Jul 2013 12:16:53 +0300
From: Yaroslav Zakharuk <slavikz@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Antonio Ospite <ospite@studenti.unina.it>,
	1173723@bugs.launchpad.net
Subject: [Regression 3.5->3.6, bisected] gspca_ov534: kernel oops when connecting
 Hercules Blog Webcam
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

After update from 3.5 kernel to newer version I got kernel oops when I 
connect my Hercules Blog Webcam. The full error stacktrace is at the end 
of this e-mail.

Commit bisect revealed the regression at:
-------------------------
1bd7d6adc691993206cf7dd69f1aaf8dccb06677 is the first bad commit
commit 1bd7d6adc691993206cf7dd69f1aaf8dccb06677
Author: Antonio Ospite <ospite@xxxxxxxxxxxx>
Date: Wed May 16 18:42:46 2012 -0300

     [media] gspca_ov534: Convert to the control framework

     Signed-off-by: Antonio Ospite <ospite@xxxxxxxxxxxx>
     Signed-off-by: Hans de Goede <hdegoede@xxxxxxxxxxxx>
     Signed-off-by: Mauro Carvalho Chehab <mchehab@xxxxxxxxxxxx>

:040000 040000 81bb6d86a59d2fca15fea4d43a8abe34354cf69e 
6b7c2077ae5d8bdea32864841b5cd14149c6a44a M drivers
-------------------------

I also try to change the gspca_ov534 module source (ov534.c) from the 
3.8 kernel and added some additional null checks in sd_start function 
and add the extensive logging to it. With those changes my webcam is 
working OK. As far as I can see, sd_start function is called couple of 
times, but when it is called the first time (when a usb cable was 
inserted), sd struct is almost empty and without null check this leads 
to kernel oops. Here is the part of test version log when sd_start was 
called first time:

sd_start: NO sd->hue!
sd_start: NO sd->saturation!
sd_start: NO sd->autogain!
sd_start: NO sd->autowhitebalance!
sd_start: NO sd->autoexposure!
sd_start: NO sd->gain!
sd_start: NO sd->exposure!
sd_start: NO sd->brightness!
sd_start: NO sd->contrast!
sd_start: NO sd->sharpness!
sd_start: NO sd->hflip and sd->vflip!
sd_start: NO sd->plfreq!

Additional info can be found here: 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1173723/


Here is the error stacktrace:
kernel: [   52.679705] usb 3-2: new high-speed USB device number 2 using 
xhci_hcd
kernel: [   52.697906] usb 3-2: New USB device found, idVendor=06f8, 
idProduct=3002
kernel: [   52.697910] usb 3-2: New USB device strings: Mfr=1, 
Product=2, SerialNumber=0
kernel: [   52.697912] usb 3-2: Product: Hercules Blog Microphone
kernel: [   52.697914] usb 3-2: Manufacturer: Hercules Blog Webcam
kernel: [   52.708983] Linux video capture interface: v2.00
kernel: [   52.710778] gspca_main: v2.14.0 registered
kernel: [   52.712210] gspca_main: ov534-2.14.0 probing 06f8:3002
kernel: [   55.506311] BUG: unable to handle kernel NULL pointer 
dereference at 0000000000000050
kernel: [   55.506367] IP: [<ffffffffa03c1b01>] 
v4l2_ctrl_g_ctrl+0x11/0x60 [videodev]
kernel: [   55.506414] PGD 0
kernel: [   55.506429] Oops: 0000 [#1] SMP
kernel: [   55.506453] Modules linked in: gspca_ov534(+) gspca_main 
videodev rfcomm bnep ppdev bluetooth binfmt_misc snd_hda_codec_hdmi 
snd_hda_codec_realtek stir4200 irda crc_ccitt usblp snd_hda_intel 
snd_hda_codec snd_hwdep snd_pcm hid_generic snd_page_alloc snd_seq_midi 
snd_seq_midi_event usbhid snd_rawmidi snd_seq snd_seq_device snd_timer 
hid i915 snd psmouse drm_kms_helper serio_raw mei_me drm mei soundcore 
video i2c_algo_bit lpc_ich mac_hid coretemp lp parport firewire_ohci 
firewire_core crc_itu_t ahci libahci alx mdio r8169 mii [last unloaded: 
parport_pc]
kernel: [   55.506819] CPU: 3 PID: 4352 Comm: modprobe Not tainted 
3.11.0-031100rc2-generic #201307211535
kernel: [   55.506864] Hardware name: Gigabyte Technology Co., Ltd. To 
be filled by O.E.M./Z77-DS3H, BIOS F9 09/19/2012
kernel: [   55.506913] task: ffff8801c20f9770 ti: ffff8801ceaa0000 
task.ti: ffff8801ceaa0000
kernel: [   55.506952] RIP: 0010:[<ffffffffa03c1b01>] 
[<ffffffffa03c1b01>] v4l2_ctrl_g_ctrl+0x11/0x60 [videodev]
kernel: [   55.507005] RSP: 0018:ffff8801ceaa1af8  EFLAGS: 00010292
kernel: [   55.507033] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 
000000000001988b
kernel: [   55.507069] RDX: 000000000001988a RSI: ffffffffa032745a RDI: 
0000000000000000
kernel: [   55.507106] RBP: ffff8801ceaa1b28 R08: 0000000000017380 R09: 
ffffea0008419d80
kernel: [   55.507142] R10: ffffffff81538f5a R11: 0000000000000002 R12: 
ffffffffa03273dc
kernel: [   55.507178] R13: ffffffffa03273dc R14: 0000000000000000 R15: 
ffffffffa03270a0
kernel: [   55.507215] FS:  00007f72d564a740(0000) 
GS:ffff88021f380000(0000) knlGS:0000000000000000
kernel: [   55.507256] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: [   55.507286] CR2: 0000000000000050 CR3: 00000001bd1f0000 CR4: 
00000000001407e0
kernel: [   55.507323] Stack:
kernel: [   55.507335]  ffff8801ceaa1b28 ffffffffa0325cff 
ffff8801000001f4 ffff8801ceb44000
kernel: [   55.507380]  ffffffffa03273dc ffff8801ceb44000 
ffff8801ceaa1b58 ffffffffa032688e
kernel: [   55.507426]  ffff8801ceb44000 ffffffffa03274f0 
ffffffffa03274f0 ffff8801ceb44380
kernel: [   55.507471] Call Trace:
kernel: [   55.507490]  [<ffffffffa0325cff>] ? sccb_w_array+0x3f/0x80 
[gspca_ov534]
kernel: [   55.507527]  [<ffffffffa032688e>] sd_start+0xce/0x2b0 
[gspca_ov534]
kernel: [   55.507561]  [<ffffffffa0326bf9>] sd_init+0x189/0x1e8 
[gspca_ov534]
kernel: [   55.507596]  [<ffffffffa02a0c95>] 
gspca_dev_probe2+0x285/0x410 [gspca_main]
kernel: [   55.507634]  [<ffffffffa02a0e58>] gspca_dev_probe+0x38/0x60 
[gspca_main]
kernel: [   55.507670]  [<ffffffffa0325081>] sd_probe+0x21/0x30 
[gspca_ov534]
kernel: [   55.507706]  [<ffffffff8153c960>] usb_probe_interface+0x1c0/0x2f0
kernel: [   55.507740]  [<ffffffff8148758c>] really_probe+0x6c/0x330
kernel: [   55.507771]  [<ffffffff814879d7>] driver_probe_device+0x47/0xa0
kernel: [   55.507803]  [<ffffffff81487adb>] __driver_attach+0xab/0xb0
kernel: [   55.507834]  [<ffffffff81487a30>] ? driver_probe_device+0xa0/0xa0
kernel: [   55.507867]  [<ffffffff814857be>] bus_for_each_dev+0x5e/0x90
kernel: [   55.507899]  [<ffffffff8148714e>] driver_attach+0x1e/0x20
kernel: [   55.507929]  [<ffffffff81486bdc>] bus_add_driver+0x10c/0x290
kernel: [   55.507961]  [<ffffffff8148805d>] driver_register+0x7d/0x160
kernel: [   55.507993]  [<ffffffff8153b590>] usb_register_driver+0xa0/0x160
kernel: [   55.508027]  [<ffffffffa0067000>] ? 0xffffffffa0066fff
kernel: [   55.508056]  [<ffffffffa006701e>] sd_driver_init+0x1e/0x1000 
[gspca_ov534]
kernel: [   55.508094]  [<ffffffff8100212a>] do_one_initcall+0xfa/0x1b0
kernel: [   55.508126]  [<ffffffff810578c3>] ? set_memory_nx+0x43/0x50
kernel: [   55.508160]  [<ffffffff81712e8d>] do_init_module+0x80/0x1d1
kernel: [   55.508193]  [<ffffffff810d2079>] load_module+0x4c9/0x5f0
kernel: [   55.508223]  [<ffffffff810cf7b0>] ? add_kallsyms+0x210/0x210
kernel: [   55.508254]  [<ffffffff810d2254>] SyS_init_module+0xb4/0x100
kernel: [   55.508286]  [<ffffffff817333ef>] tracesys+0xe1/0xe6
kernel: [   55.508312] Code: a0 09 00 00 48 c7 c7 30 c3 3c a0 e8 7a 38 
ca e0 eb cf 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 53 48 89 
fb 48 83 ec 28 <8b> 47 50 83 e8 05 83 f8 02 77 09 80 b8 20 8c 3c a0 00 
74 1d 48
kernel: [   55.508559] RIP  [<ffffffffa03c1b01>] 
v4l2_ctrl_g_ctrl+0x11/0x60 [videodev]
kernel: [   55.510605]  RSP <ffff8801ceaa1af8>
kernel: [   55.512641] CR2: 0000000000000050
kernel: [   55.525424] ---[ end trace 6786f15abfd2ac90 ]---

-- 
Regards,
  Yaroslav

