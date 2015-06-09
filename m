Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35043 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbbFILpT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2015 07:45:19 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pavel Machek <pavel@ucw.cz>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
	Jan Roemisch <maxx@spaceboyz.net>
Subject: [PATCH v2] radio-bcm2048: Fix region selection
Date: Tue,  9 Jun 2015 13:44:33 +0200
Message-Id: <1433850273-32223-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <557189C8.7040203@xs4all.nl>
References: <557189C8.7040203@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jan Roemisch <maxx@spaceboyz.net>

This patch fixes region selection for lower bottom_frequency in BCM2048 FM
receiver. It also removes "Japan wide band" region since this is impossible
to do just like that.

Signed-off-by: Jan Roemisch <maxx@spaceboyz.net>
Acked-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index e9d0691..134e2af 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -342,14 +342,6 @@ static struct region_info region_configs[] = {
 		.deemphasis		= 50,
 		.region			= 3,
 	},
-	/* Japan wide band */
-	{
-		.channel_spacing	= 10,
-		.bottom_frequency	= 76000,
-		.top_frequency		= 108000,
-		.deemphasis		= 50,
-		.region			= 4,
-	},
 };
 
 /*
@@ -741,6 +733,18 @@ static int bcm2048_set_region(struct bcm2048_device *bdev, u8 region)
 
 	mutex_lock(&bdev->mutex);
 	bdev->region_info = region_configs[region];
+
+	if (region_configs[region].bottom_frequency < 87500)
+		bdev->cache_fm_ctrl |= BCM2048_BAND_SELECT;
+	else
+		bdev->cache_fm_ctrl &= ~BCM2048_BAND_SELECT;
+
+	err = bcm2048_send_command(bdev, BCM2048_I2C_FM_CTRL,
+					bdev->cache_fm_ctrl);
+	if (err) {
+		mutex_unlock(&bdev->mutex);
+		goto done;
+	}
 	mutex_unlock(&bdev->mutex);
 
 	if (bdev->frequency < region_configs[region].bottom_frequency ||
-- 
1.7.10.4

