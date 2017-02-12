Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36207 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbdBLRB3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 12:01:29 -0500
Received: by mail-wm0-f67.google.com with SMTP id r18so15040168wmd.3
        for <linux-media@vger.kernel.org>; Sun, 12 Feb 2017 09:01:28 -0800 (PST)
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        =?UTF-8?B?QW50dGkgU2VwcMOkbMOk?= <a.seppala@gmail.com>,
        James Hogan <james@albanarts.com>, Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: nuvoton: fix deadlock in nvt_write_wakeup_codes
Message-ID: <3bf59b6c-f4be-1653-4f84-8668cf8581a1@gmail.com>
Date: Sun, 12 Feb 2017 18:01:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

nvt_write_wakeup_codes acquires the same lock as the ISR but doesn't
disable interrupts on the local CPU. This caused the following
deadlock. Fix this by using spin_lock_irqsave.

[  432.362008] ================================
[  432.362074] WARNING: inconsistent lock state
[  432.362144] 4.10.0-rc7-next-20170210 #1 Not tainted
[  432.362219] --------------------------------
[  432.362286] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[  432.362379] swapper/0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  432.362457]  (&(&nvt->lock)->rlock){?.+...}, at: [<ffffffffa016b17d>] nvt_cir_isr+0x2d/0x520 [nuvoton_cir]
[  432.362611] {HARDIRQ-ON-W} state was registered at:
[  432.362686]
[  432.362698] [<ffffffff810adb7c>] __lock_acquire+0x5dc/0x1260
[  432.362812]
[  432.362817] [<ffffffff810aec29>] lock_acquire+0xe9/0x1d0
[  432.362927]
[  432.362934] [<ffffffff81609f63>] _raw_spin_lock+0x33/0x50
[  432.363045]
[  432.363051] [<ffffffffa016b822>] nvt_write_wakeup_codes.isra.12+0x22/0xe0 [nuvoton_cir]
[  432.363193]
[  432.363199] [<ffffffffa016b9bf>] wakeup_data_store+0xdf/0xf0 [nuvoton_cir]
[  432.363327]
[  432.363333] [<ffffffff81484223>] dev_attr_store+0x13/0x20
[  432.363441]
[  432.363449] [<ffffffff81232450>] sysfs_kf_write+0x40/0x50
[  432.363558]
[  432.363564] [<ffffffff81231640>] kernfs_fop_write+0x150/0x1e0
[  432.363676]
[  432.363685] [<ffffffff811b36a3>] __vfs_write+0x23/0x120
[  432.363791]
[  432.363798] [<ffffffff811b4d53>] vfs_write+0xc3/0x1e0
[  432.363902]
[  432.363909] [<ffffffff811b6124>] SyS_write+0x44/0xa0
[  432.364012]
[  432.364021] [<ffffffff81002c47>] do_syscall_64+0x57/0x140
[  432.364129]
[  432.364135] [<ffffffff8160a9e4>] return_from_SYSCALL_64+0x0/0x7a
[  432.364252] irq event stamp: 415118
[  432.364313] hardirqs last  enabled at (415115): [<ffffffff814fd2eb>] cpuidle_enter_state+0x11b/0x370
[  432.364445] hardirqs last disabled at (415116): [<ffffffff8160b2cb>] common_interrupt+0x8b/0x90
[  432.364573] softirqs last  enabled at (415118): [<ffffffff8106157c>] _local_bh_enable+0x1c/0x50
[  432.364699] softirqs last disabled at (415117): [<ffffffff810629a3>] irq_enter+0x43/0x60
[  432.364814]
               other info that might help us debug this:
[  432.364909]  Possible unsafe locking scenario:

[  432.367821]        CPU0
[  432.370645]        ----
[  432.373432]   lock(&(&nvt->lock)->rlock);
[  432.376228]   <Interrupt>
[  432.378982]     lock(&(&nvt->lock)->rlock);
[  432.381757]
                *** DEADLOCK ***

[  432.389888] no locks held by swapper/0/0.
[  432.392574]
               stack backtrace:
