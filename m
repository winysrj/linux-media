Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:43031 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758412Ab1FFWks (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 18:40:48 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>,
	Jonathan Corbet <corbet@lwn.net>, Daniel Drake <dsd@laptop.org>
Subject: [PATCH 2/7] marvell-cam: Separate out the Marvell camera core
Date: Mon,  6 Jun 2011 16:39:58 -0600
Message-Id: <1307400003-94758-3-git-send-email-corbet@lwn.net>
In-Reply-To: <1307400003-94758-1-git-send-email-corbet@lwn.net>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There will eventually be multiple users of the core camera controller, so
separate it from the bus/platform/i2c stuff.  I've tried to do the minimal
set of changes to get the driver functioning in this configuration; I did
clean up a bunch of old checkpatch gripes in the process.  This driver
works like the old one did on OLPC XO 1 systems.

Cc: Daniel Drake <dsd@laptop.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/Makefile         |    1 +
 drivers/media/video/marvell-ccic/cafe-driver.c    |  569 ++++++
 drivers/media/video/marvell-ccic/cafe_ccic-regs.h |  166 --
 drivers/media/video/marvell-ccic/cafe_ccic.c      | 2267 ---------------------
 drivers/media/video/marvell-ccic/mcam-core.c      | 1689 +++++++++++++++
 drivers/media/video/marvell-ccic/mcam-core.h      |  319 +++
 6 files changed, 2578 insertions(+), 2433 deletions(-)
 create mode 100644 drivers/media/video/marvell-ccic/cafe-driver.c
 delete mode 100644 drivers/media/video/marvell-ccic/cafe_ccic-regs.h
 delete mode 100644 drivers/media/video/marvell-ccic/cafe_ccic.c
 create mode 100644 drivers/media/video/marvell-ccic/mcam-core.c
 create mode 100644 drivers/media/video/marvell-ccic/mcam-core.h

diff --git a/drivers/media/video/marvell-ccic/Makefile b/drivers/media/video/marvell-ccic/Makefile
index 1234725..462b385c 100644
--- a/drivers/media/video/marvell-ccic/Makefile
+++ b/drivers/media/video/marvell-ccic/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
+cafe_ccic-y := cafe-driver.o mcam-core.o
diff --git a/drivers/media/video/marvell-ccic/cafe-driver.c b/drivers/media/video/marvell-ccic/cafe-driver.c
new file mode 100644
index 0000000..1e9f38f
--- /dev/null
+++ b/drivers/media/video/marvell-ccic/cafe-driver.c
@@ -0,0 +1,569 @@
+/*
+ * A driver for the CMOS camera controller in the Marvell 88ALP01 "cafe"
+ * multifunction chip.  Currently works with the Omnivision OV7670
+ * sensor.
+ *
+ * The data sheet for this device can be found at:
+ *    http://www.marvell.com/products/pc_connectivity/88alp01/
+ *
+ * Copyright 2006-11 One Laptop Per Child Association, Inc.
+ * Copyright 2006-11 Jonathan Corbet <corbet@lwn.net>
+ *
+ * Written by Jonathan Corbet, corbet@lwn.net.
+ *
+ * v4l2_device/v4l2_subdev conversion by:
+ * Copyright (C) 2009 Hans Verkuil <hverkuil@xs4all.nl>
+ *
+ * Note: this conversion is untested! Please contact the linux-media
+ * mailinglist if you can test this, together with the test results.
+ *
+ * This file may be distributed under the terms of the GNU General
+ * Public License, version 2.
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <linux/device.h>
+#include <linux/wait.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+
+#include "mcam-core.h"
+
+#define CAFE_VERSION 0x000002
+
+
+/*
+ * Parameters.
+ */
+MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
+MODULE_DESCRIPTION("Marvell 88ALP01 CMOS Camera Controller driver");
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("Video");
+
+
+
+
+struct cafe_camera {
+	int registered;			/* Fully initialized? */
+	struct mcam_camera mcam;
+	struct pci_dev *pdev;
+	wait_queue_head_t smbus_wait;	/* Waiting on i2c events */
+};
+
+/*
+ * Debugging and related.
+ */
+#define cam_err(cam, fmt, arg...) \
+	dev_err(&(cam)->pdev->dev, fmt, ##arg);
+#define cam_warn(cam, fmt, arg...) \
+	dev_warn(&(cam)->pdev->dev, fmt, ##arg);
+
+/* -------------------------------------------------------------------- */
+/*
+ * The I2C/SMBUS interface to the camera itself starts here.  The
+ * controller handles SMBUS itself, presenting a relatively simple register
+ * interface; all we have to do is to tell it where to route the data.
+ */
+#define CAFE_SMBUS_TIMEOUT (HZ)  /* generous */
+
+static inline struct cafe_camera *to_cam(struct v4l2_device *dev)
+{
+	struct mcam_camera *m = container_of(dev, struct mcam_camera, v4l2_dev);
+	return container_of(m, struct cafe_camera, mcam);
+}
+
+
+static int cafe_smbus_write_done(struct mcam_camera *mcam)
+{
+	unsigned long flags;
+	int c1;
+
+	/*
+	 * We must delay after the interrupt, or the controller gets confused
+	 * and never does give us good status.  Fortunately, we don't do this
+	 * often.
+	 */
+	udelay(20);
+	spin_lock_irqsave(&mcam->dev_lock, flags);
+	c1 = mcam_reg_read(mcam, REG_TWSIC1);
+	spin_unlock_irqrestore(&mcam->dev_lock, flags);
+	return (c1 & (TWSIC1_WSTAT|TWSIC1_ERROR)) != TWSIC1_WSTAT;
+}
+
+static int cafe_smbus_write_data(struct cafe_camera *cam,
+		u16 addr, u8 command, u8 value)
+{
+	unsigned int rval;
+	unsigned long flags;
+	struct mcam_camera *mcam = &cam->mcam;
+
+	spin_lock_irqsave(&mcam->dev_lock, flags);
+	rval = TWSIC0_EN | ((addr << TWSIC0_SID_SHIFT) & TWSIC0_SID);
+	rval |= TWSIC0_OVMAGIC;  /* Make OV sensors work */
+	/*
+	 * Marvell sez set clkdiv to all 1's for now.
+	 */
+	rval |= TWSIC0_CLKDIV;
+	mcam_reg_write(mcam, REG_TWSIC0, rval);
+	(void) mcam_reg_read(mcam, REG_TWSIC1); /* force write */
+	rval = value | ((command << TWSIC1_ADDR_SHIFT) & TWSIC1_ADDR);
+	mcam_reg_write(mcam, REG_TWSIC1, rval);
+	spin_unlock_irqrestore(&mcam->dev_lock, flags);
+
+	/* Unfortunately, reading TWSIC1 too soon after sending a command
+	 * causes the device to die.
+	 * Use a busy-wait because we often send a large quantity of small
+	 * commands at-once; using msleep() would cause a lot of context
+	 * switches which take longer than 2ms, resulting in a noticeable
+	 * boot-time and capture-start delays.
+	 */
+	mdelay(2);
+
+	/*
+	 * Another sad fact is that sometimes, commands silently complete but
+	 * cafe_smbus_write_done() never becomes aware of this.
+	 * This happens at random and appears to possible occur with any
+	 * command.
+	 * We don't understand why this is. We work around this issue
+	 * with the timeout in the wait below, assuming that all commands
+	 * complete within the timeout.
+	 */
+	wait_event_timeout(cam->smbus_wait, cafe_smbus_write_done(mcam),
+			CAFE_SMBUS_TIMEOUT);
+
+	spin_lock_irqsave(&mcam->dev_lock, flags);
+	rval = mcam_reg_read(mcam, REG_TWSIC1);
+	spin_unlock_irqrestore(&mcam->dev_lock, flags);
+
+	if (rval & TWSIC1_WSTAT) {
+		cam_err(cam, "SMBUS write (%02x/%02x/%02x) timed out\n", addr,
+				command, value);
+		return -EIO;
+	}
+	if (rval & TWSIC1_ERROR) {
+		cam_err(cam, "SMBUS write (%02x/%02x/%02x) error\n", addr,
+				command, value);
+		return -EIO;
+	}
+	return 0;
+}
+
+
+
+static int cafe_smbus_read_done(struct mcam_camera *mcam)
+{
+	unsigned long flags;
+	int c1;
+
+	/*
+	 * We must delay after the interrupt, or the controller gets confused
+	 * and never does give us good status.  Fortunately, we don't do this
+	 * often.
+	 */
+	udelay(20);
+	spin_lock_irqsave(&mcam->dev_lock, flags);
+	c1 = mcam_reg_read(mcam, REG_TWSIC1);
+	spin_unlock_irqrestore(&mcam->dev_lock, flags);
+	return c1 & (TWSIC1_RVALID|TWSIC1_ERROR);
+}
+
+
+
+static int cafe_smbus_read_data(struct cafe_camera *cam,
+		u16 addr, u8 command, u8 *value)
+{
+	unsigned int rval;
+	unsigned long flags;
+	struct mcam_camera *mcam = &cam->mcam;
+
+	spin_lock_irqsave(&mcam->dev_lock, flags);
+	rval = TWSIC0_EN | ((addr << TWSIC0_SID_SHIFT) & TWSIC0_SID);
+	rval |= TWSIC0_OVMAGIC; /* Make OV sensors work */
+	/*
+	 * Marvel sez set clkdiv to all 1's for now.
+	 */
+	rval |= TWSIC0_CLKDIV;
+	mcam_reg_write(mcam, REG_TWSIC0, rval);
+	(void) mcam_reg_read(mcam, REG_TWSIC1); /* force write */
+	rval = TWSIC1_READ | ((command << TWSIC1_ADDR_SHIFT) & TWSIC1_ADDR);
+	mcam_reg_write(mcam, REG_TWSIC1, rval);
+	spin_unlock_irqrestore(&mcam->dev_lock, flags);
+
+	wait_event_timeout(cam->smbus_wait,
+			cafe_smbus_read_done(mcam), CAFE_SMBUS_TIMEOUT);
+	spin_lock_irqsave(&mcam->dev_lock, flags);
+	rval = mcam_reg_read(mcam, REG_TWSIC1);
+	spin_unlock_irqrestore(&mcam->dev_lock, flags);
+
+	if (rval & TWSIC1_ERROR) {
+		cam_err(cam, "SMBUS read (%02x/%02x) error\n", addr, command);
+		return -EIO;
+	}
+	if (!(rval & TWSIC1_RVALID)) {
+		cam_err(cam, "SMBUS read (%02x/%02x) timed out\n", addr,
+				command);
+		return -EIO;
+	}
+	*value = rval & 0xff;
+	return 0;
+}
+
+/*
+ * Perform a transfer over SMBUS.  This thing is called under
+ * the i2c bus lock, so we shouldn't race with ourselves...
+ */
+static int cafe_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
+		unsigned short flags, char rw, u8 command,
+		int size, union i2c_smbus_data *data)
+{
+	struct cafe_camera *cam = i2c_get_adapdata(adapter);
+	int ret = -EINVAL;
+
+	/*
+	 * This interface would appear to only do byte data ops.  OK
+	 * it can do word too, but the cam chip has no use for that.
+	 */
+	if (size != I2C_SMBUS_BYTE_DATA) {
+		cam_err(cam, "funky xfer size %d\n", size);
+		return -EINVAL;
+	}
+
+	if (rw == I2C_SMBUS_WRITE)
+		ret = cafe_smbus_write_data(cam, addr, command, data->byte);
+	else if (rw == I2C_SMBUS_READ)
+		ret = cafe_smbus_read_data(cam, addr, command, &data->byte);
+	return ret;
+}
+
+
+static void cafe_smbus_enable_irq(struct cafe_camera *cam)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cam->mcam.dev_lock, flags);
+	mcam_reg_set_bit(&cam->mcam, REG_IRQMASK, TWSIIRQS);
+	spin_unlock_irqrestore(&cam->mcam.dev_lock, flags);
+}
+
+static u32 cafe_smbus_func(struct i2c_adapter *adapter)
+{
+	return I2C_FUNC_SMBUS_READ_BYTE_DATA  |
+	       I2C_FUNC_SMBUS_WRITE_BYTE_DATA;
+}
+
+static struct i2c_algorithm cafe_smbus_algo = {
+	.smbus_xfer = cafe_smbus_xfer,
+	.functionality = cafe_smbus_func
+};
+
+static int cafe_smbus_setup(struct cafe_camera *cam)
+{
+	struct i2c_adapter *adap = &cam->mcam.i2c_adapter;
+	int ret;
+
+	cafe_smbus_enable_irq(cam);
+	adap->owner = THIS_MODULE;
+	adap->algo = &cafe_smbus_algo;
+	strcpy(adap->name, "cafe_ccic");
+	adap->dev.parent = &cam->pdev->dev;
+	i2c_set_adapdata(adap, cam);
+	ret = i2c_add_adapter(adap);
+	if (ret)
+		printk(KERN_ERR "Unable to register cafe i2c adapter\n");
+	return ret;
+}
+
+static void cafe_smbus_shutdown(struct cafe_camera *cam)
+{
+	i2c_del_adapter(&cam->mcam.i2c_adapter);
+}
+
+
+/*
+ * Controller-level stuff
+ */
+
+static void cafe_ctlr_init(struct mcam_camera *mcam)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mcam->dev_lock, flags);
+	/*
+	 * Added magic to bring up the hardware on the B-Test board
+	 */
+	mcam_reg_write(mcam, 0x3038, 0x8);
+	mcam_reg_write(mcam, 0x315c, 0x80008);
+	/*
+	 * Go through the dance needed to wake the device up.
+	 * Note that these registers are global and shared
+	 * with the NAND and SD devices.  Interaction between the
+	 * three still needs to be examined.
+	 */
+	mcam_reg_write(mcam, REG_GL_CSR, GCSR_SRS|GCSR_MRS); /* Needed? */
+	mcam_reg_write(mcam, REG_GL_CSR, GCSR_SRC|GCSR_MRC);
+	mcam_reg_write(mcam, REG_GL_CSR, GCSR_SRC|GCSR_MRS);
+	/*
+	 * Here we must wait a bit for the controller to come around.
+	 */
+	spin_unlock_irqrestore(&mcam->dev_lock, flags);
+	msleep(5);
+	spin_lock_irqsave(&mcam->dev_lock, flags);
+
+	mcam_reg_write(mcam, REG_GL_CSR, GCSR_CCIC_EN|GCSR_SRC|GCSR_MRC);
+	mcam_reg_set_bit(mcam, REG_GL_IMASK, GIMSK_CCIC_EN);
+	/*
+	 * Mask all interrupts.
+	 */
+	mcam_reg_write(mcam, REG_IRQMASK, 0);
+	spin_unlock_irqrestore(&mcam->dev_lock, flags);
+}
+
+
+static void cafe_ctlr_power_up(struct mcam_camera *mcam)
+{
+	/*
+	 * Part one of the sensor dance: turn the global
+	 * GPIO signal on.
+	 */
+	mcam_reg_write(mcam, REG_GL_FCR, GFCR_GPIO_ON);
+	mcam_reg_write(mcam, REG_GL_GPIOR, GGPIO_OUT|GGPIO_VAL);
+	/*
+	 * Put the sensor into operational mode (assumes OLPC-style
+	 * wiring).  Control 0 is reset - set to 1 to operate.
+	 * Control 1 is power down, set to 0 to operate.
+	 */
+	mcam_reg_write(mcam, REG_GPR, GPR_C1EN|GPR_C0EN); /* pwr up, reset */
+	mcam_reg_write(mcam, REG_GPR, GPR_C1EN|GPR_C0EN|GPR_C0);
+}
+
+static void cafe_ctlr_power_down(struct mcam_camera *mcam)
+{
+	mcam_reg_write(mcam, REG_GPR, GPR_C1EN|GPR_C0EN|GPR_C1);
+	mcam_reg_write(mcam, REG_GL_FCR, GFCR_GPIO_ON);
+	mcam_reg_write(mcam, REG_GL_GPIOR, GGPIO_OUT);
+}
+
+
+
+/*
+ * The platform interrupt handler.
+ */
+static irqreturn_t cafe_irq(int irq, void *data)
+{
+	struct cafe_camera *cam = data;
+	struct mcam_camera *mcam = &cam->mcam;
+	unsigned int irqs, handled;
+
+	spin_lock(&mcam->dev_lock);
+	irqs = mcam_reg_read(mcam, REG_IRQSTAT);
+	handled = cam->registered && mccic_irq(mcam, irqs);
+	if (irqs & TWSIIRQS) {
+		mcam_reg_write(mcam, REG_IRQSTAT, TWSIIRQS);
+		wake_up(&cam->smbus_wait);
+		handled = 1;
+	}
+	spin_unlock(&mcam->dev_lock);
+	return IRQ_RETVAL(handled);
+}
+
+
+/* -------------------------------------------------------------------------- */
+/*
+ * PCI interface stuff.
+ */
+
+static int cafe_pci_probe(struct pci_dev *pdev,
+		const struct pci_device_id *id)
+{
+	int ret;
+	struct cafe_camera *cam;
+	struct mcam_camera *mcam;
+
+	/*
+	 * Start putting together one of our big camera structures.
+	 */
+	ret = -ENOMEM;
+	cam = kzalloc(sizeof(struct cafe_camera), GFP_KERNEL);
+	if (cam == NULL)
+		goto out;
+	cam->pdev = pdev;
+	mcam = &cam->mcam;
+	mcam->platform = MHP_Cafe;
+	spin_lock_init(&mcam->dev_lock);
+	init_waitqueue_head(&cam->smbus_wait);
+	mcam->plat_power_up = cafe_ctlr_power_up;
+	mcam->plat_power_down = cafe_ctlr_power_down;
+	mcam->dev = &pdev->dev;
+	/*
+	 * Get set up on the PCI bus.
+	 */
+	ret = pci_enable_device(pdev);
+	if (ret)
+		goto out_free;
+	pci_set_master(pdev);
+
+	ret = -EIO;
+	mcam->regs = pci_iomap(pdev, 0, 0);
+	if (!mcam->regs) {
+		printk(KERN_ERR "Unable to ioremap cafe-ccic regs\n");
+		goto out_disable;
+	}
+	ret = request_irq(pdev->irq, cafe_irq, IRQF_SHARED, "cafe-ccic", cam);
+	if (ret)
+		goto out_iounmap;
+
+	/*
+	 * Initialize the controller and leave it powered up.  It will
+	 * stay that way until the sensor driver shows up.
+	 */
+	cafe_ctlr_init(mcam);
+	cafe_ctlr_power_up(mcam);
+	/*
+	 * Set up I2C/SMBUS communications.  We have to drop the mutex here
+	 * because the sensor could attach in this call chain, leading to
+	 * unsightly deadlocks.
+	 */
+	ret = cafe_smbus_setup(cam);
+	if (ret)
+		goto out_pdown;
+
+	ret = mccic_register(mcam);
+	if (ret == 0) {
+		cam->registered = 1;
+		return 0;
+	}
+
+	cafe_smbus_shutdown(cam);
+out_pdown:
+	cafe_ctlr_power_down(mcam);
+	free_irq(pdev->irq, cam);
+out_iounmap:
+	pci_iounmap(pdev, mcam->regs);
+out_disable:
+	pci_disable_device(pdev);
+out_free:
+	kfree(cam);
+out:
+	return ret;
+}
+
+
+/*
+ * Shut down an initialized device
+ */
+static void cafe_shutdown(struct cafe_camera *cam)
+{
+	mccic_shutdown(&cam->mcam);
+	cafe_smbus_shutdown(cam);
+	free_irq(cam->pdev->irq, cam);
+	pci_iounmap(cam->pdev, cam->mcam.regs);
+}
+
+
+static void cafe_pci_remove(struct pci_dev *pdev)
+{
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(&pdev->dev);
+	struct cafe_camera *cam = to_cam(v4l2_dev);
+
+	if (cam == NULL) {
+		printk(KERN_WARNING "pci_remove on unknown pdev %p\n", pdev);
+		return;
+	}
+	cafe_shutdown(cam);
+	kfree(cam);
+}
+
+
+#ifdef CONFIG_PM
+/*
+ * Basic power management.
+ */
+static int cafe_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(&pdev->dev);
+	struct cafe_camera *cam = to_cam(v4l2_dev);
+	int ret;
+
+	ret = pci_save_state(pdev);
+	if (ret)
+		return ret;
+	mccic_suspend(&cam->mcam);
+	pci_disable_device(pdev);
+	return 0;
+}
+
+
+static int cafe_pci_resume(struct pci_dev *pdev)
+{
+	struct v4l2_device *v4l2_dev = dev_get_drvdata(&pdev->dev);
+	struct cafe_camera *cam = to_cam(v4l2_dev);
+	int ret = 0;
+
+	pci_restore_state(pdev);
+	ret = pci_enable_device(pdev);
+
+	if (ret) {
+		cam_warn(cam, "Unable to re-enable device on resume!\n");
+		return ret;
+	}
+	cafe_ctlr_init(&cam->mcam);
+	return mccic_resume(&cam->mcam);
+}
+
+#endif  /* CONFIG_PM */
+
+static struct pci_device_id cafe_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL,
+		     PCI_DEVICE_ID_MARVELL_88ALP01_CCIC) },
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, cafe_ids);
+
+static struct pci_driver cafe_pci_driver = {
+	.name = "cafe1000-ccic",
+	.id_table = cafe_ids,
+	.probe = cafe_pci_probe,
+	.remove = cafe_pci_remove,
+#ifdef CONFIG_PM
+	.suspend = cafe_pci_suspend,
+	.resume = cafe_pci_resume,
+#endif
+};
+
+
+
+
+static int __init cafe_init(void)
+{
+	int ret;
+
+	printk(KERN_NOTICE "Marvell M88ALP01 'CAFE' Camera Controller version %d\n",
+			CAFE_VERSION);
+	ret = pci_register_driver(&cafe_pci_driver);
+	if (ret) {
+		printk(KERN_ERR "Unable to register cafe_ccic driver\n");
+		goto out;
+	}
+	ret = 0;
+
+out:
+	return ret;
+}
+
+
+static void __exit cafe_exit(void)
+{
+	pci_unregister_driver(&cafe_pci_driver);
+}
+
+module_init(cafe_init);
+module_exit(cafe_exit);
diff --git a/drivers/media/video/marvell-ccic/cafe_ccic-regs.h b/drivers/media/video/marvell-ccic/cafe_ccic-regs.h
deleted file mode 100644
index 8e2a87c..0000000
--- a/drivers/media/video/marvell-ccic/cafe_ccic-regs.h
+++ /dev/null
@@ -1,166 +0,0 @@
-/*
- * Register definitions for the m88alp01 camera interface.  Offsets in bytes
- * as given in the spec.
- *
- * Copyright 2006 One Laptop Per Child Association, Inc.
- *
- * Written by Jonathan Corbet, corbet@lwn.net.
- *
- * This file may be distributed under the terms of the GNU General
- * Public License, version 2.
- */
-#define REG_Y0BAR	0x00
-#define REG_Y1BAR	0x04
-#define REG_Y2BAR	0x08
-/* ... */
-
-#define REG_IMGPITCH	0x24	/* Image pitch register */
-#define   IMGP_YP_SHFT	  2		/* Y pitch params */
-#define   IMGP_YP_MASK	  0x00003ffc	/* Y pitch field */
-#define	  IMGP_UVP_SHFT	  18		/* UV pitch (planar) */
-#define   IMGP_UVP_MASK   0x3ffc0000
-#define REG_IRQSTATRAW	0x28	/* RAW IRQ Status */
-#define   IRQ_EOF0	  0x00000001	/* End of frame 0 */
-#define   IRQ_EOF1	  0x00000002	/* End of frame 1 */
-#define   IRQ_EOF2	  0x00000004	/* End of frame 2 */
-#define   IRQ_SOF0	  0x00000008	/* Start of frame 0 */
-#define   IRQ_SOF1	  0x00000010	/* Start of frame 1 */
-#define   IRQ_SOF2	  0x00000020	/* Start of frame 2 */
-#define   IRQ_OVERFLOW	  0x00000040	/* FIFO overflow */
-#define   IRQ_TWSIW	  0x00010000	/* TWSI (smbus) write */
-#define   IRQ_TWSIR	  0x00020000	/* TWSI read */
-#define   IRQ_TWSIE	  0x00040000	/* TWSI error */
-#define   TWSIIRQS (IRQ_TWSIW|IRQ_TWSIR|IRQ_TWSIE)
-#define   FRAMEIRQS (IRQ_EOF0|IRQ_EOF1|IRQ_EOF2|IRQ_SOF0|IRQ_SOF1|IRQ_SOF2)
-#define   ALLIRQS (TWSIIRQS|FRAMEIRQS|IRQ_OVERFLOW)
-#define REG_IRQMASK	0x2c	/* IRQ mask - same bits as IRQSTAT */
-#define REG_IRQSTAT	0x30	/* IRQ status / clear */
-
-#define REG_IMGSIZE	0x34	/* Image size */
-#define  IMGSZ_V_MASK	  0x1fff0000
-#define  IMGSZ_V_SHIFT	  16
-#define	 IMGSZ_H_MASK	  0x00003fff
-#define REG_IMGOFFSET	0x38	/* IMage offset */
-
-#define REG_CTRL0	0x3c	/* Control 0 */
-#define   C0_ENABLE	  0x00000001	/* Makes the whole thing go */
-
-/* Mask for all the format bits */
-#define   C0_DF_MASK	  0x00fffffc    /* Bits 2-23 */
-
-/* RGB ordering */
-#define   C0_RGB4_RGBX	  0x00000000
-#define	  C0_RGB4_XRGB	  0x00000004
-#define	  C0_RGB4_BGRX	  0x00000008
-#define   C0_RGB4_XBGR	  0x0000000c
-#define   C0_RGB5_RGGB	  0x00000000
-#define	  C0_RGB5_GRBG	  0x00000004
-#define	  C0_RGB5_GBRG	  0x00000008
-#define   C0_RGB5_BGGR	  0x0000000c
-
-/* Spec has two fields for DIN and DOUT, but they must match, so
-   combine them here. */
-#define   C0_DF_YUV	  0x00000000    /* Data is YUV	    */
-#define   C0_DF_RGB	  0x000000a0	/* ... RGB		    */
-#define   C0_DF_BAYER     0x00000140	/* ... Bayer                */
-/* 8-8-8 must be missing from the below - ask */
-#define   C0_RGBF_565	  0x00000000
-#define   C0_RGBF_444	  0x00000800
-#define   C0_RGB_BGR	  0x00001000	/* Blue comes first */
-#define   C0_YUV_PLANAR	  0x00000000	/* YUV 422 planar format */
-#define   C0_YUV_PACKED	  0x00008000	/* YUV 422 packed	*/
-#define   C0_YUV_420PL	  0x0000a000	/* YUV 420 planar	*/
-/* Think that 420 packed must be 111 - ask */
-#define	  C0_YUVE_YUYV	  0x00000000	/* Y1CbY0Cr 		*/
-#define	  C0_YUVE_YVYU	  0x00010000	/* Y1CrY0Cb 		*/
-#define	  C0_YUVE_VYUY	  0x00020000	/* CrY1CbY0 		*/
-#define	  C0_YUVE_UYVY	  0x00030000	/* CbY1CrY0 		*/
-#define   C0_YUVE_XYUV	  0x00000000    /* 420: .YUV		*/
-#define	  C0_YUVE_XYVU	  0x00010000	/* 420: .YVU 		*/
-#define	  C0_YUVE_XUVY	  0x00020000	/* 420: .UVY 		*/
-#define	  C0_YUVE_XVUY	  0x00030000	/* 420: .VUY 		*/
-/* Bayer bits 18,19 if needed */
-#define   C0_HPOL_LOW	  0x01000000	/* HSYNC polarity active low */
-#define   C0_VPOL_LOW	  0x02000000	/* VSYNC polarity active low */
-#define   C0_VCLK_LOW	  0x04000000	/* VCLK on falling edge */
-#define   C0_DOWNSCALE	  0x08000000	/* Enable downscaler */
-#define	  C0_SIFM_MASK	  0xc0000000	/* SIF mode bits */
-#define   C0_SIF_HVSYNC	  0x00000000	/* Use H/VSYNC */
-#define   CO_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
-
-
-#define REG_CTRL1	0x40	/* Control 1 */
-#define   C1_444ALPHA	  0x00f00000	/* Alpha field in RGB444 */
-#define   C1_ALPHA_SHFT	  20
-#define   C1_DMAB32	  0x00000000	/* 32-byte DMA burst */
-#define   C1_DMAB16	  0x02000000	/* 16-byte DMA burst */
-#define	  C1_DMAB64	  0x04000000	/* 64-byte DMA burst */
-#define	  C1_DMAB_MASK	  0x06000000
-#define   C1_TWOBUFS	  0x08000000	/* Use only two DMA buffers */
-#define   C1_PWRDWN	  0x10000000	/* Power down */
-
-#define REG_CLKCTRL	0x88	/* Clock control */
-#define   CLK_DIV_MASK	  0x0000ffff	/* Upper bits RW "reserved" */
-
-#define REG_GPR		0xb4	/* General purpose register.  This
-				   controls inputs to the power and reset
-				   pins on the OV7670 used with OLPC;
-				   other deployments could differ.  */
-#define   GPR_C1EN	  0x00000020	/* Pad 1 (power down) enable */
-#define   GPR_C0EN	  0x00000010	/* Pad 0 (reset) enable */
-#define	  GPR_C1	  0x00000002	/* Control 1 value */
-/*
- * Control 0 is wired to reset on OLPC machines.  For ov7x sensors,
- * it is active low, for 0v6x, instead, it's active high.  What
- * fun.
- */
-#define   GPR_C0	  0x00000001	/* Control 0 value */
-
-#define REG_TWSIC0	0xb8	/* TWSI (smbus) control 0 */
-#define   TWSIC0_EN       0x00000001	/* TWSI enable */
-#define   TWSIC0_MODE	  0x00000002	/* 1 = 16-bit, 0 = 8-bit */
-#define   TWSIC0_SID	  0x000003fc	/* Slave ID */
-#define   TWSIC0_SID_SHIFT 2
-#define   TWSIC0_CLKDIV   0x0007fc00	/* Clock divider */
-#define   TWSIC0_MASKACK  0x00400000	/* Mask ack from sensor */
-#define   TWSIC0_OVMAGIC  0x00800000	/* Make it work on OV sensors */
-
-#define REG_TWSIC1	0xbc	/* TWSI control 1 */
-#define   TWSIC1_DATA	  0x0000ffff	/* Data to/from camchip */
-#define   TWSIC1_ADDR	  0x00ff0000	/* Address (register) */
-#define   TWSIC1_ADDR_SHIFT 16
-#define   TWSIC1_READ	  0x01000000	/* Set for read op */
-#define   TWSIC1_WSTAT	  0x02000000	/* Write status */
-#define   TWSIC1_RVALID	  0x04000000	/* Read data valid */
-#define   TWSIC1_ERROR	  0x08000000	/* Something screwed up */
-
-
-#define REG_UBAR	0xc4	/* Upper base address register */
-
-/*
- * Here's the weird global control registers which are said to live
- * way up here.
- */
-#define REG_GL_CSR     0x3004  /* Control/status register */
-#define   GCSR_SRS	 0x00000001	/* SW Reset set */
-#define   GCSR_SRC  	 0x00000002	/* SW Reset clear */
-#define	  GCSR_MRS	 0x00000004	/* Master reset set */
-#define	  GCSR_MRC	 0x00000008	/* HW Reset clear */
-#define   GCSR_CCIC_EN   0x00004000    /* CCIC Clock enable */
-#define REG_GL_IMASK   0x300c  /* Interrupt mask register */
-#define   GIMSK_CCIC_EN          0x00000004    /* CCIC Interrupt enable */
-
-#define REG_GL_FCR	0x3038  /* GPIO functional control register */
-#define	  GFCR_GPIO_ON	  0x08		/* Camera GPIO enabled */
-#define REG_GL_GPIOR	0x315c	/* GPIO register */
-#define   GGPIO_OUT  		0x80000	/* GPIO output */
-#define   GGPIO_VAL  		0x00008	/* Output pin value */
-
-#define REG_LEN                REG_GL_IMASK + 4
-
-
-/*
- * Useful stuff that probably belongs somewhere global.
- */
-#define VGA_WIDTH	640
-#define VGA_HEIGHT	480
diff --git a/drivers/media/video/marvell-ccic/cafe_ccic.c b/drivers/media/video/marvell-ccic/cafe_ccic.c
deleted file mode 100644
index 809964b..0000000
--- a/drivers/media/video/marvell-ccic/cafe_ccic.c
+++ /dev/null
@@ -1,2267 +0,0 @@
-/*
- * A driver for the CMOS camera controller in the Marvell 88ALP01 "cafe"
- * multifunction chip.  Currently works with the Omnivision OV7670
- * sensor.
- *
- * The data sheet for this device can be found at:
- *    http://www.marvell.com/products/pc_connectivity/88alp01/ 
- *
- * Copyright 2006 One Laptop Per Child Association, Inc.
- * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
- *
- * Written by Jonathan Corbet, corbet@lwn.net.
- *
- * v4l2_device/v4l2_subdev conversion by:
- * Copyright (C) 2009 Hans Verkuil <hverkuil@xs4all.nl>
- *
- * Note: this conversion is untested! Please contact the linux-media
- * mailinglist if you can test this, together with the test results.
- *
- * This file may be distributed under the terms of the GNU General
- * Public License, version 2.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/fs.h>
-#include <linux/dmi.h>
-#include <linux/mm.h>
-#include <linux/pci.h>
-#include <linux/i2c.h>
-#include <linux/interrupt.h>
-#include <linux/spinlock.h>
-#include <linux/videodev2.h>
-#include <linux/slab.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-chip-ident.h>
-#include <media/ov7670.h>
-#include <linux/device.h>
-#include <linux/wait.h>
-#include <linux/list.h>
-#include <linux/dma-mapping.h>
-#include <linux/delay.h>
-#include <linux/jiffies.h>
-#include <linux/vmalloc.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
-
-#include "cafe_ccic-regs.h"
-
-#define CAFE_VERSION 0x000002
-
-
-/*
- * Parameters.
- */
-MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
-MODULE_DESCRIPTION("Marvell 88ALP01 CMOS Camera Controller driver");
-MODULE_LICENSE("GPL");
-MODULE_SUPPORTED_DEVICE("Video");
-
-/*
- * Internal DMA buffer management.  Since the controller cannot do S/G I/O,
- * we must have physically contiguous buffers to bring frames into.
- * These parameters control how many buffers we use, whether we
- * allocate them at load time (better chance of success, but nails down
- * memory) or when somebody tries to use the camera (riskier), and,
- * for load-time allocation, how big they should be.
- *
- * The controller can cycle through three buffers.  We could use
- * more by flipping pointers around, but it probably makes little
- * sense.
- */
-
-#define MAX_DMA_BUFS 3
-static int alloc_bufs_at_read;
-module_param(alloc_bufs_at_read, bool, 0444);
-MODULE_PARM_DESC(alloc_bufs_at_read,
-		"Non-zero value causes DMA buffers to be allocated when the "
-		"video capture device is read, rather than at module load "
-		"time.  This saves memory, but decreases the chances of "
-		"successfully getting those buffers.");
-
-static int n_dma_bufs = 3;
-module_param(n_dma_bufs, uint, 0644);
-MODULE_PARM_DESC(n_dma_bufs,
-		"The number of DMA buffers to allocate.  Can be either two "
-		"(saves memory, makes timing tighter) or three.");
-
-static int dma_buf_size = VGA_WIDTH * VGA_HEIGHT * 2;  /* Worst case */
-module_param(dma_buf_size, uint, 0444);
-MODULE_PARM_DESC(dma_buf_size,
-		"The size of the allocated DMA buffers.  If actual operating "
-		"parameters require larger buffers, an attempt to reallocate "
-		"will be made.");
-
-static int min_buffers = 1;
-module_param(min_buffers, uint, 0644);
-MODULE_PARM_DESC(min_buffers,
-		"The minimum number of streaming I/O buffers we are willing "
-		"to work with.");
-
-static int max_buffers = 10;
-module_param(max_buffers, uint, 0644);
-MODULE_PARM_DESC(max_buffers,
-		"The maximum number of streaming I/O buffers an application "
-		"will be allowed to allocate.  These buffers are big and live "
-		"in vmalloc space.");
-
-static int flip;
-module_param(flip, bool, 0444);
-MODULE_PARM_DESC(flip,
-		"If set, the sensor will be instructed to flip the image "
-		"vertically.");
-
-
-enum cafe_state {
-	S_NOTREADY,	/* Not yet initialized */
-	S_IDLE,		/* Just hanging around */
-	S_FLAKED,	/* Some sort of problem */
-	S_SINGLEREAD,	/* In read() */
-	S_SPECREAD,   	/* Speculative read (for future read()) */
-	S_STREAMING	/* Streaming data */
-};
-
-/*
- * Tracking of streaming I/O buffers.
- */
-struct cafe_sio_buffer {
-	struct list_head list;
-	struct v4l2_buffer v4lbuf;
-	char *buffer;   /* Where it lives in kernel space */
-	int mapcount;
-	struct cafe_camera *cam;
-};
-
-/*
- * A description of one of our devices.
- * Locking: controlled by s_mutex.  Certain fields, however, require
- * 	    the dev_lock spinlock; they are marked as such by comments.
- *	    dev_lock is also required for access to device registers.
- */
-struct cafe_camera
-{
-	struct v4l2_device v4l2_dev;
-	enum cafe_state state;
-	unsigned long flags;   		/* Buffer status, mainly (dev_lock) */
-	int users;			/* How many open FDs */
-	struct file *owner;		/* Who has data access (v4l2) */
-
-	/*
-	 * Subsystem structures.
-	 */
-	struct pci_dev *pdev;
-	struct video_device vdev;
-	struct i2c_adapter i2c_adapter;
-	struct v4l2_subdev *sensor;
-	unsigned short sensor_addr;
-
-	unsigned char __iomem *regs;
-	struct list_head dev_list;	/* link to other devices */
-
-	/* DMA buffers */
-	unsigned int nbufs;		/* How many are alloc'd */
-	int next_buf;			/* Next to consume (dev_lock) */
-	unsigned int dma_buf_size;  	/* allocated size */
-	void *dma_bufs[MAX_DMA_BUFS];	/* Internal buffer addresses */
-	dma_addr_t dma_handles[MAX_DMA_BUFS]; /* Buffer bus addresses */
-	unsigned int specframes;	/* Unconsumed spec frames (dev_lock) */
-	unsigned int sequence;		/* Frame sequence number */
-	unsigned int buf_seq[MAX_DMA_BUFS]; /* Sequence for individual buffers */
-
-	/* Streaming buffers */
-	unsigned int n_sbufs;		/* How many we have */
-	struct cafe_sio_buffer *sb_bufs; /* The array of housekeeping structs */
-	struct list_head sb_avail;	/* Available for data (we own) (dev_lock) */
-	struct list_head sb_full;	/* With data (user space owns) (dev_lock) */
-	struct tasklet_struct s_tasklet;
-
-	/* Current operating parameters */
-	u32 sensor_type;		/* Currently ov7670 only */
-	struct v4l2_pix_format pix_format;
-	enum v4l2_mbus_pixelcode mbus_code;
-
-	/* Locks */
-	struct mutex s_mutex; /* Access to this structure */
-	spinlock_t dev_lock;  /* Access to device */
-
-	/* Misc */
-	wait_queue_head_t smbus_wait;	/* Waiting on i2c events */
-	wait_queue_head_t iowait;	/* Waiting on frame data */
-};
-
-/*
- * Status flags.  Always manipulated with bit operations.
- */
-#define CF_BUF0_VALID	 0	/* Buffers valid - first three */
-#define CF_BUF1_VALID	 1
-#define CF_BUF2_VALID	 2
-#define CF_DMA_ACTIVE	 3	/* A frame is incoming */
-#define CF_CONFIG_NEEDED 4	/* Must configure hardware */
-
-#define sensor_call(cam, o, f, args...) \
-	v4l2_subdev_call(cam->sensor, o, f, ##args)
-
-static inline struct cafe_camera *to_cam(struct v4l2_device *dev)
-{
-	return container_of(dev, struct cafe_camera, v4l2_dev);
-}
-
-static struct cafe_format_struct {
-	__u8 *desc;
-	__u32 pixelformat;
-	int bpp;   /* Bytes per pixel */
-	enum v4l2_mbus_pixelcode mbus_code;
-} cafe_formats[] = {
-	{
-		.desc		= "YUYV 4:2:2",
-		.pixelformat	= V4L2_PIX_FMT_YUYV,
-		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
-		.bpp		= 2,
-	},
-	{
-		.desc		= "RGB 444",
-		.pixelformat	= V4L2_PIX_FMT_RGB444,
-		.mbus_code	= V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
-		.bpp		= 2,
-	},
-	{
-		.desc		= "RGB 565",
-		.pixelformat	= V4L2_PIX_FMT_RGB565,
-		.mbus_code	= V4L2_MBUS_FMT_RGB565_2X8_LE,
-		.bpp		= 2,
-	},
-	{
-		.desc		= "Raw RGB Bayer",
-		.pixelformat	= V4L2_PIX_FMT_SBGGR8,
-		.mbus_code	= V4L2_MBUS_FMT_SBGGR8_1X8,
-		.bpp		= 1
-	},
-};
-#define N_CAFE_FMTS ARRAY_SIZE(cafe_formats)
-
-static struct cafe_format_struct *cafe_find_format(u32 pixelformat)
-{
-	unsigned i;
-
-	for (i = 0; i < N_CAFE_FMTS; i++)
-		if (cafe_formats[i].pixelformat == pixelformat)
-			return cafe_formats + i;
-	/* Not found? Then return the first format. */
-	return cafe_formats;
-}
-
-/*
- * Start over with DMA buffers - dev_lock needed.
- */
-static void cafe_reset_buffers(struct cafe_camera *cam)
-{
-	int i;
-
-	cam->next_buf = -1;
-	for (i = 0; i < cam->nbufs; i++)
-		clear_bit(i, &cam->flags);
-	cam->specframes = 0;
-}
-
-static inline int cafe_needs_config(struct cafe_camera *cam)
-{
-	return test_bit(CF_CONFIG_NEEDED, &cam->flags);
-}
-
-static void cafe_set_config_needed(struct cafe_camera *cam, int needed)
-{
-	if (needed)
-		set_bit(CF_CONFIG_NEEDED, &cam->flags);
-	else
-		clear_bit(CF_CONFIG_NEEDED, &cam->flags);
-}
-
-
-
-
-/*
- * Debugging and related.
- */
-#define cam_err(cam, fmt, arg...) \
-	dev_err(&(cam)->pdev->dev, fmt, ##arg);
-#define cam_warn(cam, fmt, arg...) \
-	dev_warn(&(cam)->pdev->dev, fmt, ##arg);
-#define cam_dbg(cam, fmt, arg...) \
-	dev_dbg(&(cam)->pdev->dev, fmt, ##arg);
-
-
-/* ---------------------------------------------------------------------*/
-
-/*
- * Device register I/O
- */
-static inline void cafe_reg_write(struct cafe_camera *cam, unsigned int reg,
-		unsigned int val)
-{
-	iowrite32(val, cam->regs + reg);
-}
-
-static inline unsigned int cafe_reg_read(struct cafe_camera *cam,
-		unsigned int reg)
-{
-	return ioread32(cam->regs + reg);
-}
-
-
-static inline void cafe_reg_write_mask(struct cafe_camera *cam, unsigned int reg,
-		unsigned int val, unsigned int mask)
-{
-	unsigned int v = cafe_reg_read(cam, reg);
-
-	v = (v & ~mask) | (val & mask);
-	cafe_reg_write(cam, reg, v);
-}
-
-static inline void cafe_reg_clear_bit(struct cafe_camera *cam,
-		unsigned int reg, unsigned int val)
-{
-	cafe_reg_write_mask(cam, reg, 0, val);
-}
-
-static inline void cafe_reg_set_bit(struct cafe_camera *cam,
-		unsigned int reg, unsigned int val)
-{
-	cafe_reg_write_mask(cam, reg, val, val);
-}
-
-
-
-/* -------------------------------------------------------------------- */
-/*
- * The I2C/SMBUS interface to the camera itself starts here.  The
- * controller handles SMBUS itself, presenting a relatively simple register
- * interface; all we have to do is to tell it where to route the data.
- */
-#define CAFE_SMBUS_TIMEOUT (HZ)  /* generous */
-
-static int cafe_smbus_write_done(struct cafe_camera *cam)
-{
-	unsigned long flags;
-	int c1;
-
-	/*
-	 * We must delay after the interrupt, or the controller gets confused
-	 * and never does give us good status.  Fortunately, we don't do this
-	 * often.
-	 */
-	udelay(20);
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	c1 = cafe_reg_read(cam, REG_TWSIC1);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	return (c1 & (TWSIC1_WSTAT|TWSIC1_ERROR)) != TWSIC1_WSTAT;
-}
-
-static int cafe_smbus_write_data(struct cafe_camera *cam,
-		u16 addr, u8 command, u8 value)
-{
-	unsigned int rval;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	rval = TWSIC0_EN | ((addr << TWSIC0_SID_SHIFT) & TWSIC0_SID);
-	rval |= TWSIC0_OVMAGIC;  /* Make OV sensors work */
-	/*
-	 * Marvell sez set clkdiv to all 1's for now.
-	 */
-	rval |= TWSIC0_CLKDIV;
-	cafe_reg_write(cam, REG_TWSIC0, rval);
-	(void) cafe_reg_read(cam, REG_TWSIC1); /* force write */
-	rval = value | ((command << TWSIC1_ADDR_SHIFT) & TWSIC1_ADDR);
-	cafe_reg_write(cam, REG_TWSIC1, rval);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-
-	/* Unfortunately, reading TWSIC1 too soon after sending a command
-	 * causes the device to die.
-	 * Use a busy-wait because we often send a large quantity of small
-	 * commands at-once; using msleep() would cause a lot of context
-	 * switches which take longer than 2ms, resulting in a noticeable
-	 * boot-time and capture-start delays.
-	 */
-	mdelay(2);
-
-	/*
-	 * Another sad fact is that sometimes, commands silently complete but
-	 * cafe_smbus_write_done() never becomes aware of this.
-	 * This happens at random and appears to possible occur with any
-	 * command.
-	 * We don't understand why this is. We work around this issue
-	 * with the timeout in the wait below, assuming that all commands
-	 * complete within the timeout.
-	 */
-	wait_event_timeout(cam->smbus_wait, cafe_smbus_write_done(cam),
-			CAFE_SMBUS_TIMEOUT);
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	rval = cafe_reg_read(cam, REG_TWSIC1);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-
-	if (rval & TWSIC1_WSTAT) {
-		cam_err(cam, "SMBUS write (%02x/%02x/%02x) timed out\n", addr,
-				command, value);
-		return -EIO;
-	}
-	if (rval & TWSIC1_ERROR) {
-		cam_err(cam, "SMBUS write (%02x/%02x/%02x) error\n", addr,
-				command, value);
-		return -EIO;
-	}
-	return 0;
-}
-
-
-
-static int cafe_smbus_read_done(struct cafe_camera *cam)
-{
-	unsigned long flags;
-	int c1;
-
-	/*
-	 * We must delay after the interrupt, or the controller gets confused
-	 * and never does give us good status.  Fortunately, we don't do this
-	 * often.
-	 */
-	udelay(20);
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	c1 = cafe_reg_read(cam, REG_TWSIC1);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	return c1 & (TWSIC1_RVALID|TWSIC1_ERROR);
-}
-
-
-
-static int cafe_smbus_read_data(struct cafe_camera *cam,
-		u16 addr, u8 command, u8 *value)
-{
-	unsigned int rval;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	rval = TWSIC0_EN | ((addr << TWSIC0_SID_SHIFT) & TWSIC0_SID);
-	rval |= TWSIC0_OVMAGIC; /* Make OV sensors work */
-	/*
-	 * Marvel sez set clkdiv to all 1's for now.
-	 */
-	rval |= TWSIC0_CLKDIV;
-	cafe_reg_write(cam, REG_TWSIC0, rval);
-	(void) cafe_reg_read(cam, REG_TWSIC1); /* force write */
-	rval = TWSIC1_READ | ((command << TWSIC1_ADDR_SHIFT) & TWSIC1_ADDR);
-	cafe_reg_write(cam, REG_TWSIC1, rval);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-
-	wait_event_timeout(cam->smbus_wait,
-			cafe_smbus_read_done(cam), CAFE_SMBUS_TIMEOUT);
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	rval = cafe_reg_read(cam, REG_TWSIC1);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-
-	if (rval & TWSIC1_ERROR) {
-		cam_err(cam, "SMBUS read (%02x/%02x) error\n", addr, command);
-		return -EIO;
-	}
-	if (! (rval & TWSIC1_RVALID)) {
-		cam_err(cam, "SMBUS read (%02x/%02x) timed out\n", addr,
-				command);
-		return -EIO;
-	}
-	*value = rval & 0xff;
-	return 0;
-}
-
-/*
- * Perform a transfer over SMBUS.  This thing is called under
- * the i2c bus lock, so we shouldn't race with ourselves...
- */
-static int cafe_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
-		unsigned short flags, char rw, u8 command,
-		int size, union i2c_smbus_data *data)
-{
-	struct v4l2_device *v4l2_dev = i2c_get_adapdata(adapter);
-	struct cafe_camera *cam = to_cam(v4l2_dev);
-	int ret = -EINVAL;
-
-	/*
-	 * This interface would appear to only do byte data ops.  OK
-	 * it can do word too, but the cam chip has no use for that.
-	 */
-	if (size != I2C_SMBUS_BYTE_DATA) {
-		cam_err(cam, "funky xfer size %d\n", size);
-		return -EINVAL;
-	}
-
-	if (rw == I2C_SMBUS_WRITE)
-		ret = cafe_smbus_write_data(cam, addr, command, data->byte);
-	else if (rw == I2C_SMBUS_READ)
-		ret = cafe_smbus_read_data(cam, addr, command, &data->byte);
-	return ret;
-}
-
-
-static void cafe_smbus_enable_irq(struct cafe_camera *cam)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	cafe_reg_set_bit(cam, REG_IRQMASK, TWSIIRQS);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-}
-
-static u32 cafe_smbus_func(struct i2c_adapter *adapter)
-{
-	return I2C_FUNC_SMBUS_READ_BYTE_DATA  |
-	       I2C_FUNC_SMBUS_WRITE_BYTE_DATA;
-}
-
-static struct i2c_algorithm cafe_smbus_algo = {
-	.smbus_xfer = cafe_smbus_xfer,
-	.functionality = cafe_smbus_func
-};
-
-/* Somebody is on the bus */
-static void cafe_ctlr_stop_dma(struct cafe_camera *cam);
-static void cafe_ctlr_power_down(struct cafe_camera *cam);
-
-static int cafe_smbus_setup(struct cafe_camera *cam)
-{
-	struct i2c_adapter *adap = &cam->i2c_adapter;
-	int ret;
-
-	cafe_smbus_enable_irq(cam);
-	adap->owner = THIS_MODULE;
-	adap->algo = &cafe_smbus_algo;
-	strcpy(adap->name, "cafe_ccic");
-	adap->dev.parent = &cam->pdev->dev;
-	i2c_set_adapdata(adap, &cam->v4l2_dev);
-	ret = i2c_add_adapter(adap);
-	if (ret)
-		printk(KERN_ERR "Unable to register cafe i2c adapter\n");
-	return ret;
-}
-
-static void cafe_smbus_shutdown(struct cafe_camera *cam)
-{
-	i2c_del_adapter(&cam->i2c_adapter);
-}
-
-
-/* ------------------------------------------------------------------- */
-/*
- * Deal with the controller.
- */
-
-/*
- * Do everything we think we need to have the interface operating
- * according to the desired format.
- */
-static void cafe_ctlr_dma(struct cafe_camera *cam)
-{
-	/*
-	 * Store the first two Y buffers (we aren't supporting
-	 * planar formats for now, so no UV bufs).  Then either
-	 * set the third if it exists, or tell the controller
-	 * to just use two.
-	 */
-	cafe_reg_write(cam, REG_Y0BAR, cam->dma_handles[0]);
-	cafe_reg_write(cam, REG_Y1BAR, cam->dma_handles[1]);
-	if (cam->nbufs > 2) {
-		cafe_reg_write(cam, REG_Y2BAR, cam->dma_handles[2]);
-		cafe_reg_clear_bit(cam, REG_CTRL1, C1_TWOBUFS);
-	}
-	else
-		cafe_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
-	cafe_reg_write(cam, REG_UBAR, 0); /* 32 bits only for now */
-}
-
-static void cafe_ctlr_image(struct cafe_camera *cam)
-{
-	int imgsz;
-	struct v4l2_pix_format *fmt = &cam->pix_format;
-
-	imgsz = ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
-		(fmt->bytesperline & IMGSZ_H_MASK);
-	cafe_reg_write(cam, REG_IMGSIZE, imgsz);
-	cafe_reg_write(cam, REG_IMGOFFSET, 0);
-	/* YPITCH just drops the last two bits */
-	cafe_reg_write_mask(cam, REG_IMGPITCH, fmt->bytesperline,
-			IMGP_YP_MASK);
-	/*
-	 * Tell the controller about the image format we are using.
-	 */
-	switch (cam->pix_format.pixelformat) {
-	case V4L2_PIX_FMT_YUYV:
-	    cafe_reg_write_mask(cam, REG_CTRL0,
-			    C0_DF_YUV|C0_YUV_PACKED|C0_YUVE_YUYV,
-			    C0_DF_MASK);
-	    break;
-
-	case V4L2_PIX_FMT_RGB444:
-	    cafe_reg_write_mask(cam, REG_CTRL0,
-			    C0_DF_RGB|C0_RGBF_444|C0_RGB4_XRGB,
-			    C0_DF_MASK);
-		/* Alpha value? */
-	    break;
-
-	case V4L2_PIX_FMT_RGB565:
-	    cafe_reg_write_mask(cam, REG_CTRL0,
-			    C0_DF_RGB|C0_RGBF_565|C0_RGB5_BGGR,
-			    C0_DF_MASK);
-	    break;
-
-	default:
-	    cam_err(cam, "Unknown format %x\n", cam->pix_format.pixelformat);
-	    break;
-	}
-	/*
-	 * Make sure it knows we want to use hsync/vsync.
-	 */
-	cafe_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
-			C0_SIFM_MASK);
-}
-
-
-/*
- * Configure the controller for operation; caller holds the
- * device mutex.
- */
-static int cafe_ctlr_configure(struct cafe_camera *cam)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	cafe_ctlr_dma(cam);
-	cafe_ctlr_image(cam);
-	cafe_set_config_needed(cam, 0);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	return 0;
-}
-
-static void cafe_ctlr_irq_enable(struct cafe_camera *cam)
-{
-	/*
-	 * Clear any pending interrupts, since we do not
-	 * expect to have I/O active prior to enabling.
-	 */
-	cafe_reg_write(cam, REG_IRQSTAT, FRAMEIRQS);
-	cafe_reg_set_bit(cam, REG_IRQMASK, FRAMEIRQS);
-}
-
-static void cafe_ctlr_irq_disable(struct cafe_camera *cam)
-{
-	cafe_reg_clear_bit(cam, REG_IRQMASK, FRAMEIRQS);
-}
-
-/*
- * Make the controller start grabbing images.  Everything must
- * be set up before doing this.
- */
-static void cafe_ctlr_start(struct cafe_camera *cam)
-{
-	/* set_bit performs a read, so no other barrier should be
-	   needed here */
-	cafe_reg_set_bit(cam, REG_CTRL0, C0_ENABLE);
-}
-
-static void cafe_ctlr_stop(struct cafe_camera *cam)
-{
-	cafe_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
-}
-
-static void cafe_ctlr_init(struct cafe_camera *cam)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	/*
-	 * Added magic to bring up the hardware on the B-Test board
-	 */
-	cafe_reg_write(cam, 0x3038, 0x8);
-	cafe_reg_write(cam, 0x315c, 0x80008);
-	/*
-	 * Go through the dance needed to wake the device up.
-	 * Note that these registers are global and shared
-	 * with the NAND and SD devices.  Interaction between the
-	 * three still needs to be examined.
-	 */
-	cafe_reg_write(cam, REG_GL_CSR, GCSR_SRS|GCSR_MRS); /* Needed? */
-	cafe_reg_write(cam, REG_GL_CSR, GCSR_SRC|GCSR_MRC);
-	cafe_reg_write(cam, REG_GL_CSR, GCSR_SRC|GCSR_MRS);
-	/*
-	 * Here we must wait a bit for the controller to come around.
-	 */
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	msleep(5);
-	spin_lock_irqsave(&cam->dev_lock, flags);
-
-	cafe_reg_write(cam, REG_GL_CSR, GCSR_CCIC_EN|GCSR_SRC|GCSR_MRC);
-	cafe_reg_set_bit(cam, REG_GL_IMASK, GIMSK_CCIC_EN);
-	/*
-	 * Make sure it's not powered down.
-	 */
-	cafe_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
-	/*
-	 * Turn off the enable bit.  It sure should be off anyway,
-	 * but it's good to be sure.
-	 */
-	cafe_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
-	/*
-	 * Mask all interrupts.
-	 */
-	cafe_reg_write(cam, REG_IRQMASK, 0);
-	/*
-	 * Clock the sensor appropriately.  Controller clock should
-	 * be 48MHz, sensor "typical" value is half that.
-	 */
-	cafe_reg_write_mask(cam, REG_CLKCTRL, 2, CLK_DIV_MASK);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-}
-
-
-/*
- * Stop the controller, and don't return until we're really sure that no
- * further DMA is going on.
- */
-static void cafe_ctlr_stop_dma(struct cafe_camera *cam)
-{
-	unsigned long flags;
-
-	/*
-	 * Theory: stop the camera controller (whether it is operating
-	 * or not).  Delay briefly just in case we race with the SOF
-	 * interrupt, then wait until no DMA is active.
-	 */
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	cafe_ctlr_stop(cam);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	mdelay(1);
-	wait_event_timeout(cam->iowait,
-			!test_bit(CF_DMA_ACTIVE, &cam->flags), HZ);
-	if (test_bit(CF_DMA_ACTIVE, &cam->flags))
-		cam_err(cam, "Timeout waiting for DMA to end\n");
-		/* This would be bad news - what now? */
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	cam->state = S_IDLE;
-	cafe_ctlr_irq_disable(cam);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-}
-
-/*
- * Power up and down.
- */
-static void cafe_ctlr_power_up(struct cafe_camera *cam)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	cafe_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
-	/*
-	 * Part one of the sensor dance: turn the global
-	 * GPIO signal on.
-	 */
-	cafe_reg_write(cam, REG_GL_FCR, GFCR_GPIO_ON);
-	cafe_reg_write(cam, REG_GL_GPIOR, GGPIO_OUT|GGPIO_VAL);
-	/*
-	 * Put the sensor into operational mode (assumes OLPC-style
-	 * wiring).  Control 0 is reset - set to 1 to operate.
-	 * Control 1 is power down, set to 0 to operate.
-	 */
-	cafe_reg_write(cam, REG_GPR, GPR_C1EN|GPR_C0EN); /* pwr up, reset */
-/*	mdelay(1); */ /* Marvell says 1ms will do it */
-	cafe_reg_write(cam, REG_GPR, GPR_C1EN|GPR_C0EN|GPR_C0);
-/*	mdelay(1); */ /* Enough? */
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	msleep(5); /* Just to be sure */
-}
-
-static void cafe_ctlr_power_down(struct cafe_camera *cam)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	cafe_reg_write(cam, REG_GPR, GPR_C1EN|GPR_C0EN|GPR_C1);
-	cafe_reg_write(cam, REG_GL_FCR, GFCR_GPIO_ON);
-	cafe_reg_write(cam, REG_GL_GPIOR, GGPIO_OUT);
-	cafe_reg_set_bit(cam, REG_CTRL1, C1_PWRDWN);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-}
-
-/* -------------------------------------------------------------------- */
-/*
- * Communications with the sensor.
- */
-
-static int __cafe_cam_reset(struct cafe_camera *cam)
-{
-	return sensor_call(cam, core, reset, 0);
-}
-
-/*
- * We have found the sensor on the i2c.  Let's try to have a
- * conversation.
- */
-static int cafe_cam_init(struct cafe_camera *cam)
-{
-	struct v4l2_dbg_chip_ident chip;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	if (cam->state != S_NOTREADY)
-		cam_warn(cam, "Cam init with device in funky state %d",
-				cam->state);
-	ret = __cafe_cam_reset(cam);
-	if (ret)
-		goto out;
-	chip.ident = V4L2_IDENT_NONE;
-	chip.match.type = V4L2_CHIP_MATCH_I2C_ADDR;
-	chip.match.addr = cam->sensor_addr;
-	ret = sensor_call(cam, core, g_chip_ident, &chip);
-	if (ret)
-		goto out;
-	cam->sensor_type = chip.ident;
-	if (cam->sensor_type != V4L2_IDENT_OV7670) {
-		cam_err(cam, "Unsupported sensor type 0x%x", cam->sensor_type);
-		ret = -EINVAL;
-		goto out;
-	}
-/* Get/set parameters? */
-	ret = 0;
-	cam->state = S_IDLE;
-  out:
-	cafe_ctlr_power_down(cam);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-/*
- * Configure the sensor to match the parameters we have.  Caller should
- * hold s_mutex
- */
-static int cafe_cam_set_flip(struct cafe_camera *cam)
-{
-	struct v4l2_control ctrl;
-
-	memset(&ctrl, 0, sizeof(ctrl));
-	ctrl.id = V4L2_CID_VFLIP;
-	ctrl.value = flip;
-	return sensor_call(cam, core, s_ctrl, &ctrl);
-}
-
-
-static int cafe_cam_configure(struct cafe_camera *cam)
-{
-	struct v4l2_mbus_framefmt mbus_fmt;
-	int ret;
-
-	v4l2_fill_mbus_format(&mbus_fmt, &cam->pix_format, cam->mbus_code);
-	ret = sensor_call(cam, core, init, 0);
-	if (ret == 0)
-		ret = sensor_call(cam, video, s_mbus_fmt, &mbus_fmt);
-	/*
-	 * OV7670 does weird things if flip is set *before* format...
-	 */
-	ret += cafe_cam_set_flip(cam);
-	return ret;
-}
-
-/* -------------------------------------------------------------------- */
-/*
- * DMA buffer management.  These functions need s_mutex held.
- */
-
-/* FIXME: this is inefficient as hell, since dma_alloc_coherent just
- * does a get_free_pages() call, and we waste a good chunk of an orderN
- * allocation.  Should try to allocate the whole set in one chunk.
- */
-static int cafe_alloc_dma_bufs(struct cafe_camera *cam, int loadtime)
-{
-	int i;
-
-	cafe_set_config_needed(cam, 1);
-	if (loadtime)
-		cam->dma_buf_size = dma_buf_size;
-	else
-		cam->dma_buf_size = cam->pix_format.sizeimage;
-	if (n_dma_bufs > 3)
-		n_dma_bufs = 3;
-
-	cam->nbufs = 0;
-	for (i = 0; i < n_dma_bufs; i++) {
-		cam->dma_bufs[i] = dma_alloc_coherent(&cam->pdev->dev,
-				cam->dma_buf_size, cam->dma_handles + i,
-				GFP_KERNEL);
-		if (cam->dma_bufs[i] == NULL) {
-			cam_warn(cam, "Failed to allocate DMA buffer\n");
-			break;
-		}
-		/* For debug, remove eventually */
-		memset(cam->dma_bufs[i], 0xcc, cam->dma_buf_size);
-		(cam->nbufs)++;
-	}
-
-	switch (cam->nbufs) {
-	case 1:
-	    dma_free_coherent(&cam->pdev->dev, cam->dma_buf_size,
-			    cam->dma_bufs[0], cam->dma_handles[0]);
-	    cam->nbufs = 0;
-	case 0:
-	    cam_err(cam, "Insufficient DMA buffers, cannot operate\n");
-	    return -ENOMEM;
-
-	case 2:
-	    if (n_dma_bufs > 2)
-		    cam_warn(cam, "Will limp along with only 2 buffers\n");
-	    break;
-	}
-	return 0;
-}
-
-static void cafe_free_dma_bufs(struct cafe_camera *cam)
-{
-	int i;
-
-	for (i = 0; i < cam->nbufs; i++) {
-		dma_free_coherent(&cam->pdev->dev, cam->dma_buf_size,
-				cam->dma_bufs[i], cam->dma_handles[i]);
-		cam->dma_bufs[i] = NULL;
-	}
-	cam->nbufs = 0;
-}
-
-
-
-
-
-/* ----------------------------------------------------------------------- */
-/*
- * Here starts the V4L2 interface code.
- */
-
-/*
- * Read an image from the device.
- */
-static ssize_t cafe_deliver_buffer(struct cafe_camera *cam,
-		char __user *buffer, size_t len, loff_t *pos)
-{
-	int bufno;
-	unsigned long flags;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	if (cam->next_buf < 0) {
-		cam_err(cam, "deliver_buffer: No next buffer\n");
-		spin_unlock_irqrestore(&cam->dev_lock, flags);
-		return -EIO;
-	}
-	bufno = cam->next_buf;
-	clear_bit(bufno, &cam->flags);
-	if (++(cam->next_buf) >= cam->nbufs)
-		cam->next_buf = 0;
-	if (! test_bit(cam->next_buf, &cam->flags))
-		cam->next_buf = -1;
-	cam->specframes = 0;
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-
-	if (len > cam->pix_format.sizeimage)
-		len = cam->pix_format.sizeimage;
-	if (copy_to_user(buffer, cam->dma_bufs[bufno], len))
-		return -EFAULT;
-	(*pos) += len;
-	return len;
-}
-
-/*
- * Get everything ready, and start grabbing frames.
- */
-static int cafe_read_setup(struct cafe_camera *cam, enum cafe_state state)
-{
-	int ret;
-	unsigned long flags;
-
-	/*
-	 * Configuration.  If we still don't have DMA buffers,
-	 * make one last, desperate attempt.
-	 */
-	if (cam->nbufs == 0)
-		if (cafe_alloc_dma_bufs(cam, 0))
-			return -ENOMEM;
-
-	if (cafe_needs_config(cam)) {
-		cafe_cam_configure(cam);
-		ret = cafe_ctlr_configure(cam);
-		if (ret)
-			return ret;
-	}
-
-	/*
-	 * Turn it loose.
-	 */
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	cafe_reset_buffers(cam);
-	cafe_ctlr_irq_enable(cam);
-	cam->state = state;
-	cafe_ctlr_start(cam);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	return 0;
-}
-
-
-static ssize_t cafe_v4l_read(struct file *filp,
-		char __user *buffer, size_t len, loff_t *pos)
-{
-	struct cafe_camera *cam = filp->private_data;
-	int ret = 0;
-
-	/*
-	 * Perhaps we're in speculative read mode and already
-	 * have data?
-	 */
-	mutex_lock(&cam->s_mutex);
-	if (cam->state == S_SPECREAD) {
-		if (cam->next_buf >= 0) {
-			ret = cafe_deliver_buffer(cam, buffer, len, pos);
-			if (ret != 0)
-				goto out_unlock;
-		}
-	} else if (cam->state == S_FLAKED || cam->state == S_NOTREADY) {
-		ret = -EIO;
-		goto out_unlock;
-	} else if (cam->state != S_IDLE) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
-	/*
-	 * v4l2: multiple processes can open the device, but only
-	 * one gets to grab data from it.
-	 */
-	if (cam->owner && cam->owner != filp) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-	cam->owner = filp;
-
-	/*
-	 * Do setup if need be.
-	 */
-	if (cam->state != S_SPECREAD) {
-		ret = cafe_read_setup(cam, S_SINGLEREAD);
-		if (ret)
-			goto out_unlock;
-	}
-	/*
-	 * Wait for something to happen.  This should probably
-	 * be interruptible (FIXME).
-	 */
-	wait_event_timeout(cam->iowait, cam->next_buf >= 0, HZ);
-	if (cam->next_buf < 0) {
-		cam_err(cam, "read() operation timed out\n");
-		cafe_ctlr_stop_dma(cam);
-		ret = -EIO;
-		goto out_unlock;
-	}
-	/*
-	 * Give them their data and we should be done.
-	 */
-	ret = cafe_deliver_buffer(cam, buffer, len, pos);
-
-  out_unlock:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
-
-
-
-
-
-/*
- * Streaming I/O support.
- */
-
-
-
-static int cafe_vidioc_streamon(struct file *filp, void *priv,
-		enum v4l2_buf_type type)
-{
-	struct cafe_camera *cam = filp->private_data;
-	int ret = -EINVAL;
-
-	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		goto out;
-	mutex_lock(&cam->s_mutex);
-	if (cam->state != S_IDLE || cam->n_sbufs == 0)
-		goto out_unlock;
-
-	cam->sequence = 0;
-	ret = cafe_read_setup(cam, S_STREAMING);
-
-  out_unlock:
-	mutex_unlock(&cam->s_mutex);
-  out:
-	return ret;
-}
-
-
-static int cafe_vidioc_streamoff(struct file *filp, void *priv,
-		enum v4l2_buf_type type)
-{
-	struct cafe_camera *cam = filp->private_data;
-	int ret = -EINVAL;
-
-	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		goto out;
-	mutex_lock(&cam->s_mutex);
-	if (cam->state != S_STREAMING)
-		goto out_unlock;
-
-	cafe_ctlr_stop_dma(cam);
-	ret = 0;
-
-  out_unlock:
-	mutex_unlock(&cam->s_mutex);
-  out:
-	return ret;
-}
-
-
-
-static int cafe_setup_siobuf(struct cafe_camera *cam, int index)
-{
-	struct cafe_sio_buffer *buf = cam->sb_bufs + index;
-
-	INIT_LIST_HEAD(&buf->list);
-	buf->v4lbuf.length = PAGE_ALIGN(cam->pix_format.sizeimage);
-	buf->buffer = vmalloc_user(buf->v4lbuf.length);
-	if (buf->buffer == NULL)
-		return -ENOMEM;
-	buf->mapcount = 0;
-	buf->cam = cam;
-
-	buf->v4lbuf.index = index;
-	buf->v4lbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	buf->v4lbuf.field = V4L2_FIELD_NONE;
-	buf->v4lbuf.memory = V4L2_MEMORY_MMAP;
-	/*
-	 * Offset: must be 32-bit even on a 64-bit system.  videobuf-dma-sg
-	 * just uses the length times the index, but the spec warns
-	 * against doing just that - vma merging problems.  So we
-	 * leave a gap between each pair of buffers.
-	 */
-	buf->v4lbuf.m.offset = 2*index*buf->v4lbuf.length;
-	return 0;
-}
-
-static int cafe_free_sio_buffers(struct cafe_camera *cam)
-{
-	int i;
-
-	/*
-	 * If any buffers are mapped, we cannot free them at all.
-	 */
-	for (i = 0; i < cam->n_sbufs; i++)
-		if (cam->sb_bufs[i].mapcount > 0)
-			return -EBUSY;
-	/*
-	 * OK, let's do it.
-	 */
-	for (i = 0; i < cam->n_sbufs; i++)
-		vfree(cam->sb_bufs[i].buffer);
-	cam->n_sbufs = 0;
-	kfree(cam->sb_bufs);
-	cam->sb_bufs = NULL;
-	INIT_LIST_HEAD(&cam->sb_avail);
-	INIT_LIST_HEAD(&cam->sb_full);
-	return 0;
-}
-
-
-
-static int cafe_vidioc_reqbufs(struct file *filp, void *priv,
-		struct v4l2_requestbuffers *req)
-{
-	struct cafe_camera *cam = filp->private_data;
-	int ret = 0;  /* Silence warning */
-
-	/*
-	 * Make sure it's something we can do.  User pointers could be
-	 * implemented without great pain, but that's not been done yet.
-	 */
-	if (req->memory != V4L2_MEMORY_MMAP)
-		return -EINVAL;
-	/*
-	 * If they ask for zero buffers, they really want us to stop streaming
-	 * (if it's happening) and free everything.  Should we check owner?
-	 */
-	mutex_lock(&cam->s_mutex);
-	if (req->count == 0) {
-		if (cam->state == S_STREAMING)
-			cafe_ctlr_stop_dma(cam);
-		ret = cafe_free_sio_buffers (cam);
-		goto out;
-	}
-	/*
-	 * Device needs to be idle and working.  We *could* try to do the
-	 * right thing in S_SPECREAD by shutting things down, but it
-	 * probably doesn't matter.
-	 */
-	if (cam->state != S_IDLE || (cam->owner && cam->owner != filp)) {
-		ret = -EBUSY;
-		goto out;
-	}
-	cam->owner = filp;
-
-	if (req->count < min_buffers)
-		req->count = min_buffers;
-	else if (req->count > max_buffers)
-		req->count = max_buffers;
-	if (cam->n_sbufs > 0) {
-		ret = cafe_free_sio_buffers(cam);
-		if (ret)
-			goto out;
-	}
-
-	cam->sb_bufs = kzalloc(req->count*sizeof(struct cafe_sio_buffer),
-			GFP_KERNEL);
-	if (cam->sb_bufs == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	for (cam->n_sbufs = 0; cam->n_sbufs < req->count; (cam->n_sbufs++)) {
-		ret = cafe_setup_siobuf(cam, cam->n_sbufs);
-		if (ret)
-			break;
-	}
-
-	if (cam->n_sbufs == 0)  /* no luck at all - ret already set */
-		kfree(cam->sb_bufs);
-	req->count = cam->n_sbufs;  /* In case of partial success */
-
-  out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int cafe_vidioc_querybuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct cafe_camera *cam = filp->private_data;
-	int ret = -EINVAL;
-
-	mutex_lock(&cam->s_mutex);
-	if (buf->index >= cam->n_sbufs)
-		goto out;
-	*buf = cam->sb_bufs[buf->index].v4lbuf;
-	ret = 0;
-  out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int cafe_vidioc_qbuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct cafe_camera *cam = filp->private_data;
-	struct cafe_sio_buffer *sbuf;
-	int ret = -EINVAL;
-	unsigned long flags;
-
-	mutex_lock(&cam->s_mutex);
-	if (buf->index >= cam->n_sbufs)
-		goto out;
-	sbuf = cam->sb_bufs + buf->index;
-	if (sbuf->v4lbuf.flags & V4L2_BUF_FLAG_QUEUED) {
-		ret = 0; /* Already queued?? */
-		goto out;
-	}
-	if (sbuf->v4lbuf.flags & V4L2_BUF_FLAG_DONE) {
-		/* Spec doesn't say anything, seems appropriate tho */
-		ret = -EBUSY;
-		goto out;
-	}
-	sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_QUEUED;
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	list_add(&sbuf->list, &cam->sb_avail);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-	ret = 0;
-  out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int cafe_vidioc_dqbuf(struct file *filp, void *priv,
-		struct v4l2_buffer *buf)
-{
-	struct cafe_camera *cam = filp->private_data;
-	struct cafe_sio_buffer *sbuf;
-	int ret = -EINVAL;
-	unsigned long flags;
-
-	mutex_lock(&cam->s_mutex);
-	if (cam->state != S_STREAMING)
-		goto out_unlock;
-	if (list_empty(&cam->sb_full) && filp->f_flags & O_NONBLOCK) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
-	while (list_empty(&cam->sb_full) && cam->state == S_STREAMING) {
-		mutex_unlock(&cam->s_mutex);
-		if (wait_event_interruptible(cam->iowait,
-						!list_empty(&cam->sb_full))) {
-			ret = -ERESTARTSYS;
-			goto out;
-		}
-		mutex_lock(&cam->s_mutex);
-	}
-
-	if (cam->state != S_STREAMING)
-		ret = -EINTR;
-	else {
-		spin_lock_irqsave(&cam->dev_lock, flags);
-		/* Should probably recheck !list_empty() here */
-		sbuf = list_entry(cam->sb_full.next,
-				struct cafe_sio_buffer, list);
-		list_del_init(&sbuf->list);
-		spin_unlock_irqrestore(&cam->dev_lock, flags);
-		sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_DONE;
-		*buf = sbuf->v4lbuf;
-		ret = 0;
-	}
-
-  out_unlock:
-	mutex_unlock(&cam->s_mutex);
-  out:
-	return ret;
-}
-
-
-
-static void cafe_v4l_vm_open(struct vm_area_struct *vma)
-{
-	struct cafe_sio_buffer *sbuf = vma->vm_private_data;
-	/*
-	 * Locking: done under mmap_sem, so we don't need to
-	 * go back to the camera lock here.
-	 */
-	sbuf->mapcount++;
-}
-
-
-static void cafe_v4l_vm_close(struct vm_area_struct *vma)
-{
-	struct cafe_sio_buffer *sbuf = vma->vm_private_data;
-
-	mutex_lock(&sbuf->cam->s_mutex);
-	sbuf->mapcount--;
-	/* Docs say we should stop I/O too... */
-	if (sbuf->mapcount == 0)
-		sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_MAPPED;
-	mutex_unlock(&sbuf->cam->s_mutex);
-}
-
-static const struct vm_operations_struct cafe_v4l_vm_ops = {
-	.open = cafe_v4l_vm_open,
-	.close = cafe_v4l_vm_close
-};
-
-
-static int cafe_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
-{
-	struct cafe_camera *cam = filp->private_data;
-	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
-	int ret = -EINVAL;
-	int i;
-	struct cafe_sio_buffer *sbuf = NULL;
-
-	if (! (vma->vm_flags & VM_WRITE) || ! (vma->vm_flags & VM_SHARED))
-		return -EINVAL;
-	/*
-	 * Find the buffer they are looking for.
-	 */
-	mutex_lock(&cam->s_mutex);
-	for (i = 0; i < cam->n_sbufs; i++)
-		if (cam->sb_bufs[i].v4lbuf.m.offset == offset) {
-			sbuf = cam->sb_bufs + i;
-			break;
-		}
-	if (sbuf == NULL)
-		goto out;
-
-	ret = remap_vmalloc_range(vma, sbuf->buffer, 0);
-	if (ret)
-		goto out;
-	vma->vm_flags |= VM_DONTEXPAND;
-	vma->vm_private_data = sbuf;
-	vma->vm_ops = &cafe_v4l_vm_ops;
-	sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_MAPPED;
-	cafe_v4l_vm_open(vma);
-	ret = 0;
-  out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
-static int cafe_v4l_open(struct file *filp)
-{
-	struct cafe_camera *cam = video_drvdata(filp);
-
-	filp->private_data = cam;
-
-	mutex_lock(&cam->s_mutex);
-	if (cam->users == 0) {
-		cafe_ctlr_power_up(cam);
-		__cafe_cam_reset(cam);
-		cafe_set_config_needed(cam, 1);
-	/* FIXME make sure this is complete */
-	}
-	(cam->users)++;
-	mutex_unlock(&cam->s_mutex);
-	return 0;
-}
-
-
-static int cafe_v4l_release(struct file *filp)
-{
-	struct cafe_camera *cam = filp->private_data;
-
-	mutex_lock(&cam->s_mutex);
-	(cam->users)--;
-	if (filp == cam->owner) {
-		cafe_ctlr_stop_dma(cam);
-		cafe_free_sio_buffers(cam);
-		cam->owner = NULL;
-	}
-	if (cam->users == 0) {
-		cafe_ctlr_power_down(cam);
-		if (alloc_bufs_at_read)
-			cafe_free_dma_bufs(cam);
-	}
-	mutex_unlock(&cam->s_mutex);
-	return 0;
-}
-
-
-
-static unsigned int cafe_v4l_poll(struct file *filp,
-		struct poll_table_struct *pt)
-{
-	struct cafe_camera *cam = filp->private_data;
-
-	poll_wait(filp, &cam->iowait, pt);
-	if (cam->next_buf >= 0)
-		return POLLIN | POLLRDNORM;
-	return 0;
-}
-
-
-
-static int cafe_vidioc_queryctrl(struct file *filp, void *priv,
-		struct v4l2_queryctrl *qc)
-{
-	struct cafe_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, queryctrl, qc);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int cafe_vidioc_g_ctrl(struct file *filp, void *priv,
-		struct v4l2_control *ctrl)
-{
-	struct cafe_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, g_ctrl, ctrl);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-static int cafe_vidioc_s_ctrl(struct file *filp, void *priv,
-		struct v4l2_control *ctrl)
-{
-	struct cafe_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, core, s_ctrl, ctrl);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-
-
-
-
-static int cafe_vidioc_querycap(struct file *file, void *priv,
-		struct v4l2_capability *cap)
-{
-	strcpy(cap->driver, "cafe_ccic");
-	strcpy(cap->card, "cafe_ccic");
-	cap->version = CAFE_VERSION;
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
-	return 0;
-}
-
-
-/*
- * The default format we use until somebody says otherwise.
- */
-static const struct v4l2_pix_format cafe_def_pix_format = {
-	.width		= VGA_WIDTH,
-	.height		= VGA_HEIGHT,
-	.pixelformat	= V4L2_PIX_FMT_YUYV,
-	.field		= V4L2_FIELD_NONE,
-	.bytesperline	= VGA_WIDTH*2,
-	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
-};
-
-static const enum v4l2_mbus_pixelcode cafe_def_mbus_code =
-					V4L2_MBUS_FMT_YUYV8_2X8;
-
-static int cafe_vidioc_enum_fmt_vid_cap(struct file *filp,
-		void *priv, struct v4l2_fmtdesc *fmt)
-{
-	if (fmt->index >= N_CAFE_FMTS)
-		return -EINVAL;
-	strlcpy(fmt->description, cafe_formats[fmt->index].desc,
-			sizeof(fmt->description));
-	fmt->pixelformat = cafe_formats[fmt->index].pixelformat;
-	return 0;
-}
-
-static int cafe_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
-		struct v4l2_format *fmt)
-{
-	struct cafe_camera *cam = priv;
-	struct cafe_format_struct *f;
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-	struct v4l2_mbus_framefmt mbus_fmt;
-	int ret;
-
-	f = cafe_find_format(pix->pixelformat);
-	pix->pixelformat = f->pixelformat;
-	v4l2_fill_mbus_format(&mbus_fmt, pix, f->mbus_code);
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
-	mutex_unlock(&cam->s_mutex);
-	v4l2_fill_pix_format(pix, &mbus_fmt);
-	pix->bytesperline = pix->width * f->bpp;
-	pix->sizeimage = pix->height * pix->bytesperline;
-	return ret;
-}
-
-static int cafe_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
-		struct v4l2_format *fmt)
-{
-	struct cafe_camera *cam = priv;
-	struct cafe_format_struct *f;
-	int ret;
-
-	/*
-	 * Can't do anything if the device is not idle
-	 * Also can't if there are streaming buffers in place.
-	 */
-	if (cam->state != S_IDLE || cam->n_sbufs > 0)
-		return -EBUSY;
-
-	f = cafe_find_format(fmt->fmt.pix.pixelformat);
-
-	/*
-	 * See if the formatting works in principle.
-	 */
-	ret = cafe_vidioc_try_fmt_vid_cap(filp, priv, fmt);
-	if (ret)
-		return ret;
-	/*
-	 * Now we start to change things for real, so let's do it
-	 * under lock.
-	 */
-	mutex_lock(&cam->s_mutex);
-	cam->pix_format = fmt->fmt.pix;
-	cam->mbus_code = f->mbus_code;
-
-	/*
-	 * Make sure we have appropriate DMA buffers.
-	 */
-	ret = -ENOMEM;
-	if (cam->nbufs > 0 && cam->dma_buf_size < cam->pix_format.sizeimage)
-		cafe_free_dma_bufs(cam);
-	if (cam->nbufs == 0) {
-		if (cafe_alloc_dma_bufs(cam, 0))
-			goto out;
-	}
-	/*
-	 * It looks like this might work, so let's program the sensor.
-	 */
-	ret = cafe_cam_configure(cam);
-	if (! ret)
-		ret = cafe_ctlr_configure(cam);
-  out:
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-/*
- * Return our stored notion of how the camera is/should be configured.
- * The V4l2 spec wants us to be smarter, and actually get this from
- * the camera (and not mess with it at open time).  Someday.
- */
-static int cafe_vidioc_g_fmt_vid_cap(struct file *filp, void *priv,
-		struct v4l2_format *f)
-{
-	struct cafe_camera *cam = priv;
-
-	f->fmt.pix = cam->pix_format;
-	return 0;
-}
-
-/*
- * We only have one input - the sensor - so minimize the nonsense here.
- */
-static int cafe_vidioc_enum_input(struct file *filp, void *priv,
-		struct v4l2_input *input)
-{
-	if (input->index != 0)
-		return -EINVAL;
-
-	input->type = V4L2_INPUT_TYPE_CAMERA;
-	input->std = V4L2_STD_ALL; /* Not sure what should go here */
-	strcpy(input->name, "Camera");
-	return 0;
-}
-
-static int cafe_vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int cafe_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	if (i != 0)
-		return -EINVAL;
-	return 0;
-}
-
-/* from vivi.c */
-static int cafe_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id *a)
-{
-	return 0;
-}
-
-/*
- * G/S_PARM.  Most of this is done by the sensor, but we are
- * the level which controls the number of read buffers.
- */
-static int cafe_vidioc_g_parm(struct file *filp, void *priv,
-		struct v4l2_streamparm *parms)
-{
-	struct cafe_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, g_parm, parms);
-	mutex_unlock(&cam->s_mutex);
-	parms->parm.capture.readbuffers = n_dma_bufs;
-	return ret;
-}
-
-static int cafe_vidioc_s_parm(struct file *filp, void *priv,
-		struct v4l2_streamparm *parms)
-{
-	struct cafe_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, s_parm, parms);
-	mutex_unlock(&cam->s_mutex);
-	parms->parm.capture.readbuffers = n_dma_bufs;
-	return ret;
-}
-
-static int cafe_vidioc_g_chip_ident(struct file *file, void *priv,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	struct cafe_camera *cam = priv;
-
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (v4l2_chip_match_host(&chip->match)) {
-		chip->ident = V4L2_IDENT_CAFE;
-		return 0;
-	}
-	return sensor_call(cam, core, g_chip_ident, chip);
-}
-
-static int cafe_vidioc_enum_framesizes(struct file *filp, void *priv,
-		struct v4l2_frmsizeenum *sizes)
-{
-	struct cafe_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, enum_framesizes, sizes);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-static int cafe_vidioc_enum_frameintervals(struct file *filp, void *priv,
-		struct v4l2_frmivalenum *interval)
-{
-	struct cafe_camera *cam = priv;
-	int ret;
-
-	mutex_lock(&cam->s_mutex);
-	ret = sensor_call(cam, video, enum_frameintervals, interval);
-	mutex_unlock(&cam->s_mutex);
-	return ret;
-}
-
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int cafe_vidioc_g_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg)
-{
-	struct cafe_camera *cam = priv;
-
-	if (v4l2_chip_match_host(&reg->match)) {
-		reg->val = cafe_reg_read(cam, reg->reg);
-		reg->size = 4;
-		return 0;
-	}
-	return sensor_call(cam, core, g_register, reg);
-}
-
-static int cafe_vidioc_s_register(struct file *file, void *priv,
-		struct v4l2_dbg_register *reg)
-{
-	struct cafe_camera *cam = priv;
-
-	if (v4l2_chip_match_host(&reg->match)) {
-		cafe_reg_write(cam, reg->reg, reg->val);
-		return 0;
-	}
-	return sensor_call(cam, core, s_register, reg);
-}
-#endif
-
-/*
- * This template device holds all of those v4l2 methods; we
- * clone it for specific real devices.
- */
-
-static const struct v4l2_file_operations cafe_v4l_fops = {
-	.owner = THIS_MODULE,
-	.open = cafe_v4l_open,
-	.release = cafe_v4l_release,
-	.read = cafe_v4l_read,
-	.poll = cafe_v4l_poll,
-	.mmap = cafe_v4l_mmap,
-	.unlocked_ioctl = video_ioctl2,
-};
-
-static const struct v4l2_ioctl_ops cafe_v4l_ioctl_ops = {
-	.vidioc_querycap 	= cafe_vidioc_querycap,
-	.vidioc_enum_fmt_vid_cap = cafe_vidioc_enum_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap	= cafe_vidioc_try_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap	= cafe_vidioc_s_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap	= cafe_vidioc_g_fmt_vid_cap,
-	.vidioc_enum_input	= cafe_vidioc_enum_input,
-	.vidioc_g_input		= cafe_vidioc_g_input,
-	.vidioc_s_input		= cafe_vidioc_s_input,
-	.vidioc_s_std		= cafe_vidioc_s_std,
-	.vidioc_reqbufs		= cafe_vidioc_reqbufs,
-	.vidioc_querybuf	= cafe_vidioc_querybuf,
-	.vidioc_qbuf		= cafe_vidioc_qbuf,
-	.vidioc_dqbuf		= cafe_vidioc_dqbuf,
-	.vidioc_streamon	= cafe_vidioc_streamon,
-	.vidioc_streamoff	= cafe_vidioc_streamoff,
-	.vidioc_queryctrl	= cafe_vidioc_queryctrl,
-	.vidioc_g_ctrl		= cafe_vidioc_g_ctrl,
-	.vidioc_s_ctrl		= cafe_vidioc_s_ctrl,
-	.vidioc_g_parm		= cafe_vidioc_g_parm,
-	.vidioc_s_parm		= cafe_vidioc_s_parm,
-	.vidioc_enum_framesizes = cafe_vidioc_enum_framesizes,
-	.vidioc_enum_frameintervals = cafe_vidioc_enum_frameintervals,
-	.vidioc_g_chip_ident    = cafe_vidioc_g_chip_ident,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register 	= cafe_vidioc_g_register,
-	.vidioc_s_register 	= cafe_vidioc_s_register,
-#endif
-};
-
-static struct video_device cafe_v4l_template = {
-	.name = "cafe",
-	.tvnorms = V4L2_STD_NTSC_M,
-	.current_norm = V4L2_STD_NTSC_M,  /* make mplayer happy */
-
-	.fops = &cafe_v4l_fops,
-	.ioctl_ops = &cafe_v4l_ioctl_ops,
-	.release = video_device_release_empty,
-};
-
-
-/* ---------------------------------------------------------------------- */
-/*
- * Interrupt handler stuff
- */
-
-
-
-static void cafe_frame_tasklet(unsigned long data)
-{
-	struct cafe_camera *cam = (struct cafe_camera *) data;
-	int i;
-	unsigned long flags;
-	struct cafe_sio_buffer *sbuf;
-
-	spin_lock_irqsave(&cam->dev_lock, flags);
-	for (i = 0; i < cam->nbufs; i++) {
-		int bufno = cam->next_buf;
-		if (bufno < 0) {  /* "will never happen" */
-			cam_err(cam, "No valid bufs in tasklet!\n");
-			break;
-		}
-		if (++(cam->next_buf) >= cam->nbufs)
-			cam->next_buf = 0;
-		if (! test_bit(bufno, &cam->flags))
-			continue;
-		if (list_empty(&cam->sb_avail))
-			break;  /* Leave it valid, hope for better later */
-		clear_bit(bufno, &cam->flags);
-		sbuf = list_entry(cam->sb_avail.next,
-				struct cafe_sio_buffer, list);
-		/*
-		 * Drop the lock during the big copy.  This *should* be safe...
-		 */
-		spin_unlock_irqrestore(&cam->dev_lock, flags);
-		memcpy(sbuf->buffer, cam->dma_bufs[bufno],
-				cam->pix_format.sizeimage);
-		sbuf->v4lbuf.bytesused = cam->pix_format.sizeimage;
-		sbuf->v4lbuf.sequence = cam->buf_seq[bufno];
-		sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_QUEUED;
-		sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_DONE;
-		spin_lock_irqsave(&cam->dev_lock, flags);
-		list_move_tail(&sbuf->list, &cam->sb_full);
-	}
-	if (! list_empty(&cam->sb_full))
-		wake_up(&cam->iowait);
-	spin_unlock_irqrestore(&cam->dev_lock, flags);
-}
-
-
-
-static void cafe_frame_complete(struct cafe_camera *cam, int frame)
-{
-	/*
-	 * Basic frame housekeeping.
-	 */
-	if (test_bit(frame, &cam->flags) && printk_ratelimit())
-		cam_err(cam, "Frame overrun on %d, frames lost\n", frame);
-	set_bit(frame, &cam->flags);
-	clear_bit(CF_DMA_ACTIVE, &cam->flags);
-	if (cam->next_buf < 0)
-		cam->next_buf = frame;
-	cam->buf_seq[frame] = ++(cam->sequence);
-
-	switch (cam->state) {
-	/*
-	 * If in single read mode, try going speculative.
-	 */
-	    case S_SINGLEREAD:
-		cam->state = S_SPECREAD;
-		cam->specframes = 0;
-		wake_up(&cam->iowait);
-		break;
-
-	/*
-	 * If we are already doing speculative reads, and nobody is
-	 * reading them, just stop.
-	 */
-	    case S_SPECREAD:
-		if (++(cam->specframes) >= cam->nbufs) {
-			cafe_ctlr_stop(cam);
-			cafe_ctlr_irq_disable(cam);
-			cam->state = S_IDLE;
-		}
-		wake_up(&cam->iowait);
-		break;
-	/*
-	 * For the streaming case, we defer the real work to the
-	 * camera tasklet.
-	 *
-	 * FIXME: if the application is not consuming the buffers,
-	 * we should eventually put things on hold and restart in
-	 * vidioc_dqbuf().
-	 */
-	    case S_STREAMING:
-		tasklet_schedule(&cam->s_tasklet);
-		break;
-
-	    default:
-		cam_err(cam, "Frame interrupt in non-operational state\n");
-		break;
-	}
-}
-
-
-
-
-static void cafe_frame_irq(struct cafe_camera *cam, unsigned int irqs)
-{
-	unsigned int frame;
-
-	cafe_reg_write(cam, REG_IRQSTAT, FRAMEIRQS); /* Clear'em all */
-	/*
-	 * Handle any frame completions.  There really should
-	 * not be more than one of these, or we have fallen
-	 * far behind.
-	 */
-	for (frame = 0; frame < cam->nbufs; frame++)
-		if (irqs & (IRQ_EOF0 << frame))
-			cafe_frame_complete(cam, frame);
-	/*
-	 * If a frame starts, note that we have DMA active.  This
-	 * code assumes that we won't get multiple frame interrupts
-	 * at once; may want to rethink that.
-	 */
-	if (irqs & (IRQ_SOF0 | IRQ_SOF1 | IRQ_SOF2))
-		set_bit(CF_DMA_ACTIVE, &cam->flags);
-}
-
-
-
-static irqreturn_t cafe_irq(int irq, void *data)
-{
-	struct cafe_camera *cam = data;
-	unsigned int irqs;
-
-	spin_lock(&cam->dev_lock);
-	irqs = cafe_reg_read(cam, REG_IRQSTAT);
-	if ((irqs & ALLIRQS) == 0) {
-		spin_unlock(&cam->dev_lock);
-		return IRQ_NONE;
-	}
-	if (irqs & FRAMEIRQS)
-		cafe_frame_irq(cam, irqs);
-	if (irqs & TWSIIRQS) {
-		cafe_reg_write(cam, REG_IRQSTAT, TWSIIRQS);
-		wake_up(&cam->smbus_wait);
-	}
-	spin_unlock(&cam->dev_lock);
-	return IRQ_HANDLED;
-}
-
-
-/* -------------------------------------------------------------------------- */
-/*
- * PCI interface stuff.
- */
-
-static const struct dmi_system_id olpc_xo1_dmi[] = {
-	{
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "1"),
-		},
-	},
-	{ }
-};
-
-static int cafe_pci_probe(struct pci_dev *pdev,
-		const struct pci_device_id *id)
-{
-	int ret;
-	struct cafe_camera *cam;
-	struct ov7670_config sensor_cfg = {
-		/* This controller only does SMBUS */
-		.use_smbus = true,
-
-		/*
-		 * Exclude QCIF mode, because it only captures a tiny portion
-		 * of the sensor FOV
-		 */
-		.min_width = 320,
-		.min_height = 240,
-	};
-	struct i2c_board_info ov7670_info = {
-		.type = "ov7670",
-		.addr = 0x42,
-		.platform_data = &sensor_cfg,
-	};
-
-	/*
-	 * Start putting together one of our big camera structures.
-	 */
-	ret = -ENOMEM;
-	cam = kzalloc(sizeof(struct cafe_camera), GFP_KERNEL);
-	if (cam == NULL)
-		goto out;
-	ret = v4l2_device_register(&pdev->dev, &cam->v4l2_dev);
-	if (ret)
-		goto out_free;
-
-	mutex_init(&cam->s_mutex);
-	spin_lock_init(&cam->dev_lock);
-	cam->state = S_NOTREADY;
-	cafe_set_config_needed(cam, 1);
-	init_waitqueue_head(&cam->smbus_wait);
-	init_waitqueue_head(&cam->iowait);
-	cam->pdev = pdev;
-	cam->pix_format = cafe_def_pix_format;
-	cam->mbus_code = cafe_def_mbus_code;
-	INIT_LIST_HEAD(&cam->dev_list);
-	INIT_LIST_HEAD(&cam->sb_avail);
-	INIT_LIST_HEAD(&cam->sb_full);
-	tasklet_init(&cam->s_tasklet, cafe_frame_tasklet, (unsigned long) cam);
-	/*
-	 * Get set up on the PCI bus.
-	 */
-	ret = pci_enable_device(pdev);
-	if (ret)
-		goto out_unreg;
-	pci_set_master(pdev);
-
-	ret = -EIO;
-	cam->regs = pci_iomap(pdev, 0, 0);
-	if (! cam->regs) {
-		printk(KERN_ERR "Unable to ioremap cafe-ccic regs\n");
-		goto out_unreg;
-	}
-	ret = request_irq(pdev->irq, cafe_irq, IRQF_SHARED, "cafe-ccic", cam);
-	if (ret)
-		goto out_iounmap;
-	/*
-	 * Initialize the controller and leave it powered up.  It will
-	 * stay that way until the sensor driver shows up.
-	 */
-	cafe_ctlr_init(cam);
-	cafe_ctlr_power_up(cam);
-	/*
-	 * Set up I2C/SMBUS communications.  We have to drop the mutex here
-	 * because the sensor could attach in this call chain, leading to
-	 * unsightly deadlocks.
-	 */
-	ret = cafe_smbus_setup(cam);
-	if (ret)
-		goto out_freeirq;
-
-	/* Apply XO-1 clock speed */
-	if (dmi_check_system(olpc_xo1_dmi))
-		sensor_cfg.clock_speed = 45;
-
-	cam->sensor_addr = ov7670_info.addr;
-	cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev, &cam->i2c_adapter,
-			&ov7670_info, NULL);
-	if (cam->sensor == NULL) {
-		ret = -ENODEV;
-		goto out_smbus;
-	}
-
-	ret = cafe_cam_init(cam);
-	if (ret)
-		goto out_smbus;
-
-	/*
-	 * Get the v4l2 setup done.
-	 */
-	mutex_lock(&cam->s_mutex);
-	cam->vdev = cafe_v4l_template;
-	cam->vdev.debug = 0;
-/*	cam->vdev.debug = V4L2_DEBUG_IOCTL_ARG;*/
-	cam->vdev.v4l2_dev = &cam->v4l2_dev;
-	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
-	if (ret)
-		goto out_unlock;
-	video_set_drvdata(&cam->vdev, cam);
-
-	/*
-	 * If so requested, try to get our DMA buffers now.
-	 */
-	if (!alloc_bufs_at_read) {
-		if (cafe_alloc_dma_bufs(cam, 1))
-			cam_warn(cam, "Unable to alloc DMA buffers at load"
-					" will try again later.");
-	}
-
-	mutex_unlock(&cam->s_mutex);
-	return 0;
-
-out_unlock:
-	mutex_unlock(&cam->s_mutex);
-out_smbus:
-	cafe_smbus_shutdown(cam);
-out_freeirq:
-	cafe_ctlr_power_down(cam);
-	free_irq(pdev->irq, cam);
-out_iounmap:
-	pci_iounmap(pdev, cam->regs);
-out_free:
-	v4l2_device_unregister(&cam->v4l2_dev);
-out_unreg:
-	kfree(cam);
-out:
-	return ret;
-}
-
-
-/*
- * Shut down an initialized device
- */
-static void cafe_shutdown(struct cafe_camera *cam)
-{
-/* FIXME: Make sure we take care of everything here */
-	if (cam->n_sbufs > 0)
-		/* What if they are still mapped?  Shouldn't be, but... */
-		cafe_free_sio_buffers(cam);
-	cafe_ctlr_stop_dma(cam);
-	cafe_ctlr_power_down(cam);
-	cafe_smbus_shutdown(cam);
-	cafe_free_dma_bufs(cam);
-	free_irq(cam->pdev->irq, cam);
-	pci_iounmap(cam->pdev, cam->regs);
-	video_unregister_device(&cam->vdev);
-}
-
-
-static void cafe_pci_remove(struct pci_dev *pdev)
-{
-	struct v4l2_device *v4l2_dev = dev_get_drvdata(&pdev->dev);
-	struct cafe_camera *cam = to_cam(v4l2_dev);
-
-	if (cam == NULL) {
-		printk(KERN_WARNING "pci_remove on unknown pdev %p\n", pdev);
-		return;
-	}
-	mutex_lock(&cam->s_mutex);
-	if (cam->users > 0)
-		cam_warn(cam, "Removing a device with users!\n");
-	cafe_shutdown(cam);
-	v4l2_device_unregister(&cam->v4l2_dev);
-	kfree(cam);
-/* No unlock - it no longer exists */
-}
-
-
-#ifdef CONFIG_PM
-/*
- * Basic power management.
- */
-static int cafe_pci_suspend(struct pci_dev *pdev, pm_message_t state)
-{
-	struct v4l2_device *v4l2_dev = dev_get_drvdata(&pdev->dev);
-	struct cafe_camera *cam = to_cam(v4l2_dev);
-	int ret;
-	enum cafe_state cstate;
-
-	ret = pci_save_state(pdev);
-	if (ret)
-		return ret;
-	cstate = cam->state; /* HACK - stop_dma sets to idle */
-	cafe_ctlr_stop_dma(cam);
-	cafe_ctlr_power_down(cam);
-	pci_disable_device(pdev);
-	cam->state = cstate;
-	return 0;
-}
-
-
-static int cafe_pci_resume(struct pci_dev *pdev)
-{
-	struct v4l2_device *v4l2_dev = dev_get_drvdata(&pdev->dev);
-	struct cafe_camera *cam = to_cam(v4l2_dev);
-	int ret = 0;
-
-	pci_restore_state(pdev);
-	ret = pci_enable_device(pdev);
-
-	if (ret) {
-		cam_warn(cam, "Unable to re-enable device on resume!\n");
-		return ret;
-	}
-	cafe_ctlr_init(cam);
-
-	mutex_lock(&cam->s_mutex);
-	if (cam->users > 0) {
-		cafe_ctlr_power_up(cam);
-		__cafe_cam_reset(cam);
-	} else {
-		cafe_ctlr_power_down(cam);
-	}
-	mutex_unlock(&cam->s_mutex);
-
-	set_bit(CF_CONFIG_NEEDED, &cam->flags);
-	if (cam->state == S_SPECREAD)
-		cam->state = S_IDLE;  /* Don't bother restarting */
-	else if (cam->state == S_SINGLEREAD || cam->state == S_STREAMING)
-		ret = cafe_read_setup(cam, cam->state);
-	return ret;
-}
-
-#endif  /* CONFIG_PM */
-
-
-static struct pci_device_id cafe_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL,
-		     PCI_DEVICE_ID_MARVELL_88ALP01_CCIC) },
-	{ 0, }
-};
-
-MODULE_DEVICE_TABLE(pci, cafe_ids);
-
-static struct pci_driver cafe_pci_driver = {
-	.name = "cafe1000-ccic",
-	.id_table = cafe_ids,
-	.probe = cafe_pci_probe,
-	.remove = cafe_pci_remove,
-#ifdef CONFIG_PM
-	.suspend = cafe_pci_suspend,
-	.resume = cafe_pci_resume,
-#endif
-};
-
-
-
-
-static int __init cafe_init(void)
-{
-	int ret;
-
-	printk(KERN_NOTICE "Marvell M88ALP01 'CAFE' Camera Controller version %d\n",
-			CAFE_VERSION);
-	ret = pci_register_driver(&cafe_pci_driver);
-	if (ret) {
-		printk(KERN_ERR "Unable to register cafe_ccic driver\n");
-		goto out;
-	}
-	ret = 0;
-
-  out:
-	return ret;
-}
-
-
-static void __exit cafe_exit(void)
-{
-	pci_unregister_driver(&cafe_pci_driver);
-}
-
-module_init(cafe_init);
-module_exit(cafe_exit);
diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
new file mode 100644
index 0000000..88203d8
--- /dev/null
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -0,0 +1,1689 @@
+/*
+ * The Marvell camera core.  This device appears in a number of settings,
+ * so it needs platform-specific support outside of the core.
+ *
+ * Copyright 2011 Jonathan Corbet corbet@lwn.net
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/dmi.h>
+#include <linux/mm.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/videodev2.h>
+#include <linux/slab.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/ov7670.h>
+#include <linux/device.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/jiffies.h>
+#include <linux/vmalloc.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include "mcam-core.h"
+
+
+/*
+ * Internal DMA buffer management.  Since the controller cannot do S/G I/O,
+ * we must have physically contiguous buffers to bring frames into.
+ * These parameters control how many buffers we use, whether we
+ * allocate them at load time (better chance of success, but nails down
+ * memory) or when somebody tries to use the camera (riskier), and,
+ * for load-time allocation, how big they should be.
+ *
+ * The controller can cycle through three buffers.  We could use
+ * more by flipping pointers around, but it probably makes little
+ * sense.
+ */
+
+static int alloc_bufs_at_read;
+module_param(alloc_bufs_at_read, bool, 0444);
+MODULE_PARM_DESC(alloc_bufs_at_read,
+		"Non-zero value causes DMA buffers to be allocated when the "
+		"video capture device is read, rather than at module load "
+		"time.  This saves memory, but decreases the chances of "
+		"successfully getting those buffers.");
+
+static int n_dma_bufs = 3;
+module_param(n_dma_bufs, uint, 0644);
+MODULE_PARM_DESC(n_dma_bufs,
+		"The number of DMA buffers to allocate.  Can be either two "
+		"(saves memory, makes timing tighter) or three.");
+
+static int dma_buf_size = VGA_WIDTH * VGA_HEIGHT * 2;  /* Worst case */
+module_param(dma_buf_size, uint, 0444);
+MODULE_PARM_DESC(dma_buf_size,
+		"The size of the allocated DMA buffers.  If actual operating "
+		"parameters require larger buffers, an attempt to reallocate "
+		"will be made.");
+
+static int min_buffers = 1;
+module_param(min_buffers, uint, 0644);
+MODULE_PARM_DESC(min_buffers,
+		"The minimum number of streaming I/O buffers we are willing "
+		"to work with.");
+
+static int max_buffers = 10;
+module_param(max_buffers, uint, 0644);
+MODULE_PARM_DESC(max_buffers,
+		"The maximum number of streaming I/O buffers an application "
+		"will be allowed to allocate.  These buffers are big and live "
+		"in vmalloc space.");
+
+static int flip;
+module_param(flip, bool, 0444);
+MODULE_PARM_DESC(flip,
+		"If set, the sensor will be instructed to flip the image "
+		"vertically.");
+
+/*
+ * Status flags.  Always manipulated with bit operations.
+ */
+#define CF_BUF0_VALID	 0	/* Buffers valid - first three */
+#define CF_BUF1_VALID	 1
+#define CF_BUF2_VALID	 2
+#define CF_DMA_ACTIVE	 3	/* A frame is incoming */
+#define CF_CONFIG_NEEDED 4	/* Must configure hardware */
+
+#define sensor_call(cam, o, f, args...) \
+	v4l2_subdev_call(cam->sensor, o, f, ##args)
+
+static struct mcam_format_struct {
+	__u8 *desc;
+	__u32 pixelformat;
+	int bpp;   /* Bytes per pixel */
+	enum v4l2_mbus_pixelcode mbus_code;
+} mcam_formats[] = {
+	{
+		.desc		= "YUYV 4:2:2",
+		.pixelformat	= V4L2_PIX_FMT_YUYV,
+		.mbus_code	= V4L2_MBUS_FMT_YUYV8_2X8,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "RGB 444",
+		.pixelformat	= V4L2_PIX_FMT_RGB444,
+		.mbus_code	= V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "RGB 565",
+		.pixelformat	= V4L2_PIX_FMT_RGB565,
+		.mbus_code	= V4L2_MBUS_FMT_RGB565_2X8_LE,
+		.bpp		= 2,
+	},
+	{
+		.desc		= "Raw RGB Bayer",
+		.pixelformat	= V4L2_PIX_FMT_SBGGR8,
+		.mbus_code	= V4L2_MBUS_FMT_SBGGR8_1X8,
+		.bpp		= 1
+	},
+};
+#define N_MCAM_FMTS ARRAY_SIZE(mcam_formats)
+
+static struct mcam_format_struct *mcam_find_format(u32 pixelformat)
+{
+	unsigned i;
+
+	for (i = 0; i < N_MCAM_FMTS; i++)
+		if (mcam_formats[i].pixelformat == pixelformat)
+			return mcam_formats + i;
+	/* Not found? Then return the first format. */
+	return mcam_formats;
+}
+
+/*
+ * Start over with DMA buffers - dev_lock needed.
+ */
+static void mcam_reset_buffers(struct mcam_camera *cam)
+{
+	int i;
+
+	cam->next_buf = -1;
+	for (i = 0; i < cam->nbufs; i++)
+		clear_bit(i, &cam->flags);
+	cam->specframes = 0;
+}
+
+static inline int mcam_needs_config(struct mcam_camera *cam)
+{
+	return test_bit(CF_CONFIG_NEEDED, &cam->flags);
+}
+
+static void mcam_set_config_needed(struct mcam_camera *cam, int needed)
+{
+	if (needed)
+		set_bit(CF_CONFIG_NEEDED, &cam->flags);
+	else
+		clear_bit(CF_CONFIG_NEEDED, &cam->flags);
+}
+
+
+/*
+ * Debugging and related.  FIXME these are broken
+ */
+#define cam_err(cam, fmt, arg...) \
+	dev_err((cam)->dev, fmt, ##arg);
+#define cam_warn(cam, fmt, arg...) \
+	dev_warn((cam)->dev, fmt, ##arg);
+#define cam_dbg(cam, fmt, arg...) \
+	dev_dbg((cam)->dev, fmt, ##arg);
+
+
+
+/* ------------------------------------------------------------------- */
+/*
+ * Deal with the controller.
+ */
+
+/*
+ * Do everything we think we need to have the interface operating
+ * according to the desired format.
+ */
+static void mcam_ctlr_dma(struct mcam_camera *cam)
+{
+	/*
+	 * Store the first two Y buffers (we aren't supporting
+	 * planar formats for now, so no UV bufs).  Then either
+	 * set the third if it exists, or tell the controller
+	 * to just use two.
+	 */
+	mcam_reg_write(cam, REG_Y0BAR, cam->dma_handles[0]);
+	mcam_reg_write(cam, REG_Y1BAR, cam->dma_handles[1]);
+	if (cam->nbufs > 2) {
+		mcam_reg_write(cam, REG_Y2BAR, cam->dma_handles[2]);
+		mcam_reg_clear_bit(cam, REG_CTRL1, C1_TWOBUFS);
+	} else
+		mcam_reg_set_bit(cam, REG_CTRL1, C1_TWOBUFS);
+	mcam_reg_write(cam, REG_UBAR, 0); /* 32 bits only for now */
+}
+
+static void mcam_ctlr_image(struct mcam_camera *cam)
+{
+	int imgsz;
+	struct v4l2_pix_format *fmt = &cam->pix_format;
+
+	imgsz = ((fmt->height << IMGSZ_V_SHIFT) & IMGSZ_V_MASK) |
+		(fmt->bytesperline & IMGSZ_H_MASK);
+	mcam_reg_write(cam, REG_IMGSIZE, imgsz);
+	mcam_reg_write(cam, REG_IMGOFFSET, 0);
+	/* YPITCH just drops the last two bits */
+	mcam_reg_write_mask(cam, REG_IMGPITCH, fmt->bytesperline,
+			IMGP_YP_MASK);
+	/*
+	 * Tell the controller about the image format we are using.
+	 */
+	switch (cam->pix_format.pixelformat) {
+	case V4L2_PIX_FMT_YUYV:
+	    mcam_reg_write_mask(cam, REG_CTRL0,
+			    C0_DF_YUV|C0_YUV_PACKED|C0_YUVE_YUYV,
+			    C0_DF_MASK);
+	    break;
+
+	case V4L2_PIX_FMT_RGB444:
+	    mcam_reg_write_mask(cam, REG_CTRL0,
+			    C0_DF_RGB|C0_RGBF_444|C0_RGB4_XRGB,
+			    C0_DF_MASK);
+		/* Alpha value? */
+	    break;
+
+	case V4L2_PIX_FMT_RGB565:
+	    mcam_reg_write_mask(cam, REG_CTRL0,
+			    C0_DF_RGB|C0_RGBF_565|C0_RGB5_BGGR,
+			    C0_DF_MASK);
+	    break;
+
+	default:
+	    cam_err(cam, "Unknown format %x\n", cam->pix_format.pixelformat);
+	    break;
+	}
+	/*
+	 * Make sure it knows we want to use hsync/vsync.
+	 */
+	mcam_reg_write_mask(cam, REG_CTRL0, C0_SIF_HVSYNC,
+			C0_SIFM_MASK);
+}
+
+
+/*
+ * Configure the controller for operation; caller holds the
+ * device mutex.
+ */
+static int mcam_ctlr_configure(struct mcam_camera *cam)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	mcam_ctlr_dma(cam);
+	mcam_ctlr_image(cam);
+	mcam_set_config_needed(cam, 0);
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+	return 0;
+}
+
+static void mcam_ctlr_irq_enable(struct mcam_camera *cam)
+{
+	/*
+	 * Clear any pending interrupts, since we do not
+	 * expect to have I/O active prior to enabling.
+	 */
+	mcam_reg_write(cam, REG_IRQSTAT, FRAMEIRQS);
+	mcam_reg_set_bit(cam, REG_IRQMASK, FRAMEIRQS);
+}
+
+static void mcam_ctlr_irq_disable(struct mcam_camera *cam)
+{
+	mcam_reg_clear_bit(cam, REG_IRQMASK, FRAMEIRQS);
+}
+
+/*
+ * Make the controller start grabbing images.  Everything must
+ * be set up before doing this.
+ */
+static void mcam_ctlr_start(struct mcam_camera *cam)
+{
+	/* set_bit performs a read, so no other barrier should be
+	   needed here */
+	mcam_reg_set_bit(cam, REG_CTRL0, C0_ENABLE);
+}
+
+static void mcam_ctlr_stop(struct mcam_camera *cam)
+{
+	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
+}
+
+static void mcam_ctlr_init(struct mcam_camera *cam)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	/*
+	 * Make sure it's not powered down.
+	 */
+	mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
+	/*
+	 * Turn off the enable bit.  It sure should be off anyway,
+	 * but it's good to be sure.
+	 */
+	mcam_reg_clear_bit(cam, REG_CTRL0, C0_ENABLE);
+	/*
+	 * Clock the sensor appropriately.  Controller clock should
+	 * be 48MHz, sensor "typical" value is half that.
+	 */
+	mcam_reg_write_mask(cam, REG_CLKCTRL, 2, CLK_DIV_MASK);
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+}
+
+
+/*
+ * Stop the controller, and don't return until we're really sure that no
+ * further DMA is going on.
+ */
+static void mcam_ctlr_stop_dma(struct mcam_camera *cam)
+{
+	unsigned long flags;
+
+	/*
+	 * Theory: stop the camera controller (whether it is operating
+	 * or not).  Delay briefly just in case we race with the SOF
+	 * interrupt, then wait until no DMA is active.
+	 */
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	mcam_ctlr_stop(cam);
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+	mdelay(1);
+	wait_event_timeout(cam->iowait,
+			!test_bit(CF_DMA_ACTIVE, &cam->flags), HZ);
+	if (test_bit(CF_DMA_ACTIVE, &cam->flags))
+		cam_err(cam, "Timeout waiting for DMA to end\n");
+		/* This would be bad news - what now? */
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	cam->state = S_IDLE;
+	mcam_ctlr_irq_disable(cam);
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+}
+
+/*
+ * Power up and down.
+ */
+static void mcam_ctlr_power_up(struct mcam_camera *cam)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	mcam_reg_clear_bit(cam, REG_CTRL1, C1_PWRDWN);
+	cam->plat_power_up(cam);
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+	msleep(5); /* Just to be sure */
+}
+
+static void mcam_ctlr_power_down(struct mcam_camera *cam)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	cam->plat_power_down(cam);
+	mcam_reg_set_bit(cam, REG_CTRL1, C1_PWRDWN);
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+}
+
+/* -------------------------------------------------------------------- */
+/*
+ * Communications with the sensor.
+ */
+
+static int __mcam_cam_reset(struct mcam_camera *cam)
+{
+	return sensor_call(cam, core, reset, 0);
+}
+
+/*
+ * We have found the sensor on the i2c.  Let's try to have a
+ * conversation.
+ */
+static int mcam_cam_init(struct mcam_camera *cam)
+{
+	struct v4l2_dbg_chip_ident chip;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	if (cam->state != S_NOTREADY)
+		cam_warn(cam, "Cam init with device in funky state %d",
+				cam->state);
+	ret = __mcam_cam_reset(cam);
+	if (ret)
+		goto out;
+	chip.ident = V4L2_IDENT_NONE;
+	chip.match.type = V4L2_CHIP_MATCH_I2C_ADDR;
+	chip.match.addr = cam->sensor_addr;
+	ret = sensor_call(cam, core, g_chip_ident, &chip);
+	if (ret)
+		goto out;
+	cam->sensor_type = chip.ident;
+	if (cam->sensor_type != V4L2_IDENT_OV7670) {
+		cam_err(cam, "Unsupported sensor type 0x%x", cam->sensor_type);
+		ret = -EINVAL;
+		goto out;
+	}
+/* Get/set parameters? */
+	ret = 0;
+	cam->state = S_IDLE;
+out:
+	mcam_ctlr_power_down(cam);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+/*
+ * Configure the sensor to match the parameters we have.  Caller should
+ * hold s_mutex
+ */
+static int mcam_cam_set_flip(struct mcam_camera *cam)
+{
+	struct v4l2_control ctrl;
+
+	memset(&ctrl, 0, sizeof(ctrl));
+	ctrl.id = V4L2_CID_VFLIP;
+	ctrl.value = flip;
+	return sensor_call(cam, core, s_ctrl, &ctrl);
+}
+
+
+static int mcam_cam_configure(struct mcam_camera *cam)
+{
+	struct v4l2_mbus_framefmt mbus_fmt;
+	int ret;
+
+	v4l2_fill_mbus_format(&mbus_fmt, &cam->pix_format, cam->mbus_code);
+	ret = sensor_call(cam, core, init, 0);
+	if (ret == 0)
+		ret = sensor_call(cam, video, s_mbus_fmt, &mbus_fmt);
+	/*
+	 * OV7670 does weird things if flip is set *before* format...
+	 */
+	ret += mcam_cam_set_flip(cam);
+	return ret;
+}
+
+/* -------------------------------------------------------------------- */
+/*
+ * DMA buffer management.  These functions need s_mutex held.
+ */
+
+/* FIXME: this is inefficient as hell, since dma_alloc_coherent just
+ * does a get_free_pages() call, and we waste a good chunk of an orderN
+ * allocation.  Should try to allocate the whole set in one chunk.
+ */
+static int mcam_alloc_dma_bufs(struct mcam_camera *cam, int loadtime)
+{
+	int i;
+
+	mcam_set_config_needed(cam, 1);
+	if (loadtime)
+		cam->dma_buf_size = dma_buf_size;
+	else
+		cam->dma_buf_size = cam->pix_format.sizeimage;
+	if (n_dma_bufs > 3)
+		n_dma_bufs = 3;
+
+	cam->nbufs = 0;
+	for (i = 0; i < n_dma_bufs; i++) {
+		cam->dma_bufs[i] = dma_alloc_coherent(cam->dev,
+				cam->dma_buf_size, cam->dma_handles + i,
+				GFP_KERNEL);
+		if (cam->dma_bufs[i] == NULL) {
+			cam_warn(cam, "Failed to allocate DMA buffer\n");
+			break;
+		}
+		/* For debug, remove eventually */
+		memset(cam->dma_bufs[i], 0xcc, cam->dma_buf_size);
+		(cam->nbufs)++;
+	}
+
+	switch (cam->nbufs) {
+	case 1:
+		dma_free_coherent(cam->dev, cam->dma_buf_size,
+				cam->dma_bufs[0], cam->dma_handles[0]);
+		cam->nbufs = 0;
+	case 0:
+		cam_err(cam, "Insufficient DMA buffers, cannot operate\n");
+		return -ENOMEM;
+
+	case 2:
+		if (n_dma_bufs > 2)
+			cam_warn(cam, "Will limp along with only 2 buffers\n");
+		break;
+	}
+	return 0;
+}
+
+static void mcam_free_dma_bufs(struct mcam_camera *cam)
+{
+	int i;
+
+	for (i = 0; i < cam->nbufs; i++) {
+		dma_free_coherent(cam->dev, cam->dma_buf_size,
+				cam->dma_bufs[i], cam->dma_handles[i]);
+		cam->dma_bufs[i] = NULL;
+	}
+	cam->nbufs = 0;
+}
+
+
+
+
+
+/* ----------------------------------------------------------------------- */
+/*
+ * Here starts the V4L2 interface code.
+ */
+
+/*
+ * Read an image from the device.
+ */
+static ssize_t mcam_deliver_buffer(struct mcam_camera *cam,
+		char __user *buffer, size_t len, loff_t *pos)
+{
+	int bufno;
+	unsigned long flags;
+
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	if (cam->next_buf < 0) {
+		cam_err(cam, "deliver_buffer: No next buffer\n");
+		spin_unlock_irqrestore(&cam->dev_lock, flags);
+		return -EIO;
+	}
+	bufno = cam->next_buf;
+	clear_bit(bufno, &cam->flags);
+	if (++(cam->next_buf) >= cam->nbufs)
+		cam->next_buf = 0;
+	if (!test_bit(cam->next_buf, &cam->flags))
+		cam->next_buf = -1;
+	cam->specframes = 0;
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+
+	if (len > cam->pix_format.sizeimage)
+		len = cam->pix_format.sizeimage;
+	if (copy_to_user(buffer, cam->dma_bufs[bufno], len))
+		return -EFAULT;
+	(*pos) += len;
+	return len;
+}
+
+/*
+ * Get everything ready, and start grabbing frames.
+ */
+static int mcam_read_setup(struct mcam_camera *cam, enum mcam_state state)
+{
+	int ret;
+	unsigned long flags;
+
+	/*
+	 * Configuration.  If we still don't have DMA buffers,
+	 * make one last, desperate attempt.
+	 */
+	if (cam->nbufs == 0)
+		if (mcam_alloc_dma_bufs(cam, 0))
+			return -ENOMEM;
+
+	if (mcam_needs_config(cam)) {
+		mcam_cam_configure(cam);
+		ret = mcam_ctlr_configure(cam);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Turn it loose.
+	 */
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	mcam_reset_buffers(cam);
+	mcam_ctlr_irq_enable(cam);
+	cam->state = state;
+	mcam_ctlr_start(cam);
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+	return 0;
+}
+
+
+static ssize_t mcam_v4l_read(struct file *filp,
+		char __user *buffer, size_t len, loff_t *pos)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret = 0;
+
+	/*
+	 * Perhaps we're in speculative read mode and already
+	 * have data?
+	 */
+	mutex_lock(&cam->s_mutex);
+	if (cam->state == S_SPECREAD) {
+		if (cam->next_buf >= 0) {
+			ret = mcam_deliver_buffer(cam, buffer, len, pos);
+			if (ret != 0)
+				goto out_unlock;
+		}
+	} else if (cam->state == S_FLAKED || cam->state == S_NOTREADY) {
+		ret = -EIO;
+		goto out_unlock;
+	} else if (cam->state != S_IDLE) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	/*
+	 * v4l2: multiple processes can open the device, but only
+	 * one gets to grab data from it.
+	 */
+	if (cam->owner && cam->owner != filp) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+	cam->owner = filp;
+
+	/*
+	 * Do setup if need be.
+	 */
+	if (cam->state != S_SPECREAD) {
+		ret = mcam_read_setup(cam, S_SINGLEREAD);
+		if (ret)
+			goto out_unlock;
+	}
+	/*
+	 * Wait for something to happen.  This should probably
+	 * be interruptible (FIXME).
+	 */
+	wait_event_timeout(cam->iowait, cam->next_buf >= 0, HZ);
+	if (cam->next_buf < 0) {
+		cam_err(cam, "read() operation timed out\n");
+		mcam_ctlr_stop_dma(cam);
+		ret = -EIO;
+		goto out_unlock;
+	}
+	/*
+	 * Give them their data and we should be done.
+	 */
+	ret = mcam_deliver_buffer(cam, buffer, len, pos);
+
+out_unlock:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+
+
+
+
+
+
+
+/*
+ * Streaming I/O support.
+ */
+
+
+
+static int mcam_vidioc_streamon(struct file *filp, void *priv,
+		enum v4l2_buf_type type)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret = -EINVAL;
+
+	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		goto out;
+	mutex_lock(&cam->s_mutex);
+	if (cam->state != S_IDLE || cam->n_sbufs == 0)
+		goto out_unlock;
+
+	cam->sequence = 0;
+	ret = mcam_read_setup(cam, S_STREAMING);
+
+out_unlock:
+	mutex_unlock(&cam->s_mutex);
+out:
+	return ret;
+}
+
+
+static int mcam_vidioc_streamoff(struct file *filp, void *priv,
+		enum v4l2_buf_type type)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret = -EINVAL;
+
+	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		goto out;
+	mutex_lock(&cam->s_mutex);
+	if (cam->state != S_STREAMING)
+		goto out_unlock;
+
+	mcam_ctlr_stop_dma(cam);
+	ret = 0;
+
+out_unlock:
+	mutex_unlock(&cam->s_mutex);
+out:
+	return ret;
+}
+
+
+
+static int mcam_setup_siobuf(struct mcam_camera *cam, int index)
+{
+	struct mcam_sio_buffer *buf = cam->sb_bufs + index;
+
+	INIT_LIST_HEAD(&buf->list);
+	buf->v4lbuf.length = PAGE_ALIGN(cam->pix_format.sizeimage);
+	buf->buffer = vmalloc_user(buf->v4lbuf.length);
+	if (buf->buffer == NULL)
+		return -ENOMEM;
+	buf->mapcount = 0;
+	buf->cam = cam;
+
+	buf->v4lbuf.index = index;
+	buf->v4lbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	buf->v4lbuf.field = V4L2_FIELD_NONE;
+	buf->v4lbuf.memory = V4L2_MEMORY_MMAP;
+	/*
+	 * Offset: must be 32-bit even on a 64-bit system.  videobuf-dma-sg
+	 * just uses the length times the index, but the spec warns
+	 * against doing just that - vma merging problems.  So we
+	 * leave a gap between each pair of buffers.
+	 */
+	buf->v4lbuf.m.offset = 2*index*buf->v4lbuf.length;
+	return 0;
+}
+
+static int mcam_free_sio_buffers(struct mcam_camera *cam)
+{
+	int i;
+
+	/*
+	 * If any buffers are mapped, we cannot free them at all.
+	 */
+	for (i = 0; i < cam->n_sbufs; i++)
+		if (cam->sb_bufs[i].mapcount > 0)
+			return -EBUSY;
+	/*
+	 * OK, let's do it.
+	 */
+	for (i = 0; i < cam->n_sbufs; i++)
+		vfree(cam->sb_bufs[i].buffer);
+	cam->n_sbufs = 0;
+	kfree(cam->sb_bufs);
+	cam->sb_bufs = NULL;
+	INIT_LIST_HEAD(&cam->sb_avail);
+	INIT_LIST_HEAD(&cam->sb_full);
+	return 0;
+}
+
+
+
+static int mcam_vidioc_reqbufs(struct file *filp, void *priv,
+		struct v4l2_requestbuffers *req)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret = 0;  /* Silence warning */
+
+	/*
+	 * Make sure it's something we can do.  User pointers could be
+	 * implemented without great pain, but that's not been done yet.
+	 */
+	if (req->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+	/*
+	 * If they ask for zero buffers, they really want us to stop streaming
+	 * (if it's happening) and free everything.  Should we check owner?
+	 */
+	mutex_lock(&cam->s_mutex);
+	if (req->count == 0) {
+		if (cam->state == S_STREAMING)
+			mcam_ctlr_stop_dma(cam);
+		ret = mcam_free_sio_buffers(cam);
+		goto out;
+	}
+	/*
+	 * Device needs to be idle and working.  We *could* try to do the
+	 * right thing in S_SPECREAD by shutting things down, but it
+	 * probably doesn't matter.
+	 */
+	if (cam->state != S_IDLE || (cam->owner && cam->owner != filp)) {
+		ret = -EBUSY;
+		goto out;
+	}
+	cam->owner = filp;
+
+	if (req->count < min_buffers)
+		req->count = min_buffers;
+	else if (req->count > max_buffers)
+		req->count = max_buffers;
+	if (cam->n_sbufs > 0) {
+		ret = mcam_free_sio_buffers(cam);
+		if (ret)
+			goto out;
+	}
+
+	cam->sb_bufs = kzalloc(req->count*sizeof(struct mcam_sio_buffer),
+			GFP_KERNEL);
+	if (cam->sb_bufs == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	for (cam->n_sbufs = 0; cam->n_sbufs < req->count; (cam->n_sbufs++)) {
+		ret = mcam_setup_siobuf(cam, cam->n_sbufs);
+		if (ret)
+			break;
+	}
+
+	if (cam->n_sbufs == 0)  /* no luck at all - ret already set */
+		kfree(cam->sb_bufs);
+	req->count = cam->n_sbufs;  /* In case of partial success */
+
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+
+static int mcam_vidioc_querybuf(struct file *filp, void *priv,
+		struct v4l2_buffer *buf)
+{
+	struct mcam_camera *cam = filp->private_data;
+	int ret = -EINVAL;
+
+	mutex_lock(&cam->s_mutex);
+	if (buf->index >= cam->n_sbufs)
+		goto out;
+	*buf = cam->sb_bufs[buf->index].v4lbuf;
+	ret = 0;
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_qbuf(struct file *filp, void *priv,
+		struct v4l2_buffer *buf)
+{
+	struct mcam_camera *cam = filp->private_data;
+	struct mcam_sio_buffer *sbuf;
+	int ret = -EINVAL;
+	unsigned long flags;
+
+	mutex_lock(&cam->s_mutex);
+	if (buf->index >= cam->n_sbufs)
+		goto out;
+	sbuf = cam->sb_bufs + buf->index;
+	if (sbuf->v4lbuf.flags & V4L2_BUF_FLAG_QUEUED) {
+		ret = 0; /* Already queued?? */
+		goto out;
+	}
+	if (sbuf->v4lbuf.flags & V4L2_BUF_FLAG_DONE) {
+		/* Spec doesn't say anything, seems appropriate tho */
+		ret = -EBUSY;
+		goto out;
+	}
+	sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_QUEUED;
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	list_add(&sbuf->list, &cam->sb_avail);
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+	ret = 0;
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_dqbuf(struct file *filp, void *priv,
+		struct v4l2_buffer *buf)
+{
+	struct mcam_camera *cam = filp->private_data;
+	struct mcam_sio_buffer *sbuf;
+	int ret = -EINVAL;
+	unsigned long flags;
+
+	mutex_lock(&cam->s_mutex);
+	if (cam->state != S_STREAMING)
+		goto out_unlock;
+	if (list_empty(&cam->sb_full) && filp->f_flags & O_NONBLOCK) {
+		ret = -EAGAIN;
+		goto out_unlock;
+	}
+
+	while (list_empty(&cam->sb_full) && cam->state == S_STREAMING) {
+		mutex_unlock(&cam->s_mutex);
+		if (wait_event_interruptible(cam->iowait,
+						!list_empty(&cam->sb_full))) {
+			ret = -ERESTARTSYS;
+			goto out;
+		}
+		mutex_lock(&cam->s_mutex);
+	}
+
+	if (cam->state != S_STREAMING)
+		ret = -EINTR;
+	else {
+		spin_lock_irqsave(&cam->dev_lock, flags);
+		/* Should probably recheck !list_empty() here */
+		sbuf = list_entry(cam->sb_full.next,
+				struct mcam_sio_buffer, list);
+		list_del_init(&sbuf->list);
+		spin_unlock_irqrestore(&cam->dev_lock, flags);
+		sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_DONE;
+		*buf = sbuf->v4lbuf;
+		ret = 0;
+	}
+
+out_unlock:
+	mutex_unlock(&cam->s_mutex);
+out:
+	return ret;
+}
+
+
+
+static void mcam_v4l_vm_open(struct vm_area_struct *vma)
+{
+	struct mcam_sio_buffer *sbuf = vma->vm_private_data;
+	/*
+	 * Locking: done under mmap_sem, so we don't need to
+	 * go back to the camera lock here.
+	 */
+	sbuf->mapcount++;
+}
+
+
+static void mcam_v4l_vm_close(struct vm_area_struct *vma)
+{
+	struct mcam_sio_buffer *sbuf = vma->vm_private_data;
+
+	mutex_lock(&sbuf->cam->s_mutex);
+	sbuf->mapcount--;
+	/* Docs say we should stop I/O too... */
+	if (sbuf->mapcount == 0)
+		sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_MAPPED;
+	mutex_unlock(&sbuf->cam->s_mutex);
+}
+
+static const struct vm_operations_struct mcam_v4l_vm_ops = {
+	.open = mcam_v4l_vm_open,
+	.close = mcam_v4l_vm_close
+};
+
+
+static int mcam_v4l_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct mcam_camera *cam = filp->private_data;
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	int ret = -EINVAL;
+	int i;
+	struct mcam_sio_buffer *sbuf = NULL;
+
+	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+	/*
+	 * Find the buffer they are looking for.
+	 */
+	mutex_lock(&cam->s_mutex);
+	for (i = 0; i < cam->n_sbufs; i++)
+		if (cam->sb_bufs[i].v4lbuf.m.offset == offset) {
+			sbuf = cam->sb_bufs + i;
+			break;
+		}
+	if (sbuf == NULL)
+		goto out;
+
+	ret = remap_vmalloc_range(vma, sbuf->buffer, 0);
+	if (ret)
+		goto out;
+	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_private_data = sbuf;
+	vma->vm_ops = &mcam_v4l_vm_ops;
+	sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_MAPPED;
+	mcam_v4l_vm_open(vma);
+	ret = 0;
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+
+
+static int mcam_v4l_open(struct file *filp)
+{
+	struct mcam_camera *cam = video_drvdata(filp);
+
+	filp->private_data = cam;
+
+	mutex_lock(&cam->s_mutex);
+	if (cam->users == 0) {
+		mcam_ctlr_power_up(cam);
+		__mcam_cam_reset(cam);
+		mcam_set_config_needed(cam, 1);
+	/* FIXME make sure this is complete */
+	}
+	(cam->users)++;
+	mutex_unlock(&cam->s_mutex);
+	return 0;
+}
+
+
+static int mcam_v4l_release(struct file *filp)
+{
+	struct mcam_camera *cam = filp->private_data;
+
+	mutex_lock(&cam->s_mutex);
+	(cam->users)--;
+	if (filp == cam->owner) {
+		mcam_ctlr_stop_dma(cam);
+		mcam_free_sio_buffers(cam);
+		cam->owner = NULL;
+	}
+	if (cam->users == 0) {
+		mcam_ctlr_power_down(cam);
+		if (alloc_bufs_at_read)
+			mcam_free_dma_bufs(cam);
+	}
+	mutex_unlock(&cam->s_mutex);
+	return 0;
+}
+
+
+
+static unsigned int mcam_v4l_poll(struct file *filp,
+		struct poll_table_struct *pt)
+{
+	struct mcam_camera *cam = filp->private_data;
+
+	poll_wait(filp, &cam->iowait, pt);
+	if (cam->next_buf >= 0)
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+
+
+static int mcam_vidioc_queryctrl(struct file *filp, void *priv,
+		struct v4l2_queryctrl *qc)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, core, queryctrl, qc);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+
+static int mcam_vidioc_g_ctrl(struct file *filp, void *priv,
+		struct v4l2_control *ctrl)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, core, g_ctrl, ctrl);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+
+static int mcam_vidioc_s_ctrl(struct file *filp, void *priv,
+		struct v4l2_control *ctrl)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, core, s_ctrl, ctrl);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+
+
+
+
+static int mcam_vidioc_querycap(struct file *file, void *priv,
+		struct v4l2_capability *cap)
+{
+	strcpy(cap->driver, "marvell_ccic");
+	strcpy(cap->card, "marvell_ccic");
+	cap->version = 1;
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
+	return 0;
+}
+
+
+/*
+ * The default format we use until somebody says otherwise.
+ */
+static const struct v4l2_pix_format mcam_def_pix_format = {
+	.width		= VGA_WIDTH,
+	.height		= VGA_HEIGHT,
+	.pixelformat	= V4L2_PIX_FMT_YUYV,
+	.field		= V4L2_FIELD_NONE,
+	.bytesperline	= VGA_WIDTH*2,
+	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,
+};
+
+static const enum v4l2_mbus_pixelcode mcam_def_mbus_code =
+					V4L2_MBUS_FMT_YUYV8_2X8;
+
+static int mcam_vidioc_enum_fmt_vid_cap(struct file *filp,
+		void *priv, struct v4l2_fmtdesc *fmt)
+{
+	if (fmt->index >= N_MCAM_FMTS)
+		return -EINVAL;
+	strlcpy(fmt->description, mcam_formats[fmt->index].desc,
+			sizeof(fmt->description));
+	fmt->pixelformat = mcam_formats[fmt->index].pixelformat;
+	return 0;
+}
+
+static int mcam_vidioc_try_fmt_vid_cap(struct file *filp, void *priv,
+		struct v4l2_format *fmt)
+{
+	struct mcam_camera *cam = priv;
+	struct mcam_format_struct *f;
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+	struct v4l2_mbus_framefmt mbus_fmt;
+	int ret;
+
+	f = mcam_find_format(pix->pixelformat);
+	pix->pixelformat = f->pixelformat;
+	v4l2_fill_mbus_format(&mbus_fmt, pix, f->mbus_code);
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, try_mbus_fmt, &mbus_fmt);
+	mutex_unlock(&cam->s_mutex);
+	v4l2_fill_pix_format(pix, &mbus_fmt);
+	pix->bytesperline = pix->width * f->bpp;
+	pix->sizeimage = pix->height * pix->bytesperline;
+	return ret;
+}
+
+static int mcam_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
+		struct v4l2_format *fmt)
+{
+	struct mcam_camera *cam = priv;
+	struct mcam_format_struct *f;
+	int ret;
+
+	/*
+	 * Can't do anything if the device is not idle
+	 * Also can't if there are streaming buffers in place.
+	 */
+	if (cam->state != S_IDLE || cam->n_sbufs > 0)
+		return -EBUSY;
+
+	f = mcam_find_format(fmt->fmt.pix.pixelformat);
+
+	/*
+	 * See if the formatting works in principle.
+	 */
+	ret = mcam_vidioc_try_fmt_vid_cap(filp, priv, fmt);
+	if (ret)
+		return ret;
+	/*
+	 * Now we start to change things for real, so let's do it
+	 * under lock.
+	 */
+	mutex_lock(&cam->s_mutex);
+	cam->pix_format = fmt->fmt.pix;
+	cam->mbus_code = f->mbus_code;
+
+	/*
+	 * Make sure we have appropriate DMA buffers.
+	 */
+	ret = -ENOMEM;
+	if (cam->nbufs > 0 && cam->dma_buf_size < cam->pix_format.sizeimage)
+		mcam_free_dma_bufs(cam);
+	if (cam->nbufs == 0) {
+		if (mcam_alloc_dma_bufs(cam, 0))
+			goto out;
+	}
+	/*
+	 * It looks like this might work, so let's program the sensor.
+	 */
+	ret = mcam_cam_configure(cam);
+	if (!ret)
+		ret = mcam_ctlr_configure(cam);
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+/*
+ * Return our stored notion of how the camera is/should be configured.
+ * The V4l2 spec wants us to be smarter, and actually get this from
+ * the camera (and not mess with it at open time).  Someday.
+ */
+static int mcam_vidioc_g_fmt_vid_cap(struct file *filp, void *priv,
+		struct v4l2_format *f)
+{
+	struct mcam_camera *cam = priv;
+
+	f->fmt.pix = cam->pix_format;
+	return 0;
+}
+
+/*
+ * We only have one input - the sensor - so minimize the nonsense here.
+ */
+static int mcam_vidioc_enum_input(struct file *filp, void *priv,
+		struct v4l2_input *input)
+{
+	if (input->index != 0)
+		return -EINVAL;
+
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+	input->std = V4L2_STD_ALL; /* Not sure what should go here */
+	strcpy(input->name, "Camera");
+	return 0;
+}
+
+static int mcam_vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int mcam_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
+{
+	if (i != 0)
+		return -EINVAL;
+	return 0;
+}
+
+/* from vivi.c */
+static int mcam_vidioc_s_std(struct file *filp, void *priv, v4l2_std_id *a)
+{
+	return 0;
+}
+
+/*
+ * G/S_PARM.  Most of this is done by the sensor, but we are
+ * the level which controls the number of read buffers.
+ */
+static int mcam_vidioc_g_parm(struct file *filp, void *priv,
+		struct v4l2_streamparm *parms)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, g_parm, parms);
+	mutex_unlock(&cam->s_mutex);
+	parms->parm.capture.readbuffers = n_dma_bufs;
+	return ret;
+}
+
+static int mcam_vidioc_s_parm(struct file *filp, void *priv,
+		struct v4l2_streamparm *parms)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, s_parm, parms);
+	mutex_unlock(&cam->s_mutex);
+	parms->parm.capture.readbuffers = n_dma_bufs;
+	return ret;
+}
+
+static int mcam_vidioc_g_chip_ident(struct file *file, void *priv,
+		struct v4l2_dbg_chip_ident *chip)
+{
+	struct mcam_camera *cam = priv;
+
+	chip->ident = V4L2_IDENT_NONE;
+	chip->revision = 0;
+	if (v4l2_chip_match_host(&chip->match)) {
+		chip->ident = V4L2_IDENT_CAFE;  /* FIXME */
+		return 0;
+	}
+	return sensor_call(cam, core, g_chip_ident, chip);
+}
+
+static int mcam_vidioc_enum_framesizes(struct file *filp, void *priv,
+		struct v4l2_frmsizeenum *sizes)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, enum_framesizes, sizes);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+static int mcam_vidioc_enum_frameintervals(struct file *filp, void *priv,
+		struct v4l2_frmivalenum *interval)
+{
+	struct mcam_camera *cam = priv;
+	int ret;
+
+	mutex_lock(&cam->s_mutex);
+	ret = sensor_call(cam, video, enum_frameintervals, interval);
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int mcam_vidioc_g_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg)
+{
+	struct mcam_camera *cam = priv;
+
+	if (v4l2_chip_match_host(&reg->match)) {
+		reg->val = mcam_reg_read(cam, reg->reg);
+		reg->size = 4;
+		return 0;
+	}
+	return sensor_call(cam, core, g_register, reg);
+}
+
+static int mcam_vidioc_s_register(struct file *file, void *priv,
+		struct v4l2_dbg_register *reg)
+{
+	struct mcam_camera *cam = priv;
+
+	if (v4l2_chip_match_host(&reg->match)) {
+		mcam_reg_write(cam, reg->reg, reg->val);
+		return 0;
+	}
+	return sensor_call(cam, core, s_register, reg);
+}
+#endif
+
+/*
+ * This template device holds all of those v4l2 methods; we
+ * clone it for specific real devices.
+ */
+
+static const struct v4l2_file_operations mcam_v4l_fops = {
+	.owner = THIS_MODULE,
+	.open = mcam_v4l_open,
+	.release = mcam_v4l_release,
+	.read = mcam_v4l_read,
+	.poll = mcam_v4l_poll,
+	.mmap = mcam_v4l_mmap,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
+	.vidioc_querycap	= mcam_vidioc_querycap,
+	.vidioc_enum_fmt_vid_cap = mcam_vidioc_enum_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap	= mcam_vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	= mcam_vidioc_s_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	= mcam_vidioc_g_fmt_vid_cap,
+	.vidioc_enum_input	= mcam_vidioc_enum_input,
+	.vidioc_g_input		= mcam_vidioc_g_input,
+	.vidioc_s_input		= mcam_vidioc_s_input,
+	.vidioc_s_std		= mcam_vidioc_s_std,
+	.vidioc_reqbufs		= mcam_vidioc_reqbufs,
+	.vidioc_querybuf	= mcam_vidioc_querybuf,
+	.vidioc_qbuf		= mcam_vidioc_qbuf,
+	.vidioc_dqbuf		= mcam_vidioc_dqbuf,
+	.vidioc_streamon	= mcam_vidioc_streamon,
+	.vidioc_streamoff	= mcam_vidioc_streamoff,
+	.vidioc_queryctrl	= mcam_vidioc_queryctrl,
+	.vidioc_g_ctrl		= mcam_vidioc_g_ctrl,
+	.vidioc_s_ctrl		= mcam_vidioc_s_ctrl,
+	.vidioc_g_parm		= mcam_vidioc_g_parm,
+	.vidioc_s_parm		= mcam_vidioc_s_parm,
+	.vidioc_enum_framesizes = mcam_vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals = mcam_vidioc_enum_frameintervals,
+	.vidioc_g_chip_ident	= mcam_vidioc_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register	= mcam_vidioc_g_register,
+	.vidioc_s_register	= mcam_vidioc_s_register,
+#endif
+};
+
+static struct video_device mcam_v4l_template = {
+	.name = "mcam",
+	.tvnorms = V4L2_STD_NTSC_M,
+	.current_norm = V4L2_STD_NTSC_M,  /* make mplayer happy */
+
+	.fops = &mcam_v4l_fops,
+	.ioctl_ops = &mcam_v4l_ioctl_ops,
+	.release = video_device_release_empty,
+};
+
+/* ---------------------------------------------------------------------- */
+/*
+ * Interrupt handler stuff
+ */
+
+
+
+static void mcam_frame_tasklet(unsigned long data)
+{
+	struct mcam_camera *cam = (struct mcam_camera *) data;
+	int i;
+	unsigned long flags;
+	struct mcam_sio_buffer *sbuf;
+
+	spin_lock_irqsave(&cam->dev_lock, flags);
+	for (i = 0; i < cam->nbufs; i++) {
+		int bufno = cam->next_buf;
+		if (bufno < 0) {  /* "will never happen" */
+			cam_err(cam, "No valid bufs in tasklet!\n");
+			break;
+		}
+		if (++(cam->next_buf) >= cam->nbufs)
+			cam->next_buf = 0;
+		if (!test_bit(bufno, &cam->flags))
+			continue;
+		if (list_empty(&cam->sb_avail))
+			break;  /* Leave it valid, hope for better later */
+		clear_bit(bufno, &cam->flags);
+		sbuf = list_entry(cam->sb_avail.next,
+				struct mcam_sio_buffer, list);
+		/*
+		 * Drop the lock during the big copy.  This *should* be safe...
+		 */
+		spin_unlock_irqrestore(&cam->dev_lock, flags);
+		memcpy(sbuf->buffer, cam->dma_bufs[bufno],
+				cam->pix_format.sizeimage);
+		sbuf->v4lbuf.bytesused = cam->pix_format.sizeimage;
+		sbuf->v4lbuf.sequence = cam->buf_seq[bufno];
+		sbuf->v4lbuf.flags &= ~V4L2_BUF_FLAG_QUEUED;
+		sbuf->v4lbuf.flags |= V4L2_BUF_FLAG_DONE;
+		spin_lock_irqsave(&cam->dev_lock, flags);
+		list_move_tail(&sbuf->list, &cam->sb_full);
+	}
+	if (!list_empty(&cam->sb_full))
+		wake_up(&cam->iowait);
+	spin_unlock_irqrestore(&cam->dev_lock, flags);
+}
+
+
+
+static void mcam_frame_complete(struct mcam_camera *cam, int frame)
+{
+	/*
+	 * Basic frame housekeeping.
+	 */
+	if (test_bit(frame, &cam->flags) && printk_ratelimit())
+		cam_err(cam, "Frame overrun on %d, frames lost\n", frame);
+	set_bit(frame, &cam->flags);
+	clear_bit(CF_DMA_ACTIVE, &cam->flags);
+	if (cam->next_buf < 0)
+		cam->next_buf = frame;
+	cam->buf_seq[frame] = ++(cam->sequence);
+
+	switch (cam->state) {
+	/*
+	 * If in single read mode, try going speculative.
+	 */
+	case S_SINGLEREAD:
+		cam->state = S_SPECREAD;
+		cam->specframes = 0;
+		wake_up(&cam->iowait);
+		break;
+
+	/*
+	 * If we are already doing speculative reads, and nobody is
+	 * reading them, just stop.
+	 */
+	case S_SPECREAD:
+		if (++(cam->specframes) >= cam->nbufs) {
+			mcam_ctlr_stop(cam);
+			mcam_ctlr_irq_disable(cam);
+			cam->state = S_IDLE;
+		}
+		wake_up(&cam->iowait);
+		break;
+	/*
+	 * For the streaming case, we defer the real work to the
+	 * camera tasklet.
+	 *
+	 * FIXME: if the application is not consuming the buffers,
+	 * we should eventually put things on hold and restart in
+	 * vidioc_dqbuf().
+	 */
+	case S_STREAMING:
+		tasklet_schedule(&cam->s_tasklet);
+		break;
+
+	default:
+		cam_err(cam, "Frame interrupt in non-operational state\n");
+		break;
+	}
+}
+
+
+
+
+int mccic_irq(struct mcam_camera *cam, unsigned int irqs)
+{
+	unsigned int frame, handled = 0;
+
+	mcam_reg_write(cam, REG_IRQSTAT, FRAMEIRQS); /* Clear'em all */
+	/*
+	 * Handle any frame completions.  There really should
+	 * not be more than one of these, or we have fallen
+	 * far behind.
+	 */
+	for (frame = 0; frame < cam->nbufs; frame++)
+		if (irqs & (IRQ_EOF0 << frame)) {
+			mcam_frame_complete(cam, frame);
+			handled = 1;
+		}
+	/*
+	 * If a frame starts, note that we have DMA active.  This
+	 * code assumes that we won't get multiple frame interrupts
+	 * at once; may want to rethink that.
+	 */
+	if (irqs & (IRQ_SOF0 | IRQ_SOF1 | IRQ_SOF2)) {
+		set_bit(CF_DMA_ACTIVE, &cam->flags);
+		handled = 1;
+	}
+	return handled;
+}
+
+/*
+ * Registration and such.
+ */
+
+/* FIXME this is really platform stuff */
+static const struct dmi_system_id olpc_xo1_dmi[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "OLPC"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "1"),
+		},
+	},
+	{ }
+};
+
+static struct ov7670_config sensor_cfg = {
+	/* This controller only does SMBUS */
+	.use_smbus = true,
+
+	/*
+	 * Exclude QCIF mode, because it only captures a tiny portion
+	 * of the sensor FOV
+	 */
+	.min_width = 320,
+	.min_height = 240,
+};
+
+
+int mccic_register(struct mcam_camera *cam)
+{
+	struct i2c_board_info ov7670_info = {
+		.type = "ov7670",
+		.addr = 0x42,
+		.platform_data = &sensor_cfg,
+	};
+	int ret;
+
+	/*
+	 * Register with V4L
+	 */
+	ret = v4l2_device_register(cam->dev, &cam->v4l2_dev);
+	if (ret)
+		return ret;
+
+	mutex_init(&cam->s_mutex);
+	cam->state = S_NOTREADY;
+	mcam_set_config_needed(cam, 1);
+	init_waitqueue_head(&cam->iowait);
+	cam->pix_format = mcam_def_pix_format;
+	cam->mbus_code = mcam_def_mbus_code;
+	INIT_LIST_HEAD(&cam->dev_list);
+	INIT_LIST_HEAD(&cam->sb_avail);
+	INIT_LIST_HEAD(&cam->sb_full);
+	tasklet_init(&cam->s_tasklet, mcam_frame_tasklet, (unsigned long) cam);
+
+	mcam_ctlr_init(cam);
+
+	/* Apply XO-1 clock speed */
+	if (dmi_check_system(olpc_xo1_dmi))
+		sensor_cfg.clock_speed = 45;
+
+	/*
+	 * Try to find the sensor.
+	 */
+	cam->sensor_addr = ov7670_info.addr;
+	cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
+			&cam->i2c_adapter, &ov7670_info, NULL);
+	if (cam->sensor == NULL) {
+		ret = -ENODEV;
+		goto out_unregister;
+	}
+
+	ret = mcam_cam_init(cam);
+	if (ret)
+		goto out_unregister;
+	/*
+	 * Get the v4l2 setup done.
+	 */
+	mutex_lock(&cam->s_mutex);
+	cam->vdev = mcam_v4l_template;
+	cam->vdev.debug = 0;
+	cam->vdev.v4l2_dev = &cam->v4l2_dev;
+	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
+	if (ret)
+		goto out;
+	video_set_drvdata(&cam->vdev, cam);
+
+	/*
+	 * If so requested, try to get our DMA buffers now.
+	 */
+	if (!alloc_bufs_at_read) {
+		if (mcam_alloc_dma_bufs(cam, 1))
+			cam_warn(cam, "Unable to alloc DMA buffers at load"
+					" will try again later.");
+	}
+
+out:
+	mutex_unlock(&cam->s_mutex);
+	return ret;
+out_unregister:
+	v4l2_device_unregister(&cam->v4l2_dev);
+	return ret;
+}
+
+
+void mccic_shutdown(struct mcam_camera *cam)
+{
+	if (cam->users > 0)
+		cam_warn(cam, "Removing a device with users!\n");
+	if (cam->n_sbufs > 0)
+		/* What if they are still mapped?  Shouldn't be, but... */
+		mcam_free_sio_buffers(cam);
+	mcam_ctlr_stop_dma(cam);
+	mcam_ctlr_power_down(cam);
+	mcam_free_dma_bufs(cam);
+	video_unregister_device(&cam->vdev);
+	v4l2_device_unregister(&cam->v4l2_dev);
+}
+
+/*
+ * Power management
+ */
+#ifdef CONFIG_PM
+
+void mccic_suspend(struct mcam_camera *cam)
+{
+	enum mcam_state cstate = cam->state;
+
+	mcam_ctlr_stop_dma(cam);
+	mcam_ctlr_power_down(cam);
+	cam->state = cstate;
+}
+
+int mccic_resume(struct mcam_camera *cam)
+{
+	int ret = 0;
+
+	mutex_lock(&cam->s_mutex);
+	if (cam->users > 0) {
+		mcam_ctlr_power_up(cam);
+		__mcam_cam_reset(cam);
+	} else {
+		mcam_ctlr_power_down(cam);
+	}
+	mutex_unlock(&cam->s_mutex);
+
+	set_bit(CF_CONFIG_NEEDED, &cam->flags);
+	if (cam->state == S_SPECREAD)
+		cam->state = S_IDLE;  /* Don't bother restarting */
+	else if (cam->state == S_SINGLEREAD || cam->state == S_STREAMING)
+		ret = mcam_read_setup(cam, cam->state);
+	return ret;
+}
+#endif /* CONFIG_PM */
diff --git a/drivers/media/video/marvell-ccic/mcam-core.h b/drivers/media/video/marvell-ccic/mcam-core.h
new file mode 100644
index 0000000..6258df8
--- /dev/null
+++ b/drivers/media/video/marvell-ccic/mcam-core.h
@@ -0,0 +1,319 @@
+/*
+ * Marvell camera core structures.
+ *
+ * Copyright 2011 Jonathan Corbet corbet@lwn.net
+ */
+
+/*
+ * Tracking of streaming I/O buffers.
+ * FIXME doesn't belong in this file
+ */
+struct mcam_sio_buffer {
+	struct list_head list;
+	struct v4l2_buffer v4lbuf;
+	char *buffer;   /* Where it lives in kernel space */
+	int mapcount;
+	struct mcam_camera *cam;
+};
+
+enum mcam_state {
+	S_NOTREADY,	/* Not yet initialized */
+	S_IDLE,		/* Just hanging around */
+	S_FLAKED,	/* Some sort of problem */
+	S_SINGLEREAD,	/* In read() */
+	S_SPECREAD,	/* Speculative read (for future read()) */
+	S_STREAMING	/* Streaming data */
+};
+#define MAX_DMA_BUFS 3
+
+/*
+ * Which platform are we running on?
+ */
+enum mcam_host_plat {
+	MHP_Cafe,	/* OLPC XO 1 w/Cafe controller */
+	MHP_Armada610,	/* Armada 610 processor (XO 1.75) */
+};
+
+/*
+ * A description of one of our devices.
+ * Locking: controlled by s_mutex.  Certain fields, however, require
+ *          the dev_lock spinlock; they are marked as such by comments.
+ *          dev_lock is also required for access to device registers.
+ */
+struct mcam_camera {
+	/*
+	 * These fields should be set by the platform code prior to
+	 * calling mcam_register().
+	 */
+	struct i2c_adapter i2c_adapter;
+	unsigned char __iomem *regs;
+	spinlock_t dev_lock;
+	struct device *dev; /* For messages, dma alloc */
+	enum mcam_host_plat platform;
+
+	/*
+	 * Callbacks from the core to the platform code.
+	 */
+	void (*plat_power_up) (struct mcam_camera *cam);
+	void (*plat_power_down) (struct mcam_camera *cam);
+
+	/*
+	 * Everything below here is private to the mcam core and
+	 * should not be touched by the platform code.
+	 */
+	struct v4l2_device v4l2_dev;
+	enum mcam_state state;
+	unsigned long flags;		/* Buffer status, mainly (dev_lock) */
+	int users;			/* How many open FDs */
+	struct file *owner;		/* Who has data access (v4l2) */
+
+	/*
+	 * Subsystem structures.
+	 */
+	struct video_device vdev;
+	struct v4l2_subdev *sensor;
+	unsigned short sensor_addr;
+
+	struct list_head dev_list;	/* link to other devices */
+
+	/* DMA buffers */
+	unsigned int nbufs;		/* How many are alloc'd */
+	int next_buf;			/* Next to consume (dev_lock) */
+	unsigned int dma_buf_size;	/* allocated size */
+	void *dma_bufs[MAX_DMA_BUFS];	/* Internal buffer addresses */
+	dma_addr_t dma_handles[MAX_DMA_BUFS]; /* Buffer bus addresses */
+	unsigned int specframes;	/* Unconsumed spec frames (dev_lock) */
+	unsigned int sequence;		/* Frame sequence number */
+	unsigned int buf_seq[MAX_DMA_BUFS]; /* Sequence for individual buffers */
+
+	/* Streaming buffers */
+	unsigned int n_sbufs;		/* How many we have */
+	struct mcam_sio_buffer *sb_bufs; /* The array of housekeeping structs */
+	struct list_head sb_avail;	/* Available for data (we own) (dev_lock) */
+	struct list_head sb_full;	/* With data (user space owns) (dev_lock) */
+	struct tasklet_struct s_tasklet;
+
+	/* Current operating parameters */
+	u32 sensor_type;		/* Currently ov7670 only */
+	struct v4l2_pix_format pix_format;
+	enum v4l2_mbus_pixelcode mbus_code;
+
+	/* Locks */
+	struct mutex s_mutex; /* Access to this structure */
+
+	/* Misc */
+	wait_queue_head_t iowait;	/* Waiting on frame data */
+};
+
+
+/*
+ * Register I/O functions.  These are here because the platform code
+ * may legitimately need to mess with the register space.
+ */
+/*
+ * Device register I/O
+ */
+static inline void mcam_reg_write(struct mcam_camera *cam, unsigned int reg,
+		unsigned int val)
+{
+	iowrite32(val, cam->regs + reg);
+}
+
+static inline unsigned int mcam_reg_read(struct mcam_camera *cam,
+		unsigned int reg)
+{
+	return ioread32(cam->regs + reg);
+}
+
+
+static inline void mcam_reg_write_mask(struct mcam_camera *cam, unsigned int reg,
+		unsigned int val, unsigned int mask)
+{
+	unsigned int v = mcam_reg_read(cam, reg);
+
+	v = (v & ~mask) | (val & mask);
+	mcam_reg_write(cam, reg, v);
+}
+
+static inline void mcam_reg_clear_bit(struct mcam_camera *cam,
+		unsigned int reg, unsigned int val)
+{
+	mcam_reg_write_mask(cam, reg, 0, val);
+}
+
+static inline void mcam_reg_set_bit(struct mcam_camera *cam,
+		unsigned int reg, unsigned int val)
+{
+	mcam_reg_write_mask(cam, reg, val, val);
+}
+
+/*
+ * Functions for use by platform code.
+ */
+int mccic_register(struct mcam_camera *cam);
+int mccic_irq(struct mcam_camera *cam, unsigned int irqs);
+void mccic_shutdown(struct mcam_camera *cam);
+#ifdef CONFIG_PM
+void mccic_suspend(struct mcam_camera *cam);
+int mccic_resume(struct mcam_camera *cam);
+#endif
+
+/*
+ * Register definitions for the m88alp01 camera interface.  Offsets in bytes
+ * as given in the spec.
+ */
+#define REG_Y0BAR	0x00
+#define REG_Y1BAR	0x04
+#define REG_Y2BAR	0x08
+/* ... */
+
+#define REG_IMGPITCH	0x24	/* Image pitch register */
+#define   IMGP_YP_SHFT	  2		/* Y pitch params */
+#define   IMGP_YP_MASK	  0x00003ffc	/* Y pitch field */
+#define	  IMGP_UVP_SHFT	  18		/* UV pitch (planar) */
+#define   IMGP_UVP_MASK   0x3ffc0000
+#define REG_IRQSTATRAW	0x28	/* RAW IRQ Status */
+#define   IRQ_EOF0	  0x00000001	/* End of frame 0 */
+#define   IRQ_EOF1	  0x00000002	/* End of frame 1 */
+#define   IRQ_EOF2	  0x00000004	/* End of frame 2 */
+#define   IRQ_SOF0	  0x00000008	/* Start of frame 0 */
+#define   IRQ_SOF1	  0x00000010	/* Start of frame 1 */
+#define   IRQ_SOF2	  0x00000020	/* Start of frame 2 */
+#define   IRQ_OVERFLOW	  0x00000040	/* FIFO overflow */
+#define   IRQ_TWSIW	  0x00010000	/* TWSI (smbus) write */
+#define   IRQ_TWSIR	  0x00020000	/* TWSI read */
+#define   IRQ_TWSIE	  0x00040000	/* TWSI error */
+#define   TWSIIRQS (IRQ_TWSIW|IRQ_TWSIR|IRQ_TWSIE)
+#define   FRAMEIRQS (IRQ_EOF0|IRQ_EOF1|IRQ_EOF2|IRQ_SOF0|IRQ_SOF1|IRQ_SOF2)
+#define   ALLIRQS (TWSIIRQS|FRAMEIRQS|IRQ_OVERFLOW)
+#define REG_IRQMASK	0x2c	/* IRQ mask - same bits as IRQSTAT */
+#define REG_IRQSTAT	0x30	/* IRQ status / clear */
+
+#define REG_IMGSIZE	0x34	/* Image size */
+#define  IMGSZ_V_MASK	  0x1fff0000
+#define  IMGSZ_V_SHIFT	  16
+#define	 IMGSZ_H_MASK	  0x00003fff
+#define REG_IMGOFFSET	0x38	/* IMage offset */
+
+#define REG_CTRL0	0x3c	/* Control 0 */
+#define   C0_ENABLE	  0x00000001	/* Makes the whole thing go */
+
+/* Mask for all the format bits */
+#define   C0_DF_MASK	  0x00fffffc    /* Bits 2-23 */
+
+/* RGB ordering */
+#define	  C0_RGB4_RGBX	  0x00000000
+#define	  C0_RGB4_XRGB	  0x00000004
+#define	  C0_RGB4_BGRX	  0x00000008
+#define	  C0_RGB4_XBGR	  0x0000000c
+#define	  C0_RGB5_RGGB	  0x00000000
+#define	  C0_RGB5_GRBG	  0x00000004
+#define	  C0_RGB5_GBRG	  0x00000008
+#define	  C0_RGB5_BGGR	  0x0000000c
+
+/* Spec has two fields for DIN and DOUT, but they must match, so
+   combine them here. */
+#define	  C0_DF_YUV	  0x00000000	/* Data is YUV	    */
+#define	  C0_DF_RGB	  0x000000a0	/* ... RGB		    */
+#define	  C0_DF_BAYER	  0x00000140	/* ... Bayer		    */
+/* 8-8-8 must be missing from the below - ask */
+#define	  C0_RGBF_565	  0x00000000
+#define	  C0_RGBF_444	  0x00000800
+#define	  C0_RGB_BGR	  0x00001000	/* Blue comes first */
+#define	  C0_YUV_PLANAR	  0x00000000	/* YUV 422 planar format */
+#define	  C0_YUV_PACKED	  0x00008000	/* YUV 422 packed	*/
+#define	  C0_YUV_420PL	  0x0000a000	/* YUV 420 planar	*/
+/* Think that 420 packed must be 111 - ask */
+#define	  C0_YUVE_YUYV	  0x00000000	/* Y1CbY0Cr		*/
+#define	  C0_YUVE_YVYU	  0x00010000	/* Y1CrY0Cb		*/
+#define	  C0_YUVE_VYUY	  0x00020000	/* CrY1CbY0		*/
+#define	  C0_YUVE_UYVY	  0x00030000	/* CbY1CrY0		*/
+#define	  C0_YUVE_XYUV	  0x00000000	/* 420: .YUV		*/
+#define	  C0_YUVE_XYVU	  0x00010000	/* 420: .YVU		*/
+#define	  C0_YUVE_XUVY	  0x00020000	/* 420: .UVY		*/
+#define	  C0_YUVE_XVUY	  0x00030000	/* 420: .VUY		*/
+/* Bayer bits 18,19 if needed */
+#define	  C0_HPOL_LOW	  0x01000000	/* HSYNC polarity active low */
+#define	  C0_VPOL_LOW	  0x02000000	/* VSYNC polarity active low */
+#define	  C0_VCLK_LOW	  0x04000000	/* VCLK on falling edge */
+#define	  C0_DOWNSCALE	  0x08000000	/* Enable downscaler */
+#define	  C0_SIFM_MASK	  0xc0000000	/* SIF mode bits */
+#define	  C0_SIF_HVSYNC	  0x00000000	/* Use H/VSYNC */
+#define	  CO_SOF_NOSYNC	  0x40000000	/* Use inband active signaling */
+
+
+#define REG_CTRL1	0x40	/* Control 1 */
+#define	  C1_444ALPHA	  0x00f00000	/* Alpha field in RGB444 */
+#define	  C1_ALPHA_SHFT	  20
+#define	  C1_DMAB32	  0x00000000	/* 32-byte DMA burst */
+#define	  C1_DMAB16	  0x02000000	/* 16-byte DMA burst */
+#define	  C1_DMAB64	  0x04000000	/* 64-byte DMA burst */
+#define	  C1_DMAB_MASK	  0x06000000
+#define	  C1_TWOBUFS	  0x08000000	/* Use only two DMA buffers */
+#define	  C1_PWRDWN	  0x10000000	/* Power down */
+
+#define REG_CLKCTRL	0x88	/* Clock control */
+#define	  CLK_DIV_MASK	  0x0000ffff	/* Upper bits RW "reserved" */
+
+#define REG_GPR		0xb4	/* General purpose register.  This
+				   controls inputs to the power and reset
+				   pins on the OV7670 used with OLPC;
+				   other deployments could differ.  */
+#define	  GPR_C1EN	  0x00000020	/* Pad 1 (power down) enable */
+#define	  GPR_C0EN	  0x00000010	/* Pad 0 (reset) enable */
+#define	  GPR_C1	  0x00000002	/* Control 1 value */
+/*
+ * Control 0 is wired to reset on OLPC machines.  For ov7x sensors,
+ * it is active low, for 0v6x, instead, it's active high.  What
+ * fun.
+ */
+#define	  GPR_C0	  0x00000001	/* Control 0 value */
+
+#define REG_TWSIC0	0xb8	/* TWSI (smbus) control 0 */
+#define	  TWSIC0_EN	  0x00000001	/* TWSI enable */
+#define	  TWSIC0_MODE	  0x00000002	/* 1 = 16-bit, 0 = 8-bit */
+#define	  TWSIC0_SID	  0x000003fc	/* Slave ID */
+#define	  TWSIC0_SID_SHIFT 2
+#define	  TWSIC0_CLKDIV	  0x0007fc00	/* Clock divider */
+#define	  TWSIC0_MASKACK  0x00400000	/* Mask ack from sensor */
+#define	  TWSIC0_OVMAGIC  0x00800000	/* Make it work on OV sensors */
+
+#define REG_TWSIC1	0xbc	/* TWSI control 1 */
+#define	  TWSIC1_DATA	  0x0000ffff	/* Data to/from camchip */
+#define	  TWSIC1_ADDR	  0x00ff0000	/* Address (register) */
+#define	  TWSIC1_ADDR_SHIFT 16
+#define	  TWSIC1_READ	  0x01000000	/* Set for read op */
+#define	  TWSIC1_WSTAT	  0x02000000	/* Write status */
+#define	  TWSIC1_RVALID	  0x04000000	/* Read data valid */
+#define	  TWSIC1_ERROR	  0x08000000	/* Something screwed up */
+
+
+#define REG_UBAR	0xc4	/* Upper base address register */
+
+/*
+ * Here's the weird global control registers which are said to live
+ * way up here.
+ */
+#define REG_GL_CSR     0x3004  /* Control/status register */
+#define	  GCSR_SRS	 0x00000001	/* SW Reset set */
+#define	  GCSR_SRC	 0x00000002	/* SW Reset clear */
+#define	  GCSR_MRS	 0x00000004	/* Master reset set */
+#define	  GCSR_MRC	 0x00000008	/* HW Reset clear */
+#define	  GCSR_CCIC_EN	 0x00004000    /* CCIC Clock enable */
+#define REG_GL_IMASK   0x300c  /* Interrupt mask register */
+#define	  GIMSK_CCIC_EN		 0x00000004    /* CCIC Interrupt enable */
+
+#define REG_GL_FCR	0x3038	/* GPIO functional control register */
+#define	  GFCR_GPIO_ON	  0x08		/* Camera GPIO enabled */
+#define REG_GL_GPIOR	0x315c	/* GPIO register */
+#define	  GGPIO_OUT		0x80000	/* GPIO output */
+#define	  GGPIO_VAL		0x00008	/* Output pin value */
+
+#define REG_LEN		       (REG_GL_IMASK + 4)
+
+
+/*
+ * Useful stuff that probably belongs somewhere global.
+ */
+#define VGA_WIDTH	640
+#define VGA_HEIGHT	480
-- 
1.7.5.2

