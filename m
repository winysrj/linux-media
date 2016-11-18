Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:42891 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753464AbcKRXVL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:11 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 03/35] media: ti-vpe: vpdma: Add helper to set a background color
Date: Fri, 18 Nov 2016 17:20:13 -0600
Message-ID: <20161118232045.24665-4-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a helper to set the background color during vpdma transfer.
This is needed when VPDMA is generating 32 bits RGB format
to have the Alpha channel set to an appropriate value.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 10 ++++++++++
 drivers/media/platform/ti-vpe/vpdma.h |  3 ++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 2b094016b470..133154628543 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -867,6 +867,16 @@ void vpdma_clear_list_stat(struct vpdma_data *vpdma, int irq_num)
 }
 EXPORT_SYMBOL(vpdma_clear_list_stat);
 
+void vpdma_set_bg_color(struct vpdma_data *vpdma,
+		struct vpdma_data_format *fmt, u32 color)
+{
+	if (fmt->type == VPDMA_DATA_FMT_TYPE_RGB)
+		write_reg(vpdma, VPDMA_BG_RGB, color);
+	else if (fmt->type == VPDMA_DATA_FMT_TYPE_YUV)
+		write_reg(vpdma, VPDMA_BG_YUV, color);
+}
+EXPORT_SYMBOL(vpdma_set_bg_color);
+
 /*
  * configures the output mode of the line buffer for the given client, the
  * line buffer content can either be mirrored(each line repeated twice) or
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 83325d887546..220dc7e793f6 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -221,7 +221,8 @@ void vpdma_set_line_mode(struct vpdma_data *vpdma, int line_mode,
 		enum vpdma_channel chan);
 void vpdma_set_frame_start_event(struct vpdma_data *vpdma,
 		enum vpdma_frame_start_event fs_event, enum vpdma_channel chan);
-
+void vpdma_set_bg_color(struct vpdma_data *vpdma,
+			struct vpdma_data_format *fmt, u32 color);
 void vpdma_dump_regs(struct vpdma_data *vpdma);
 
 /* initialize vpdma, passed with VPE's platform device pointer */
-- 
2.9.0

