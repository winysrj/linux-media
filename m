Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:34251 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992579AbbEOVdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 17:33:00 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	maxx <maxx@spaceboyz.net>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] radio-bcm2048: Fix region selection
Date: Fri, 15 May 2015 23:32:51 +0200
Message-Id: <1431725571-7417-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: maxx <maxx@spaceboyz.net>

This actually fixes region selection for BCM2048 FM receiver. To select
the japanese FM-band an additional bit in FM_CTRL register needs to be
set. This might not sound so important but it enables at least me to
listen to some 'very interesting' radio transmission below normal
FM-band.

Patch writen by maxx@spaceboyz.net

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Cc: maxx@spaceboyz.net
---
 drivers/staging/media/bcm2048/radio-bcm2048.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index aeb6c3c..1482d4b 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -739,7 +739,20 @@ static int bcm2048_set_region(struct bcm2048_device *bdev, u8 region)
 		return -EINVAL;
 
 	mutex_lock(&bdev->mutex);
+
 	bdev->region_info = region_configs[region];
+
+	bdev->cache_fm_ctrl &= ~BCM2048_BAND_SELECT;
+	if (region > 2) {
+		bdev->cache_fm_ctrl |= BCM2048_BAND_SELECT;
+		err = bcm2048_send_command(bdev, BCM2048_I2C_FM_CTRL,
+					bdev->cache_fm_ctrl);
+		if (err) {
+			mutex_unlock(&bdev->mutex);
+			goto done;
+		}
+	}
+
 	mutex_unlock(&bdev->mutex);
 
 	if (bdev->frequency < region_configs[region].bottom_frequency ||
-- 
1.7.9.5

