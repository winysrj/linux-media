Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55070 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935638AbdEWRjp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 13:39:45 -0400
Date: Wed, 24 May 2017 01:39:35 +0800
From: kernel test robot <fengguang.wu@intel.com>
To: Sean Young <sean@mess.org>
Cc: LKP <lkp@01.org>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        wfg@linux.intel.com
Subject: [[media] sir_ir] 592ddc9f7d:  BUG: unable to handle kernel NULL
 pointer dereference at 00000000000005b8
Message-ID: <592473d7.6iRq9pjNkVk+nmfn%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_592473d7.GhTTSot/dRvRsViweAavdcLadKnMmV0H59rGc5VT3B5pds3h"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--=_592473d7.GhTTSot/dRvRsViweAavdcLadKnMmV0H59rGc5VT3B5pds3h
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master

commit 592ddc9f7db36c778d3bf9ffdfd93d8d5d548e48
Author:     Sean Young <sean@mess.org>
AuthorDate: Tue May 16 04:56:14 2017 -0300
Commit:     Mauro Carvalho Chehab <mchehab@s-opensource.com>
CommitDate: Thu May 18 06:16:41 2017 -0300

    [media] sir_ir: infinite loop in interrupt handler
    
    Since this driver does no detection of hardware, it might be used with
    a non-sir port. Escape out if we are spinning.
    
    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Signed-off-by: Sean Young <sean@mess.org>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

dd8245f445  [media] atomisp: don't treat warnings as errors
592ddc9f7d  [media] sir_ir: infinite loop in interrupt handler
f482797714  Add linux-next specific files for 20170523
+------------------------------------------------------------------+------------+------------+---------------+
|                                                                  | dd8245f445 | 592ddc9f7d | next-20170523 |
+------------------------------------------------------------------+------------+------------+---------------+
| boot_successes                                                   | 33         | 0          | 0             |
| boot_failures                                                    | 2          | 15         | 2             |
| invoked_oom-killer:gfp_mask=0x                                   | 2          |            |               |
| Mem-Info                                                         | 2          |            |               |
| Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes | 2          |            |               |
| BUG:unable_to_handle_kernel                                      | 0          | 14         | 2             |
| Oops:#[##]                                                       | 0          | 14         | 2             |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt            | 0          | 15         | 2             |
| general_protection_fault:#[##]                                   | 0          | 1          |               |
+------------------------------------------------------------------+------------+------------+---------------+

[    2.947120] page_owner is disabled
[    2.949932] Key type encrypted registered
[    2.949932] Key type encrypted registered
[    2.956911] platform sir_ir.0: Trapped in interrupt
[    2.956911] platform sir_ir.0: Trapped in interrupt
[    2.958377] BUG: unable to handle kernel NULL pointer dereference at 00000000000005b8
[    2.958377] BUG: unable to handle kernel NULL pointer dereference at 00000000000005b8
[    2.960689] IP: __lock_acquire+0xdb/0x1280
[    2.960689] IP: __lock_acquire+0xdb/0x1280
[    2.961900] PGD 0 
[    2.961900] PGD 0 
[    2.961903] P4D 0 
[    2.961903] P4D 0 
[    2.962511] 
[    2.962511] 
[    2.963568] Oops: 0000 [#1] PREEMPT
[    2.963568] Oops: 0000 [#1] PREEMPT
[    2.964602] Modules linked in:
[    2.964602] Modules linked in:
[    2.965515] CPU: 0 PID: 1 Comm: swapper Not tainted 4.12.0-rc1-00003-g592ddc9 #1
[    2.965515] CPU: 0 PID: 1 Comm: swapper Not tainted 4.12.0-rc1-00003-g592ddc9 #1
[    2.967675] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
[    2.967675] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
[    2.970647] task: ffff99608f33e540 task.stack: ffff99608f334000
[    2.970647] task: ffff99608f33e540 task.stack: ffff99608f334000
[    2.972382] RIP: 0010:__lock_acquire+0xdb/0x1280
[    2.972382] RIP: 0010:__lock_acquire+0xdb/0x1280
[    2.973746] RSP: 0000:ffffffffacc35cb0 EFLAGS: 00010002
[    2.973746] RSP: 0000:ffffffffacc35cb0 EFLAGS: 00010002
[    2.975277] RAX: 0000000000000046 RBX: 0000000000000001 RCX: 0000000000000000
[    2.975277] RAX: 0000000000000046 RBX: 0000000000000001 RCX: 0000000000000000
[    2.977365] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    2.977365] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    2.979460] RBP: ffffffffacc35d50 R08: 0000000000000001 R09: 0000000000000001
[    2.979460] RBP: ffffffffacc35d50 R08: 0000000000000001 R09: 0000000000000001
[    2.981553] R10: 0000000000000000 R11: ffffffffabcc9fd3 R12: 00000000000005b8
[    2.981553] R10: 0000000000000000 R11: ffffffffabcc9fd3 R12: 00000000000005b8
[    2.983641] R13: ffff99608f33e540 R14: 0000000000000001 R15: 0000000000000000
[    2.983641] R13: ffff99608f33e540 R14: 0000000000000001 R15: 0000000000000000
[    2.985726] FS:  0000000000000000(0000) GS:ffffffffacc32000(0000) knlGS:0000000000000000
[    2.985726] FS:  0000000000000000(0000) GS:ffffffffacc32000(0000) knlGS:0000000000000000
[    2.988089] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.988089] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    2.989776] CR2: 00000000000005b8 CR3: 0000000010617000 CR4: 00000000001406f0
[    2.989776] CR2: 00000000000005b8 CR3: 0000000010617000 CR4: 00000000001406f0
[    2.991866] Call Trace:
[    2.991866] Call Trace:
[    2.992600]  <IRQ>
[    2.992600]  <IRQ>
[    2.993208]  lock_acquire+0xba/0x1c0
[    2.993208]  lock_acquire+0xba/0x1c0
[    2.994271]  ? try_to_wake_up+0x4a/0x530
[    2.994271]  ? try_to_wake_up+0x4a/0x530
[    2.995432]  ? lock_acquire+0xba/0x1c0
[    2.995432]  ? lock_acquire+0xba/0x1c0
[    2.996551]  ? try_to_wake_up+0x33/0x530
[    2.996551]  ? try_to_wake_up+0x33/0x530
[    2.997720]  _raw_spin_lock_irqsave+0x50/0x8b
[    2.997720]  _raw_spin_lock_irqsave+0x50/0x8b
[    2.999008]  ? try_to_wake_up+0x33/0x530
[    2.999008]  ? try_to_wake_up+0x33/0x530
[    3.000167]  try_to_wake_up+0x33/0x530
[    3.000167]  try_to_wake_up+0x33/0x530
[    3.001279]  wake_up_process+0x15/0x20
[    3.001279]  wake_up_process+0x15/0x20
[    3.002391]  ir_raw_event_handle+0x2c/0x40
[    3.002391]  ir_raw_event_handle+0x2c/0x40
[    3.003613]  sir_interrupt+0x248/0x260
[    3.003613]  sir_interrupt+0x248/0x260
[    3.004728]  __handle_irq_event_percpu+0x67/0x410
[    3.004728]  __handle_irq_event_percpu+0x67/0x410
[    3.006119]  handle_irq_event_percpu+0x2b/0x70
[    3.006119]  handle_irq_event_percpu+0x2b/0x70
[    3.007436]  handle_irq_event+0x3e/0x60
[    3.007436]  handle_irq_event+0x3e/0x60
[    3.008578]  handle_edge_irq+0xbc/0x1f0
[    3.008578]  handle_edge_irq+0xbc/0x1f0
[    3.009717]  handle_irq+0x1a/0x30
[    3.009717]  handle_irq+0x1a/0x30
[    3.010700]  do_IRQ+0x65/0x130
[    3.010700]  do_IRQ+0x65/0x130
[    3.011614]  common_interrupt+0x91/0x91
[    3.011614]  common_interrupt+0x91/0x91
[    3.012756] RIP: 0010:_raw_spin_unlock_irqrestore+0x63/0x80
[    3.012756] RIP: 0010:_raw_spin_unlock_irqrestore+0x63/0x80
[    3.014385] RSP: 0000:ffff99608f337a40 EFLAGS: 00000297 ORIG_RAX: ffffffffffffffcb
[    3.014385] RSP: 0000:ffff99608f337a40 EFLAGS: 00000297 ORIG_RAX: ffffffffffffffcb
[    3.016608] RAX: ffff99608f33e540 RBX: 0000000000000297 RCX: 0000000000000006
[    3.016608] RAX: ffff99608f33e540 RBX: 0000000000000297 RCX: 0000000000000006
[    3.018684] RDX: 0000000000000179 RSI: ffff99608f33ebe8 RDI: 0000000000000297
[    3.018684] RDX: 0000000000000179 RSI: ffff99608f33ebe8 RDI: 0000000000000297
[    3.020777] RBP: ffff99608f337a50 R08: 0000000125f23c45 R09: 0000000000000000
[    3.020777] RBP: ffff99608f337a50 R08: 0000000125f23c45 R09: 0000000000000000
[    3.022868] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffae63f320
[    3.022868] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffae63f320
[    3.024961] R13: 0000000000000297 R14: 0000000000000002 R15: 0000000000000000
[    3.024961] R13: 0000000000000297 R14: 0000000000000002 R15: 0000000000000000
[    3.027051]  </IRQ>
[    3.027051]  </IRQ>
[    3.027696]  serial8250_do_startup+0x2f6/0x800
[    3.027696]  serial8250_do_startup+0x2f6/0x800
[    3.029009]  serial8250_startup+0x46/0x60
[    3.029009]  serial8250_startup+0x46/0x60
[    3.030198]  uart_port_startup+0x97/0x1f0
[    3.030198]  uart_port_startup+0x97/0x1f0
[    3.031386]  ? uart_port_startup+0x1f0/0x1f0
[    3.031386]  ? uart_port_startup+0x1f0/0x1f0
[    3.032654]  uart_port_activate+0xa5/0x100
[    3.032654]  uart_port_activate+0xa5/0x100
[    3.033866]  tty_port_open+0x91/0xf0
[    3.033866]  tty_port_open+0x91/0xf0
[    3.034927]  ? uart_proc_open+0x40/0x40
[    3.034927]  ? uart_proc_open+0x40/0x40
[    3.036068]  uart_open+0x46/0x60
[    3.036068]  uart_open+0x46/0x60
[    3.037030]  tty_open+0x133/0x5c0
[    3.037030]  tty_open+0x133/0x5c0
[    3.038021]  ? tty_init_dev+0x240/0x240
[    3.038021]  ? tty_init_dev+0x240/0x240
[    3.039157]  chrdev_open+0xda/0x250
[    3.039157]  chrdev_open+0xda/0x250
[    3.040196]  ? cdev_put+0x40/0x40
[    3.040196]  ? cdev_put+0x40/0x40
[    3.041184]  do_dentry_open+0x2bf/0x420
[    3.041184]  do_dentry_open+0x2bf/0x420
[    3.042528]  vfs_open+0x5a/0xb0
[    3.042528]  vfs_open+0x5a/0xb0
[    3.043467]  path_openat+0x25c/0xf20
[    3.043467]  path_openat+0x25c/0xf20
[    3.044532]  do_filp_open+0xaa/0x130
[    3.044532]  do_filp_open+0xaa/0x130
[    3.045598]  ? __alloc_fd+0x12d/0x280
[    3.045598]  ? __alloc_fd+0x12d/0x280
[    3.046685]  ? __alloc_fd+0x12d/0x280
[    3.046685]  ? __alloc_fd+0x12d/0x280
[    3.047772]  ? preempt_count_sub+0x94/0xf0
[    3.047772]  ? preempt_count_sub+0x94/0xf0
[    3.048991]  ? _raw_spin_unlock+0x31/0x50
[    3.048991]  ? _raw_spin_unlock+0x31/0x50
[    3.050178]  do_sys_open+0x197/0x2e0
[    3.050178]  do_sys_open+0x197/0x2e0
[    3.051236]  ? do_sys_open+0x197/0x2e0
[    3.051236]  ? do_sys_open+0x197/0x2e0
[    3.052346]  SyS_open+0x32/0x40
[    3.052346]  SyS_open+0x32/0x40
[    3.053289]  kernel_init_freeable+0x1d8/0x2d2
[    3.053289]  kernel_init_freeable+0x1d8/0x2d2
[    3.054585]  ? rest_init+0x170/0x170
[    3.054585]  ? rest_init+0x170/0x170
[    3.055646]  kernel_init+0x18/0x170
[    3.055646]  kernel_init+0x18/0x170
[    3.056685]  ? schedule_tail+0x19/0x70
[    3.056685]  ? schedule_tail+0x19/0x70
[    3.057796]  ? rest_init+0x170/0x170
[    3.057796]  ? rest_init+0x170/0x170
[    3.058866]  ret_from_fork+0x31/0x40
[    3.058866]  ret_from_fork+0x31/0x40
[    3.059926] Code: ff 8b 8d 64 ff ff ff 44 8b 8d 60 ff ff ff 75 42 45 31 e4 48 83 c4 70 44 89 e0 5b 41 5a 41 5c 41 5d 41 5e 41 5f 5d 49 8d 62 f8 c3 <49> 81 3c 24 a0 22 0b ad 41 be 00 00 00 00 45 0f 45 f0 83 fe 01 
[    3.059926] Code: ff 8b 8d 64 ff ff ff 44 8b 8d 60 ff ff ff 75 42 45 31 e4 48 83 c4 70 44 89 e0 5b 41 5a 41 5c 41 5d 41 5e 41 5f 5d 49 8d 62 f8 c3 <49> 81 3c 24 a0 22 0b ad 41 be 00 00 00 00 45 0f 45 f0 83 fe 01 
[    3.065518] RIP: __lock_acquire+0xdb/0x1280 RSP: ffffffffacc35cb0
[    3.065518] RIP: __lock_acquire+0xdb/0x1280 RSP: ffffffffacc35cb0
[    3.067305] CR2: 00000000000005b8
[    3.067305] CR2: 00000000000005b8
[    3.068288] ---[ end trace b8db06be04fca3aa ]---
[    3.068288] ---[ end trace b8db06be04fca3aa ]---

                                                          # HH:MM RESULT GOOD BAD GOOD_BUT_DIRTY DIRTY_NOT_BAD
