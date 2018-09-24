Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:5679 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728862AbeIXS5g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 14:57:36 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH] media: stm32-dcmi: only enable IT frame on JPEG capture
Date: Mon, 24 Sep 2018 14:54:59 +0200
Message-ID: <1537793699-2555-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Only enable IT frame on JPEG capture, this saves some CPU
interruptions and processing on all the other cases.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index ba3e2ee..d6b00eda 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -659,7 +659,10 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	/* Enable interruptions */
-	reg_set(dcmi->regs, DCMI_IER, IT_FRAME | IT_OVR | IT_ERR);
+	if (dcmi->sd_format->fourcc == V4L2_PIX_FMT_JPEG)
+		reg_set(dcmi->regs, DCMI_IER, IT_FRAME | IT_OVR | IT_ERR);
+	else
+		reg_set(dcmi->regs, DCMI_IER, IT_OVR | IT_ERR);
 
 	return 0;
 
-- 
2.7.4
