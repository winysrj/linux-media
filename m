Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42410 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab1BYIWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 03:22:12 -0500
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ilho Lee <ilho215.lee@samsung.com>,
	KyungHwan Kim <kh.k.kim@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Jiun Yu <jiun.yu@samsung.com>,
	Abhilash Kesavan <a.kesavan@samsung.com>
Subject: [PATCH 4/5] [media] s5p-tvout: Add CEC driver for S5P TVOUT
Date: Fri, 25 Feb 2011 16:53:32 +0900
Message-Id: <1298620413-24182-5-git-send-email-a.kesavan@samsung.com>
In-Reply-To: <1298620413-24182-1-git-send-email-a.kesavan@samsung.com>
References: <1298620413-24182-1-git-send-email-a.kesavan@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: KyungHwan Kim <kh.k.kim@samsung.com>

This patch adds support CEC(Consumer Electronic Control) driver
for S5P TVOUT driver.

It allows source device to command and control CEC-enabled sink
devices in case of HDMI. For example, it can send signals like
turning on/off from source device to digital TV.

[based on work originally written by Sangpil Moon <sangpil.moon@samsung.com>]
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Jiun Yu <jiun.yu@samsung.com>
Signed-off-by: KyungHwan Kim <kh.k.kim@samsung.com>
Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
---
 drivers/media/video/s5p-tvout/hw_if/cec.c     |  239 ++++++++++++++++
 drivers/media/video/s5p-tvout/hw_if/hdcp.c    |    2 +-
 drivers/media/video/s5p-tvout/s5p_tvout_cec.c |  362 +++++++++++++++++++++++++
 3 files changed, 602 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/video/s5p-tvout/hw_if/cec.c
 create mode 100644 drivers/media/video/s5p-tvout/s5p_tvout_cec.c

