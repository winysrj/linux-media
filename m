Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:34113 "EHLO
        DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751880AbdIRGlv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 02:41:51 -0400
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
Subject: [PATCH v2 2/5] media: atmel-isc: Add prepare and unprepare ops
Date: Mon, 18 Sep 2017 14:39:22 +0800
Message-ID: <20170918063925.6372-3-wenyou.yang@microchip.com>
In-Reply-To: <20170918063925.6372-1-wenyou.yang@microchip.com>
References: <20170918063925.6372-1-wenyou.yang@microchip.com>
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

Changes in v2: None

 drivers/media/platform/atmel/atmel-isc-regs.h |  1 +
 drivers/media/platform/atmel/atmel-isc.c      | 30 +++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

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
index 78114193af4c..8b9c1cafa348 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -308,6 +308,34 @@ module_param(sensor_preferred, uint, 0644);
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
+	return isc_wait_clk_stable(hw);
+}
+
+static void isc_clk_unprepare(struct clk_hw *hw)
+{
+	isc_wait_clk_stable(hw);
+}
+
 static int isc_clk_enable(struct clk_hw *hw)
 {
 	struct isc_clk *isc_clk = to_isc_clk(hw);
@@ -459,6 +487,8 @@ static int isc_clk_set_rate(struct clk_hw *hw,
 }
 
 static const struct clk_ops isc_clk_ops = {
+	.prepare	= isc_clk_prepare,
+	.unprepare	= isc_clk_unprepare,
 	.enable		= isc_clk_enable,
 	.disable	= isc_clk_disable,
 	.is_enabled	= isc_clk_is_enabled,
-- 
2.13.0
