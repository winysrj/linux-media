Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59075 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751944AbdHDOun (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 10:50:43 -0400
From: Sean Young <sean@mess.org>
To: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org
Subject: [PATCH] Revert "[media] lirc_dev: remove superfluous get/put_device() calls"
Date: Fri,  4 Aug 2017 15:50:41 +0100
Message-Id: <20170804145041.18866-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 5be2b76a9ca4ea5fd3e221114d62eeb0d78267ca.

Only when the lirc device is freed, should we drop our reference to
rc_dev, else we the rc_dev is freed to early. If userspace has
a file descriptor open during unplug, it goes bang.

==================================================================
BUG: KASAN: use-after-free in __lock_acquire+0x7bb/0x1e10
Read of size 8 at addr ffff8801d7d61ed0 by task ir-rec/2609

-snip-
 mutex_lock_nested+0x1b/0x20
 ? mutex_lock_nested+0x1b/0x20
 rc_close.part.6+0x20/0x60 [rc_core]
 rc_close+0x13/0x20 [rc_core]
 lirc_dev_fop_close+0x62/0xd0 [lirc_dev]
 __fput+0x236/0x410
 ? fput+0xb0/0xb0
 ? do_raw_spin_trylock+0x110/0x110
 ? set_rq_offline.part.70+0xa0/0xa0
 ____fput+0xe/0x10
 task_work_run+0x116/0x180
 ? task_work_cancel+0x170/0x170
 ? _raw_spin_unlock+0x27/0x40
 ? switch_task_namespaces+0x5f/0x90
 do_exit+0x68b/0xe80

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index db1e7b70c998..9080e39ea391 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -59,6 +59,8 @@ static void lirc_release(struct device *ld)
 {
 	struct irctl *ir = container_of(ld, struct irctl, dev);
 
+	put_device(ir->dev.parent);
+
 	if (ir->buf_internal) {
 		lirc_buffer_free(ir->buf);
 		kfree(ir->buf);
@@ -218,6 +220,8 @@ int lirc_register_driver(struct lirc_driver *d)
 
 	mutex_unlock(&lirc_dev_lock);
 
+	get_device(ir->dev.parent);
+
 	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
 		 ir->d.name, ir->d.minor);
 
-- 
2.13.3
