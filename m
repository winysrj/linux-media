Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37293 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab3LSBjQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 20:39:16 -0500
Message-ID: <1387417215.2011.5.camel@palomino.walls.org>
Subject: Re: [ivtv-users] Kernel crash with modprobe cx18
From: Andy Walls <awalls@md.metrocast.net>
To: User discussion about IVTV <ivtv-users@ivtvdriver.org>
Cc: linux-media@vger.kernel.org
Date: Wed, 18 Dec 2013 20:40:15 -0500
In-Reply-To: <CAL0vL9x-zWXVdyffrtfczkOHjmf9qUcf_Eeqqzew8Xw+F9Hy+Q@mail.gmail.com>
References: <CAL0vL9x-zWXVdyffrtfczkOHjmf9qUcf_Eeqqzew8Xw+F9Hy+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2013-12-18 at 13:06 -0600, Scott Robinson wrote:
> I am running Fedora 18, x86_64, and recently updated the kernel to
> 3.11.10-100.fc18 from 3.6.10-4.fc18.
> 
> When I try to install the cx18 module, the kernel crashes with the following:

Can you provide the output of 

	$ objdump -d -l -F /lib/modules/3.11.10-100.fc18.x86_64/kernel/drivers/media/common/tuners/tda8290.ko

for the first few screenfuls of the tda829x_attach function?

I can match that up with the kernel v3.10 source code and see what
pointer is NULL.

Regards,
Andy