git bisect start 25a6a323286a4ee6c571d219727a864fef8ad63e 08332893e37af6ae779367e78e444f8f9571511d --
git bisect good fc7ec88b1908fa018407073a61223f2b6949b8ff  # 19:00  G     11     0    0   0  Merge 'ath6kl/ath-qca' into devel-spot-201705231457
git bisect good 22debe8516d52f16157d37c3bc3b685093af771c  # 19:55  G     11     0    0   0  Merge 'linux-review/Linus-Walleij/ARM-dma-pl08x-pass-reasonable-memcpy-settings/20170522-180845' into devel-spot-201705231457
git bisect  bad 4d4a11c5c71f5c33dd9975f9b512c10428e22aba  # 20:16  B      0    10   22   0  Merge 'linux-review/Gregory-CLEMENT/Improve-cp110-clk-support-on-Marvell-Armada-7K-8K/20170522-164927' into devel-spot-201705231457
git bisect  bad 299e2ba6ebba23bbf11ff9f13140ec3686ebee4a  # 20:33  B      0    11   25   2  Merge 'hid/for-next' into devel-spot-201705231457
git bisect good 9fc5fc1a40a71a444ecf61e89bb129750e94c1a6  # 21:25  G     11     0    0   0  Merge 'linux-review/Matthias-Kaehlcke/dmaengine-pl330-Mark-unused-functions-as-__maybe_unused/20170522-181208' into devel-spot-201705231457
git bisect good c5fdc9dfc0cd3b2c6394f7f43e12c6ad8b1850c6  # 22:41  G     11     0    0   2  Merge 'hverkuil-media/rpi3' into devel-spot-201705231457
git bisect  bad bdd8ad1d9b23634d21944f9515aec1efcc8f9554  # 22:53  B      0    11   25   2  Merge 'linuxtv-media/master' into devel-spot-201705231457
git bisect  bad 592ddc9f7db36c778d3bf9ffdfd93d8d5d548e48  # 23:05  B      0    11   23   0  [media] sir_ir: infinite loop in interrupt handler
git bisect good dd8245f445f5e751b38126140b6ba1723f06c60b  # 00:03  G     11     0    0   2  [media] atomisp: don't treat warnings as errors
# first bad commit: [592ddc9f7db36c778d3bf9ffdfd93d8d5d548e48] [media] sir_ir: infinite loop in interrupt handler
git bisect good dd8245f445f5e751b38126140b6ba1723f06c60b  # 00:39  G     31     0    0   2  [media] atomisp: don't treat warnings as errors
# extra tests with CONFIG_DEBUG_INFO_REDUCED
git bisect  bad 592ddc9f7db36c778d3bf9ffdfd93d8d5d548e48  # 00:50  B      0     6   18   0  [media] sir_ir: infinite loop in interrupt handler
# extra tests on HEAD of linux-devel/devel-spot-201705231457
git bisect  bad 25a6a323286a4ee6c571d219727a864fef8ad63e  # 00:50  B      0    13   28   0  0day head guard for 'devel-spot-201705231457'
# extra tests on tree/branch linux-next/master
git bisect  bad f482797714a9f4c2cf8e4a3929c7908413bd06c7  # 00:51  B      0     2   14   0  Add linux-next specific files for 20170523
# extra tests with first bad commit reverted
git bisect good 5152ac21d0c7aa950f872daecdd6b144d4d42c99  # 01:39  G     11     0    0   0  Revert "[media] sir_ir: infinite loop in interrupt handler"

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/lkp                          Intel Corporation

