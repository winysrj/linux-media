Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.rdslink.ro ([81.196.12.70]:54792 "EHLO smtp.rdslink.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751386Ab0CUSBS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Mar 2010 14:01:18 -0400
Subject: 0004-Staging-cx25821-fix-coding-style-issues-in-cx25821-i.patch
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com,
	palash.bandyopadhyay@conexant.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Sun, 21 Mar 2010 20:01:13 +0200
Message-ID: <1269194473.6971.8.camel@tuxtm-linux>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 5f02f6af270ce061174806a039d8d44a35b2ce5e Mon Sep 17 00:00:00 2001
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Date: Sun, 21 Mar 2010 19:52:31 +0200
Subject: [PATCH 4/4] Staging: cx25821: fix coding style issues in cx25821-i2c.c
 This is a patch to cx25821-i2c.c file that fixes up warnings and errors found by the checkpatch.pl tool
 Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>

---
 drivers/staging/cx25821/cx25821-i2c.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index f4f2681..f727b85 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -159,9 +159,9 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 
 	return msg->len;
 
-      eio:
+eio:
 	retval = -EIO;
-      err:
+err:
 	if (i2c_debug)
 		printk(KERN_ERR " ERR: %d\n", retval);
 	return retval;
@@ -223,9 +223,9 @@ static int i2c_readbytes(struct i2c_adapter *i2c_adap,
 	}
 
 	return msg->len;
-      eio:
+eio:
 	retval = -EIO;
-      err:
+err:
 	if (i2c_debug)
 		printk(KERN_ERR " ERR: %d\n", retval);
 	return retval;
@@ -266,7 +266,7 @@ static int i2c_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg *msgs, int num)
 	}
 	return num;
 
-      err:
+err:
 	return retval;
 }
 
@@ -319,7 +319,7 @@ int cx25821_i2c_register(struct cx25821_i2c *bus)
 
 	bus->i2c_client.adapter = &bus->i2c_adap;
 
-	//set up the I2c
+	/* set up the I2c */
 	bus->i2c_client.addr = (0x88 >> 1);
 
 	return bus->i2c_rc;
-- 
1.7.0



