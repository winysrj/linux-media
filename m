Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:53295 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZKOSof (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2009 13:44:35 -0500
Received: from IO.local (61-140.4-85.fix.bluewin.ch [85.4.140.61])
	(authenticated bits=0)
	by smtp1.infomaniak.ch (8.14.2/8.14.2) with ESMTP id nAFIcrq9002488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 15 Nov 2009 19:39:00 +0100
Message-ID: <4B004ABD.9090903@deckpoint.ch>
Date: Sun, 15 Nov 2009 19:38:53 +0100
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Ubuntu karmic, 2.6.31-14 + KNC1 DVB-S2 = GPF
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello all,

It would appear that since I've upgraded to Ubuntu Karmic and the 
2.6.31-14 kernel, my KNC1 DVB-S2 now enjoys a GPF when I use scan-s2.

Card seems to initialise without any issues as it did with previous kernels:
[    8.053229] saa7146: found saa7146 @ mem ffffc900021f8400 (revision 
1, irq 23) (0x1894,0x0019).
[    8.053233] saa7146 (1): dma buffer size 192512
[    8.053235] DVB: registering new adapter (KNC1 DVB-S2)
[    8.120878] adapter failed MAC signature check
[    8.120880] encoded MAC from EEPROM was 
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
[    8.430350] KNC1-2: MAC addr = 00:09:d6:65:2d:91
[    8.610008] saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting 
for end of xfer
[    8.734457] stb0899_attach: Attaching STB0899
[    8.768481] tda8261_attach: Attaching TDA8261 8PSK/QPSK tuner
[    8.768485] DVB: registering adapter 2 frontend 0 (STB0899 
Multistandard)...

Once I launch scan-s2:
scan-s2 -vvvv -a 2 -s 1 -l UNIVERSAL /usr/share/dvb/dvb-s/Hotbird-13.0E

I see the following via dmesg:

[  435.040017] saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting 
for end of xfer
[  435.778648] tda8261_get_bandwidth: Bandwidth=40000000
[  435.781781] tda8261_get_bandwidth: Bandwidth=40000000
[  435.783311] tda8261_set_state: Step size=1, Divider=1000, PG=0x793 (1939)
[  435.783512] tda8261_set_state: Waiting to Phase LOCK
[  435.810134] tda8261_get_status: Tuner Phase Locked
[  435.810137] tda8261_set_state: Tuner Phase locked: status=1
[  435.810139] tda8261_set_frequency: Frequency=1939000
[  435.810141] tda8261_get_frequency: Frequency=7574
[  435.830008] tda8261_get_bandwidth: Bandwidth=40000000
[  436.402814] tda8261_get_bandwidth: Bandwidth=40000000
[  436.405946] tda8261_get_bandwidth: Bandwidth=40000000
[  436.407458] general protection fault: 0000 [#1] SMP
[  436.407527] last sysfs file: 
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
[  436.407560] CPU 0
[  436.407601] Modules linked in: tda8261 stb0899 dvb_pll mt352 lnbp21 
budget_av saa7146_vv snd_hda_codec_realtek videodev stv0299 v4l1_compat 
coretemp snd_hda_intel v4l2_compat_ioctl32 i915 videobuf_dma_sg 
b2c2_flexcop_pci snd_hda_codec budget_ci videobuf_core b2c2_flexcop 
ir_common w83627ehf drm snd_hwdep cx24123 budget_core hwmon_vid snd_pcm 
cx24113 dvb_core iptable_filter snd_timer i2c_algo_bit ip_tables saa7146 
s5h1420 snd ttpci_eeprom soundcore intel_agp video serio_raw pcspkr lp 
snd_page_alloc x_tables output parport pata_it8213 e1000e
[  436.408757] Pid: 1410, comm: kdvb-ad-2-fe-0 Not tainted 
2.6.31-14-server #48-Ubuntu C2SBC-Q
[  436.408818] RIP: 0010:[<ffffffffa00241a1>]  [<ffffffffa00241a1>] 
tda8261_set_state+0x51/0x250 [tda8261]
[  436.408903] RSP: 0018:ffff88013649bc70  EFLAGS: 00010283
[  436.408945] RAX: 00000000000f1748 RBX: ffff880138870680 RCX: 
0000000000000018
[  436.408990] RDX: ffff88013649bcd0 RSI: 0000000000000001 RDI: 
ffff880135273010
[  436.409035] RBP: ffff88013649bcc0 R08: 0000000000000001 R09: 
0000000000000002
[  436.409081] R10: ffff88013649bc40 R11: 0000000055555556 R12: 
00000000001d9638
[  436.409126] R13: 38ffffffa0261568 R14: 0000000000000000 R15: 
ffff880135273010
[  436.409172] FS:  0000000000000000(0000) GS:ffff880028022000(0000) 
knlGS:0000000000000000
[  436.409232] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  436.409274] CR2: 00007fff925e4cd8 CR3: 000000013642a000 CR4: 
00000000000406f0
[  436.409320] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  436.409365] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  436.409411] Process kdvb-ad-2-fe-0 (pid: 1410, threadinfo 
ffff88013649a000, task ffff88013658ad60)
[  436.409473] Stack:
[  436.409508]  ffff880136ee2af1 00000000bcd5d166 ffff000200000068 
0000000035273000
[  436.409608] <0> 0000000000000001 ffff880135273000 ffffffffa0265260 
00003473bc000000
[  436.409758] <0> 0000000000000000 ffff88013a4e05e0 ffff88013649bd00 
ffffffffa025f133
[  436.409938] Call Trace:
[  436.409978]  [<ffffffffa025f133>] tda8261_set_frequency+0x23/0x70 
[budget_av]
[  436.410027]  [<ffffffffa026ed09>] ? stb0899_i2c_gate_ctrl+0x49/0xf0 
[stb0899]
[  436.410074]  [<ffffffffa026e259>] ? stb0899_write_reg+0x19/0x20 [stb0899]
[  436.410121]  [<ffffffffa02716e2>] stb0899_dvbs_algo+0x3a2/0x13c8 
[stb0899]
[  436.410170]  [<ffffffff813cdd0d>] ? i2c_transfer+0xbd/0x100
[  436.410215]  [<ffffffffa026e13c>] ? stb0899_write_regs+0xac/0x1b0 
[stb0899]
[  436.410262]  [<ffffffffa026f239>] stb0899_search+0x489/0x750 [stb0899]
[  436.410308]  [<ffffffff8107d153>] ? down_interruptible+0x33/0x60
[  436.410360]  [<ffffffffa00c34ec>] dvb_frontend_thread+0x57c/0x720 
[dvb_core]
[  436.410407]  [<ffffffff81078620>] ? autoremove_wake_function+0x0/0x40
[  436.410457]  [<ffffffffa00c2f70>] ? dvb_frontend_thread+0x0/0x720 
[dvb_core]
[  436.410504]  [<ffffffff81078236>] kthread+0xa6/0xb0
[  436.410547]  [<ffffffff810130aa>] child_rip+0xa/0x20
[  436.410589]  [<ffffffff81078190>] ? kthread+0x0/0xb0
[  436.410631]  [<ffffffff810130a0>] ? child_rip+0x0/0x20
[  436.410672] Code: 00 03 00 00 4c 8b 6b 10 c7 45 cc 00 00 00 00 0f 84 
e8 01 00 00 44 8b 22 41 8d 84 24 10 81 f1 ff 3d 80 4f 12 00 0f 87 af 01 
00 00 <41> 8b 75 04 31 d2 48 c7 c7 d8 46 02 a0 89 f0 8b 0c 85 f0 45 02
[  436.411950] RIP  [<ffffffffa00241a1>] tda8261_set_state+0x51/0x250 
[tda8261]
[  436.412015]  RSP <ffff88013649bc70>
[  436.412064] ---[ end trace c1d7ae4d9e05c51b ]---

Has anyone else come across this issue with a KNC1 card? Any suggestions 
what I can do to trace the issue?

Regards,
Thomas

