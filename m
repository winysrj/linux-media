Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:46606 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbdFPQjD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 12:39:03 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>
Subject: [PATCH v3 3/4] MAINTAINERS: Add entry for Synopsys Designware HDMI drivers
Date: Fri, 16 Jun 2017 17:38:32 +0100
Message-Id: <c8a09ab2f541cd29bd3322beffbfc5e1b6732b62.1497630695.git.joabreu@synopsys.com>
In-Reply-To: <cover.1497630695.git.joabreu@synopsys.com>
References: <cover.1497630695.git.joabreu@synopsys.com>
In-Reply-To: <cover.1497630695.git.joabreu@synopsys.com>
References: <cover.1497630695.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a entry for Synopsys Designware HDMI Receivers drivers
and phys.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 053c3bd..e798040 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11294,6 +11294,13 @@ L:	netdev@vger.kernel.org
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
