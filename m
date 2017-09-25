Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:58360 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934555AbdIYTPh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 15:15:37 -0400
To: linux-media@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Thomas Gleixner <tglx@linutronix.de>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] [media] cx88: Use common error handling code in
 get_key_pvr2000()
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <962b8373-ca02-b27a-cc25-eb9b4ac16e05@users.sourceforge.net>
Date: Mon, 25 Sep 2017 21:15:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 25 Sep 2017 21:03:57 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/cx88/cx88-input.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index e02449bf2041..001fbb97bcdf 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -566,20 +566,17 @@ static int get_key_pvr2000(struct IR_i2c *ir, enum rc_proto *protocol,
 
 	/* poll IR chip */
 	flags = i2c_smbus_read_byte_data(ir->c, 0x10);
-	if (flags < 0) {
-		dprintk("read error\n");
-		return 0;
-	}
+	if (flags < 0)
+		goto report_read_failure;
+
 	/* key pressed ? */
 	if (0 == (flags & 0x80))
 		return 0;
 
 	/* read actual key code */
 	code = i2c_smbus_read_byte_data(ir->c, 0x00);
-	if (code < 0) {
-		dprintk("read error\n");
-		return 0;
-	}
+	if (code < 0)
+		goto report_read_failure;
 
 	dprintk("IR Key/Flags: (0x%02x/0x%02x)\n",
 		code & 0xff, flags & 0xff);
@@ -588,6 +585,10 @@ static int get_key_pvr2000(struct IR_i2c *ir, enum rc_proto *protocol,
 	*scancode = code & 0xff;
 	*toggle = 0;
 	return 1;
+
+report_read_failure:
+	dprintk("read error\n");
+	return 0;
 }
 
 void cx88_i2c_init_ir(struct cx88_core *core)
-- 
2.14.1
