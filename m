Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ptb-relay03.plus.net ([212.159.14.147])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mayo@clara.co.uk>) id 1LGcEq-0003Fn-0K
	for linux-dvb@linuxtv.org; Sat, 27 Dec 2008 17:42:10 +0100
Received: from [87.114.71.242] (helo=mayos.plus.com)
	by ptb-relay03.plus.net with esmtp (Exim) id 1LGcEI-0002pl-4C
	for linux-dvb@linuxtv.org; Sat, 27 Dec 2008 16:41:34 +0000
Message-ID: <49565ABD.7030209@clara.co.uk>
Date: Sat, 27 Dec 2008 16:41:33 +0000
From: Chris Mayo <mayo@clara.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] general protection fault: 0000 [1] SMP with 2.6.27 and
	2.6.28
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I've been seeing general protection fault's with 2.6.27 and 2.6.28
(gentoo-sources, amd64) used with vdr. Unfortunately I can't reproduce
them on demand.

System has two DVB-T tuners and one full featured DVB-S used for
playback only:
Gigabyte GA-M56S-S3 F3 BIOS & AMD BE-2350
Radeon HD2400 PRO
U.S. Robotics USR997902 PCI Network Card
Nova-T Rev 1.1
Nova-T Rev 1.2
Nexus Rev 2.1

Thanks in advance

Chris


