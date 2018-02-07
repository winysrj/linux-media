Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:1072 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753390AbeBGRgN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 12:36:13 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v1 2/3] media: stm32-dcmi: remove redundant clear of interrupt flags
Date: Wed, 7 Feb 2018 18:35:35 +0100
Message-ID: <1518024936-2455-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1518024936-2455-1-git-send-email-hugues.fruchet@st.com>
References: <1518024936-2455-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is already cleared in dcmi_irq_callback().

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index abc79d8..dfab867 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -385,8 +385,6 @@ static irqreturn_t dcmi_irq_thread(int irq, void *arg)
 		dcmi->errors_count++;
 		dmaengine_terminate_all(dcmi->dma_chan);
 
-		reg_set(dcmi->regs, DCMI_ICR, IT_FRAME | IT_OVR | IT_ERR);
-
 		dev_dbg(dcmi->dev, "Restarting capture after DCMI error\n");
 
 		if (dcmi_start_capture(dcmi)) {
-- 
1.9.1
