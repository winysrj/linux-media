Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:39918 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbdJ0DZO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 23:25:14 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v5 2/5] media: atmel-isc: Add prepare and unprepare ops
Date: Fri, 27 Oct 2017 11:21:29 +0800
Message-ID: <20171027032132.16418-3-wenyou.yang@microchip.com>
In-Reply-To: <20171027032132.16418-1-wenyou.yang@microchip.com>
References: <20171027032132.16418-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A software write operation to the ISC_CLKEN or ISC_CLKDIS register
requires double clock domain synchronization and is not permitted
when the ISC_SR.SIP is asserted. So add the .prepare and .unprepare
ops to make sure the ISC_CLKSR.SIP is unasserted before the write
operation to the ISC_CLKEN or ISC_CLKDIS register.

Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
---

Changes in v5:
 - Fix the clock ID which enters the runtime suspend should be
   ISC_ISPCK, instead of ISC_MCK for clk_prepare/clk_unprepare().

Changes in v4:
 - Call pm_runtime_get_sync() and pm_runtime_put_sync() in ->prepare
   and ->unprepare callback.

Changes in v3: None
Changes in v2: None

 drivers/media/platform/atmel/atmel-isc-regs.h |  1 +
 drivers/media/platform/atmel/atmel-isc.c      | 40 +++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/drivers/media/platform/atmel/atmel-isc-regs.h b/drivers/media/platform/atmel/atmel-isc-regs.h
index 6936ac467609..93e58fcf1d5f 100644
--- a/drivers/media/platform/atmel/atmel-isc-regs.h
+++ b/drivers/media/platform/atmel/atmel-isc-regs.h
@@ -42,6 +42,7 @@
 
 /* ISC Clock Status Register */
 #define ISC_CLKSR               0x00000020
+#define ISC_CLKSR_SIP		BIT(31)
 
 #define ISC_CLK(n)		BIT(n)
 
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 991f962b7023..329ee8f256bb 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -308,6 +308,44 @@ module_param(sensor_preferred, uint, 0644);
 MODULE_PARM_DESC(sensor_preferred,
 		 "Sensor is preferred to output the specified format (1-on 0-off), default 1");
 
+static int isc_wait_clk_stable(struct clk_hw *hw)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+	struct regmap *regmap = isc_clk->regmap;
+	unsigned long timeout = jiffies + usecs_to_jiffies(1000);
+	unsigned int status;
+
+	while (time_before(jiffies, timeout)) {
+		regmap_read(regmap, ISC_CLKSR, &status);
+		if (!(status & ISC_CLKSR_SIP))
+			return 0;
+
+		usleep_range(10, 250);
+	}
+
+	return -ETIMEDOUT;
+}
+
+static int isc_clk_prepare(struct clk_hw *hw)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+
+	if (isc_clk->id == ISC_ISPCK)
+		pm_runtime_get_sync(isc_clk->dev);
+
+	return isc_wait_clk_stable(hw);
+}
+
+static void isc_clk_unprepare(struct clk_hw *hw)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+
+	isc_wait_clk_stable(hw);
+
+	if (isc_clk->id == ISC_ISPCK)
+		pm_runtime_put_sync(isc_clk->dev);
+}
+
 static int isc_clk_enable(struct clk_hw *hw)
 {
 	struct isc_clk *isc_clk = to_isc_clk(hw);
@@ -459,6 +497,8 @@ static int isc_clk_set_rate(struct clk_hw *hw,
 }
 
 static const struct clk_ops isc_clk_ops = {
+	.prepare	= isc_clk_prepare,
+	.unprepare	= isc_clk_unprepare,
 	.enable		= isc_clk_enable,
 	.disable	= isc_clk_disable,
 	.is_enabled	= isc_clk_is_enabled,
-- 
2.13.0
