Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:36638 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751835AbdFVPNp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 11:13:45 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v1 1/5] [media] stm32-dcmi: catch dma submission error
Date: Thu, 22 Jun 2017 17:12:47 +0200
Message-ID: <1498144371-13310-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1498144371-13310-1-git-send-email-hugues.fruchet@st.com>
References: <1498144371-13310-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Test cookie return by dmaengine_submit() and return error if any.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 83d32a5..0dd5d1c 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -295,6 +295,10 @@ static int dcmi_start_dma(struct stm32_dcmi *dcmi,
 
 	/* Push current DMA transaction in the pending queue */
 	dcmi->dma_cookie = dmaengine_submit(desc);
+	if (dma_submit_error(dcmi->dma_cookie)) {
+		dev_err(dcmi->dev, "%s: DMA submission failed\n", __func__);
+		return -ENXIO;
+	}
 
 	dma_async_issue_pending(dcmi->dma_chan);
 
-- 
1.9.1
