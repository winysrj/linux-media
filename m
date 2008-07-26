Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6QDeNRj021113
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 09:40:23 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6QDeCgv011937
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 09:40:12 -0400
Received: by fg-out-1718.google.com with SMTP id e21so2112089fga.7
	for <video4linux-list@redhat.com>; Sat, 26 Jul 2008 06:40:12 -0700 (PDT)
Message-ID: <b8d38c530807260640t52280fa2rb7ed43cfb023f65e@mail.gmail.com>
Date: Sat, 26 Jul 2008 15:40:12 +0200
From: "Thomas Pegeot" <thomas.pegeot@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <200807202015.05795.thomas.pegeot@gmail.com>
MIME-Version: 1.0
References: <200807202015.05795.thomas.pegeot@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Re: Issue with Hauppauge hvr-1100 and 2.6.26
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,
I still have the same problem with a "newer" kernel (2.6.26-git14).
Does anyone here know what it is wrong ? Is there any way to debug this
problem ?
Thank you.

divide error: 0000 [1] PREEMPT
CPU 0
Modules linked in: w83627hf hwmon_vid cx88_dvb cx88_vp3054_i2c videobuf_dvb
tuner cx88_alsa cx8800 cx8802 cx88xx ir_common i2c_algo_bit tveeprom
videobuf_dma_sg sky2 btcx_risc gspca_zc3xx gspca_main k8temp videobuf_core
i2c_nforce2
Pid: 3679, comm: kdvb-fe-0 Not tainted 2.6.26-git14 #1
RIP: 0010:[<ffffffff8042218d>]  [<ffffffff8042218d>]
simple_dvb_calc_regs+0x99/0x223
RSP: 0018:ffff88002c357d30  EFLAGS: 00010246
RAX: 000000002de54480 RBX: ffff88002c357dc0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff80754200 RDI: ffff88003ed6c810
RBP: ffff88002c357da0 R08: ffff88002c357d76 R09: 0000000000000001
R10: 00007fff6ed97068 R11: 0000000000000202 R12: ffff88003ed6c810
R13: ffff88003ecf4bc0 R14: ffff88003ed6cc08 R15: ffff88003ed6c810
FS:  00007f6966b22750(0000) GS:ffffffff80775180(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f6965da1eb5 CR3: 00000000309df000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kdvb-fe-0 (pid: 3679, threadinfo ffff88002c356000, task
ffff88002c354740)
Stack:  ffff88002c357d50 ffffffffa0039229 ffffffff807e1588 ffff880033b5a108
 ffff88002c357d80 ffffffff8022428c ffffffff80753380 ffff880033b5a0f8
 8e01ffff00003020 ffff88003ecf4bc0 ffff88003ed6c810 0000000000000000
Call Trace:
 [<ffffffffa0039229>] ? i2c_stop+0x45/0x49 [i2c_algo_bit]
 [<ffffffff8022428c>] ? __dequeue_entity+0x61/0x69
 [<ffffffff804224ee>] simple_dvb_set_params+0x3f/0xbe
 [<ffffffff80224aef>] ? finish_task_switch+0x30/0x88
 [<ffffffff804411e2>] cx22702_set_tps+0x28/0x1d0
 [<ffffffff8043cf57>] dvb_frontend_swzigzag_autotune+0x190/0x1b7
 [<ffffffff8043d766>] dvb_frontend_swzigzag+0x1bc/0x21f
 [<ffffffff8043dadd>] dvb_frontend_thread+0x314/0x3f2
 [<ffffffff8043d7c9>] ? dvb_frontend_thread+0x0/0x3f2
 [<ffffffff8023d409>] kthread+0x49/0x76
 [<ffffffff8020bc99>] child_rip+0xa/0x11
 [<ffffffff8023d3c0>] ? kthread+0x0/0x76
 [<ffffffff8020bc8f>] ? child_rip+0x0/0x11


Code: 00 00 48 8b 45 c0 8b 48 1c 48 8b 05 4e ac 43 00 0f b7 40 0a 89 ca 03
45 d0 d1 ea 69 c0 24 f4 00 00 03 05 47 ac 43 00 01 d0 31 d2 <f7> f1 8a 55 d6
88 53 04 41 89 c4 c1 e8 08 88 43 01 8a 45 d7 44
RIP  [<ffffffff8042218d>] simple_dvb_calc_regs+0x99/0x223
 RSP <ffff88002c357d30>
---[ end trace 351d687600d643ff ]---
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
