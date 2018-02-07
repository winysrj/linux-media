Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:57801 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753721AbeBGRgN (ORCPT
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
Subject: [PATCH v1 1/3] media: stm32-dcmi: remove redundant capture enable
Date: Wed, 7 Feb 2018 18:35:34 +0100
Message-ID: <1518024936-2455-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1518024936-2455-1-git-send-email-hugues.fruchet@st.com>
References: <1518024936-2455-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove redundant capture enable already done
in dcmi_start_capture().

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 9460b30..abc79d8 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -255,9 +255,6 @@ static void dcmi_dma_callback(void *param)
 				spin_unlock(&dcmi->irqlock);
 				return;
 			}
-
-			/* Enable capture */
-			reg_set(dcmi->regs, DCMI_CR, CR_CAPTURE);
 		}
 
 		break;
-- 
1.9.1
