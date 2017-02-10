Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33530 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdBJJhx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 04:37:53 -0500
From: Ran Algawi <ran.algawi@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Ran Algawi <ran.algawi@gmail.com>
Subject: [PATCH 1/2] Staging: media: bcm2048: fixed 20+ warings/errors
Date: Fri, 10 Feb 2017 11:37:04 +0200
Message-Id: <1486719425-24546-1-git-send-email-ran.algawi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixed a coding style issues, and two major erros about complex macros
and an error where the driver used a decimal number insted of an octal
number when using a warning.

Signed-off-by: Ran Algawi <ran.algawi@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 64 +++++++++++++--------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 37bd439..55968ba 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -177,12 +177,12 @@
 
 #define BCM2048_FREQDEV_UNIT		10000
 #define BCM2048_FREQV4L2_MULTI		625
-#define dev_to_v4l2(f)	((f * BCM2048_FREQDEV_UNIT) / BCM2048_FREQV4L2_MULTI)
-#define v4l2_to_dev(f)	((f * BCM2048_FREQV4L2_MULTI) / BCM2048_FREQDEV_UNIT)
+#define dev_to_v4l2(f)	(((f) * BCM2048_FREQDEV_UNIT) / BCM2048_FREQV4L2_MULTI)
+#define v4l2_to_dev(f)	(((f) * BCM2048_FREQV4L2_MULTI) / BCM2048_FREQDEV_UNIT)
 
-#define msb(x)                  ((u8)((u16)x >> 8))
-#define lsb(x)                  ((u8)((u16)x &  0x00FF))
-#define compose_u16(msb, lsb)	(((u16)msb << 8) | lsb)
+#define msb(x)                  ((u8)((u16)(x) >> 8))
+#define lsb(x)                  ((u8)((u16)(x) &  0x00FF))
+#define compose_u16(msb, lsb)	(((u16)(msb) << 8) | (lsb))
 
 #define BCM2048_DEFAULT_POWERING_DELAY	20
 #define BCM2048_DEFAULT_REGION		0x02
@@ -300,7 +300,7 @@ struct bcm2048_device {
 };
 
 static int radio_nr = -1;	/* radio device minor (-1 ==> auto assign) */
-module_param(radio_nr, int, 0);
+module_param(radio_nr, int, 0000);
 MODULE_PARM_DESC(radio_nr,
 		 "Minor number for radio device (-1 ==> auto assign)");
 
@@ -1534,7 +1534,7 @@ static int bcm2048_parse_rt_match_c(struct bcm2048_device *bdev, int i,
 	if (crc == BCM2048_RDS_CRC_UNRECOVARABLE)
 		return 0;
 
-	BUG_ON((index+2) >= BCM2048_MAX_RDS_RT);
+	WARN_ON((index + 2) >= BCM2048_MAX_RDS_RT);
 
 	if ((bdev->rds_info.radio_text[i] & BCM2048_RDS_BLOCK_MASK) ==
 		BCM2048_RDS_BLOCK_C) {
@@ -1557,7 +1557,7 @@ static void bcm2048_parse_rt_match_d(struct bcm2048_device *bdev, int i,
 	if (crc == BCM2048_RDS_CRC_UNRECOVARABLE)
 		return;
 
-	BUG_ON((index+4) >= BCM2048_MAX_RDS_RT);
+	WARN_ON((index + 4) >= BCM2048_MAX_RDS_RT);
 
 	if ((bdev->rds_info.radio_text[i] & BCM2048_RDS_BLOCK_MASK) ==
 	    BCM2048_RDS_BLOCK_D)
@@ -1857,7 +1857,7 @@ static int bcm2048_probe(struct bcm2048_device *bdev)
 		goto unlock;
 
 	err = bcm2048_set_fm_search_rssi_threshold(bdev,
-					BCM2048_DEFAULT_RSSI_THRESHOLD);
+			BCM2048_DEFAULT_RSSI_THRESHOLD);
 	if (err < 0)
 		goto unlock;
 
@@ -1992,7 +1992,7 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
 	return sprintf(buf, mask "\n", value);				\
 }
 
-#define DEFINE_SYSFS_PROPERTY(prop, signal, size, mask, check)		\
+#define DEFINE_SYSFS_PROPERTY(prop, signal, size, mask, check) \
 property_write(prop, signal size, mask, check)				\
 property_read(prop, size, mask)
 
@@ -2020,27 +2020,27 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
 	return count;							\
 }
 
-DEFINE_SYSFS_PROPERTY(power_state, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(mute, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(audio_route, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(dac_output, unsigned, int, "%u", 0)
-
-DEFINE_SYSFS_PROPERTY(fm_hi_lo_injection, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_frequency, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_af_frequency, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_deemphasis, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_rds_mask, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_best_tune_mode, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_search_rssi_threshold, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_search_mode_direction, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_search_tune_mode, unsigned, int, "%u", value > 3)
-
-DEFINE_SYSFS_PROPERTY(rds, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(rds_b_block_mask, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(rds_b_block_match, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(rds_pi_mask, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(rds_pi_match, unsigned, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(rds_wline, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(power_state, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(mute, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(audio_route, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(dac_output, unsigned int, int, "%u", 0)
+
+DEFINE_SYSFS_PROPERTY(fm_hi_lo_injection, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_frequency, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_af_frequency, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_deemphasis, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_rds_mask, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_best_tune_mode, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_search_rssi_threshold, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_search_mode_direction, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_search_tune_mode, unsigned int, int, "%u", value > 3)
+
+DEFINE_SYSFS_PROPERTY(rds, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_b_block_mask, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_b_block_match, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_pi_mask, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_pi_match, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_wline, unsigned int, int, "%u", 0)
 property_read(rds_pi, unsigned int, "%x")
 property_str_read(rds_rt, (BCM2048_MAX_RDS_RT + 1))
 property_str_read(rds_ps, (BCM2048_MAX_RDS_PS + 1))
@@ -2052,7 +2052,7 @@ property_read(region_bottom_frequency, unsigned int, "%u")
 property_read(region_top_frequency, unsigned int, "%u")
 property_signed_read(fm_carrier_error, int, "%d")
 property_signed_read(fm_rssi, int, "%d")
-DEFINE_SYSFS_PROPERTY(region, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(region, unsigned int, int, "%u", 0)
 
 static struct device_attribute attrs[] = {
 	__ATTR(power_state, 0644, bcm2048_power_state_read,
-- 
2.7.4

