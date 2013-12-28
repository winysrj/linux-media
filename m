Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50197 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab3L1MQ2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:16:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 14/24] em28xx: remove a false positive warning
Date: Sat, 28 Dec 2013 10:16:06 -0200
Message-Id: <1388232976-20061-15-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

gcc knows nothing about jiffies. So, it produces this error:

	drivers/media/usb/em28xx/em28xx-i2c.c: In function ‘em28xx_i2c_recv_bytes’:
	drivers/media/usb/em28xx/em28xx-i2c.c:274:5: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]

It is a false positive, however, removing it is as easy as replacing
a while by a do/while construction.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 26f7b0a2e83a..d972e2f67214 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -241,7 +241,7 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 	 * Zero length reads always succeed, even if no device is connected
 	 */
 
-	while (time_is_after_jiffies(timeout)) {
+	do {
 		/* Read data from i2c device */
 		ret = dev->em28xx_read_reg_req_len(dev, 2, addr, buf, len);
 		if (ret < 0) {
@@ -270,7 +270,8 @@ static int em28xx_i2c_recv_bytes(struct em28xx *dev, u16 addr, u8 *buf, u16 len)
 		if (ret != 0x10)
 			break;
 		msleep(5);
-	}
+	} while (time_is_after_jiffies(timeout));
+
 	if (ret == 0x10) {
 		em28xx_warn("I2C transfer timeout on read from addr 0x%02x", addr);
 		return -ENODEV;
-- 
1.8.3.1

