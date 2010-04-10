Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-1.ramapo.edu ([192.107.108.40]:51401 "EHLO
	smtp-1.ramapo.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0DJBho (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Apr 2010 21:37:44 -0400
Received: from smtp-1.ramapo.edu (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 2D24524E218
	for <linux-media@vger.kernel.org>; Fri,  9 Apr 2010 21:28:41 -0400 (EDT)
Received: from [10.0.0.2] (unknown [172.16.111.12])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-1.ramapo.edu (Postfix) with ESMTPSA id AD95A24E1CE
	for <linux-media@vger.kernel.org>; Fri,  9 Apr 2010 21:28:40 -0400 (EDT)
Message-ID: <4BBFD448.7060301@gmail.com>
Date: Fri, 09 Apr 2010 21:28:40 -0400
From: Darren Blaber <dmbtech@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: OOPS: cx18
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recieved an oops today while loading the cx18 driver:
[342153.973342] cx18:  Start initialization, version 1.4.0
[342153.974007] cx18-0: Initializing card 0
[342153.974012] cx18-0: Autodetected Hauppauge card
[342153.974451] cx18 0000:07:01.0: PCI INT A -> GSI 17 (level, low) -> 
IRQ 17
[342153.976826] cx18-0: cx23418 revision 01010000 (B)
[342154.197416] tveeprom 0-0050: Hauppauge model 74041, rev C6B2, 
serial# 7037045
[342154.197420] tveeprom 0-0050: MAC address is 00:0d:fe:6b:60:75
[342154.197424] tveeprom 0-0050: tuner model is TCL M2523_5N_E (idx 112, 
type 50)
[342154.197427] tveeprom 0-0050: TV standards NTSC(M) (eeprom 0x08)
[342154.197430] tveeprom 0-0050: audio processor is CX23418 (idx 38)
[342154.197433] tveeprom 0-0050: decoder processor is CX23418 (idx 31)
[342154.197435] tveeprom 0-0050: has no radio, has IR receiver, has IR 
transmitter
[342154.197439] cx18-0: Autodetected Hauppauge HVR-1600
[342154.197441] cx18-0: Simultaneous Digital and Analog TV capture supported
[342154.280378] IRQ 17/cx18-0: IRQF_DISABLED is not guaranteed on shared 
IRQs
[342154.292388] tuner 1-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
[342154.305399] cs5345 0-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
[342154.371726] tuner-simple 1-0061: creating new instance
[342154.371731] tuner-simple 1-0061: type set to 50 (TCL 2002N)
[342154.380824] cx18-0: Couldn't allocate buffers for encoder YUV stream
[342154.381088] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000008
[342154.381092] IP: [<ffffffffa0763ba0>] cx18_queue_flush+0x60/0xf0 [cx18]
[342154.381106] PGD 0
[342154.381109] Oops: 0000 [#1] SMP
[342154.381112] last sysfs file: 
/sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/block/sdc/sdc1/stat
[342154.381116] CPU 0
[342154.381118] Modules linked in: tuner_simple tuner_types cs5345 tuner 
cx18(+) dvb_core cbc cryptd aes_x86_64 aes_generic ecb usblp 
nls_iso8859_1 nls_cp437 vfat fat usb_storage binfmt_misc vboxdrv 
kvm_intel kvm vmnet ppdev parport_pc vmblock vsock vmci vmmon cx8800 
cx88xx ivtv cx2341x bttv v4l2_common videodev v4l1_compat 
v4l2_compat_ioctl32 ir_common i2c_algo_bit videobuf_dma_sg videobuf_core 
btcx_risc tveeprom ir_core lirc_i2c lirc_dev snd_hda_codec_atihdmi 
snd_hda_codec_realtek snd_seq_dummy snd_hda_intel snd_seq_oss 
snd_hda_codec snd_seq_midi snd_hwdep snd_rawmidi snd_pcm_oss 
snd_seq_midi_event snd_mixer_oss snd_pcm snd_seq iptable_filter 
snd_timer snd_seq_device lp ip_tables snd x_tables parport soundcore 
snd_page_alloc asus_atk0110 fglrx(P) dm_raid45 xor ohci1394 usbhid 
ieee1394 r8169 mii
[342154.381180] Pid: 31669, comm: work_for_cpu Tainted: P           
2.6.31-19-generic #56-Ubuntu System Product Name
[342154.381183] RIP: 0010:[<ffffffffa0763ba0>]  [<ffffffffa0763ba0>] 
cx18_queue_flush+0x60/0xf0 [cx18]
[342154.381192] RSP: 0018:ffff880193dcdc70  EFLAGS: 00010282
[342154.381195] RAX: 0000000000000000 RBX: ffff880144e52220 RCX: 
ffff8800273c2800
[342154.381197] RDX: ffff880144e52208 RSI: ffff880144e52218 RDI: 
ffff880144e52220
[342154.381200] RBP: ffff880193dcdc90 R08: 0000000000000000 R09: 
0000000000000000
[342154.381202] R10: 0000000000000390 R11: 0000000000000001 R12: 
ffff880144e521e0
[342154.381205] R13: ffff880144e521c8 R14: ffff880144e52208 R15: 
0000000000000000
[342154.381208] FS:  0000000000000000(0000) GS:ffff880028034000(0000) 
knlGS:0000000000000000
[342154.381211] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[342154.381213] CR2: 0000000000000008 CR3: 0000000001001000 CR4: 
00000000000026f0
[342154.381216] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[342154.381219] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[342154.381222] Process work_for_cpu (pid: 31669, threadinfo 
ffff880193dcc000, task ffff8800024edac0)
[342154.381224] Stack:
[342154.381225]  ffff880144e52220 ffff880144e52138 ffff880144e52208 
000000000000003f
[342154.381229] <0> ffff880193dcdcc0 ffffffffa0763cae ffff8801965ff5c0 
ffff880144e52138
[342154.381234] <0> ffff880144e52208 0000000000000006 ffff880193dcdcf0 
ffffffffa0763e20
[342154.381239] Call Trace:
[342154.381248]  [<ffffffffa0763cae>] cx18_unload_queues+0x2e/0xf0 [cx18]
[342154.381256]  [<ffffffffa0763e20>] cx18_stream_free+0x30/0x120 [cx18]
[342154.381265]  [<ffffffffa0765747>] cx18_streams_cleanup+0xe7/0x120 [cx18]
[342154.381273]  [<ffffffffa0765d62>] cx18_streams_setup+0x332/0x3c0 [cx18]
[342154.381282]  [<ffffffffa07734c5>] cx18_probe+0x134f/0x148a [cx18]
[342154.381289]  [<ffffffff8101062b>] ? __switch_to+0xcb/0x370
[342154.381294]  [<ffffffff8104f025>] ? finish_task_switch+0x65/0x120
[342154.381301]  [<ffffffff81073e50>] ? do_work_for_cpu+0x0/0x30
[342154.381306]  [<ffffffff8128e462>] local_pci_probe+0x12/0x20
[342154.381310]  [<ffffffff81073e63>] do_work_for_cpu+0x13/0x30
[342154.381314]  [<ffffffff810785d6>] kthread+0xa6/0xb0
[342154.381317]  [<ffffffff810130ea>] child_rip+0xa/0x20
[342154.381321]  [<ffffffff81078530>] ? kthread+0x0/0xb0
[342154.381324]  [<ffffffff810130e0>] ? child_rip+0x0/0x20
[342154.381326] Code: 84 a3 00 00 00 4c 8d 66 18 49 8d 5e 18 4c 89 e7 e8 
b6 60 dc e0 48 89 df e8 ae 60 dc e0 49 8b 45 00 49 39 c5 74 56 49 8d 76 
10 90 <48> 8b 50 08 48 8b 08 48 89 51 08 48 89 0a 49 8b 56 08 49 89 46
[342154.381360] RIP  [<ffffffffa0763ba0>] cx18_queue_flush+0x60/0xf0 [cx18]
[342154.381369]  RSP <ffff880193dcdc70>
[342154.381371] CR2: 0000000000000008
[342154.381374] ---[ end trace fd704337e629f4b4 ]---

