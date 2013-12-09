Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36421 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3LITIY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 14:08:24 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] radio-bcm2048: fix signal of value
Date: Mon,  9 Dec 2013 14:05:33 -0200
Message-Id: <1386605133-8680-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As value can be initialized with a value lower than zero, change it
to int, to avoid those warnings:

drivers/staging/media/bcm2048/radio-bcm2048.c: In function 'bcm2048_rds_pi_read':
drivers/staging/media/bcm2048/radio-bcm2048.c:1989:9: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
  struct bcm2048_device *bdev = dev_get_drvdata(dev);  \
         ^
drivers/staging/media/bcm2048/radio-bcm2048.c:2070:1: note: in expansion of macro 'property_read'
 property_read(rds_pi, unsigned int, "%x")
 ^
drivers/staging/media/bcm2048/radio-bcm2048.c: In function 'bcm2048_fm_rds_flags_read':
drivers/staging/media/bcm2048/radio-bcm2048.c:1989:9: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
  struct bcm2048_device *bdev = dev_get_drvdata(dev);  \
         ^
drivers/staging/media/bcm2048/radio-bcm2048.c:2074:1: note: in expansion of macro 'property_read'
 property_read(fm_rds_flags, unsigned int, "%u")
 ^
drivers/staging/media/bcm2048/radio-bcm2048.c: In function 'bcm2048_region_bottom_frequency_read':
drivers/staging/media/bcm2048/radio-bcm2048.c:1989:9: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
  struct bcm2048_device *bdev = dev_get_drvdata(dev);  \
         ^
drivers/staging/media/bcm2048/radio-bcm2048.c:2077:1: note: in expansion of macro 'property_read'
 property_read(region_bottom_frequency, unsigned int, "%u")
 ^
drivers/staging/media/bcm2048/radio-bcm2048.c: In function 'bcm2048_region_top_frequency_read':
drivers/staging/media/bcm2048/radio-bcm2048.c:1989:9: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
  struct bcm2048_device *bdev = dev_get_drvdata(dev);  \
         ^
drivers/staging/media/bcm2048/radio-bcm2048.c:2078:1: note: in expansion of macro 'property_read'
 property_read(region_top_frequency, unsigned int, "%u")

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 782cc11fd037..494ec3916ef5 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -1987,7 +1987,7 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
 					char *buf)			\
 {									\
 	struct bcm2048_device *bdev = dev_get_drvdata(dev);		\
-	size value;							\
+	int value;							\
 									\
 	if (!bdev)							\
 		return -ENODEV;						\
-- 
1.8.3.1

