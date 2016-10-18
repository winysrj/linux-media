Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.microchip.com ([198.175.253.82]:42938 "EHLO
        email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758272AbcJRGPg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 02:15:36 -0400
From: Songjun Wu <songjun.wu@microchip.com>
To: Nicolas Ferre <nicolas.ferre@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Songjun Wu <songjun.wu@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [RESEND][PATCH] [media] atmel-isc: start dma in some scenario
Date: Tue, 18 Oct 2016 14:12:14 +0800
Message-ID: <1476771134-30075-1-git-send-email-songjun.wu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a new vb buf is added to vb queue, the queue is
empty and steaming, dma should be started.

Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
---

 drivers/media/platform/atmel/atmel-isc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index ccfe13b..ff403d5 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -617,7 +617,14 @@ static void isc_buffer_queue(struct vb2_buffer *vb)
 	unsigned long flags;
 
 	spin_lock_irqsave(&isc->dma_queue_lock, flags);
-	list_add_tail(&buf->list, &isc->dma_queue);
+	if (!isc->cur_frm && list_empty(&isc->dma_queue) &&
+		vb2_is_streaming(vb->vb2_queue)) {
+		isc->cur_frm = buf;
+		isc_start_dma(isc->regmap, isc->cur_frm,
+			isc->current_fmt->reg_dctrl_dview);
+	} else {
+		list_add_tail(&buf->list, &isc->dma_queue);
+	}
 	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
 }
 
-- 
2.7.4