--=_592473d7.GhTTSot/dRvRsViweAavdcLadKnMmV0H59rGc5VT3B5pds3h
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-yocto-ivb41-123:20170523230515:x86_64-randconfig-s4-05231630:4.12.0-rc1-00003-g592ddc9:1.gz"

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
n/4Oycf/AScIlamnxQEA

--=_592473d7.GhTTSot/dRvRsViweAavdcLadKnMmV0H59rGc5VT3B5pds3h
Content-Type: application/gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg-vm-lkp-nex04-1G-24:20170523233239:x86_64-randconfig-s4-05231630:4.12.0-rc1-00002-gdd8245f:1.gz"

H4sICM1zJFkAA2RtZXNnLXZtLWxrcC1uZXgwNC0xRy0yNDoyMDE3MDUyMzIzMzIzOTp4ODZf
NjQtcmFuZGNvbmZpZy1zNC0wNTIzMTYzMDo0LjEyLjAtcmMxLTAwMDAyLWdkZDgyNDVmOjEA
7F3rc9rIsv9881f0qfPh2OcarNFbVLF1MMYxZWOzgLO5J5WihDTCWgtJKwnHzl9/u0cSxgj8
Ct7suRdVEj2m+zc9o5l+zLQIt5PgHpwoTKOAgx9CyrN5jA9c/oGvlvG7LLGdbHzDk5AHH/ww
nmdj187sBkh3UnkokmkoE7UoDnj4qFSyuKxN9A/RPMPiR0UsPxVFFU5m6Ibnmh/y2sdZlNnB
OPW/80dUsm3ZBDKJooy7cOvbkGZ2go0aK/Le/of+9X3qO3YAZ63h+QDmqR9OYXA8Grbr9fqH
Tz5Sbir8cMydaBYnPBXPz/1wfofPoW8n4kHn/ETc8sSLkhk9SXgQOXbmYxdSiRuFvP7hCCWj
wuyaQ96W+ocvgIdUz5vwNYeGW464UQhqncl1qZY4rCZaWJu6rimrmgd7N5O5H7j/Cm7i2lTb
h72p4yzY9DpygSwxXbIkBnvHfOLbxeOasg/78HcG/UGn0+uPYDTn0LPvQVbwT0PWGpIB7eGI
2I1V6drRbGaHLgR+iH3vx80GHrezGkkR8jtJrbGPNVltNNxrJ4YEm9s8dPntYWLPJOxTnjSR
En6PJs1DvDhMnWvuzgPuHlYxDuk11ljNFbLX7kx9rKs1alNNMmsKqzvT77WiN1T8q3FDYxPF
ZLLOVGmiT2xmyIon6Y4uTYjPkDRZqZkyM40ak7PvepjWWP3engXQGrRPm3kNcIOj3vOnxW0t
webmT2qpWiMIpisSTPC5c90M6G2hiLc8OBT/1tIYpS5rY6pm4Cyazfys+VJR4ejycjTu9lof
O83D+GZ6KOo4fFKcQ3z5Nf3wpVVgbxPo99rm4TWz78bzOPNnvKlLEgw6w6vz0XiAojUPcRbM
g0y8n0O2+uYOn3pf220Fg/Oz/njYGXzqDJp+GAJWPZ+CHftOM79M79Pkj7EdfLPv0zEP7QkO
NUiceYyai9fxYuzE8zEqiQCVCrYV1U8TVRGEPKv7XmjPeNqUIE78MLup4/u9maXTJs6v2A6x
jhqDNPIynOc3qGLyZwzCmT/+ZmfOtRtNm+IhRFGcFpdBZLtjnA2un940ZYRGrZItHkjgJhO3
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
ZjTAqco8fT2Fz8f/B7zVc4o58gAA

--=_592473d7.GhTTSot/dRvRsViweAavdcLadKnMmV0H59rGc5VT3B5pds3h
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce-yocto-ivb41-123:20170523230515:x86_64-randconfig-s4-05231630:4.12.0-rc1-00003-g592ddc9:1"

#!/bin/bash

kernel=$1
initrd=yocto-trinity-x86_64.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-enable-kvm
	-cpu Haswell,+smep,+smap
	-kernel $kernel
	-initrd $initrd
	-m 512
	-smp 1
	-device e1000,netdev=net0
	-netdev user,id=net0
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-watchdog-action debug
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null
)

append=(
	root=/dev/ram0
	hung_task_panic=1
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	net.ifnames=0
	printk.devkmsg=on
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	drbd.minor_count=8
	systemd.log_level=err
	ignore_loglevel
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	rw
	drbd.minor_count=8
)

"${kvm[@]}" -append "${append[*]}"

--=_592473d7.GhTTSot/dRvRsViweAavdcLadKnMmV0H59rGc5VT3B5pds3h
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-4.12.0-rc1-00003-g592ddc9"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 4.12.0-rc1 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=4
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

#
# RCU Subsystem
#
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
# CONFIG_BLK_CGROUP is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUP_PIDS is not set
# CONFIG_CGROUP_RDMA is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_BPF is not set
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_SOCK_CGROUP_DATA is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_INITRAMFS_COMPRESSION=".gz"
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_POSIX_TIMERS=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_ABSOLUTE_PERCPU is not set
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_BPF_SYSCALL=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_USERFAULTFD=y
CONFIG_PCI_QUIRKS=y
CONFIG_MEMBARRIER=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_MEMCG_SYSFS_ON is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_FREELIST_RANDOM=y
# CONFIG_SYSTEM_DATA_VERIFICATION is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_CYC_COMPLEXITY is not set
CONFIG_GCC_PLUGIN_SANCOV=y
CONFIG_GCC_PLUGIN_LATENT_ENTROPY=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK is not set
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
# CONFIG_HAVE_ARCH_HASH is not set
# CONFIG_ISA_BUS_API is not set
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
# CONFIG_CPU_NO_EFFICIENT_FFS is not set
CONFIG_HAVE_ARCH_VMAP_STACK=y
# CONFIG_VMAP_STACK is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX is not set
# CONFIG_ARCH_OPTIONAL_KERNEL_RWX_DEFAULT is not set
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_MODULE_COMPRESS=y
CONFIG_MODULE_COMPRESS_GZIP=y
# CONFIG_MODULE_COMPRESS_XZ is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_CMDLINE_PARSER=y
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_SQ=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_DEBUG_FS is not set
CONFIG_BLK_SED_OPAL=y

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_MQ_IOSCHED_DEADLINE=m
CONFIG_MQ_IOSCHED_KYBER=m
CONFIG_IOSCHED_BFQ=m
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_FAST_FEATURE_TESTS=y
# CONFIG_X86_X2APIC is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_GOLDFISH=y
CONFIG_INTEL_RDT_A=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_UP_LATE_INIT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
# CONFIG_PERF_EVENTS_INTEL_UNCORE is not set
# CONFIG_PERF_EVENTS_INTEL_RAPL is not set
# CONFIG_PERF_EVENTS_INTEL_CSTATE is not set
CONFIG_PERF_EVENTS_AMD_POWER=m
# CONFIG_VM86 is not set
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_X86_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
# CONFIG_BALLOON_COMPACTION is not set
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=m
# CONFIG_Z3FOLD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT=y
# CONFIG_DEFERRED_STRUCT_PAGE_INIT is not set
# CONFIG_IDLE_PAGE_TRACKING is not set
CONFIG_ZONE_DEVICE=y
CONFIG_FRAME_VECTOR=y
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_X86_INTEL_MPX is not set
# CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
CONFIG_SECCOMP=y
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_KEXEC_VERIFY_SIG=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_COMPAT_VDSO=y
# CONFIG_LEGACY_VSYSCALL_NATIVE is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
CONFIG_ACPI_DEBUGGER=y
CONFIG_ACPI_DEBUGGER_USER=m
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=m
# CONFIG_ACPI_FAN is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_TABLE_UPGRADE is not set
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=m
CONFIG_ACPI_CUSTOM_METHOD=m
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
# CONFIG_ACPI_APEI_GHES is not set
# CONFIG_ACPI_APEI_MEMORY_FAILURE is not set
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_DPTF_POWER=y
# CONFIG_ACPI_EXTLOG is not set
CONFIG_PMIC_OPREGION=y
# CONFIG_XPOWER_PMIC_OPREGION is not set
CONFIG_ACPI_CONFIGFS=m
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
CONFIG_X86_P4_CLOCKMOD=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_BUS_ADDR_T_64BIT=y
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_LABEL=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT is not set