diff --git a/drivers/media/video/s5p-tvout/hw_if/cec.c b/drivers/media/video/s5p-tvout/hw_if/cec.c
new file mode 100644
index 0000000..dbff584
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/hw_if/cec.c
@@ -0,0 +1,239 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * CEC for Samsung S5P TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#include <mach/regs-clock.h>
+#include <mach/regs-clock.h>
+#include <mach/regs-cec.h>
+
+#include "../s5p_tvout_common_lib.h"
+#include "hw_if.h"
+
+#define S5P_HDMI_FIN			24000000
+#define CEC_DIV_RATIO			320000
+
+#define CEC_MESSAGE_BROADCAST_MASK	0x0F
+#define CEC_MESSAGE_BROADCAST		0x0F
+#define CEC_FILTER_THRESHOLD		0x15
+
+static struct resource	*cec_mem;
+void __iomem		*cec_base;
+
+struct cec_rx_struct cec_rx_struct;
+struct cec_tx_struct cec_tx_struct;
+
+void s5p_cec_set_divider(void)
+{
+	u32 div_ratio, reg, div_val;
+
+	div_ratio  = (S5P_HDMI_FIN / CEC_DIV_RATIO) - 1;
+
+	reg = readl(S5P_HDMI_PHY_CONTROL);
+	reg = (reg & ~(0x3FF << 16)) | (div_ratio << 16);
+
+	writel(reg, S5P_HDMI_PHY_CONTROL);
+
+	div_val = (CEC_DIV_RATIO * 0.00005) - 1;
+
+	writeb(0x0, cec_base + S5P_CEC_DIVISOR_3);
+	writeb(0x0, cec_base + S5P_CEC_DIVISOR_2);
+	writeb(0x0, cec_base + S5P_CEC_DIVISOR_1);
+	writeb(div_val, cec_base + S5P_CEC_DIVISOR_0);
+}
+
+void s5p_cec_enable_rx(void)
+{
+	u8 reg;
+
+	reg = readb(cec_base + S5P_CEC_RX_CTRL);
+	reg |= S5P_CEC_RX_CTRL_ENABLE;
+	writeb(reg, cec_base + S5P_CEC_RX_CTRL);
+}
+
+void s5p_cec_mask_rx_interrupts(void)
+{
+	u8 reg;
+
+	reg = readb(cec_base + S5P_CEC_IRQ_MASK);
+	reg |= S5P_CEC_IRQ_RX_DONE;
+	reg |= S5P_CEC_IRQ_RX_ERROR;
+	writeb(reg, cec_base + S5P_CEC_IRQ_MASK);
+}
+
+void s5p_cec_unmask_rx_interrupts(void)
+{
+	u8 reg;
+
+	reg = readb(cec_base + S5P_CEC_IRQ_MASK);
+	reg &= ~S5P_CEC_IRQ_RX_DONE;
+	reg &= ~S5P_CEC_IRQ_RX_ERROR;
+	writeb(reg, cec_base + S5P_CEC_IRQ_MASK);
+}
+
+void s5p_cec_mask_tx_interrupts(void)
+{
+	u8 reg;
+
+	reg = readb(cec_base + S5P_CEC_IRQ_MASK);
+	reg |= S5P_CEC_IRQ_TX_DONE;
+	reg |= S5P_CEC_IRQ_TX_ERROR;
+	writeb(reg, cec_base + S5P_CEC_IRQ_MASK);
+}
+
+void s5p_cec_unmask_tx_interrupts(void)
+{
+	u8 reg;
+
+	reg = readb(cec_base + S5P_CEC_IRQ_MASK);
+	reg &= ~S5P_CEC_IRQ_TX_DONE;
+	reg &= ~S5P_CEC_IRQ_TX_ERROR;
+	writeb(reg, cec_base + S5P_CEC_IRQ_MASK);
+}
+
+void s5p_cec_tx_reset(void)
+{
+	writeb(S5P_CEC_TX_CTRL_RESET, cec_base + S5P_CEC_TX_CTRL);
+}
+
+void s5p_cec_rx_reset(void)
+{
+	writeb(S5P_CEC_RX_CTRL_RESET, cec_base + S5P_CEC_RX_CTRL);
+}
+
+void s5p_cec_reset(void)
+{
+	s5p_cec_rx_reset();
+	s5p_cec_tx_reset();
+}
+
+void s5p_cec_threshold(void)
+{
+	writeb(CEC_FILTER_THRESHOLD, cec_base + S5P_CEC_RX_FILTER_TH);
+	writeb(0, cec_base + S5P_CEC_RX_FILTER_CTRL);
+}
+
+void s5p_cec_set_tx_state(enum cec_state state)
+{
+	atomic_set(&cec_tx_struct.state, state);
+}
+
+void s5p_cec_set_rx_state(enum cec_state state)
+{
+	atomic_set(&cec_rx_struct.state, state);
+}
+
+void s5p_cec_copy_packet(char *data, size_t count)
+{
+	int i = 0;
+	u8 reg;
+
+	while (i < count) {
+		writeb(data[i], cec_base + (S5P_CEC_TX_BUFF0 + (i * 4)));
+		i++;
+	}
+
+	writeb(count, cec_base + S5P_CEC_TX_BYTES);
+	s5p_cec_set_tx_state(STATE_TX);
+	reg = readb(cec_base + S5P_CEC_TX_CTRL);
+	reg |= S5P_CEC_TX_CTRL_START;
+
+	if ((data[0] & CEC_MESSAGE_BROADCAST_MASK) == CEC_MESSAGE_BROADCAST)
+		reg |= S5P_CEC_TX_CTRL_BCAST;
+	else
+		reg &= ~S5P_CEC_TX_CTRL_BCAST;
+
+	reg |= 0x50;
+	writeb(reg, cec_base + S5P_CEC_TX_CTRL);
+}
+
+void s5p_cec_set_addr(u32 addr)
+{
+	writeb(addr & 0x0F, cec_base + S5P_CEC_LOGIC_ADDR);
+}
+
+u32 s5p_cec_get_status(void)
+{
+	u32 status = 0;
+
+	status = readb(cec_base + S5P_CEC_STATUS_0);
+	status |= readb(cec_base + S5P_CEC_STATUS_1) << 8;
+	status |= readb(cec_base + S5P_CEC_STATUS_2) << 16;
+	status |= readb(cec_base + S5P_CEC_STATUS_3) << 24;
+
+	return status;
+}
+
+void s5p_clr_pending_tx(void)
+{
+	writeb(S5P_CEC_IRQ_TX_DONE | S5P_CEC_IRQ_TX_ERROR,
+		cec_base + S5P_CEC_IRQ_CLEAR);
+}
+
+void s5p_clr_pending_rx(void)
+{
+	writeb(S5P_CEC_IRQ_RX_DONE | S5P_CEC_IRQ_RX_ERROR,
+		cec_base + S5P_CEC_IRQ_CLEAR);
+}
+
+void s5p_cec_get_rx_buf(u32 size, u8 *buffer)
+{
+	u32 i = 0;
+
+	while (i < size) {
+		buffer[i] = readb(cec_base + S5P_CEC_RX_BUFF0 + (i * 4));
+		i++;
+	}
+}
+
+void __init s5p_cec_mem_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	size_t size = 0;
+	int ret;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev,
+			"failed to get memory region resource for cec\n");
+		ret = -ENOENT;
+	} else
+		size = resource_size(res);
+
+	cec_mem = request_mem_region(res->start, size, pdev->name);
+	if (cec_mem == NULL) {
+		dev_err(&pdev->dev,
+			"failed to get memory region for cec\n");
+		ret = -ENOENT;
+	}
+
+	cec_base = ioremap(res->start, size);
+	if (cec_base == NULL) {
+		dev_err(&pdev->dev,
+			"failed to ioremap address region for cec\n");
+		ret = -ENOENT;
+	}
+}
+
+int __init s5p_cec_mem_release(struct platform_device *pdev)
+{
+	iounmap(cec_base);
+	if (cec_mem != NULL) {
+		if (release_resource(cec_mem))
+			dev_err(&pdev->dev, "can't remove tvout drv !!\n");
+
+		kfree(cec_mem);
+
+		cec_mem = NULL;
+	}
+	return 0;
+}
diff --git a/drivers/media/video/s5p-tvout/hw_if/hdcp.c b/drivers/media/video/s5p-tvout/hw_if/hdcp.c
index a254941..d1c95eb 100644
--- a/drivers/media/video/s5p-tvout/hw_if/hdcp.c
+++ b/drivers/media/video/s5p-tvout/hw_if/hdcp.c
@@ -33,7 +33,7 @@
 #define BKSV_SZ			5
 #define MAX_KEY_SZ		16
 
