Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43577 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbaDNJA4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 05:00:56 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
	by paasikivi.fi.intel.com (Postfix) with ESMTP id 2EDAE20981
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:00:53 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 04/21] smiapp: Add a macro for constructing 8-bit quirk registers
Date: Mon, 14 Apr 2014 11:58:29 +0300
Message-Id: <1397465926-29724-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1397465926-29724-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-quirk.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index 4f65c4e..96a253e 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -56,6 +56,12 @@ struct smiapp_reg_8 {
 void smiapp_replace_limit(struct smiapp_sensor *sensor,
 			  u32 limit, u32 val);
 
+#define SMIAPP_MK_QUIRK_REG_8(_reg, _val) \
+	{				\
+		.reg = (u16)_reg,	\
+		.val = _val,		\
+	}
+
 #define smiapp_call_quirk(_sensor, _quirk, ...)				\
 	(_sensor->minfo.quirk &&					\
 	 _sensor->minfo.quirk->_quirk ?					\
-- 
1.8.3.2

