Return-path: <mchehab@pedra>
Received: from ozlabs.org ([203.10.76.45]:55501 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab0KRGnP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 01:43:15 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] V4L/DVB: cx88: Add module parameter to disable IR
Message-Id: <1290062581.41867.321546213719.1.gpush@pororo>
To: <linux-media@vger.kernel.org>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Thu, 18 Nov 2010 14:43:01 +0800
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Jeremy Kerr <jk@ozlabs.org>

Currently, the cx88-input code unconditionally establishes an input
device for IR events. On some cards, this sets up a hrtimer to poll the
IR status frequently - I get around 200 wakeups per second from this
polling, and don't use the IR ports.

Although the hrtimer is only run when the input device is opened, the
device is actually unconditionally opened by kbd_connect, because we
have the EV_KEY bit set in the input device descriptor. In effect, the
IR device is always opened (and so polling) if CONFIG_VT.

This change adds a module parameter, 'ir_disable' to disable the IR
code, and not register this input device at all. This drastically
reduces the number of wakeups per second for me.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
 drivers/media/video/cx88/cx88-input.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index fc777bc..d49af18 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -67,6 +67,10 @@ static int ir_debug;
 module_param(ir_debug, int, 0644);	/* debug level [IR] */
 MODULE_PARM_DESC(ir_debug, "enable debug messages [IR]");
 
+static int ir_disable;
+module_param(ir_disable, int, 0644);
+MODULE_PARM_DESC(ir_disable, "disable IR support");
+
 #define ir_dprintk(fmt, arg...)	if (ir_debug) \
 	printk(KERN_DEBUG "%s IR: " fmt , ir->core->name , ##arg)
 
@@ -244,6 +248,9 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 				 * used with a full-code IR table
 				 */
 
+	if (ir_disable)
+		return 0;
+
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	input_dev = input_allocate_device();
 	if (!ir || !input_dev)
