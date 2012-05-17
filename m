Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:30224 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760587Ab2EQQa3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 12:30:29 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.199.25])
	by mgw-sa01.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4HGURnu029742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:27 +0300
Received: from lanttu (lanttu-o.localdomain [192.168.239.74])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id 59E2B1F4C5A
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:27 +0300 (EEST)
Received: from sakke by lanttu with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1SV3am-00086j-Gh
	for linux-media@vger.kernel.org; Thu, 17 May 2012 19:30:20 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 05/10] smiapp: Round minimum pre_pll up rather than down in ip_clk_freq check
Date: Thu, 17 May 2012 19:30:04 +0300
Message-Id: <1337272209-31061-5-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4FB52770.9000400@maxwell.research.nokia.com>
References: <4FB52770.9000400@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pre_pll divisor must be such that ext_clk / pre_pll divisor does not
result in a frequency that is greater than pll_ip_clk_freq. Fix this.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/smiapp-pll.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/smiapp-pll.c b/drivers/media/video/smiapp-pll.c
index a416e27..a2e41a2 100644
--- a/drivers/media/video/smiapp-pll.c
+++ b/drivers/media/video/smiapp-pll.c
@@ -124,8 +124,9 @@ int smiapp_pll_calculate(struct device *dev, struct smiapp_pll_limits *limits,
 				   limits->min_pll_ip_freq_hz));
 	limits->min_pre_pll_clk_div =
 		max_t(uint16_t, limits->min_pre_pll_clk_div,
-		      clk_div_even(pll->ext_clk_freq_hz /
-				   limits->max_pll_ip_freq_hz));
+		      clk_div_even_up(
+			      DIV_ROUND_UP(pll->ext_clk_freq_hz,
+					   limits->max_pll_ip_freq_hz)));
 	dev_dbg(dev, "pre-pll check: min / max pre_pll_clk_div: %d / %d\n",
 		limits->min_pre_pll_clk_div, limits->max_pre_pll_clk_div);
 
-- 
1.7.2.5

