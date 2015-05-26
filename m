Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50976 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420AbbEZN0l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 09:26:41 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 01/13] dmaengine: of_dma: Correct return code for of_dma_request_slave_channel in case !CONFIG_OF
Date: Tue, 26 May 2015 16:25:56 +0300
Message-ID: <1432646768-12532-2-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

of_dma_request_slave_channel should return either pointer for valid
dma_chan or ERR_PTR() error code, NULL is not expected to be returned.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
---
 include/linux/of_dma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of_dma.h b/include/linux/of_dma.h
index 98ba7525929e..0fd80be152c4 100644
--- a/include/linux/of_dma.h
+++ b/include/linux/of_dma.h
@@ -80,7 +80,7 @@ static inline int of_dma_router_register(struct device_node *np,
 static inline struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
 						     const char *name)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline struct dma_chan *of_dma_simple_xlate(struct of_phandle_args *dma_spec,
-- 
2.3.5

