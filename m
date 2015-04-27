Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37246 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbbD0HaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 03:30:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] radio-bcm2048: fix compiler warning
Date: Mon, 27 Apr 2015 09:29:55 +0200
Message-Id: <1430119795-16527-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
References: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

radio-bcm2048.c: In function 'bcm2048_i2c_driver_probe':
radio-bcm2048.c:2597:11: warning: variable 'skip_release' set but not used [-Wunused-but-set-variable]
  int err, skip_release = 0;
             ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index bd50fb2..dbed3a2 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2594,7 +2594,7 @@ static int bcm2048_i2c_driver_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct bcm2048_device *bdev;
-	int err, skip_release = 0;
+	int err;
 
 	bdev = kzalloc(sizeof(*bdev), GFP_KERNEL);
 	if (!bdev) {
@@ -2647,7 +2647,6 @@ free_sysfs:
 	bcm2048_sysfs_unregister_properties(bdev, ARRAY_SIZE(attrs));
 free_registration:
 	video_unregister_device(&bdev->videodev);
-	skip_release = 1;
 free_irq:
 	if (client->irq)
 		free_irq(client->irq, bdev);
-- 
2.1.4