> [  495.361662] netconsole: network logging started
> [  558.481787] media: Linux media interface: v0.10
> [  558.502941] Linux video capture interface: v2.00
> [  558.617145] cx18:  Start initialization, version 1.5.1
> [  558.617237] cx18-0: Initializing card 0
> [  558.617271] cx18-0:  info: Stream type 0 options: 2 MB, 64 buffers,
> 32768 bytes
> [  558.617290] cx18-0:  info: Stream type 1 options: 1 MB, 32 buffers,
> 32768 bytes
> [  558.617300] cx18-0:  info: Stream type 2 options: 2 MB, 20 buffers,
> 103680 bytes
> [  558.617314] cx18-0:  info: Stream type 3 options: 1 MB, 20 buffers,
> 51984 bytes
> [  558.617322] cx18-0:  info: Stream type 4 options: 1 MB, 256
> buffers, 4096 bytes
> [  558.617336] cx18-0:  info: Stream type 5 options: 0 MB, 63 buffers,
> 1536 bytes
> [  558.617345] cx18-0: Autodetected Hauppauge card
> [  558.617434] cx18-0:  info: base addr: 0xf8000000
> [  558.617442] cx18-0:  info: Enabling pci device
> [  558.617639] cx18-0:  info: cx23418 (rev 0) at 03:00.0, irq: 20,
> latency: 64, memory: 0xf8000000
> [  558.617649] cx18-0:  info: attempting ioremap at 0xf8000000 len 0x04000000
> [  558.626564] cx18-0: cx23418 revision 01010000 (B)
> [  558.724970] cx18-0:  info: GPIO initial dir: 0000ffff/0000ffff out:
> 00000000/00000000
> [  558.725076] cx18-0:  info: activating i2c...
> [  558.725084] cx18-0:  i2c: i2c init
> [  558.858738] tveeprom 6-0050: Hauppauge model 74351, rev F1F5, serial# 7764125
> [  558.858766] tveeprom 6-0050: MAC address is 00:0d:fe:76:78:9d
> [  558.858790] tveeprom 6-0050: tuner model is NXP 18271C2 (idx 155, type 54)
> [  558.858801] tveeprom 6-0050: TV standards PAL(B/G) NTSC(M) PAL(I)
> SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> [  558.858817] tveeprom 6-0050: audio processor is CX23418 (idx 38)
> [  558.858825] tveeprom 6-0050: decoder processor is CX23418 (idx 31)
> [  558.858839] tveeprom 6-0050: has no radio
> [  558.858847] cx18-0: Autodetected Hauppauge HVR-1600
> [  558.858860] cx18-0:  info: Worldwide tuner detected
> [  558.858882] cx18-0:  info: GPIO initial dir: 0000cffe/0000ffff out:
> 00003001/00000000
> [  558.908552] cx18-0: Simultaneous Digital and Analog TV capture supported
> [  559.075778] tuner 7-0042: Tuner -1 found with type(s) Radio TV.
> [  559.098598] cs5345 6-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
> [  559.105203] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000202
> [  559.109526] IP: [<ffffffffa04facae>] tda829x_attach+0x6e/0xba0 [tda8290]
> [  559.113832] PGD 0
> [  559.118058] Oops: 0000 [#1] SMP
> [  559.122219] Modules linked in: cs5345 tda8290 tuner cx18(+)
> videobuf_vmalloc tveeprom cx2341x videobuf_core dvb_core v4l2_common
> videodev media netconsole nfsv4 dns_resolver nfs lockd fscache
> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq
> snd_seq_device snd_pcm snd_page_alloc ppdev kvm_amd kvm sp5100_tco
> snd_timer snd soundcore shpchp parport_pc parport microcode serio_raw
> edac_core k10temp edac_mce_amd acpi_cpufreq mperf i2c_piix4 uinput
> ata_generic pata_acpi radeon i2c_algo_bit drm_kms_helper pata_atiixp
> ttm r8169 drm mii i2c_core sunrpc
> [  559.137276] CPU: 0 PID: 26 Comm: kworker/0:1 Not tainted
> 3.11.10-100.fc18.x86_64 #1
> [  559.142306] Hardware name: FOXCONN A6VMX/A6VMX, BIOS 080014  06/03/2009
> [  559.147406] Workqueue: events work_for_cpu_fn
> [  559.152497] task: ffff880121ef9e80 ti: ffff8801219a0000 task.ti:
> ffff8801219a0000
> [  559.157655] RIP: 0010:[<ffffffffa04facae>]  [<ffffffffa04facae>]
> tda829x_attach+0x6e/0xba0 [tda8290]
> [  559.162964] RSP: 0018:ffff8801219a1b68  EFLAGS: 00010202
> [  559.168238] RAX: ffff88011d3bf060 RBX: ffff88011c734000 RCX: 0000000000000000
> [  559.173537] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88011d3bf0c0
> [  559.178905] RBP: ffff8801219a1bf8 R08: 0000000000016f00 R09: ffff880123401a00
> [  559.184294] R10: ffffffffa04fac87 R11: 0000000000000000 R12: ffff88011d3bf060
> [  559.189662] R13: 0000000000000202 R14: ffff88012099d698 R15: 0000000000000042
> [  559.195081] FS:  00007fc9f1c89840(0000) GS:ffff880127c00000(0000)
> knlGS:0000000000000000
> [  559.200563] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  559.206034] CR2: 0000000000000202 CR3: 0000000001c0c000 CR4: 00000000000007f0
> [  559.211611] Stack:
> [  559.217124]  ffff8801219a1bc8 ffffffff810cc08d ffff88012099d370
> ffffffffa04f6138
> [  559.222852]  ffff8801219a0101 ffffffffa04fe060 0000000000000000
> ffffffffa04fd030
> [  559.228659]  ffff8801219a1c4c ffffffffa04fd030 0000000000000036
> 00000000b58d6d22
> [  559.234345] Call Trace:
> [  559.239922]  [<ffffffff810cc08d>] ? find_symbol+0x3d/0xb0
> [  559.245535]  [<ffffffffa04f3605>] set_type+0x325/0x9f0 [tuner]
> [  559.251177]  [<ffffffffa04c95ca>] ? cx18_i2c_register+0x15a/0x210 [cx18]
> [  559.256814]  [<ffffffffa04f3d6f>] tuner_s_type_addr+0x9f/0x140 [tuner]
> [  559.262494]  [<ffffffffa04c8722>] cx18_probe+0xda2/0x1560 [cx18]
> [  559.268195]  [<ffffffff8133d4ab>] local_pci_probe+0x4b/0x80
> [  559.273897]  [<ffffffff81080da8>] work_for_cpu_fn+0x18/0x30
> [  559.279604]  [<ffffffff8108391a>] process_one_work+0x17a/0x400
> [  559.285341]  [<ffffffff81083bcc>] process_scheduled_works+0x2c/0x40
> [  559.291056]  [<ffffffff81084ed2>] worker_thread+0x262/0x370
> [  559.296787]  [<ffffffff81084c70>] ? manage_workers.isra.21+0x2b0/0x2b0
> [  559.302532]  [<ffffffff8108b3e0>] kthread+0xc0/0xd0
> [  559.308252]  [<ffffffff81010000>] ? perf_trace_xen_mc_callback+0xe0/0xe0
> [  559.314017]  [<ffffffff8108b320>] ? kthread_create_on_node+0x120/0x120
> [  559.319770]  [<ffffffff8167576c>] ret_from_fork+0x7c/0xb0
> [  559.325544]  [<ffffffff8108b320>] ? kthread_create_on_node+0x120/0x120
> [  559.331343] Code: c9 a8 c9 e0 48 85 c0 49 89 c4 0f 84 7e 0a 00 00
> 4d 85 ed 48 89 83 28 03 00 00 44 88 38 4c 89 70 08 48 c7 40 18 87 d4
> 4f a0 74 12 <41> 8b 45 00 41 89 44 24 38 49 8b 45 08 49 89 44 24 48 4d
> 8d 74
> [  559.344343] RIP  [<ffffffffa04facae>] tda829x_attach+0x6e/0xba0 [tda8290]
> [  559.350561]  RSP <ffff8801219a1b68>
> [  559.356632] CR2: 0000000000000202
> [  559.396189] ---[ end trace d9c77bf63cfd8777 ]---
> [  559.398420] BUG: unable to handle kernel paging request at ffffffffffffffd8
> [  559.404868] IP: [<ffffffff8108b6c0>] kthread_data+0x10/0x20
> [  559.411371] PGD 1c0f067 PUD 1c11067 PMD 0
> [  559.417676] Oops: 0000 [#2] SMP
> [  559.423821] Modules linked in: cs5345 tda8290 tuner cx18(+)
> videobuf_vmalloc tveeprom cx2341x videobuf_core dvb_core v4l2_common
> videodev media netconsole nfsv4 dns_resolver nfs lockd fscache
> snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq
> snd_seq_device snd_pcm snd_page_alloc ppdev kvm_amd kvm sp5100_tco
> snd_timer snd soundcore shpchp parport_pc parport microcode serio_raw
> edac_core k10temp edac_mce_amd acpi_cpufreq mperf i2c_piix4 uinput
> ata_generic pata_acpi radeon i2c_algo_bit drm_kms_helper pata_atiixp
> ttm r8169 drm mii i2c_core sunrpc
> [  559.444987] CPU: 0 PID: 26 Comm: kworker/0:1 Tainted: G      D
> 3.11.10-100.fc18.x86_64 #1
> [  559.452106] Hardware name: FOXCONN A6VMX/A6VMX, BIOS 080014  06/03/2009
> [  559.459180] task: ffff880121ef9e80 ti: ffff8801219a0000 task.ti:
> ffff8801219a0000
> [  559.466267] RIP: 0010:[<ffffffff8108b6c0>]  [<ffffffff8108b6c0>]
> kthread_data+0x10/0x20
> [  559.473364] RSP: 0018:ffff8801219a1758  EFLAGS: 00010092
> [  559.480514] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000000f
> [  559.487469] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880121ef9e80
> [  559.494212] RBP: ffff8801219a1758 R08: ffff880121ef9ef0 R09: 000000000000005f
> [  559.500757] R10: 0000000000000001 R11: 0000000000000000 R12: ffff880127c14180
> [  559.507118] R13: 0000000000000000 R14: 0000000000000001 R15: ffff880121ef9e80
> [  559.513429] FS:  00007f73ce1a6980(0000) GS:ffff880127c00000(0000)
> knlGS:0000000000000000
> [  559.519763] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  559.526047] CR2: 0000000000000028 CR3: 000000011dcc0000 CR4: 00000000000007f0
> [  559.532331] Stack:
> [  559.538475]  ffff8801219a1778 ffffffff81085065 ffff8801219a1778
> ffff880121efa190
> [  559.544779]  ffff8801219a17e8 ffffffff8166af62 ffff880121ef9e80
> ffff8801219a1fd8
> [  559.551125]  ffff8801219a1fd8 ffff8801219a1fd8 ffff8801219a17d8
> ffff880121ef9e80
> [  559.557344] Call Trace:
> [  559.563534]  [<ffffffff81085065>] wq_worker_sleeping+0x15/0xa0
> [  559.569761]  [<ffffffff8166af62>] __schedule+0x492/0x7a0
> [  559.575925]  [<ffffffff8166bc99>] schedule+0x29/0x70
> [  559.582047]  [<ffffffff8106bd12>] do_exit+0x6b2/0xa20
> [  559.588098]  [<ffffffff8166e0a2>] oops_end+0xa2/0xf0
> [  559.594098]  [<ffffffff81661fc7>] no_context+0x253/0x27e
> [  559.600051]  [<ffffffff81318e8a>] ? delay_tsc+0x4a/0x80
> [  559.605971]  [<ffffffff816621b2>] __bad_area_nosemaphore+0x1c0/0x1df
> [  559.611958]  [<ffffffff816621e4>] bad_area_nosemaphore+0x13/0x15
> [  559.617885]  [<ffffffff81670f06>] __do_page_fault+0x3a6/0x4f0
> [  559.623767]  [<ffffffff8131e460>] ? bsearch+0x60/0x90
> [  559.629658]  [<ffffffff810cb2e0>] ? mod_find_symname+0x80/0x80
> [  559.635542]  [<ffffffff810cb469>] ? find_symbol_in_section+0x49/0x120
> [  559.641411]  [<ffffffff810cb420>] ? section_objs+0x60/0x60
> [  559.647307]  [<ffffffff810cbc16>] ? each_symbol_section.part.6+0x186/0x1e0
> [  559.653186]  [<ffffffff8167105e>] do_page_fault+0xe/0x10
> [  559.659062]  [<ffffffff8166d4d8>] page_fault+0x28/0x30
> [  559.664950]  [<ffffffffa04fac87>] ? tda829x_attach+0x47/0xba0 [tda8290]
> [  559.670858]  [<ffffffffa04facae>] ? tda829x_attach+0x6e/0xba0 [tda8290]
> [  559.676742]  [<ffffffffa04fac87>] ? tda829x_attach+0x47/0xba0 [tda8290]
> [  559.682581]  [<ffffffff810cc08d>] ? find_symbol+0x3d/0xb0
> [  559.688381]  [<ffffffffa04f3605>] set_type+0x325/0x9f0 [tuner]
> [  559.694200]  [<ffffffffa04c95ca>] ? cx18_i2c_register+0x15a/0x210 [cx18]
> [  559.700050]  [<ffffffffa04f3d6f>] tuner_s_type_addr+0x9f/0x140 [tuner]
> [  559.705866]  [<ffffffffa04c8722>] cx18_probe+0xda2/0x1560 [cx18]
> [  559.711697]  [<ffffffff8133d4ab>] local_pci_probe+0x4b/0x80
> [  559.717304]  [<ffffffff81080da8>] work_for_cpu_fn+0x18/0x30
> [  559.722660]  [<ffffffff8108391a>] process_one_work+0x17a/0x400
> [  559.727981]  [<ffffffff81083bcc>] process_scheduled_works+0x2c/0x40
> [  559.733268]  [<ffffffff81084ed2>] worker_thread+0x262/0x370
> [  559.738544]  [<ffffffff81084c70>] ? manage_workers.isra.21+0x2b0/0x2b0
> [  559.743828]  [<ffffffff8108b3e0>] kthread+0xc0/0xd0
> [  559.749053]  [<ffffffff81010000>] ? perf_trace_xen_mc_callback+0xe0/0xe0
> [  559.754273]  [<ffffffff8108b320>] ? kthread_create_on_node+0x120/0x120
> [  559.759536]  [<ffffffff8167576c>] ret_from_fork+0x7c/0xb0
> [  559.764568]  [<ffffffff8108b320>] ? kthread_create_on_node+0x120/0x120
> [  559.769386] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01
> c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 b8 02 00 00
> 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66
> 66 90
> [  559.779908] RIP  [<ffffffff8108b6c0>] kthread_data+0x10/0x20
> [  559.784720]  RSP <ffff8801219a1758>
> [  559.789434] CR2: ffffffffffffffd8
> [  559.794086] ---[ end trace d9c77bf63cfd8778 ]---
> [  559.794094] Fixing recursive fault but reboot is needed!
> 
> Please advise.
> 
> Scott
> 
> _______________________________________________
> ivtv-users mailing list
> ivtv-users@ivtvdriver.org
> http://ivtvdriver.org/mailman/listinfo/ivtv-users