#
# PCI host controller drivers
#
CONFIG_VMD=m

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_PD6729=m
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_X86_X32=y
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
# CONFIG_IP_PIMSM_V1 is not set
# CONFIG_IP_PIMSM_V2 is not set
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=m
# CONFIG_NET_UDP_TUNNEL is not set
# CONFIG_NET_FOU is not set
# CONFIG_NET_FOU_IP_TUNNELS is not set
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=m
# CONFIG_IPV6_ROUTER_PREF is not set
CONFIG_IPV6_OPTIMISTIC_DAD=y
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=m
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=m
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_FOU is not set
# CONFIG_IPV6_FOU_TUNNEL is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_INLINE is not set
CONFIG_IPV6_SEG6_HMAC=y
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
# CONFIG_X25 is not set
CONFIG_LAPB=m
CONFIG_PHONET=y
CONFIG_6LOWPAN=m
CONFIG_6LOWPAN_DEBUGFS=y
CONFIG_6LOWPAN_NHC=m
CONFIG_6LOWPAN_NHC_DEST=m
CONFIG_6LOWPAN_NHC_FRAGMENT=m
CONFIG_6LOWPAN_NHC_HOP=m
CONFIG_6LOWPAN_NHC_IPV6=m
CONFIG_6LOWPAN_NHC_MOBILITY=m
# CONFIG_6LOWPAN_NHC_ROUTING is not set
# CONFIG_6LOWPAN_NHC_UDP is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_HOP is not set
# CONFIG_6LOWPAN_GHC_UDP is not set
CONFIG_6LOWPAN_GHC_ICMPV6=m
CONFIG_6LOWPAN_GHC_EXT_HDR_DEST=m
CONFIG_6LOWPAN_GHC_EXT_HDR_FRAG=m
CONFIG_6LOWPAN_GHC_EXT_HDR_ROUTE=m
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_BATMAN_V is not set
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_MCAST=y
CONFIG_BATMAN_ADV_DEBUGFS=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
CONFIG_VSOCKETS=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
# CONFIG_NETLINK_DIAG is not set
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
# CONFIG_MPLS_ROUTING is not set
# CONFIG_HSR is not set
# CONFIG_NET_SWITCHDEV is not set
# CONFIG_NET_L3_MASTER_DEV is not set
CONFIG_NET_NCSI=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_YAM=m
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_VXCAN=y
CONFIG_CAN_SLCAN=m
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
CONFIG_NSC_FIR=m
# CONFIG_WINBOND_FIR is not set
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=m
# CONFIG_VIA_FIR is not set
CONFIG_BT=m
# CONFIG_BT_BREDR is not set
# CONFIG_BT_LE is not set
CONFIG_BT_LEDS=y
CONFIG_BT_SELFTEST=y
CONFIG_BT_DEBUGFS=y

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
CONFIG_BT_BCM=m
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
CONFIG_BT_HCIUART_INTEL=y
CONFIG_BT_HCIUART_BCM=y
# CONFIG_BT_HCIUART_QCA is not set
CONFIG_BT_HCIUART_AG6XX=y
CONFIG_BT_HCIUART_MRVL=y
# CONFIG_BT_HCIDTL1 is not set
CONFIG_BT_HCIBT3C=m
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
# CONFIG_BT_MRVL_SDIO is not set
# CONFIG_BT_WILINK is not set
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_IPV6=y
CONFIG_AF_RXRPC_INJECT_LOSS=y
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_AF_KCM=m
CONFIG_STREAM_PARSER=m
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=m
# CONFIG_CAIF_USB is not set
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
# CONFIG_NFC_DIGITAL is not set
CONFIG_NFC_NCI=m
# CONFIG_NFC_NCI_UART is not set
CONFIG_NFC_HCI=m
# CONFIG_NFC_SHDLC is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_MEI_PHY=m
# CONFIG_NFC_FDP is not set
# CONFIG_NFC_PN544_MEI is not set
CONFIG_NFC_PN533=m
CONFIG_NFC_PN533_I2C=m
CONFIG_NFC_MICROREAD=m
CONFIG_NFC_MICROREAD_MEI=m
CONFIG_NFC_ST_NCI=m
CONFIG_NFC_ST_NCI_I2C=m
# CONFIG_NFC_NXP_NCI is not set
CONFIG_NFC_S3FWRN5=m
CONFIG_NFC_S3FWRN5_I2C=m
# CONFIG_PSAMPLE is not set
CONFIG_NET_IFE=y
CONFIG_LWTUNNEL=y
# CONFIG_LWTUNNEL_BPF is not set
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
# CONFIG_NET_DEVLINK is not set
CONFIG_MAY_USE_DEVLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
CONFIG_DEBUG_TEST_DRIVER_REMOVE=y
CONFIG_TEST_ASYNC_DRIVER_PROBE=m
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=200
CONFIG_CMA_SIZE_PERCENTAGE=0
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=m
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
# CONFIG_MTD_CFI_AMDSTD is not set
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
CONFIG_MTD_PMC551_BUGFIX=y
CONFIG_MTD_PMC551_DEBUG=y
CONFIG_MTD_SLRAM=m
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_SPI_NOR=m
CONFIG_MTD_MT81xx_NOR=m
# CONFIG_MTD_SPI_NOR_USE_4K_SECTORS is not set
# CONFIG_SPI_INTEL_SPI_PLATFORM is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
CONFIG_MTD_UBI_BLOCK=y
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_SKD=y
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_RAM_DAX is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=m
# CONFIG_VIRTIO_BLK_SCSI is not set
CONFIG_BLK_DEV_RBD=y
CONFIG_BLK_DEV_RSXX=y
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
# CONFIG_BLK_DEV_NVME_SCSI is not set
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_FC is not set
CONFIG_NVME_TARGET=m
CONFIG_NVME_TARGET_LOOP=m
# CONFIG_NVME_TARGET_FC is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=m
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_DUMMY_IRQ=m
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_USB_SWITCH_FSA9480=m
# CONFIG_SRAM is not set
CONFIG_PCI_ENDPOINT_TEST=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=m
# CONFIG_EEPROM_93CX6 is not set
CONFIG_EEPROM_IDT_89HPESX=m
CONFIG_CB710_CORE=y
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=m

#
# Intel MIC Bus Driver
#
CONFIG_INTEL_MIC_BUS=y

#
# SCIF Bus Driver
#
CONFIG_SCIF_BUS=m

#
# VOP Bus Driver
#
# CONFIG_VOP_BUS is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#

#
# SCIF Driver
#
CONFIG_SCIF=m

#
# Intel MIC Coprocessor State Management (COSM) Drivers
#
CONFIG_MIC_COSM=m

