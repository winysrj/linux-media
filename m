Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49969 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753451AbdLNRWB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 12:22:01 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 04/10] media: rc: bang in ir_do_keyup
Date: Thu, 14 Dec 2017 17:21:55 +0000
Message-Id: <1b036f5af4d9f26de84d026710e4e0d422cd0a25.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
In-Reply-To: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
References: <4e8c9939b6b116a54e3042d098343bc918268b1d.1513271970.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rc_keydown() can be called from interrupt context, by e.g. an rc scancode
driver. Since commit b2c96ba352b5 ("media: cec: move cec autorepeat
handling to rc-core"), the del_timer_sync() call is not happy about
being called in interrupt connect. del_timer() will suffice.

WARNING: CPU: 0 PID: 0 at kernel/time/timer.c:1285 del_timer_sync+0x1d/0x40
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W        4.15.0-rc1+ #1
Hardware name:                  /DG45ID, BIOS IDG4510H.86A.0135.2011.0225.1100 02/25/2011
task: ffffffffa3e10480 task.stack: ffffffffa3e00000
RIP: 0010:del_timer_sync+0x1d/0x40
RSP: 0018:ffff8b396bc03db0 EFLAGS: 00010046
RAX: 0000000080010000 RBX: ffff8b394d70e410 RCX: 0000000000000073
RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8b394d70e410
RBP: 0000000000000001 R08: ffffffffc0616000 R09: ffff8b396bfa3000
R10: 0000000000000000 R11: 0000000000000390 R12: ffff8b394f003800
R13: 0000000000000000 R14: ffff8b3771c19630 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8b396bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1944469000 CR3: 00000001ebe09000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 ir_do_keyup.part.5+0x22/0x90 [rc_core]
 rc_keyup+0x37/0x50 [rc_core]
 usb_rx_callback_intf0+0x79/0x90 [imon]
 __usb_hcd_giveback_urb+0x90/0x130
 uhci_giveback_urb+0xab/0x250
 uhci_scan_schedule.part.34+0x806/0xb00
 uhci_irq+0xab/0x150
 usb_hcd_irq+0x22/0x30
 __handle_irq_event_percpu+0x3a/0x180
 handle_irq_event_percpu+0x30/0x70
 handle_irq_event+0x27/0x50
 handle_fasteoi_irq+0x6b/0x110
 handle_irq+0xa5/0x100
 do_IRQ+0x41/0xc0
 common_interrupt+0x96/0x96
 </IRQ>
RIP: 0010:cpuidle_enter_state+0x9a/0x2d0
RSP: 0018:ffffffffa3e03e88 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffda
RAX: ffff8b396bc1a000 RBX: 00000010da7bcd63 RCX: 00000010da7bccf6
RDX: 00000010da7bcd63 RSI: 00000010da7bcd63 RDI: 0000000000000000
RBP: ffff8b394f587400 R08: 0000000000000000 R09: 0000000000000002
R10: ffffffffa3e03e48 R11: 0000000000000390 R12: 0000000000000003
R13: ffffffffa3ebf018 R14: 0000000000000000 R15: 00000010da7ba772
 ? cpuidle_enter_state+0x8d/0x2d0
 do_idle+0x17b/0x1d0
 cpu_startup_entry+0x6f/0x80
 start_kernel+0x4a7/0x4c7
 secondary_startup_64+0xa5/0xb0
Code: e7 5b 5d 41 5c e9 84 88 05 00 0f 1f 40 00 66 66 66 66 90 65 8b 05 e4 6f ef 5c a9 00 00 0f 00 53 48 89 fb 74 16 f6 47 22 20 75 10 <0f> ff 48 89 df e8 89 f1 ff ff 85 c0 79 0e f3 90 48 89 df e8 7b

Fixes: b2c96ba352b5 ("media: cec: move cec autorepeat handling to rc-core")

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1870b7999062..1db8d38fed7c 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -597,7 +597,7 @@ static void ir_do_keyup(struct rc_dev *dev, bool sync)
 		return;
 
 	IR_dprintk(1, "keyup key 0x%04x\n", dev->last_keycode);
-	del_timer_sync(&dev->timer_repeat);
+	del_timer(&dev->timer_repeat);
 	input_report_key(dev->input_dev, dev->last_keycode, 0);
 	led_trigger_event(led_feedback, LED_OFF);
 	if (sync)
-- 
2.14.3
