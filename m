Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:39289 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752338AbdGDOMS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 10:12:18 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>
Subject: [PATCH v6 3/4] MAINTAINERS: Add entry for Synopsys Designware HDMI drivers
Date: Tue,  4 Jul 2017 15:11:39 +0100
Message-Id: <5c63010bdc112bfe480f4b6b2c73e1600e45d3ed.1499176790.git.joabreu@synopsys.com>
In-Reply-To: <cover.1499176790.git.joabreu@synopsys.com>
References: <cover.1499176790.git.joabreu@synopsys.com>
In-Reply-To: <cover.1499176790.git.joabreu@synopsys.com>
References: <cover.1499176790.git.joabreu@synopsys.com>
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
index c4be6d4..7ebc6dd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11354,6 +11354,13 @@ L:	netdev@vger.kernel.org
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
