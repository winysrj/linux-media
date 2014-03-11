Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:48739 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbaCKIfK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 04:35:10 -0400
From: Archit Taneja <archit@ti.com>
To: <k.debski@samsung.com>, <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH v3 08/14] v4l: ti-vpe: Rename csc memory resource name
Date: Tue, 11 Mar 2014 14:03:47 +0530
Message-ID: <1394526833-24805-9-git-send-email-archit@ti.com>
In-Reply-To: <1394526833-24805-1-git-send-email-archit@ti.com>
References: <1393922965-15967-1-git-send-email-archit@ti.com>
 <1394526833-24805-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename the memory block resource "vpe_csc" to "csc" since it also exists within
the VIP IP block. This would make the name more generic, and both VPE and VIP DT
nodes in the future can use it.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/csc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/csc.c b/drivers/media/platform/ti-vpe/csc.c
index acfea50..0333339 100644
--- a/drivers/media/platform/ti-vpe/csc.c
+++ b/drivers/media/platform/ti-vpe/csc.c
@@ -180,7 +180,7 @@ struct csc_data *csc_create(struct platform_device *pdev)
 	csc->pdev = pdev;
 
 	csc->res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-			"vpe_csc");
+			"csc");
 	if (csc->res == NULL) {
 		dev_err(&pdev->dev, "missing platform resources data\n");
 		return ERR_PTR(-ENODEV);
-- 
1.8.3.2

