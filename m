Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:54156 "EHLO mout1.freenet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbdH1PIL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 11:08:11 -0400
From: Branislav Radocaj <branislav@radocaj.org>
To: mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: jb@abbadie.fr, hans.verkuil@cisco.com, nikola.jelic83@gmail.com,
        ran.algawi@gmail.com, aquannie@gmail.com, branislav@radocaj.org,
        shilpapri@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: bcm2048 fix bare use of 'unsigned' in radio-bcm2048.c
Date: Mon, 28 Aug 2017 17:02:44 +0200
Message-Id: <20170828150244.2952-1-branislav@radocaj.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a patch to the radio-bcm2048.c file that fixes up
a warning found by the checkpatch.pl tool.

Removed unused 'size' argument from property_read macro.
In property_write macro, 'signal, size' is replaced by 'prop_type'.
This change implys the update of DEFINE_SYSFS_PROPERTY macro
and all places of its usage as well.

Signed-off-by: Branislav Radocaj <branislav@radocaj.org>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 60 +++++++++++++--------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 38f72d069e27..b1e664aeb6ab 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -1965,7 +1965,7 @@ static ssize_t bcm2048_##prop##_write(struct device *dev,		\
 	return err < 0 ? err : count;					\
 }
 
-#define property_read(prop, size, mask)					\
+#define property_read(prop, mask)					\
 static ssize_t bcm2048_##prop##_read(struct device *dev,		\
 					struct device_attribute *attr,	\
 					char *buf)			\
@@ -2000,9 +2000,9 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
 	return sprintf(buf, mask "\n", value);				\
 }
 
-#define DEFINE_SYSFS_PROPERTY(prop, signal, size, mask, check)		\
-property_write(prop, signal size, mask, check)				\
-property_read(prop, size, mask)
+#define DEFINE_SYSFS_PROPERTY(prop, prop_type, mask, check)		\
+property_write(prop, prop_type, mask, check)				\
+property_read(prop, mask)						\
 
 #define property_str_read(prop, size)					\
 static ssize_t bcm2048_##prop##_read(struct device *dev,		\
@@ -2028,39 +2028,39 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
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
-property_read(rds_pi, unsigned int, "%x")
+DEFINE_SYSFS_PROPERTY(power_state, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(mute, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(audio_route, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(dac_output, unsigned int, "%u", 0)
+
+DEFINE_SYSFS_PROPERTY(fm_hi_lo_injection, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_frequency, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_af_frequency, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_deemphasis, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_rds_mask, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_best_tune_mode, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_search_rssi_threshold, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_search_mode_direction, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_search_tune_mode, unsigned int, "%u", value > 3)
+
+DEFINE_SYSFS_PROPERTY(rds, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_b_block_mask, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_b_block_match, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_pi_mask, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_pi_match, unsigned int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_wline, unsigned int, "%u", 0)
+property_read(rds_pi, "%x")
 property_str_read(rds_rt, (BCM2048_MAX_RDS_RT + 1))
 property_str_read(rds_ps, (BCM2048_MAX_RDS_PS + 1))
 
-property_read(fm_rds_flags, unsigned int, "%u")
+property_read(fm_rds_flags, "%u")
 property_str_read(rds_data, BCM2048_MAX_RDS_RADIO_TEXT * 5)
 
-property_read(region_bottom_frequency, unsigned int, "%u")
-property_read(region_top_frequency, unsigned int, "%u")
+property_read(region_bottom_frequency, "%u")
+property_read(region_top_frequency, "%u")
 property_signed_read(fm_carrier_error, int, "%d")
 property_signed_read(fm_rssi, int, "%d")
-DEFINE_SYSFS_PROPERTY(region, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(region, unsigned int, "%u", 0)
 
 static struct device_attribute attrs[] = {
 	__ATTR(power_state, 0644, bcm2048_power_state_read,
-- 
2.11.0
