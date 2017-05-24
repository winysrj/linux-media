Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55119 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936287AbdEXPUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 11:20:23 -0400
Date: Wed, 24 May 2017 16:20:21 +0100
From: Sean Young <sean@mess.org>
To: kernel test robot <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        wfg@linux.intel.com
Subject: [PATCH] [media] rc-core: race condition before rc_register_device()
Message-ID: <20170524152021.GA20380@gofer.mess.org>
References: <592473d7.6iRq9pjNkVk+nmfn%fengguang.wu@intel.com>
 <20170523213847.GA6902@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170523213847.GA6902@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A rc device can call ir_raw_event_handle() after rc_allocate_device(),
but before rc_register_device() has completed. This is racey because
rcdev->raw is set before rcdev->raw->thread has a valid value.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-ir-raw.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
index 90f66dc..a2fc1a1 100644
--- a/drivers/media/rc/rc-ir-raw.c
+++ b/drivers/media/rc/rc-ir-raw.c
@@ -211,7 +211,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_set_idle);
  */
 void ir_raw_event_handle(struct rc_dev *dev)
 {
-	if (!dev->raw)
+	if (!dev->raw || !dev->raw->thread)
 		return;
 
 	wake_up_process(dev->raw->thread);
@@ -490,6 +490,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 {
 	int rc;
 	struct ir_raw_handler *handler;
+	struct task_struct *thread;
 
 	if (!dev)
 		return -EINVAL;
@@ -507,13 +508,15 @@ int ir_raw_event_register(struct rc_dev *dev)
 	 * because the event is coming from userspace
 	 */
 	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
-		dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-					       "rc%u", dev->minor);
+		thread = kthread_run(ir_raw_event_thread, dev->raw, "rc%u",
+				     dev->minor);
 
-		if (IS_ERR(dev->raw->thread)) {
-			rc = PTR_ERR(dev->raw->thread);
+		if (IS_ERR(thread)) {
+			rc = PTR_ERR(thread);
 			goto out;
 		}
+
+		dev->raw->thread = thread;
 	}
 
 	mutex_lock(&ir_raw_handler_lock);
-- 
2.9.4
