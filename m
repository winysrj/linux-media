Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33374 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751675AbdIUPED (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 11:04:03 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: chiranjeevi.rapolu@intel.com
Subject: [PATCH 1/1] ov13858: Use do_div() for dividing a 64-bit number
Date: Thu, 21 Sep 2017 18:04:01 +0300
Message-Id: <20170921150401.27933-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ov13858 contained a 64-bit division. Use do_div() for calculating it.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/ov13858.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index 2bd659976c30..5030f4ebe056 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -951,7 +951,12 @@ static const char * const ov13858_test_pattern_menu[] = {
  * pixel_rate = link_freq * data-rate * nr_of_lanes / bits_per_sample
  * data rate => double data rate; number of lanes => 4; bits per pixel => 10
  */
-#define LINK_FREQ_TO_PIXEL_RATE(f)	(((f) * 2 * 4) / 10)
+#define LINK_FREQ_TO_PIXEL_RATE(f)					\
+	({								\
+		u64 __link_freq_to_pixel_rate_tmp = (f) * 2 * 4;	\
+		do_div(__link_freq_to_pixel_rate_tmp, 10);		\
+		__link_freq_to_pixel_rate_tmp;				\
+	})
 
 /* Menu items for LINK_FREQ V4L2 control */
 static const s64 link_freq_menu_items[OV13858_NUM_OF_LINK_FREQS] = {
-- 
2.11.0
