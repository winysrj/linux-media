Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36710 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbcCDTL4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2016 14:11:56 -0500
Received: by mail-wm0-f43.google.com with SMTP id n186so4214880wmn.1
        for <linux-media@vger.kernel.org>; Fri, 04 Mar 2016 11:11:56 -0800 (PST)
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: nuvoton: switch attribute wakeup_data to text
Message-ID: <56D9DDEC.8090204@gmail.com>
Date: Fri, 4 Mar 2016 20:11:40 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch attribute wakeup_data from binary to a text attribute.
This makes it easier to handle in userspace and allows to
use the output of tools like mode2 almost as is to set a
wakeup sequence.
Changing to a text format and values in microseconds also
makes the userspace interface independent of the setting of
SAMPLE_PERIOD in the driver.

In addition document the new sysfs attribute in
Documentation/ABI/testing/sysfs-class-rc-nuvoton.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 Documentation/ABI/testing/sysfs-class-rc-nuvoton | 15 +++++
 drivers/media/rc/nuvoton-cir.c                   | 85 +++++++++++++++---------
 2 files changed, 68 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-rc-nuvoton

diff --git a/Documentation/ABI/testing/sysfs-class-rc-nuvoton b/Documentation/ABI/testing/sysfs-class-rc-nuvoton
new file mode 100644
index 0000000..905bcde
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-rc-nuvoton
@@ -0,0 +1,15 @@
+What:		/sys/class/rc/rcN/wakeup_data
+Date:		Mar 2016
+KernelVersion:	4.6
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
+Description:
+		Reading this file returns the stored CIR wakeup sequence.
+		It starts with a pulse, followed by a space, pulse etc.
+		All values are in microseconds.
+		The same format can be used to store a wakeup sequence
+		in the Nuvoton chip by writing to this file.
+
+		Note: Some systems reset the stored wakeup sequence to a
+		factory default on each boot. On such systems store the
+		wakeup sequence in a file and set it on boot using e.g.
+		a udev rule.
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index c2ee5bd..99b303b 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -179,55 +179,74 @@ static void nvt_set_ioaddr(struct nvt_dev *nvt, unsigned long *ioaddr)
 	}
 }
 
-static ssize_t wakeup_data_read(struct file *fp, struct kobject *kobj,
-				struct bin_attribute *bin_attr,
-				char *buf, loff_t off, size_t count)
+static ssize_t wakeup_data_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
 {
-	struct device *dev = kobj_to_dev(kobj);
 	struct rc_dev *rc_dev = to_rc_dev(dev);
 	struct nvt_dev *nvt = rc_dev->priv;
-	int fifo_len, len;
+	int fifo_len, duration;
 	unsigned long flags;
+	ssize_t buf_len = 0;
 	int i;
 
 	spin_lock_irqsave(&nvt->nvt_lock, flags);
 
 	fifo_len = nvt_cir_wake_reg_read(nvt, CIR_WAKE_FIFO_COUNT);
-	len = min(fifo_len, WAKEUP_MAX_SIZE);
-
-	if (off >= len) {
-		spin_unlock_irqrestore(&nvt->nvt_lock, flags);
-		return 0;
-	}
-
-	if (len > count)
-		len = count;
+	fifo_len = min(fifo_len, WAKEUP_MAX_SIZE);
 
 	/* go to first element to be read */
-	while (nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY_IDX) != off)
+	while (nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY_IDX))
 		nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY);
 
-	for (i = 0; i < len; i++)
-		buf[i] = nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY);
+	for (i = 0; i < fifo_len; i++) {
+		duration = nvt_cir_wake_reg_read(nvt, CIR_WAKE_RD_FIFO_ONLY);
+		duration = (duration & BUF_LEN_MASK) * SAMPLE_PERIOD;
+		buf_len += snprintf(buf + buf_len, PAGE_SIZE - buf_len,
+				    "%d ", duration);
+	}
+	buf_len += snprintf(buf + buf_len, PAGE_SIZE - buf_len, "\n");
 
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
-	return len;
+	return buf_len;
 }
 
-static ssize_t wakeup_data_write(struct file *fp, struct kobject *kobj,
-				struct bin_attribute *bin_attr,
-				char *buf, loff_t off, size_t count)
+static ssize_t wakeup_data_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t len)
 {
-	struct device *dev = kobj_to_dev(kobj);
 	struct rc_dev *rc_dev = to_rc_dev(dev);
 	struct nvt_dev *nvt = rc_dev->priv;
 	unsigned long flags;
-	u8 tolerance, config;
-	int i;
+	u8 tolerance, config, wake_buf[WAKEUP_MAX_SIZE];
+	char **argv;
+	int i, count;
+	unsigned int val;
+	ssize_t ret;
+
+	argv = argv_split(GFP_KERNEL, buf, &count);
+	if (!argv)
+		return -ENOMEM;
+	if (!count || count > WAKEUP_MAX_SIZE) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (off > 0)
-		return -EINVAL;
+	for (i = 0; i < count; i++) {
+		ret = kstrtouint(argv[i], 10, &val);
+		if (ret)
+			goto out;
+		val = DIV_ROUND_CLOSEST(val, SAMPLE_PERIOD);
+		if (!val || val > 0x7f) {
+			ret = -EINVAL;
+			goto out;
+		}
+		wake_buf[i] = val;
+		/* sequence must start with a pulse */
+		if (i % 2 == 0)
+			wake_buf[i] |= BUF_PULSE_BIT;
+	}
 
 	/* hardcode the tolerance to 10% */
 	tolerance = DIV_ROUND_UP(count, 10);
@@ -245,16 +264,18 @@ static ssize_t wakeup_data_write(struct file *fp, struct kobject *kobj,
 			       CIR_WAKE_IRCON);
 
 	for (i = 0; i < count; i++)
-		nvt_cir_wake_reg_write(nvt, buf[i], CIR_WAKE_WR_FIFO_DATA);
+		nvt_cir_wake_reg_write(nvt, wake_buf[i], CIR_WAKE_WR_FIFO_DATA);
 
 	nvt_cir_wake_reg_write(nvt, config, CIR_WAKE_IRCON);
 
 	spin_unlock_irqrestore(&nvt->nvt_lock, flags);
 
-	return count;
+	ret = len;
+out:
+	argv_free(argv);
+	return ret;
 }
-
-static BIN_ATTR_RW(wakeup_data, WAKEUP_MAX_SIZE);
+static DEVICE_ATTR_RW(wakeup_data);
 
 /* dump current cir register contents */
 static void cir_dump_regs(struct nvt_dev *nvt)
@@ -1212,7 +1233,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
 			     NVT_DRIVER_NAME "-wake", (void *)nvt))
 		goto exit_unregister_device;
 
-	ret = device_create_bin_file(&rdev->dev, &bin_attr_wakeup_data);
+	ret = device_create_file(&rdev->dev, &dev_attr_wakeup_data);
 	if (ret)
 		goto exit_unregister_device;
 
@@ -1239,7 +1260,7 @@ static void nvt_remove(struct pnp_dev *pdev)
 {
 	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
 
-	device_remove_bin_file(&nvt->rdev->dev, &bin_attr_wakeup_data);
+	device_remove_file(&nvt->rdev->dev, &dev_attr_wakeup_data);
 
 	nvt_disable_cir(nvt);
 
-- 
2.7.1

