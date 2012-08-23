Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:41194 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab2HWVS2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 17:18:28 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH] [media] rc: fix buffer overrun
Date: Thu, 23 Aug 2012 22:18:25 +0100
Message-Id: <1345756705-17576-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"[media] rc-core: move timeout and checks to lirc" introduced a buffer
overrun by passing the number of bytes, rather than the number of samples,
to the transmit function.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 6ad4a07..569124b 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -140,7 +140,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	ret = dev->tx_ir(dev, txbuf, (u32)n);
+	ret = dev->tx_ir(dev, txbuf, count);
 	if (ret < 0)
 		goto out;
 
-- 
1.7.11.4