-#define BKSV_RETRY_CNT		14
+#define BKSV_RETRY_CNT		20
 #define BKSV_DELAY		100
 
 #define DDC_RETRY_CNT		400000
diff --git a/drivers/media/video/s5p-tvout/s5p_tvout_cec.c b/drivers/media/video/s5p-tvout/s5p_tvout_cec.c
new file mode 100644
index 0000000..ebeba9e
--- /dev/null
+++ b/drivers/media/video/s5p-tvout/s5p_tvout_cec.c
@@ -0,0 +1,362 @@
+/*
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * CEC Support for Samsung S5P TVOUT
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/poll.h>
+#include <linux/miscdevice.h>
+
+#include <plat/tvout.h>
+
+#include "s5p_tvout_common_lib.h"
+#include "hw_if/hw_if.h"
+
+#define CEC_IOC_MAGIC			'c'
+#define CEC_IOC_SETLADDR		_IOW(CEC_IOC_MAGIC, 0, unsigned int)
+
+/* /dev/cec (Major 10, Minor 242) */
+#define CEC_MINOR			242
+
+#define CEC_STATUS_TX_DONE		(1 << 2)
+#define CEC_STATUS_TX_ERROR		(1 << 3)
+#define CEC_STATUS_RX_DONE		(1 << 18)
+#define CEC_STATUS_RX_ERROR		(1 << 19)
+
+#define CEC_TX_BUFF_SIZE		16
+
+static atomic_t hdmi_on = ATOMIC_INIT(0);
+static DEFINE_MUTEX(cec_lock);
+
+static int s5p_cec_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	mutex_lock(&cec_lock);
+
+	if (atomic_read(&hdmi_on)) {
+		tvout_dbg("do not allow multiple open for tvout cec\n");
+		ret = -EBUSY;
+		goto err_multi_open;
+	} else
+		atomic_inc(&hdmi_on);
+
+	s5p_cec_reset();
+
+	s5p_cec_set_divider();
+
+	s5p_cec_threshold();
+
+	s5p_cec_unmask_tx_interrupts();
+
+	s5p_cec_set_rx_state(STATE_RX);
+	s5p_cec_unmask_rx_interrupts();
+	s5p_cec_enable_rx();
+
+err_multi_open:
+	mutex_unlock(&cec_lock);
+
+	return ret;
+}
+
+static int s5p_cec_release(struct inode *inode, struct file *file)
+{
+	atomic_dec(&hdmi_on);
+
+	s5p_cec_mask_tx_interrupts();
+	s5p_cec_mask_rx_interrupts();
+
+	return 0;
+}
+
+static ssize_t s5p_cec_read(struct file *file, char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	ssize_t retval;
+
+	if (wait_event_interruptible(cec_rx_struct.waitq, atomic_read(&cec_rx_struct.state) == STATE_DONE))
+		return -ERESTARTSYS;
+
+	spin_lock_irq(&cec_rx_struct.lock);
+
+	if (cec_rx_struct.size > count) {
+		spin_unlock_irq(&cec_rx_struct.lock);
+
+		return -1;
+	}
+
+	if (copy_to_user(buffer, cec_rx_struct.buffer, cec_rx_struct.size)) {
+		spin_unlock_irq(&cec_rx_struct.lock);
+		printk(KERN_ERR " copy_to_user() failed!\n");
+
+		return -EFAULT;
+	}
+
+	retval = cec_rx_struct.size;
+
+	s5p_cec_set_rx_state(STATE_RX);
+	spin_unlock_irq(&cec_rx_struct.lock);
+
+	return retval;
+}
+
+static ssize_t s5p_cec_write(struct file *file, const char __user *buffer,
+			     size_t count, loff_t *ppos)
+{
+	char *data;
+
+	/* check data size */
+
+	if (count > CEC_TX_BUFF_SIZE || count == 0)
+		return -1;
+
+	data = kmalloc(count, GFP_KERNEL);
+
+	if (!data) {
+		printk(KERN_ERR " kmalloc() failed!\n");
+
+		return -1;
+	}
+
+	if (copy_from_user(data, buffer, count)) {
+		printk(KERN_ERR " copy_from_user() failed!\n");
+		kfree(data);
+
+		return -EFAULT;
+	}
+
+	s5p_cec_copy_packet(data, count);
+
+	kfree(data);
+
+	/* wait for interrupt */
+	if (wait_event_interruptible(cec_tx_struct.waitq, atomic_read(&cec_tx_struct.state) != STATE_TX))
+		return -ERESTARTSYS;
+
+	if (atomic_read(&cec_tx_struct.state) == STATE_ERROR)
+		return -1;
+
+	return count;
+}
+
+static long s5p_cec_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
+{
+	u32 laddr;
+
+	switch (cmd) {
+	case CEC_IOC_SETLADDR:
+		if (get_user(laddr, (u32 __user *) arg))
+			return -EFAULT;
+
+		tvout_dbg("logical address = 0x%02x\n", laddr);
+
+		s5p_cec_set_addr(laddr);
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static u32 s5p_cec_poll(struct file *file, poll_table *wait)
+{
+	poll_wait(file, &cec_rx_struct.waitq, wait);
+
+	if (atomic_read(&cec_rx_struct.state) == STATE_DONE)
+		return POLLIN | POLLRDNORM;
+
+	return 0;
+}
+
+static const struct file_operations cec_fops = {
+	.owner			= THIS_MODULE,
+	.open			= s5p_cec_open,
+	.release		= s5p_cec_release,
+	.read			= s5p_cec_read,
+	.write			= s5p_cec_write,
+	.unlocked_ioctl		= s5p_cec_ioctl,
+	.poll			= s5p_cec_poll,
+};
+
+static struct miscdevice cec_misc_device = {
+	.minor			= CEC_MINOR,
+	.name			= "CEC",
+	.fops			= &cec_fops,
+};
+
+static irqreturn_t s5p_cec_irq_handler(int irq, void *dev_id)
+{
+	u32 status = s5p_cec_get_status();
+
+	if (status & CEC_STATUS_TX_DONE) {
+		if (status & CEC_STATUS_TX_ERROR) {
+			tvout_dbg(" CEC_STATUS_TX_ERROR!\n");
+			s5p_cec_set_tx_state(STATE_ERROR);
+		} else {
+			tvout_dbg(" CEC_STATUS_TX_DONE!\n");
+			s5p_cec_set_tx_state(STATE_DONE);
+		}
+
+		s5p_clr_pending_tx();
+
+		wake_up_interruptible(&cec_tx_struct.waitq);
+	}
+
+	if (status & CEC_STATUS_RX_DONE) {
+		if (status & CEC_STATUS_RX_ERROR) {
+			tvout_dbg(" CEC_STATUS_RX_ERROR!\n");
+			s5p_cec_rx_reset();
+
+		} else {
+			u32 size;
+
+			tvout_dbg(" CEC_STATUS_RX_DONE!\n");
+
+			/* copy data from internal buffer */
+			size = status >> 24;
+
+			spin_lock(&cec_rx_struct.lock);
+
+			s5p_cec_get_rx_buf(size, cec_rx_struct.buffer);
+
+			cec_rx_struct.size = size;
+
+			s5p_cec_set_rx_state(STATE_DONE);
+
+			spin_unlock(&cec_rx_struct.lock);
+
+			s5p_cec_enable_rx();
+		}
+
+		/* clear interrupt pending bit */
+		s5p_clr_pending_rx();
+
+		wake_up_interruptible(&cec_rx_struct.waitq);
+	}
+	return IRQ_HANDLED;
+}
+
+static int __init s5p_cec_probe(struct platform_device *pdev)
+{
+	struct s5p_platform_cec *pdata;
+	u8 *buffer;
+	int irq_num;
+	int ret;
+
+	pdata = to_tvout_plat(&pdev->dev);
+
+	if (pdata->cfg_gpio)
+		pdata->cfg_gpio(pdev);
+
+	/* get ioremap addr */
+	s5p_cec_mem_probe(pdev);
+
+	if (misc_register(&cec_misc_device)) {
+		printk(KERN_WARNING " Couldn't register device 10, %d.\n", CEC_MINOR);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	irq_num = platform_get_irq(pdev, 0);
+	if (irq_num < 0) {
+		printk(KERN_ERR  "failed to get %s irq resource\n", "cec");
+		ret = -EBUSY;
+		goto irq_err;
+	}
+
+	if (request_irq(irq_num, s5p_cec_irq_handler, IRQF_DISABLED, pdev->name, &pdev->id)) {
+		printk(KERN_ERR  "failed to install %s irq (%d)\n", "cec", ret);
+		ret = -EBUSY;
+		goto irq_err;
+	}
+
+	init_waitqueue_head(&cec_rx_struct.waitq);
+	spin_lock_init(&cec_rx_struct.lock);
+	init_waitqueue_head(&cec_tx_struct.waitq);
+
+	if (kmalloc(CEC_TX_BUFF_SIZE, GFP_KERNEL)) {
+		printk(KERN_ERR " kmalloc() failed!\n");
+		ret = -EIO;
+		goto kmalloc_err;
+	}
+
+	cec_rx_struct.buffer = buffer;
+	cec_rx_struct.size   = 0;
+
+	return 0;
+
+kmalloc_err:
+	free_irq(irq_num);
+irq_err:
+	misc_deregister(&cec_misc_device);
+out:
+	return ret;
+
+}
+
+static int s5p_cec_remove(struct platform_device *pdev)
+{
+	int irq_num = platform_get_irq(pdev, 0);
+
+	free_irq(irq_num);
+	misc_deregister(&cec_misc_device);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int s5p_cec_suspend(struct platform_device *dev, pm_message_t state)
+{
+	return 0;
+}
+
+static int s5p_cec_resume(struct platform_device *dev)
+{
+	return 0;
+}
+
+#else
+#define s5p_cec_suspend NULL
+#define s5p_cec_resume NULL
+#endif
+
+static struct platform_driver s5p_cec_driver = {
+	.probe		= s5p_cec_probe,
+	.remove		= s5p_cec_remove,
+	.suspend	= s5p_cec_suspend,
+	.resume		= s5p_cec_resume,
+	.driver		= {
+		.name		= "s5p-tvout-cec",
+		.owner		= THIS_MODULE,
+	},
+};
+
+static int __init s5p_cec_init(void)
+{
+	printk(KERN_INFO "S5P CEC for TVOUT Driver, Copyright (c) 2011 Samsung Electronics Co., LTD.\n");
+
+	return platform_driver_register(&s5p_cec_driver);
+}
+
+static void __exit s5p_cec_exit(void)
+{
+	kfree(cec_rx_struct.buffer);
+
+	platform_driver_unregister(&s5p_cec_driver);
+}
+module_init(s5p_cec_init);
+module_exit(s5p_cec_exit);
+
+MODULE_AUTHOR("KyungHwan Kim <kh.k.kim@samsung.com>");
+MODULE_DESCRIPTION("Samsung S5P CEC driver");
+MODULE_LICENSE("GPL");
-- 
1.7.1

