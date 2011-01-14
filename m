Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:49783 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786Ab1ANVvD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 16:51:03 -0500
Subject: [PATCH] ir-kbd-i2c: Add debug to examine received data in
 get_key_haup_common()
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@redhat.com>
Cc: Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org,
	Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Jan 2011 16:50:44 -0500
Message-ID: <1295041844.2459.15.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a hex dump of the received bytes for tester reporting of actual data
received from the hardware.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>

---
My heart won't be broken if this never makes it into the kernel.

Regards,
Andy

diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index c87b6bc..b27fc43 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -76,6 +76,11 @@ static int get_key_haup_common(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw,
 	if (size != i2c_master_recv(ir->c, buf, size))
 		return -EIO;
 
+	if (debug >= 2)
+		print_hex_dump_bytes(MODULE_NAME
+				     ": get_key_haup_common: received bytes: ",
+				     DUMP_PREFIX_NONE, buf, size);
+
 	/* split rc5 data block ... */
 	start  = (buf[offset] >> 7) &    1;
 	range  = (buf[offset] >> 6) &    1;


