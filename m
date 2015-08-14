Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:32837 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113AbbHNQoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 12:44:04 -0400
From: Andrew Milkovich <amilkovich@gmail.com>
To: mchehab@osg.samsung.com
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Milkovich <amilkovich@gmail.com>
Subject: [PATCH] Staging: media: bcm2048: warnings for uninitialized variables fixed
Date: Fri, 14 Aug 2015 09:43:56 -0700
Message-Id: <1439570636-32539-1-git-send-email-amilkovich@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes the following sparse warnings:
warning: ... may be used uninitialized in this function
Some function variables have been initialized to 0.

Signed-off-by: Andrew Milkovich <amilkovich@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 8bc68e2..2f81579 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -621,7 +621,7 @@ static int bcm2048_set_fm_frequency(struct bcm2048_device *bdev, u32 frequency)
 static int bcm2048_get_fm_frequency(struct bcm2048_device *bdev)
 {
 	int err;
-	u8 lsb, msb;
+	u8 lsb = 0, msb = 0;
 
 	mutex_lock(&bdev->mutex);
 
@@ -666,7 +666,7 @@ static int bcm2048_set_fm_af_frequency(struct bcm2048_device *bdev,
 static int bcm2048_get_fm_af_frequency(struct bcm2048_device *bdev)
 {
 	int err;
-	u8 lsb, msb;
+	u8 lsb = 0, msb = 0;
 
 	mutex_lock(&bdev->mutex);
 
@@ -1048,7 +1048,7 @@ static int bcm2048_set_rds_b_block_mask(struct bcm2048_device *bdev, u16 mask)
 static int bcm2048_get_rds_b_block_mask(struct bcm2048_device *bdev)
 {
 	int err;
-	u8 lsb, msb;
+	u8 lsb = 0, msb = 0;
 
 	mutex_lock(&bdev->mutex);
 
@@ -1084,7 +1084,7 @@ static int bcm2048_set_rds_b_block_match(struct bcm2048_device *bdev,
 static int bcm2048_get_rds_b_block_match(struct bcm2048_device *bdev)
 {
 	int err;
-	u8 lsb, msb;
+	u8 lsb = 0, msb = 0;
 
 	mutex_lock(&bdev->mutex);
 
@@ -1119,7 +1119,7 @@ static int bcm2048_set_rds_pi_mask(struct bcm2048_device *bdev, u16 mask)
 static int bcm2048_get_rds_pi_mask(struct bcm2048_device *bdev)
 {
 	int err;
-	u8 lsb, msb;
+	u8 lsb = 0, msb = 0;
 
 	mutex_lock(&bdev->mutex);
 
@@ -1154,7 +1154,7 @@ static int bcm2048_set_rds_pi_match(struct bcm2048_device *bdev, u16 match)
 static int bcm2048_get_rds_pi_match(struct bcm2048_device *bdev)
 {
 	int err;
-	u8 lsb, msb;
+	u8 lsb = 0, msb = 0;
 
 	mutex_lock(&bdev->mutex);
 
@@ -1189,7 +1189,7 @@ static int bcm2048_set_fm_rds_mask(struct bcm2048_device *bdev, u16 mask)
 static int bcm2048_get_fm_rds_mask(struct bcm2048_device *bdev)
 {
 	int err;
-	u8 value0, value1;
+	u8 value0 = 0, value1 = 0;
 
 	mutex_lock(&bdev->mutex);
 
@@ -1207,7 +1207,7 @@ static int bcm2048_get_fm_rds_mask(struct bcm2048_device *bdev)
 static int bcm2048_get_fm_rds_flags(struct bcm2048_device *bdev)
 {
 	int err;
-	u8 value0, value1;
+	u8 value0 = 0, value1 = 0;
 
 	mutex_lock(&bdev->mutex);
 
@@ -1235,7 +1235,7 @@ static int bcm2048_get_region_top_frequency(struct bcm2048_device *bdev)
 static int bcm2048_set_fm_best_tune_mode(struct bcm2048_device *bdev, u8 mode)
 {
 	int err;
-	u8 value;
+	u8 value = 0;
 
 	mutex_lock(&bdev->mutex);
 
@@ -1909,7 +1909,7 @@ unlock:
 static void bcm2048_work(struct work_struct *work)
 {
 	struct bcm2048_device *bdev;
-	u8 flag_lsb, flag_msb, flags;
+	u8 flag_lsb = 0, flag_msb = 0, flags;
 
 	bdev = container_of(work, struct bcm2048_device, work);
 	bcm2048_recv_command(bdev, BCM2048_I2C_FM_RDS_FLAG0, &flag_lsb);
-- 
2.5.0

