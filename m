Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([46.65.169.142]:35814 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3GHVlP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jul 2013 17:41:15 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] lirc: validate transmission ir data
Date: Mon,  8 Jul 2013 22:33:11 +0100
Message-Id: <1373319192-26816-4-git-send-email-sean@mess.org>
In-Reply-To: <1373319192-26816-1-git-send-email-sean@mess.org>
References: <1373319192-26816-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The lirc interface allows 255 u32 spaces and pulses, which are usec. If
the driver can handle this (e.g. winbond-cir) you can produce hours of
meaningless IR data and there is no method of interrupting it.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index e456126..e5be920 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -140,11 +140,20 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		goto out;
 	}
 
+	for (i = 0; i < count; i++) {
+		if (txbuf[i] > IR_MAX_DURATION / 1000 - duration || !txbuf[i]) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		duration += txbuf[i];
+	}
+
 	ret = dev->tx_ir(dev, txbuf, count);
 	if (ret < 0)
 		goto out;
 
-	for (i = 0; i < ret; i++)
+	for (duration = i = 0; i < ret; i++)
 		duration += txbuf[i];
 
 	ret *= sizeof(unsigned int);
-- 
1.8.3.1

