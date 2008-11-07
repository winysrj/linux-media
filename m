Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <steweg@gmail.com>) id 1KySTo-0004gO-8A
	for linux-dvb@linuxtv.org; Fri, 07 Nov 2008 15:38:33 +0100
Received: by yx-out-2324.google.com with SMTP id 8so487372yxg.41
	for <linux-dvb@linuxtv.org>; Fri, 07 Nov 2008 06:38:27 -0800 (PST)
Message-ID: <b1ac3a660811070638n32f32372tb032c73d971e2a3f@mail.gmail.com>
Date: Fri, 7 Nov 2008 15:38:27 +0100
From: "=?ISO-8859-2?Q?=A9tefan_Gula?=" <steweg@ynet.sk>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] NULL pointer dereference
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

I am currently trying to make my new Mantis card running on Gentoo
linux with kernel 2.6.25 x86_64. I was able to compile driver (got the
latest from site http://jusst.de/hg/mantis) and load modules
but when I try to tune it creates kernel OOPS about NULL pointer
dereferencing (see the dmesg log below).

Thanks for any help.

lspci -vvvn:
05:00.0 0480: 1822:4e35 (rev 01)
       Subsystem: 1ae4:0002
       Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
       Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
       Latency: 64 (2000ns min, 63750ns max)
       Interrupt: pin A routed to IRQ 16
       Region 0: Memory at fafff000 (32-bit, prefetchable) [size=4K]
       Kernel driver in use: Mantis
       Kernel modules: mantis



dmesg log:
Unable to handle kernel NULL pointer dereference at 0000000000000038 RIP:
 [<ffffffff88026752>] :mantis:philips_cu1216_tuner_set+0x1e/0x264
PGD 0
Oops: 0000 [1] SMP
CPU 3
Modules linked in: i2c_i801 cu1216 mantis lnbp21 mb86a16 stb6100
tda10021 tda100                                              23
stb0899 stv0299
Pid: 5250, comm: kdvb-fe-0 Not tainted 2.6.24-gentoo-r8 #1
RIP: 0010:[<ffffffff88026752>]  [<ffffffff88026752>]
:mantis:philips_cu1216_tune
 r_set+0x1e/0x264
RSP: 0018:ffff81006ce13dc0  EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff81013d2af010 RCX: 0000000000000001
RDX: 0000000000000001 RSI: ffff81013d930808 RDI: ffff81013d2af010
RBP: ffff81013d2af010 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff81013d930808
R13: ffff81013d2af000 R14: 0000000000000003 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff81013fab6940(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000038 CR3: 000000013c412000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kdvb-fe-0 (pid: 5250, threadinfo ffff81006ce12000, task
ffff810120139040                                              )
Stack:  0000000000000286 ffffffff8023c7d1 ffff81006ce12000 ffff81006ce13e30
 00000000ffffffff ffff81013d2af010 ffff81013d930808 0000000000000001
 ffff81013d2af000 ffffffff8800e543 ffff81013d930800 ffff81013d2af010
Call Trace:
 [<ffffffff8023c7d1>] lock_timer_base+0x24/0x49
 [<ffffffff8800e543>] :tda10023:tda10023_set_parameters+0x36/0x297
 [<ffffffff80429834>] dvb_frontend_swzigzag_autotune+0x188/0x1a5
 [<ffffffff80429a08>] dvb_frontend_swzigzag+0x1b7/0x216
 [<ffffffff80429d63>] dvb_frontend_thread+0x296/0x310
 [<ffffffff80246f4d>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80246f4d>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80429acd>] dvb_frontend_thread+0x0/0x310
 [<ffffffff802469f4>] kthread+0x3d/0x63
 [<ffffffff8020c498>] child_rip+0xa/0x12
 [<ffffffff802469b7>] kthread+0x0/0x63
 [<ffffffff8020c48e>] child_rip+0x0/0x12


Code: 4c 8b 68 38 76 0e 48 c7 c7 5d 98 02 88 31 c0 e8 32 eb 20 f8
RIP  [<ffffffff88026752>] :mantis:philips_cu1216_tuner_set+0x1e/0x264
 RSP <ffff81006ce13dc0>
CR2: 0000000000000038
---[ end trace 442dec1c5f34bbe9 ]---

-- 
Stefan Gula
CCNP, CCIP

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
