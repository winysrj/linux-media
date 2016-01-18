Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33641 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbcARMx5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 07:53:57 -0500
Received: by mail-pa0-f66.google.com with SMTP id pv5so33614502pac.0
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2016 04:53:57 -0800 (PST)
From: Josh Wu <rainyfeeling@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
	linux-arm-kernel@lists.infradead.org,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Songjun Wu <songjun.wu@atmel.com>,
	Josh Wu <rainyfeeling@gmail.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 13/13] atmel-isi: use an hw_data structure according compatible string
Date: Mon, 18 Jan 2016 20:52:25 +0800
Message-Id: <1453121545-27528-9-git-send-email-rainyfeeling@gmail.com>
In-Reply-To: <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
References: <1453119709-20940-1-git-send-email-rainyfeeling@gmail.com>
 <1453121545-27528-1-git-send-email-rainyfeeling@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Josh Wu <josh.wu@atmel.com>

The hw_data can define new hw_ops, hw_regs, which has all hardware related
data. That can make us easy to add another hardware support.

Also rename the hw related function with 'isi_' prefix.

Signed-off-by: Josh Wu <rainyfeeling@gmail.com>
---

 drivers/media/platform/soc_camera/atmel-isi.c | 88 ++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index b4c1f38..7f7be7d 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
@@ -91,6 +92,8 @@ struct atmel_isi {
 	struct frame_buffer		*active;
 
 	struct soc_camera_host		soc_host;
+	struct at91_camera_hw_ops	*hw_ops;
+	struct at91_camera_hw_regs	*hw_regs;
 };
 
 static void isi_writel(struct atmel_isi *isi, u32 reg, u32 val)
@@ -102,6 +105,29 @@ static u32 isi_readl(struct atmel_isi *isi, u32 reg)
 	return readl(isi->regs + reg);
 }
 
+struct at91_camera_hw_ops {
+	/* start dma transfer */
+	void (*hw_start_dma)(struct atmel_isi *isi, struct frame_buffer *buf);
+	/* start ISI hardware capture */
+	void (*hw_start)(struct atmel_isi *isi);
+	int  (*hw_initialize)(struct atmel_isi *isi);
+	void (*hw_uninitialize)(struct atmel_isi *isi);
+	void (*hw_configure)(struct atmel_isi *isi, u32 width, u32 height,
+			     const struct soc_camera_format_xlate *xlate);
+	irqreturn_t (*hw_interrupt)(int irq, void *dev_id);
+	void (*hw_init_dma_desc)(union fbd *p_fdb, u32 fb_addr,
+			      u32 next_fbd_addr);
+};
+
+struct at91_camera_hw_regs {
+	u32 status_reg_offset;
+};
+
+struct at91_camera_hw_data {
+	struct at91_camera_hw_ops *hw_ops;
+	struct at91_camera_hw_regs *hw_regs;
+};
+
 static u32 setup_cfg2_yuv_swap(struct atmel_isi *isi,
 		const struct soc_camera_format_xlate *xlate)
 {
@@ -140,7 +166,7 @@ static u32 setup_cfg2_yuv_swap(struct atmel_isi *isi,
 	return ISI_CFG2_YCC_SWAP_DEFAULT;
 }
 
-static void configure_geometry(struct atmel_isi *isi, u32 width,
+static void isi_configure_geometry(struct atmel_isi *isi, u32 width,
 		u32 height, const struct soc_camera_format_xlate *xlate)
 {
 	u32 cfg2, psize;
@@ -192,8 +218,8 @@ static int isi_hw_wait_status(struct atmel_isi *isi, int status_flag,
 {
 	unsigned long timeout = jiffies + wait_ms * HZ;
 
-	while ((isi_readl(isi, ISI_STATUS) & status_flag) &&
-			time_before(jiffies, timeout))
+	while ((isi_readl(isi, isi->hw_regs->status_reg_offset) & status_flag)
+			&& time_before(jiffies, timeout))
 		msleep(1);
 
 	if (time_after(jiffies, timeout))
@@ -274,7 +300,7 @@ static void isi_hw_uninitialize(struct atmel_isi *isi)
 		dev_err(isi->soc_host.icd->parent, "Disable ISI timed out\n");
 }
 
-static void start_isi(struct atmel_isi *isi)
+static void isi_start(struct atmel_isi *isi)
 {
 	u32 ctrl;
 
@@ -288,7 +314,7 @@ static void start_isi(struct atmel_isi *isi)
 	isi_writel(isi, ISI_CTRL, ctrl);
 }
 
-static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
+static void isi_start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 {
 	/* Check if already in a frame */
 	if (!isi->enable_preview_path) {
@@ -330,7 +356,8 @@ static irqreturn_t atmel_isi_handle_streaming(struct atmel_isi *isi)
 		/* start next dma frame. */
 		isi->active = list_entry(isi->video_buffer_list.next,
 					struct frame_buffer, list);
-		start_dma(isi, isi->active);
+
+		(*isi->hw_ops->hw_start_dma)(isi, isi->active);
 	}
 	return IRQ_HANDLED;
 }
@@ -419,6 +446,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	struct atmel_isi *isi = ici->priv;
 	unsigned long size;
 	struct isi_dma_desc *desc;
+	u32 vb_addr;
 
 	size = icd->sizeimage;
 
@@ -442,7 +470,8 @@ static int buffer_prepare(struct vb2_buffer *vb)
 			list_del_init(&desc->list);
 
 			/* Initialize the dma descriptor */
-			isi_hw_init_dma_desc(desc->p_fbd, vb2_dma_contig_plane_dma_addr(vb, 0), 0);
+			vb_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
+			(*isi->hw_ops->hw_init_dma_desc)(desc->p_fbd, vb_addr, 0);
 
 			buf->p_dma_desc = desc;
 		}
@@ -478,7 +507,7 @@ static void buffer_queue(struct vb2_buffer *vb)
 	if (isi->active == NULL) {
 		isi->active = buf;
 		if (vb2_is_streaming(vb->vb2_queue))
-			start_dma(isi, buf);
+			(*isi->hw_ops->hw_start_dma)(isi, buf);
 	}
 	spin_unlock_irqrestore(&isi->lock, flags);
 }
@@ -492,20 +521,20 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	pm_runtime_get_sync(ici->v4l2_dev.dev);
 
-	ret = isi_hw_initialize(isi);
+	ret = (*isi->hw_ops->hw_initialize)(isi);
 	if (ret) {
 		pm_runtime_put(ici->v4l2_dev.dev);
 		return ret;
 	}
 
-	configure_geometry(isi, icd->user_width, icd->user_height,
-				icd->current_fmt);
+	(*isi->hw_ops->hw_configure)(isi, icd->user_width, icd->user_height,
+				     icd->current_fmt);
 
 	spin_lock_irq(&isi->lock);
 
 	if (count) {
-		start_dma(isi, isi->active);
-		start_isi(isi);
+		(*isi->hw_ops->hw_start_dma)(isi, isi->active);
+		(*isi->hw_ops->hw_start)(isi);
 	}
 
 	spin_unlock_irq(&isi->lock);
@@ -530,7 +559,7 @@ static void stop_streaming(struct vb2_queue *vq)
 	}
 	spin_unlock_irq(&isi->lock);
 
-	isi_hw_uninitialize(isi);
+	(*isi->hw_ops->hw_uninitialize)(isi);
 
 	pm_runtime_put(ici->v4l2_dev.dev);
 }
