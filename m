Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:36160 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751342AbdHDKl7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 06:41:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] stm32-cec: use CEC_CAP_DEFAULTS
Date: Fri,  4 Aug 2017 12:41:55 +0200
Message-Id: <20170804104155.37386-6-hverkuil@xs4all.nl>
In-Reply-To: <20170804104155.37386-1-hverkuil@xs4all.nl>
References: <20170804104155.37386-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the new CEC_CAP_DEFAULTS define in this driver.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/stm32/stm32-cec.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-cec.c b/drivers/media/platform/stm32/stm32-cec.c
index 89904096d0a9..ed332a1a39b1 100644
--- a/drivers/media/platform/stm32/stm32-cec.c
+++ b/drivers/media/platform/stm32/stm32-cec.c
@@ -246,9 +246,7 @@ static const struct regmap_config stm32_cec_regmap_cfg = {
 
 static int stm32_cec_probe(struct platform_device *pdev)
 {
-	u32 caps = CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
-		   CEC_CAP_TRANSMIT | CEC_CAP_RC | CEC_CAP_PHYS_ADDR |
-		   CEC_MODE_MONITOR_ALL;
+	u32 caps = CEC_CAP_DEFAULTS | CEC_CAP_PHYS_ADDR | CEC_MODE_MONITOR_ALL;
 	struct resource *res;
 	struct stm32_cec *cec;
 	void __iomem *mmio;
-- 
2.13.2