#
# VOP Driver
#
CONFIG_GENWQE=y
CONFIG_GENWQE_PLATFORM_ERROR_RECOVERY=0
CONFIG_ECHO=m
# CONFIG_CXL_BASE is not set
# CONFIG_CXL_AFU_DRIVER_OPS is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_MQ_DEFAULT is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_AHA152X is not set
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
# CONFIG_SCSI_DH is not set
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_MQ_DEFAULT is not set
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
# CONFIG_DM_ERA is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_RAID is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_DM_FLAKEY is not set
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_DM_LOG_WRITES is not set
# CONFIG_DM_INTEGRITY is not set
CONFIG_TARGET_CORE=m
# CONFIG_TCM_IBLOCK is not set
# CONFIG_TCM_FILEIO is not set
CONFIG_TCM_PSCSI=m
# CONFIG_TCM_USER2 is not set
CONFIG_LOOPBACK_TARGET=m
# CONFIG_ISCSI_TARGET is not set
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
CONFIG_FIREWIRE_NOSY=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=m
# CONFIG_NETDEVICES is not set
# CONFIG_NVM is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=m
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_GOLDFISH_EVENTS is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_PS2_FOCALTECH=y
# CONFIG_MOUSE_PS2_VMMOUSE is not set
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=m
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=m
CONFIG_INPUT_AD714X_I2C=m
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_E3X0_BUTTON=y
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_GPIO_DECODER=y
CONFIG_INPUT_ATLAS_BTNS=m
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_REGULATOR_HAPTIC=y
CONFIG_INPUT_TPS65218_PWRBUTTON=m
CONFIG_INPUT_AXP20X_PEK=m
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_DA9052_ONKEY=m
CONFIG_INPUT_DA9063_ONKEY=y
CONFIG_INPUT_WM831X_ON=m
CONFIG_INPUT_ADXL34X=m
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
CONFIG_INPUT_DRV260X_HAPTICS=m
CONFIG_INPUT_DRV2665_HAPTICS=m
CONFIG_INPUT_DRV2667_HAPTICS=m
CONFIG_RMI4_CORE=y
# CONFIG_RMI4_I2C is not set
# CONFIG_RMI4_SMB is not set
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=y
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F54 is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_GOLDFISH_TTY=m
# CONFIG_DEVMEM is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_FINTEK=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=m
# CONFIG_SERIAL_8250_EXAR is not set
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_FSL is not set
# CONFIG_SERIAL_8250_DW is not set
CONFIG_SERIAL_8250_RT288X=y
CONFIG_SERIAL_8250_LPSS=y
# CONFIG_SERIAL_8250_MID is not set
CONFIG_SERIAL_8250_MOXA=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_UARTLITE_NR_UARTS=1
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_SCCNXP=m
CONFIG_SERIAL_SC16IS7XX=y
# CONFIG_SERIAL_SC16IS7XX_I2C is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
# CONFIG_IPMI_PANIC_STRING is not set
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_HW_RANDOM_VIRTIO=m
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=m
CONFIG_R3964=y
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_SCR24X=m
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=m
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=m
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_CRB=m
CONFIG_TCG_VTPM_PROXY=m
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set

#
# I2C support
#
CONFIG_I2C=y
# CONFIG_ACPI_I2C_OPREGION is not set
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=m
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=m
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=m
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
CONFIG_I2C_DESIGNWARE_PCI=m
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
CONFIG_I2C_EMEV2=m
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
CONFIG_I2C_STUB=m
CONFIG_I2C_SLAVE=y
CONFIG_I2C_SLAVE_EEPROM=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_KVM=m
CONFIG_PINCTRL=y

#
# Pin controllers
#
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=m
CONFIG_PINCTRL_SX150X=y
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_PINCTRL_CHERRYVIEW=m
CONFIG_PINCTRL_INTEL=m
CONFIG_PINCTRL_BROXTON=m
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=y
# CONFIG_GPIO_AXP209 is not set
CONFIG_GPIO_DWAPB=m
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_LYNXPOINT=y
CONFIG_GPIO_MOCKUP=y
CONFIG_GPIO_VX855=y

#
# Port-mapped I/O GPIO drivers
#
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_IT87=m
CONFIG_GPIO_SCH=y
CONFIG_GPIO_SCH311X=m

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TPIC2810=y

#
# MFD GPIO expanders
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_JANZ_TTL=m
CONFIG_GPIO_KEMPLD=y
# CONFIG_GPIO_LP3943 is not set
# CONFIG_GPIO_LP873X is not set
CONFIG_GPIO_TPS65218=m
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y
CONFIG_GPIO_TPS65912=m
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_WM8994 is not set

#
# PCI GPIO expanders
#
CONFIG_GPIO_AMD8111=m
CONFIG_GPIO_BT8XX=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
CONFIG_GPIO_RDC321X=y

#
# SPI or I2C GPIO expanders
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2405 is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
# CONFIG_W1_SLAVE_DS2406 is not set
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
# CONFIG_W1_SLAVE_DS2438 is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
# CONFIG_POWER_AVS is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=y
CONFIG_WM8350_POWER=y
CONFIG_TEST_POWER=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=m
CONFIG_BATTERY_DS2781=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=y
CONFIG_CHARGER_SBS=m
CONFIG_BATTERY_BQ27XXX=m
CONFIG_BATTERY_BQ27XXX_I2C=m
CONFIG_BATTERY_DA9052=m
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX14577=m
CONFIG_CHARGER_MAX77693=m
CONFIG_CHARGER_MAX8997=m
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_BQ24257=y
# CONFIG_CHARGER_BQ24735 is not set
CONFIG_CHARGER_BQ25890=y
CONFIG_CHARGER_SMB347=m
CONFIG_CHARGER_TPS65090=m
# CONFIG_CHARGER_TPS65217 is not set
CONFIG_BATTERY_GAUGE_LTC2941=m
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=m
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ASPEED=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_MC13783_ADC=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_POWR1220=m
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=m
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
CONFIG_SENSORS_MAX6639=m
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_TC654=m
# CONFIG_SENSORS_MENF21BMC_HWMON is not set
# CONFIG_SENSORS_LM63 is not set
CONFIG_SENSORS_LM73=m
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
CONFIG_SENSORS_NCT7802=m
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
CONFIG_SENSORS_LM25066=m
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_LTC3815=m
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX20751=m
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_TPS40422 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SHT3x=m
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_STTS751=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_ADC128D818=m
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
CONFIG_SENSORS_TMP108=m
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=m
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_WM8350=m
CONFIG_SENSORS_XGENE=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_DEFAULT_GOV_POWER_ALLOCATOR is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_POWER_ALLOCATOR is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
CONFIG_INTEL_SOC_DTS_THERMAL=m

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_BCM590XX=m
CONFIG_MFD_AXP20X=m
CONFIG_MFD_AXP20X_I2C=m
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9062=y
CONFIG_MFD_DA9063=m
# CONFIG_MFD_DA9150 is not set
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_I2C=m
# CONFIG_HTC_PASIC3 is not set
CONFIG_HTC_I2CPLD=y
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
# CONFIG_MFD_INTEL_LPSS_PCI is not set
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_KEMPLD=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=m
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77693=m
CONFIG_MFD_MAX77843=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_MT6397=m
CONFIG_MFD_MENF21BMC=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RT5033=m
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=m
CONFIG_MFD_LP8788=y
CONFIG_MFD_TI_LMU=m
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65086 is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=m
CONFIG_MFD_TI_LP873X=y
CONFIG_MFD_TPS65218=y
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=m
CONFIG_MFD_TPS65912_I2C=m
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=m
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_CS47L24=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
CONFIG_MFD_WM8998=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=m
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_ACT8865 is not set
# CONFIG_REGULATOR_AD5398 is not set
CONFIG_REGULATOR_ANATOP=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_AS3711 is not set
# CONFIG_REGULATOR_AXP20X is not set
CONFIG_REGULATOR_BCM590XX=m
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9062=m
# CONFIG_REGULATOR_DA9063 is not set
# CONFIG_REGULATOR_DA9210 is not set
CONFIG_REGULATOR_DA9211=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL9305=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LM363X=m
CONFIG_REGULATOR_LP3971=y
# CONFIG_REGULATOR_LP3972 is not set
# CONFIG_REGULATOR_LP872X is not set
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=m
CONFIG_REGULATOR_LTC3589=y
# CONFIG_REGULATOR_LTC3676 is not set
CONFIG_REGULATOR_MAX14577=y
# CONFIG_REGULATOR_MAX1586 is not set
CONFIG_REGULATOR_MAX8649=m
# CONFIG_REGULATOR_MAX8660 is not set
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8997=m
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_MT6311=m
CONFIG_REGULATOR_MT6323=m
CONFIG_REGULATOR_MT6397=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_PV88060=m
CONFIG_REGULATOR_PV88080=y
CONFIG_REGULATOR_PV88090=y
# CONFIG_REGULATOR_RT5033 is not set
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=m
# CONFIG_REGULATOR_TPS62360 is not set
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS65090=m
# CONFIG_REGULATOR_TPS65132 is not set
CONFIG_REGULATOR_TPS65217=m
CONFIG_REGULATOR_TPS6586X=m
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS65912=m
CONFIG_REGULATOR_WM831X=m
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8994=m
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CEC_SUPPORT is not set
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_SG=y
CONFIG_VIDEOBUF2_DVB=m
CONFIG_DVB_CORE=y
# CONFIG_DVB_NET is not set
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=16
# CONFIG_DVB_DYNAMIC_MINORS is not set
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_IR_ENE=y
# CONFIG_IR_HIX5HD2 is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=y
# CONFIG_IR_REDRAT3 is not set
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=y
# CONFIG_IR_GPIO_CIR is not set
# CONFIG_IR_SERIAL is not set
CONFIG_IR_SIR=y
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=y
# CONFIG_VIDEO_CX88_BLACKBIRD is not set
# CONFIG_VIDEO_CX88_DVB is not set
# CONFIG_VIDEO_BT848 is not set
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
# CONFIG_VIDEO_SAA7164 is not set

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=y
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=y
# CONFIG_DVB_BUDGET is not set
CONFIG_DVB_BUDGET_CI=m
# CONFIG_DVB_BUDGET_AV is not set
CONFIG_DVB_BUDGET_PATCH=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=y
CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG=y
CONFIG_DVB_PLUTO2=m
CONFIG_DVB_DM1105=y
# CONFIG_DVB_PT1 is not set
# CONFIG_DVB_PT3 is not set
CONFIG_MANTIS_CORE=y
# CONFIG_DVB_MANTIS is not set
CONFIG_DVB_HOPPER=y
# CONFIG_DVB_NGENE is not set
CONFIG_DVB_DDBRIDGE=m
CONFIG_DVB_SMIPCIE=y
CONFIG_DVB_PLATFORM_DRIVERS=y

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
# CONFIG_RADIO_ADAPTERS is not set

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_TVEEPROM=y
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y
CONFIG_VIDEO_SAA7146=y
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_SMS_SIANO_MDTV=m
# CONFIG_SMS_SIANO_RC is not set

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# I2C Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
CONFIG_VIDEO_TEA6415C=y
CONFIG_VIDEO_TEA6420=m
# CONFIG_VIDEO_MSP3400 is not set
CONFIG_VIDEO_CS3308=m
CONFIG_VIDEO_CS5345=y
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=y
CONFIG_VIDEO_UDA1342=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=y
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_ADV7183=m
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=y
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_TVP514X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_TVP7002=m
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=m
CONFIG_VIDEO_TW9906=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=y
# CONFIG_VIDEO_CX25840 is not set

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
# CONFIG_VIDEO_SAA7185 is not set
CONFIG_VIDEO_ADV7170=m
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
CONFIG_VIDEO_MT9M111=y

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
CONFIG_VIDEO_UPD64083=y

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=m
CONFIG_VIDEO_M52790=m

