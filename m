Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48081 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945225AbcJaRwc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 13:52:32 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 7/9] [media] lirc: might sleep error in lirc_dev_fop_read
Date: Mon, 31 Oct 2016 17:52:25 +0000
Message-Id: <1477936347-9029-8-git-send-email-sean@mess.org>
In-Reply-To: <1477936347-9029-1-git-send-email-sean@mess.org>
References: <1477936347-9029-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[  101.457944] ------------[ cut here ]------------
[  101.457954] WARNING: CPU: 3 PID: 1819 at kernel/sched/core.c:7708 __might_sleep+0x7e/0x80
[  101.457960] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffffc0364bc2>] lirc_dev_fop_read+0x292/0x4e0 [lirc_dev]

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 91f9bb8..bf4309f 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -684,7 +684,6 @@ ssize_t lirc_dev_fop_read(struct file *file,
 	 * between while condition checking and scheduling)
 	 */
 	add_wait_queue(&ir->buf->wait_poll, &wait);
-	set_current_state(TASK_INTERRUPTIBLE);
 
 	/*
 	 * while we didn't provide 'length' bytes, device is opened in blocking
@@ -709,13 +708,13 @@ ssize_t lirc_dev_fop_read(struct file *file,
 			}
 
 			mutex_unlock(&ir->irctl_lock);
-			schedule();
 			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+			set_current_state(TASK_RUNNING);
 
 			if (mutex_lock_interruptible(&ir->irctl_lock)) {
 				ret = -ERESTARTSYS;
 				remove_wait_queue(&ir->buf->wait_poll, &wait);
-				set_current_state(TASK_RUNNING);
 				goto out_unlocked;
 			}
 
@@ -735,7 +734,6 @@ ssize_t lirc_dev_fop_read(struct file *file,
 	}
 
 	remove_wait_queue(&ir->buf->wait_poll, &wait);
-	set_current_state(TASK_RUNNING);
 
 out_locked:
 	mutex_unlock(&ir->irctl_lock);
-- 
2.7.4

