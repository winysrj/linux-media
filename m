Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47041 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaAEPJV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 10:09:21 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx: unregister i2c bus 0 if bus 1 fails to register
Date: Sun,  5 Jan 2014 10:05:53 -0200
Message-Id: <1388923553-24827-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the error handling logic, making it to unregister i2c bus 0, in
case of a failure to register the second bus.

Reported-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 541de6df127b..dbce4dc421f9 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2989,6 +2989,9 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 		if (retval < 0) {
 			em28xx_errdev("%s: em28xx_i2c_register bus 1 - error [%d]!\n",
 				__func__, retval);
+
+			em28xx_i2c_unregister(dev, 0);
+
 			return retval;
 		}
 	}
-- 
1.8.3.1

