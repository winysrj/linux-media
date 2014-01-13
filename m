Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaAMVgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 16:36:20 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/7] [media] radio-usb-si4713: make si4713_register_i2c_adapter static
Date: Mon, 13 Jan 2014 16:32:33 -0200
Message-Id: <1389637958-3884-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
References: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function isn't used nowhere outside the same .c file.
Fixes this warning:

drivers/media/radio/si4713/radio-usb-si4713.c:418:5: warning: no previous prototype for 'si4713_register_i2c_adapter' [-Wmissing-prototypes]
 int si4713_register_i2c_adapter(struct si4713_usb_device *radio)
     ^

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/radio/si4713/radio-usb-si4713.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index d97884494d04..f1e640d71188 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -415,7 +415,7 @@ static struct i2c_adapter si4713_i2c_adapter_template = {
 	.algo   = &si4713_algo,
 };
 
-int si4713_register_i2c_adapter(struct si4713_usb_device *radio)
+static int si4713_register_i2c_adapter(struct si4713_usb_device *radio)
 {
 	radio->i2c_adapter = si4713_i2c_adapter_template;
 	/* set up sysfs linkage to our parent device */
-- 
1.8.3.1

