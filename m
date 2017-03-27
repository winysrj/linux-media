Return-path: <linux-media-owner@vger.kernel.org>
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:42529
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751574AbdC0GSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 02:18:46 -0400
Date: Mon, 27 Mar 2017 17:20:29 +1100
From: Eddie Youseph <psyclone@iinet.net.au>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] Revert
 "staging: radio-bcm2048: fixed bare use of unsigned int"
Message-Id: <20170327172029.5d0c1c13b5c656b768ecbe10@iinet.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts previous changes to checkpatch warning:
WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
---
Changes in v2:
	- Added changelog

Changes in v3:
	- Revert changes to using bare unsigned

 drivers/staging/media/bcm2048/radio-bcm2048.c | 44 +++++++++++++--------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index 7d33bce..d605c41 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2020,27 +2020,27 @@ static irqreturn_t bcm2048_handler(int irq, void *dev)
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
+DEFINE_SYSFS_PROPERTY(power_state, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(mute, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(audio_route, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(dac_output, unsigned, int, "%u", 0)
+
+DEFINE_SYSFS_PROPERTY(fm_hi_lo_injection, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_frequency, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_af_frequency, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_deemphasis, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_rds_mask, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_best_tune_mode, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_search_rssi_threshold, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_search_mode_direction, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(fm_search_tune_mode, unsigned, int, "%u", value > 3)
+
+DEFINE_SYSFS_PROPERTY(rds, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_b_block_mask, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_b_block_match, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_pi_mask, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_pi_match, unsigned, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(rds_wline, unsigned, int, "%u", 0)
 property_read(rds_pi, unsigned int, "%x")
 property_str_read(rds_rt, (BCM2048_MAX_RDS_RT + 1))
 property_str_read(rds_ps, (BCM2048_MAX_RDS_PS + 1))
@@ -2052,7 +2052,7 @@ static irqreturn_t bcm2048_handler(int irq, void *dev)
 property_read(region_top_frequency, unsigned int, "%u")
 property_signed_read(fm_carrier_error, int, "%d")
 property_signed_read(fm_rssi, int, "%d")
-DEFINE_SYSFS_PROPERTY(region, unsigned int, int, "%u", 0)
+DEFINE_SYSFS_PROPERTY(region, unsigned, int, "%u", 0)
 
 static struct device_attribute attrs[] = {
 	__ATTR(power_state, 0644, bcm2048_power_state_read,
-- 
1.8.3.1
