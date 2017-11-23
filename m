Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.151.58]:32727 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752017AbdKWDzh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 22:55:37 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id E1657F80D
        for <linux-media@vger.kernel.org>; Wed, 22 Nov 2017 21:35:06 -0600 (CST)
Date: Wed, 22 Nov 2017 21:34:44 -0600
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] davinci: vpif_capture: add NULL check on devm_kzalloc return
 value
Message-ID: <20171123033444.GA22637@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check return value from call to devm_kzalloc() in order to prevent
a NULL pointer dereference.

This issue was detected with the help of Coccinelle.

Fixes: 4a5f8ae50b66 ("[media] davinci: vpif_capture: get subdevs from DT when available")
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a89367a..3879c7c 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1550,6 +1550,8 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 					    sizeof(*chan->inputs) *
 					    VPIF_CAPTURE_NUM_CHANNELS,
 					    GFP_KERNEL);
+		if (!chan->inputs)
+			return NULL;
 
 		chan->input_count++;
 		chan->inputs[i].input.type = V4L2_INPUT_TYPE_CAMERA;
-- 
2.7.4
