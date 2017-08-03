Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:56238 "EHLO mout3.freenet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751699AbdHCPWY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 Aug 2017 11:22:24 -0400
From: Branislav Radocaj <branislav@radocaj.org>
To: mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: jb@abbadie.fr, hans.verkuil@cisco.com, nikola.jelic83@gmail.com,
        ran.algawi@gmail.com, aquannie@gmail.com, branislav@radocaj.org,
        shilpapri@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: bcm2048: fix bare use of 'unsigned' in radio-bcm2048.c
Date: Thu,  3 Aug 2017 17:13:48 +0200
Message-Id: <20170803151348.21349-1-branislav@radocaj.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a patch to the radio-bcm2048.c file that fixes up
a warning found by the checkpatch.pl tool.

Signed-off-by: Branislav Radocaj <branislav@radocaj.org>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 44 +++++++++++++--------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 38f72d069e27..bb8956b3d40c 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2028,27 +2028,27 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
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
@@ -2060,7 +2060,7 @@ property_read(region_bottom_frequency, unsigned int, "%u")
 property_read(region_top_frequency, unsigned int, "%u")
 property_signed_read(fm_carrier_error, int, "%d")
 property_signed_read(fm_rssi, int, "%d")
-DEFINE_SYSFS_PROPERTY(region, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(region, unsigned int, int, "%u", 0)
 
 static struct device_attribute attrs[] = {
 	__ATTR(power_state, 0644, bcm2048_power_state_read,
-- 
2.11.0
