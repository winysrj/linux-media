Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36783 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033478AbdEWViz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 17:38:55 -0400
Date: Tue, 23 May 2017 22:38:47 +0100
From: Sean Young <sean@mess.org>
To: kernel test robot <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        wfg@linux.intel.com
Subject: Re: [[media] sir_ir] 592ddc9f7d:  BUG: unable to handle kernel NULL
 pointer dereference at 00000000000005b8
Message-ID: <20170523213847.GA6902@gofer.mess.org>
References: <592473d7.6iRq9pjNkVk+nmfn%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <592473d7.6iRq9pjNkVk+nmfn%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 24, 2017 at 01:39:35AM +0800, kernel test robot wrote:
> Greetings,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> 
> commit 592ddc9f7db36c778d3bf9ffdfd93d8d5d548e48
> Author:     Sean Young <sean@mess.org>
> AuthorDate: Tue May 16 04:56:14 2017 -0300
> Commit:     Mauro Carvalho Chehab <mchehab@s-opensource.com>
> CommitDate: Thu May 18 06:16:41 2017 -0300
> 
>     [media] sir_ir: infinite loop in interrupt handler
>     
>     Since this driver does no detection of hardware, it might be used with
>     a non-sir port. Escape out if we are spinning.
>     
>     Reported-by: kbuild test robot <fengguang.wu@intel.com>
>     Signed-off-by: Sean Young <sean@mess.org>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> 
> dd8245f445  [media] atomisp: don't treat warnings as errors
> 592ddc9f7d  [media] sir_ir: infinite loop in interrupt handler
> f482797714  Add linux-next specific files for 20170523
> +------------------------------------------------------------------+------------+------------+---------------+
> |                                                                  | dd8245f445 | 592ddc9f7d | next-20170523 |
> +------------------------------------------------------------------+------------+------------+---------------+
> | boot_successes                                                   | 33         | 0          | 0             |
> | boot_failures                                                    | 2          | 15         | 2             |
> | invoked_oom-killer:gfp_mask=0x                                   | 2          |            |               |
> | Mem-Info                                                         | 2          |            |               |
> | Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes | 2          |            |               |
> | BUG:unable_to_handle_kernel                                      | 0          | 14         | 2             |
> | Oops:#[##]                                                       | 0          | 14         | 2             |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt            | 0          | 15         | 2             |
> | general_protection_fault:#[##]                                   | 0          | 1          |               |
> +------------------------------------------------------------------+------------+------------+---------------+
> 
> [    2.947120] page_owner is disabled
> [    2.949932] Key type encrypted registered
> [    2.949932] Key type encrypted registered
> [    2.956911] platform sir_ir.0: Trapped in interrupt
> [    2.956911] platform sir_ir.0: Trapped in interrupt
> [    2.958377] BUG: unable to handle kernel NULL pointer dereference at 00000000000005b8
> [    2.958377] BUG: unable to handle kernel NULL pointer dereference at 00000000000005b8
> [    2.960689] IP: __lock_acquire+0xdb/0x1280
> [    2.960689] IP: __lock_acquire+0xdb/0x1280
> [    2.961900] PGD 0 
> [    2.961900] PGD 0 
> [    2.961903] P4D 0 
> [    2.961903] P4D 0 
> [    2.962511] 
> [    2.962511] 
> [    2.963568] Oops: 0000 [#1] PREEMPT
> [    2.963568] Oops: 0000 [#1] PREEMPT
> [    2.964602] Modules linked in:
> [    2.964602] Modules linked in:
> [    2.965515] CPU: 0 PID: 1 Comm: swapper Not tainted 4.12.0-rc1-00003-g592ddc9 #1
> [    2.965515] CPU: 0 PID: 1 Comm: swapper Not tainted 4.12.0-rc1-00003-g592ddc9 #1
> [    2.967675] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
> [    2.967675] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-20161025_171302-gandalf 04/01/2014
> [    2.970647] task: ffff99608f33e540 task.stack: ffff99608f334000
> [    2.970647] task: ffff99608f33e540 task.stack: ffff99608f334000
> [    2.972382] RIP: 0010:__lock_acquire+0xdb/0x1280
> [    2.972382] RIP: 0010:__lock_acquire+0xdb/0x1280
> [    2.973746] RSP: 0000:ffffffffacc35cb0 EFLAGS: 00010002
> [    2.973746] RSP: 0000:ffffffffacc35cb0 EFLAGS: 00010002
> [    2.975277] RAX: 0000000000000046 RBX: 0000000000000001 RCX: 0000000000000000
> [    2.975277] RAX: 0000000000000046 RBX: 0000000000000001 RCX: 0000000000000000
> [    2.977365] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [    2.977365] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [    2.979460] RBP: ffffffffacc35d50 R08: 0000000000000001 R09: 0000000000000001
> [    2.979460] RBP: ffffffffacc35d50 R08: 0000000000000001 R09: 0000000000000001
> [    2.981553] R10: 0000000000000000 R11: ffffffffabcc9fd3 R12: 00000000000005b8
> [    2.981553] R10: 0000000000000000 R11: ffffffffabcc9fd3 R12: 00000000000005b8
> [    2.983641] R13: ffff99608f33e540 R14: 0000000000000001 R15: 0000000000000000
> [    2.983641] R13: ffff99608f33e540 R14: 0000000000000001 R15: 0000000000000000
> [    2.985726] FS:  0000000000000000(0000) GS:ffffffffacc32000(0000) knlGS:0000000000000000
> [    2.985726] FS:  0000000000000000(0000) GS:ffffffffacc32000(0000) knlGS:0000000000000000
> [    2.988089] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.988089] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    2.989776] CR2: 00000000000005b8 CR3: 0000000010617000 CR4: 00000000001406f0
> [    2.989776] CR2: 00000000000005b8 CR3: 0000000010617000 CR4: 00000000001406f0
> [    2.991866] Call Trace:
> [    2.991866] Call Trace:
> [    2.992600]  <IRQ>
> [    2.992600]  <IRQ>
> [    2.993208]  lock_acquire+0xba/0x1c0
> [    2.993208]  lock_acquire+0xba/0x1c0
> [    2.994271]  ? try_to_wake_up+0x4a/0x530
> [    2.994271]  ? try_to_wake_up+0x4a/0x530
> [    2.995432]  ? lock_acquire+0xba/0x1c0
> [    2.995432]  ? lock_acquire+0xba/0x1c0
> [    2.996551]  ? try_to_wake_up+0x33/0x530
> [    2.996551]  ? try_to_wake_up+0x33/0x530
> [    2.997720]  _raw_spin_lock_irqsave+0x50/0x8b
> [    2.997720]  _raw_spin_lock_irqsave+0x50/0x8b
> [    2.999008]  ? try_to_wake_up+0x33/0x530
> [    2.999008]  ? try_to_wake_up+0x33/0x530
> [    3.000167]  try_to_wake_up+0x33/0x530
> [    3.000167]  try_to_wake_up+0x33/0x530
> [    3.001279]  wake_up_process+0x15/0x20
> [    3.001279]  wake_up_process+0x15/0x20
> [    3.002391]  ir_raw_event_handle+0x2c/0x40
> [    3.002391]  ir_raw_event_handle+0x2c/0x40
> [    3.003613]  sir_interrupt+0x248/0x260
> [    3.003613]  sir_interrupt+0x248/0x260
> [    3.004728]  __handle_irq_event_percpu+0x67/0x410
> [    3.004728]  __handle_irq_event_percpu+0x67/0x410
> [    3.006119]  handle_irq_event_percpu+0x2b/0x70
> [    3.006119]  handle_irq_event_percpu+0x2b/0x70
> [    3.007436]  handle_irq_event+0x3e/0x60
> [    3.007436]  handle_irq_event+0x3e/0x60
> [    3.008578]  handle_edge_irq+0xbc/0x1f0
> [    3.008578]  handle_edge_irq+0xbc/0x1f0
> [    3.009717]  handle_irq+0x1a/0x30
> [    3.009717]  handle_irq+0x1a/0x30
> [    3.010700]  do_IRQ+0x65/0x130
> [    3.010700]  do_IRQ+0x65/0x130
> [    3.011614]  common_interrupt+0x91/0x91
> [    3.011614]  common_interrupt+0x91/0x91

This is another issue, not a regression. This is a race condition between
the driver calling ir_raw_event_handle() and in ir_raw_event_register(),
dev->raw being set but dev->raw->thread not yet.

I think this issue has always existed, but only just been found by 0day,
good catch!

I'll send a patch as a reply this email, although I'm a bit busy for
the rest of the week..

Thanks
Sean
