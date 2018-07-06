Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:56136 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932336AbeGFNEC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2018 09:04:02 -0400
Received: by mail-wm0-f65.google.com with SMTP id v16-v6so14849459wmv.5
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2018 06:04:02 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: mchehab@kernel.org, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, hans.verkuil@cisco.com,
        hugues.fruchet@st.com
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH] media: stm32: dcmi: replace "%p" with "%pK"
Date: Fri,  6 Jul 2018 15:03:55 +0200
Message-Id: <20180706130355.22100-1-benjamin.gaignard@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The format specifier "%p" can leak kernel addresses.
Use "%pK" instead.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 2e1933d872ee..fe90672cf16f 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1753,7 +1753,7 @@ static int dcmi_probe(struct platform_device *pdev)
 
 	ret = clk_prepare(mclk);
 	if (ret) {
-		dev_err(&pdev->dev, "Unable to prepare mclk %p\n", mclk);
+		dev_err(&pdev->dev, "Unable to prepare mclk %pK\n", mclk);
 		goto err_dma_release;
 	}
 
-- 
2.15.0
