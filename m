Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60262 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753860AbdFLRNf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 13:13:35 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/6] [media] s5p-jpeg: Add stream error handling for Exynos5420
Date: Mon, 12 Jun 2017 19:13:25 +0200
Message-Id: <1497287605-20074-7-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
References: <1497287605-20074-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: henryhsu <henryhsu@chromium.org>

On Exynos5420, the STREAM_STAT bit raised on the JPGINTST register means
there is a syntax error or an unrecoverable error on compressed file
when ERR_INT_EN is set to 1.

Fix this case and report BUF_STATE_ERROR to videobuf2.

Signed-off-by: Henry-Ruey Hsu <henryhsu@chromium.org>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 3d90a63..1a07a82 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2790,6 +2790,7 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 	unsigned long payload_size = 0;
 	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
 	bool interrupt_timeout = false;
+	bool stream_error = false;
 	u32 irq_status;
 
 	spin_lock(&jpeg->slock);
@@ -2806,6 +2807,11 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 
 	jpeg->irq_status |= irq_status;
 
+	if (irq_status & EXYNOS3250_STREAM_STAT) {
+		stream_error = true;
+		dev_err(jpeg->dev, "Syntax error or unrecoverable error occurred.\n");
+	}
+
 	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
 
 	if (!curr_ctx)
@@ -2822,7 +2828,7 @@ static irqreturn_t exynos3250_jpeg_irq(int irq, void *dev_id)
 				EXYNOS3250_RDMA_DONE |
 				EXYNOS3250_RESULT_STAT))
 		payload_size = exynos3250_jpeg_compressed_size(jpeg->regs);
-	else if (interrupt_timeout)
+	else if (interrupt_timeout || stream_error)
 		state = VB2_BUF_STATE_ERROR;
 	else
 		goto exit_unlock;
-- 
2.7.4
