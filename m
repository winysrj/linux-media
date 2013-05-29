Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2555 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965643Ab3E2LJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:09:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCHv1 29/38] marvell-ccic: check register address.
Date: Wed, 29 May 2013 13:00:02 +0200
Message-Id: <1369825211-29770-30-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Prevent out-of-range register accesses.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/marvell-ccic/cafe-driver.c |    1 +
 drivers/media/platform/marvell-ccic/mcam-core.c   |    4 ++++
 drivers/media/platform/marvell-ccic/mcam-core.h   |    1 +
 drivers/media/platform/marvell-ccic/mmp-driver.c  |    1 +
 4 files changed, 7 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/cafe-driver.c b/drivers/media/platform/marvell-ccic/cafe-driver.c
index 7b07fc5..1f079ff 100644
--- a/drivers/media/platform/marvell-ccic/cafe-driver.c
+++ b/drivers/media/platform/marvell-ccic/cafe-driver.c
@@ -500,6 +500,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 		printk(KERN_ERR "Unable to ioremap cafe-ccic regs\n");
 		goto out_disable;
 	}
+	mcam->regs_size = pci_resource_len(pdev, 0);
 	ret = request_irq(pdev->irq, cafe_irq, IRQF_SHARED, "cafe-ccic", cam);
 	if (ret)
 		goto out_iounmap;
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index a187161..c69cfc4 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1404,6 +1404,8 @@ static int mcam_vidioc_g_register(struct file *file, void *priv,
 {
 	struct mcam_camera *cam = priv;
 
+	if (reg->reg > cam->regs_size - 4)
+		return -EINVAL;
 	reg->val = mcam_reg_read(cam, reg->reg);
 	reg->size = 4;
 	return 0;
@@ -1414,6 +1416,8 @@ static int mcam_vidioc_s_register(struct file *file, void *priv,
 {
 	struct mcam_camera *cam = priv;
 
+	if (reg->reg > cam->regs_size - 4)
+		return -EINVAL;
 	mcam_reg_write(cam, reg->reg, reg->val);
 	return 0;
 }
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 46b6ea3..520c8de 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -101,6 +101,7 @@ struct mcam_camera {
 	 */
 	struct i2c_adapter *i2c_adapter;
 	unsigned char __iomem *regs;
+	unsigned regs_size; /* size in bytes of the register space */
 	spinlock_t dev_lock;
 	struct device *dev; /* For messages, dma alloc */
 	enum mcam_chip_id chip_id;
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index cadad64..a634888 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -202,6 +202,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 		ret = -ENODEV;
 		goto out_free;
 	}
+	mcam->regs_size = resource_size(res);
 	/*
 	 * Power/clock memory is elsewhere; get it too.  Perhaps this
 	 * should really be managed outside of this driver?
-- 
1.7.10.4

