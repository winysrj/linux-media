Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:25424 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762194Ab2EQQah (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 12:30:37 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.199.25])
	by mgw-da02.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4HGUZpW007010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:36 +0300
Received: from lanttu (lanttu-o.localdomain [192.168.239.74])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id 867F21F4C5A
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:34 +0300 (EEST)
Received: from sakke by lanttu with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1SV3av-000877-Ff
	for linux-media@vger.kernel.org; Thu, 17 May 2012 19:30:29 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 08/10] smiapp: Allow generic quirk registers
Date: Thu, 17 May 2012 19:30:07 +0300
Message-Id: <1337272209-31061-8-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4FB52770.9000400@maxwell.research.nokia.com>
References: <4FB52770.9000400@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement more generic quirk registers than just limit and capability
registers. This comes with the expense of a little bit more access time so
these should be only used when really needed.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/smiapp/smiapp-quirk.c |   46 +++++++++++++++++++++++++++++
 drivers/media/video/smiapp/smiapp-quirk.h |   10 ++++++
 drivers/media/video/smiapp/smiapp-regs.c  |    4 ++
 3 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/smiapp/smiapp-quirk.c b/drivers/media/video/smiapp/smiapp-quirk.c
index 81c2be3..55e8795 100644
--- a/drivers/media/video/smiapp/smiapp-quirk.c
+++ b/drivers/media/video/smiapp/smiapp-quirk.c
@@ -81,6 +81,52 @@ int smiapp_replace_limit_at(struct smiapp_sensor *sensor,
 	return -EINVAL;
 }
 
+bool smiapp_quirk_reg(struct smiapp_sensor *sensor,
+		      u32 reg, u32 *val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	const struct smia_reg *sreg;
+
+	if (!sensor->minfo.quirk)
+		return false;
+
+	sreg = sensor->minfo.quirk->regs;
+
+	if (!sreg)
+		return false;
+
+	while (sreg->type) {
+		u16 type = reg >> 16;
+		u16 reg16 = reg;
+
+		if (sreg->type != type || sreg->reg != reg16) {
+			sreg++;
+			continue;
+		}
+
+		switch ((u8)type) {
+		case SMIA_REG_8BIT:
+			dev_dbg(&client->dev, "quirk: 0x%8.8x: 0x%2.2x\n",
+				reg, sreg->val);
+			break;
+		case SMIA_REG_16BIT:
+			dev_dbg(&client->dev, "quirk: 0x%8.8x: 0x%4.4x\n",
+				reg, sreg->val);
+			break;
+		case SMIA_REG_32BIT:
+			dev_dbg(&client->dev, "quirk: 0x%8.8x: 0x%8.8x\n",
+				reg, sreg->val);
+			break;
+		}
+
+		*val = sreg->val;
+
+		return true;
+	}
+
+	return false;
+}
+
 static int jt8ew9_limits(struct smiapp_sensor *sensor)
 {
 	if (sensor->minfo.revision_number_major < 0x03)
diff --git a/drivers/media/video/smiapp/smiapp-quirk.h b/drivers/media/video/smiapp/smiapp-quirk.h
index de82cdf..f4dcaab 100644
--- a/drivers/media/video/smiapp/smiapp-quirk.h
+++ b/drivers/media/video/smiapp/smiapp-quirk.h
@@ -41,6 +41,7 @@ struct smiapp_quirk {
 	int (*post_poweron)(struct smiapp_sensor *sensor);
 	int (*pre_streamon)(struct smiapp_sensor *sensor);
 	int (*post_streamoff)(struct smiapp_sensor *sensor);
+	const struct smia_reg *regs;
 	unsigned long flags;
 };
 
@@ -55,6 +56,15 @@ struct smiapp_reg_8 {
 
 void smiapp_replace_limit(struct smiapp_sensor *sensor,
 			  u32 limit, u32 val);
+bool smiapp_quirk_reg(struct smiapp_sensor *sensor,
+		      u32 reg, u32 *val);
+
+#define SMIAPP_MK_QUIRK_REG(_reg, _val) \
+	{				\
+		.type = (_reg >> 16),	\
+		.reg = (u16)_reg,	\
+		.val = _val,		\
+	}
 
 #define smiapp_call_quirk(_sensor, _quirk, ...)				\
 	(_sensor->minfo.quirk &&					\
diff --git a/drivers/media/video/smiapp/smiapp-regs.c b/drivers/media/video/smiapp/smiapp-regs.c
index 9c43064..b1812b1 100644
--- a/drivers/media/video/smiapp/smiapp-regs.c
+++ b/drivers/media/video/smiapp/smiapp-regs.c
@@ -172,6 +172,9 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 	    && len != SMIA_REG_32BIT)
 		return -EINVAL;
 
+	if (smiapp_quirk_reg(sensor, reg, val))
+		goto found_quirk;
+
 	if (len == SMIA_REG_8BIT && !only8)
 		rval = ____smiapp_read(sensor, (u16)reg, len, val);
 	else
@@ -179,6 +182,7 @@ static int __smiapp_read(struct smiapp_sensor *sensor, u32 reg, u32 *val,
 	if (rval < 0)
 		return rval;
 
+found_quirk:
 	if (reg & SMIA_REG_FLAG_FLOAT)
 		*val = float_to_u32_mul_1000000(client, *val);
 
-- 
1.7.2.5

