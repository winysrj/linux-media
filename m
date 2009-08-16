Return-path: <linux-media-owner@vger.kernel.org>
Received: from best-of-bremen.com ([217.160.217.225]:53372 "HELO
	p15135933.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750722AbZHPJxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Aug 2009 05:53:30 -0400
From: Martin Konopka <martin.konopka@mknetz.de>
To: linux-media@vger.kernel.org
Subject: Pinnacle 300i antenna power kernel oops
Date: Sun, 16 Aug 2009 11:53:25 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908161153.25302.martin.konopka@mknetz.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

after my failed attempts to activate the external antenna power on an Pinnacle 
310i, I bought a 300i. When I load the module saa7134_dvb with the option 
antenna_pwr = 1 I can indeed measure a voltage at the HF-Socket. But when my 
tv application tries to access the DVB device, I get a kernel oops. I have 
attached the log messages below. I'm using kernel 2.6.28-11-generic SMP 
i686 .

The card works perfectly when the antenna power is disabled.

Thanks for your help!

Martin



[   22.556260] BUG: unable to handle kernel paging request at f84b92d0
[   22.556349] IP: [<f7e8341a>] pinnacle_antenna_pwr+0xda/0x140 [saa7134_dvb]
[   22.556412] *pde = 35d3f067 *pte = 00000000
[   22.556416] Oops: 0000 [#1] SMP
[   22.556500] last sysfs file: /sys/devices/virtual/net/pan0/flags
[   22.556532] Dumping ftrace buffer:
[   22.556563]    (ftrace buffer empty)
[   22.556592] Modules linked in: bridge stp bnep video output input_polldev 
nfsd auth_rpcgss exportfs nfs lockd nfs_acl sunrpc xfs it87 hwmon_vid lp 
mt352 saa7134_dvb videobuf_dvb dvb_core saa7134_alsa mt20xx tea5767 tda9887 
tda8290 tuner snd_seq_dummy snd_seq_oss snd_hda_intel snd_seq_midi saa7134 
snd_rawmidi snd_seq_midi_event snd_pcm_oss snd_mixer_oss ir_common snd_pcm 
videodev snd_seq fglrx(P) v4l1_compat compat_ioctl32 agpgart snd_seq_device 
snd_timer ppdev pcspkr i2c_piix4 v4l2_common videobuf_dma_sg videobuf_core 
tveeprom shpchp snd soundcore snd_page_alloc parport_pc parport usbhid floppy 
ohci1394 r8169 mii ieee1394 fbcon tileblit font bitblit softcursor
[   22.558582]
[   22.558612] Pid: 3361, comm: kdvb-ad-0-fe-0 Tainted: P           
(2.6.28-11-generic #42-Ubuntu) System Product Name
[   22.558646] EIP: 0060:[<f7e8341a>] EFLAGS: 00010282 CPU: 1
[   22.558678] EIP is at pinnacle_antenna_pwr+0xda/0x140 [saa7134_dvb]
[   22.558710] EAX: f84b92d0 EBX: f5dd3000 ECX: 0165f000 EDX: 0000001b
[   22.558741] ESI: f5dd3000 EDI: f5dd3140 EBP: f5f4fe9c ESP: f5f4fe84
[   22.558772]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   22.558803] Process kdvb-ad-0-fe-0 (pid: 3361, ti=f5f4e000 task=f5a0d7f0 
task.ti=f5f4e000)
[   22.558837] Stack:
[   22.558867]  c03e7a3d 00000001 f5f4fed0 f5c4d404 f5c4d404 f5dd3000 f5f4feec 
f7e837af
[   22.559090]  00000000 00000003 000025a0 c012888f f5a0d7f0 f5b48c90 f5f4fee4 
c0102ab7
[   22.559369]  f5a0db2c c1e18280 f5f4feec 00000043 c1e10002 f5f4fedc f1007100 
fffff1cc
[   22.559677] Call Trace:
[   22.559707]  [<c03e7a3d>] ? i2c_transfer+0x6d/0x90
[   22.559770]  [<f7e837af>] ? mt352_pinnacle_tuner_set_params+0xcf/0xe0 
[saa7134_dvb]
[   22.559834]  [<c012888f>] ? dequeue_task+0xcf/0x130
[   22.559894]  [<c0102ab7>] ? __switch_to+0xb7/0x1a0
[   22.559954]  [<f7e9a3b8>] ? mt352_set_parameters+0x2d8/0x410 [mt352]
[   22.560020]  [<c0122d58>] ? default_spin_lock_flags+0x8/0x10
[   22.560081]  [<c0502c0e>] ? _spin_lock_irqsave+0x2e/0x40
[   22.560142]  [<f7f0c871>] ? dvb_frontend_swzigzag_autotune+0xc1/0x240 
[dvb_core]
[   22.560202]  [<c05016e6>] ? schedule_timeout+0x86/0xe0
[   22.560202]  [<c0143db0>] ? process_timeout+0x0/0x10
[   22.560202]  [<f7f0d6e1>] ? dvb_frontend_swzigzag+0x221/0x270 [dvb_core]
[   22.560202]  [<f7f0e037>] ? dvb_frontend_thread+0x397/0x440 [dvb_core]
[   22.560202]  [<c014ecb0>] ? autoremove_wake_function+0x0/0x50
[   22.560202]  [<f7f0dca0>] ? dvb_frontend_thread+0x0/0x440 [dvb_core]
[   22.560202]  [<c014e90c>] ? kthread+0x3c/0x70
[   22.560202]  [<c014e8d0>] ? kthread+0x0/0x70
[   22.560202]  [<c0105477>] ? kernel_thread_helper+0x7/0x10
[   22.560202] Code: c8 8b 93 20 01 00 00 81 c2 b4 01 00 00 8b 02 0d 00 00 00 
10 89 02 b8 c6 a7 00 00 e8 91 96 44 c8 8b 83 20 01 00 00 05 d0 06 00 00 <8b> 
30 a1 88 7f e8 f7 81 e6 00 00 00 08 85 c0 75 22 85 f6 75 15
[   22.560202] EIP: [<f7e8341a>] pinnacle_antenna_pwr+0xda/0x140 [saa7134_dvb] 
SS:ESP 0068:f5f4fe84
