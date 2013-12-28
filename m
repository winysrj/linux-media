Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab3L1MQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:29 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 18/24] em28xx: improve I2C timeout error message
Date: Sat, 28 Dec 2013 10:16:10 -0200
Message-Id: <1388232976-20061-19-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

Since sometimes em28xx is returning 0x02 or 0x04 at the I2C status
register, output what's the returned status:

[ 1090.939820] em2882/3 #0: write to i2c device at 0xc2 timed out (ret=0x04)
[ 1090.939826] xc2028 19-0061: Error on line 1290: -5
[ 1091.140136] em2882/3 #0: write to i2c device at 0xc2 timed out (ret=0x04)
[ 1091.140155] xc2028 19-0061: Error on line 1290: -5
[ 1091.828622] em2882/3 #0: write to i2c device at 0xc2 timed out (ret=0x02)
[ 1091.828625] xc2028 19-0061: i2c input error: rc = -5 (should be 2)
[ 1091.928731] em2882/3 #0: write to i2c device at 0xc2 timed out (ret=0x02)
[ 1091.928734] xc2028 19-0061: i2c input error: rc = -5 (should be 2)

As that may help to latter improve the code.

Also, as those errors are now present, remove that bogus comment that
only 0x00 and 0x10 values are present.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index d972e2f67214..420fddf7da3a 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -209,11 +209,6 @@ retry:
 			return ret;
 		}
 		msleep(5);
-		/*
-		 * NOTE: do we really have to wait for success ?
-		 * Never seen anything else than 0x00 or 0x10
-		 * (even with high payload) ...
-		 */
 	}
 
 	if (ret == 0x10) {
@@ -221,7 +216,8 @@ retry:
 			    addr);
 		return -ENODEV;
 	}
-	em28xx_warn("write to i2c device at 0x%x timed out\n", addr);
+	em28xx_warn("write to i2c device at 0x%x timed out (ret=0x%02x)\n",
+		    addr, ret);
 	return -EIO;
 }
 
-- 
1.8.3.1

