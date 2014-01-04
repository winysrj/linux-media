Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaADN7R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jan 2014 08:59:17 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v4 17/22] [media] em28xx-i2c: Fix error code for I2C error transfers
Date: Sat,  4 Jan 2014 08:55:46 -0200
Message-Id: <1388832951-11195-18-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The proper error code for I2C errors are EREMOTEIO. The em28xx driver
is using EIO instead.

Replace all occurrences of EIO at em28xx-i2c, in order to fix it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 9fa7ed51e5b1..8b35aa51b9bb 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -72,7 +72,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	if (ret != 2 + len) {
 		em28xx_warn("failed to trigger write to i2c address 0x%x (error=%i)\n",
 			    addr, ret);
-		return (ret < 0) ? ret : -EIO;
+		return (ret < 0) ? ret : -EREMOTEIO;
 	}
 	/* wait for completion */
 	while (time_is_after_jiffies(timeout)) {
@@ -91,7 +91,7 @@ static int em2800_i2c_send_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 		msleep(5);
 	}
 	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
-	return -EIO;
+	return -EREMOTEIO;
 }
 
 /*
@@ -115,7 +115,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	if (ret != 2) {
 		em28xx_warn("failed to trigger read from i2c address 0x%x (error=%i)\n",
 			    addr, ret);
-		return (ret < 0) ? ret : -EIO;
+		return (ret < 0) ? ret : -EREMOTEIO;
 	}
 
 	/* wait for completion */
@@ -142,7 +142,7 @@ static int em2800_i2c_recv_bytes(struct em28xx *dev, u8 addr, u8 *buf, u16 len)
 	if (ret != len) {
 		em28xx_warn("reading from i2c device at 0x%x failed: couldn't get the received message from the bridge (error=%i)\n",
 			    addr, ret);
-		return (ret < 0) ? ret : -EIO;
+		return (ret < 0) ? ret : -EREMOTEIO;
 	}
 	for (i = 0; i < len; i++)
 		buf[i] = buf2[len - 1 - i];
@@ -162,7 +162,7 @@ static int em2800_i2c_check_for_device(struct em28xx *dev, u8 addr)
 	ret = em2800_i2c_recv_bytes(dev, addr, &buf, 1);
 	if (ret == 1)
 		return 0;
-	return (ret < 0) ? ret : -EIO;
+	return (ret < 0) ? ret : -EREMOTEIO;
 }
 
 /*
@@ -191,7 +191,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		} else {
 			em28xx_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
 				    len, addr, ret);
-			return -EIO;
+			return -EREMOTEIO;
 		}
 	}
 
@@ -219,7 +219,7 @@ static int em28xx_i2c_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 	}
 
 	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
-	return -EIO;
+	return -EREMOTEIO;
 }
 
 /*
@@ -268,7 +268,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	}
 
 	em28xx_warn("unknown i2c error (status=%i)\n", ret);
-	return -EIO;
+	return -EREMOTEIO;
 }
 
 /*
@@ -283,7 +283,7 @@ static int em28xx_i2c_check_for_device(struct em28xx *dev, u16 addr)
 	ret = em28xx_i2c_recv_bytes(dev, addr, &buf, 1);
 	if (ret == 1)
 		return 0;
-	return (ret < 0) ? ret : -EIO;
+	return (ret < 0) ? ret : -EREMOTEIO;
 }
 
 /*
@@ -312,7 +312,7 @@ static int em25xx_bus_B_send_bytes(struct em28xx *dev, u16 addr, u8 *buf,
 		} else {
 			em28xx_warn("%i bytes write to i2c device at 0x%x requested, but %i bytes written\n",
 				    len, addr, ret);
-			return -EIO;
+			return -EREMOTEIO;
 		}
 	}
 	/* Check success */
-- 
1.8.3.1

