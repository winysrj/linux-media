Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64754 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933318AbdKAVGJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 03/26] media: led-class-flash: better handle NULL flash struct
Date: Wed,  1 Nov 2017 17:05:40 -0400
Message-Id: <7e38ad92ea843f1ec1130a64ab50afeb72b850c1.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic at V4L2 led core assumes that the flash struct
can be null. However, it doesn't check for null while
trying to set, causing some smatch  to warn:

	drivers/media/v4l2-core/v4l2-flash-led-class.c:210 v4l2_flash_s_ctrl() error: we previously assumed 'fled_cdev' could be null (see line 200)

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/linux/led-class-flash.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/led-class-flash.h b/include/linux/led-class-flash.h
index e97966d1fb8d..700efaa9e115 100644
--- a/include/linux/led-class-flash.h
+++ b/include/linux/led-class-flash.h
@@ -121,6 +121,8 @@ extern void led_classdev_flash_unregister(struct led_classdev_flash *fled_cdev);
 static inline int led_set_flash_strobe(struct led_classdev_flash *fled_cdev,
 					bool state)
 {
+	if (!fled_cdev)
+		return -EINVAL;
 	return fled_cdev->ops->strobe_set(fled_cdev, state);
 }
 
@@ -136,6 +138,8 @@ static inline int led_set_flash_strobe(struct led_classdev_flash *fled_cdev,
 static inline int led_get_flash_strobe(struct led_classdev_flash *fled_cdev,
 					bool *state)
 {
+	if (!fled_cdev)
+		return -EINVAL;
 	if (fled_cdev->ops->strobe_get)
 		return fled_cdev->ops->strobe_get(fled_cdev, state);
 
-- 
2.13.6
