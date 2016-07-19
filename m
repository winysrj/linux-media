Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:43900 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbcGSP5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 11:57:12 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [RFC 5/7] [media] ir-lirc-codec: do not handle any buffer for raw
 transmitters
Date: Wed, 20 Jul 2016 00:56:56 +0900
Message-id: <1468943818-26025-6-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Raw transmitters receive the data which need to be sent to
receivers from userspace as stream of bits, they don't require
any handling from the lirc framework.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/ir-lirc-codec.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 5effc65..80e94b6 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -121,17 +121,6 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (!lirc)
 		return -EFAULT;
 
-	if (n < sizeof(unsigned) || n % sizeof(unsigned))
-		return -EINVAL;
-
-	count = n / sizeof(unsigned);
-	if (count > LIRCBUF_SIZE || count % 2 == 0)
-		return -EINVAL;
-
-	txbuf = memdup_user(buf, n);
-	if (IS_ERR(txbuf))
-		return PTR_ERR(txbuf);
-
 	dev = lirc->dev;
 	if (!dev) {
 		ret = -EFAULT;
@@ -143,6 +132,25 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		goto out;
 	}
 
+	if (dev->driver_type == RC_DRIVER_IR_RAW_TX) {
+		txbuf = memdup_user(buf, n);
+		if (IS_ERR(txbuf))
+			return PTR_ERR(txbuf);
+
+		return dev->tx_ir(dev, txbuf, n);
+	}
+
+	if (n < sizeof(unsigned) || n % sizeof(unsigned))
+		return -EINVAL;
+
+	count = n / sizeof(unsigned);
+	if (count > LIRCBUF_SIZE || count % 2 == 0)
+		return -EINVAL;
+
+	txbuf = memdup_user(buf, n);
+	if (IS_ERR(txbuf))
+		return PTR_ERR(txbuf);
+
 	for (i = 0; i < count; i++) {
 		if (txbuf[i] > IR_MAX_DURATION / 1000 - duration || !txbuf[i]) {
 			ret = -EINVAL;
-- 
2.8.1