[  432.397774] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.10.0-rc7-next-20170210 #1
[  432.400375] Hardware name: ZOTAC ZBOX-CI321NANO/ZBOX-CI321NANO, BIOS B246P105 06/01/2015
[  432.403023] Call Trace:
[  432.405636]  <IRQ>
[  432.408208]  dump_stack+0x68/0x93
[  432.410775]  print_usage_bug+0x1dd/0x1f0
[  432.413334]  mark_lock+0x559/0x5c0
[  432.415871]  ? print_shortest_lock_dependencies+0x1a0/0x1a0
[  432.418431]  __lock_acquire+0x6b1/0x1260
[  432.420941]  lock_acquire+0xe9/0x1d0
[  432.423396]  ? nvt_cir_isr+0x2d/0x520 [nuvoton_cir]
[  432.425844]  _raw_spin_lock+0x33/0x50
[  432.428252]  ? nvt_cir_isr+0x2d/0x520 [nuvoton_cir]
[  432.430670]  nvt_cir_isr+0x2d/0x520 [nuvoton_cir]
[  432.433085]  __handle_irq_event_percpu+0x43/0x330
[  432.435493]  handle_irq_event_percpu+0x1e/0x50
[  432.437884]  handle_irq_event+0x34/0x60
[  432.440236]  handle_edge_irq+0x6a/0x150
[  432.442561]  handle_irq+0x15/0x20
[  432.444854]  do_IRQ+0x57/0x110
[  432.447115]  common_interrupt+0x90/0x90
[  432.449380] RIP: 0010:cpuidle_enter_state+0x120/0x370
[  432.451653] RSP: 0018:ffffffff81c03dd8 EFLAGS: 00000206 ORIG_RAX: ffffffffffffffcc
[  432.453994] RAX: ffffffff81c14500 RBX: 0000000000000008 RCX: 00000064aac6f2d2
[  432.456349] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81c14500
[  432.458704] RBP: ffffffff81c03e18 R08: cccccccccccccccd R09: 0000000000000018
[  432.461072] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880100a21260
[  432.463450] R13: ffffffff81c7e6f8 R14: 0000000000000008 R15: ffffffff81c7e6e0
[  432.465819]  </IRQ>
[  432.468104]  ? cpuidle_enter_state+0x11b/0x370
[  432.470413]  cpuidle_enter+0x12/0x20
[  432.472698]  call_cpuidle+0x1e/0x40
[  432.474967]  do_idle+0xe3/0x1c0
[  432.477172]  cpu_startup_entry+0x18/0x20
[  432.479376]  rest_init+0x130/0x140
[  432.481565]  start_kernel+0x3cc/0x3d9
[  432.483750]  x86_64_start_reservations+0x2a/0x2c
[  432.485980]  x86_64_start_kernel+0x178/0x18b
[  432.488222]  start_cpu+0x14/0x14
[  432.490453]  ? start_cpu+0x14/0x14

Fixes: 97c129747af5 "[media] rc: nuvoton-cir: Add support wakeup via sysfs filter callback"
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/nuvoton-cir.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index b109f824..ec4b25bd 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -176,12 +176,13 @@ static void nvt_write_wakeup_codes(struct rc_dev *dev,
 {
 	u8 tolerance, config;
 	struct nvt_dev *nvt = dev->priv;
+	unsigned long flags;
 	int i;
 
 	/* hardcode the tolerance to 10% */
 	tolerance = DIV_ROUND_UP(count, 10);
 
-	spin_lock(&nvt->lock);
+	spin_lock_irqsave(&nvt->lock, flags);
 
 	nvt_clear_cir_wake_fifo(nvt);
 	nvt_cir_wake_reg_write(nvt, count, CIR_WAKE_FIFO_CMP_DEEP);
@@ -203,7 +204,7 @@ static void nvt_write_wakeup_codes(struct rc_dev *dev,
 
 	nvt_cir_wake_reg_write(nvt, config, CIR_WAKE_IRCON);
 
-	spin_unlock(&nvt->lock);
+	spin_unlock_irqrestore(&nvt->lock, flags);
 }
 
 static ssize_t wakeup_data_show(struct device *dev,
-- 
2.11.1