#
# Sensors used on soc_camera driver
#

#
# SPI helper chips
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=y
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=m
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_XC4000=m
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=y
# CONFIG_MEDIA_TUNER_TDA18218 is not set
# CONFIG_MEDIA_TUNER_FC0011 is not set
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=y
CONFIG_MEDIA_TUNER_M88RS6000T=y
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=y
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=y
CONFIG_MEDIA_TUNER_MXL301RF=y
# CONFIG_MEDIA_TUNER_QM1D1C0042 is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
# CONFIG_DVB_TDA18271C2DD is not set
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=y
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=y
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
# CONFIG_DVB_STV0900 is not set
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=m
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TUA6100 is not set
CONFIG_DVB_CX24116=m
# CONFIG_DVB_CX24117 is not set
CONFIG_DVB_CX24120=y
CONFIG_DVB_SI21XX=y
# CONFIG_DVB_TS2020 is not set
# CONFIG_DVB_DS3000 is not set
# CONFIG_DVB_MB86A16 is not set
CONFIG_DVB_TDA10071=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=y
# CONFIG_DVB_CX22702 is not set
# CONFIG_DVB_S5H1432 is not set
# CONFIG_DVB_DRXD is not set
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=m
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=m
# CONFIG_DVB_DIB7000M is not set
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=y
CONFIG_DVB_TDA10048=y
# CONFIG_DVB_AF9013 is not set
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_CXD2841ER=m
# CONFIG_DVB_AS102_FE is not set
CONFIG_DVB_ZD1301_DEMOD=y
# CONFIG_DVB_GP8PSK_FE is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
CONFIG_DVB_TDA10021=y
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
CONFIG_DVB_OR51211=y
# CONFIG_DVB_OR51132 is not set
CONFIG_DVB_BCM3510=m
# CONFIG_DVB_LGDT330X is not set
# CONFIG_DVB_LGDT3305 is not set
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_AU8522_V4L=m
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
# CONFIG_DVB_DIB8000 is not set
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_TC90522 is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_DRX39XYJ is not set
# CONFIG_DVB_LNBH25 is not set
# CONFIG_DVB_LNBP21 is not set
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
# CONFIG_DVB_ISL6423 is not set
CONFIG_DVB_A8293=m
# CONFIG_DVB_SP2 is not set
CONFIG_DVB_LGS8GL5=m
# CONFIG_DVB_LGS8GXX is not set
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=y
CONFIG_DVB_IX2505V=y
CONFIG_DVB_M88RS2000=m
# CONFIG_DVB_AF9033 is not set
CONFIG_DVB_HORUS3A=m
CONFIG_DVB_ASCOT2E=m
# CONFIG_DVB_HELENE is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=m
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
# CONFIG_DRM is not set

#
# ACP (Audio CoProcessor) Configuration
#
# CONFIG_DRM_LIB_RANDOM is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_PROVIDE_GET_FB_UNMAPPED_AREA is not set
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=m
CONFIG_FB_OPENCORES=y
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=m
# CONFIG_FB_MATROX_MILLENIUM is not set
# CONFIG_FB_MATROX_MYSTIQUE is not set
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
# CONFIG_FB_VIA_X_COMPATIBILITY is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=y
# CONFIG_FB_TRIDENT is not set
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_IBM_GXT4500=m
# CONFIG_FB_GOLDFISH is not set
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
CONFIG_FB_BROADSHEET=m
# CONFIG_FB_AUO_K190X is not set
CONFIG_FB_SIMPLE=y
CONFIG_FB_SM712=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_PM8941_WLED=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_PCF50633 is not set
CONFIG_BACKLIGHT_AAT2870=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_AS3711=m
CONFIG_BACKLIGHT_GPIO=m
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_BACKLIGHT_ARCXCNN=y
CONFIG_VGASTATE=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
CONFIG_HID_ACRUX=y
CONFIG_HID_ACRUX_FF=y
CONFIG_HID_APPLE=y
CONFIG_HID_ASUS=y
# CONFIG_HID_AUREAL is not set
# CONFIG_HID_BELKIN is not set
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=y
CONFIG_HID_CMEDIA=m
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=m
CONFIG_HID_GEMBIRD=y
CONFIG_HID_GFRM=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_WALTOP=m
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_HIDPP=y
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MAYFLASH is not set
CONFIG_HID_MICROSOFT=y
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTI=m
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
CONFIG_HID_PRIMAX=m
CONFIG_HID_SAITEK=m
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_RMI=y
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_UDRAW_PS3=y
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set
# CONFIG_HID_ALPS is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
CONFIG_USB_PCI=y

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_GADGET is not set

