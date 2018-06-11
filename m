Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:2915 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932453AbeFKJvB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 05:51:01 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH 1/4] media: stm32-dcmi: do not fall into error on buffer starvation
Date: Mon, 11 Jun 2018 11:50:24 +0200
Message-ID: <1528710627-8566-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1528710627-8566-1-git-send-email-hugues.fruchet@st.com>
References: <1528710627-8566-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Return silently instead of falling into error when running
out of available buffers when restarting capture.
Capture will be restarted when new buffers will be
provided by V4L2 client.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index b796334..a3fbfac 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -228,13 +228,10 @@ static int dcmi_restart_capture(struct stm32_dcmi *dcmi)
 
 	/* Restart a new DMA transfer with next buffer */
 	if (list_empty(&dcmi->buffers)) {
-		dev_err(dcmi->dev, "%s: No more buffer queued, cannot capture buffer\n",
-			__func__);
-		dcmi->errors_count++;
+		dev_dbg(dcmi->dev, "Capture restart is deferred to next buffer queueing\n");
 		dcmi->active = NULL;
-
 		spin_unlock_irq(&dcmi->irqlock);
-		return -EINVAL;
+		return 0;
 	}
 
 	dcmi->active = list_entry(dcmi->buffers.next,
-- 
1.9.1