vdr: [5577] switching device 2 to channel 2
DVB: frontend 1 frequency limits undefined - fix the driver
general protection fault: 0000 [1] SMP
CPU 0
Modules linked in: snd_pcm_oss snd_mixer_oss it87 hwmon_vid r8169
dvb_ttpci saa7146_vv videobuf_dma_sg videobuf_core sp8870 budget l64781
ves1x93 budget_ci lnbp21 budget_core saa7146 ttpci_eeprom tda1004x
ir_common tda10023 stv0299 k8temp snd_hda_intel snd_pcm snd_timer snd
snd_page_alloc forcedeth i2c_nforce2
Pid: 5721, comm: kdvb-fe-1 Not tainted 2.6.27-gentoo-r5 #1
RIP: 0010:[<ffffffffa00e8a79>]  [<ffffffffa00e8a79>]
grundig_29504_401_tuner_set_params+0x39/0x100 [budget]
RSP: 0018:ffff88003d3edda0  EFLAGS: 00010202
RAX: ffff88003d3eddb0 RBX: ffff88003e0de000 RCX: 00000000ffffffff
RDX: 2802000000000004 RSI: ffff88003efe5808 RDI: ffff88003efe4010
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003efe5808
vdr: [5720] changing pids of channel 30 from 203+203:407=eng,408=und:0:0
to 203+203:407=eng,408=und:603=eng:0
R13: ffff88003efe4000 R14: 000000001d324372 R15: ffff88003efe59d8
FS:  0000000045a17950(0000) GS:ffffffff80710600(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000f86000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kdvb-fe-1 (pid: 5721, threadinfo ffff88003d3ec000, task
ffff88003f2cd890)
Stack:  0000000400000000 ffff88003d3eddb0 ffff88003f2cd890 7fffffffffffffff
ffff88003efe4010 ffffffffa00e5660 ffff88003d3edec0 ffff88003efe59d8
ffff88003efe59b0 ffffffff8059815d 00000000ffffffff ffff88003efe5800
Call Trace:
[<ffffffffa00e5660>] apply_frontend_param+0x40/0x3e0 [l64781]
[<ffffffff8059815d>] schedule_timeout+0xad/0xf0
[<ffffffff8041c45d>] dvb_frontend_swzigzag_autotune+0xcd/0x220
[<ffffffff80598a2c>] __down_interruptible+0x9c/0xd0
[<ffffffff8041ceba>] dvb_frontend_swzigzag+0x19a/0x290
[<ffffffff802549b6>] down_interruptible+0x36/0x60
[<ffffffff8041d3b8>] dvb_frontend_thread+0x408/0x4c0
[<ffffffff80250570>] autoremove_wake_function+0x0/0x30
[<ffffffff8041cfb0>] dvb_frontend_thread+0x0/0x4c0
[<ffffffff802501b7>] kthread+0x47/0x80
[<ffffffff80232887>] schedule_tail+0x27/0x70
[<ffffffff8020ca49>] child_rip+0xa/0x11
[<ffffffff80250170>] kthread+0x0/0x80
[<ffffffff8020ca3f>] child_rip+0x0/0x11


Code: 97 d0 02 00 00 48 8b 58 38 48 8d 44 24 10 48 85 d2 48 c7 04 24 00
00 00 00 66 c7 44 24 04 04 00 48 89 44 24 08 0f 84 af 00 00 00 <0f> b6
02 66 89 04 24 8b 0e b8 05 3d 95 0c 44 8d 81 48 39 27 02
RIP  [<ffffffffa00e8a79>] grundig_29504_401_tuner_set_params+0x39/0x100
[budget]
RSP <ffff88003d3edda0>
---[ end trace 33ec88b18fe8a71a ]---





vdr: [2391] setting watchdog timer to 60 seconds
DVB: frontend 0 frequency limits undefined - fix the driver
general protection fault: 0000 [1] SMP
CPU 0
Modules linked in: snd_pcm_oss snd_mixer_oss dvb_ttpci snd_hda_intel
saa7146_vv budget_ci snd_pcm budget lnbp21 videobuf_dma_sg l64781
videobuf_core snd_timer budget_core sp8870 saa7146 snd tda1004x
ttpci_eeprom forcedeth ir_common k8temp ves1x93 tda10023 stv0299
i2c_nforce2 r8169 snd_page_alloc
Pid: 2398, comm: kdvb-fe-0 Not tainted 2.6.27-gentoo-r7 #1
RIP: 0010:[<ffffffffa0076a79>]  [<ffffffffa0076a79>]
grundig_29504_401_tuner_set_params+0x39/0x100 [budget]
RSP: 0018:ffff88003c00bda0  EFLAGS: 00010286
RAX: ffff88003c00bdb0 RBX: ffff88003e6ba000 RCX: 00000000ffffffff
RDX: 8008080800000000 RSI: ffff88003e433008 RDI: ffff88003e74cc10
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003e433008
vdr: [2410] CAM 1: no module present
vdr: [2410] CAM 2: no module present
R13: ffff88003e74cc00 R14: 000000002181fb8e R15: ffff88003e4331d8
FS:  00007f98d92a46f0(0000) GS:ffffffff80711600(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000004c7a80 CR3: 000000003d493000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kdvb-fe-0 (pid: 2398, threadinfo ffff88003c00a000, task
ffff88003f29f200)
Stack:  0000000400000000 ffff88003c00bdb0 ffff88003f29f200 7fffffffffffffff
ffff88003e74cc10 ffffffffa006c660 ffff88003c00bec0 ffff88003e4331d8
ffff88003e4331b0 ffffffff8059831d 00000000ffffffff ffff88003e433000
Call Trace:
[<ffffffffa006c660>] apply_frontend_param+0x40/0x3e0 [l64781]
[<ffffffff8059831d>] schedule_timeout+0xad/0xf0
[<ffffffff8041c57d>] dvb_frontend_swzigzag_autotune+0xcd/0x220
[<ffffffff80598bec>] __down_interruptible+0x9c/0xd0
[<ffffffff8041cfda>] dvb_frontend_swzigzag+0x19a/0x290
[<ffffffff802549c6>] down_interruptible+0x36/0x60
[<ffffffff8041d4d8>] dvb_frontend_thread+0x408/0x4c0
[<ffffffff80250580>] autoremove_wake_function+0x0/0x30
[<ffffffff8041d0d0>] dvb_frontend_thread+0x0/0x4c0
[<ffffffff802501c7>] kthread+0x47/0x80
[<ffffffff80232897>] schedule_tail+0x27/0x70
[<ffffffff8020ca49>] child_rip+0xa/0x11
[<ffffffff80250180>] kthread+0x0/0x80
[<ffffffff8020ca3f>] child_rip+0x0/0x11


Code: 97 d0 02 00 00 48 8b 58 38 48 8d 44 24 10 48 85 d2 48 c7 04 24 00
00 00 00 66 c7 44 24 04 04 00 48 89 44 24 08 0f 84 af 00 00 00 <0f> b6
02 66 89 04 24 8b 0e b8 05 3d 95 0c 44 8d 81 48 39 27 02
RIP  [<ffffffffa0076a79>] grundig_29504_401_tuner_set_params+0x39/0x100
[budget]
RSP <ffff88003c00bda0>
---[ end trace 69aa4ae250698950 ]---





vdr: [2403] switching device 2 to channel 14
DVB: adapter 1 frontend 4294670335 frequency limits undefined - fix the
driver
general protection fault: 0000 [#1] SMP
last sysfs file: /sys/class/firmware/0000:01:06.0/loading
CPU 1
Modules linked in: snd_pcm_oss snd_mixer_oss dvb_ttpci snd_hda_intel
saa7146_vv budget videobuf_dma_sg l64781 budget_ci lnbp21 budget_core
videobuf_core saa7146 sp8870 snd_pcm ir_common ves1x93 ttpci_eeprom
tda1004x tda10023 stv0299 snd_timer dvb_core snd k8temp snd_page_alloc
tda827x forcedeth r8169 i2c_nforce2
Pid: 2421, comm: kdvb-ad-1-fe--2 Not tainted 2.6.28-gentoo #2
RIP: 0010:[<ffffffffa00ddbc9>]  [<ffffffffa00ddbc9>]
grundig_29504_401_tuner_set_params+0x39/0x100 [budget]
RSP: 0018:ffff88003c94fda0  EFLAGS: 00010282
RAX: ffff88003c94fdb0 RBX: ffff88003e2f9000 RCX: 0000000000000001
RDX: ffdfff7ff5bffff7 RSI: ffff88003ee0ac08 RDI: ffff88003ee0a810
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88003ee0ac08
R13: ffff88003ee0a800 R14: 000000002088c172 R15: ffff88003ee0add8
FS:  00000000434d1950(0000) GS:ffff88003f86a9c0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007fe3e2555000 CR3: 000000003c840000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kdvb-ad-1-fe--2 (pid: 2421, threadinfo ffff88003c94e000, task
ffff88003f956890)
Stack:
0000000400000000 ffff88003c94fdb0 ffff88003f956890 7fffffffffffffff
ffff88003ee0a810 ffffffffa0004660 ffff88003c94fec0 ffff88003ee0add8
ffff88003ee0adb0 ffffffff805bed1d 00000000ffffffff ffff88003ee0ac00
Call Trace:
[<ffffffffa0004660>] apply_frontend_param+0x40/0x3e0 [l64781]
[<ffffffff805bed1d>] schedule_timeout+0xad/0xf0
[<ffffffffa005623d>] dvb_frontend_swzigzag_autotune+0xcd/0x220 [dvb_core]
[<ffffffff805bf75c>] __down_interruptible+0x9c/0xd0
[<ffffffffa005748a>] dvb_frontend_swzigzag+0x19a/0x290 [dvb_core]
[<ffffffff802578c6>] down_interruptible+0x36/0x60
[<ffffffffa00579a0>] dvb_frontend_thread+0x420/0x4d0 [dvb_core]
[<ffffffff80253490>] autoremove_wake_function+0x0/0x30
[<ffffffffa0057580>] dvb_frontend_thread+0x0/0x4d0 [dvb_core]
[<ffffffff802530e7>] kthread+0x47/0x80
[<ffffffff802354f7>] schedule_tail+0x27/0x70
[<ffffffff8020c9a9>] child_rip+0xa/0x11
[<ffffffff802530a0>] kthread+0x0/0x80
[<ffffffff8020c99f>] child_rip+0x0/0x11
Code: 97 e0 02 00 00 48 8b 58 38 48 8d 44 24 10 48 85 d2 48 c7 04 24 00
00 00 00 66 c7 44 24 04 04 00 48 89 44 24 08 0f 84 af 00 00 00 <0f> b6
02 66 89 04 24 8b 0e b8 05 3d 95 0c 44 8d 81 48 39 27 02
RIP  [<ffffffffa00ddbc9>] grundig_29504_401_tuner_set_params+0x39/0x100
[budget]
RSP <ffff88003c94fda0>
---[ end trace 03be0cf97d6717a0 ]---




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