#
# USB Power Delivery and Type-C drivers
#
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_GOLDFISH is not set
# CONFIG_MMC_SDRICOH_CS is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_USDHI6ROL0=m
CONFIG_MMC_REALTEK_PCI=m
CONFIG_MMC_TOSHIBA_PCI=m
CONFIG_MMC_MTK=m
CONFIG_MMC_SDHCI_XENON=m
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=y
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
# CONFIG_LEDS_MT6323 is not set
CONFIG_LEDS_PCA9532=m
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP3952=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=y
CONFIG_LEDS_LP8860=m
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_WM8350=m
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_TLC591XX=m
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_MENF21BMC is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_USER is not set
CONFIG_LEDS_NIC78BX=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
CONFIG_LEDS_TRIGGER_GPIO=m
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_LEDS_TRIGGER_PANIC=y
CONFIG_ACCESSIBILITY=y
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_AMD64=y
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=y
CONFIG_EDAC_IE31200=y
CONFIG_EDAC_X38=y
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
# CONFIG_EDAC_SKX is not set
# CONFIG_EDAC_PND2 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
CONFIG_INTEL_IDMA64=y
CONFIG_INTEL_IOATDMA=m
CONFIG_INTEL_MIC_X100_DMA=y
CONFIG_QCOM_HIDMA_MGMT=m
CONFIG_QCOM_HIDMA=m
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
# CONFIG_SYNC_FILE is not set
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
# CONFIG_HD44780 is not set
CONFIG_IMG_ASCII_LCD=m
CONFIG_UIO=y
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
CONFIG_UIO_PRUSS=m
CONFIG_UIO_MF624=m
CONFIG_VFIO_IOMMU_TYPE1=m
# CONFIG_VFIO_VIRQFD is not set
CONFIG_VFIO=m
# CONFIG_VFIO_NOIOMMU is not set
# CONFIG_VFIO_PCI is not set
CONFIG_VFIO_MDEV=m
# CONFIG_VFIO_MDEV_DEVICE is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=m
# CONFIG_VIRTIO_PCI_LEGACY is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_INPUT is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_HYPERV_TSCPAGE is not set
CONFIG_STAGING=y
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
CONFIG_COMEDI_MISC_DRIVERS=y
# CONFIG_COMEDI_BOND is not set
# CONFIG_COMEDI_TEST is not set
# CONFIG_COMEDI_PARPORT is not set
CONFIG_COMEDI_SERIAL2002=m
# CONFIG_COMEDI_ISA_DRIVERS is not set
CONFIG_COMEDI_PCI_DRIVERS=m
CONFIG_COMEDI_8255_PCI=m
CONFIG_COMEDI_ADDI_WATCHDOG=m
CONFIG_COMEDI_ADDI_APCI_1032=m
# CONFIG_COMEDI_ADDI_APCI_1500 is not set
CONFIG_COMEDI_ADDI_APCI_1516=m
CONFIG_COMEDI_ADDI_APCI_1564=m
CONFIG_COMEDI_ADDI_APCI_16XX=m
# CONFIG_COMEDI_ADDI_APCI_2032 is not set
CONFIG_COMEDI_ADDI_APCI_2200=m
# CONFIG_COMEDI_ADDI_APCI_3120 is not set
CONFIG_COMEDI_ADDI_APCI_3501=m
CONFIG_COMEDI_ADDI_APCI_3XXX=m
# CONFIG_COMEDI_ADL_PCI6208 is not set
CONFIG_COMEDI_ADL_PCI7X3X=m
CONFIG_COMEDI_ADL_PCI8164=m
# CONFIG_COMEDI_ADL_PCI9111 is not set
# CONFIG_COMEDI_ADL_PCI9118 is not set
CONFIG_COMEDI_ADV_PCI1710=m
CONFIG_COMEDI_ADV_PCI1720=m
# CONFIG_COMEDI_ADV_PCI1723 is not set
CONFIG_COMEDI_ADV_PCI1724=m
# CONFIG_COMEDI_ADV_PCI1760 is not set
CONFIG_COMEDI_ADV_PCI_DIO=m
CONFIG_COMEDI_AMPLC_DIO200_PCI=m
# CONFIG_COMEDI_AMPLC_PC236_PCI is not set
# CONFIG_COMEDI_AMPLC_PC263_PCI is not set
CONFIG_COMEDI_AMPLC_PCI224=m
CONFIG_COMEDI_AMPLC_PCI230=m
CONFIG_COMEDI_CONTEC_PCI_DIO=m
CONFIG_COMEDI_DAS08_PCI=m
# CONFIG_COMEDI_DT3000 is not set
CONFIG_COMEDI_DYNA_PCI10XX=m
# CONFIG_COMEDI_GSC_HPDI is not set
CONFIG_COMEDI_MF6X4=m
CONFIG_COMEDI_ICP_MULTI=m
CONFIG_COMEDI_DAQBOARD2000=m
# CONFIG_COMEDI_JR3_PCI is not set
# CONFIG_COMEDI_KE_COUNTER is not set
CONFIG_COMEDI_CB_PCIDAS64=m
# CONFIG_COMEDI_CB_PCIDAS is not set
# CONFIG_COMEDI_CB_PCIDDA is not set
CONFIG_COMEDI_CB_PCIMDAS=m
CONFIG_COMEDI_CB_PCIMDDA=m
CONFIG_COMEDI_ME4000=m
CONFIG_COMEDI_ME_DAQ=m
CONFIG_COMEDI_NI_6527=m
# CONFIG_COMEDI_NI_65XX is not set
CONFIG_COMEDI_NI_660X=m
# CONFIG_COMEDI_NI_670X is not set
CONFIG_COMEDI_NI_LABPC_PCI=m
# CONFIG_COMEDI_NI_PCIDIO is not set
CONFIG_COMEDI_NI_PCIMIO=m
# CONFIG_COMEDI_RTD520 is not set
CONFIG_COMEDI_S626=m
CONFIG_COMEDI_MITE=m
CONFIG_COMEDI_NI_TIOCMD=m
CONFIG_COMEDI_PCMCIA_DRIVERS=m
# CONFIG_COMEDI_CB_DAS16_CS is not set
CONFIG_COMEDI_DAS08_CS=m
CONFIG_COMEDI_NI_DAQ_700_CS=m
CONFIG_COMEDI_NI_DAQ_DIO24_CS=m
CONFIG_COMEDI_NI_LABPC_CS=m
# CONFIG_COMEDI_NI_MIO_CS is not set
CONFIG_COMEDI_QUATECH_DAQP_CS=m
CONFIG_COMEDI_8254=m
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_8255_SA=m
CONFIG_COMEDI_KCOMEDILIB=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_TIO=m
# CONFIG_RTS5208 is not set
CONFIG_FB_SM750=m
# CONFIG_FB_XGI is not set

#
# Speakup console speech
#
CONFIG_STAGING_MEDIA=y
CONFIG_DVB_CXD2099=y

#
# Android
#
# CONFIG_FIREWIRE_SERIAL is not set
CONFIG_GOLDFISH_AUDIO=m
# CONFIG_MTD_GOLDFISH_NAND is not set
CONFIG_LNET=m
CONFIG_LNET_MAX_PAYLOAD=1048576
CONFIG_LNET_SELFTEST=m
CONFIG_LUSTRE_FS=m
CONFIG_LUSTRE_OBD_MAX_IOCTL_BUFFER=8192
CONFIG_LUSTRE_DEBUG_EXPENSIVE_CHECK=y
CONFIG_DGNC=y
CONFIG_GS_FPGABOOT=m
# CONFIG_CRYPTO_SKEIN is not set
CONFIG_UNISYSSPAR=y
CONFIG_UNISYS_VISORBUS=y
CONFIG_UNISYS_VISORNIC=m
CONFIG_UNISYS_VISORINPUT=y
CONFIG_UNISYS_VISORHBA=m
CONFIG_MOST=y
CONFIG_MOSTCORE=y
# CONFIG_AIM_CDEV is not set
CONFIG_AIM_NETWORK=y
# CONFIG_AIM_V4L2 is not set
CONFIG_HDM_DIM2=m
# CONFIG_HDM_I2C is not set
# CONFIG_GREYBUS is not set

#
# USB Power Delivery and Type-C drivers
#
# CONFIG_X86_PLATFORM_DEVICES is not set
CONFIG_PMC_ATOM=y
CONFIG_GOLDFISH_BUS=y
# CONFIG_GOLDFISH_PIPE is not set
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_WM831X is not set
CONFIG_COMMON_CLK_SI5351=m
CONFIG_COMMON_CLK_CDCE706=m
CONFIG_COMMON_CLK_CS2000_CP=m
# CONFIG_COMMON_CLK_NXP is not set
# CONFIG_COMMON_CLK_PXA is not set
# CONFIG_COMMON_CLK_PIC32 is not set

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_ATMEL_PIT is not set
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
CONFIG_IOMMU_IOVA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_SVM=y
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_IRQ_REMAP=y

#
# Remoteproc drivers
#
CONFIG_REMOTEPROC=y

#
# Rpmsg drivers
#

#
# SOC (System On Chip) specific Drivers
#

#
# Broadcom SoC drivers
#

