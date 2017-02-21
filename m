Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34632 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdBUBfT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 20:35:19 -0500
Received: by mail-it0-f65.google.com with SMTP id r141so13517212ita.1
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 17:35:18 -0800 (PST)
From: David Cako <dc@cako.io>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        gregkh@linuxfoundation.org
Cc: David Cako <dc@cako.io>
Subject: [PATCH] fix unsigned int argument
Date: Mon, 20 Feb 2017 18:35:07 -0700
Message-Id: <1487640907-177606-1-git-send-email-dc@cako.io>
In-Reply-To: <1487635736-161650-1-git-send-email-dc@cako.io>
References: <1487635736-161650-1-git-send-email-dc@cako.io>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry, left the old "int" argument in previous patch.

Signed-off-by: David Cako <dc@cako.io>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 44 +++++++++++++--------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index b1923a3..a41d971 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2020,27 +2020,27 @@ static ssize_t bcm2048_##prop##_read(struct device *dev,		\
 	return count;							\
 }
 
-DEFINE_SYSFS_PROPERTY(power_state, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(mute, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(audio_route, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(dac_output, unsigned int, int, "%u", 0)
-
-DEFINE_SYSFS_PROPERTY(fm_hi_lo_injection, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_frequency, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_af_frequency, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_deemphasis, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_rds_mask, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_best_tune_mode, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_search_rssi_threshold, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_search_mode_direction, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(fm_search_tune_mode, unsigned int, int, "%u", value > 3)
-
-DEFINE_SYSFS_PROPERTY(rds, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(rds_b_block_mask, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(rds_b_block_match, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(rds_pi_mask, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(rds_pi_match, unsigned int, int, "%u", 0)
-DEFINE_SYSFS_PROPERTY(rds_wline, unsigned int, int, "%u", 0)
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
 property_read(rds_pi, unsigned int, "%x")
 property_str_read(rds_rt, (BCM2048_MAX_RDS_RT + 1))
 property_str_read(rds_ps, (BCM2048_MAX_RDS_PS + 1))
@@ -2052,7 +2052,7 @@ property_read(region_bottom_frequency, unsigned int, "%u")
 property_read(region_top_frequency, unsigned int, "%u")
 property_signed_read(fm_carrier_error, int, "%d")
 property_signed_read(fm_rssi, int, "%d")
-DEFINE_SYSFS_PROPERTY(region, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(region, unsigned int, "%u", 0)
 
 static struct device_attribute attrs[] = {
 	__ATTR(power_state, 0644, bcm2048_power_state_read,
-- 
2.7.4
