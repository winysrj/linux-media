Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44280 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab2EWJyx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:53 -0400
Subject: [PATCH 11/43] mceusb: remove pointless kmalloc
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:42:58 +0200
Message-ID: <20120523094258.14474.1303.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The previous code allocated a char buffer of size MCE_CMDBUF_SIZE (384) by
kzalloc():ing sizeof(unsigned) * MCE_CMDBUF_SIZE bytes.

The buffer was therefore 4 * the necessary size.

Additionally, zeroing out the buffer is pointless.

Replace the allocated buffer with a stack buffer.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/mceusb.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index f0f053d..9f546be 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -785,11 +785,7 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	struct mceusb_dev *ir = dev->priv;
 	int i, ret = 0;
 	int cmdcount = 0;
-	unsigned char *cmdbuf; /* MCE command buffer */
-
-	cmdbuf = kzalloc(sizeof(unsigned) * MCE_CMDBUF_SIZE, GFP_KERNEL);
-	if (!cmdbuf)
-		return -ENOMEM;
+	unsigned char cmdbuf[MCE_CMDBUF_SIZE]; /* MCE command buffer */
 
 	/* MCE tx init header */
 	cmdbuf[cmdcount++] = MCE_CMD_PORT_IR;
@@ -841,7 +837,6 @@ static int mceusb_tx_ir(struct rc_dev *dev, unsigned *txbuf, unsigned count)
 	mce_async_out(ir, cmdbuf, cmdcount);
 
 out:
-	kfree(cmdbuf);
 	return ret ? ret : count;
 }
 