#
# i.MX SoC drivers
#
# CONFIG_SUNXI_SRAM is not set
# CONFIG_SOC_TI is not set
# CONFIG_SOC_ZTE is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y
CONFIG_DEVFREQ_GOV_PASSIVE=m

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
CONFIG_NTB_AMD=m
CONFIG_NTB_INTEL=m
CONFIG_NTB_PINGPONG=m
# CONFIG_NTB_TOOL is not set
CONFIG_NTB_PERF=m
CONFIG_NTB_TRANSPORT=m
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_ARM_GIC_MAX_NR=1
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=m
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
# CONFIG_RESET_ATH79 is not set
# CONFIG_RESET_BERLIN is not set
# CONFIG_RESET_IMX7 is not set
# CONFIG_RESET_LPC18XX is not set
# CONFIG_RESET_MESON is not set
# CONFIG_RESET_PISTACHIO is not set
# CONFIG_RESET_SOCFPGA is not set
# CONFIG_RESET_STM32 is not set
# CONFIG_RESET_SUNXI is not set
CONFIG_TI_SYSCON_RESET=m
# CONFIG_RESET_ZYNQ is not set
# CONFIG_RESET_TEGRA_BPMP is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_PXA_28NM_HSIC=m
CONFIG_PHY_PXA_28NM_USB2=m
CONFIG_BCM_KONA_USB2_PHY=m
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=m
# CONFIG_MCB is not set

#
# Performance monitor support
#
CONFIG_RAS=y
CONFIG_MCE_AMD_INJ=y
# CONFIG_RAS_CEC is not set
CONFIG_THUNDERBOLT=y

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_NVMEM=y
CONFIG_STM=m
# CONFIG_STM_DUMMY is not set
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
# CONFIG_INTEL_TH_GTH is not set
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
# CONFIG_INTEL_TH_PTI is not set
CONFIG_INTEL_TH_DEBUG=y

#
# FPGA Configuration Support
#
# CONFIG_FPGA is not set

#
# FSI support
#
CONFIG_FSI=y
# CONFIG_TEE is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=m
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_FW_CFG_SYSFS is not set
CONFIG_GOOGLE_FIRMWARE=y
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_COREBOOT_TABLE=y
CONFIG_GOOGLE_COREBOOT_TABLE_ACPI=y
CONFIG_GOOGLE_MEMCONSOLE=y
# CONFIG_GOOGLE_MEMCONSOLE_X86_LEGACY is not set
CONFIG_GOOGLE_MEMCONSOLE_COREBOOT=y
# CONFIG_GOOGLE_VPD is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=m
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
CONFIG_EFI_CAPSULE_LOADER=y
CONFIG_EFI_TEST=y
CONFIG_APPLE_PROPERTIES=y
CONFIG_UEFI_CPER=y
CONFIG_EFI_DEV_PATH_PARSER=y

#
# Tegra firmware driver
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_FS_IOMAP=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
CONFIG_JFS_STATISTICS=y
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
CONFIG_F2FS_FS_SECURITY=y
CONFIG_F2FS_CHECK_FS=y
# CONFIG_F2FS_FS_ENCRYPTION is not set
CONFIG_F2FS_IO_TRACE=y
CONFIG_F2FS_FAULT_INJECTION=y
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
# CONFIG_MANDATORY_FILE_LOCKING is not set
# CONFIG_FS_ENCRYPTION is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=m
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
CONFIG_CUSE=m
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set

#
# Caches
#
CONFIG_FSCACHE=m
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_FAT_DEFAULT_UTF8 is not set
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=m
CONFIG_EFIVAR_FS=m
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ORANGEFS_FS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=m
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=m
# CONFIG_QNX6FS_DEBUG is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_ZLIB_COMPRESS is not set
# CONFIG_PSTORE_LZO_COMPRESS is not set
CONFIG_PSTORE_LZ4_COMPRESS=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
CONFIG_UFS_DEBUG=y
# CONFIG_EXOFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=m
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=y
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_PAGE_OWNER=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_SECTION_MISMATCH_WARN_ONLY is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_PAGE_POISONING=y
# CONFIG_PAGE_POISONING_NO_SANITY is not set
# CONFIG_PAGE_POISONING_ZERO is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_VMACACHE=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VM_PGFLAGS is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_HAVE_ARCH_KASAN=y
# CONFIG_KASAN is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_KCOV=y
CONFIG_KCOV_INSTRUMENT_ALL=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
# CONFIG_WQ_WATCHDOG is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_TIMEKEEPING is not set
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
# CONFIG_WW_MUTEX_SELFTEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PI_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
CONFIG_RCU_PERF_TEST=y
CONFIG_RCU_TORTURE_TEST=m
# CONFIG_RCU_TORTURE_TEST_SLOW_PREINIT is not set
# CONFIG_RCU_TORTURE_TEST_SLOW_INIT is not set
# CONFIG_RCU_TORTURE_TEST_SLOW_CLEANUP is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
# CONFIG_FAIL_MAKE_REQUEST is not set
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAIL_FUTEX=y
# CONFIG_FAULT_INJECTION_DEBUG_FS is not set
# CONFIG_LATENCYTOP is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_HWLAT_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_TRACING_MAP=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
CONFIG_TRACE_ENUM_MAP_FILE=y
CONFIG_TRACING_EVENTS_GPIO=y

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
CONFIG_TEST_LIST_SORT=m
# CONFIG_TEST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_TEST_HEXDUMP=y
CONFIG_TEST_STRING_HELPERS=m
CONFIG_TEST_KSTRTOX=m
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
CONFIG_TEST_UUID=m
CONFIG_TEST_RHASHTABLE=m
CONFIG_TEST_HASH=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_FIRMWARE=m
# CONFIG_TEST_UDELAY is not set
# CONFIG_MEMTEST is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_BUG_ON_DATA_CORRUPTION=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_ARCH_WANTS_UBSAN_NO_NULL is not set
# CONFIG_UBSAN is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_EFI=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
CONFIG_X86_PTDUMP_CORE=y
CONFIG_X86_PTDUMP=m
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_DEBUG=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_ENTRY=y
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_FPU is not set
CONFIG_PUNIT_ATOM_DEBUG=m

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
# CONFIG_BIG_KEYS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEY_DH_OPERATIONS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
# CONFIG_INTEL_TXT is not set
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=y
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=y
CONFIG_CRYPTO_ECDH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_MCRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y
CONFIG_CRYPTO_ENGINE=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_CHACHA20POLY1305=y
CONFIG_CRYPTO_SEQIV=m
CONFIG_CRYPTO_ECHAINIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
# CONFIG_CRYPTO_KEYWRAP is not set

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_POLY1305=y
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256_SSSE3=m
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA1_MB=m
# CONFIG_CRYPTO_SHA256_MB is not set
# CONFIG_CRYPTO_SHA512_MB is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_X86_64=y
# CONFIG_CRYPTO_AES_NI_INTEL is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
CONFIG_CRYPTO_CAST6=m
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_CHACHA20=y
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
# CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_842=y
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_USER_API_RNG=y
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
CONFIG_CRYPTO_DEV_PADLOCK_AES=y
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
# CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_DESC is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_CRYPTO_DEV_QAT=y
# CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
# CONFIG_CRYPTO_DEV_QAT_C3XXX is not set
CONFIG_CRYPTO_DEV_QAT_C62X=m
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=y
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=y
CONFIG_CRYPTO_DEV_QAT_C62XVF=y
CONFIG_CRYPTO_DEV_VIRTIO=y
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_PKCS7_MESSAGE_PARSER=y

#
# Certificates for signature checking
#
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
CONFIG_SYSTEM_EXTRA_CERTIFICATE=y
CONFIG_SYSTEM_EXTRA_CERTIFICATE_SIZE=4096
CONFIG_SECONDARY_TRUSTED_KEYRING=y
# CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_VHOST_NET=y
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
CONFIG_VHOST=y
CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
# CONFIG_HAVE_ARCH_BITREVERSE is not set
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=m
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=m
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_842_COMPRESS=y
CONFIG_842_DECOMPRESS=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_INTERVAL_TREE=y
CONFIG_RADIX_TREE_MULTIORDER=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
# CONFIG_DMA_NOOP_OPS is not set
# CONFIG_DMA_VIRT_OPS is not set
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_GLOB=y
CONFIG_GLOB_SELFTEST=m
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=m
# CONFIG_DDR is not set
# CONFIG_IRQ_POLL is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONT_8x16=y
CONFIG_FONT_AUTOSELECT=y
# CONFIG_SG_SPLIT is not set
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_SG_CHAIN=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_ARCH_HAS_MMIO_FLUSH=y
CONFIG_STACKDEPOT=y
CONFIG_SBITMAP=y

--=_592473d7.GhTTSot/dRvRsViweAavdcLadKnMmV0H59rGc5VT3B5pds3h--
