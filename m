Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:49351 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751999AbdLKRmF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 12:42:05 -0500
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v10 2/4] MAINTAINERS: Add entry for Synopsys DesignWare HDMI drivers
Date: Mon, 11 Dec 2017 17:41:19 +0000
Message-Id: <8d468c10f1a66986b087a664e619dac339bad247.1513013948.git.joabreu@synopsys.com>
In-Reply-To: <cover.1513013948.git.joabreu@synopsys.com>
References: <cover.1513013948.git.joabreu@synopsys.com>
In-Reply-To: <cover.1513013948.git.joabreu@synopsys.com>
References: <cover.1513013948.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an entry for Synopsys DesignWare HDMI Receivers drivers
and phys.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7a52a66..a1675bc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13108,6 +13108,13 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/synopsys/
 
+SYNOPSYS DESIGNWARE HDMI RECEIVERS AND PHY DRIVERS
+M:	Jose Abreu <joabreu@synopsys.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/dwc/*
+F:	include/media/dwc/*
+
 SYNOPSYS DESIGNWARE I2C DRIVER
 M:	Jarkko Nikula <jarkko.nikula@linux.intel.com>
 R:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
-- 
1.9.1
