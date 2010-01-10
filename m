Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:55622 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab0AJBwV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Jan 2010 20:52:21 -0500
Received: by fxm25 with SMTP id 25so13632911fxm.21
        for <linux-media@vger.kernel.org>; Sat, 09 Jan 2010 17:52:19 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 9 Jan 2010 20:52:18 -0500
Message-ID: <829197381001091752v239d3514l32969da7e559cf97@mail.gmail.com>
Subject: Regression - OOPS when connecting devices with IR support
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey all,

This is going to sound like a bit of a silly question.  Has anyone
tried the current v4l-dvb tip with a device that has IR support?

I had been working on separate branches for the last few weeks, and
finally updated to the tip.  I'm seeing the exact same OOPS condition
for both my em28xx and cx88 based device.

Did someone break the IR core?  This occurs 100% of the time in my
environment when loading either cx88 or em28xx based devices that have
IR support (a stock Ubuntu 9.10 build (2.6.31-17-generic) with the
current v4l-dvb tip as of tonight.

Devin

[ 1265.371807] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb1/1-5/input/input6
[ 1265.371887] Creating IR device irrcv0
[ 1265.371905] BUG: unable to handle kernel paging request at 72727563
[ 1265.371912] IP: [<c0318b52>] strcmp+0x12/0x30
[ 1265.371922] *pde = 00000000
[ 1265.371927] Oops: 0000 [#1] SMP
[ 1265.371932] last sysfs file:
/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-5/firmware/1-5/loading
[ 1265.371937] Modules linked in: tuner_xc2028 tuner tvp5150 em28xx(+)
v4l2_common videodev v4l1_compat ir_common videobuf_vmalloc
videobuf_core ir_core tveeprom binfmt_misc ppdev snd_hda_codec_realtek
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device dell_wmi psmouse
dcdbas iptable_filter ip_tables x_tables lp parport nvidia(P) snd
soundcore snd_page_alloc serio_raw usbhid floppy r8169 mii intel_agp
agpgart
[ 1265.372001]
[ 1265.372006] Pid: 2540, comm: modprobe Tainted: P
(2.6.31-17-generic #54-Ubuntu) Inspiron 537
[ 1265.372011] EIP: 0060:[<c0318b52>] EFLAGS: 00010296 CPU: 1
[ 1265.372015] EIP is at strcmp+0x12/0x30
[ 1265.372019] EAX: c06e2d75 EBX: f11b9720 ECX: c023a3c0 EDX: 72727563
[ 1265.372023] ESI: c06e2db1 EDI: 72727563 EBP: f2207ab4 ESP: f2207aac
[ 1265.372027]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[ 1265.372031] Process modprobe (pid: 2540, ti=f2206000 task=f21a1920
task.ti=f2206000)
[ 1265.372035] Stack:
[ 1265.372037]  72727563 f2207b18 f2207ac4 c023a721 f11b9840 f2207b18
f2207ad8 c023b2ef
[ 1265.372048] <0> f2207b18 f11b9840 f2207b18 f2207b0c c023b3a8
c01fb879 f11b96f0 00000001
[ 1265.372059] <0> f11b96f0 f2207b18 f2207b0c c023a8cf f11b96f0
f2207b18 f11b9840 fffffff4
[ 1265.372072] Call Trace:
[ 1265.372078]  [<c023a721>] ? sysfs_find_dirent+0x21/0x30
[ 1265.372084]  [<c023b2ef>] ? __sysfs_add_one+0x1f/0xc0
[ 1265.372090]  [<c023b3a8>] ? sysfs_add_one+0x18/0x100
[ 1265.372095]  [<c01fb879>] ? ilookup5+0x39/0x50
[ 1265.372100]  [<c023a8cf>] ? sysfs_addrm_start+0x3f/0xa0
[ 1265.372107]  [<c0239bdc>] ? sysfs_add_file_mode+0x4c/0x80
[ 1265.372113]  [<c023c515>] ? create_files+0x55/0xc0
[ 1265.372119]  [<c023c5e5>] ? internal_create_group+0x65/0xc0
[ 1265.372125]  [<c023c66c>] ? sysfs_create_group+0xc/0x10
[ 1265.372134]  [<f80e690b>] ? ir_register_class+0x8b/0xd0 [ir_core]
[ 1265.372142]  [<f80e63a4>] ? ir_input_register+0x184/0x250 [ir_core]
[ 1265.372149]  [<c015834b>] ? queue_work_on+0x3b/0x60
[ 1265.372155]  [<c01583a5>] ? queue_work+0x15/0x20
[ 1265.372170]  [<f81b059f>] ? em28xx_ir_init+0x1af/0x240 [em28xx]
[ 1265.372183]  [<f81ac6ec>] ? em28xx_card_setup+0x4ac/0xe90 [em28xx]
[ 1265.372197]  [<f81abc60>] ? em28xx_tuner_callback+0x0/0x30 [em28xx]
[ 1265.372209]  [<f81ad694>] ? em28xx_usb_probe+0x5c4/0xaa0 [em28xx]
[ 1265.372219]  [<c0414fc7>] ? usb_probe_interface+0x87/0x160
[ 1265.372225]  [<c023b8b2>] ? sysfs_create_link+0x12/0x20
[ 1265.372232]  [<c03a2e30>] ? really_probe+0x50/0x140
[ 1265.372238]  [<c0570cea>] ? _spin_lock_irqsave+0x2a/0x40
[ 1265.372245]  [<c03a2f39>] ? driver_probe_device+0x19/0x20
[ 1265.372251]  [<c03a2fb9>] ? __driver_attach+0x79/0x80
[ 1265.372257]  [<c03a2488>] ? bus_for_each_dev+0x48/0x70
[ 1265.372263]  [<c03a2cf9>] ? driver_attach+0x19/0x20
[ 1265.372269]  [<c03a2f40>] ? __driver_attach+0x0/0x80
[ 1265.372275]  [<c03a26df>] ? bus_add_driver+0xbf/0x2a0
[ 1265.372281]  [<c03a3245>] ? driver_register+0x65/0x120
[ 1265.372288]  [<c04145d9>] ? usb_register_driver+0x79/0xf0
[ 1265.372295]  [<c01979df>] ? tracepoint_module_notify+0x2f/0x40
[ 1265.372306]  [<f81bf01b>] ? em28xx_module_init+0x1b/0x44 [em28xx]
[ 1265.372311]  [<c010112c>] ? do_one_initcall+0x2c/0x190
[ 1265.372322]  [<f81bf000>] ? em28xx_module_init+0x0/0x44 [em28xx]
[ 1265.372328]  [<c0173711>] ? sys_init_module+0xb1/0x1f0
[ 1265.372334]  [<c010336c>] ? syscall_call+0x7/0xb
[ 1265.372337] Code: 8b 1c 24 8b 7c 24 08 89 ec 5d c3 8d b4 26 00 00
00 00 8d bc 27 00 00 00 00 55 89 e5 83 ec 08 89 34 24 89 c6 89 7c 24
04 89 d7 ac <ae> 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 8b 34 24 8b
7c 24
[ 1265.372404] EIP: [<c0318b52>] strcmp+0x12/0x30 SS:ESP 0068:f2207aac
[ 1265.372411] CR2: 0000000072727563
[ 1265.372416] ---[ end trace a4f8803cde5fb73f ]---


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
