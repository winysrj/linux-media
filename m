Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50528 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751266AbaJBIql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 04:46:41 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH v2 05/18] smiapp-pll: External clock frequency isn't an output value
Date: Thu,  2 Oct 2014 11:45:55 +0300
Message-Id: <1412239568-8524-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

It's input. Move it elsewhere in the struct.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp-pll.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index 5ce2b61..2885cd7 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -53,6 +53,7 @@ struct smiapp_pll {
 	uint8_t scale_n;
 	uint8_t bits_per_pixel;
 	uint32_t link_freq;
+	uint32_t ext_clk_freq_hz;
 
 	/* output values */
 	uint16_t pre_pll_clk_div;
@@ -62,7 +63,6 @@ struct smiapp_pll {
 	uint16_t vt_sys_clk_div;
 	uint16_t vt_pix_clk_div;
 
-	uint32_t ext_clk_freq_hz;
 	uint32_t pll_ip_clk_freq_hz;
 	uint32_t pll_op_clk_freq_hz;
 	uint32_t op_sys_clk_freq_hz;
-- 
1.7.10.4

