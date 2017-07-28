Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:62327 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751614AbdG1KFu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 06:05:50 -0400
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
Subject: [PATCH v1 2/5] [media] stm32-dcmi: revisit control register handling
Date: Fri, 28 Jul 2017 12:04:59 +0200
Message-ID: <1501236302-18097-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1501236302-18097-1-git-send-email-hugues.fruchet@st.com>
References: <1501236302-18097-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify bits handling of DCMI_CR register.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 716b3db..526e354 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -490,7 +490,7 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct stm32_dcmi *dcmi = vb2_get_drv_priv(vq);
 	struct dcmi_buf *buf, *node;
-	u32 val;
+	u32 val = 0;
 	int ret;
 
 	ret = clk_enable(dcmi->mclk);
@@ -510,22 +510,16 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	spin_lock_irq(&dcmi->irqlock);
 
-	val = reg_read(dcmi->regs, DCMI_CR);
-
-	val &= ~(CR_PCKPOL | CR_HSPOL | CR_VSPOL |
-		 CR_EDM_0 | CR_EDM_1 | CR_FCRC_0 |
-		 CR_FCRC_1 | CR_JPEG | CR_ESS);
-
 	/* Set bus width */
 	switch (dcmi->bus.bus_width) {
 	case 14:
-		val &= CR_EDM_0 + CR_EDM_1;
+		val |= CR_EDM_0 | CR_EDM_1;
 		break;
 	case 12:
-		val &= CR_EDM_1;
+		val |= CR_EDM_1;
 		break;
 	case 10:
-		val &= CR_EDM_0;
+		val |= CR_EDM_0;
 		break;
 	default:
 		/* Set bus width to 8 bits by default */
-- 
1.9.1
