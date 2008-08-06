Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7616QaN016034
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 21:06:36 -0400
Received: from ik-out-1112.google.com (ik-out-1112.google.com [66.249.90.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m76150J6011744
	for <video4linux-list@redhat.com>; Tue, 5 Aug 2008 21:05:21 -0400
Received: by ik-out-1112.google.com with SMTP id c30so5401329ika.3
	for <video4linux-list@redhat.com>; Tue, 05 Aug 2008 18:04:50 -0700 (PDT)
Message-ID: <de8cad4d0808051804l13d1b66cs9df26cc43ba6cfd6@mail.gmail.com>
Date: Tue, 5 Aug 2008 21:04:50 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: CX18 Oops
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

Hi All

I am running kernel 2.6.26 on  Ubuntu 8.04. Any thoughts?

Thanks in advance

Brandon

[35037.080230] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000000
[35037.080258] IP: [<ffffffffa01e4180>] :cx18:cx18_queue_move_buf+0x0/0xa0
[35037.080284] PGD 21b9e9067 PUD 218c12067 PMD 0
[35037.080298] Oops: 0000 [1] PREEMPT SMP
[35037.080311] CPU 1
[35037.080320] Modules linked in: binfmt_misc iptable_filter ip_tables
x_tables xfs loop mxl5005s s5h1409 tuner_simple ipv6 tuner_types
cs5345 tuner usbhid cx18 dvb_core hid compat_ioctl32 videodev
v4l1_compat i2c_algo_bit cx2341x v4l2_common tveeprom psmouse i2c_core
button ext3 jbd mbcache sd_mod ahci libata scsi_mod iTCO_wdt dock
r8169 ehci_hcd uhci_hcd usbcore raid10 raid456 async_xor async_memcpy
async_tx xor raid1 raid0 multipath linear md_mod dm_mirror dm_log
dm_snapshot dm_mod thermal processor fan fuse
[35037.080488] Pid: 15894, comm: java Not tainted 2.6.26-server-sagetv #1
[35037.080499] RIP: 0010:[<ffffffffa01e4180>]  [<ffffffffa01e4180>]
:cx18:cx18_queue_move_buf+0x0/0xa0
[35037.080521] RSP: 0018:ffff810217c4be50  EFLAGS: 00010046
[35037.080530] RAX: 00000000003d0000 RBX: 0000000000000000 RCX: 0000000000000001
[35037.080541] RDX: ffff81021d9a81f8 RSI: 0000000000000000 RDI: ffff81021d9a8188
[35037.080552] RBP: ffff81021d9a81f8 R08: 0000000000000000 R09: 000000000009d548
[35037.080563] R10: 000000000009d547 R11: 0000000000000002 R12: 0000000000000001
[35037.080574] R13: 0000000000020000 R14: 0000000000000000 R15: ffff81021d9a8188
[35037.080585] FS:  0000000000000000(0000) GS:ffff81021fc06580(0063)
knlGS:00000000c9efbb90
[35037.080601] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[35037.080611] CR2: 0000000000000000 CR3: 00000002179b8000 CR4: 00000000000006a0
[35037.080622] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[35037.080633] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[35037.080644] Process java (pid: 15894, threadinfo ffff810217c4a000,
task ffff81020ad6c620)
[35037.080659] Stack:  ffffffffa01e42c2 00000000003d0000
ffff81021d9a81b0 0000000000000292
[35037.080682]  000000011d9a81f8 ffff8102003d0000 ffff81021d9a8188
ffff81021d9a8000
[35037.080703]  ffff81021d9a8188 ffff81021d9a8128 ffff81021fd15600
0000000000000000
[35037.080719] Call Trace:
[35037.080736]  [<ffffffffa01e42c2>] ? :cx18:cx18_queue_move+0xa2/0x160
[35037.080752]  [<ffffffffa01e58e8>] ? :cx18:cx18_release_stream+0x78/0xc0
[35037.080767]  [<ffffffffa01e5d86>] ? :cx18:cx18_v4l2_close+0xb6/0x150
[35037.080781]  [<ffffffff802a88d1>] ? __fput+0xb1/0x1d0
[35037.080792]  [<ffffffff802a5404>] ? filp_close+0x54/0x90
[35037.080803]  [<ffffffff802a6c1f>] ? sys_close+0x9f/0x110
[35037.080815]  [<ffffffff80226c02>] ? sysenter_do_call+0x1b/0x66
[35037.080826]  [<ffffffff80315060>] ? dummy_file_free_security+0x0/0x10
[35037.080839]
[35037.080845]
[35037.080852] Code: 74 22 31 c9 0f 1f 80 00 00 00 00 48 89 c8 48 03
47 28 8b 10 0f ca 89 10 8d 41 04 48 83 c1 04 39 47 30 77 e7 f3 c3 0f
1f 44 00 00 <4c> 8b 0e 49 89 d2 49 8b 41 08 49 8b 11 48 89 42 08 48 89
10 49
[35037.080976] RIP  [<ffffffffa01e4180>] :cx18:cx18_queue_move_buf+0x0/0xa0
[35037.080992]  RSP <ffff810217c4be50>
[35037.081000] CR2: 0000000000000000
[35037.081192] ---[ end trace 10100555b3a0d104 ]---
[35037.090147] note: java[15894] exited with preempt_count 1

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
