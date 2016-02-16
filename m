Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53925 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbcBPK3w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 05:29:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 2/3] [media] smsusb: don't sleep while atomic
Date: Tue, 16 Feb 2016 08:28:22 -0200
Message-Id: <b73aa272f5a35e846cdcd65138b25dc0d9684274.1455618493.git.mchehab@osg.samsung.com>
In-Reply-To: <57e8ce823fdb89814e1510d9708a2edac9b356e6.1455618493.git.mchehab@osg.samsung.com>
References: <57e8ce823fdb89814e1510d9708a2edac9b356e6.1455618493.git.mchehab@osg.samsung.com>
In-Reply-To: <57e8ce823fdb89814e1510d9708a2edac9b356e6.1455618493.git.mchehab@osg.samsung.com>
References: <57e8ce823fdb89814e1510d9708a2edac9b356e6.1455618493.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smscore_getbuffer() calls internally wait_event(), with can sleep.
As smsusb_onresponse() is called on interrupt context, this causes
the following warning:

	BUG: sleeping function called from invalid context at drivers/media/common/siano/smscoreapi.c:1653
	in_atomic(): 1, irqs_disabled(): 1, pid: 11084, name: systemd-udevd
	INFO: lockdep is turned off.
	irq event stamp: 0
	hardirqs last  enabled at (0): [<          (null)>]           (null)
	hardirqs last disabled at (0): [<ffffffff811480f7>] copy_process.part.7+0x10e7/0x56d0
	softirqs last  enabled at (0): [<ffffffff81148193>] copy_process.part.7+0x1183/0x56d0
	softirqs last disabled at (0): [<          (null)>]           (null)
	CPU: 2 PID: 11084 Comm: systemd-udevd Tainted: G    B   W       4.5.0-rc3+ #47
	Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
	 0000000000000000 ffff8803c6907a80 ffffffff81933901 ffff8802bd916000
	 ffff8802bd9165c8 ffff8803c6907aa8 ffffffff811c6af5 ffff8802bd916000
	 ffffffffa0ce9b60 0000000000000675 ffff8803c6907ae8 ffffffff811c6ce5
	Call Trace:
	 <IRQ>  [<ffffffff81933901>] dump_stack+0x85/0xc4
	 [<ffffffff811c6af5>] ___might_sleep+0x245/0x3a0
	 [<ffffffff811c6ce5>] __might_sleep+0x95/0x1a0
	 [<ffffffffa0ce020a>] ? list_add_locked+0xca/0x140 [smsmdtv]
	 [<ffffffffa0ce3b8d>] smscore_getbuffer+0x7d/0x120 [smsmdtv]
	 [<ffffffff8123819d>] ? trace_hardirqs_off+0xd/0x10
	 [<ffffffffa0ce3b10>] ? smscore_sendrequest_and_wait.isra.5+0x120/0x120 [smsmdtv]
	 [<ffffffffa0ce020a>] ? list_add_locked+0xca/0x140 [smsmdtv]
	 [<ffffffffa0ce13ca>] ? smscore_putbuffer+0x3a/0x40 [smsmdtv]
	 [<ffffffffa0d107bc>] smsusb_submit_urb+0x2ec/0x4f0 [smsusb]
	 [<ffffffffa0d10e36>] smsusb_onresponse+0x476/0x720 [smsusb]

Let's add a work queue to handle the bottom half, preventing this
problem.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/siano/smsusb.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 6cb4be6dddbb..8e0c05271a33 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -52,6 +52,9 @@ struct smsusb_urb_t {
 	struct smsusb_device_t *dev;
 
 	struct urb urb;
+
+	/* For the bottom half */
+	struct work_struct wq;
 };
 
 struct smsusb_device_t {
@@ -72,6 +75,18 @@ static int smsusb_submit_urb(struct smsusb_device_t *dev,
 			     struct smsusb_urb_t *surb);
 
 /**
+ * Completing URB's callback handler - bottom half (proccess context)
+ * submits the URB prepared on smsusb_onresponse()
+ */
+static void do_submit_urb(struct work_struct *work)
+{
+	struct smsusb_urb_t *surb = container_of(work, struct smsusb_urb_t, wq);
+	struct smsusb_device_t *dev = surb->dev;
+
+	smsusb_submit_urb(dev, surb);
+}
+
+/**
  * Completing URB's callback handler - top half (interrupt context)
  * adds completing sms urb to the global surbs list and activtes the worker
  * thread the surb
@@ -139,13 +154,15 @@ static void smsusb_onresponse(struct urb *urb)
 
 
 exit_and_resubmit:
-	smsusb_submit_urb(dev, surb);
+	INIT_WORK(&surb->wq, do_submit_urb);
+	schedule_work(&surb->wq);
 }
 
 static int smsusb_submit_urb(struct smsusb_device_t *dev,
 			     struct smsusb_urb_t *surb)
 {
 	if (!surb->cb) {
+		/* This function can sleep */
 		surb->cb = smscore_getbuffer(dev->coredev);
 		if (!surb->cb) {
 			pr_err("smscore_getbuffer(...) returned NULL\n");
-- 
2.5.0

