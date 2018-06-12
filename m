Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:58259 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932976AbeFLRYr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 13:24:47 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Niklas Soderlund <niklas.soderlund+renesas@ragnatech.se>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] media: stm32-dcmi: simplify of_node_put usage
Date: Tue, 12 Jun 2018 19:23:16 +0200
Message-Id: <1528824196-19149-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This does not fix any bug - this is just a code simplification. As
np is not used after passing it to v4l2_fwnode_endpoint_parse() its
refcount can be decremented immediately and at one location.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Issue found during code reading.

Patch was compile tested with: x86_64_defconfig, MEDIA_SUPPORT=y
MEDIA_CAMERA_SUPPORT=y, V4L_PLATFORM_DRIVERS=y, OF=y, COMPILE_TEST=y
CONFIG_VIDEO_STM32_DCMI=y
(There are a few sparse warnings - but unrelated to the lines changed)

Patch is against 4.17.0 (localversion-next is next-20180608)

 drivers/media/platform/stm32/stm32-dcmi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 2e1933d..0b61042 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1696,23 +1696,20 @@ static int dcmi_probe(struct platform_device *pdev)
 	}
 
 	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(np), &ep);
+	of_node_put(np);
 	if (ret) {
 		dev_err(&pdev->dev, "Could not parse the endpoint\n");
-		of_node_put(np);
 		return -ENODEV;
 	}
 
 	if (ep.bus_type == V4L2_MBUS_CSI2) {
 		dev_err(&pdev->dev, "CSI bus not supported\n");
-		of_node_put(np);
 		return -ENODEV;
 	}
 	dcmi->bus.flags = ep.bus.parallel.flags;
 	dcmi->bus.bus_width = ep.bus.parallel.bus_width;
 	dcmi->bus.data_shift = ep.bus.parallel.data_shift;
 
-	of_node_put(np);
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_err(&pdev->dev, "Could not get irq\n");
-- 
2.1.4
