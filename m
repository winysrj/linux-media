Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46535 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751798AbaKRFoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 00:44:04 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
	by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 21A2B60096
	for <linux-media@vger.kernel.org>; Tue, 18 Nov 2014 07:44:01 +0200 (EET)
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Subject: [REVIEW PATCH v2 04/11] smiapp: Use types better suitable for DT
Date: Tue, 18 Nov 2014 07:43:39 +0200
Message-Id: <1416289426-804-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289426-804-1-git-send-email-sakari.ailus@iki.fi>
References: <1416289426-804-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 include/media/smiapp.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/media/smiapp.h b/include/media/smiapp.h
index 0b8f124..268a3cd 100644
--- a/include/media/smiapp.h
+++ b/include/media/smiapp.h
@@ -65,19 +65,19 @@ struct smiapp_platform_data {
 	unsigned short i2c_addr_dfl;	/* Default i2c addr */
 	unsigned short i2c_addr_alt;	/* Alternate i2c addr */
 
-	unsigned int nvm_size;			/* bytes */
-	unsigned int ext_clk;			/* sensor external clk */
+	uint32_t nvm_size;		/* bytes */
+	uint32_t ext_clk;		/* sensor external clk */
 
 	unsigned int lanes;		/* Number of CSI-2 lanes */
-	u8 csi_signalling_mode;		/* SMIAPP_CSI_SIGNALLING_MODE_* */
-	const s64 *op_sys_clock;
+	uint32_t csi_signalling_mode;	/* SMIAPP_CSI_SIGNALLING_MODE_* */
+	uint64_t *op_sys_clock;
 
 	enum smiapp_module_board_orient module_board_orient;
 
 	struct smiapp_flash_strobe_parms *strobe_setup;
 
 	int (*set_xclk)(struct v4l2_subdev *sd, int hz);
-	int xshutdown;			/* gpio or SMIAPP_NO_XSHUTDOWN */
+	int32_t xshutdown;		/* gpio or SMIAPP_NO_XSHUTDOWN */
 };
 
 #endif /* __SMIAPP_H_  */
-- 
1.7.10.4

