Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:36888 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab3K0QPI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 11:15:08 -0500
Message-ID: <52961A85.4080009@gentoo.org>
Date: Wed, 27 Nov 2013 17:15:01 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, m.chehab@samsung.com
Subject: [PATCH] cx231xx: fix i2c debug prints
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not shift the already 7bit i2c address.
Print a message also for write+read transactions.
For write+read, print the read buffer correctly instead of using the write
buffer.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
  drivers/media/usb/cx231xx/cx231xx-i2c.c | 16 ++++++++++++----
  1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c 
b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 96a5a09..a0d2235 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -371,9 +371,9 @@ static int cx231xx_i2c_xfer(struct i2c_adapter 
*i2c_adap,
         mutex_lock(&dev->i2c_lock);
         for (i = 0; i < num; i++) {

-               addr = msgs[i].addr >> 1;
+               addr = msgs[i].addr;

-               dprintk2(2, "%s %s addr=%x len=%d:",
+               dprintk2(2, "%s %s addr=0x%x len=%d:",
                          (msgs[i].flags & I2C_M_RD) ? "read" : "write",
                          i == num - 1 ? "stop" : "nonstop", addr, 
msgs[i].len);
                 if (!msgs[i].len) {
@@ -395,13 +395,21 @@ static int cx231xx_i2c_xfer(struct i2c_adapter 
*i2c_adap,
                 } else if (i + 1 < num && (msgs[i + 1].flags & I2C_M_RD) &&
                            msgs[i].addr == msgs[i + 1].addr
                            && (msgs[i].len <= 2) && (bus->nr < 3)) {
+                       /* write bytes */
+                       if (i2c_debug >= 2) {
+                               for (byte = 0; byte < msgs[i].len; byte++)
+                                       printk(" %02x", msgs[i].buf[byte]);
+                       }
                         /* read bytes */
+                       dprintk2(2, "plus %s %s addr=0x%x len=%d:",
+                               (msgs[i+1].flags & I2C_M_RD) ? "read" : 
"write",
+                               i+1 == num - 1 ? "stop" : "nonstop", 
addr, msgs[i+1].len);
                         rc = cx231xx_i2c_recv_bytes_with_saddr(i2c_adap,
&msgs[i],
&msgs[i + 1]);
                         if (i2c_debug >= 2) {
-                               for (byte = 0; byte < msgs[i].len; byte++)
-                                       printk(" %02x", msgs[i].buf[byte]);
+                               for (byte = 0; byte < msgs[i+1].len; byte++)
+                                       printk(" %02x", 
msgs[i+1].buf[byte]);
                         }
                         i++;
                 } else {

