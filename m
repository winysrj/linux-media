Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36690 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753724AbdCTK7g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:59:36 -0400
From: "unknown" <psyblasted@gmail.com>
Date: Mon, 20 Mar 2017 22:02:33 +1100
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: radio-bcm2048: Fix checkpatch warnings: WARNING:
 Prefer 'unsigned int' to bare use of 'unsigned'
Message-ID: <20170320110232.GA15983@unknown.darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Eddie Youseph <psyblasted@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 44 +++++++++++++--------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index d605c41..7d33bce 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2020,27 +2020,27 @@ static irqreturn_t bcm2048_handler(int irq, void *dev)
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
@@ -2052,7 +2052,7 @@ static irqreturn_t bcm2048_handler(int irq, void *dev)
 property_read(region_top_frequency, unsigned int, "%u")
 property_signed_read(fm_carrier_error, int, "%d")
 property_signed_read(fm_rssi, int, "%d")
-DEFINE_SYSFS_PROPERTY(region, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(region, unsigned int, int, "%u", 0)
 
 static struct device_attribute attrs[] = {
 	__ATTR(power_state, 0644, bcm2048_power_state_read,
-- 
1.8.3.1