@@ -993,6 +1022,7 @@ static int atmel_isi_parse_dt(struct atmel_isi *isi,
 	return 0;
 }
 
+static const struct of_device_id atmel_isi_of_match[];
 static int atmel_isi_probe(struct platform_device *pdev)
 {
 	unsigned int irq;
@@ -1000,6 +1030,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	struct resource *regs;
 	int ret, i;
 	struct soc_camera_host *soc_host;
+	struct at91_camera_hw_data *hw_data;
 
 	isi = devm_kzalloc(&pdev->dev, sizeof(struct atmel_isi), GFP_KERNEL);
 	if (!isi) {
@@ -1015,6 +1046,11 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	hw_data = (struct at91_camera_hw_data *)
+		of_match_device(atmel_isi_of_match, &pdev->dev)->data;
+	isi->hw_ops = hw_data->hw_ops;
+	isi->hw_regs = hw_data->hw_regs;
+
 	isi->active = NULL;
 	spin_lock_init(&isi->lock);
 	INIT_LIST_HEAD(&isi->video_buffer_list);
@@ -1060,7 +1096,8 @@ static int atmel_isi_probe(struct platform_device *pdev)
 		goto err_req_irq;
 	}
 
-	ret = devm_request_irq(&pdev->dev, irq, isi_interrupt, 0, "isi", isi);
+	ret = devm_request_irq(&pdev->dev, irq, isi->hw_ops->hw_interrupt, 0,
+			       "isi", isi);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to request irq %d\n", irq);
 		goto err_req_irq;
@@ -1119,13 +1156,32 @@ static int atmel_isi_runtime_resume(struct device *dev)
 }
 #endif /* CONFIG_PM */
 
+static struct at91_camera_hw_ops at91sam9g45_ops = {
+	.hw_initialize = isi_hw_initialize,
+	.hw_uninitialize = isi_hw_uninitialize,
+	.hw_configure = isi_configure_geometry,
+	.hw_start = isi_start,
+	.hw_start_dma = isi_start_dma,
+	.hw_interrupt = isi_interrupt,
+	.hw_init_dma_desc = isi_hw_init_dma_desc,
+};
+
+static struct at91_camera_hw_regs at91sam9g45_regs = {
+	.status_reg_offset = ISI_STATUS,
+};
+
+static struct at91_camera_hw_data at91sam9g45_data = {
+	.hw_ops = &at91sam9g45_ops,
+	.hw_regs = &at91sam9g45_regs,
+};
+
 static const struct dev_pm_ops atmel_isi_dev_pm_ops = {
 	SET_RUNTIME_PM_OPS(atmel_isi_runtime_suspend,
 				atmel_isi_runtime_resume, NULL)
 };
 
 static const struct of_device_id atmel_isi_of_match[] = {
-	{ .compatible = "atmel,at91sam9g45-isi" },
+	{ .compatible = "atmel,at91sam9g45-isi", .data = &at91sam9g45_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, atmel_isi_of_match);
-- 
1.9.1

