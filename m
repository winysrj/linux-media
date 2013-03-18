Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3744 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3CRMch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 01/19] solo6x10: sync to latest code from Bluecherry's git repo.
Date: Mon, 18 Mar 2013 13:32:00 +0100
Message-Id: <1363609938-21735-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Synced to commit e9815ac5503ae60cfbf6ff8037035de8f62e2846 from
branch next in git repository https://github.com/bluecherrydvr/solo6x10.git

Only removed some code under #if LINUX_VERSION_CODE < some-kernel-version,
renamed the driver back to solo6x10 from solo6x10-edge and removed the
unnecessary compat.h header.

Otherwise the code is identical.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
---
 drivers/staging/media/solo6x10/Makefile        |    2 +-
 drivers/staging/media/solo6x10/TODO            |   36 +-
 drivers/staging/media/solo6x10/core.c          |  575 ++++++++--
 drivers/staging/media/solo6x10/disp.c          |  127 ++-
 drivers/staging/media/solo6x10/eeprom.c        |  154 +++
 drivers/staging/media/solo6x10/enc.c           |  240 +++--
 drivers/staging/media/solo6x10/g723.c          |   91 +-
 drivers/staging/media/solo6x10/gpio.c          |   13 +-
 drivers/staging/media/solo6x10/i2c.c           |   26 +-
 drivers/staging/media/solo6x10/offsets.h       |   79 +-
 drivers/staging/media/solo6x10/osd-font.h      |  154 ---
 drivers/staging/media/solo6x10/p2m.c           |  394 +++----
 drivers/staging/media/solo6x10/registers.h     |   86 +-
 drivers/staging/media/solo6x10/solo6x10-jpeg.h |   94 +-
 drivers/staging/media/solo6x10/solo6x10.h      |  196 ++--
 drivers/staging/media/solo6x10/tw28.c          |  171 +--
 drivers/staging/media/solo6x10/tw28.h          |   11 +-
 drivers/staging/media/solo6x10/v4l2-enc.c      | 1370 ++++++++++++------------
 drivers/staging/media/solo6x10/v4l2.c          |  290 ++---
 19 files changed, 2373 insertions(+), 1736 deletions(-)
 create mode 100644 drivers/staging/media/solo6x10/eeprom.c
 delete mode 100644 drivers/staging/media/solo6x10/osd-font.h

diff --git a/drivers/staging/media/solo6x10/Makefile b/drivers/staging/media/solo6x10/Makefile
index 337e38c..9bbde29 100644
--- a/drivers/staging/media/solo6x10/Makefile
+++ b/drivers/staging/media/solo6x10/Makefile
@@ -1,3 +1,3 @@
-solo6x10-y := core.o i2c.o p2m.o v4l2.o tw28.o gpio.o disp.o enc.o v4l2-enc.o g723.o
+solo6x10-y := core.o i2c.o p2m.o v4l2.o tw28.o gpio.o disp.o enc.o v4l2-enc.o g723.o eeprom.o
 
 obj-$(CONFIG_SOLO6X10) += solo6x10.o
diff --git a/drivers/staging/media/solo6x10/TODO b/drivers/staging/media/solo6x10/TODO
index 539f739..aca9998 100644
--- a/drivers/staging/media/solo6x10/TODO
+++ b/drivers/staging/media/solo6x10/TODO
@@ -1,24 +1,12 @@
-TODO (staging => main):
-
-	* Motion detection flags need to be moved to v4l2
-	* Some private CIDs need to be moved to v4l2
-
-TODO (general):
-
-	* encoder on/off controls
-	* mpeg cid bitrate mode (vbr/cbr)
-	* mpeg cid bitrate/bitrate-peak
-	* mpeg encode of user data
-	* mpeg decode of user data
-	* switch between 4 frames/irq to 1 when using mjpeg (and then back
-	  when not)
-	* implement a CID control for motion areas/thresholds
-	* implement CID controls for mozaic areas
-	* allow for higher level of interval (for < 1 fps)
-	* sound:
-	  - implement playback via external sound jack
-	  - implement loopback of external sound jack with incoming audio?
-	  - implement pause/resume
-
-Plase send patches to Mauro Carvalho Chehab <mchehab@redhat.com> and Cc Ben Collins
-<bcollins@bluecherry.net>
+- batch up desc requests for more efficient use of p2m?
+- encoder on/off controls
+- mpeg cid bitrate mode (vbr/cbr)
+- mpeg cid bitrate/bitrate-peak
+- mpeg encode of user data
+- mpeg decode of user data
+- implement CID controls for mozaic areas
+
+- sound
+ - implement playback via external sound jack
+ - implement loopback of external sound jack with incoming audio?
+ - implement pause/resume (make use of in bc-server)
diff --git a/drivers/staging/media/solo6x10/core.c b/drivers/staging/media/solo6x10/core.c
index fd83d6d..27ae75a 100644
--- a/drivers/staging/media/solo6x10/core.c
+++ b/drivers/staging/media/solo6x10/core.c
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,29 +26,78 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
-#include <linux/slab.h>
 #include <linux/videodev2.h>
+#include <linux/delay.h>
+#include <linux/sysfs.h>
+#include <linux/ktime.h>
+
 #include "solo6x10.h"
 #include "tw28.h"
 
-MODULE_DESCRIPTION("Softlogic 6x10 MP4/H.264 Encoder/Decoder V4L2/ALSA Driver");
-MODULE_AUTHOR("Ben Collins <bcollins@bluecherry.net>");
+MODULE_DESCRIPTION("Softlogic 6x10 MPEG4/H.264/G.723 CODEC V4L2/ALSA Driver");
+MODULE_AUTHOR("Bluecherry <maintainers@bluecherrydvr.com>");
 MODULE_VERSION(SOLO6X10_VERSION);
 MODULE_LICENSE("GPL");
 
-void solo_irq_on(struct solo_dev *solo_dev, u32 mask)
+unsigned video_nr = -1;
+module_param(video_nr, uint, 0644);
+MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect (default)");
+
+static int full_eeprom; /* default is only top 64B */
+module_param(full_eeprom, uint, 0644);
+MODULE_PARM_DESC(full_eeprom, "Allow access to full 128B EEPROM (dangerous)");
+
+
+static void solo_set_time(struct solo_dev *solo_dev)
 {
-	solo_dev->irq_mask |= mask;
-	solo_reg_write(solo_dev, SOLO_IRQ_ENABLE, solo_dev->irq_mask);
+	struct timespec ts;
+
+	ktime_get_ts(&ts);
+
+	solo_reg_write(solo_dev, SOLO_TIMER_SEC, ts.tv_sec);
+	solo_reg_write(solo_dev, SOLO_TIMER_USEC, ts.tv_nsec / NSEC_PER_USEC);
 }
 
-void solo_irq_off(struct solo_dev *solo_dev, u32 mask)
+static void solo_timer_sync(struct solo_dev *solo_dev)
 {
-	solo_dev->irq_mask &= ~mask;
-	solo_reg_write(solo_dev, SOLO_IRQ_ENABLE, solo_dev->irq_mask);
+	u32 sec, usec;
+	struct timespec ts;
+	long diff;
+
+	if (solo_dev->type != SOLO_DEV_6110)
+		return;
+
+	if (++solo_dev->time_sync < 60)
+		return;
+
+	solo_dev->time_sync = 0;
+
+	sec = solo_reg_read(solo_dev, SOLO_TIMER_SEC);
+	usec = solo_reg_read(solo_dev, SOLO_TIMER_USEC);
+
+	ktime_get_ts(&ts);
+
+	diff = (long)ts.tv_sec - (long)sec;
+	diff = (diff * 1000000)
+		+ ((long)(ts.tv_nsec / NSEC_PER_USEC) - (long)usec);
+
+	if (diff > 1000 || diff < -1000) {
+		solo_set_time(solo_dev);
+	} else if (diff) {
+		long usec_lsb = solo_dev->usec_lsb;
+
+		usec_lsb -= diff / 4;
+		if (usec_lsb < 0)
+			usec_lsb = 0;
+		else if (usec_lsb > 255)
+			usec_lsb = 255;
+
+		solo_dev->usec_lsb = usec_lsb;
+		solo_reg_write(solo_dev, SOLO_TIMER_USEC_LSB,
+			       solo_dev->usec_lsb);
+	}
 }
 
-/* XXX We should check the return value of the sub-device ISR's */
 static irqreturn_t solo_isr(int irq, void *data)
 {
 	struct solo_dev *solo_dev = data;
@@ -60,11 +114,8 @@ static irqreturn_t solo_isr(int irq, void *data)
 		status &= solo_dev->irq_mask;
 	}
 
-	if (status & SOLO_IRQ_PCI_ERR) {
-		u32 err = solo_reg_read(solo_dev, SOLO_PCI_ERR);
-		solo_p2m_error_isr(solo_dev, err);
-		solo_reg_write(solo_dev, SOLO_IRQ_STAT, SOLO_IRQ_PCI_ERR);
-	}
+	if (status & SOLO_IRQ_PCI_ERR)
+		solo_p2m_error_isr(solo_dev);
 
 	for (i = 0; i < SOLO_NR_P2M; i++)
 		if (status & SOLO_IRQ_P2M(i))
@@ -73,12 +124,10 @@ static irqreturn_t solo_isr(int irq, void *data)
 	if (status & SOLO_IRQ_IIC)
 		solo_i2c_isr(solo_dev);
 
-	if (status & SOLO_IRQ_VIDEO_IN)
+	if (status & SOLO_IRQ_VIDEO_IN) {
 		solo_video_in_isr(solo_dev);
-
-	/* Call this first so enc gets detected flag set */
-	if (status & SOLO_IRQ_MOTION)
-		solo_motion_isr(solo_dev);
+		solo_timer_sync(solo_dev);
+	}
 
 	if (status & SOLO_IRQ_ENCODER)
 		solo_enc_v4l2_isr(solo_dev);
@@ -86,6 +135,9 @@ static irqreturn_t solo_isr(int irq, void *data)
 	if (status & SOLO_IRQ_G723)
 		solo_g723_isr(solo_dev);
 
+	/* Clear all interrupts handled */
+	solo_reg_write(solo_dev, SOLO_IRQ_STAT, status);
+
 	return IRQ_HANDLED;
 }
 
@@ -96,6 +148,9 @@ static void free_solo_dev(struct solo_dev *solo_dev)
 	if (!solo_dev)
 		return;
 
+	if (solo_dev->dev.parent)
+		device_unregister(&solo_dev->dev);
+
 	pdev = solo_dev->pdev;
 
 	/* If we never initialized the PCI device, then nothing else
@@ -105,21 +160,22 @@ static void free_solo_dev(struct solo_dev *solo_dev)
 		return;
 	}
 
-	/* Bring down the sub-devices first */
-	solo_g723_exit(solo_dev);
-	solo_enc_v4l2_exit(solo_dev);
-	solo_enc_exit(solo_dev);
-	solo_v4l2_exit(solo_dev);
-	solo_disp_exit(solo_dev);
-	solo_gpio_exit(solo_dev);
-	solo_p2m_exit(solo_dev);
-	solo_i2c_exit(solo_dev);
-
-	/* Now cleanup the PCI device */
 	if (solo_dev->reg_base) {
+		/* Bring down the sub-devices first */
+		solo_g723_exit(solo_dev);
+		solo_enc_v4l2_exit(solo_dev);
+		solo_enc_exit(solo_dev);
+		solo_v4l2_exit(solo_dev);
+		solo_disp_exit(solo_dev);
+		solo_gpio_exit(solo_dev);
+		solo_p2m_exit(solo_dev);
+		solo_i2c_exit(solo_dev);
+
+		/* Now cleanup the PCI device */
 		solo_irq_off(solo_dev, ~0);
 		pci_iounmap(pdev, solo_dev->reg_base);
-		free_irq(pdev->irq, solo_dev);
+		if (pdev->irq)
+			free_irq(pdev->irq, solo_dev);
 	}
 
 	pci_release_regions(pdev);
@@ -129,29 +185,346 @@ static void free_solo_dev(struct solo_dev *solo_dev)
 	kfree(solo_dev);
 }
 
-static int solo_pci_probe(struct pci_dev *pdev,
-				    const struct pci_device_id *id)
+static ssize_t eeprom_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+	unsigned short *p = (unsigned short *)buf;
+	int i;
+
+	if (count & 0x1)
+		dev_warn(dev, "EEPROM Write not aligned (truncating)\n");
+
+	if (!full_eeprom && count > 64) {
+		dev_warn(dev, "EEPROM Write truncated to 64 bytes\n");
+		count = 64;
+	} else if (full_eeprom && count > 128) {
+		dev_warn(dev, "EEPROM Write truncated to 128 bytes\n");
+		count = 128;
+	}
+
+	solo_eeprom_ewen(solo_dev, 1);
+
+	for (i = full_eeprom ? 0 : 32; i < min((int)(full_eeprom ? 64 : 32),
+					       (int)(count / 2)); i++)
+		solo_eeprom_write(solo_dev, i, cpu_to_be16(p[i]));
+
+	solo_eeprom_ewen(solo_dev, 0);
+
+	return count;
+}
+
+static ssize_t eeprom_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+	unsigned short *p = (unsigned short *)buf;
+	int count = (full_eeprom ? 128 : 64);
+	int i;
+
+	for (i = (full_eeprom ? 0 : 32); i < (count / 2); i++)
+		p[i] = be16_to_cpu(solo_eeprom_read(solo_dev, i));
+
+	return count;
+}
+
+static ssize_t video_type_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	return -EPERM;
+}
+
+static ssize_t video_type_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+
+	return sprintf(buf, "%s", solo_dev->video_type ==
+		       SOLO_VO_FMT_TYPE_NTSC ? "NTSC" : "PAL");
+}
+
+static ssize_t p2m_timeouts_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+
+	return sprintf(buf, "%d\n", solo_dev->p2m_timeouts);
+}
+
+static ssize_t sdram_size_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+
+	return sprintf(buf, "%dMegs\n", solo_dev->sdram_size >> 20);
+}
+
+static ssize_t tw28xx_show(struct device *dev,
+			   struct device_attribute *attr,
+			   char *buf)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+
+	return sprintf(buf, "tw2815[%d] tw2864[%d] tw2865[%d]\n",
+		       hweight32(solo_dev->tw2815),
+		       hweight32(solo_dev->tw2864),
+		       hweight32(solo_dev->tw2865));
+}
+
+static ssize_t input_map_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+	unsigned int val;
+	char *out = buf;
+
+	val = solo_reg_read(solo_dev, SOLO_VI_CH_SWITCH_0);
+	out += sprintf(out, "Channel 0   => Input %d\n", val & 0x1f);
+	out += sprintf(out, "Channel 1   => Input %d\n", (val >> 5) & 0x1f);
+	out += sprintf(out, "Channel 2   => Input %d\n", (val >> 10) & 0x1f);
+	out += sprintf(out, "Channel 3   => Input %d\n", (val >> 15) & 0x1f);
+	out += sprintf(out, "Channel 4   => Input %d\n", (val >> 20) & 0x1f);
+	out += sprintf(out, "Channel 5   => Input %d\n", (val >> 25) & 0x1f);
+
+	val = solo_reg_read(solo_dev, SOLO_VI_CH_SWITCH_1);
+	out += sprintf(out, "Channel 6   => Input %d\n", val & 0x1f);
+	out += sprintf(out, "Channel 7   => Input %d\n", (val >> 5) & 0x1f);
+	out += sprintf(out, "Channel 8   => Input %d\n", (val >> 10) & 0x1f);
+	out += sprintf(out, "Channel 9   => Input %d\n", (val >> 15) & 0x1f);
+	out += sprintf(out, "Channel 10  => Input %d\n", (val >> 20) & 0x1f);
+	out += sprintf(out, "Channel 11  => Input %d\n", (val >> 25) & 0x1f);
+
+	val = solo_reg_read(solo_dev, SOLO_VI_CH_SWITCH_2);
+	out += sprintf(out, "Channel 12  => Input %d\n", val & 0x1f);
+	out += sprintf(out, "Channel 13  => Input %d\n", (val >> 5) & 0x1f);
+	out += sprintf(out, "Channel 14  => Input %d\n", (val >> 10) & 0x1f);
+	out += sprintf(out, "Channel 15  => Input %d\n", (val >> 15) & 0x1f);
+	out += sprintf(out, "Spot Output => Input %d\n", (val >> 20) & 0x1f);
+
+	return out - buf;
+}
+
+static ssize_t p2m_timeout_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+	unsigned long ms;
+
+	int ret = kstrtoul(buf, 10, &ms);
+	if (ret < 0 || ms > 200)
+		return -EINVAL;
+	solo_dev->p2m_jiffies = msecs_to_jiffies(ms);
+
+	return count;
+}
+
+static ssize_t p2m_timeout_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+
+	return sprintf(buf, "%ums\n", jiffies_to_msecs(solo_dev->p2m_jiffies));
+}
+
+static ssize_t intervals_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+	char *out = buf;
+	int fps = solo_dev->fps;
+	int i;
+
+	for (i = 0; i < solo_dev->nr_chans; i++) {
+		out += sprintf(out, "Channel %d: %d/%d (0x%08x)\n",
+			       i, solo_dev->v4l2_enc[i]->interval, fps,
+			       solo_reg_read(solo_dev, SOLO_CAP_CH_INTV(i)));
+	}
+
+	return out - buf;
+}
+
+static ssize_t sdram_offsets_show(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+	char *out = buf;
+
+	out += sprintf(out, "DISP: 0x%08x @ 0x%08x\n",
+		       SOLO_DISP_EXT_ADDR,
+		       SOLO_DISP_EXT_SIZE);
+
+	out += sprintf(out, "EOSD: 0x%08x @ 0x%08x (0x%08x * %d)\n",
+		       SOLO_EOSD_EXT_ADDR,
+		       SOLO_EOSD_EXT_AREA(solo_dev),
+		       SOLO_EOSD_EXT_SIZE(solo_dev),
+		       SOLO_EOSD_EXT_AREA(solo_dev) /
+		       SOLO_EOSD_EXT_SIZE(solo_dev));
+
+	out += sprintf(out, "MOTI: 0x%08x @ 0x%08x\n",
+		       SOLO_MOTION_EXT_ADDR(solo_dev),
+		       SOLO_MOTION_EXT_SIZE);
+
+	out += sprintf(out, "G723: 0x%08x @ 0x%08x\n",
+		       SOLO_G723_EXT_ADDR(solo_dev),
+		       SOLO_G723_EXT_SIZE);
+
+	out += sprintf(out, "CAPT: 0x%08x @ 0x%08x (0x%08x * %d)\n",
+		       SOLO_CAP_EXT_ADDR(solo_dev),
+		       SOLO_CAP_EXT_SIZE(solo_dev),
+		       SOLO_CAP_PAGE_SIZE,
+		       SOLO_CAP_EXT_SIZE(solo_dev) / SOLO_CAP_PAGE_SIZE);
+
+	out += sprintf(out, "EREF: 0x%08x @ 0x%08x (0x%08x * %d)\n",
+		       SOLO_EREF_EXT_ADDR(solo_dev),
+		       SOLO_EREF_EXT_AREA(solo_dev),
+		       SOLO_EREF_EXT_SIZE,
+		       SOLO_EREF_EXT_AREA(solo_dev) / SOLO_EREF_EXT_SIZE);
+
+	out += sprintf(out, "MPEG: 0x%08x @ 0x%08x\n",
+		       SOLO_MP4E_EXT_ADDR(solo_dev),
+		       SOLO_MP4E_EXT_SIZE(solo_dev));
+
+	out += sprintf(out, "JPEG: 0x%08x @ 0x%08x\n",
+		       SOLO_JPEG_EXT_ADDR(solo_dev),
+		       SOLO_JPEG_EXT_SIZE(solo_dev));
+
+	return out - buf;
+}
+
+static ssize_t sdram_show(struct file *file, struct kobject *kobj,
+			  struct bin_attribute *a, char *buf,
+			  loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct solo_dev *solo_dev =
+		container_of(dev, struct solo_dev, dev);
+	const int size = solo_dev->sdram_size;
+
+	if (off >= size)
+		return 0;
+
+	if (off + count > size)
+		count = size - off;
+
+	if (solo_p2m_dma(solo_dev, 0, buf, off, count, 0, 0))
+		return -EIO;
+
+	return count;
+}
+
+static const struct device_attribute solo_dev_attrs[] = {
+	__ATTR(eeprom, 0640, eeprom_show, eeprom_store),
+	__ATTR(video_type, 0644, video_type_show, video_type_store),
+	__ATTR(p2m_timeout, 0644, p2m_timeout_show, p2m_timeout_store),
+	__ATTR_RO(p2m_timeouts),
+	__ATTR_RO(sdram_size),
+	__ATTR_RO(tw28xx),
+	__ATTR_RO(input_map),
+	__ATTR_RO(intervals),
+	__ATTR_RO(sdram_offsets),
+};
+
+static void solo_device_release(struct device *dev)
+{
+	/* Do nothing */
+}
+
+static int solo_sysfs_init(struct solo_dev *solo_dev)
+{
+	struct bin_attribute *sdram_attr = &solo_dev->sdram_attr;
+	struct device *dev = &solo_dev->dev;
+	const char *driver;
+	int i;
+
+	if (solo_dev->type == SOLO_DEV_6110)
+		driver = "solo6110";
+	else
+		driver = "solo6010";
+
+	dev->release = solo_device_release;
+	dev->parent = &solo_dev->pdev->dev;
+	set_dev_node(dev, dev_to_node(&solo_dev->pdev->dev));
+	dev_set_name(dev, "%s-%d-%d", driver, solo_dev->vfd->num,
+		     solo_dev->nr_chans);
+
+	if (device_register(dev)) {
+		dev->parent = NULL;
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(solo_dev_attrs); i++) {
+		if (device_create_file(dev, &solo_dev_attrs[i])) {
+			device_unregister(dev);
+			return -ENOMEM;
+		}
+	}
+
+	sdram_attr->attr.name = "sdram";
+	sdram_attr->attr.mode = 0440;
+	sdram_attr->read = sdram_show;
+	sdram_attr->size = solo_dev->sdram_size;
+
+	if (device_create_bin_file(dev, sdram_attr)) {
+		device_unregister(dev);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int solo_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct solo_dev *solo_dev;
 	int ret;
-	int sdram;
 	u8 chip_id;
-	u32 reg;
 
 	solo_dev = kzalloc(sizeof(*solo_dev), GFP_KERNEL);
 	if (solo_dev == NULL)
 		return -ENOMEM;
 
+	if (id->driver_data == SOLO_DEV_6010)
+		dev_info(&pdev->dev, "Probing Softlogic 6010\n");
+	else
+		dev_info(&pdev->dev, "Probing Softlogic 6110\n");
+
+	solo_dev->type = id->driver_data;
 	solo_dev->pdev = pdev;
 	spin_lock_init(&solo_dev->reg_io_lock);
 	pci_set_drvdata(pdev, solo_dev);
 
+	/* Only for during init */
+	solo_dev->p2m_jiffies = msecs_to_jiffies(100);
+
 	ret = pci_enable_device(pdev);
 	if (ret)
 		goto fail_probe;
 
 	pci_set_master(pdev);
 
+	/* RETRY/TRDY Timeout disabled */
+	pci_write_config_byte(pdev, 0x40, 0x00);
+	pci_write_config_byte(pdev, 0x41, 0x00);
+
 	ret = pci_request_regions(pdev, SOLO6X10_NAME);
 	if (ret)
 		goto fail_probe;
@@ -163,7 +536,7 @@ static int solo_pci_probe(struct pci_dev *pdev,
 	}
 
 	chip_id = solo_reg_read(solo_dev, SOLO_CHIP_OPTION) &
-					SOLO_CHIP_ID_MASK;
+				SOLO_CHIP_ID_MASK;
 	switch (chip_id) {
 	case 7:
 		solo_dev->nr_chans = 16;
@@ -174,52 +547,50 @@ static int solo_pci_probe(struct pci_dev *pdev,
 		solo_dev->nr_ext = 2;
 		break;
 	default:
-		dev_warn(&pdev->dev, "Invalid chip_id 0x%02x, "
-			 "defaulting to 4 channels\n",
+		dev_warn(&pdev->dev, "Invalid chip_id 0x%02x, assuming 4 ch\n",
 			 chip_id);
 	case 5:
 		solo_dev->nr_chans = 4;
 		solo_dev->nr_ext = 1;
 	}
 
-	solo_dev->flags = id->driver_data;
-
 	/* Disable all interrupts to start */
 	solo_irq_off(solo_dev, ~0);
 
-	reg = SOLO_SYS_CFG_SDRAM64BIT;
 	/* Initial global settings */
-	if (!(solo_dev->flags & FLAGS_6110))
-		reg |= SOLO6010_SYS_CFG_INPUTDIV(25) |
-			SOLO6010_SYS_CFG_FEEDBACKDIV((SOLO_CLOCK_MHZ * 2) - 2) |
-			SOLO6010_SYS_CFG_OUTDIV(3);
-	solo_reg_write(solo_dev, SOLO_SYS_CFG, reg);
-
-	if (solo_dev->flags & FLAGS_6110) {
-		u32 sys_clock_MHz = SOLO_CLOCK_MHZ;
-		u32 pll_DIVQ;
-		u32 pll_DIVF;
-
-		if (sys_clock_MHz < 125) {
-			pll_DIVQ = 3;
-			pll_DIVF = (sys_clock_MHz * 4) / 3;
+	if (solo_dev->type == SOLO_DEV_6010) {
+		solo_dev->clock_mhz = 108;
+		solo_dev->sys_config = SOLO_SYS_CFG_SDRAM64BIT
+			| SOLO_SYS_CFG_INPUTDIV(25)
+			| SOLO_SYS_CFG_FEEDBACKDIV(solo_dev->clock_mhz * 2 - 2)
+			| SOLO_SYS_CFG_OUTDIV(3);
+		solo_reg_write(solo_dev, SOLO_SYS_CFG, solo_dev->sys_config);
+	} else {
+		u32 divq, divf;
+
+		solo_dev->clock_mhz = 135;
+
+		if (solo_dev->clock_mhz < 125) {
+			divq = 3;
+			divf = (solo_dev->clock_mhz * 4) / 3 - 1;
 		} else {
-			pll_DIVQ = 2;
-			pll_DIVF = (sys_clock_MHz * 2) / 3;
+			divq = 2;
+			divf = (solo_dev->clock_mhz * 2) / 3 - 1;
 		}
 
-		solo_reg_write(solo_dev, SOLO6110_PLL_CONFIG,
-			       SOLO6110_PLL_RANGE_5_10MHZ |
-			       SOLO6110_PLL_DIVR(9) |
-			       SOLO6110_PLL_DIVQ_EXP(pll_DIVQ) |
-			       SOLO6110_PLL_DIVF(pll_DIVF) | SOLO6110_PLL_FSEN);
-		mdelay(1);      /* PLL Locking time (1ms) */
+		solo_reg_write(solo_dev, SOLO_PLL_CONFIG,
+			       (1 << 20) | /* PLL_RANGE */
+			       (8 << 15) | /* PLL_DIVR  */
+			       (divq << 12) |
+			       (divf <<  4) |
+			       (1 <<  1)   /* PLL_FSEN */);
 
-		solo_reg_write(solo_dev, SOLO_DMA_CTRL1, 3 << 8); /* ? */
-	} else
-		solo_reg_write(solo_dev, SOLO_DMA_CTRL1, 1 << 8); /* ? */
+		solo_dev->sys_config = SOLO_SYS_CFG_SDRAM64BIT;
+	}
 
-	solo_reg_write(solo_dev, SOLO_TIMER_CLOCK_NUM, SOLO_CLOCK_MHZ - 1);
+	solo_reg_write(solo_dev, SOLO_SYS_CFG, solo_dev->sys_config);
+	solo_reg_write(solo_dev, SOLO_TIMER_CLOCK_NUM,
+		       solo_dev->clock_mhz - 1);
 
 	/* PLL locking time of 1ms */
 	mdelay(1);
@@ -237,14 +608,27 @@ static int solo_pci_probe(struct pci_dev *pdev,
 		goto fail_probe;
 
 	/* Setup the DMA engine */
-	sdram = (solo_dev->nr_chans >= 8) ? 2 : 1;
 	solo_reg_write(solo_dev, SOLO_DMA_CTRL,
 		       SOLO_DMA_CTRL_REFRESH_CYCLE(1) |
-		       SOLO_DMA_CTRL_SDRAM_SIZE(sdram) |
+		       SOLO_DMA_CTRL_SDRAM_SIZE(2) |
 		       SOLO_DMA_CTRL_SDRAM_CLK_INVERT |
 		       SOLO_DMA_CTRL_READ_CLK_SELECT |
 		       SOLO_DMA_CTRL_LATENCY(1));
 
+	/* Undocumented crap */
+	solo_reg_write(solo_dev, SOLO_DMA_CTRL1,
+		       solo_dev->type == SOLO_DEV_6010 ? 0x100 : 0x300);
+
+	if (solo_dev->type != SOLO_DEV_6010) {
+		solo_dev->usec_lsb = 0x3f;
+		solo_set_time(solo_dev);
+	}
+
+	/* Disable watchdog */
+	solo_reg_write(solo_dev, SOLO_WATCHDOG, 0);
+
+	/* Initialize sub components */
+
 	ret = solo_p2m_init(solo_dev);
 	if (ret)
 		goto fail_probe;
@@ -261,7 +645,7 @@ static int solo_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto fail_probe;
 
-	ret = solo_v4l2_init(solo_dev);
+	ret = solo_v4l2_init(solo_dev, video_nr);
 	if (ret)
 		goto fail_probe;
 
@@ -269,7 +653,7 @@ static int solo_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto fail_probe;
 
-	ret = solo_enc_v4l2_init(solo_dev);
+	ret = solo_enc_v4l2_init(solo_dev, video_nr);
 	if (ret)
 		goto fail_probe;
 
@@ -277,6 +661,13 @@ static int solo_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto fail_probe;
 
+	ret = solo_sysfs_init(solo_dev);
+	if (ret)
+		goto fail_probe;
+
+	/* Now that init is over, set this lower */
+	solo_dev->p2m_jiffies = msecs_to_jiffies(20);
+
 	return 0;
 
 fail_probe:
@@ -291,21 +682,31 @@ static void solo_pci_remove(struct pci_dev *pdev)
 	free_solo_dev(solo_dev);
 }
 
-static struct pci_device_id solo_id_table[] = {
+static DEFINE_PCI_DEVICE_TABLE(solo_id_table) = {
 	/* 6010 based cards */
-	{PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6010)},
-	{PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6110),
-	 .driver_data = FLAGS_6110},
-	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_NEUSOLO_4)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_NEUSOLO_9)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_NEUSOLO_16)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_SOLO_4)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_SOLO_9)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_SOLO_16)},
+	{ PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6010),
+	  .driver_data = SOLO_DEV_6010 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_NEUSOLO_4),
+	  .driver_data = SOLO_DEV_6010 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_NEUSOLO_9),
+	  .driver_data = SOLO_DEV_6010 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_NEUSOLO_16),
+	  .driver_data = SOLO_DEV_6010 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_SOLO_4),
+	  .driver_data = SOLO_DEV_6010 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_SOLO_9),
+	  .driver_data = SOLO_DEV_6010 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_SOLO_16),
+	  .driver_data = SOLO_DEV_6010 },
 	/* 6110 based cards */
-	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_6110_4)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_6110_8)},
-	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_6110_16)},
+	{ PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6110),
+	  .driver_data = SOLO_DEV_6110 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_6110_4),
+	  .driver_data = SOLO_DEV_6110 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_6110_8),
+	  .driver_data = SOLO_DEV_6110 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_BC_6110_16),
+	  .driver_data = SOLO_DEV_6110 },
 	{0,}
 };
 
diff --git a/drivers/staging/media/solo6x10/disp.c b/drivers/staging/media/solo6x10/disp.c
index 884c0eb..ddd85e7 100644
--- a/drivers/staging/media/solo6x10/disp.c
+++ b/drivers/staging/media/solo6x10/disp.c
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-ioctl.h>
+
 #include "solo6x10.h"
 
 #define SOLO_VCLK_DELAY			3
@@ -30,8 +36,8 @@
 #define SOLO_MOT_THRESH_H		64
 #define SOLO_MOT_THRESH_SIZE		8192
 #define SOLO_MOT_THRESH_REAL		(SOLO_MOT_THRESH_W * SOLO_MOT_THRESH_H)
-#define SOLO_MOT_FLAG_SIZE		512
-#define SOLO_MOT_FLAG_AREA		(SOLO_MOT_FLAG_SIZE * 32)
+#define SOLO_MOT_FLAG_SIZE		1024
+#define SOLO_MOT_FLAG_AREA		(SOLO_MOT_FLAG_SIZE * 16)
 
 static unsigned video_type;
 module_param(video_type, uint, 0644);
@@ -73,7 +79,12 @@ static void solo_vin_config(struct solo_dev *solo_dev)
 	solo_reg_write(solo_dev, SOLO_VI_CH_FORMAT,
 		       SOLO_VI_FD_SEL_MASK(0) | SOLO_VI_PROG_MASK(0));
 
-	solo_reg_write(solo_dev, SOLO_VI_FMT_CFG, 0);
+	/* On 6110, initialize mozaic darkness stength */
+	if (solo_dev->type == SOLO_DEV_6010)
+		solo_reg_write(solo_dev, SOLO_VI_FMT_CFG, 0);
+	else
+		solo_reg_write(solo_dev, SOLO_VI_FMT_CFG, 16 << 22);
+
 	solo_reg_write(solo_dev, SOLO_VI_PAGE_SW, 2);
 
 	if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC) {
@@ -97,21 +108,30 @@ static void solo_vin_config(struct solo_dev *solo_dev)
 		       SOLO_VI_PB_HSTOP(16 + 720));
 }
 
-static void solo_disp_config(struct solo_dev *solo_dev)
+static void solo_vout_config_cursor(struct solo_dev *dev)
+{
+	int i;
+
+	/* Load (blank) cursor bitmap mask (2bpp) */
+	for (i = 0; i < 20; i++)
+		solo_reg_write(dev, SOLO_VO_CURSOR_MASK(i), 0);
+
+	solo_reg_write(dev, SOLO_VO_CURSOR_POS, 0);
+
+	solo_reg_write(dev, SOLO_VO_CURSOR_CLR,
+		       (0x80 << 24) | (0x80 << 16) | (0x10 << 8) | 0x80);
+	solo_reg_write(dev, SOLO_VO_CURSOR_CLR2, (0xe0 << 8) | 0x80);
+}
+
+static void solo_vout_config(struct solo_dev *solo_dev)
 {
 	solo_dev->vout_hstart = 6;
 	solo_dev->vout_vstart = 8;
 
-	solo_reg_write(solo_dev, SOLO_VO_BORDER_LINE_COLOR,
-		       (0xa0 << 24) | (0x88 << 16) | (0xa0 << 8) | 0x88);
-	solo_reg_write(solo_dev, SOLO_VO_BORDER_FILL_COLOR,
-		       (0x10 << 24) | (0x8f << 16) | (0x10 << 8) | 0x8f);
-	solo_reg_write(solo_dev, SOLO_VO_BKG_COLOR,
-		       (16 << 24) | (128 << 16) | (16 << 8) | 128);
-
 	solo_reg_write(solo_dev, SOLO_VO_FMT_ENC,
 		       solo_dev->video_type |
 		       SOLO_VO_USER_COLOR_SET_NAV |
+		       SOLO_VO_USER_COLOR_SET_NAH |
 		       SOLO_VO_NA_COLOR_Y(0) |
 		       SOLO_VO_NA_COLOR_CB(0) |
 		       SOLO_VO_NA_COLOR_CR(0));
@@ -130,19 +150,31 @@ static void solo_disp_config(struct solo_dev *solo_dev)
 		       SOLO_VO_H_LEN(solo_dev->video_hsize) |
 		       SOLO_VO_V_LEN(solo_dev->video_vsize));
 
-	solo_reg_write(solo_dev, SOLO_VI_WIN_SW, 5);
+	/* Border & background colors */
+	solo_reg_write(solo_dev, SOLO_VO_BORDER_LINE_COLOR,
+		       (0xa0 << 24) | (0x88 << 16) | (0xa0 << 8) | 0x88);
+	solo_reg_write(solo_dev, SOLO_VO_BORDER_FILL_COLOR,
+		       (0x10 << 24) | (0x8f << 16) | (0x10 << 8) | 0x8f);
+	solo_reg_write(solo_dev, SOLO_VO_BKG_COLOR,
+		       (16 << 24) | (128 << 16) | (16 << 8) | 128);
+
+	solo_reg_write(solo_dev, SOLO_VO_DISP_ERASE, SOLO_VO_DISP_ERASE_ON);
+
+	solo_reg_write(solo_dev, SOLO_VI_WIN_SW, 0);
+
+	solo_reg_write(solo_dev, SOLO_VO_ZOOM_CTRL, 0);
+	solo_reg_write(solo_dev, SOLO_VO_FREEZE_CTRL, 0);
 
 	solo_reg_write(solo_dev, SOLO_VO_DISP_CTRL, SOLO_VO_DISP_ON |
 		       SOLO_VO_DISP_ERASE_COUNT(8) |
 		       SOLO_VO_DISP_BASE(SOLO_DISP_EXT_ADDR));
 
-	solo_reg_write(solo_dev, SOLO_VO_DISP_ERASE, SOLO_VO_DISP_ERASE_ON);
 
-	/* Enable channels we support */
-	solo_reg_write(solo_dev, SOLO_VI_CH_ENA, (1 << solo_dev->nr_chans) - 1);
+	solo_vout_config_cursor(solo_dev);
 
-	/* Disable the watchdog */
-	solo_reg_write(solo_dev, SOLO_WATCHDOG, 0);
+	/* Enable channels we support */
+	solo_reg_write(solo_dev, SOLO_VI_CH_ENA,
+		       (1 << solo_dev->nr_chans) - 1);
 }
 
 static int solo_dma_vin_region(struct solo_dev *solo_dev, u32 off,
@@ -156,26 +188,53 @@ static int solo_dma_vin_region(struct solo_dev *solo_dev, u32 off,
 		buf[i] = val;
 
 	for (i = 0; i < reg_size; i += sizeof(buf))
-		ret |= solo_p2m_dma(solo_dev, SOLO_P2M_DMA_ID_VIN, 1, buf,
+		ret |= solo_p2m_dma(solo_dev, 1, buf,
 				    SOLO_MOTION_EXT_ADDR(solo_dev) + off + i,
-				    sizeof(buf));
+				    sizeof(buf), 0, 0);
 
 	return ret;
 }
 
-void solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val)
+int solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val)
 {
 	if (ch > solo_dev->nr_chans)
-		return;
+		return -EINVAL;
 
-	solo_dma_vin_region(solo_dev, SOLO_MOT_FLAG_AREA +
-			    (ch * SOLO_MOT_THRESH_SIZE * 2),
-			    val, SOLO_MOT_THRESH_REAL);
+	return solo_dma_vin_region(solo_dev, SOLO_MOT_FLAG_AREA +
+				   (ch * SOLO_MOT_THRESH_SIZE * 2),
+				   val, SOLO_MOT_THRESH_SIZE);
+}
+
+int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch, u16 val,
+			   u16 block)
+{
+	u16 buf[64];
+	u32 addr;
+	int re;
+
+	addr = SOLO_MOTION_EXT_ADDR(solo_dev) +
+		SOLO_MOT_FLAG_AREA +
+		(SOLO_MOT_THRESH_SIZE * 2 * ch) +
+		(block * 2);
+
+	/* Read and write only on a 128-byte boundary; 4-byte writes with
+	   solo_p2m_dma silently failed. Bluecherry bug #908. */
+	re = solo_p2m_dma(solo_dev, 0, &buf, addr & ~0x7f, sizeof(buf), 0, 0);
+	if (re)
+		return re;
+
+	buf[(addr & 0x7f) / 2] = val;
+
+	re = solo_p2m_dma(solo_dev, 1, &buf, addr & ~0x7f, sizeof(buf), 0, 0);
+	if (re)
+		return re;
+
+	return 0;
 }
 
 /* First 8k is motion flag (512 bytes * 16). Following that is an 8k+8k
  * threshold and working table for each channel. Atleast that's what the
- * spec says. However, this code (take from rdk) has some mystery 8k
+ * spec says. However, this code (taken from rdk) has some mystery 8k
  * block right after the flag area, before the first thresh table. */
 static void solo_motion_config(struct solo_dev *solo_dev)
 {
@@ -188,9 +247,9 @@ static void solo_motion_config(struct solo_dev *solo_dev)
 
 		/* Clear working cache table */
 		solo_dma_vin_region(solo_dev, SOLO_MOT_FLAG_AREA +
-				    SOLO_MOT_THRESH_SIZE +
-				    (i * SOLO_MOT_THRESH_SIZE * 2),
-				    0x0000, SOLO_MOT_THRESH_REAL);
+				    (i * SOLO_MOT_THRESH_SIZE * 2) +
+				    SOLO_MOT_THRESH_SIZE, 0x0000,
+				    SOLO_MOT_THRESH_SIZE);
 
 		/* Set default threshold table */
 		solo_set_motion_threshold(solo_dev, i, SOLO_DEF_MOT_THRESH);
@@ -202,8 +261,8 @@ static void solo_motion_config(struct solo_dev *solo_dev)
 	solo_reg_write(solo_dev, SOLO_VI_MOT_CTRL,
 		       SOLO_VI_MOTION_FRAME_COUNT(3) |
 		       SOLO_VI_MOTION_SAMPLE_LENGTH(solo_dev->video_hsize / 16)
-		       | /* SOLO_VI_MOTION_INTR_START_STOP | */
-		       SOLO_VI_MOTION_SAMPLE_COUNT(10));
+		       /* | SOLO_VI_MOTION_INTR_START_STOP */
+		       | SOLO_VI_MOTION_SAMPLE_COUNT(10));
 
 	solo_reg_write(solo_dev, SOLO_VI_MOTION_BORDER, 0);
 	solo_reg_write(solo_dev, SOLO_VI_MOTION_BAR, 0);
@@ -226,7 +285,7 @@ int solo_disp_init(struct solo_dev *solo_dev)
 
 	solo_vin_config(solo_dev);
 	solo_motion_config(solo_dev);
-	solo_disp_config(solo_dev);
+	solo_vout_config(solo_dev);
 
 	for (i = 0; i < solo_dev->nr_chans; i++)
 		solo_reg_write(solo_dev, SOLO_VI_WIN_ON(i), 1);
@@ -238,8 +297,6 @@ void solo_disp_exit(struct solo_dev *solo_dev)
 {
 	int i;
 
-	solo_irq_off(solo_dev, SOLO_IRQ_MOTION);
-
 	solo_reg_write(solo_dev, SOLO_VO_DISP_CTRL, 0);
 	solo_reg_write(solo_dev, SOLO_VO_ZOOM_CTRL, 0);
 	solo_reg_write(solo_dev, SOLO_VO_FREEZE_CTRL, 0);
diff --git a/drivers/staging/media/solo6x10/eeprom.c b/drivers/staging/media/solo6x10/eeprom.c
new file mode 100644
index 0000000..9d1c9bb
--- /dev/null
+++ b/drivers/staging/media/solo6x10/eeprom.c
@@ -0,0 +1,154 @@
+/*
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/delay.h>
+
+#include "solo6x10.h"
+
+/* Control */
+#define EE_SHIFT_CLK	0x04
+#define EE_CS		0x08
+#define EE_DATA_WRITE	0x02
+#define EE_DATA_READ	0x01
+#define EE_ENB		(0x80 | EE_CS)
+
+#define eeprom_delay()	udelay(100)
+#if 0
+#define eeprom_delay()	solo_reg_read(solo_dev, SOLO_EEPROM_CTRL)
+#define eeprom_delay()	({				\
+	int i, ret;					\
+	udelay(100);					\
+	for (i = ret = 0; i < 1000 && !ret; i++)	\
+		ret = solo_eeprom_reg_read(solo_dev);	\
+})
+#endif
+#define ADDR_LEN	6
+
+/* Commands */
+#define EE_EWEN_CMD	4
+#define EE_EWDS_CMD	4
+#define EE_WRITE_CMD	5
+#define EE_READ_CMD	6
+#define EE_ERASE_CMD	7
+
+static unsigned int solo_eeprom_reg_read(struct solo_dev *solo_dev)
+{
+	return solo_reg_read(solo_dev, SOLO_EEPROM_CTRL) & EE_DATA_READ;
+}
+
+static void solo_eeprom_reg_write(struct solo_dev *solo_dev, u32 data)
+{
+	solo_reg_write(solo_dev, SOLO_EEPROM_CTRL, data);
+	eeprom_delay();
+}
+
+static void solo_eeprom_cmd(struct solo_dev *solo_dev, int cmd)
+{
+	int i;
+
+	solo_eeprom_reg_write(solo_dev, SOLO_EEPROM_ACCESS_EN);
+	solo_eeprom_reg_write(solo_dev, SOLO_EEPROM_ENABLE);
+
+	for (i = 4 + ADDR_LEN; i >= 0; i--) {
+		int dataval = (cmd & (1 << i)) ? EE_DATA_WRITE : 0;
+
+		solo_eeprom_reg_write(solo_dev, SOLO_EEPROM_ENABLE | dataval);
+		solo_eeprom_reg_write(solo_dev, SOLO_EEPROM_ENABLE |
+				      EE_SHIFT_CLK | dataval);
+	}
+
+	solo_eeprom_reg_write(solo_dev, SOLO_EEPROM_ENABLE);
+}
+
+unsigned int solo_eeprom_ewen(struct solo_dev *solo_dev, int w_en)
+{
+	int ewen_cmd = (w_en ? 0x3f : 0) | (EE_EWEN_CMD << ADDR_LEN);
+	unsigned int retval = 0;
+	int i;
+
+	solo_eeprom_cmd(solo_dev, ewen_cmd);
+
+	for (i = 0; i < 16; i++) {
+		solo_eeprom_reg_write(solo_dev, SOLO_EEPROM_ENABLE |
+				      EE_SHIFT_CLK);
+		retval = (retval << 1) | solo_eeprom_reg_read(solo_dev);
+		solo_eeprom_reg_write(solo_dev, SOLO_EEPROM_ENABLE);
+		retval = (retval << 1) | solo_eeprom_reg_read(solo_dev);
+	}
+
+	solo_eeprom_reg_write(solo_dev, ~EE_CS);
+	retval = (retval << 1) | solo_eeprom_reg_read(solo_dev);
+
+	return retval;
+}
+
+unsigned short solo_eeprom_read(struct solo_dev *solo_dev, int loc)
+{
+	int read_cmd = loc | (EE_READ_CMD << ADDR_LEN);
+	unsigned short retval = 0;
+	int i;
+
+	solo_eeprom_cmd(solo_dev, read_cmd);
+
+	for (i = 0; i < 16; i++) {
+		solo_eeprom_reg_write(solo_dev, SOLO_EEPROM_ENABLE |
+				      EE_SHIFT_CLK);
+		retval = (retval << 1) | solo_eeprom_reg_read(solo_dev);
+		solo_eeprom_reg_write(solo_dev, SOLO_EEPROM_ENABLE);
+	}
+
+	solo_eeprom_reg_write(solo_dev, ~EE_CS);
+
+	return retval;
+}
+
+int solo_eeprom_write(struct solo_dev *solo_dev, int loc,
+		      unsigned short data)
+{
+	int write_cmd = loc | (EE_WRITE_CMD << ADDR_LEN);
+	unsigned int retval;
+	int i;
+
+	solo_eeprom_cmd(solo_dev, write_cmd);
+
+	for (i = 15; i >= 0; i--) {
+		unsigned int dataval = (data >> i) & 1;
+
+		solo_eeprom_reg_write(solo_dev, EE_ENB);
+		solo_eeprom_reg_write(solo_dev,
+				      EE_ENB | (dataval << 1) | EE_SHIFT_CLK);
+	}
+
+	solo_eeprom_reg_write(solo_dev, EE_ENB);
+	solo_eeprom_reg_write(solo_dev, ~EE_CS);
+	solo_eeprom_reg_write(solo_dev, EE_ENB);
+
+	for (i = retval = 0; i < 10000 && !retval; i++)
+		retval = solo_eeprom_reg_read(solo_dev);
+
+	solo_eeprom_reg_write(solo_dev, ~EE_CS);
+
+	return !retval;
+}
diff --git a/drivers/staging/media/solo6x10/enc.c b/drivers/staging/media/solo6x10/enc.c
index de50259..c992639 100644
--- a/drivers/staging/media/solo6x10/enc.c
+++ b/drivers/staging/media/solo6x10/enc.c
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -18,30 +23,40 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/slab.h>
-#include "solo6x10.h"
-#include "osd-font.h"
+#include <linux/font.h>
+#include <linux/bitrev.h>
 
-#define CAPTURE_MAX_BANDWIDTH		32	/* D1 4channel (D1 == 4) */
-#define OSG_BUFFER_SIZE			1024
+#include "solo6x10.h"
 
 #define VI_PROG_HSIZE			(1280 - 16)
 #define VI_PROG_VSIZE			(1024 - 16)
 
+#define IRQ_LEVEL			2
+
 static void solo_capture_config(struct solo_dev *solo_dev)
 {
-	int i, j;
 	unsigned long height;
 	unsigned long width;
-	unsigned char *buf;
+	void *buf;
+	int i;
 
 	solo_reg_write(solo_dev, SOLO_CAP_BASE,
-		       SOLO_CAP_MAX_PAGE(SOLO_CAP_EXT_MAX_PAGE *
-					 solo_dev->nr_chans) |
-		       SOLO_CAP_BASE_ADDR(SOLO_CAP_EXT_ADDR(solo_dev) >> 16));
-	solo_reg_write(solo_dev, SOLO_CAP_BTW,
-		       (1 << 17) | SOLO_CAP_PROG_BANDWIDTH(2) |
-		       SOLO_CAP_MAX_BANDWIDTH(CAPTURE_MAX_BANDWIDTH));
+		       SOLO_CAP_MAX_PAGE((SOLO_CAP_EXT_SIZE(solo_dev)
+					  - SOLO_CAP_PAGE_SIZE) >> 16)
+		       | SOLO_CAP_BASE_ADDR(SOLO_CAP_EXT_ADDR(solo_dev) >> 16));
+
+	/* XXX: Undocumented bits at b17 and b24 */
+	if (solo_dev->type == SOLO_DEV_6110) {
+		/* NOTE: Ref driver has (62 << 24) here as well, but it causes
+		 * wacked out frame timing on 4-port 6110. */
+		solo_reg_write(solo_dev, SOLO_CAP_BTW,
+			       (1 << 17) | SOLO_CAP_PROG_BANDWIDTH(2) |
+			       SOLO_CAP_MAX_BANDWIDTH(36));
+	} else {
+		solo_reg_write(solo_dev, SOLO_CAP_BTW,
+			       (1 << 17) | SOLO_CAP_PROG_BANDWIDTH(2) |
+			       SOLO_CAP_MAX_BANDWIDTH(32));
+	}
 
 	/* Set scale 1, 9 dimension */
 	width = solo_dev->video_hsize;
@@ -96,115 +111,212 @@ static void solo_capture_config(struct solo_dev *solo_dev)
 	solo_reg_write(solo_dev, SOLO_VE_OSD_BASE, SOLO_EOSD_EXT_ADDR >> 16);
 	solo_reg_write(solo_dev, SOLO_VE_OSD_CLR,
 		       0xF0 << 16 | 0x80 << 8 | 0x80);
-	solo_reg_write(solo_dev, SOLO_VE_OSD_OPT, 0);
+
+	if (solo_dev->type == SOLO_DEV_6010)
+		solo_reg_write(solo_dev, SOLO_VE_OSD_OPT,
+			       SOLO_VE_OSD_H_SHADOW | SOLO_VE_OSD_V_SHADOW);
+	else
+		solo_reg_write(solo_dev, SOLO_VE_OSD_OPT, SOLO_VE_OSD_V_DOUBLE
+			       | SOLO_VE_OSD_H_SHADOW | SOLO_VE_OSD_V_SHADOW);
 
 	/* Clear OSG buffer */
-	buf = kzalloc(OSG_BUFFER_SIZE, GFP_KERNEL);
+	buf = kzalloc(SOLO_EOSD_EXT_SIZE(solo_dev), GFP_KERNEL);
 	if (!buf)
 		return;
 
 	for (i = 0; i < solo_dev->nr_chans; i++) {
-		for (j = 0; j < SOLO_EOSD_EXT_SIZE; j += OSG_BUFFER_SIZE) {
-			solo_p2m_dma(solo_dev, SOLO_P2M_DMA_ID_MP4E, 1, buf,
-				     SOLO_EOSD_EXT_ADDR +
-				     (i * SOLO_EOSD_EXT_SIZE) + j,
-				     OSG_BUFFER_SIZE);
-		}
+		solo_p2m_dma(solo_dev, 1, buf,
+			     SOLO_EOSD_EXT_ADDR +
+			     (SOLO_EOSD_EXT_SIZE(solo_dev) * i),
+			     SOLO_EOSD_EXT_SIZE(solo_dev), 0, 0);
 	}
 	kfree(buf);
 }
 
+/* Should be called with enable_lock held */
 int solo_osd_print(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	char *str = solo_enc->osd_text;
-	u8 *buf;
+	unsigned char *str = solo_enc->osd_text;
+	u8 *buf = solo_enc->osd_buf;
 	u32 reg = solo_reg_read(solo_dev, SOLO_VE_OSD_CH);
-	int len = strlen(str);
+	const struct font_desc *vga = find_font("VGA8x16");
+	const unsigned char *vga_data;
+	int len;
 	int i, j;
-	int x = 1, y = 1;
+
+	if (WARN_ON_ONCE(!vga))
+		return -ENODEV;
+
+	len = strlen(str);
 
 	if (len == 0) {
+		/* Disable OSD on this channel */
 		reg &= ~(1 << solo_enc->ch);
 		solo_reg_write(solo_dev, SOLO_VE_OSD_CH, reg);
 		return 0;
 	}
 
-	buf = kzalloc(SOLO_EOSD_EXT_SIZE, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	memset(buf, 0, SOLO_EOSD_EXT_SIZE_MAX);
+	vga_data = (const unsigned char *)vga->data;
 
 	for (i = 0; i < len; i++) {
+		unsigned char c = str[i];
+
 		for (j = 0; j < 16; j++) {
-			buf[(j*2) + (i%2) + ((x + (i/2)) * 32) + (y * 2048)] =
-				(solo_osd_font[(str[i] * 4) + (j / 4)]
-					>> ((3 - (j % 4)) * 8)) & 0xff;
+			buf[(j * 2) + (i % 2) + (i / 2 * 32)] =
+				bitrev8(vga_data[(c * 16) + j]);
 		}
 	}
 
-	solo_p2m_dma(solo_dev, 0, 1, buf, SOLO_EOSD_EXT_ADDR +
-		     (solo_enc->ch * SOLO_EOSD_EXT_SIZE), SOLO_EOSD_EXT_SIZE);
+	solo_p2m_dma(solo_dev, 1, buf,
+		     SOLO_EOSD_EXT_ADDR +
+		     (solo_enc->ch * SOLO_EOSD_EXT_SIZE(solo_dev)),
+		     SOLO_EOSD_EXT_SIZE(solo_dev), 0, 0);
+
+	/* Enable OSD on this channel */
 	reg |= (1 << solo_enc->ch);
 	solo_reg_write(solo_dev, SOLO_VE_OSD_CH, reg);
 
-	kfree(buf);
-
 	return 0;
 }
 
+/**
+ * Set channel Quality Profile (0-3).
+ */
+void solo_s_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch,
+		    unsigned int qp)
+{
+	unsigned long flags;
+	unsigned int idx, reg;
+
+	if ((ch > 31) || (qp > 3))
+		return;
+
+	if (solo_dev->type == SOLO_DEV_6010)
+		return;
+
+	if (ch < 16) {
+		idx = 0;
+		reg = SOLO_VE_JPEG_QP_CH_L;
+	} else {
+		ch -= 16;
+		idx = 1;
+		reg = SOLO_VE_JPEG_QP_CH_H;
+	}
+	ch *= 2;
+
+	spin_lock_irqsave(&solo_dev->jpeg_qp_lock, flags);
+
+	solo_dev->jpeg_qp[idx] &= ~(3 << ch);
+	solo_dev->jpeg_qp[idx] |= (qp & 3) << ch;
+
+	solo_reg_write(solo_dev, reg, solo_dev->jpeg_qp[idx]);
+
+	spin_unlock_irqrestore(&solo_dev->jpeg_qp_lock, flags);
+}
+
+int solo_g_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch)
+{
+	int idx;
+
+	if (solo_dev->type == SOLO_DEV_6010)
+		return 2;
+
+	if (WARN_ON_ONCE(ch > 31))
+		return 2;
+
+	if (ch < 16) {
+		idx = 0;
+	} else {
+		ch -= 16;
+		idx = 1;
+	}
+	ch *= 2;
+
+	return (solo_dev->jpeg_qp[idx] >> ch) & 3;
+}
+
+#define SOLO_QP_INIT 0xaaaaaaaa
+
 static void solo_jpeg_config(struct solo_dev *solo_dev)
 {
-	u32 reg;
-	if (solo_dev->flags & FLAGS_6110)
-		reg = (4 << 24) | (3 << 16) | (2 << 8) | (1 << 0);
-	else
-		reg = (2 << 24) | (2 << 16) | (2 << 8) | (2 << 0);
-	solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_TBL, reg);
-	solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_CH_L, 0);
-	solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_CH_H, 0);
+	if (solo_dev->type == SOLO_DEV_6010) {
+		solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_TBL,
+			       (2 << 24) | (2 << 16) | (2 << 8) | 2);
+	} else {
+		solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_TBL,
+			       (4 << 24) | (3 << 16) | (2 << 8) | 1);
+	}
+
+	spin_lock_init(&solo_dev->jpeg_qp_lock);
+
+	/* Initialize Quality Profile for all channels */
+	solo_dev->jpeg_qp[0] = solo_dev->jpeg_qp[1] = SOLO_QP_INIT;
+	solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_CH_L, SOLO_QP_INIT);
+	solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_CH_H, SOLO_QP_INIT);
+
 	solo_reg_write(solo_dev, SOLO_VE_JPEG_CFG,
 		(SOLO_JPEG_EXT_SIZE(solo_dev) & 0xffff0000) |
 		((SOLO_JPEG_EXT_ADDR(solo_dev) >> 16) & 0x0000ffff));
 	solo_reg_write(solo_dev, SOLO_VE_JPEG_CTRL, 0xffffffff);
-	/* que limit, samp limit, pos limit */
-	solo_reg_write(solo_dev, 0x0688, (0 << 16) | (30 << 8) | 60);
+	if (solo_dev->type == SOLO_DEV_6110) {
+		solo_reg_write(solo_dev, SOLO_VE_JPEG_CFG1,
+			       (0 << 16) | (30 << 8) | 60);
+	}
 }
 
 static void solo_mp4e_config(struct solo_dev *solo_dev)
 {
 	int i;
-	u32 reg;
+	u32 cfg;
 
-	/* We can only use VE_INTR_CTRL(0) if we want to support mjpeg */
 	solo_reg_write(solo_dev, SOLO_VE_CFG0,
-		       SOLO_VE_INTR_CTRL(0) |
+		       SOLO_VE_INTR_CTRL(IRQ_LEVEL) |
 		       SOLO_VE_BLOCK_SIZE(SOLO_MP4E_EXT_SIZE(solo_dev) >> 16) |
 		       SOLO_VE_BLOCK_BASE(SOLO_MP4E_EXT_ADDR(solo_dev) >> 16));
 
-	solo_reg_write(solo_dev, SOLO_VE_CFG1,
-		       SOLO_VE_INSERT_INDEX | SOLO_VE_MOTION_MODE(0));
+
+	cfg = SOLO_VE_BYTE_ALIGN(2) | SOLO_VE_INSERT_INDEX
+		| SOLO_VE_MOTION_MODE(0);
+	if (solo_dev->type != SOLO_DEV_6010) {
+		cfg |= SOLO_VE_MPEG_SIZE_H(
+			(SOLO_MP4E_EXT_SIZE(solo_dev) >> 24) & 0x0f);
+		cfg |= SOLO_VE_JPEG_SIZE_H(
+			(SOLO_JPEG_EXT_SIZE(solo_dev) >> 24) & 0x0f);
+	}
+	solo_reg_write(solo_dev, SOLO_VE_CFG1, cfg);
 
 	solo_reg_write(solo_dev, SOLO_VE_WMRK_POLY, 0);
 	solo_reg_write(solo_dev, SOLO_VE_VMRK_INIT_KEY, 0);
 	solo_reg_write(solo_dev, SOLO_VE_WMRK_STRL, 0);
+	if (solo_dev->type == SOLO_DEV_6110)
+		solo_reg_write(solo_dev, SOLO_VE_WMRK_ENABLE, 0);
 	solo_reg_write(solo_dev, SOLO_VE_ENCRYP_POLY, 0);
 	solo_reg_write(solo_dev, SOLO_VE_ENCRYP_INIT, 0);
 
-	reg = SOLO_VE_LITTLE_ENDIAN | SOLO_COMP_ATTR_FCODE(1) |
-		SOLO_COMP_TIME_INC(0) | SOLO_COMP_TIME_WIDTH(15);
-	if (solo_dev->flags & FLAGS_6110)
-		reg |= SOLO_DCT_INTERVAL(10);
-	else
-		reg |= SOLO_DCT_INTERVAL(36 / 4);
-	solo_reg_write(solo_dev, SOLO_VE_ATTR, reg);
+	solo_reg_write(solo_dev, SOLO_VE_ATTR,
+		       SOLO_VE_LITTLE_ENDIAN |
+		       SOLO_COMP_ATTR_FCODE(1) |
+		       SOLO_COMP_TIME_INC(0) |
+		       SOLO_COMP_TIME_WIDTH(15) |
+		       SOLO_DCT_INTERVAL(solo_dev->type == SOLO_DEV_6010 ? 9 : 10));
 
-	for (i = 0; i < solo_dev->nr_chans; i++)
+	for (i = 0; i < solo_dev->nr_chans; i++) {
 		solo_reg_write(solo_dev, SOLO_VE_CH_REF_BASE(i),
 			       (SOLO_EREF_EXT_ADDR(solo_dev) +
 			       (i * SOLO_EREF_EXT_SIZE)) >> 16);
+		solo_reg_write(solo_dev, SOLO_VE_CH_REF_BASE_E(i),
+			       (SOLO_EREF_EXT_ADDR(solo_dev) +
+			       ((i + 16) * SOLO_EREF_EXT_SIZE)) >> 16);
+	}
 
-	if (solo_dev->flags & FLAGS_6110)
-		solo_reg_write(solo_dev, 0x0634, 0x00040008); /* ? */
+	if (solo_dev->type == SOLO_DEV_6110) {
+		solo_reg_write(solo_dev, SOLO_VE_COMPT_MOT, 0x00040008);
+	} else {
+		for (i = 0; i < solo_dev->nr_chans; i++)
+			solo_reg_write(solo_dev, SOLO_VE_CH_MOT(i), 0x100);
+	}
 }
 
 int solo_enc_init(struct solo_dev *solo_dev)
@@ -220,8 +332,6 @@ int solo_enc_init(struct solo_dev *solo_dev)
 		solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(i), 0);
 	}
 
-	solo_irq_on(solo_dev, SOLO_IRQ_ENCODER);
-
 	return 0;
 }
 
@@ -229,8 +339,6 @@ void solo_enc_exit(struct solo_dev *solo_dev)
 {
 	int i;
 
-	solo_irq_off(solo_dev, SOLO_IRQ_ENCODER);
-
 	for (i = 0; i < solo_dev->nr_chans; i++) {
 		solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(i), 0);
 		solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(i), 0);
diff --git a/drivers/staging/media/solo6x10/g723.c b/drivers/staging/media/solo6x10/g723.c
index 2cd0de2..aeff41a 100644
--- a/drivers/staging/media/solo6x10/g723.c
+++ b/drivers/staging/media/solo6x10/g723.c
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,17 +26,17 @@
 #include <linux/mempool.h>
 #include <linux/poll.h>
 #include <linux/kthread.h>
-#include <linux/slab.h>
 #include <linux/freezer.h>
-#include <linux/export.h>
+#include <linux/module.h>
+
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/pcm.h>
 #include <sound/control.h>
+
 #include "solo6x10.h"
 #include "tw28.h"
 
-#define G723_INTR_ORDER		0
 #define G723_FDMA_PAGES		32
 #define G723_PERIOD_BYTES	48
 #define G723_PERIOD_BLOCK	1024
@@ -46,36 +51,40 @@
 /* The solo writes to 1k byte pages, 32 pages, in the dma. Each 1k page
  * is broken down to 20 * 48 byte regions (one for each channel possible)
  * with the rest of the page being dummy data. */
-#define MAX_BUFFER		(G723_PERIOD_BYTES * PERIODS_MAX)
-#define IRQ_PAGES		4 /* 0 - 4 */
-#define PERIODS_MIN		(1 << IRQ_PAGES)
+#define G723_MAX_BUFFER		(G723_PERIOD_BYTES * PERIODS_MAX)
+#define G723_INTR_ORDER		4 /* 0 - 4 */
+#define PERIODS_MIN		(1 << G723_INTR_ORDER)
 #define PERIODS_MAX		G723_FDMA_PAGES
 
 struct solo_snd_pcm {
-	int		on;
-	spinlock_t	lock;
-	struct solo_dev	*solo_dev;
-	unsigned char	g723_buf[G723_PERIOD_BYTES];
+	int				on;
+	spinlock_t			lock;
+	struct solo_dev		*solo_dev;
+	unsigned char			*g723_buf;
+	dma_addr_t			g723_dma;
 };
 
 static void solo_g723_config(struct solo_dev *solo_dev)
 {
 	int clk_div;
 
-	clk_div = SOLO_CLOCK_MHZ / (SAMPLERATE * (BITRATE * 2) * 2);
+	clk_div = (solo_dev->clock_mhz * 1000000)
+		/ (SAMPLERATE * (BITRATE * 2) * 2);
 
 	solo_reg_write(solo_dev, SOLO_AUDIO_SAMPLE,
-		       SOLO_AUDIO_BITRATE(BITRATE) |
-		       SOLO_AUDIO_CLK_DIV(clk_div));
+		       SOLO_AUDIO_BITRATE(BITRATE)
+		       | SOLO_AUDIO_CLK_DIV(clk_div));
 
 	solo_reg_write(solo_dev, SOLO_AUDIO_FDMA_INTR,
-		      SOLO_AUDIO_FDMA_INTERVAL(IRQ_PAGES) |
-		      SOLO_AUDIO_INTR_ORDER(G723_INTR_ORDER) |
-		      SOLO_AUDIO_FDMA_BASE(SOLO_G723_EXT_ADDR(solo_dev) >> 16));
+		       SOLO_AUDIO_FDMA_INTERVAL(1)
+		       | SOLO_AUDIO_INTR_ORDER(G723_INTR_ORDER)
+		       | SOLO_AUDIO_FDMA_BASE(SOLO_G723_EXT_ADDR(solo_dev) >> 16));
 
 	solo_reg_write(solo_dev, SOLO_AUDIO_CONTROL,
-		       SOLO_AUDIO_ENABLE | SOLO_AUDIO_I2S_MODE |
-		       SOLO_AUDIO_I2S_MULTI(3) | SOLO_AUDIO_MODE(OUTMODE_MASK));
+		       SOLO_AUDIO_ENABLE
+		       | SOLO_AUDIO_I2S_MODE
+		       | SOLO_AUDIO_I2S_MULTI(3)
+		       | SOLO_AUDIO_MODE(OUTMODE_MASK));
 }
 
 void solo_g723_isr(struct solo_dev *solo_dev)
@@ -85,8 +94,6 @@ void solo_g723_isr(struct solo_dev *solo_dev)
 	struct snd_pcm_substream *ss;
 	struct solo_snd_pcm *solo_pcm;
 
-	solo_reg_write(solo_dev, SOLO_IRQ_STAT, SOLO_IRQ_G723);
-
 	for (ss = pstr->substream; ss != NULL; ss = ss->next) {
 		if (snd_pcm_substream_chip(ss) == NULL)
 			continue;
@@ -115,18 +122,18 @@ static int snd_solo_hw_free(struct snd_pcm_substream *ss)
 	return snd_pcm_lib_free_pages(ss);
 }
 
-static struct snd_pcm_hardware snd_solo_pcm_hw = {
+static const struct snd_pcm_hardware snd_solo_pcm_hw = {
 	.info			= (SNDRV_PCM_INFO_MMAP |
 				   SNDRV_PCM_INFO_INTERLEAVED |
 				   SNDRV_PCM_INFO_BLOCK_TRANSFER |
 				   SNDRV_PCM_INFO_MMAP_VALID),
 	.formats		= SNDRV_PCM_FMTBIT_U8,
 	.rates			= SNDRV_PCM_RATE_8000,
-	.rate_min		= 8000,
-	.rate_max		= 8000,
+	.rate_min		= SAMPLERATE,
+	.rate_max		= SAMPLERATE,
 	.channels_min		= 1,
 	.channels_max		= 1,
-	.buffer_bytes_max	= MAX_BUFFER,
+	.buffer_bytes_max	= G723_MAX_BUFFER,
 	.period_bytes_min	= G723_PERIOD_BYTES,
 	.period_bytes_max	= G723_PERIOD_BYTES,
 	.periods_min		= PERIODS_MIN,
@@ -140,7 +147,13 @@ static int snd_solo_pcm_open(struct snd_pcm_substream *ss)
 
 	solo_pcm = kzalloc(sizeof(*solo_pcm), GFP_KERNEL);
 	if (solo_pcm == NULL)
-		return -ENOMEM;
+		goto oom;
+
+	solo_pcm->g723_buf = pci_alloc_consistent(solo_dev->pdev,
+						  G723_PERIOD_BYTES,
+						  &solo_pcm->g723_dma);
+	if (solo_pcm->g723_buf == NULL)
+		goto oom;
 
 	spin_lock_init(&solo_pcm->lock);
 	solo_pcm->solo_dev = solo_dev;
@@ -149,6 +162,10 @@ static int snd_solo_pcm_open(struct snd_pcm_substream *ss)
 	snd_pcm_substream_chip(ss) = solo_pcm;
 
 	return 0;
+
+oom:
+	kfree(solo_pcm);
+	return -ENOMEM;
 }
 
 static int snd_solo_pcm_close(struct snd_pcm_substream *ss)
@@ -156,6 +173,8 @@ static int snd_solo_pcm_close(struct snd_pcm_substream *ss)
 	struct solo_snd_pcm *solo_pcm = snd_pcm_substream_chip(ss);
 
 	snd_pcm_substream_chip(ss) = solo_pcm->solo_dev;
+	pci_free_consistent(solo_pcm->solo_dev->pdev, G723_PERIOD_BYTES,
+			    solo_pcm->g723_buf, solo_pcm->g723_dma);
 	kfree(solo_pcm);
 
 	return 0;
@@ -220,12 +239,11 @@ static int snd_solo_pcm_copy(struct snd_pcm_substream *ss, int channel,
 	for (i = 0; i < (count / G723_FRAMES_PER_PAGE); i++) {
 		int page = (pos / G723_FRAMES_PER_PAGE) + i;
 
-		err = solo_p2m_dma(solo_dev, SOLO_P2M_DMA_ID_G723E, 0,
-				   solo_pcm->g723_buf,
-				   SOLO_G723_EXT_ADDR(solo_dev) +
-				   (page * G723_PERIOD_BLOCK) +
-				   (ss->number * G723_PERIOD_BYTES),
-				   G723_PERIOD_BYTES);
+		err = solo_p2m_dma_t(solo_dev, 0, solo_pcm->g723_dma,
+				     SOLO_G723_EXT_ADDR(solo_dev) +
+				     (page * G723_PERIOD_BLOCK) +
+				     (ss->number * G723_PERIOD_BYTES),
+				     G723_PERIOD_BYTES, 0, 0);
 		if (err)
 			return err;
 
@@ -325,7 +343,7 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
 	ret = snd_pcm_lib_preallocate_pages_for_all(pcm,
 					SNDRV_DMA_TYPE_CONTINUOUS,
 					snd_dma_continuous_data(GFP_KERNEL),
-					MAX_BUFFER, MAX_BUFFER);
+					G723_MAX_BUFFER, G723_MAX_BUFFER);
 	if (ret < 0)
 		return ret;
 
@@ -368,6 +386,7 @@ int solo_g723_init(struct solo_dev *solo_dev)
 	strcpy(card->mixername, "SOLO-6x10");
 	kctl = snd_solo_capture_volume;
 	kctl.count = solo_dev->nr_chans;
+
 	ret = snd_ctl_add(card, snd_ctl_new1(&kctl, solo_dev));
 	if (ret < 0)
 		return ret;
@@ -393,8 +412,12 @@ snd_error:
 
 void solo_g723_exit(struct solo_dev *solo_dev)
 {
+	if (!solo_dev->snd_card)
+		return;
+
 	solo_reg_write(solo_dev, SOLO_AUDIO_CONTROL, 0);
 	solo_irq_off(solo_dev, SOLO_IRQ_G723);
 
 	snd_card_free(solo_dev->snd_card);
+	solo_dev->snd_card = NULL;
 }
diff --git a/drivers/staging/media/solo6x10/gpio.c b/drivers/staging/media/solo6x10/gpio.c
index 0925e6f..73276dc 100644
--- a/drivers/staging/media/solo6x10/gpio.c
+++ b/drivers/staging/media/solo6x10/gpio.c
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -19,7 +24,9 @@
 
 #include <linux/kernel.h>
 #include <linux/fs.h>
-#include <asm/uaccess.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+
 #include "solo6x10.h"
 
 static void solo_gpio_mode(struct solo_dev *solo_dev,
diff --git a/drivers/staging/media/solo6x10/i2c.c b/drivers/staging/media/solo6x10/i2c.c
index 398070a..01aa417 100644
--- a/drivers/staging/media/solo6x10/i2c.c
+++ b/drivers/staging/media/solo6x10/i2c.c
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -26,6 +31,7 @@
  * thread context, ACK the interrupt, and move on. -- BenC */
 
 #include <linux/kernel.h>
+
 #include "solo6x10.h"
 
 u8 solo_i2c_readbyte(struct solo_dev *solo_dev, int id, u8 addr, u8 off)
@@ -173,10 +179,9 @@ int solo_i2c_isr(struct solo_dev *solo_dev)
 	u32 status = solo_reg_read(solo_dev, SOLO_IIC_CTRL);
 	int ret = -EINVAL;
 
-	solo_reg_write(solo_dev, SOLO_IRQ_STAT, SOLO_IRQ_IIC);
 
-	if (status & (SOLO_IIC_STATE_TRNS | SOLO_IIC_STATE_SIG_ERR) ||
-	    solo_dev->i2c_id < 0) {
+	if (CHK_FLAGS(status, SOLO_IIC_STATE_TRNS | SOLO_IIC_STATE_SIG_ERR)
+	    || solo_dev->i2c_id < 0) {
 		solo_i2c_stop(solo_dev);
 		return -ENXIO;
 	}
@@ -239,7 +244,8 @@ static int solo_i2c_master_xfer(struct i2c_adapter *adap,
 	timeout = HZ / 2;
 
 	for (;;) {
-		prepare_to_wait(&solo_dev->i2c_wait, &wait, TASK_INTERRUPTIBLE);
+		prepare_to_wait(&solo_dev->i2c_wait, &wait,
+				TASK_INTERRUPTIBLE);
 
 		if (solo_dev->i2c_state == IIC_STATE_STOP)
 			break;
@@ -267,7 +273,7 @@ static u32 solo_i2c_functionality(struct i2c_adapter *adap)
 	return I2C_FUNC_I2C;
 }
 
-static struct i2c_algorithm solo_i2c_algo = {
+static const struct i2c_algorithm solo_i2c_algo = {
 	.master_xfer	= solo_i2c_master_xfer,
 	.functionality	= solo_i2c_functionality,
 };
@@ -288,7 +294,8 @@ int solo_i2c_init(struct solo_dev *solo_dev)
 	for (i = 0; i < SOLO_I2C_ADAPTERS; i++) {
 		struct i2c_adapter *adap = &solo_dev->i2c_adap[i];
 
-		snprintf(adap->name, I2C_NAME_SIZE, "%s I2C %d", SOLO6X10_NAME, i);
+		snprintf(adap->name, I2C_NAME_SIZE, "%s I2C %d",
+			 SOLO6X10_NAME, i);
 		adap->algo = &solo_i2c_algo;
 		adap->algo_data = solo_dev;
 		adap->retries = 1;
@@ -311,9 +318,6 @@ int solo_i2c_init(struct solo_dev *solo_dev)
 		return ret;
 	}
 
-	dev_info(&solo_dev->pdev->dev, "Enabled %d i2c adapters\n",
-		 SOLO_I2C_ADAPTERS);
-
 	return 0;
 }
 
diff --git a/drivers/staging/media/solo6x10/offsets.h b/drivers/staging/media/solo6x10/offsets.h
index 3d7e569..f005dca 100644
--- a/drivers/staging/media/solo6x10/offsets.h
+++ b/drivers/staging/media/solo6x10/offsets.h
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -20,55 +25,61 @@
 #ifndef __SOLO6X10_OFFSETS_H
 #define __SOLO6X10_OFFSETS_H
 
-/* Offsets and sizes of the external address */
 #define SOLO_DISP_EXT_ADDR			0x00000000
 #define SOLO_DISP_EXT_SIZE			0x00480000
 
-#define SOLO_DEC2LIVE_EXT_ADDR (SOLO_DISP_EXT_ADDR + SOLO_DISP_EXT_SIZE)
-#define SOLO_DEC2LIVE_EXT_SIZE			0x00240000
-
-#define SOLO_OSG_EXT_ADDR (SOLO_DEC2LIVE_EXT_ADDR + SOLO_DEC2LIVE_EXT_SIZE)
-#define SOLO_OSG_EXT_SIZE			0x00120000
+#define SOLO_EOSD_EXT_ADDR \
+	(SOLO_DISP_EXT_ADDR + SOLO_DISP_EXT_SIZE)
+#define SOLO_EOSD_EXT_SIZE(__solo) \
+	(__solo->type == SOLO_DEV_6010 ? 0x10000 : 0x20000)
+#define SOLO_EOSD_EXT_SIZE_MAX			0x20000
+#define SOLO_EOSD_EXT_AREA(__solo) \
+	(SOLO_EOSD_EXT_SIZE(__solo) * 32)
 
-#define SOLO_EOSD_EXT_ADDR (SOLO_OSG_EXT_ADDR + SOLO_OSG_EXT_SIZE)
-#define SOLO_EOSD_EXT_SIZE			0x00010000
-
-#define SOLO_MOTION_EXT_ADDR(__solo) (SOLO_EOSD_EXT_ADDR +	\
-				      (SOLO_EOSD_EXT_SIZE * __solo->nr_chans))
+#define SOLO_MOTION_EXT_ADDR(__solo) \
+	(SOLO_EOSD_EXT_ADDR + SOLO_EOSD_EXT_AREA(__solo))
 #define SOLO_MOTION_EXT_SIZE			0x00080000
 
 #define SOLO_G723_EXT_ADDR(__solo) \
-		(SOLO_MOTION_EXT_ADDR(__solo) + SOLO_MOTION_EXT_SIZE)
+	(SOLO_MOTION_EXT_ADDR(__solo) + SOLO_MOTION_EXT_SIZE)
 #define SOLO_G723_EXT_SIZE			0x00010000
 
 #define SOLO_CAP_EXT_ADDR(__solo) \
-		(SOLO_G723_EXT_ADDR(__solo) + SOLO_G723_EXT_SIZE)
-#define SOLO_CAP_EXT_MAX_PAGE			(18 + 15)
-#define SOLO_CAP_EXT_SIZE			(SOLO_CAP_EXT_MAX_PAGE * 65536)
+	(SOLO_G723_EXT_ADDR(__solo) + SOLO_G723_EXT_SIZE)
+
+/* 18 is the maximum number of pages required for PAL@D1, the largest frame
+ * possible */
+#define SOLO_CAP_PAGE_SIZE			(18 << 16)
+
+/* Always allow the encoder enough for 16 channels, even if we have less. The
+ * exception is if we have card with only 32Megs of memory. */
+#define SOLO_CAP_EXT_SIZE(__solo) \
+	((((__solo->sdram_size <= (32 << 20)) ? 4 : 16) + 1)	\
+	 * SOLO_CAP_PAGE_SIZE)
 
-/* This +1 is very important -- Why?! -- BenC */
 #define SOLO_EREF_EXT_ADDR(__solo) \
-		(SOLO_CAP_EXT_ADDR(__solo) + \
-		 (SOLO_CAP_EXT_SIZE * (__solo->nr_chans + 1)))
+	(SOLO_CAP_EXT_ADDR(__solo) + SOLO_CAP_EXT_SIZE(__solo))
 #define SOLO_EREF_EXT_SIZE			0x00140000
+#define SOLO_EREF_EXT_AREA(__solo) \
+	(SOLO_EREF_EXT_SIZE * __solo->nr_chans * 2)
+
+#define __SOLO_JPEG_MIN_SIZE(__solo)		(__solo->nr_chans * 0x00080000)
 
 #define SOLO_MP4E_EXT_ADDR(__solo) \
-		(SOLO_EREF_EXT_ADDR(__solo) + \
-		 (SOLO_EREF_EXT_SIZE * __solo->nr_chans))
-#define SOLO_MP4E_EXT_SIZE(__solo)		(0x00080000 * __solo->nr_chans)
+	(SOLO_EREF_EXT_ADDR(__solo) + SOLO_EREF_EXT_AREA(__solo))
+#define SOLO_MP4E_EXT_SIZE(__solo) \
+	max((__solo->nr_chans * 0x00080000),				\
+	    min(((__solo->sdram_size - SOLO_MP4E_EXT_ADDR(__solo)) -	\
+		 __SOLO_JPEG_MIN_SIZE(__solo)), 0x00ff0000))
 
-#define SOLO_DREF_EXT_ADDR(__solo) \
+#define __SOLO_JPEG_MIN_SIZE(__solo)		(__solo->nr_chans * 0x00080000)
+#define SOLO_JPEG_EXT_ADDR(__solo) \
 		(SOLO_MP4E_EXT_ADDR(__solo) + SOLO_MP4E_EXT_SIZE(__solo))
-#define SOLO_DREF_EXT_SIZE			0x00140000
+#define SOLO_JPEG_EXT_SIZE(__solo) \
+	max(__SOLO_JPEG_MIN_SIZE(__solo),				\
+	    min((__solo->sdram_size - SOLO_JPEG_EXT_ADDR(__solo)), 0x00ff0000))
 
-#define SOLO_MP4D_EXT_ADDR(__solo) \
-		(SOLO_DREF_EXT_ADDR(__solo) + \
-		 (SOLO_DREF_EXT_SIZE * __solo->nr_chans))
-#define SOLO_MP4D_EXT_SIZE			0x00080000
-
-#define SOLO_JPEG_EXT_ADDR(__solo) \
-		(SOLO_MP4D_EXT_ADDR(__solo) + \
-		 (SOLO_MP4D_EXT_SIZE * __solo->nr_chans))
-#define SOLO_JPEG_EXT_SIZE(__solo)		(0x00080000 * __solo->nr_chans)
+#define SOLO_SDRAM_END(__solo) \
+	(SOLO_JPEG_EXT_ADDR(__solo) + SOLO_JPEG_EXT_SIZE(__solo))
 
 #endif /* __SOLO6X10_OFFSETS_H */
diff --git a/drivers/staging/media/solo6x10/osd-font.h b/drivers/staging/media/solo6x10/osd-font.h
deleted file mode 100644
index 591e0e8..0000000
--- a/drivers/staging/media/solo6x10/osd-font.h
+++ /dev/null
@@ -1,154 +0,0 @@
-/*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef __SOLO6X10_OSD_FONT_H
-#define __SOLO6X10_OSD_FONT_H
-
-static const unsigned int solo_osd_font[] = {
-	0x00000000, 0x0000c0c8, 0xccfefe0c, 0x08000000,
-	0x00000000, 0x10103838, 0x7c7cfefe, 0x00000000,	/* 0 */
-	0x00000000, 0xfefe7c7c, 0x38381010, 0x10000000,
-	0x00000000, 0x7c82fefe, 0xfefefe7c, 0x00000000,
-	0x00000000, 0x00001038, 0x10000000, 0x00000000,
-	0x00000000, 0x0010387c, 0xfe7c3810, 0x00000000,
-	0x00000000, 0x00384444, 0x44380000, 0x00000000,
-	0x00000000, 0x38448282, 0x82443800, 0x00000000,
-	0x00000000, 0x007c7c7c, 0x7c7c0000, 0x00000000,
-	0x00000000, 0x6c6c6c6c, 0x6c6c6c6c, 0x00000000,
-	0x00000000, 0x061e7efe, 0xfe7e1e06, 0x00000000,
-	0x00000000, 0xc0f0fcfe, 0xfefcf0c0, 0x00000000,
-	0x00000000, 0xc6cedefe, 0xfedecec6, 0x00000000,
-	0x00000000, 0xc6e6f6fe, 0xfef6e6c6, 0x00000000,
-	0x00000000, 0x12367efe, 0xfe7e3612, 0x00000000,
-	0x00000000, 0x90d8fcfe, 0xfefcd890, 0x00000000,
-	0x00000038, 0x7cc692ba, 0x92c67c38, 0x00000000,
-	0x00000038, 0x7cc6aa92, 0xaac67c38, 0x00000000,
-	0x00000038, 0x7830107c, 0xbaa8680c, 0x00000000,
-	0x00000038, 0x3c18127c, 0xb8382c60, 0x00000000,
-	0x00000044, 0xaa6c8254, 0x38eec67c, 0x00000000,
-	0x00000082, 0x44288244, 0x38c6827c, 0x00000000,
-	0x00000038, 0x444444fe, 0xfeeec6fe, 0x00000000,
-	0x00000018, 0x78187818, 0x3c7e7e3c, 0x00000000,
-	0x00000000, 0x3854929a, 0x82443800, 0x00000000,
-	0x00000000, 0x00c0c8cc, 0xfefe0c08, 0x00000000,
-	0x0000e0a0, 0xe040e00e, 0x8a0ea40e, 0x00000000,
-	0x0000e0a0, 0xe040e00e, 0x0a8e440e, 0x00000000,
-	0x0000007c, 0x82829292, 0x929282fe, 0x00000000,
-	0x000000f8, 0xfc046494, 0x946404fc, 0x00000000,
-	0x0000003f, 0x7f404c52, 0x524c407f, 0x00000000,
-	0x0000007c, 0x82ba82ba, 0x82ba82fe, 0x00000000,
-	0x00000000, 0x00000000, 0x00000000, 0x00000000,
-	0x00000000, 0x183c3c3c, 0x18180018, 0x18000000,	/* 32   ! */
-	0x00000066, 0x66240000, 0x00000000, 0x00000000,
-	0x00000000, 0x6c6cfe6c, 0x6c6cfe6c, 0x6c000000,	/* 34 " # */
-	0x00001010, 0x7cd6d616, 0x7cd0d6d6, 0x7c101000,
-	0x00000000, 0x0086c660, 0x30180cc6, 0xc2000000,	/* 36 $ % */
-	0x00000000, 0x386c6c38, 0xdc766666, 0xdc000000,
-	0x0000000c, 0x0c0c0600, 0x00000000, 0x00000000,	/* 38 & ' */
-	0x00000000, 0x30180c0c, 0x0c0c0c18, 0x30000000,
-	0x00000000, 0x0c183030, 0x30303018, 0x0c000000,	/* 40 ( ) */
-	0x00000000, 0x0000663c, 0xff3c6600, 0x00000000,
-	0x00000000, 0x00001818, 0x7e181800, 0x00000000,	/* 42 * + */
-	0x00000000, 0x00000000, 0x00000e0e, 0x0c060000,
-	0x00000000, 0x00000000, 0x7e000000, 0x00000000,	/* 44 , - */
-	0x00000000, 0x00000000, 0x00000006, 0x06000000,
-	0x00000000, 0x80c06030, 0x180c0602, 0x00000000,	/* 46 . / */
-	0x0000007c, 0xc6e6f6de, 0xcec6c67c, 0x00000000,
-	0x00000030, 0x383c3030, 0x303030fc, 0x00000000,	/* 48 0 1 */
-	0x0000007c, 0xc6c06030, 0x180cc6fe, 0x00000000,
-	0x0000007c, 0xc6c0c07c, 0xc0c0c67c, 0x00000000,	/* 50 2 3 */
-	0x00000060, 0x70786c66, 0xfe6060f0, 0x00000000,
-	0x000000fe, 0x0606067e, 0xc0c0c67c, 0x00000000,	/* 52 4 5 */
-	0x00000038, 0x0c06067e, 0xc6c6c67c, 0x00000000,
-	0x000000fe, 0xc6c06030, 0x18181818, 0x00000000,	/* 54 6 7 */
-	0x0000007c, 0xc6c6c67c, 0xc6c6c67c, 0x00000000,
-	0x0000007c, 0xc6c6c6fc, 0xc0c06038, 0x00000000,	/* 56 8 9 */
-	0x00000000, 0x18180000, 0x00181800, 0x00000000,
-	0x00000000, 0x18180000, 0x0018180c, 0x00000000,	/* 58 : ; */
-	0x00000060, 0x30180c06, 0x0c183060, 0x00000000,
-	0x00000000, 0x007e0000, 0x007e0000, 0x00000000,
-	0x00000006, 0x0c183060, 0x30180c06, 0x00000000,
-	0x0000007c, 0xc6c66030, 0x30003030, 0x00000000,
-	0x0000007c, 0xc6f6d6d6, 0x7606067c, 0x00000000,
-	0x00000010, 0x386cc6c6, 0xfec6c6c6, 0x00000000,	/* 64 @ A */
-	0x0000007e, 0xc6c6c67e, 0xc6c6c67e, 0x00000000,
-	0x00000078, 0xcc060606, 0x0606cc78, 0x00000000,	/* 66 */
-	0x0000003e, 0x66c6c6c6, 0xc6c6663e, 0x00000000,
-	0x000000fe, 0x0606063e, 0x060606fe, 0x00000000,	/* 68 */
-	0x000000fe, 0x0606063e, 0x06060606, 0x00000000,
-	0x00000078, 0xcc060606, 0xf6c6ccb8, 0x00000000,	/* 70 */
-	0x000000c6, 0xc6c6c6fe, 0xc6c6c6c6, 0x00000000,
-	0x0000003c, 0x18181818, 0x1818183c, 0x00000000,	/* 72 */
-	0x00000060, 0x60606060, 0x6066663c, 0x00000000,
-	0x000000c6, 0xc666361e, 0x3666c6c6, 0x00000000,	/* 74 */
-	0x00000006, 0x06060606, 0x060606fe, 0x00000000,
-	0x000000c6, 0xeefed6c6, 0xc6c6c6c6, 0x00000000,	/* 76 */
-	0x000000c6, 0xcedefef6, 0xe6c6c6c6, 0x00000000,
-	0x00000038, 0x6cc6c6c6, 0xc6c66c38, 0x00000000,	/* 78 */
-	0x0000007e, 0xc6c6c67e, 0x06060606, 0x00000000,
-	0x00000038, 0x6cc6c6c6, 0xc6d67c38, 0x60000000,	/* 80 */
-	0x0000007e, 0xc6c6c67e, 0x66c6c6c6, 0x00000000,
-	0x0000007c, 0xc6c60c38, 0x60c6c67c, 0x00000000,	/* 82 */
-	0x0000007e, 0x18181818, 0x18181818, 0x00000000,
-	0x000000c6, 0xc6c6c6c6, 0xc6c6c67c, 0x00000000,	/* 84 */
-	0x000000c6, 0xc6c6c6c6, 0xc66c3810, 0x00000000,
-	0x000000c6, 0xc6c6c6c6, 0xd6d6fe6c, 0x00000000,	/* 86 */
-	0x000000c6, 0xc6c66c38, 0x6cc6c6c6, 0x00000000,
-	0x00000066, 0x66666666, 0x3c181818, 0x00000000,	/* 88 */
-	0x000000fe, 0xc0603018, 0x0c0606fe, 0x00000000,
-	0x0000003c, 0x0c0c0c0c, 0x0c0c0c3c, 0x00000000,	/* 90 */
-	0x00000002, 0x060c1830, 0x60c08000, 0x00000000,
-	0x0000003c, 0x30303030, 0x3030303c, 0x00000000,	/* 92 */
-	0x00001038, 0x6cc60000, 0x00000000, 0x00000000,
-	0x00000000, 0x00000000, 0x00000000, 0x00fe0000,
-	0x00001818, 0x30000000, 0x00000000, 0x00000000,
-	0x00000000, 0x00003c60, 0x7c66667c, 0x00000000,
-	0x0000000c, 0x0c0c7ccc, 0xcccccc7c, 0x00000000,
-	0x00000000, 0x00007cc6, 0x0606c67c, 0x00000000,
-	0x00000060, 0x60607c66, 0x6666667c, 0x00000000,
-	0x00000000, 0x00007cc6, 0xfe06c67c, 0x00000000,
-	0x00000078, 0x0c0c0c3e, 0x0c0c0c0c, 0x00000000,
-	0x00000000, 0x00007c66, 0x6666667c, 0x60603e00,
-	0x0000000c, 0x0c0c7ccc, 0xcccccccc, 0x00000000,
-	0x00000030, 0x30003830, 0x30303078, 0x00000000,
-	0x00000030, 0x30003c30, 0x30303030, 0x30301f00,
-	0x0000000c, 0x0c0ccc6c, 0x3c6ccccc, 0x00000000,
-	0x00000030, 0x30303030, 0x30303030, 0x00000000,
-	0x00000000, 0x000066fe, 0xd6d6d6d6, 0x00000000,
-	0x00000000, 0x000078cc, 0xcccccccc, 0x00000000,
-	0x00000000, 0x00007cc6, 0xc6c6c67c, 0x00000000,
-	0x00000000, 0x00007ccc, 0xcccccc7c, 0x0c0c0c00,
-	0x00000000, 0x00007c66, 0x6666667c, 0x60606000,
-	0x00000000, 0x000076dc, 0x0c0c0c0c, 0x00000000,
-	0x00000000, 0x00007cc6, 0x1c70c67c, 0x00000000,
-	0x00000000, 0x1818fe18, 0x18181870, 0x00000000,
-	0x00000000, 0x00006666, 0x6666663c, 0x00000000,
-	0x00000000, 0x0000c6c6, 0xc66c3810, 0x00000000,
-	0x00000000, 0x0000c6d6, 0xd6d6fe6c, 0x00000000,
-	0x00000000, 0x0000c66c, 0x38386cc6, 0x00000000,
-	0x00000000, 0x00006666, 0x6666667c, 0x60603e00,
-	0x00000000, 0x0000fe60, 0x30180cfe, 0x00000000,
-	0x00000070, 0x1818180e, 0x18181870, 0x00000000,
-	0x00000018, 0x18181800, 0x18181818, 0x00000000,
-	0x0000000e, 0x18181870, 0x1818180e, 0x00000000,
-	0x000000dc, 0x76000000, 0x00000000, 0x00000000,
-	0x00000000, 0x0010386c, 0xc6c6fe00, 0x00000000
-};
-
-#endif /* __SOLO6X10_OSD_FONT_H */
diff --git a/drivers/staging/media/solo6x10/p2m.c b/drivers/staging/media/solo6x10/p2m.c
index 58ab61b..3ed4d58 100644
--- a/drivers/staging/media/solo6x10/p2m.c
+++ b/drivers/staging/media/solo6x10/p2m.c
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -18,28 +23,37 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/scatterlist.h>
+#include <linux/module.h>
+
 #include "solo6x10.h"
 
-/* #define SOLO_TEST_P2M */
+static int multi_p2m;
+module_param(multi_p2m, uint, 0644);
+MODULE_PARM_DESC(multi_p2m,
+		 "Use multiple P2M DMA channels (default: no, 6010-only)");
 
-int solo_p2m_dma(struct solo_dev *solo_dev, u8 id, int wr,
-		 void *sys_addr, u32 ext_addr, u32 size)
+static int desc_mode;
+module_param(desc_mode, uint, 0644);
+MODULE_PARM_DESC(desc_mode,
+		 "Allow use of descriptor mode DMA (default: no, 6010-only)");
+
+int solo_p2m_dma(struct solo_dev *solo_dev, int wr,
+		 void *sys_addr, u32 ext_addr, u32 size,
+		 int repeat, u32 ext_size)
 {
 	dma_addr_t dma_addr;
 	int ret;
 
-	WARN_ON(!size);
-	BUG_ON(id >= SOLO_NR_P2M);
-
-	if (!size)
+	if (WARN_ON_ONCE((unsigned long)sys_addr & 0x03))
+		return -EINVAL;
+	if (WARN_ON_ONCE(!size))
 		return -EINVAL;
 
 	dma_addr = pci_map_single(solo_dev->pdev, sys_addr, size,
 				  wr ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
 
-	ret = solo_p2m_dma_t(solo_dev, id, wr, dma_addr, ext_addr, size);
+	ret = solo_p2m_dma_t(solo_dev, wr, dma_addr, ext_addr, size,
+			     repeat, ext_size);
 
 	pci_unmap_single(solo_dev->pdev, dma_addr, size,
 			 wr ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
@@ -47,221 +61,141 @@ int solo_p2m_dma(struct solo_dev *solo_dev, u8 id, int wr,
 	return ret;
 }
 
-int solo_p2m_dma_t(struct solo_dev *solo_dev, u8 id, int wr,
-		   dma_addr_t dma_addr, u32 ext_addr, u32 size)
-{
-	struct p2m_desc *desc = kzalloc(sizeof(*desc) * 2, GFP_DMA);
-	int ret;
-
-	if (desc == NULL)
-		return -ENOMEM;
-
-	solo_p2m_push_desc(&desc[1], wr, dma_addr, ext_addr, size, 0, 0);
-	ret = solo_p2m_dma_desc(solo_dev, id, desc, 2);
-	kfree(desc);
-
-	return ret;
-}
-
-void solo_p2m_push_desc(struct p2m_desc *desc, int wr, dma_addr_t dma_addr,
-			u32 ext_addr, u32 size, int repeat, u32 ext_size)
-{
-	desc->ta = cpu_to_le32(dma_addr);
-	desc->fa = cpu_to_le32(ext_addr);
-
-	desc->ext = cpu_to_le32(SOLO_P2M_COPY_SIZE(size >> 2));
-	desc->ctrl = cpu_to_le32(SOLO_P2M_BURST_SIZE(SOLO_P2M_BURST_256) |
-				 (wr ? SOLO_P2M_WRITE : 0) | SOLO_P2M_TRANS_ON);
-
-	/* Ext size only matters when we're repeating */
-	if (repeat) {
-		desc->ext |= cpu_to_le32(SOLO_P2M_EXT_INC(ext_size >> 2));
-		desc->ctrl |=  cpu_to_le32(SOLO_P2M_PCI_INC(size >> 2) |
-					   SOLO_P2M_REPEAT(repeat));
-	}
-}
-
-int solo_p2m_dma_desc(struct solo_dev *solo_dev, u8 id,
-		      struct p2m_desc *desc, int desc_count)
+/* Mutex must be held for p2m_id before calling this!! */
+int solo_p2m_dma_desc(struct solo_dev *solo_dev,
+		      struct solo_p2m_desc *desc, dma_addr_t desc_dma,
+		      int desc_cnt)
 {
 	struct solo_p2m_dev *p2m_dev;
 	unsigned int timeout;
+	unsigned int config = 0;
 	int ret = 0;
-	u32 config = 0;
-	dma_addr_t desc_dma = 0;
+	int p2m_id = 0;
 
-	BUG_ON(id >= SOLO_NR_P2M);
-	BUG_ON(!desc_count || desc_count > SOLO_NR_P2M_DESC);
+	/* Get next ID. According to Softlogic, 6110 has problems on !=0 P2M */
+	if (solo_dev->type != SOLO_DEV_6110 && multi_p2m) {
+		p2m_id = atomic_inc_return(&solo_dev->p2m_count) % SOLO_NR_P2M;
+		if (p2m_id < 0)
+			p2m_id = -p2m_id;
+	}
 
-	p2m_dev = &solo_dev->p2m_dev[id];
+	p2m_dev = &solo_dev->p2m_dev[p2m_id];
 
-	mutex_lock(&p2m_dev->mutex);
-
-	solo_reg_write(solo_dev, SOLO_P2M_CONTROL(id), 0);
+	if (mutex_lock_interruptible(&p2m_dev->mutex))
+		return -EINTR;
 
 	INIT_COMPLETION(p2m_dev->completion);
 	p2m_dev->error = 0;
 
-	/* Enable the descriptors */
-	config = solo_reg_read(solo_dev, SOLO_P2M_CONFIG(id));
-	desc_dma = pci_map_single(solo_dev->pdev, desc,
-				  desc_count * sizeof(*desc),
-				  PCI_DMA_TODEVICE);
-	solo_reg_write(solo_dev, SOLO_P2M_DES_ADR(id), desc_dma);
-	solo_reg_write(solo_dev, SOLO_P2M_DESC_ID(id), desc_count - 1);
-	solo_reg_write(solo_dev, SOLO_P2M_CONFIG(id), config |
-		       SOLO_P2M_DESC_MODE);
-
-	/* Should have all descriptors completed from one interrupt */
-	timeout = wait_for_completion_timeout(&p2m_dev->completion, HZ);
-
-	solo_reg_write(solo_dev, SOLO_P2M_CONTROL(id), 0);
+	if (desc_cnt > 1 && solo_dev->type != SOLO_DEV_6110 && desc_mode) {
+		/* For 6010 with more than one desc, we can do a one-shot */
+		p2m_dev->desc_count = p2m_dev->desc_idx = 0;
+		config = solo_reg_read(solo_dev, SOLO_P2M_CONFIG(p2m_id));
+
+		solo_reg_write(solo_dev, SOLO_P2M_DES_ADR(p2m_id), desc_dma);
+		solo_reg_write(solo_dev, SOLO_P2M_DESC_ID(p2m_id), desc_cnt);
+		solo_reg_write(solo_dev, SOLO_P2M_CONFIG(p2m_id), config |
+			       SOLO_P2M_DESC_MODE);
+	} else {
+		/* For single descriptors and 6110, we need to run each desc */
+		p2m_dev->desc_count = desc_cnt;
+		p2m_dev->desc_idx = 1;
+		p2m_dev->descs = desc;
+
+		solo_reg_write(solo_dev, SOLO_P2M_TAR_ADR(p2m_id),
+			       desc[1].dma_addr);
+		solo_reg_write(solo_dev, SOLO_P2M_EXT_ADR(p2m_id),
+			       desc[1].ext_addr);
+		solo_reg_write(solo_dev, SOLO_P2M_EXT_CFG(p2m_id),
+			       desc[1].cfg);
+		solo_reg_write(solo_dev, SOLO_P2M_CONTROL(p2m_id),
+			       desc[1].ctrl);
+	}
 
-	/* Reset back to non-descriptor mode */
-	solo_reg_write(solo_dev, SOLO_P2M_CONFIG(id), config);
-	solo_reg_write(solo_dev, SOLO_P2M_DESC_ID(id), 0);
-	solo_reg_write(solo_dev, SOLO_P2M_DES_ADR(id), 0);
-	pci_unmap_single(solo_dev->pdev, desc_dma,
-			 desc_count * sizeof(*desc),
-			 PCI_DMA_TODEVICE);
+	timeout = wait_for_completion_timeout(&p2m_dev->completion,
+					      solo_dev->p2m_jiffies);
 
-	if (p2m_dev->error)
+	if (WARN_ON_ONCE(p2m_dev->error))
 		ret = -EIO;
-	else if (timeout == 0)
+	else if (timeout == 0) {
+		solo_dev->p2m_timeouts++;
 		ret = -EAGAIN;
-
-	mutex_unlock(&p2m_dev->mutex);
-
-	WARN_ON_ONCE(ret);
-
-	return ret;
-}
-
-int solo_p2m_dma_sg(struct solo_dev *solo_dev, u8 id,
-		    struct p2m_desc *pdesc, int wr,
-		    struct scatterlist *sg, u32 sg_off,
-		    u32 ext_addr, u32 size)
-{
-	int i;
-	int idx;
-
-	BUG_ON(id >= SOLO_NR_P2M);
-
-	if (WARN_ON_ONCE(!size))
-		return -EINVAL;
-
-	memset(pdesc, 0, sizeof(*pdesc));
-
-	/* Should rewrite this to handle > SOLO_NR_P2M_DESC transactions */
-	for (i = 0, idx = 1; idx < SOLO_NR_P2M_DESC && sg && size > 0;
-	     i++, sg = sg_next(sg)) {
-		struct p2m_desc *desc = &pdesc[idx];
-		u32 sg_len = sg_dma_len(sg);
-		u32 len;
-
-		if (sg_off >= sg_len) {
-			sg_off -= sg_len;
-			continue;
-		}
-
-		sg_len -= sg_off;
-		len = min(sg_len, size);
-
-		solo_p2m_push_desc(desc, wr, sg_dma_address(sg) + sg_off,
-				   ext_addr, len, 0, 0);
-
-		size -= len;
-		ext_addr += len;
-		idx++;
-
-		sg_off = 0;
 	}
 
-	WARN_ON_ONCE(size || i >= SOLO_NR_P2M_DESC);
+	solo_reg_write(solo_dev, SOLO_P2M_CONTROL(p2m_id), 0);
 
-	return solo_p2m_dma_desc(solo_dev, id, pdesc, idx);
-}
+	/* Don't write here for the no_desc_mode case, because config is 0.
+	 * We can't test no_desc_mode again, it might race. */
+	if (desc_cnt > 1 && solo_dev->type != SOLO_DEV_6110 && config)
+		solo_reg_write(solo_dev, SOLO_P2M_CONFIG(p2m_id), config);
 
-#ifdef SOLO_TEST_P2M
+	mutex_unlock(&p2m_dev->mutex);
 
-#define P2M_TEST_CHAR		0xbe
+	return ret;
+}
 
-static unsigned long long p2m_test(struct solo_dev *solo_dev, u8 id,
-				   u32 base, int size)
+void solo_p2m_fill_desc(struct solo_p2m_desc *desc, int wr,
+			dma_addr_t dma_addr, u32 ext_addr, u32 size,
+			int repeat, u32 ext_size)
 {
-	u8 *wr_buf;
-	u8 *rd_buf;
-	int i;
-	unsigned long long err_cnt = 0;
+	WARN_ON_ONCE(dma_addr & 0x03);
+	WARN_ON_ONCE(!size);
 
-	wr_buf = kmalloc(size, GFP_KERNEL);
-	if (!wr_buf) {
-		printk(SOLO6X10_NAME ": Failed to malloc for p2m_test\n");
-		return size;
-	}
+	desc->cfg = SOLO_P2M_COPY_SIZE(size >> 2);
+	desc->ctrl = SOLO_P2M_BURST_SIZE(SOLO_P2M_BURST_256) |
+		(wr ? SOLO_P2M_WRITE : 0) | SOLO_P2M_TRANS_ON;
 
-	rd_buf = kmalloc(size, GFP_KERNEL);
-	if (!rd_buf) {
-		printk(SOLO6X10_NAME ": Failed to malloc for p2m_test\n");
-		kfree(wr_buf);
-		return size;
+	if (repeat) {
+		desc->cfg |= SOLO_P2M_EXT_INC(ext_size >> 2);
+		desc->ctrl |=  SOLO_P2M_PCI_INC(size >> 2) |
+			 SOLO_P2M_REPEAT(repeat);
 	}
 
-	memset(wr_buf, P2M_TEST_CHAR, size);
-	memset(rd_buf, P2M_TEST_CHAR + 1, size);
-
-	solo_p2m_dma(solo_dev, id, 1, wr_buf, base, size);
-	solo_p2m_dma(solo_dev, id, 0, rd_buf, base, size);
-
-	for (i = 0; i < size; i++)
-		if (wr_buf[i] != rd_buf[i])
-			err_cnt++;
-
-	kfree(wr_buf);
-	kfree(rd_buf);
-
-	return err_cnt;
+	desc->dma_addr = dma_addr;
+	desc->ext_addr = ext_addr;
 }
 
-#define TEST_CHUNK_SIZE		(8 * 1024)
-
-static void run_p2m_test(struct solo_dev *solo_dev)
+int solo_p2m_dma_t(struct solo_dev *solo_dev, int wr,
+		   dma_addr_t dma_addr, u32 ext_addr, u32 size,
+		   int repeat, u32 ext_size)
 {
-	unsigned long long errs = 0;
-	u32 size = SOLO_JPEG_EXT_ADDR(solo_dev) + SOLO_JPEG_EXT_SIZE(solo_dev);
-	int i, d;
+	struct solo_p2m_desc desc[2];
 
-	dev_warn(&solo_dev->pdev->dev, "Testing %u bytes of external ram\n",
-		 size);
+	solo_p2m_fill_desc(&desc[1], wr, dma_addr, ext_addr, size, repeat,
+			   ext_size);
 
-	for (i = 0; i < size; i += TEST_CHUNK_SIZE)
-		for (d = 0; d < 4; d++)
-			errs += p2m_test(solo_dev, d, i, TEST_CHUNK_SIZE);
-
-	dev_warn(&solo_dev->pdev->dev, "Found %llu errors during p2m test\n",
-		 errs);
-
-	return;
+	/* No need for desc_dma since we know it is a single-shot */
+	return solo_p2m_dma_desc(solo_dev, desc, 0, 1);
 }
-#else
-#define run_p2m_test(__solo)	do {} while (0)
-#endif
 
 void solo_p2m_isr(struct solo_dev *solo_dev, int id)
 {
 	struct solo_p2m_dev *p2m_dev = &solo_dev->p2m_dev[id];
+	struct solo_p2m_desc *desc;
+
+	if (p2m_dev->desc_count <= p2m_dev->desc_idx) {
+		complete(&p2m_dev->completion);
+		return;
+	}
 
-	solo_reg_write(solo_dev, SOLO_IRQ_STAT, SOLO_IRQ_P2M(id));
+	/* Setup next descriptor */
+	p2m_dev->desc_idx++;
+	desc = &p2m_dev->descs[p2m_dev->desc_idx];
 
-	complete(&p2m_dev->completion);
+	solo_reg_write(solo_dev, SOLO_P2M_CONTROL(id), 0);
+	solo_reg_write(solo_dev, SOLO_P2M_TAR_ADR(id), desc->dma_addr);
+	solo_reg_write(solo_dev, SOLO_P2M_EXT_ADR(id), desc->ext_addr);
+	solo_reg_write(solo_dev, SOLO_P2M_EXT_CFG(id), desc->cfg);
+	solo_reg_write(solo_dev, SOLO_P2M_CONTROL(id), desc->ctrl);
 }
 
-void solo_p2m_error_isr(struct solo_dev *solo_dev, u32 status)
+void solo_p2m_error_isr(struct solo_dev *solo_dev)
 {
+	unsigned int err = solo_reg_read(solo_dev, SOLO_PCI_ERR);
 	struct solo_p2m_dev *p2m_dev;
 	int i;
 
-	if (!(status & SOLO_PCI_ERR_P2M))
+	if (!(err & SOLO_PCI_ERR_P2M))
 		return;
 
 	for (i = 0; i < SOLO_NR_P2M; i++) {
@@ -280,6 +214,52 @@ void solo_p2m_exit(struct solo_dev *solo_dev)
 		solo_irq_off(solo_dev, SOLO_IRQ_P2M(i));
 }
 
+static int solo_p2m_test(struct solo_dev *solo_dev, int base, int size)
+{
+	u32 *wr_buf;
+	u32 *rd_buf;
+	int i;
+	int ret = -EIO;
+	int order = get_order(size);
+
+	wr_buf = (u32 *)__get_free_pages(GFP_KERNEL, order);
+	if (wr_buf == NULL)
+		return -1;
+
+	rd_buf = (u32 *)__get_free_pages(GFP_KERNEL, order);
+	if (rd_buf == NULL) {
+		free_pages((unsigned long)wr_buf, order);
+		return -1;
+	}
+
+	for (i = 0; i < (size >> 3); i++)
+		*(wr_buf + i) = (i << 16) | (i + 1);
+
+	for (i = (size >> 3); i < (size >> 2); i++)
+		*(wr_buf + i) = ~((i << 16) | (i + 1));
+
+	memset(rd_buf, 0x55, size);
+
+	if (solo_p2m_dma(solo_dev, 1, wr_buf, base, size, 0, 0))
+		goto test_fail;
+
+	if (solo_p2m_dma(solo_dev, 0, rd_buf, base, size, 0, 0))
+		goto test_fail;
+
+	for (i = 0; i < (size >> 2); i++) {
+		if (*(wr_buf + i) != *(rd_buf + i))
+			goto test_fail;
+	}
+
+	ret = 0;
+
+test_fail:
+	free_pages((unsigned long)wr_buf, order);
+	free_pages((unsigned long)rd_buf, order);
+
+	return ret;
+}
+
 int solo_p2m_init(struct solo_dev *solo_dev)
 {
 	struct solo_p2m_dev *p2m_dev;
@@ -294,13 +274,57 @@ int solo_p2m_init(struct solo_dev *solo_dev)
 		solo_reg_write(solo_dev, SOLO_P2M_CONTROL(i), 0);
 		solo_reg_write(solo_dev, SOLO_P2M_CONFIG(i),
 			       SOLO_P2M_CSC_16BIT_565 |
-			       SOLO_P2M_DMA_INTERVAL(3) |
 			       SOLO_P2M_DESC_INTR_OPT |
+			       SOLO_P2M_DMA_INTERVAL(0) |
 			       SOLO_P2M_PCI_MASTER_MODE);
 		solo_irq_on(solo_dev, SOLO_IRQ_P2M(i));
 	}
 
-	run_p2m_test(solo_dev);
+	/* Find correct SDRAM size */
+	for (solo_dev->sdram_size = 0, i = 2; i >= 0; i--) {
+		solo_reg_write(solo_dev, SOLO_DMA_CTRL,
+			       SOLO_DMA_CTRL_REFRESH_CYCLE(1) |
+			       SOLO_DMA_CTRL_SDRAM_SIZE(i) |
+			       SOLO_DMA_CTRL_SDRAM_CLK_INVERT |
+			       SOLO_DMA_CTRL_READ_CLK_SELECT |
+			       SOLO_DMA_CTRL_LATENCY(1));
+
+		solo_reg_write(solo_dev, SOLO_SYS_CFG, solo_dev->sys_config |
+			       SOLO_SYS_CFG_RESET);
+		solo_reg_write(solo_dev, SOLO_SYS_CFG, solo_dev->sys_config);
+
+		switch (i) {
+		case 2:
+			if (solo_p2m_test(solo_dev, 0x07ff0000, 0x00010000) ||
+			    solo_p2m_test(solo_dev, 0x05ff0000, 0x00010000))
+				continue;
+			break;
+
+		case 1:
+			if (solo_p2m_test(solo_dev, 0x03ff0000, 0x00010000))
+				continue;
+			break;
+
+		default:
+			if (solo_p2m_test(solo_dev, 0x01ff0000, 0x00010000))
+				continue;
+		}
+
+		solo_dev->sdram_size = (32 << 20) << i;
+		break;
+	}
+
+	if (!solo_dev->sdram_size) {
+		dev_err(&solo_dev->pdev->dev, "Error detecting SDRAM size\n");
+		return -EIO;
+	}
+
+	if (SOLO_SDRAM_END(solo_dev) > solo_dev->sdram_size) {
+		dev_err(&solo_dev->pdev->dev,
+			"SDRAM is not large enough (%u < %u)\n",
+			solo_dev->sdram_size, SOLO_SDRAM_END(solo_dev));
+		return -EIO;
+	}
 
 	return 0;
 }
diff --git a/drivers/staging/media/solo6x10/registers.h b/drivers/staging/media/solo6x10/registers.h
index aca5444..5e5c7e6 100644
--- a/drivers/staging/media/solo6x10/registers.h
+++ b/drivers/staging/media/solo6x10/registers.h
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -22,18 +27,18 @@
 
 #include "offsets.h"
 
-/* Global 6X10 system configuration */
+/* Global 6010 system configuration */
 #define SOLO_SYS_CFG				0x0000
-#define   SOLO6010_SYS_CFG_FOUT_EN		0x00000001 /* 6010 only */
-#define   SOLO6010_SYS_CFG_PLL_BYPASS		0x00000002 /* 6010 only */
-#define   SOLO6010_SYS_CFG_PLL_PWDN		0x00000004 /* 6010 only */
-#define   SOLO6010_SYS_CFG_OUTDIV(__n)		(((__n) & 0x003) << 3) /* 6010 only */
-#define   SOLO6010_SYS_CFG_FEEDBACKDIV(__n)	(((__n) & 0x1ff) << 5) /* 6010 only */
-#define   SOLO6010_SYS_CFG_INPUTDIV(__n)	(((__n) & 0x01f) << 14) /* 6010 only */
+#define   SOLO_SYS_CFG_FOUT_EN			0x00000001
+#define   SOLO_SYS_CFG_PLL_BYPASS		0x00000002
+#define   SOLO_SYS_CFG_PLL_PWDN			0x00000004
+#define   SOLO_SYS_CFG_OUTDIV(__n)		(((__n) & 0x003) << 3)
+#define   SOLO_SYS_CFG_FEEDBACKDIV(__n)		(((__n) & 0x1ff) << 5)
+#define   SOLO_SYS_CFG_INPUTDIV(__n)		(((__n) & 0x01f) << 14)
 #define   SOLO_SYS_CFG_CLOCK_DIV		0x00080000
 #define   SOLO_SYS_CFG_NCLK_DELAY(__n)		(((__n) & 0x003) << 24)
 #define   SOLO_SYS_CFG_PCLK_DELAY(__n)		(((__n) & 0x00f) << 26)
-#define   SOLO_SYS_CFG_SDRAM64BIT		0x40000000 /* 6110: must be set */
+#define   SOLO_SYS_CFG_SDRAM64BIT		0x40000000
 #define   SOLO_SYS_CFG_RESET			0x80000000
 
 #define	SOLO_DMA_CTRL				0x0004
@@ -45,7 +50,9 @@
 #define	  SOLO_DMA_CTRL_READ_DATA_SELECT	(1<<3)
 #define	  SOLO_DMA_CTRL_READ_CLK_SELECT		(1<<2)
 #define	  SOLO_DMA_CTRL_LATENCY(n)		((n)<<0)
-#define	SOLO_DMA_CTRL1				0x0008
+
+/* Some things we set in this are undocumented. Why Softlogic?!?! */
+#define SOLO_DMA_CTRL1				0x0008
 
 #define SOLO_SYS_VCLK				0x000C
 #define	  SOLO_VCLK_INVERT			(1<<22)
@@ -61,7 +68,7 @@
 #define	  SOLO_VCLK_VIN0001_DELAY(n)		((n)<<0)
 
 #define SOLO_IRQ_STAT				0x0010
-#define SOLO_IRQ_ENABLE				0x0014
+#define SOLO_IRQ_MASK				0x0014
 #define	  SOLO_IRQ_P2M(n)			(1<<((n)+17))
 #define	  SOLO_IRQ_GPIO				(1<<16)
 #define	  SOLO_IRQ_VIDEO_LOSS			(1<<15)
@@ -82,22 +89,7 @@
 #define SOLO_CHIP_OPTION			0x001C
 #define   SOLO_CHIP_ID_MASK			0x00000007
 
-#define SOLO6110_PLL_CONFIG			0x0020
-#define   SOLO6110_PLL_RANGE_BYPASS		(0 << 20)
-#define   SOLO6110_PLL_RANGE_5_10MHZ		(1 << 20)
-#define   SOLO6110_PLL_RANGE_8_16MHZ		(2 << 20)
-#define   SOLO6110_PLL_RANGE_13_26MHZ		(3 << 20)
-#define   SOLO6110_PLL_RANGE_21_42MHZ		(4 << 20)
-#define   SOLO6110_PLL_RANGE_34_68MHZ		(5 << 20)
-#define   SOLO6110_PLL_RANGE_54_108MHZ		(6 << 20)
-#define   SOLO6110_PLL_RANGE_88_200MHZ		(7 << 20)
-#define   SOLO6110_PLL_DIVR(x)			(((x) - 1) << 15)
-#define   SOLO6110_PLL_DIVQ_EXP(x)		((x) << 12)
-#define   SOLO6110_PLL_DIVF(x)			(((x) - 1) << 4)
-#define   SOLO6110_PLL_RESET			(1 << 3)
-#define   SOLO6110_PLL_BYPASS			(1 << 2)
-#define   SOLO6110_PLL_FSEN			(1 << 1)
-#define   SOLO6110_PLL_FB			(1 << 0)
+#define SOLO_PLL_CONFIG				0x0020 /* 6110 Only */
 
 #define SOLO_EEPROM_CTRL			0x0060
 #define	  SOLO_EEPROM_ACCESS_EN			(1<<7)
@@ -105,7 +97,7 @@
 #define	  SOLO_EEPROM_CLK			(1<<2)
 #define	  SOLO_EEPROM_DO			(1<<1)
 #define	  SOLO_EEPROM_DI			(1<<0)
-#define	  SOLO_EEPROM_ENABLE			(EEPROM_ACCESS_EN | EEPROM_CS)
+#define	  SOLO_EEPROM_ENABLE (SOLO_EEPROM_ACCESS_EN | SOLO_EEPROM_CS)
 
 #define SOLO_PCI_ERR				0x0070
 #define   SOLO_PCI_ERR_FATAL			0x00000001
@@ -274,8 +266,8 @@
 #define	  SOLO_VO_FI_CHANGE			(1<<20)
 #define	  SOLO_VO_USER_COLOR_SET_VSYNC		(1<<19)
 #define	  SOLO_VO_USER_COLOR_SET_HSYNC		(1<<18)
-#define	  SOLO_VO_USER_COLOR_SET_NAV		(1<<17)
-#define	  SOLO_VO_USER_COLOR_SET_NAH		(1<<16)
+#define	  SOLO_VO_USER_COLOR_SET_NAH		(1<<17)
+#define	  SOLO_VO_USER_COLOR_SET_NAV		(1<<16)
 #define	  SOLO_VO_NA_COLOR_Y(Y)			((Y)<<8)
 #define	  SOLO_VO_NA_COLOR_CB(CB)		(((CB)/16)<<4)
 #define	  SOLO_VO_NA_COLOR_CR(CR)		(((CR)/16)<<0)
@@ -401,12 +393,13 @@
 #define	  SOLO_VE_BLOCK_BASE(n)			((n)<<0)
 
 #define SOLO_VE_CFG1				0x0614
-#define   SOLO6110_VE_MPEG_SIZE_H(n)		((n)<<28) /* 6110 only */
-#define	  SOLO6010_VE_BYTE_ALIGN(n)		((n)<<24) /* 6010 only */
-#define   SOLO6110_VE_JPEG_SIZE_H(n)		((n)<<20) /* 6110 only */
+#define	  SOLO_VE_BYTE_ALIGN(n)			((n)<<24)
 #define	  SOLO_VE_INSERT_INDEX			(1<<18)
 #define	  SOLO_VE_MOTION_MODE(n)		((n)<<16)
 #define	  SOLO_VE_MOTION_BASE(n)		((n)<<0)
+#define   SOLO_VE_MPEG_SIZE_H(n)		((n)<<28) /* 6110 Only */
+#define   SOLO_VE_JPEG_SIZE_H(n)		((n)<<20) /* 6110 Only */
+#define   SOLO_VE_INSERT_INDEX_JPEG		(1<<19)   /* 6110 Only */
 
 #define SOLO_VE_WMRK_POLY			0x061C
 #define SOLO_VE_VMRK_INIT_KEY			0x0620
@@ -420,6 +413,7 @@
 #define	  SOLO_COMP_TIME_INC(n)			((n)<<25)
 #define	  SOLO_COMP_TIME_WIDTH(n)		((n)<<21)
 #define	  SOLO_DCT_INTERVAL(n)			((n)<<16)
+#define SOLO_VE_COMPT_MOT			0x0634 /* 6110 Only */
 
 #define SOLO_VE_STATE(n)			(0x0640+((n)*4))
 
@@ -428,14 +422,21 @@
 #define SOLO_VE_JPEG_QP_CH_H			0x0678
 #define SOLO_VE_JPEG_CFG			0x067C
 #define SOLO_VE_JPEG_CTRL			0x0680
-
+#define SOLO_VE_CODE_ENCRYPT			0x0684 /* 6110 Only */
+#define SOLO_VE_JPEG_CFG1			0x0688 /* 6110 Only */
+#define SOLO_VE_WMRK_ENABLE			0x068C /* 6110 Only */
 #define SOLO_VE_OSD_CH				0x0690
 #define SOLO_VE_OSD_BASE			0x0694
 #define SOLO_VE_OSD_CLR				0x0698
 #define SOLO_VE_OSD_OPT				0x069C
+#define   SOLO_VE_OSD_V_DOUBLE			(1<<16) /* 6110 Only */
+#define   SOLO_VE_OSD_H_SHADOW			(1<<15)
+#define   SOLO_VE_OSD_V_SHADOW			(1<<14)
+#define   SOLO_VE_OSD_H_OFFSET(n)		((n & 0x7f)<<7)
+#define   SOLO_VE_OSD_V_OFFSET(n)		(n & 0x7f)
 
 #define SOLO_VE_CH_INTL(ch)			(0x0700+((ch)*4))
-#define SOLO6010_VE_CH_MOT(ch)			(0x0740+((ch)*4)) /* 6010 only */
+#define SOLO_VE_CH_MOT(ch)			(0x0740+((ch)*4))
 #define SOLO_VE_CH_QP(ch)			(0x0780+((ch)*4))
 #define SOLO_VE_CH_QP_E(ch)			(0x07C0+((ch)*4))
 #define SOLO_VE_CH_GOP(ch)			(0x0800+((ch)*4))
@@ -447,7 +448,7 @@
 #define SOLO_VE_JPEG_QUE(n)			(0x0A04+((n)*8))
 
 #define SOLO_VD_CFG0				0x0900
-#define	  SOLO6010_VD_CFG_NO_WRITE_NO_WINDOW	(1<<24) /* 6010 only */
+#define	  SOLO_VD_CFG_NO_WRITE_NO_WINDOW	(1<<24)
 #define	  SOLO_VD_CFG_BUSY_WIAT_CODE		(1<<23)
 #define	  SOLO_VD_CFG_BUSY_WIAT_REF		(1<<22)
 #define	  SOLO_VD_CFG_BUSY_WIAT_RES		(1<<21)
@@ -599,9 +600,9 @@
 #define	  SOLO_UART_RX_DATA_POP			(1<<8)
 
 #define SOLO_TIMER_CLOCK_NUM			0x0be0
-#define SOLO_TIMER_WATCHDOG			0x0be4
 #define SOLO_TIMER_USEC				0x0be8
 #define SOLO_TIMER_SEC				0x0bec
+#define SOLO_TIMER_USEC_LSB			0x0d20 /* 6110 Only */
 
 #define SOLO_AUDIO_CONTROL			0x0D00
 #define	  SOLO_AUDIO_ENABLE			(1<<31)
@@ -629,9 +630,10 @@
 #define	  SOLO_AUDIO_EVOL(ch, value)		((value)<<((ch)%10))
 #define SOLO_AUDIO_STA				0x0D14
 
-
-#define SOLO_WATCHDOG				0x0BE4
-#define WATCHDOG_STAT(status)			(status<<8)
-#define WATCHDOG_TIME(sec)			(sec&0xff)
+/*
+ * Watchdog configuration
+ */
+#define SOLO_WATCHDOG				0x0be4
+#define SOLO_WATCHDOG_SET(status, sec)		(status << 8 | (sec & 0xff))
 
 #endif /* __SOLO6X10_REGISTERS_H */
diff --git a/drivers/staging/media/solo6x10/solo6x10-jpeg.h b/drivers/staging/media/solo6x10/solo6x10-jpeg.h
index 50defec..c5218ce 100644
--- a/drivers/staging/media/solo6x10/solo6x10-jpeg.h
+++ b/drivers/staging/media/solo6x10/solo6x10-jpeg.h
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -20,7 +25,7 @@
 #ifndef __SOLO6X10_JPEG_H
 #define __SOLO6X10_JPEG_H
 
-static unsigned char jpeg_header[] = {
+static const unsigned char jpeg_header[] = {
 	0xff, 0xd8, 0xff, 0xfe, 0x00, 0x0d, 0x42, 0x6c,
 	0x75, 0x65, 0x63, 0x68, 0x65, 0x72, 0x72, 0x79,
 	0x20, 0xff, 0xdb, 0x00, 0x43, 0x00, 0x20, 0x16,
@@ -102,4 +107,87 @@ static unsigned char jpeg_header[] = {
 /* This is the byte marker for the start of SOF0: 0xffc0 marker */
 #define SOF0_START	575
 
+/* This is the byte marker for the start of the DQT */
+#define DQT_START	17
+#define DQT_LEN		138
+const unsigned char jpeg_dqt[4][DQT_LEN] = {
+	{
+		0xff, 0xdb, 0x00, 0x43, 0x00,
+		0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07,
+		0x07, 0x07, 0x09, 0x09, 0x08, 0x0a, 0x0c, 0x14,
+		0x0d, 0x0c, 0x0b, 0x0b, 0x0c, 0x19, 0x12, 0x13,
+		0x0f, 0x14, 0x1d, 0x1a, 0x1f, 0x1e, 0x1d, 0x1a,
+		0x1c, 0x1c, 0x20, 0x24, 0x2e, 0x27, 0x20, 0x22,
+		0x2c, 0x23, 0x1c, 0x1c, 0x28, 0x37, 0x29, 0x2c,
+		0x30, 0x31, 0x34, 0x34, 0x34, 0x1f, 0x27, 0x39,
+		0x3d, 0x38, 0x32, 0x3c, 0x2e, 0x33, 0x34, 0x32,
+		0xff, 0xdb, 0x00, 0x43, 0x01,
+		0x09, 0x09, 0x09, 0x0c, 0x0b, 0x0c, 0x18, 0x0d,
+		0x0d, 0x18, 0x32, 0x21, 0x1c, 0x21, 0x32, 0x32,
+		0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+		0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+		0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+		0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+		0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+		0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32
+	}, {
+		0xff, 0xdb, 0x00, 0x43, 0x00,
+		0x10, 0x0b, 0x0c, 0x0e, 0x0c, 0x0a, 0x10, 0x0e,
+		0x0d, 0x0e, 0x12, 0x11, 0x10, 0x13, 0x18, 0x28,
+		0x1a, 0x18, 0x16, 0x16, 0x18, 0x31, 0x23, 0x25,
+		0x1d, 0x28, 0x3a, 0x33, 0x3d, 0x3c, 0x39, 0x33,
+		0x38, 0x37, 0x40, 0x48, 0x5c, 0x4e, 0x40, 0x44,
+		0x57, 0x45, 0x37, 0x38, 0x50, 0x6d, 0x51, 0x57,
+		0x5f, 0x62, 0x67, 0x68, 0x67, 0x3e, 0x4d, 0x71,
+		0x79, 0x70, 0x64, 0x78, 0x5c, 0x65, 0x67, 0x63,
+		0xff, 0xdb, 0x00, 0x43, 0x01,
+		0x11, 0x12, 0x12, 0x18, 0x15, 0x18, 0x2f, 0x1a,
+		0x1a, 0x2f, 0x63, 0x42, 0x38, 0x42, 0x63, 0x63,
+		0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+		0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+		0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+		0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+		0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+		0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63
+	}, {
+		0xff, 0xdb, 0x00, 0x43, 0x00,
+		0x20, 0x16, 0x18, 0x1c, 0x18, 0x14, 0x20, 0x1c,
+		0x1a, 0x1c, 0x24, 0x22, 0x20, 0x26, 0x30, 0x50,
+		0x34, 0x30, 0x2c, 0x2c, 0x30, 0x62, 0x46, 0x4a,
+		0x3a, 0x50, 0x74, 0x66, 0x7a, 0x78, 0x72, 0x66,
+		0x70, 0x6e, 0x80, 0x90, 0xb8, 0x9c, 0x80, 0x88,
+		0xae, 0x8a, 0x6e, 0x70, 0xa0, 0xda, 0xa2, 0xae,
+		0xbe, 0xc4, 0xce, 0xd0, 0xce, 0x7c, 0x9a, 0xe2,
+		0xf2, 0xe0, 0xc8, 0xf0, 0xb8, 0xca, 0xce, 0xc6,
+		0xff, 0xdb, 0x00, 0x43, 0x01,
+		0x22, 0x24, 0x24, 0x30, 0x2a, 0x30, 0x5e, 0x34,
+		0x34, 0x5e, 0xc6, 0x84, 0x70, 0x84, 0xc6, 0xc6,
+		0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6,
+		0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6,
+		0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6,
+		0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6,
+		0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6,
+		0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6, 0xc6
+	}, {
+		0xff, 0xdb, 0x00, 0x43, 0x00,
+		0x30, 0x21, 0x24, 0x2a, 0x24, 0x1e, 0x30, 0x2a,
+		0x27, 0x2a, 0x36, 0x33, 0x30, 0x39, 0x48, 0x78,
+		0x4e, 0x48, 0x42, 0x42, 0x48, 0x93, 0x69, 0x6f,
+		0x57, 0x78, 0xae, 0x99, 0xb7, 0xb4, 0xab, 0x99,
+		0xa8, 0xa5, 0xc0, 0xd8, 0xff, 0xea, 0xc0, 0xcc,
+		0xff, 0xcf, 0xa5, 0xa8, 0xf0, 0xff, 0xf3, 0xff,
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xba, 0xe7, 0xff,
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		0xff, 0xdb, 0x00, 0x43, 0x01,
+		0x33, 0x36, 0x36, 0x48, 0x3f, 0x48, 0x8d, 0x4e,
+		0x4e, 0x8d, 0xff, 0xc6, 0xa8, 0xc6, 0xff, 0xff,
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+		0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+	}
+};
+
 #endif /* __SOLO6X10_JPEG_H */
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index abee721..44ae160 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -23,17 +28,17 @@
 #include <linux/version.h>
 #include <linux/pci.h>
 #include <linux/i2c.h>
-#include <linux/semaphore.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/wait.h>
-#include <linux/delay.h>
-#include <linux/slab.h>
-#include <asm/io.h>
+#include <linux/stringify.h>
+#include <linux/io.h>
 #include <linux/atomic.h>
+
 #include <linux/videodev2.h>
 #include <media/v4l2-dev.h>
 #include <media/videobuf-core.h>
+
 #include "registers.h"
 
 #ifndef PCI_VENDOR_ID_SOFTLOGIC
@@ -58,19 +63,24 @@
 #define PCI_DEVICE_ID_BC_6110_16	0x5310
 #endif /* Bluecherry */
 
+/* Used in pci_device_id, and solo_dev->type */
+#define SOLO_DEV_6010			0
+#define SOLO_DEV_6110			1
+
 #define SOLO6X10_NAME			"solo6x10"
 
 #define SOLO_MAX_CHANNELS		16
 
 /* Make sure these two match */
-#define SOLO6X10_VERSION		"2.1.0"
 #define SOLO6X10_VER_MAJOR		2
-#define SOLO6X10_VER_MINOR		0
-#define SOLO6X10_VER_SUB		0
+#define SOLO6X10_VER_MINOR		4
+#define SOLO6X10_VER_SUB		4
 #define SOLO6X10_VER_NUM \
 	KERNEL_VERSION(SOLO6X10_VER_MAJOR, SOLO6X10_VER_MINOR, SOLO6X10_VER_SUB)
-
-#define FLAGS_6110			1
+#define SOLO6X10_VERSION \
+	__stringify(SOLO6X10_VER_MAJOR) "." \
+	__stringify(SOLO6X10_VER_MINOR) "." \
+	__stringify(SOLO6X10_VER_SUB)
 
 /*
  * The SOLO6x10 actually has 8 i2c channels, but we only use 2.
@@ -84,16 +94,7 @@
 /* DMA Engine setup */
 #define SOLO_NR_P2M			4
 #define SOLO_NR_P2M_DESC		256
-/* MPEG and JPEG share the same interrupt and locks so they must be together
- * in the same dma channel. */
-#define SOLO_P2M_DMA_ID_MP4E		0
-#define SOLO_P2M_DMA_ID_JPEG		0
-#define SOLO_P2M_DMA_ID_MP4D		1
-#define SOLO_P2M_DMA_ID_G723D		1
-#define SOLO_P2M_DMA_ID_DISP		2
-#define SOLO_P2M_DMA_ID_OSG		2
-#define SOLO_P2M_DMA_ID_G723E		3
-#define SOLO_P2M_DMA_ID_VIN		3
+#define SOLO_P2M_DESC_SIZE		(SOLO_NR_P2M_DESC * 16)
 
 /* Encoder standard modes */
 #define SOLO_ENC_MODE_CIF		2
@@ -103,12 +104,6 @@
 #define SOLO_DEFAULT_GOP		30
 #define SOLO_DEFAULT_QP			3
 
-/* There is 8MB memory available for solo to buffer MPEG4 frames.
- * This gives us 512 * 16kbyte queues. */
-#define SOLO_NR_RING_BUFS		512
-
-#define SOLO_CLOCK_MHZ			108
-
 #ifndef V4L2_BUF_FLAG_MOTION_ON
 #define V4L2_BUF_FLAG_MOTION_ON		0x0400
 #define V4L2_BUF_FLAG_MOTION_DETECTED	0x0800
@@ -128,64 +123,67 @@ enum SOLO_I2C_STATE {
 	IIC_STATE_STOP
 };
 
-struct p2m_desc {
-	u32 ctrl;
-	u32 ext;
-	u32 ta;
-	u32 fa;
+/* Defined in Table 4-16, Page 68-69 of the 6010 Datasheet */
+struct solo_p2m_desc {
+	u32	ctrl;
+	u32	cfg;
+	u32	dma_addr;
+	u32	ext_addr;
 };
 
 struct solo_p2m_dev {
 	struct mutex		mutex;
 	struct completion	completion;
+	int			desc_count;
+	int			desc_idx;
+	struct solo_p2m_desc	*descs;
 	int			error;
 };
 
-#define OSD_TEXT_MAX		30
-
-enum solo_enc_types {
-	SOLO_ENC_TYPE_STD,
-	SOLO_ENC_TYPE_EXT,
-};
+#define OSD_TEXT_MAX		44
 
 struct solo_enc_dev {
-	struct solo_dev		*solo_dev;
+	struct solo_dev	*solo_dev;
 	/* V4L2 Items */
 	struct video_device	*vfd;
 	/* General accounting */
-	wait_queue_head_t	thread_wait;
-	spinlock_t		lock;
+	struct mutex		enable_lock;
+	spinlock_t		motion_lock;
 	atomic_t		readers;
+	atomic_t		mpeg_readers;
 	u8			ch;
 	u8			mode, gop, qp, interlaced, interval;
-	u8			reset_gop;
 	u8			bw_weight;
-	u8			motion_detected;
 	u16			motion_thresh;
 	u16			width;
 	u16			height;
+
+	/* OSD buffers */
 	char			osd_text[OSD_TEXT_MAX + 1];
-};
+	u8			osd_buf[SOLO_EOSD_EXT_SIZE_MAX]
+					__aligned(4);
 
-struct solo_enc_buf {
-	u8			vop;
-	u8			ch;
-	enum solo_enc_types	type;
-	u32			off;
-	u32			size;
-	u32			jpeg_off;
-	u32			jpeg_size;
-	struct timeval		ts;
+	/* VOP stuff */
+	unsigned char		vop[64];
+	int			vop_len;
+	unsigned char		jpeg_header[1024];
+	int			jpeg_len;
+
+	/* File handles that are listening for buffers */
+	struct list_head	listeners;
 };
 
 /* The SOLO6x10 PCI Device */
 struct solo_dev {
 	/* General stuff */
 	struct pci_dev		*pdev;
+	int			type;
+	unsigned int		time_sync;
+	unsigned int		usec_lsb;
+	unsigned int		clock_mhz;
 	u8 __iomem		*reg_base;
 	int			nr_chans;
 	int			nr_ext;
-	u32			flags;
 	u32			irq_mask;
 	u32			motion_mask;
 	spinlock_t		reg_io_lock;
@@ -206,6 +204,9 @@ struct solo_dev {
 
 	/* P2M DMA Engine */
 	struct solo_p2m_dev	p2m_dev[SOLO_NR_P2M];
+	atomic_t		p2m_count;
+	int			p2m_jiffies;
+	unsigned int		p2m_timeouts;
 
 	/* V4L2 Display items */
 	struct video_device	*vfd;
@@ -219,9 +220,6 @@ struct solo_dev {
 	u16			enc_bw_remain;
 	/* IDX into hw mp4 encoder */
 	u8			enc_idx;
-	/* Our software ring of enc buf references */
-	u16			enc_wr_idx;
-	struct solo_enc_buf	enc_buf[SOLO_NR_RING_BUFS];
 
 	/* Current video settings */
 	u32			video_type;
@@ -230,11 +228,32 @@ struct solo_dev {
 	u16			vin_hstart, vin_vstart;
 	u8			fps;
 
+	/* JPEG Qp setting */
+	spinlock_t      jpeg_qp_lock;
+	u32		jpeg_qp[2];
+
 	/* Audio components */
 	struct snd_card		*snd_card;
 	struct snd_pcm		*snd_pcm;
 	atomic_t		snd_users;
 	int			g723_hw_idx;
+
+	/* sysfs stuffs */
+	struct device		dev;
+	int			sdram_size;
+	struct bin_attribute	sdram_attr;
+	unsigned int		sys_config;
+
+	/* Ring thread */
+	struct task_struct	*ring_thread;
+	wait_queue_head_t	ring_thread_wait;
+	atomic_t		enc_users;
+	atomic_t		disp_users;
+
+	/* VOP_HEADER handling */
+	void                    *vh_buf;
+	dma_addr_t		vh_dma;
+	int			vh_size;
 };
 
 static inline u32 solo_reg_read(struct solo_dev *solo_dev, int reg)
@@ -255,7 +274,8 @@ static inline u32 solo_reg_read(struct solo_dev *solo_dev, int reg)
 	return ret;
 }
 
-static inline void solo_reg_write(struct solo_dev *solo_dev, int reg, u32 data)
+static inline void solo_reg_write(struct solo_dev *solo_dev, int reg,
+				  u32 data)
 {
 	unsigned long flags;
 	u16 val;
@@ -270,8 +290,17 @@ static inline void solo_reg_write(struct solo_dev *solo_dev, int reg, u32 data)
 	spin_unlock_irqrestore(&solo_dev->reg_io_lock, flags);
 }
 
-void solo_irq_on(struct solo_dev *solo_dev, u32 mask);
-void solo_irq_off(struct solo_dev *solo_dev, u32 mask);
+static inline void solo_irq_on(struct solo_dev *dev, u32 mask)
+{
+	dev->irq_mask |= mask;
+	solo_reg_write(dev, SOLO_IRQ_MASK, dev->irq_mask);
+}
+
+static inline void solo_irq_off(struct solo_dev *dev, u32 mask)
+{
+	dev->irq_mask &= ~mask;
+	solo_reg_write(dev, SOLO_IRQ_MASK, dev->irq_mask);
+}
 
 /* Init/exit routeines for subsystems */
 int solo_disp_init(struct solo_dev *solo_dev);
@@ -286,13 +315,13 @@ void solo_i2c_exit(struct solo_dev *solo_dev);
 int solo_p2m_init(struct solo_dev *solo_dev);
 void solo_p2m_exit(struct solo_dev *solo_dev);
 
-int solo_v4l2_init(struct solo_dev *solo_dev);
+int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr);
 void solo_v4l2_exit(struct solo_dev *solo_dev);
 
 int solo_enc_init(struct solo_dev *solo_dev);
 void solo_enc_exit(struct solo_dev *solo_dev);
 
-int solo_enc_v4l2_init(struct solo_dev *solo_dev);
+int solo_enc_v4l2_init(struct solo_dev *solo_dev, unsigned nr);
 void solo_enc_v4l2_exit(struct solo_dev *solo_dev);
 
 int solo_g723_init(struct solo_dev *solo_dev);
@@ -301,7 +330,7 @@ void solo_g723_exit(struct solo_dev *solo_dev);
 /* ISR's */
 int solo_i2c_isr(struct solo_dev *solo_dev);
 void solo_p2m_isr(struct solo_dev *solo_dev, int id);
-void solo_p2m_error_isr(struct solo_dev *solo_dev, u32 status);
+void solo_p2m_error_isr(struct solo_dev *solo_dev);
 void solo_enc_v4l2_isr(struct solo_dev *solo_dev);
 void solo_g723_isr(struct solo_dev *solo_dev);
 void solo_motion_isr(struct solo_dev *solo_dev);
@@ -313,24 +342,39 @@ void solo_i2c_writebyte(struct solo_dev *solo_dev, int id, u8 addr, u8 off,
 			u8 data);
 
 /* P2M DMA */
-int solo_p2m_dma_t(struct solo_dev *solo_dev, u8 id, int wr,
-		   dma_addr_t dma_addr, u32 ext_addr, u32 size);
-int solo_p2m_dma(struct solo_dev *solo_dev, u8 id, int wr,
-		 void *sys_addr, u32 ext_addr, u32 size);
-int solo_p2m_dma_sg(struct solo_dev *solo_dev, u8 id,
-		    struct p2m_desc *pdesc, int wr,
-		    struct scatterlist *sglist, u32 sg_off,
-		    u32 ext_addr, u32 size);
-void solo_p2m_push_desc(struct p2m_desc *desc, int wr, dma_addr_t dma_addr,
-			u32 ext_addr, u32 size, int repeat, u32 ext_size);
-int solo_p2m_dma_desc(struct solo_dev *solo_dev, u8 id,
-		      struct p2m_desc *desc, int desc_count);
+int solo_p2m_dma_t(struct solo_dev *solo_dev, int wr,
+		   dma_addr_t dma_addr, u32 ext_addr, u32 size,
+		   int repeat, u32 ext_size);
+int solo_p2m_dma(struct solo_dev *solo_dev, int wr,
+		 void *sys_addr, u32 ext_addr, u32 size,
+		 int repeat, u32 ext_size);
+void solo_p2m_fill_desc(struct solo_p2m_desc *desc, int wr,
+			dma_addr_t dma_addr, u32 ext_addr, u32 size,
+			int repeat, u32 ext_size);
+int solo_p2m_dma_desc(struct solo_dev *solo_dev,
+		      struct solo_p2m_desc *desc, dma_addr_t desc_dma,
+		      int desc_cnt);
 
 /* Set the threshold for motion detection */
-void solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val);
+int solo_set_motion_threshold(struct solo_dev *solo_dev, u8 ch, u16 val);
+int solo_set_motion_block(struct solo_dev *solo_dev, u8 ch, u16 val,
+			   u16 block);
 #define SOLO_DEF_MOT_THRESH		0x0300
 
 /* Write text on OSD */
 int solo_osd_print(struct solo_enc_dev *solo_enc);
 
+/* EEPROM commands */
+unsigned int solo_eeprom_ewen(struct solo_dev *solo_dev, int w_en);
+unsigned short solo_eeprom_read(struct solo_dev *solo_dev, int loc);
+int solo_eeprom_write(struct solo_dev *solo_dev, int loc,
+		      unsigned short data);
+
+/* JPEG Qp functions */
+void solo_s_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch,
+		    unsigned int qp);
+int solo_g_jpeg_qp(struct solo_dev *solo_dev, unsigned int ch);
+
+#define CHK_FLAGS(v, flags) (((v) & (flags)) == (flags))
+
 #endif /* __SOLO6X10_H */
diff --git a/drivers/staging/media/solo6x10/tw28.c b/drivers/staging/media/solo6x10/tw28.c
index db56b42..365ab10 100644
--- a/drivers/staging/media/solo6x10/tw28.c
+++ b/drivers/staging/media/solo6x10/tw28.c
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -18,12 +23,12 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/delay.h>
+
 #include "solo6x10.h"
 #include "tw28.h"
 
-/* XXX: Some of these values are masked into an 8-bit regs, and shifted
- * around for other 8-bit regs. What are the magic bits in these values? */
-#define DEFAULT_HDELAY_NTSC		(32 - 4)
+#define DEFAULT_HDELAY_NTSC		(32 - 8)
 #define DEFAULT_HACTIVE_NTSC		(720 + 16)
 #define DEFAULT_VDELAY_NTSC		(7 - 2)
 #define DEFAULT_VACTIVE_NTSC		(240 + 4)
@@ -33,15 +38,16 @@
 #define DEFAULT_VDELAY_PAL		(6)
 #define DEFAULT_VACTIVE_PAL		(312-DEFAULT_VDELAY_PAL)
 
-static u8 tbl_tw2864_template[] = {
-	0x00, 0x00, 0x80, 0x10, 0x80, 0x80, 0x00, 0x02, /* 0x00 */
-	0x12, 0xf5, 0x09, 0xd0, 0x00, 0x00, 0x00, 0x7f,
-	0x00, 0x00, 0x80, 0x10, 0x80, 0x80, 0x00, 0x02, /* 0x10 */
-	0x12, 0xf5, 0x09, 0xd0, 0x00, 0x00, 0x00, 0x7f,
-	0x00, 0x00, 0x80, 0x10, 0x80, 0x80, 0x00, 0x02, /* 0x20 */
-	0x12, 0xf5, 0x09, 0xd0, 0x00, 0x00, 0x00, 0x7f,
-	0x00, 0x00, 0x80, 0x10, 0x80, 0x80, 0x00, 0x02, /* 0x30 */
-	0x12, 0xf5, 0x09, 0xd0, 0x00, 0x00, 0x00, 0x7f,
+
+static const u8 tbl_tw2864_ntsc_template[] = {
+	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x02, /* 0x00 */
+	0x12, 0xf5, 0x0c, 0xd0, 0x00, 0x00, 0x00, 0x7f,
+	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x02, /* 0x10 */
+	0x12, 0xf5, 0x0c, 0xd0, 0x00, 0x00, 0x00, 0x7f,
+	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x02, /* 0x20 */
+	0x12, 0xf5, 0x0c, 0xd0, 0x00, 0x00, 0x00, 0x7f,
+	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x02, /* 0x30 */
+	0x12, 0xf5, 0x0c, 0xd0, 0x00, 0x00, 0x00, 0x7f,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x40 */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x50 */
@@ -61,14 +67,49 @@ static u8 tbl_tw2864_template[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xc0 */
 	0x00, 0x00, 0x55, 0x00, 0xb1, 0xe4, 0x40, 0x00,
 	0x77, 0x77, 0x01, 0x13, 0x57, 0x9b, 0xdf, 0x20, /* 0xd0 */
-	0x64, 0xa8, 0xec, 0xd1, 0x0f, 0x11, 0x11, 0x81,
-	0x10, 0xe0, 0xbb, 0xbb, 0x00, 0x11, 0x00, 0x00, /* 0xe0 */
+	0x64, 0xa8, 0xec, 0xc1, 0x0f, 0x11, 0x11, 0x81,
+	0x00, 0xe0, 0xbb, 0xbb, 0x00, 0x11, 0x00, 0x00, /* 0xe0 */
 	0x11, 0x00, 0x00, 0x11, 0x00, 0x00, 0x11, 0x00,
 	0x83, 0xb5, 0x09, 0x78, 0x85, 0x00, 0x01, 0x20, /* 0xf0 */
 	0x64, 0x11, 0x40, 0xaf, 0xff, 0x00, 0x00, 0x00,
 };
 
-static u8 tbl_tw2865_ntsc_template[] = {
+static const u8 tbl_tw2864_pal_template[] = {
+	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x12, /* 0x00 */
+	0x18, 0xf5, 0x0c, 0xd0, 0x00, 0x00, 0x01, 0x7f,
+	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x12, /* 0x10 */
+	0x18, 0xf5, 0x0c, 0xd0, 0x00, 0x00, 0x01, 0x7f,
+	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x12, /* 0x20 */
+	0x18, 0xf5, 0x0c, 0xd0, 0x00, 0x00, 0x01, 0x7f,
+	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x12, /* 0x30 */
+	0x18, 0xf5, 0x0c, 0xd0, 0x00, 0x00, 0x01, 0x7f,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x40 */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x50 */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x60 */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0x70 */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA3, 0x00,
+	0x00, 0x02, 0x00, 0xcc, 0x00, 0x80, 0x44, 0x50, /* 0x80 */
+	0x22, 0x01, 0xd8, 0xbc, 0xb8, 0x44, 0x38, 0x00,
+	0x00, 0x78, 0x72, 0x3e, 0x14, 0xa5, 0xe4, 0x05, /* 0x90 */
+	0x00, 0x28, 0x44, 0x44, 0xa0, 0x90, 0x5a, 0x01,
+	0x0a, 0x0a, 0x0a, 0x0a, 0x1a, 0x1a, 0x1a, 0x1a, /* 0xa0 */
+	0x00, 0x00, 0x00, 0xf0, 0xf0, 0xf0, 0xf0, 0x44,
+	0x44, 0x0a, 0x00, 0xff, 0xef, 0xef, 0xef, 0xef, /* 0xb0 */
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 0xc0 */
+	0x00, 0x00, 0x55, 0x00, 0xb1, 0xe4, 0x40, 0x00,
+	0x77, 0x77, 0x01, 0x13, 0x57, 0x9b, 0xdf, 0x20, /* 0xd0 */
+	0x64, 0xa8, 0xec, 0xc1, 0x0f, 0x11, 0x11, 0x81,
+	0x00, 0xe0, 0xbb, 0xbb, 0x00, 0x11, 0x00, 0x00, /* 0xe0 */
+	0x11, 0x00, 0x00, 0x11, 0x00, 0x00, 0x11, 0x00,
+	0x83, 0xb5, 0x09, 0x00, 0xa0, 0x00, 0x01, 0x20, /* 0xf0 */
+	0x64, 0x11, 0x40, 0xaf, 0xff, 0x00, 0x00, 0x00,
+};
+
+static const u8 tbl_tw2865_ntsc_template[] = {
 	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x02, /* 0x00 */
 	0x12, 0xff, 0x09, 0xd0, 0x00, 0x00, 0x00, 0x7f,
 	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x02, /* 0x10 */
@@ -103,7 +144,7 @@ static u8 tbl_tw2865_ntsc_template[] = {
 	0x64, 0x51, 0x40, 0xaf, 0xFF, 0xF0, 0x00, 0xC0,
 };
 
-static u8 tbl_tw2865_pal_template[] = {
+static const u8 tbl_tw2865_pal_template[] = {
 	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x12, /* 0x00 */
 	0x11, 0xff, 0x01, 0xc3, 0x00, 0x00, 0x01, 0x7f,
 	0x00, 0xf0, 0x70, 0x30, 0x80, 0x80, 0x00, 0x12, /* 0x10 */
@@ -180,8 +221,8 @@ static void tw_write_and_verify(struct solo_dev *solo_dev, u8 addr, u8 off,
 		msleep_interruptible(1);
 	}
 
-/*	printk("solo6x10/tw28: Error writing register: %02x->%02x [%02x]\n",
-		addr, off, val); */
+/*	printk("solo6x10/tw28: Error writing register: %02x->%02x [%02x]\n", */
+/*		addr, off, val); */
 }
 
 static int tw2865_setup(struct solo_dev *solo_dev, u8 dev_addr)
@@ -216,16 +257,17 @@ static int tw2865_setup(struct solo_dev *solo_dev, u8 dev_addr)
 
 	for (i = 0; i < 0xff; i++) {
 		/* Skip read only registers */
-		if (i >= 0xb8 && i <= 0xc1)
-			continue;
-		if ((i & ~0x30) == 0x00 ||
-		    (i & ~0x30) == 0x0c ||
-		    (i & ~0x30) == 0x0d)
-			continue;
-		if (i >= 0xc4 && i <= 0xc7)
+		switch (i) {
+		case 0xb8 ... 0xc1:
+		case 0xc4 ... 0xc7:
+		case 0xfd:
 			continue;
-		if (i == 0xfd)
+		}
+		switch (i & ~0x30) {
+		case 0x00:
+		case 0x0c ... 0x0d:
 			continue;
+		}
 
 		tw_write_and_verify(solo_dev, dev_addr, i,
 				    tbl_tw2865_common[i]);
@@ -236,11 +278,15 @@ static int tw2865_setup(struct solo_dev *solo_dev, u8 dev_addr)
 
 static int tw2864_setup(struct solo_dev *solo_dev, u8 dev_addr)
 {
-	u8 tbl_tw2864_common[sizeof(tbl_tw2864_template)];
+	u8 tbl_tw2864_common[256];
 	int i;
 
-	memcpy(tbl_tw2864_common, tbl_tw2864_template,
-	       sizeof(tbl_tw2864_common));
+	if (solo_dev->video_type == SOLO_VO_FMT_TYPE_PAL)
+		memcpy(tbl_tw2864_common, tbl_tw2864_pal_template,
+		       sizeof(tbl_tw2864_common));
+	else
+		memcpy(tbl_tw2864_common, tbl_tw2864_ntsc_template,
+		       sizeof(tbl_tw2864_common));
 
 	if (solo_dev->tw2865 == 0) {
 		/* IRQ Mode */
@@ -285,33 +331,19 @@ static int tw2864_setup(struct solo_dev *solo_dev, u8 dev_addr)
 		}
 	}
 
-	/* NTSC or PAL */
-	if (solo_dev->video_type == SOLO_VO_FMT_TYPE_PAL) {
-		for (i = 0; i < 4; i++) {
-			tbl_tw2864_common[0x07 | (i << 4)] |= 0x10;
-			tbl_tw2864_common[0x08 | (i << 4)] |= 0x06;
-			tbl_tw2864_common[0x0a | (i << 4)] |= 0x08;
-			tbl_tw2864_common[0x0b | (i << 4)] |= 0x13;
-			tbl_tw2864_common[0x0e | (i << 4)] |= 0x01;
-		}
-		tbl_tw2864_common[0x9d] = 0x90;
-		tbl_tw2864_common[0xf3] = 0x00;
-		tbl_tw2864_common[0xf4] = 0xa0;
-	}
-
 	for (i = 0; i < 0xff; i++) {
 		/* Skip read only registers */
-		if (i >= 0xb8 && i <= 0xc1)
-			continue;
-		if ((i & ~0x30) == 0x00 ||
-		    (i & ~0x30) == 0x0c ||
-		    (i & ~0x30) == 0x0d)
-			continue;
-		if (i == 0x74 || i == 0x77 || i == 0x78 ||
-		    i == 0x79 || i == 0x7a)
+		switch (i) {
+		case 0xb8 ... 0xc1:
+		case 0xfd:
 			continue;
-		if (i == 0xfd)
+		}
+		switch (i & ~0x30) {
+		case 0x00:
+		case 0x0c:
+		case 0x0d:
 			continue;
+		}
 
 		tw_write_and_verify(solo_dev, dev_addr, i,
 				    tbl_tw2864_common[i]);
@@ -544,8 +576,8 @@ int solo_tw28_init(struct solo_dev *solo_dev)
 	int i;
 	u8 value;
 
-	/* Detect techwell chip type */
-	for (i = 0; i < TW_NUM_CHIP; i++) {
+	/* Detect techwell chip type(s) */
+	for (i = 0; i < solo_dev->nr_chans / 4; i++) {
 		value = solo_i2c_readbyte(solo_dev, SOLO_I2C_TW,
 					  TW_CHIP_OFFSET_ADDR(i), 0xFF);
 
@@ -560,7 +592,8 @@ int solo_tw28_init(struct solo_dev *solo_dev)
 			break;
 		default:
 			value = solo_i2c_readbyte(solo_dev, SOLO_I2C_TW,
-						  TW_CHIP_OFFSET_ADDR(i), 0x59);
+						  TW_CHIP_OFFSET_ADDR(i),
+						  0x59);
 			if ((value >> 3) == 0x04) {
 				solo_dev->tw2815 |= 1 << i;
 				solo_dev->tw28_cnt++;
@@ -568,8 +601,11 @@ int solo_tw28_init(struct solo_dev *solo_dev)
 		}
 	}
 
-	if (!solo_dev->tw28_cnt)
+	if (solo_dev->tw28_cnt != (solo_dev->nr_chans >> 2)) {
+		dev_err(&solo_dev->pdev->dev,
+			"Could not initialize any techwell chips\n");
 		return -EINVAL;
+	}
 
 	saa7128_setup(solo_dev);
 
@@ -582,17 +618,6 @@ int solo_tw28_init(struct solo_dev *solo_dev)
 			tw2815_setup(solo_dev, TW_CHIP_OFFSET_ADDR(i));
 	}
 
-	dev_info(&solo_dev->pdev->dev, "Initialized %d tw28xx chip%s:",
-		 solo_dev->tw28_cnt, solo_dev->tw28_cnt == 1 ? "" : "s");
-
-	if (solo_dev->tw2865)
-		printk(" tw2865[%d]", hweight32(solo_dev->tw2865));
-	if (solo_dev->tw2864)
-		printk(" tw2864[%d]", hweight32(solo_dev->tw2864));
-	if (solo_dev->tw2815)
-		printk(" tw2815[%d]", hweight32(solo_dev->tw2815));
-	printk("\n");
-
 	return 0;
 }
 
@@ -610,7 +635,7 @@ int tw28_get_video_status(struct solo_dev *solo_dev, u8 ch)
 	chip_num = ch / 4;
 	ch %= 4;
 
-	val = tw_readbyte(solo_dev, chip_num, TW286X_AV_STAT_ADDR,
+	val = tw_readbyte(solo_dev, chip_num, TW286x_AV_STAT_ADDR,
 			  TW_AV_STAT_ADDR) & 0x0f;
 
 	return val & (1 << ch) ? 1 : 0;
@@ -626,7 +651,7 @@ u16 tw28_get_audio_status(struct solo_dev *solo_dev)
 	int i;
 
 	for (i = 0; i < solo_dev->tw28_cnt; i++) {
-		val = (tw_readbyte(solo_dev, i, TW286X_AV_STAT_ADDR,
+		val = (tw_readbyte(solo_dev, i, TW286x_AV_STAT_ADDR,
 				   TW_AV_STAT_ADDR) & 0xf0) >> 4;
 		status |= val << (i * 4);
 	}
@@ -635,7 +660,8 @@ u16 tw28_get_audio_status(struct solo_dev *solo_dev)
 }
 #endif
 
-int tw28_set_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch, s32 val)
+int tw28_set_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch,
+		      s32 val)
 {
 	char sval;
 	u8 chip_num;
@@ -676,6 +702,7 @@ int tw28_set_ctrl_val(struct solo_dev *solo_dev, u32 ctrl, u8 ch, s32 val)
 		break;
 
 	case V4L2_CID_SATURATION:
+		/* 286x chips have a U and V component for saturation */
 		if (is_tw286x(solo_dev, chip_num)) {
 			solo_i2c_writebyte(solo_dev, SOLO_I2C_TW,
 					   TW_CHIP_OFFSET_ADDR(chip_num),
diff --git a/drivers/staging/media/solo6x10/tw28.h b/drivers/staging/media/solo6x10/tw28.h
index a44a03a..a03b429 100644
--- a/drivers/staging/media/solo6x10/tw28.h
+++ b/drivers/staging/media/solo6x10/tw28.h
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -36,7 +41,7 @@
 #define TW_AUDIO_INPUT_GAIN_ADDR(n)		(0x60 + ((n > 1) ? 1 : 0))
 
 /* tw286x */
-#define TW286X_AV_STAT_ADDR			0xfd
+#define TW286x_AV_STAT_ADDR			0xfd
 #define TW286x_HUE_ADDR(n)			(0x06 | ((n) << 4))
 #define TW286x_SATURATIONU_ADDR(n)		(0x04 | ((n) << 4))
 #define TW286x_SATURATIONV_ADDR(n)		(0x05 | ((n) << 4))
diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 4977e86..b05b328 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,33 +26,100 @@
 #include <linux/module.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
 #include <media/videobuf-dma-sg.h>
+
 #include "solo6x10.h"
 #include "tw28.h"
 #include "solo6x10-jpeg.h"
 
-#define MIN_VID_BUFFERS		4
-#define FRAME_BUF_SIZE		(128 * 1024)
+#define MIN_VID_BUFFERS		2
+#define FRAME_BUF_SIZE		(196 * 1024)
 #define MP4_QS			16
+#define DMA_ALIGN		4096
 
-static int solo_enc_thread(void *data);
-
-extern unsigned video_nr;
+enum solo_enc_types {
+	SOLO_ENC_TYPE_STD,
+	SOLO_ENC_TYPE_EXT,
+};
 
 struct solo_enc_fh {
 	struct			solo_enc_dev *enc;
 	u32			fmt;
-	u16			rd_idx;
 	u8			enc_on;
 	enum solo_enc_types	type;
 	struct videobuf_queue	vidq;
 	struct list_head	vidq_active;
-	struct task_struct	*kthread;
-	struct p2m_desc		desc[SOLO_NR_P2M_DESC];
+	int			desc_count;
+	int			desc_nelts;
+	struct solo_p2m_desc	*desc_items;
+	dma_addr_t		desc_dma;
+	spinlock_t		av_lock;
+	struct list_head	list;
+};
+
+struct solo_videobuf {
+	struct videobuf_buffer	vb;
+	unsigned int		flags;
+};
+
+/* 6010 M4V */
+static unsigned char vop_6010_ntsc_d1[] = {
+	0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x20,
+	0x02, 0x48, 0x1d, 0xc0, 0x00, 0x40, 0x00, 0x40,
+	0x00, 0x40, 0x00, 0x80, 0x00, 0x97, 0x53, 0x04,
+	0x1f, 0x4c, 0x58, 0x10, 0xf0, 0x71, 0x18, 0x3f,
+};
+
+static unsigned char vop_6010_ntsc_cif[] = {
+	0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x20,
+	0x02, 0x48, 0x1d, 0xc0, 0x00, 0x40, 0x00, 0x40,
+	0x00, 0x40, 0x00, 0x80, 0x00, 0x97, 0x53, 0x04,
+	0x1f, 0x4c, 0x2c, 0x10, 0x78, 0x51, 0x18, 0x3f,
+};
+
+static unsigned char vop_6010_pal_d1[] = {
+	0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x20,
+	0x02, 0x48, 0x15, 0xc0, 0x00, 0x40, 0x00, 0x40,
+	0x00, 0x40, 0x00, 0x80, 0x00, 0x97, 0x53, 0x04,
+	0x1f, 0x4c, 0x58, 0x11, 0x20, 0x71, 0x18, 0x3f,
+};
+
+static unsigned char vop_6010_pal_cif[] = {
+	0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x20,
+	0x02, 0x48, 0x15, 0xc0, 0x00, 0x40, 0x00, 0x40,
+	0x00, 0x40, 0x00, 0x80, 0x00, 0x97, 0x53, 0x04,
+	0x1f, 0x4c, 0x2c, 0x10, 0x90, 0x51, 0x18, 0x3f,
+};
+
+/* 6110 h.264 */
+static unsigned char vop_6110_ntsc_d1[] = {
+	0x00, 0x00, 0x00, 0x01, 0x67, 0x42, 0x00, 0x1e,
+	0x9a, 0x74, 0x05, 0x81, 0xec, 0x80, 0x00, 0x00,
+	0x00, 0x01, 0x68, 0xce, 0x32, 0x28, 0x00, 0x00,
+};
+
+static unsigned char vop_6110_ntsc_cif[] = {
+	0x00, 0x00, 0x00, 0x01, 0x67, 0x42, 0x00, 0x1e,
+	0x9a, 0x74, 0x0b, 0x0f, 0xc8, 0x00, 0x00, 0x00,
+	0x01, 0x68, 0xce, 0x32, 0x28, 0x00, 0x00, 0x00,
+};
+
+static unsigned char vop_6110_pal_d1[] = {
+	0x00, 0x00, 0x00, 0x01, 0x67, 0x42, 0x00, 0x1e,
+	0x9a, 0x74, 0x05, 0x80, 0x93, 0x20, 0x00, 0x00,
+	0x00, 0x01, 0x68, 0xce, 0x32, 0x28, 0x00, 0x00,
+};
+
+static unsigned char vop_6110_pal_cif[] = {
+	0x00, 0x00, 0x00, 0x01, 0x67, 0x42, 0x00, 0x1e,
+	0x9a, 0x74, 0x0b, 0x04, 0xb2, 0x00, 0x00, 0x00,
+	0x01, 0x68, 0xce, 0x32, 0x28, 0x00, 0x00, 0x00,
 };
 
+
 static const u32 solo_user_ctrls[] = {
 	V4L2_CID_BRIGHTNESS,
 	V4L2_CID_CONTRAST,
@@ -82,79 +154,179 @@ static const u32 *solo_ctrl_classes[] = {
 	NULL
 };
 
+struct vop_header {
+	/* VE_STATUS0 */
+	u32 mpeg_size:20, sad_motion_flag:1, video_motion_flag:1, vop_type:2,
+		channel:5, source_fl:1, interlace:1, progressive:1;
+
+	/* VE_STATUS1 */
+	u32 vsize:8, hsize:8, last_queue:4, nop0:8, scale:4;
+
+	/* VE_STATUS2 */
+	u32 mpeg_off;
+
+	/* VE_STATUS3 */
+	u32 jpeg_off;
+
+	/* VE_STATUS4 */
+	u32 jpeg_size:20, interval:10, nop1:2;
+
+	/* VE_STATUS5/6 */
+	u32 sec, usec;
+
+	/* VE_STATUS7/8/9 */
+	u32 nop2[3];
+
+	/* VE_STATUS10 */
+	u32 mpeg_size_alt:20, nop3:12;
+
+	u32 end_nops[5];
+} __packed;
+
+struct solo_enc_buf {
+	enum solo_enc_types	type;
+	struct vop_header	*vh;
+	int			motion;
+};
+
 static int solo_is_motion_on(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	u8 ch = solo_enc->ch;
 
-	if (solo_dev->motion_mask & (1 << ch))
-		return 1;
-	return 0;
+	return (solo_dev->motion_mask >> solo_enc->ch) & 1;
+}
+
+static int solo_motion_detected(struct solo_enc_dev *solo_enc)
+{
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
+	unsigned long flags;
+	u32 ch_mask = 1 << solo_enc->ch;
+	int ret = 0;
+
+	spin_lock_irqsave(&solo_enc->motion_lock, flags);
+	if (solo_reg_read(solo_dev, SOLO_VI_MOT_STATUS) & ch_mask) {
+		solo_reg_write(solo_dev, SOLO_VI_MOT_CLEAR, ch_mask);
+		ret = 1;
+	}
+	spin_unlock_irqrestore(&solo_enc->motion_lock, flags);
+
+	return ret;
 }
 
 static void solo_motion_toggle(struct solo_enc_dev *solo_enc, int on)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	u8 ch = solo_enc->ch;
+	u32 mask = 1 << solo_enc->ch;
+	unsigned long flags;
 
-	spin_lock(&solo_enc->lock);
+	spin_lock_irqsave(&solo_enc->motion_lock, flags);
 
 	if (on)
-		solo_dev->motion_mask |= (1 << ch);
+		solo_dev->motion_mask |= mask;
 	else
-		solo_dev->motion_mask &= ~(1 << ch);
+		solo_dev->motion_mask &= ~mask;
 
-	/* Do this regardless of if we are turning on or off */
-	solo_reg_write(solo_enc->solo_dev, SOLO_VI_MOT_CLEAR,
-		       1 << solo_enc->ch);
-	solo_enc->motion_detected = 0;
+	solo_reg_write(solo_dev, SOLO_VI_MOT_CLEAR, mask);
 
 	solo_reg_write(solo_dev, SOLO_VI_MOT_ADR,
 		       SOLO_VI_MOTION_EN(solo_dev->motion_mask) |
 		       (SOLO_MOTION_EXT_ADDR(solo_dev) >> 16));
 
-	if (solo_dev->motion_mask)
-		solo_irq_on(solo_dev, SOLO_IRQ_MOTION);
-	else
-		solo_irq_off(solo_dev, SOLO_IRQ_MOTION);
-
-	spin_unlock(&solo_enc->lock);
+	spin_unlock_irqrestore(&solo_enc->motion_lock, flags);
 }
 
-/* Should be called with solo_enc->lock held */
+/* MUST be called with solo_enc->enable_lock held */
 static void solo_update_mode(struct solo_enc_dev *solo_enc)
 {
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-
-	assert_spin_locked(&solo_enc->lock);
+	int vop_len;
+	unsigned char *vop;
 
 	solo_enc->interlaced = (solo_enc->mode & 0x08) ? 1 : 0;
 	solo_enc->bw_weight = max(solo_dev->fps / solo_enc->interval, 1);
 
-	switch (solo_enc->mode) {
-	case SOLO_ENC_MODE_CIF:
+	if (solo_enc->mode == SOLO_ENC_MODE_CIF) {
 		solo_enc->width = solo_dev->video_hsize >> 1;
 		solo_enc->height = solo_dev->video_vsize;
-		break;
-	case SOLO_ENC_MODE_D1:
+		if (solo_dev->type == SOLO_DEV_6110) {
+			if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC) {
+				vop = vop_6110_ntsc_cif;
+				vop_len = sizeof(vop_6110_ntsc_cif);
+			} else {
+				vop = vop_6110_pal_cif;
+				vop_len = sizeof(vop_6110_pal_cif);
+			}
+		} else {
+			if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC) {
+				vop = vop_6010_ntsc_cif;
+				vop_len = sizeof(vop_6010_ntsc_cif);
+			} else {
+				vop = vop_6010_pal_cif;
+				vop_len = sizeof(vop_6010_pal_cif);
+			}
+		}
+	} else {
 		solo_enc->width = solo_dev->video_hsize;
 		solo_enc->height = solo_dev->video_vsize << 1;
 		solo_enc->bw_weight <<= 2;
-		break;
-	default:
-		WARN(1, "mode is unknown\n");
+		if (solo_dev->type == SOLO_DEV_6110) {
+			if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC) {
+				vop = vop_6110_ntsc_d1;
+				vop_len = sizeof(vop_6110_ntsc_d1);
+			} else {
+				vop = vop_6110_pal_d1;
+				vop_len = sizeof(vop_6110_pal_d1);
+			}
+		} else {
+			if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC) {
+				vop = vop_6010_ntsc_d1;
+				vop_len = sizeof(vop_6010_ntsc_d1);
+			} else {
+				vop = vop_6010_pal_d1;
+				vop_len = sizeof(vop_6010_pal_d1);
+			}
+		}
 	}
+
+	memcpy(solo_enc->vop, vop, vop_len);
+
+	/* Some fixups for 6010/M4V */
+	if (solo_dev->type == SOLO_DEV_6010) {
+		u16 fps = solo_dev->fps * 1000;
+		u16 interval = solo_enc->interval * 1000;
+
+		vop = solo_enc->vop;
+
+		/* Frame rate and interval */
+		vop[22] = fps >> 4;
+		vop[23] = ((fps << 4) & 0xf0) | 0x0c
+			| ((interval >> 13) & 0x3);
+		vop[24] = (interval >> 5) & 0xff;
+		vop[25] = ((interval << 3) & 0xf8) | 0x04;
+	}
+
+	solo_enc->vop_len = vop_len;
+
+	/* Now handle the jpeg header */
+	vop = solo_enc->jpeg_header;
+	vop[SOF0_START + 5] = 0xff & (solo_enc->height >> 8);
+	vop[SOF0_START + 6] = 0xff & solo_enc->height;
+	vop[SOF0_START + 7] = 0xff & (solo_enc->width >> 8);
+	vop[SOF0_START + 8] = 0xff & solo_enc->width;
+
+	memcpy(vop + DQT_START,
+	       jpeg_dqt[solo_g_jpeg_qp(solo_dev, solo_enc->ch)], DQT_LEN);
 }
 
-/* Should be called with solo_enc->lock held */
-static int solo_enc_on(struct solo_enc_fh *fh)
+/* MUST be called with solo_enc->enable_lock held */
+static int __solo_enc_on(struct solo_enc_fh *fh)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
 	u8 ch = solo_enc->ch;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	u8 interval;
 
-	assert_spin_locked(&solo_enc->lock);
+	BUG_ON(!mutex_is_locked(&solo_enc->enable_lock));
 
 	if (fh->enc_on)
 		return 0;
@@ -170,13 +342,20 @@ static int solo_enc_on(struct solo_enc_fh *fh)
 	}
 
 	fh->enc_on = 1;
-	fh->rd_idx = solo_enc->solo_dev->enc_wr_idx;
+	list_add(&fh->list, &solo_enc->listeners);
 
 	if (fh->type == SOLO_ENC_TYPE_EXT)
 		solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(ch), 1);
 
-	if (atomic_inc_return(&solo_enc->readers) > 1)
+	/* Reset the encoder if we are the first mpeg reader, else only reset
+	 * on the first mjpeg reader. */
+	if (fh->fmt == V4L2_PIX_FMT_MPEG) {
+		atomic_inc(&solo_enc->readers);
+		if (atomic_inc_return(&solo_enc->mpeg_readers) > 1)
+			return 0;
+	} else if (atomic_inc_return(&solo_enc->readers) > 1) {
 		return 0;
+	}
 
 	/* Disable all encoding for this channel */
 	solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(ch), 0);
@@ -203,701 +382,414 @@ static int solo_enc_on(struct solo_enc_fh *fh)
 	/* Enables the standard encoder */
 	solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(ch), solo_enc->mode);
 
-	/* Settle down Beavis... */
-	mdelay(10);
-
 	return 0;
 }
 
-static void solo_enc_off(struct solo_enc_fh *fh)
+static int solo_enc_on(struct solo_enc_fh *fh)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo_dev *solo_dev = solo_enc->solo_dev;
-
-	if (!fh->enc_on)
-		return;
-
-	if (fh->kthread) {
-		kthread_stop(fh->kthread);
-		fh->kthread = NULL;
-	}
-
-	solo_dev->enc_bw_remain += solo_enc->bw_weight;
-	fh->enc_on = 0;
+	int ret;
 
-	if (atomic_dec_return(&solo_enc->readers) > 0)
-		return;
+	mutex_lock(&solo_enc->enable_lock);
+	ret = __solo_enc_on(fh);
+	mutex_unlock(&solo_enc->enable_lock);
 
-	solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(solo_enc->ch), 0);
-	solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(solo_enc->ch), 0);
+	return ret;
 }
 
-static int solo_start_fh_thread(struct solo_enc_fh *fh)
+static void __solo_enc_off(struct solo_enc_fh *fh)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 
-	fh->kthread = kthread_run(solo_enc_thread, fh, SOLO6X10_NAME "_enc");
-
-	/* Oops, we had a problem */
-	if (IS_ERR(fh->kthread)) {
-		spin_lock(&solo_enc->lock);
-		solo_enc_off(fh);
-		spin_unlock(&solo_enc->lock);
-
-		return PTR_ERR(fh->kthread);
-	}
+	BUG_ON(!mutex_is_locked(&solo_enc->enable_lock));
 
-	return 0;
-}
+	if (!fh->enc_on)
+		return;
 
-static void enc_reset_gop(struct solo_dev *solo_dev, u8 ch)
-{
-	BUG_ON(ch >= solo_dev->nr_chans);
-	solo_reg_write(solo_dev, SOLO_VE_CH_GOP(ch), 1);
-	solo_dev->v4l2_enc[ch]->reset_gop = 1;
-}
+	list_del(&fh->list);
+	fh->enc_on = 0;
 
-static int enc_gop_reset(struct solo_dev *solo_dev, u8 ch, u8 vop)
-{
-	BUG_ON(ch >= solo_dev->nr_chans);
-	if (!solo_dev->v4l2_enc[ch]->reset_gop)
-		return 0;
-	if (vop)
-		return 1;
-	solo_dev->v4l2_enc[ch]->reset_gop = 0;
-	solo_reg_write(solo_dev, SOLO_VE_CH_GOP(ch),
-		       solo_dev->v4l2_enc[ch]->gop);
-	return 0;
-}
+	if (fh->fmt == V4L2_PIX_FMT_MPEG)
+		atomic_dec(&solo_enc->mpeg_readers);
 
-static void enc_write_sg(struct scatterlist *sglist, void *buf, int size)
-{
-	struct scatterlist *sg;
-	u8 *src = buf;
+	if (atomic_dec_return(&solo_enc->readers) > 0)
+		return;
 
-	for (sg = sglist; sg && size > 0; sg = sg_next(sg)) {
-		u8 *p = sg_virt(sg);
-		size_t len = sg_dma_len(sg);
-		int i;
+	solo_dev->enc_bw_remain += solo_enc->bw_weight;
 
-		for (i = 0; i < len && size; i++)
-			p[i] = *(src++);
-	}
+	solo_reg_write(solo_dev, SOLO_CAP_CH_SCALE(solo_enc->ch), 0);
+	solo_reg_write(solo_dev, SOLO_CAP_CH_COMP_ENA_E(solo_enc->ch), 0);
 }
 
-static int enc_get_mpeg_dma_sg(struct solo_dev *solo_dev,
-			       struct p2m_desc *desc,
-			       struct scatterlist *sglist, int skip,
-			       unsigned int off, unsigned int size)
+static void solo_enc_off(struct solo_enc_fh *fh)
 {
-	int ret;
-
-	if (off > SOLO_MP4E_EXT_SIZE(solo_dev))
-		return -EINVAL;
-
-	if (off + size <= SOLO_MP4E_EXT_SIZE(solo_dev)) {
-		return solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_MP4E,
-				       desc, 0, sglist, skip,
-				       SOLO_MP4E_EXT_ADDR(solo_dev) + off, size);
-	}
-
-	/* Buffer wrap */
-	ret = solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_MP4E, desc, 0,
-			      sglist, skip, SOLO_MP4E_EXT_ADDR(solo_dev) + off,
-			      SOLO_MP4E_EXT_SIZE(solo_dev) - off);
-
-	ret |= solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_MP4E, desc, 0,
-			       sglist, skip + SOLO_MP4E_EXT_SIZE(solo_dev) - off,
-			       SOLO_MP4E_EXT_ADDR(solo_dev),
-			       size + off - SOLO_MP4E_EXT_SIZE(solo_dev));
+	struct solo_enc_dev *solo_enc = fh->enc;
 
-	return ret;
+	mutex_lock(&solo_enc->enable_lock);
+	__solo_enc_off(fh);
+	mutex_unlock(&solo_enc->enable_lock);
 }
 
-static int enc_get_mpeg_dma_t(struct solo_dev *solo_dev,
-			      dma_addr_t buf, unsigned int off,
-			      unsigned int size)
+static int enc_get_mpeg_dma(struct solo_dev *solo_dev, dma_addr_t dma,
+			      unsigned int off, unsigned int size)
 {
 	int ret;
 
 	if (off > SOLO_MP4E_EXT_SIZE(solo_dev))
 		return -EINVAL;
 
+	/* Single shot */
 	if (off + size <= SOLO_MP4E_EXT_SIZE(solo_dev)) {
-		return solo_p2m_dma_t(solo_dev, SOLO_P2M_DMA_ID_MP4E, 0, buf,
-				      SOLO_MP4E_EXT_ADDR(solo_dev) + off, size);
+		return solo_p2m_dma_t(solo_dev, 0, dma,
+				      SOLO_MP4E_EXT_ADDR(solo_dev) + off, size,
+				      0, 0);
 	}
 
 	/* Buffer wrap */
-	ret = solo_p2m_dma_t(solo_dev, SOLO_P2M_DMA_ID_MP4E, 0, buf,
+	ret = solo_p2m_dma_t(solo_dev, 0, dma,
 			     SOLO_MP4E_EXT_ADDR(solo_dev) + off,
-			     SOLO_MP4E_EXT_SIZE(solo_dev) - off);
-
-	ret |= solo_p2m_dma_t(solo_dev, SOLO_P2M_DMA_ID_MP4E, 0,
-			      buf + SOLO_MP4E_EXT_SIZE(solo_dev) - off,
-			      SOLO_MP4E_EXT_ADDR(solo_dev),
-			      size + off - SOLO_MP4E_EXT_SIZE(solo_dev));
-
-	return ret;
-}
+			     SOLO_MP4E_EXT_SIZE(solo_dev) - off, 0, 0);
 
-static int enc_get_mpeg_dma(struct solo_dev *solo_dev, void *buf,
-			    unsigned int off, unsigned int size)
-{
-	int ret;
-
-	dma_addr_t dma_addr = pci_map_single(solo_dev->pdev, buf, size,
-					     PCI_DMA_FROMDEVICE);
-	ret = enc_get_mpeg_dma_t(solo_dev, dma_addr, off, size);
-	pci_unmap_single(solo_dev->pdev, dma_addr, size, PCI_DMA_FROMDEVICE);
+	if (!ret) {
+		ret = solo_p2m_dma_t(solo_dev, 0,
+			     dma + SOLO_MP4E_EXT_SIZE(solo_dev) - off,
+			     SOLO_MP4E_EXT_ADDR(solo_dev),
+			     size + off - SOLO_MP4E_EXT_SIZE(solo_dev), 0, 0);
+	}
 
 	return ret;
 }
 
-static int enc_get_jpeg_dma_sg(struct solo_dev *solo_dev,
-			       struct p2m_desc *desc,
-			       struct scatterlist *sglist, int skip,
-			       unsigned int off, unsigned int size)
+/* Build a descriptor queue out of an SG list and send it to the P2M for
+ * processing. */
+static int solo_send_desc(struct solo_enc_fh *fh, int skip,
+			  struct videobuf_dmabuf *vbuf, int off, int size,
+			  unsigned int base, unsigned int base_size)
 {
+	struct solo_dev *solo_dev = fh->enc->solo_dev;
+	struct scatterlist *sg;
+	int i;
 	int ret;
 
-	if (off > SOLO_JPEG_EXT_SIZE(solo_dev))
+	if (WARN_ON_ONCE(size > FRAME_BUF_SIZE))
 		return -EINVAL;
 
-	if (off + size <= SOLO_JPEG_EXT_SIZE(solo_dev)) {
-		return solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_JPEG,
-				       desc, 0, sglist, skip,
-				       SOLO_JPEG_EXT_ADDR(solo_dev) + off, size);
-	}
-
-	/* Buffer wrap */
-	ret = solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_JPEG, desc, 0,
-			      sglist, skip, SOLO_JPEG_EXT_ADDR(solo_dev) + off,
-			      SOLO_JPEG_EXT_SIZE(solo_dev) - off);
+	fh->desc_count = 1;
+
+	for_each_sg(vbuf->sglist, sg, vbuf->sglen, i) {
+		struct solo_p2m_desc *desc;
+		dma_addr_t dma;
+		int len;
+		int left = base_size - off;
+
+		desc = &fh->desc_items[fh->desc_count++];
+		dma = sg_dma_address(sg);
+		len = sg_dma_len(sg);
+
+		/* We assume this is smaller than the scatter size */
+		BUG_ON(skip >= len);
+		if (skip) {
+			len -= skip;
+			dma += skip;
+			size -= skip;
+			skip = 0;
+		}
 
-	ret |= solo_p2m_dma_sg(solo_dev, SOLO_P2M_DMA_ID_JPEG, desc, 0,
-			       sglist, skip + SOLO_JPEG_EXT_SIZE(solo_dev) - off,
-			       SOLO_JPEG_EXT_ADDR(solo_dev),
-			       size + off - SOLO_JPEG_EXT_SIZE(solo_dev));
+		len = min(len, size);
 
-	return ret;
-}
+		if (len <= left) {
+			/* Single descriptor */
+			solo_p2m_fill_desc(desc, 0, dma, base + off,
+					   len, 0, 0);
+		} else {
+			/* Buffer wrap */
+			/* XXX: Do these as separate DMA requests, to avoid
+			   timeout errors triggered by awkwardly sized
+			   descriptors. See
+			   <https://github.com/bluecherrydvr/solo6x10/issues/8>
+			 */
+			ret = solo_p2m_dma_t(solo_dev, 0, dma, base + off,
+					     left, 0, 0);
+			if (ret)
+				return ret;
+
+			ret = solo_p2m_dma_t(solo_dev, 0, dma + left, base,
+					     len - left, 0, 0);
+			if (ret)
+				return ret;
+
+			fh->desc_count--;
+		}
 
-/* Returns true of __chk is within the first __range bytes of __off */
-#define OFF_IN_RANGE(__off, __range, __chk) \
-	((__off <= __chk) && ((__off + __range) >= __chk))
+		size -= len;
+		if (size <= 0)
+			break;
 
-static void solo_jpeg_header(struct solo_enc_dev *solo_enc,
-			     struct videobuf_dmabuf *vbuf)
-{
-	struct scatterlist *sg;
-	void *src = jpeg_header;
-	size_t copied = 0;
-	size_t to_copy = sizeof(jpeg_header);
-
-	for (sg = vbuf->sglist; sg && copied < to_copy; sg = sg_next(sg)) {
-		size_t this_copy = min(sg_dma_len(sg),
-				       (unsigned int)(to_copy - copied));
-		u8 *p = sg_virt(sg);
-
-		memcpy(p, src + copied, this_copy);
-
-		if (OFF_IN_RANGE(copied, this_copy, SOF0_START + 5))
-			p[(SOF0_START + 5) - copied] =
-				0xff & (solo_enc->height >> 8);
-		if (OFF_IN_RANGE(copied, this_copy, SOF0_START + 6))
-			p[(SOF0_START + 6) - copied] = 0xff & solo_enc->height;
-		if (OFF_IN_RANGE(copied, this_copy, SOF0_START + 7))
-			p[(SOF0_START + 7) - copied] =
-				0xff & (solo_enc->width >> 8);
-		if (OFF_IN_RANGE(copied, this_copy, SOF0_START + 8))
-			p[(SOF0_START + 8) - copied] = 0xff & solo_enc->width;
-
-		copied += this_copy;
+		off += len;
+		if (off >= base_size)
+			off -= base_size;
+
+		/* Because we may use two descriptors per loop */
+		if (fh->desc_count >= (fh->desc_nelts - 1)) {
+			ret = solo_p2m_dma_desc(solo_dev, fh->desc_items,
+						fh->desc_dma,
+						fh->desc_count - 1);
+			if (ret)
+				return ret;
+			fh->desc_count = 1;
+		}
 	}
-}
-
-static int solo_fill_jpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
-			  struct videobuf_buffer *vb,
-			  struct videobuf_dmabuf *vbuf)
-{
-	struct solo_dev *solo_dev = fh->enc->solo_dev;
-	int size = enc_buf->jpeg_size;
-
-	/* Copy the header first (direct write) */
-	solo_jpeg_header(fh->enc, vbuf);
-
-	vb->size = size + sizeof(jpeg_header);
-
-	/* Grab the jpeg frame */
-	return enc_get_jpeg_dma_sg(solo_dev, fh->desc, vbuf->sglist,
-				   sizeof(jpeg_header),
-				   enc_buf->jpeg_off, size);
-}
-
-static inline int vop_interlaced(__le32 *vh)
-{
-	return (__le32_to_cpu(vh[0]) >> 30) & 1;
-}
 
-static inline u32 vop_size(__le32 *vh)
-{
-	return __le32_to_cpu(vh[0]) & 0xFFFFF;
-}
-
-static inline u8 vop_hsize(__le32 *vh)
-{
-	return (__le32_to_cpu(vh[1]) >> 8) & 0xFF;
-}
-
-static inline u8 vop_vsize(__le32 *vh)
-{
-	return __le32_to_cpu(vh[1]) & 0xFF;
-}
-
-/* must be called with *bits % 8 = 0 */
-static void write_bytes(u8 **out, unsigned *bits, const u8 *src, unsigned count)
-{
-	memcpy(*out, src, count);
-	*out += count;
-	*bits += count * 8;
-}
-
-static void write_bits(u8 **out, unsigned *bits, u32 value, unsigned count)
-{
-
-	value <<= 32 - count; // shift to the right
+	if (fh->desc_count <= 1)
+		return 0;
 
-	while (count--) {
-		**out <<= 1;
-		**out |= !!(value & (1 << 31)); /* MSB */
-		value <<= 1;
-		if (++(*bits) % 8 == 0)
-			(*out)++;
-	}
+	return solo_p2m_dma_desc(solo_dev, fh->desc_items, fh->desc_dma,
+				 fh->desc_count - 1);
 }
 
-static void write_ue(u8 **out, unsigned *bits, unsigned value) /* H.264 only */
+static int solo_fill_jpeg(struct solo_enc_fh *fh, struct videobuf_buffer *vb,
+			  struct videobuf_dmabuf *vbuf, struct vop_header *vh)
 {
-	uint32_t max = 0, cnt = 0;
+	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
+	struct solo_videobuf *svb = (struct solo_videobuf *)vb;
+	int frame_size;
 
-	while (value > max) {
-		max = (max + 2) * 2 - 2;
-		cnt++;
-	}
-	write_bits(out, bits, 1, cnt + 1);
-	write_bits(out, bits, ~(max - value), cnt);
-}
+	svb->flags |= V4L2_BUF_FLAG_KEYFRAME;
 
-static void write_se(u8 **out, unsigned *bits, int value) /* H.264 only */
-{
-	if (value <= 0)
-		write_ue(out, bits, -value * 2);
-	else
-		write_ue(out, bits, value * 2 - 1);
-}
+	if (vb->bsize < (vh->jpeg_size + solo_enc->jpeg_len))
+		return -EIO;
 
-static void write_mpeg4_end(u8 **out, unsigned *bits)
-{
-	write_bits(out, bits, 0, 1);
-	/* align on 32-bit boundary */
-	if (*bits % 32)
-		write_bits(out, bits, 0xFFFFFFFF, 32 - *bits % 32);
-}
+	vb->width = solo_enc->width;
+	vb->height = solo_enc->height;
+	vb->size = vh->jpeg_size + solo_enc->jpeg_len;
 
-static void write_h264_end(u8 **out, unsigned *bits, int align)
-{
-	write_bits(out, bits, 1, 1);
-	while ((*bits) % 8)
-		write_bits(out, bits, 0, 1);
-	if (align)
-		while ((*bits) % 32)
-			write_bits(out, bits, 0, 1);
-}
+	sg_copy_from_buffer(vbuf->sglist, vbuf->sglen,
+			    solo_enc->jpeg_header,
+			    solo_enc->jpeg_len);
 
-static void mpeg4_write_vol(u8 **out, struct solo_dev *solo_dev,
-			    __le32 *vh, unsigned fps, unsigned interval)
-{
-	static const u8 hdr[] = {
-		0, 0, 1, 0x00 /* video_object_start_code */,
-		0, 0, 1, 0x20 /* video_object_layer_start_code */
-	};
-	unsigned bits = 0;
-	unsigned width = vop_hsize(vh) << 4;
-	unsigned height = vop_vsize(vh) << 4;
-	unsigned interlaced = vop_interlaced(vh);
-
-	write_bytes(out, &bits, hdr, sizeof(hdr));
-	write_bits(out, &bits,    0,  1); /* random_accessible_vol */
-	write_bits(out, &bits, 0x04,  8); /* video_object_type_indication: main */
-	write_bits(out, &bits,    1,  1); /* is_object_layer_identifier */
-	write_bits(out, &bits,    2,  4); /* video_object_layer_verid: table V2-39 */
-	write_bits(out, &bits,    0,  3); /* video_object_layer_priority */
-	if (solo_dev->video_type == SOLO_VO_FMT_TYPE_NTSC)
-		write_bits(out, &bits,  3,  4); /* aspect_ratio_info, assuming 4:3 */
-	else
-		write_bits(out, &bits,  2,  4);
-	write_bits(out, &bits,    1,  1); /* vol_control_parameters */
-	write_bits(out, &bits,    1,  2); /* chroma_format: 4:2:0 */
-	write_bits(out, &bits,    1,  1); /* low_delay */
-	write_bits(out, &bits,    0,  1); /* vbv_parameters */
-	write_bits(out, &bits,    0,  2); /* video_object_layer_shape: rectangular */
-	write_bits(out, &bits,    1,  1); /* marker_bit */
-	write_bits(out, &bits,  fps, 16); /* vop_time_increment_resolution */
-	write_bits(out, &bits,    1,  1); /* marker_bit */
-	write_bits(out, &bits,    1,  1); /* fixed_vop_rate */
-	write_bits(out, &bits, interval, 15); /* fixed_vop_time_increment */
-	write_bits(out, &bits,    1,  1); /* marker_bit */
-	write_bits(out, &bits, width, 13); /* video_object_layer_width */
-	write_bits(out, &bits,    1,  1); /* marker_bit */
-	write_bits(out, &bits, height, 13); /* video_object_layer_height */
-	write_bits(out, &bits,    1,  1); /* marker_bit */
-	write_bits(out, &bits, interlaced, 1); /* interlaced */
-	write_bits(out, &bits,    1,  1); /* obmc_disable */
-	write_bits(out, &bits,    0,  2); /* sprite_enable */
-	write_bits(out, &bits,    0,  1); /* not_8_bit */
-	write_bits(out, &bits,    1,  0); /* quant_type */
-	write_bits(out, &bits,    0,  1); /* load_intra_quant_mat */
-	write_bits(out, &bits,    0,  1); /* load_nonintra_quant_mat */
-	write_bits(out, &bits,    0,  1); /* quarter_sample */
-	write_bits(out, &bits,    1,  1); /* complexity_estimation_disable */
-	write_bits(out, &bits,    1,  1); /* resync_marker_disable */
-	write_bits(out, &bits,    0,  1); /* data_partitioned */
-	write_bits(out, &bits,    0,  1); /* newpred_enable */
-	write_bits(out, &bits,    0,  1); /* reduced_resolution_vop_enable */
-	write_bits(out, &bits,    0,  1); /* scalability */
-	write_mpeg4_end(out, &bits);
-}
+	frame_size = (vh->jpeg_size + solo_enc->jpeg_len + (DMA_ALIGN - 1))
+		& ~(DMA_ALIGN - 1);
 
-static void h264_write_vol(u8 **out, struct solo_dev *solo_dev, __le32 *vh)
-{
-	static const u8 sps[] = {
-		0, 0, 0, 1 /* start code */, 0x67, 66 /* profile_idc */,
-		0 /* constraints */, 30 /* level_idc */
-	};
-	static const u8 pps[] = {
-		0, 0, 0, 1 /* start code */, 0x68
-	};
-
-	unsigned bits = 0;
-	unsigned mbs_w = vop_hsize(vh);
-	unsigned mbs_h = vop_vsize(vh);
-
-	write_bytes(out, &bits, sps, sizeof(sps));
-	write_ue(out, &bits,   0);	/* seq_parameter_set_id */
-	write_ue(out, &bits,   5);	/* log2_max_frame_num_minus4 */
-	write_ue(out, &bits,   0);	/* pic_order_cnt_type */
-	write_ue(out, &bits,   6);	/* log2_max_pic_order_cnt_lsb_minus4 */
-	write_ue(out, &bits,   1);	/* max_num_ref_frames */
-	write_bits(out, &bits, 0, 1);	/* gaps_in_frame_num_value_allowed_flag */
-	write_ue(out, &bits, mbs_w - 1);	/* pic_width_in_mbs_minus1 */
-	write_ue(out, &bits, mbs_h - 1);	/* pic_height_in_map_units_minus1 */
-	write_bits(out, &bits, 1, 1);	/* frame_mbs_only_flag */
-	write_bits(out, &bits, 1, 1);	/* direct_8x8_frame_field_flag */
-	write_bits(out, &bits, 0, 1);	/* frame_cropping_flag */
-	write_bits(out, &bits, 0, 1);	/* vui_parameters_present_flag */
-	write_h264_end(out, &bits, 0);
-
-	write_bytes(out, &bits, pps, sizeof(pps));
-	write_ue(out, &bits,   0);	/* pic_parameter_set_id */
-	write_ue(out, &bits,   0);	/* seq_parameter_set_id */
-	write_bits(out, &bits, 0, 1);	/* entropy_coding_mode_flag */
-	write_bits(out, &bits, 0, 1);	/* bottom_field_pic_order_in_frame_present_flag */
-	write_ue(out, &bits,   0);	/* num_slice_groups_minus1 */
-	write_ue(out, &bits,   0);	/* num_ref_idx_l0_default_active_minus1 */
-	write_ue(out, &bits,   0);	/* num_ref_idx_l1_default_active_minus1 */
-	write_bits(out, &bits, 0, 1);	/* weighted_pred_flag */
-	write_bits(out, &bits, 0, 2);	/* weighted_bipred_idc */
-	write_se(out, &bits,   0);	/* pic_init_qp_minus26 */
-	write_se(out, &bits,   0);	/* pic_init_qs_minus26 */
-	write_se(out, &bits,   2);	/* chroma_qp_index_offset */
-	write_bits(out, &bits, 0, 1);	/* deblocking_filter_control_present_flag */
-	write_bits(out, &bits, 1, 1);	/* constrained_intra_pred_flag */
-	write_bits(out, &bits, 0, 1);	/* redundant_pic_cnt_present_flag */
-	write_h264_end(out, &bits, 1);
+	return solo_send_desc(fh, solo_enc->jpeg_len, vbuf, vh->jpeg_off,
+			      frame_size, SOLO_JPEG_EXT_ADDR(solo_dev),
+			      SOLO_JPEG_EXT_SIZE(solo_dev));
 }
 
-static int solo_fill_mpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
-			  struct videobuf_buffer *vb,
-			  struct videobuf_dmabuf *vbuf)
+static int solo_fill_mpeg(struct solo_enc_fh *fh, struct videobuf_buffer *vb,
+			  struct videobuf_dmabuf *vbuf, struct vop_header *vh)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
-
-#define VH_WORDS 16
-#define MAX_VOL_HEADER_LENGTH 64
-
-	__le32 vh[VH_WORDS];
-	int ret;
-	int frame_size, frame_off;
+	struct solo_videobuf *svb = (struct solo_videobuf *)vb;
+	int frame_off, frame_size;
 	int skip = 0;
 
-	if (WARN_ON_ONCE(enc_buf->size <= sizeof(vh)))
-		return -EINVAL;
-
-	/* First get the hardware vop header (not real mpeg) */
-	ret = enc_get_mpeg_dma(solo_dev, vh, enc_buf->off, sizeof(vh));
-	if (WARN_ON_ONCE(ret))
-		return ret;
+	if (vb->bsize < vh->mpeg_size)
+		return -EIO;
 
-	if (WARN_ON_ONCE(vop_size(vh) > enc_buf->size))
-		return -EINVAL;
+	vb->width = vh->hsize << 4;
+	vb->height = vh->vsize << 4;
+	vb->size = vh->mpeg_size;
 
-	vb->width = vop_hsize(vh) << 4;
-	vb->height = vop_vsize(vh) << 4;
-	vb->size = vop_size(vh);
+	/* If this is a key frame, add extra header */
+	if (!vh->vop_type) {
+		sg_copy_from_buffer(vbuf->sglist, vbuf->sglen,
+				    solo_enc->vop,
+				    solo_enc->vop_len);
 
-	/* If this is a key frame, add extra m4v header */
-	if (!enc_buf->vop) {
-		u8 header[MAX_VOL_HEADER_LENGTH], *out = header;
+		skip = solo_enc->vop_len;
+		vb->size += solo_enc->vop_len;
 
-		if (solo_dev->flags & FLAGS_6110)
-			h264_write_vol(&out, solo_dev, vh);
-		else
-			mpeg4_write_vol(&out, solo_dev, vh,
-					solo_dev->fps * 1000,
-					solo_enc->interval * 1000);
-		skip = out - header;
-		enc_write_sg(vbuf->sglist, header, skip);
-		/* Adjust the dma buffer past this header */
-		vb->size += skip;
+		svb->flags |= V4L2_BUF_FLAG_KEYFRAME;
+	} else {
+		svb->flags |= V4L2_BUF_FLAG_PFRAME;
 	}
 
 	/* Now get the actual mpeg payload */
-	frame_off = (enc_buf->off + sizeof(vh)) % SOLO_MP4E_EXT_SIZE(solo_dev);
-	frame_size = enc_buf->size - sizeof(vh);
-
-	ret = enc_get_mpeg_dma_sg(solo_dev, fh->desc, vbuf->sglist,
-				  skip, frame_off, frame_size);
-	WARN_ON_ONCE(ret);
+	frame_off = (vh->mpeg_off + sizeof(*vh))
+		% SOLO_MP4E_EXT_SIZE(solo_dev);
+	frame_size = (vh->mpeg_size + skip + (DMA_ALIGN - 1))
+		& ~(DMA_ALIGN - 1);
 
-	return ret;
+	return solo_send_desc(fh, skip, vbuf, frame_off, frame_size,
+			      SOLO_MP4E_EXT_ADDR(solo_dev),
+			      SOLO_MP4E_EXT_SIZE(solo_dev));
 }
 
-static void solo_enc_fillbuf(struct solo_enc_fh *fh,
-			    struct videobuf_buffer *vb)
+static int solo_enc_fillbuf(struct solo_enc_fh *fh,
+			    struct videobuf_buffer *vb,
+			    struct solo_enc_buf *enc_buf)
 {
 	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct solo_enc_buf *enc_buf = NULL;
-	struct videobuf_dmabuf *vbuf;
+	struct solo_videobuf *svb = (struct solo_videobuf *)vb;
+	struct videobuf_dmabuf *vbuf = NULL;
+	struct vop_header *vh = enc_buf->vh;
 	int ret;
-	int error = 1;
-	u16 idx = fh->rd_idx;
-
-	while (idx != solo_dev->enc_wr_idx) {
-		struct solo_enc_buf *ebuf = &solo_dev->enc_buf[idx];
 
-		idx = (idx + 1) % SOLO_NR_RING_BUFS;
-
-		if (ebuf->ch != solo_enc->ch)
-			continue;
-
-		if (fh->fmt == V4L2_PIX_FMT_MPEG) {
-			if (fh->type == ebuf->type) {
-				enc_buf = ebuf;
-				break;
-			}
-		} else {
-			/* For mjpeg, keep reading to the newest frame */
-			enc_buf = ebuf;
-		}
+	vbuf = videobuf_to_dma(vb);
+	if (WARN_ON_ONCE(!vbuf)) {
+		ret = -EIO;
+		goto vbuf_error;
 	}
 
-	fh->rd_idx = idx;
-
-	if (WARN_ON_ONCE(!enc_buf))
-		goto buf_err;
+	/* Setup some common flags for both types */
+	svb->flags = V4L2_BUF_FLAG_TIMECODE;
+	vb->ts.tv_sec = vh->sec;
+	vb->ts.tv_usec = vh->usec;
 
-	if ((fh->fmt == V4L2_PIX_FMT_MPEG &&
-	     vb->bsize < enc_buf->size) ||
-	    (fh->fmt == V4L2_PIX_FMT_MJPEG &&
-	     vb->bsize < (enc_buf->jpeg_size + sizeof(jpeg_header)))) {
-		WARN_ON_ONCE(1);
-		goto buf_err;
+	/* Check for motion flags */
+	if (solo_is_motion_on(solo_enc)) {
+		svb->flags |= V4L2_BUF_FLAG_MOTION_ON;
+		if (enc_buf->motion)
+			svb->flags |= V4L2_BUF_FLAG_MOTION_DETECTED;
 	}
 
-	vbuf = videobuf_to_dma(vb);
-	if (WARN_ON_ONCE(!vbuf))
-		goto buf_err;
-
 	if (fh->fmt == V4L2_PIX_FMT_MPEG)
-		ret = solo_fill_mpeg(fh, enc_buf, vb, vbuf);
+		ret = solo_fill_mpeg(fh, vb, vbuf, vh);
 	else
-		ret = solo_fill_jpeg(fh, enc_buf, vb, vbuf);
+		ret = solo_fill_jpeg(fh, vb, vbuf, vh);
 
-	if (!ret)
-		error = 0;
+vbuf_error:
+	/* On error, we push this buffer back into the queue. The
+	 * videobuf-core doesn't handle error packets very well. Plus
+	 * we recover nicely internally anyway. */
+	if (ret) {
+		unsigned long flags;
 
-buf_err:
-	if (error) {
-		vb->state = VIDEOBUF_ERROR;
+		spin_lock_irqsave(&fh->av_lock, flags);
+		list_add(&vb->queue, &fh->vidq_active);
+		vb->state = VIDEOBUF_QUEUED;
+		spin_unlock_irqrestore(&fh->av_lock, flags);
 	} else {
-		vb->field_count++;
-		vb->ts = enc_buf->ts;
 		vb->state = VIDEOBUF_DONE;
-	}
+		vb->field_count++;
+		vb->width = solo_enc->width;
+		vb->height = solo_enc->height;
 
-	wake_up(&vb->done);
+		wake_up(&vb->done);
+	}
 
-	return;
+	return ret;
 }
 
-static void solo_enc_thread_try(struct solo_enc_fh *fh)
+static void solo_enc_handle_one(struct solo_enc_dev *solo_enc,
+				struct solo_enc_buf *enc_buf)
 {
-	struct solo_enc_dev *solo_enc = fh->enc;
-	struct solo_dev *solo_dev = solo_enc->solo_dev;
-	struct videobuf_buffer *vb;
+	struct solo_enc_fh *fh;
 
-	for (;;) {
-		spin_lock(&solo_enc->lock);
+	mutex_lock(&solo_enc->enable_lock);
+
+	list_for_each_entry(fh, &solo_enc->listeners, list) {
+		struct videobuf_buffer *vb;
+		unsigned long flags;
+
+		if (fh->type != enc_buf->type)
+			continue;
 
-		if (fh->rd_idx == solo_dev->enc_wr_idx)
-			break;
 
 		if (list_empty(&fh->vidq_active))
-			break;
+			continue;
+
+		spin_lock_irqsave(&fh->av_lock, flags);
 
 		vb = list_first_entry(&fh->vidq_active,
 				      struct videobuf_buffer, queue);
 
-		if (!waitqueue_active(&vb->done))
-			break;
-
 		list_del(&vb->queue);
+		vb->state = VIDEOBUF_ACTIVE;
 
-		spin_unlock(&solo_enc->lock);
-
-		solo_enc_fillbuf(fh, vb);
-	}
-
-	assert_spin_locked(&solo_enc->lock);
-	spin_unlock(&solo_enc->lock);
-}
-
-static int solo_enc_thread(void *data)
-{
-	struct solo_enc_fh *fh = data;
-	struct solo_enc_dev *solo_enc = fh->enc;
-	DECLARE_WAITQUEUE(wait, current);
+		spin_unlock_irqrestore(&fh->av_lock, flags);
 
-	set_freezable();
-	add_wait_queue(&solo_enc->thread_wait, &wait);
-
-	for (;;) {
-		long timeout = schedule_timeout_interruptible(HZ);
-		if (timeout == -ERESTARTSYS || kthread_should_stop())
-			break;
-		solo_enc_thread_try(fh);
-		try_to_freeze();
+		solo_enc_fillbuf(fh, vb, enc_buf);
 	}
 
-	remove_wait_queue(&solo_enc->thread_wait, &wait);
-
-	return 0;
+	mutex_unlock(&solo_enc->enable_lock);
 }
 
-void solo_motion_isr(struct solo_dev *solo_dev)
+void solo_enc_v4l2_isr(struct solo_dev *solo_dev)
 {
-	u32 status;
-	int i;
-
-	solo_reg_write(solo_dev, SOLO_IRQ_STAT, SOLO_IRQ_MOTION);
-
-	status = solo_reg_read(solo_dev, SOLO_VI_MOT_STATUS);
-
-	for (i = 0; i < solo_dev->nr_chans; i++) {
-		struct solo_enc_dev *solo_enc = solo_dev->v4l2_enc[i];
-
-		BUG_ON(solo_enc == NULL);
-
-		if (solo_enc->motion_detected)
-			continue;
-		if (!(status & (1 << i)))
-			continue;
-
-		solo_enc->motion_detected = 1;
-	}
+	wake_up_interruptible_all(&solo_dev->ring_thread_wait);
 }
 
-void solo_enc_v4l2_isr(struct solo_dev *solo_dev)
+static void solo_handle_ring(struct solo_dev *solo_dev)
 {
-	struct solo_enc_buf *enc_buf;
-	u32 mpeg_current, mpeg_next, mpeg_size;
-	u32 jpeg_current, jpeg_next, jpeg_size;
-	u32 reg_mpeg_size;
-	u8 cur_q, vop_type;
-	u8 ch;
-	enum solo_enc_types enc_type;
-
-	solo_reg_write(solo_dev, SOLO_IRQ_STAT, SOLO_IRQ_ENCODER);
-
-	cur_q = ((solo_reg_read(solo_dev, SOLO_VE_STATE(11)) & 0xF) + 1) % MP4_QS;
-
-	reg_mpeg_size = ((solo_reg_read(solo_dev, SOLO_VE_STATE(0)) & 0xFFFFF) + 64 + 8) & ~7;
+	for (;;) {
+		struct solo_enc_dev *solo_enc;
+		struct solo_enc_buf enc_buf;
+		u32 mpeg_current, off;
+		u8 ch;
+		u8 cur_q;
+
+		/* Check if the hardware has any new ones in the queue */
+		cur_q = solo_reg_read(solo_dev, SOLO_VE_STATE(11)) & 0xff;
+		if (cur_q == solo_dev->enc_idx)
+			break;
 
-	while (solo_dev->enc_idx != cur_q) {
 		mpeg_current = solo_reg_read(solo_dev,
 					SOLO_VE_MPEG4_QUE(solo_dev->enc_idx));
-		jpeg_current = solo_reg_read(solo_dev,
-					SOLO_VE_JPEG_QUE(solo_dev->enc_idx));
 		solo_dev->enc_idx = (solo_dev->enc_idx + 1) % MP4_QS;
-		mpeg_next = solo_reg_read(solo_dev,
-					SOLO_VE_MPEG4_QUE(solo_dev->enc_idx));
-		jpeg_next = solo_reg_read(solo_dev,
-					SOLO_VE_JPEG_QUE(solo_dev->enc_idx));
 
 		ch = (mpeg_current >> 24) & 0x1f;
+		off = mpeg_current & 0x00ffffff;
+
 		if (ch >= SOLO_MAX_CHANNELS) {
 			ch -= SOLO_MAX_CHANNELS;
-			enc_type = SOLO_ENC_TYPE_EXT;
+			enc_buf.type = SOLO_ENC_TYPE_EXT;
 		} else
-			enc_type = SOLO_ENC_TYPE_STD;
-
-		vop_type = (mpeg_current >> 29) & 3;
-
-		mpeg_current &= 0x00ffffff;
-		mpeg_next    &= 0x00ffffff;
-		jpeg_current &= 0x00ffffff;
-		jpeg_next    &= 0x00ffffff;
-
-		mpeg_size = (SOLO_MP4E_EXT_SIZE(solo_dev) +
-			     mpeg_next - mpeg_current) %
-			    SOLO_MP4E_EXT_SIZE(solo_dev);
-
-		jpeg_size = (SOLO_JPEG_EXT_SIZE(solo_dev) +
-			     jpeg_next - jpeg_current) %
-			    SOLO_JPEG_EXT_SIZE(solo_dev);
+			enc_buf.type = SOLO_ENC_TYPE_STD;
 
-		/* XXX I think this means we had a ring overflow? */
-		if (mpeg_current > mpeg_next && mpeg_size != reg_mpeg_size) {
-			enc_reset_gop(solo_dev, ch);
+		solo_enc = solo_dev->v4l2_enc[ch];
+		if (solo_enc == NULL) {
+			dev_err(&solo_dev->pdev->dev,
+				"Got spurious packet for channel %d\n", ch);
 			continue;
 		}
 
-		/* When resetting the GOP, skip frames until I-frame */
-		if (enc_gop_reset(solo_dev, ch, vop_type))
+		/* FAIL... */
+		if (enc_get_mpeg_dma(solo_dev, solo_dev->vh_dma, off,
+				     sizeof(struct vop_header)))
 			continue;
 
-		enc_buf = &solo_dev->enc_buf[solo_dev->enc_wr_idx];
+		enc_buf.vh = (struct vop_header *)solo_dev->vh_buf;
+		enc_buf.vh->mpeg_off -= SOLO_MP4E_EXT_ADDR(solo_dev);
+		enc_buf.vh->jpeg_off -= SOLO_JPEG_EXT_ADDR(solo_dev);
 
-		enc_buf->vop = vop_type;
-		enc_buf->ch = ch;
-		enc_buf->off = mpeg_current;
-		enc_buf->size = mpeg_size;
-		enc_buf->jpeg_off = jpeg_current;
-		enc_buf->jpeg_size = jpeg_size;
-		enc_buf->type = enc_type;
+		/* Sanity check */
+		if (enc_buf.vh->mpeg_off != off)
+			continue;
+
+		if (solo_motion_detected(solo_enc))
+			enc_buf.motion = 1;
+		else
+			enc_buf.motion = 0;
+
+		solo_enc_handle_one(solo_enc, &enc_buf);
+	}
+}
 
-		do_gettimeofday(&enc_buf->ts);
+static int solo_ring_thread(void *data)
+{
+	struct solo_dev *solo_dev = data;
+	DECLARE_WAITQUEUE(wait, current);
 
-		solo_dev->enc_wr_idx = (solo_dev->enc_wr_idx + 1) %
-					SOLO_NR_RING_BUFS;
+	set_freezable();
+	add_wait_queue(&solo_dev->ring_thread_wait, &wait);
 
-		wake_up_interruptible(&solo_dev->v4l2_enc[ch]->thread_wait);
+	for (;;) {
+		long timeout = schedule_timeout_interruptible(HZ);
+		if (timeout == -ERESTARTSYS || kthread_should_stop())
+			break;
+		solo_irq_off(solo_dev, SOLO_IRQ_ENCODER);
+		solo_handle_ring(solo_dev);
+		solo_irq_on(solo_dev, SOLO_IRQ_ENCODER);
+		try_to_freeze();
 	}
 
-	return;
+	remove_wait_queue(&solo_dev->ring_thread_wait, &wait);
+
+	return 0;
 }
 
 static int solo_enc_buf_setup(struct videobuf_queue *vq, unsigned int *count,
@@ -915,17 +807,12 @@ static int solo_enc_buf_prepare(struct videobuf_queue *vq,
 				struct videobuf_buffer *vb,
 				enum v4l2_field field)
 {
-	struct solo_enc_fh *fh = vq->priv_data;
-	struct solo_enc_dev *solo_enc = fh->enc;
-
 	vb->size = FRAME_BUF_SIZE;
 	if (vb->baddr != 0 && vb->bsize < vb->size)
 		return -EINVAL;
 
-	/* These properties only change when queue is idle */
-	vb->width = solo_enc->width;
-	vb->height = solo_enc->height;
-	vb->field  = field;
+	/* This property only change when queue is idle */
+	vb->field = field;
 
 	if (vb->state == VIDEOBUF_NEEDS_INIT) {
 		int rc = videobuf_iolock(vq, vb, NULL);
@@ -933,7 +820,7 @@ static int solo_enc_buf_prepare(struct videobuf_queue *vq,
 			struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
 			videobuf_dma_unmap(vq->dev, dma);
 			videobuf_dma_free(dma);
-			vb->state = VIDEOBUF_NEEDS_INIT;
+
 			return rc;
 		}
 	}
@@ -949,20 +836,18 @@ static void solo_enc_buf_queue(struct videobuf_queue *vq,
 
 	vb->state = VIDEOBUF_QUEUED;
 	list_add_tail(&vb->queue, &fh->vidq_active);
-	wake_up_interruptible(&fh->enc->thread_wait);
 }
 
 static void solo_enc_buf_release(struct videobuf_queue *vq,
 				 struct videobuf_buffer *vb)
 {
 	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-
 	videobuf_dma_unmap(vq->dev, dma);
 	videobuf_dma_free(dma);
 	vb->state = VIDEOBUF_NEEDS_INIT;
 }
 
-static struct videobuf_queue_ops solo_enc_video_qops = {
+static const struct videobuf_queue_ops solo_enc_video_qops = {
 	.buf_setup	= solo_enc_buf_setup,
 	.buf_prepare	= solo_enc_buf_prepare,
 	.buf_queue	= solo_enc_buf_queue,
@@ -984,27 +869,78 @@ static int solo_enc_mmap(struct file *file, struct vm_area_struct *vma)
 	return videobuf_mmap_mapper(&fh->vidq, vma);
 }
 
+static int solo_ring_start(struct solo_dev *solo_dev)
+{
+	if (atomic_inc_return(&solo_dev->enc_users) > 1)
+		return 0;
+
+	solo_dev->ring_thread = kthread_run(solo_ring_thread, solo_dev,
+					    SOLO6X10_NAME "_ring");
+	if (IS_ERR(solo_dev->ring_thread)) {
+		int err = PTR_ERR(solo_dev->ring_thread);
+		solo_dev->ring_thread = NULL;
+		return err;
+	}
+
+	solo_irq_on(solo_dev, SOLO_IRQ_ENCODER);
+
+	return 0;
+}
+
+static void solo_ring_stop(struct solo_dev *solo_dev)
+{
+	if (atomic_dec_return(&solo_dev->enc_users) > 0)
+		return;
+
+	if (solo_dev->ring_thread) {
+		kthread_stop(solo_dev->ring_thread);
+		solo_dev->ring_thread = NULL;
+	}
+
+	solo_irq_off(solo_dev, SOLO_IRQ_ENCODER);
+}
+
 static int solo_enc_open(struct file *file)
 {
 	struct solo_enc_dev *solo_enc = video_drvdata(file);
+	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct solo_enc_fh *fh;
+	int ret;
+
+	ret = solo_ring_start(solo_dev);
+	if (ret)
+		return ret;
 
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (fh == NULL)
+	if (fh == NULL) {
+		solo_ring_stop(solo_dev);
+		return -ENOMEM;
+	}
+
+	fh->desc_nelts = 32;
+	fh->desc_items = pci_alloc_consistent(solo_dev->pdev,
+				      sizeof(struct solo_p2m_desc) *
+				      fh->desc_nelts, &fh->desc_dma);
+	if (fh->desc_items == NULL) {
+		kfree(fh);
+		solo_ring_stop(solo_dev);
 		return -ENOMEM;
+	}
 
 	fh->enc = solo_enc;
+	spin_lock_init(&fh->av_lock);
 	file->private_data = fh;
 	INIT_LIST_HEAD(&fh->vidq_active);
 	fh->fmt = V4L2_PIX_FMT_MPEG;
 	fh->type = SOLO_ENC_TYPE_STD;
 
 	videobuf_queue_sg_init(&fh->vidq, &solo_enc_video_qops,
-			       &solo_enc->solo_dev->pdev->dev,
-			       &solo_enc->lock,
-			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			       V4L2_FIELD_INTERLACED,
-			       sizeof(struct videobuf_buffer), fh, NULL);
+				&solo_dev->pdev->dev,
+				&fh->av_lock,
+				V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				V4L2_FIELD_INTERLACED,
+				sizeof(struct solo_videobuf),
+				fh, NULL);
 
 	return 0;
 }
@@ -1013,22 +949,12 @@ static ssize_t solo_enc_read(struct file *file, char __user *data,
 			     size_t count, loff_t *ppos)
 {
 	struct solo_enc_fh *fh = file->private_data;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	int ret;
 
 	/* Make sure the encoder is on */
-	if (!fh->enc_on) {
-		int ret;
-
-		spin_lock(&solo_enc->lock);
-		ret = solo_enc_on(fh);
-		spin_unlock(&solo_enc->lock);
-		if (ret)
-			return ret;
-
-		ret = solo_start_fh_thread(fh);
-		if (ret)
-			return ret;
-	}
+	ret = solo_enc_on(fh);
+	if (ret)
+		return ret;
 
 	return videobuf_read_stream(&fh->vidq, data, count, ppos, 0,
 				    file->f_flags & O_NONBLOCK);
@@ -1037,17 +963,21 @@ static ssize_t solo_enc_read(struct file *file, char __user *data,
 static int solo_enc_release(struct file *file)
 {
 	struct solo_enc_fh *fh = file->private_data;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_dev *solo_dev = fh->enc->solo_dev;
+
+	solo_enc_off(fh);
 
 	videobuf_stop(&fh->vidq);
 	videobuf_mmap_free(&fh->vidq);
 
-	spin_lock(&solo_enc->lock);
-	solo_enc_off(fh);
-	spin_unlock(&solo_enc->lock);
+	pci_free_consistent(fh->enc->solo_dev->pdev,
+			    sizeof(struct solo_p2m_desc) *
+			    fh->desc_nelts, fh->desc_items, fh->desc_dma);
 
 	kfree(fh);
 
+	solo_ring_stop(solo_dev);
+
 	return 0;
 }
 
@@ -1095,7 +1025,8 @@ static int solo_enc_enum_input(struct file *file, void *priv,
 	return 0;
 }
 
-static int solo_enc_set_input(struct file *file, void *priv, unsigned int index)
+static int solo_enc_set_input(struct file *file, void *priv,
+			      unsigned int index)
 {
 	if (index)
 		return -EINVAL;
@@ -1144,8 +1075,8 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 	    pix->pixelformat != V4L2_PIX_FMT_MJPEG)
 		return -EINVAL;
 
-	/* We cannot change width/height in mid read */
-	if (atomic_read(&solo_enc->readers) > 0) {
+	/* We cannot change width/height in mid mpeg */
+	if (atomic_read(&solo_enc->mpeg_readers) > 0) {
 		if (pix->width != solo_enc->width ||
 		    pix->height != solo_enc->height)
 			return -EBUSY;
@@ -1183,11 +1114,11 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
 
-	spin_lock(&solo_enc->lock);
+	mutex_lock(&solo_enc->enable_lock);
 
 	ret = solo_enc_try_fmt_cap(file, priv, f);
 	if (ret) {
-		spin_unlock(&solo_enc->lock);
+		mutex_unlock(&solo_enc->enable_lock);
 		return ret;
 	}
 
@@ -1201,14 +1132,10 @@ static int solo_enc_set_fmt_cap(struct file *file, void *priv,
 
 	if (pix->priv)
 		fh->type = SOLO_ENC_TYPE_EXT;
-	ret = solo_enc_on(fh);
-
-	spin_unlock(&solo_enc->lock);
 
-	if (ret)
-		return ret;
+	mutex_unlock(&solo_enc->enable_lock);
 
-	return solo_start_fh_thread(fh);
+	return 0;
 }
 
 static int solo_enc_get_fmt_cap(struct file *file, void *priv,
@@ -1245,7 +1172,8 @@ static int solo_enc_querybuf(struct file *file, void *priv,
 	return videobuf_querybuf(&fh->vidq, buf);
 }
 
-static int solo_enc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+static int solo_enc_qbuf(struct file *file, void *priv,
+			 struct v4l2_buffer *buf)
 {
 	struct solo_enc_fh *fh = priv;
 
@@ -1256,50 +1184,21 @@ static int solo_enc_dqbuf(struct file *file, void *priv,
 			  struct v4l2_buffer *buf)
 {
 	struct solo_enc_fh *fh = priv;
-	struct solo_enc_dev *solo_enc = fh->enc;
+	struct solo_videobuf *svb;
 	int ret;
 
 	/* Make sure the encoder is on */
-	if (!fh->enc_on) {
-		spin_lock(&solo_enc->lock);
-		ret = solo_enc_on(fh);
-		spin_unlock(&solo_enc->lock);
-		if (ret)
-			return ret;
-
-		ret = solo_start_fh_thread(fh);
-		if (ret)
-			return ret;
-	}
+	ret = solo_enc_on(fh);
+	if (ret)
+		return ret;
 
 	ret = videobuf_dqbuf(&fh->vidq, buf, file->f_flags & O_NONBLOCK);
 	if (ret)
 		return ret;
 
-	/* Signal motion detection */
-	if (solo_is_motion_on(solo_enc)) {
-		buf->flags |= V4L2_BUF_FLAG_MOTION_ON;
-		if (solo_enc->motion_detected) {
-			buf->flags |= V4L2_BUF_FLAG_MOTION_DETECTED;
-			solo_reg_write(solo_enc->solo_dev, SOLO_VI_MOT_CLEAR,
-				       1 << solo_enc->ch);
-			solo_enc->motion_detected = 0;
-		}
-	}
-
-	/* Check for key frame on mpeg data */
-	if (fh->fmt == V4L2_PIX_FMT_MPEG) {
-		struct videobuf_dmabuf *vbuf =
-				videobuf_to_dma(fh->vidq.bufs[buf->index]);
-
-		if (vbuf) {
-			u8 *p = sg_virt(vbuf->sglist);
-			if (p[3] == 0x00)
-				buf->flags |= V4L2_BUF_FLAG_KEYFRAME;
-			else
-				buf->flags |= V4L2_BUF_FLAG_PFRAME;
-		}
-	}
+	/* Copy over the flags */
+	svb = (struct solo_videobuf *)fh->vidq.bufs[buf->index];
+	buf->flags |= svb->flags;
 
 	return 0;
 }
@@ -1319,11 +1218,16 @@ static int solo_enc_streamoff(struct file *file, void *priv,
 			      enum v4l2_buf_type i)
 {
 	struct solo_enc_fh *fh = priv;
+	int ret;
 
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	return videobuf_streamoff(&fh->vidq);
+	ret = videobuf_streamoff(&fh->vidq);
+	if (!ret)
+		solo_enc_off(fh);
+
+	return ret;
 }
 
 static int solo_enc_s_std(struct file *file, void *priv, v4l2_std_id *i)
@@ -1407,10 +1311,10 @@ static int solo_s_parm(struct file *file, void *priv,
 	struct solo_dev *solo_dev = solo_enc->solo_dev;
 	struct v4l2_captureparm *cp = &sp->parm.capture;
 
-	spin_lock(&solo_enc->lock);
+	mutex_lock(&solo_enc->enable_lock);
 
-	if (atomic_read(&solo_enc->readers) > 0) {
-		spin_unlock(&solo_enc->lock);
+	if (atomic_read(&solo_enc->mpeg_readers) > 0) {
+		mutex_unlock(&solo_enc->enable_lock);
 		return -EBUSY;
 	}
 
@@ -1431,10 +1335,9 @@ static int solo_s_parm(struct file *file, void *priv,
 
 	cp->capability = V4L2_CAP_TIMEPERFRAME;
 
-	solo_enc->gop = max(solo_dev->fps / solo_enc->interval, 1);
 	solo_update_mode(solo_enc);
 
-	spin_unlock(&solo_enc->lock);
+	mutex_unlock(&solo_enc->enable_lock);
 
 	return 0;
 }
@@ -1510,6 +1413,7 @@ static int solo_querymenu(struct file *file, void *priv,
 	int err;
 
 	qctrl.id = qmenu->id;
+
 	err = solo_queryctrl(file, priv, &qctrl);
 	if (err)
 		return err;
@@ -1536,6 +1440,8 @@ static int solo_g_ctrl(struct file *file, void *priv,
 		ctrl->value = V4L2_MPEG_VIDEO_ENCODING_MPEG_4_AVC;
 		break;
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
+		if (atomic_read(&solo_enc->readers) > 0)
+			return -EBUSY;
 		ctrl->value = solo_enc->gop;
 		break;
 	case V4L2_CID_MOTION_THRESHOLD:
@@ -1574,19 +1480,32 @@ static int solo_s_ctrl(struct file *file, void *priv,
 		if (ctrl->value < 1 || ctrl->value > 255)
 			return -ERANGE;
 		solo_enc->gop = ctrl->value;
-		solo_reg_write(solo_dev, SOLO_VE_CH_GOP(solo_enc->ch),
-			       solo_enc->gop);
-		solo_reg_write(solo_dev, SOLO_VE_CH_GOP_E(solo_enc->ch),
-			       solo_enc->gop);
 		break;
 	case V4L2_CID_MOTION_THRESHOLD:
-		/* TODO accept value on lower 16-bits and use high
-		 * 16-bits to assign the value to a specific block */
-		if (ctrl->value < 0 || ctrl->value > 0xffff)
+	{
+		u16 block = (ctrl->value >> 16) & 0xffff;
+		u16 value = ctrl->value & 0xffff;
+
+		/* Motion thresholds are in a table of 64x64 samples, with
+		 * each sample representing 16x16 pixels of the source. In
+		 * effect, 44x30 samples are used for NTSC, and 44x36 for PAL.
+		 * The 5th sample on the 10th row is (10*64)+5 = 645.
+		 *
+		 * Block is 0 to set the threshold globally, or any positive
+		 * number under 2049 to set block-1 individually. */
+		if (block > 2049)
 			return -ERANGE;
-		solo_enc->motion_thresh = ctrl->value;
-		solo_set_motion_threshold(solo_dev, solo_enc->ch, ctrl->value);
+
+		if (block == 0) {
+			solo_enc->motion_thresh = value;
+			return solo_set_motion_threshold(solo_dev,
+							 solo_enc->ch, value);
+		} else {
+			return solo_set_motion_block(solo_dev, solo_enc->ch,
+						     value, block - 1);
+		}
 		break;
+	}
 	case V4L2_CID_MOTION_ENABLE:
 		solo_motion_toggle(solo_enc, ctrl->value);
 		break;
@@ -1613,6 +1532,7 @@ static int solo_s_ext_ctrls(struct file *file, void *priv,
 			if (ctrl->size - 1 > OSD_TEXT_MAX)
 				err = -ERANGE;
 			else {
+				mutex_lock(&solo_enc->enable_lock);
 				err = copy_from_user(solo_enc->osd_text,
 						     ctrl->string,
 						     OSD_TEXT_MAX);
@@ -1621,6 +1541,7 @@ static int solo_s_ext_ctrls(struct file *file, void *priv,
 					err = solo_osd_print(solo_enc);
 				else
 					err = -EFAULT;
+				mutex_unlock(&solo_enc->enable_lock);
 			}
 			break;
 		default:
@@ -1653,11 +1574,13 @@ static int solo_g_ext_ctrls(struct file *file, void *priv,
 				ctrl->size = OSD_TEXT_MAX;
 				err = -ENOSPC;
 			} else {
+				mutex_lock(&solo_enc->enable_lock);
 				err = copy_to_user(ctrl->string,
 						   solo_enc->osd_text,
 						   OSD_TEXT_MAX);
 				if (err)
 					err = -EFAULT;
+				mutex_unlock(&solo_enc->enable_lock);
 			}
 			break;
 		default:
@@ -1717,7 +1640,7 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	.vidioc_s_ext_ctrls		= solo_s_ext_ctrls,
 };
 
-static struct video_device solo_enc_template = {
+static const struct video_device solo_enc_template = {
 	.name			= SOLO6X10_NAME,
 	.fops			= &solo_enc_fops,
 	.ioctl_ops		= &solo_enc_ioctl_ops,
@@ -1728,7 +1651,8 @@ static struct video_device solo_enc_template = {
 	.current_norm		= V4L2_STD_NTSC_M,
 };
 
-static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
+static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
+					   u8 ch, unsigned nr)
 {
 	struct solo_enc_dev *solo_enc;
 	int ret;
@@ -1748,8 +1672,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 
 	*solo_enc->vfd = solo_enc_template;
 	solo_enc->vfd->parent = &solo_dev->pdev->dev;
-	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER,
-				    video_nr);
+	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER, nr);
 	if (ret < 0) {
 		video_device_release(solo_enc->vfd);
 		kfree(solo_enc);
@@ -1762,12 +1685,12 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 		 "%s-enc (%i/%i)", SOLO6X10_NAME, solo_dev->vfd->num,
 		 solo_enc->vfd->num);
 
-	if (video_nr != -1)
-		video_nr++;
+	INIT_LIST_HEAD(&solo_enc->listeners);
+	mutex_init(&solo_enc->enable_lock);
+	spin_lock_init(&solo_enc->motion_lock);
 
-	spin_lock_init(&solo_enc->lock);
-	init_waitqueue_head(&solo_enc->thread_wait);
 	atomic_set(&solo_enc->readers, 0);
+	atomic_set(&solo_enc->mpeg_readers, 0);
 
 	solo_enc->qp = SOLO_DEFAULT_QP;
 	solo_enc->gop = solo_dev->fps;
@@ -1775,9 +1698,13 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	solo_enc->mode = SOLO_ENC_MODE_CIF;
 	solo_enc->motion_thresh = SOLO_DEF_MOT_THRESH;
 
-	spin_lock(&solo_enc->lock);
+	mutex_lock(&solo_enc->enable_lock);
 	solo_update_mode(solo_enc);
-	spin_unlock(&solo_enc->lock);
+	mutex_unlock(&solo_enc->enable_lock);
+
+	/* Initialize this per encoder */
+	solo_enc->jpeg_len = sizeof(jpeg_header);
+	memcpy(solo_enc->jpeg_header, jpeg_header, solo_enc->jpeg_len);
 
 	return solo_enc;
 }
@@ -1791,12 +1718,22 @@ static void solo_enc_free(struct solo_enc_dev *solo_enc)
 	kfree(solo_enc);
 }
 
-int solo_enc_v4l2_init(struct solo_dev *solo_dev)
+int solo_enc_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 {
 	int i;
 
+	atomic_set(&solo_dev->enc_users, 0);
+	init_waitqueue_head(&solo_dev->ring_thread_wait);
+
+	solo_dev->vh_size = sizeof(struct vop_header);
+	solo_dev->vh_buf = pci_alloc_consistent(solo_dev->pdev,
+						solo_dev->vh_size,
+						&solo_dev->vh_dma);
+	if (solo_dev->vh_buf == NULL)
+		return -ENOMEM;
+
 	for (i = 0; i < solo_dev->nr_chans; i++) {
-		solo_dev->v4l2_enc[i] = solo_enc_alloc(solo_dev, i);
+		solo_dev->v4l2_enc[i] = solo_enc_alloc(solo_dev, i, nr);
 		if (IS_ERR(solo_dev->v4l2_enc[i]))
 			break;
 	}
@@ -1805,11 +1742,15 @@ int solo_enc_v4l2_init(struct solo_dev *solo_dev)
 		int ret = PTR_ERR(solo_dev->v4l2_enc[i]);
 		while (i--)
 			solo_enc_free(solo_dev->v4l2_enc[i]);
+		pci_free_consistent(solo_dev->pdev, solo_dev->vh_size,
+				    solo_dev->vh_buf, solo_dev->vh_dma);
 		return ret;
 	}
 
-	/* D1@MAX-FPS * 4 */
-	solo_dev->enc_bw_remain = solo_dev->fps * 4 * 4;
+	if (solo_dev->type == SOLO_DEV_6010)
+		solo_dev->enc_bw_remain = solo_dev->fps * 4 * 4;
+	else
+		solo_dev->enc_bw_remain = solo_dev->fps * 4 * 5;
 
 	dev_info(&solo_dev->pdev->dev, "Encoders as /dev/video%d-%d\n",
 		 solo_dev->v4l2_enc[0]->vfd->num,
@@ -1822,8 +1763,9 @@ void solo_enc_v4l2_exit(struct solo_dev *solo_dev)
 {
 	int i;
 
-	solo_irq_off(solo_dev, SOLO_IRQ_MOTION);
-
 	for (i = 0; i < solo_dev->nr_chans; i++)
 		solo_enc_free(solo_dev->v4l2_enc[i]);
+
+	pci_free_consistent(solo_dev->pdev, solo_dev->vh_size,
+			    solo_dev->vh_buf, solo_dev->vh_dma);
 }
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index ca774cc..f8ec2a3 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -1,6 +1,11 @@
 /*
- * Copyright (C) 2010 Bluecherry, LLC www.bluecherrydvr.com
- * Copyright (C) 2010 Ben Collins <bcollins@bluecherry.net>
+ * Copyright (C) 2010-2013 Bluecherry, LLC <http://www.bluecherrydvr.com>
+ *
+ * Original author:
+ * Ben Collins <bcollins@ubuntu.com>
+ *
+ * Additional work by:
+ * John Brooks <john.brooks@bluecherry.net>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -21,47 +26,43 @@
 #include <linux/module.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
-#include <media/videobuf-dma-sg.h>
+#include <media/videobuf-dma-contig.h>
+
 #include "solo6x10.h"
 #include "tw28.h"
 
-#define SOLO_HW_BPL		2048
 #define SOLO_DISP_PIX_FIELD	V4L2_FIELD_INTERLACED
 
-/* Image size is two fields, SOLO_HW_BPL is one horizontal line */
+/* Image size is two fields, SOLO_HW_BPL is one horizontal line in hardware */
+#define SOLO_HW_BPL		2048
 #define solo_vlines(__solo)	(__solo->video_vsize * 2)
 #define solo_image_size(__solo) (solo_bytesperline(__solo) * \
 				 solo_vlines(__solo))
 #define solo_bytesperline(__solo) (__solo->video_hsize * 2)
 
-#define MIN_VID_BUFFERS		4
+#define MIN_VID_BUFFERS		2
 
 /* Simple file handle */
 struct solo_filehandle {
-	struct solo_dev		*solo_dev;
+	struct solo_dev	*solo_dev;
 	struct videobuf_queue	vidq;
 	struct task_struct      *kthread;
 	spinlock_t		slock;
 	int			old_write;
 	struct list_head	vidq_active;
-	struct p2m_desc		desc[SOLO_NR_P2M_DESC];
-	int			desc_idx;
 };
 
-unsigned video_nr = -1;
-module_param(video_nr, uint, 0644);
-MODULE_PARM_DESC(video_nr, "videoX start number, -1 is autodetect (default)");
-
-static void erase_on(struct solo_dev *solo_dev)
+static inline void erase_on(struct solo_dev *solo_dev)
 {
 	solo_reg_write(solo_dev, SOLO_VO_DISP_ERASE, SOLO_VO_DISP_ERASE_ON);
 	solo_dev->erasing = 1;
 	solo_dev->frame_blank = 0;
 }
 
-static int erase_off(struct solo_dev *solo_dev)
+static inline int erase_off(struct solo_dev *solo_dev)
 {
 	if (!solo_dev->erasing)
 		return 0;
@@ -78,8 +79,7 @@ static int erase_off(struct solo_dev *solo_dev)
 
 void solo_video_in_isr(struct solo_dev *solo_dev)
 {
-	solo_reg_write(solo_dev, SOLO_IRQ_STAT, SOLO_IRQ_VIDEO_IN);
-	wake_up_interruptible(&solo_dev->disp_thread_wait);
+	wake_up_interruptible_all(&solo_dev->disp_thread_wait);
 }
 
 static void solo_win_setup(struct solo_dev *solo_dev, u8 ch,
@@ -202,165 +202,61 @@ static int solo_v4l2_set_ch(struct solo_dev *solo_dev, u8 ch)
 	return 0;
 }
 
-static void disp_reset_desc(struct solo_filehandle *fh)
-{
-	/* We use desc mode, which ignores desc 0 */
-	memset(fh->desc, 0, sizeof(*fh->desc));
-	fh->desc_idx = 1;
-}
-
-static int disp_flush_descs(struct solo_filehandle *fh)
-{
-	int ret;
-
-	if (!fh->desc_idx)
-		return 0;
-
-	ret = solo_p2m_dma_desc(fh->solo_dev, SOLO_P2M_DMA_ID_DISP,
-				fh->desc, fh->desc_idx);
-	disp_reset_desc(fh);
-
-	return ret;
-}
-
-static int disp_push_desc(struct solo_filehandle *fh, dma_addr_t dma_addr,
-		      u32 ext_addr, int size, int repeat, int ext_size)
-{
-	if (fh->desc_idx >= SOLO_NR_P2M_DESC) {
-		int ret = disp_flush_descs(fh);
-		if (ret)
-			return ret;
-	}
-
-	solo_p2m_push_desc(&fh->desc[fh->desc_idx], 0, dma_addr, ext_addr,
-			   size, repeat, ext_size);
-	fh->desc_idx++;
-
-	return 0;
-}
-
 static void solo_fillbuf(struct solo_filehandle *fh,
 			 struct videobuf_buffer *vb)
 {
 	struct solo_dev *solo_dev = fh->solo_dev;
-	struct videobuf_dmabuf *vbuf;
+	dma_addr_t vbuf;
 	unsigned int fdma_addr;
-	int error = 1;
+	int error = -1;
 	int i;
-	struct scatterlist *sg;
-	dma_addr_t sg_dma;
-	int sg_size_left;
 
-	vbuf = videobuf_to_dma(vb);
+	vbuf = videobuf_to_dma_contig(vb);
 	if (!vbuf)
 		goto finish_buf;
 
 	if (erase_off(solo_dev)) {
-		int i;
-
-		/* Just blit to the entire sg list, ignoring size */
-		for_each_sg(vbuf->sglist, sg, vbuf->sglen, i) {
-			void *p = sg_virt(sg);
-			size_t len = sg_dma_len(sg);
-
-			for (i = 0; i < len; i += 2) {
-				((u8 *)p)[i] = 0x80;
-				((u8 *)p)[i + 1] = 0x00;
-			}
+		void *p = videobuf_queue_to_vaddr(&fh->vidq, vb);
+		int image_size = solo_image_size(solo_dev);
+		for (i = 0; i < image_size; i += 2) {
+			((u8 *)p)[i] = 0x80;
+			((u8 *)p)[i + 1] = 0x00;
 		}
-
 		error = 0;
-		goto finish_buf;
-	}
-
-	disp_reset_desc(fh);
-	sg = vbuf->sglist;
-	sg_dma = sg_dma_address(sg);
-	sg_size_left = sg_dma_len(sg);
-
-	fdma_addr = SOLO_DISP_EXT_ADDR + (fh->old_write *
-			(SOLO_HW_BPL * solo_vlines(solo_dev)));
-
-	for (i = 0; i < solo_vlines(solo_dev); i++) {
-		int line_len = solo_bytesperline(solo_dev);
-		int lines;
-
-		if (!sg_size_left) {
-			sg = sg_next(sg);
-			if (sg == NULL)
-				goto finish_buf;
-			sg_dma = sg_dma_address(sg);
-			sg_size_left = sg_dma_len(sg);
-		}
-
-		/* No room for an entire line, so chunk it up */
-		if (sg_size_left < line_len) {
-			int this_addr = fdma_addr;
-
-			while (line_len > 0) {
-				int this_write;
-
-				if (!sg_size_left) {
-					sg = sg_next(sg);
-					if (sg == NULL)
-						goto finish_buf;
-					sg_dma = sg_dma_address(sg);
-					sg_size_left = sg_dma_len(sg);
-				}
-
-				this_write = min(sg_size_left, line_len);
-
-				if (disp_push_desc(fh, sg_dma, this_addr,
-						   this_write, 0, 0))
-					goto finish_buf;
-
-				line_len -= this_write;
-				sg_size_left -= this_write;
-				sg_dma += this_write;
-				this_addr += this_write;
-			}
-
-			fdma_addr += SOLO_HW_BPL;
-			continue;
-		}
-
-		/* Shove as many lines into a repeating descriptor as possible */
-		lines = min(sg_size_left / line_len,
-			    solo_vlines(solo_dev) - i);
-
-		if (disp_push_desc(fh, sg_dma, fdma_addr, line_len,
-				   lines - 1, SOLO_HW_BPL))
-			goto finish_buf;
+	} else {
+		fdma_addr = SOLO_DISP_EXT_ADDR + (fh->old_write *
+				(SOLO_HW_BPL * solo_vlines(solo_dev)));
 
-		i += lines - 1;
-		fdma_addr += SOLO_HW_BPL * lines;
-		sg_dma += lines * line_len;
-		sg_size_left -= lines * line_len;
+		error = solo_p2m_dma_t(solo_dev, 0, vbuf, fdma_addr,
+				       solo_bytesperline(solo_dev),
+				       solo_vlines(solo_dev), SOLO_HW_BPL);
 	}
 
-	error = disp_flush_descs(fh);
-
 finish_buf:
 	if (error) {
 		vb->state = VIDEOBUF_ERROR;
 	} else {
-		vb->size = solo_vlines(solo_dev) * solo_bytesperline(solo_dev);
 		vb->state = VIDEOBUF_DONE;
 		vb->field_count++;
-		do_gettimeofday(&vb->ts);
 	}
 
 	wake_up(&vb->done);
-
-	return;
 }
 
 static void solo_thread_try(struct solo_filehandle *fh)
 {
 	struct videobuf_buffer *vb;
-	unsigned int cur_write;
 
+	/* Only "break" from this loop if slock is held, otherwise
+	 * just return. */
 	for (;;) {
+		unsigned int cur_write;
+
+		cur_write = SOLO_VI_STATUS0_PAGE(
+			solo_reg_read(fh->solo_dev, SOLO_VI_STATUS0));
+		if (cur_write == fh->old_write)
+			return;
+
 		spin_lock(&fh->slock);
 
 		if (list_empty(&fh->vidq_active))
@@ -372,13 +268,9 @@ static void solo_thread_try(struct solo_filehandle *fh)
 		if (!waitqueue_active(&vb->done))
 			break;
 
-		cur_write = SOLO_VI_STATUS0_PAGE(solo_reg_read(fh->solo_dev,
-						 SOLO_VI_STATUS0));
-		if (cur_write == fh->old_write)
-			break;
-
 		fh->old_write = cur_write;
 		list_del(&vb->queue);
+		vb->state = VIDEOBUF_ACTIVE;
 
 		spin_unlock(&fh->slock);
 
@@ -413,17 +305,31 @@ static int solo_thread(void *data)
 
 static int solo_start_thread(struct solo_filehandle *fh)
 {
+	int ret = 0;
+
+	if (atomic_inc_return(&fh->solo_dev->disp_users) == 1)
+		solo_irq_on(fh->solo_dev, SOLO_IRQ_VIDEO_IN);
+
 	fh->kthread = kthread_run(solo_thread, fh, SOLO6X10_NAME "_disp");
 
-	return PTR_RET(fh->kthread);
+	if (IS_ERR(fh->kthread)) {
+		ret = PTR_ERR(fh->kthread);
+		fh->kthread = NULL;
+	}
+
+	return ret;
 }
 
 static void solo_stop_thread(struct solo_filehandle *fh)
 {
-	if (fh->kthread) {
-		kthread_stop(fh->kthread);
-		fh->kthread = NULL;
-	}
+	if (!fh->kthread)
+		return;
+
+	kthread_stop(fh->kthread);
+	fh->kthread = NULL;
+
+	if (atomic_dec_return(&fh->solo_dev->disp_users) == 0)
+		solo_irq_off(fh->solo_dev, SOLO_IRQ_VIDEO_IN);
 }
 
 static int solo_buf_setup(struct videobuf_queue *vq, unsigned int *count,
@@ -459,9 +365,7 @@ static int solo_buf_prepare(struct videobuf_queue *vq,
 	if (vb->state == VIDEOBUF_NEEDS_INIT) {
 		int rc = videobuf_iolock(vq, vb, NULL);
 		if (rc < 0) {
-			struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-			videobuf_dma_unmap(vq->dev, dma);
-			videobuf_dma_free(dma);
+			videobuf_dma_contig_free(vq, vb);
 			vb->state = VIDEOBUF_NEEDS_INIT;
 			return rc;
 		}
@@ -485,14 +389,11 @@ static void solo_buf_queue(struct videobuf_queue *vq,
 static void solo_buf_release(struct videobuf_queue *vq,
 			     struct videobuf_buffer *vb)
 {
-	struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
-
-	videobuf_dma_unmap(vq->dev, dma);
-	videobuf_dma_free(dma);
+	videobuf_dma_contig_free(vq, vb);
 	vb->state = VIDEOBUF_NEEDS_INIT;
 }
 
-static struct videobuf_queue_ops solo_video_qops = {
+static const struct videobuf_queue_ops solo_video_qops = {
 	.buf_setup	= solo_buf_setup,
 	.buf_prepare	= solo_buf_prepare,
 	.buf_queue	= solo_buf_queue,
@@ -535,12 +436,12 @@ static int solo_v4l2_open(struct file *file)
 		return ret;
 	}
 
-	videobuf_queue_sg_init(&fh->vidq, &solo_video_qops,
-			       &solo_dev->pdev->dev, &fh->slock,
-			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			       SOLO_DISP_PIX_FIELD,
-			       sizeof(struct videobuf_buffer), fh, NULL);
-
+	videobuf_queue_dma_contig_init(&fh->vidq, &solo_video_qops,
+				       &solo_dev->pdev->dev, &fh->slock,
+				       V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				       SOLO_DISP_PIX_FIELD,
+				       sizeof(struct videobuf_buffer),
+				       fh, NULL);
 	return 0;
 }
 
@@ -557,9 +458,11 @@ static int solo_v4l2_release(struct file *file)
 {
 	struct solo_filehandle *fh = file->private_data;
 
+	solo_stop_thread(fh);
+
 	videobuf_stop(&fh->vidq);
 	videobuf_mmap_free(&fh->vidq);
-	solo_stop_thread(fh);
+
 	kfree(fh);
 
 	return 0;
@@ -585,12 +488,12 @@ static int solo_querycap(struct file *file, void  *priv,
 static int solo_enum_ext_input(struct solo_dev *solo_dev,
 			       struct v4l2_input *input)
 {
-	static const char *dispnames_1[] = { "4UP" };
-	static const char *dispnames_2[] = { "4UP-1", "4UP-2" };
-	static const char *dispnames_5[] = {
+	static const char * const dispnames_1[] = { "4UP" };
+	static const char * const dispnames_2[] = { "4UP-1", "4UP-2" };
+	static const char * const dispnames_5[] = {
 		"4UP-1", "4UP-2", "4UP-3", "4UP-4", "16UP"
 	};
-	const char **dispnames;
+	const char * const *dispnames;
 
 	if (input->index >= (solo_dev->nr_chans + solo_dev->nr_ext))
 		return -EINVAL;
@@ -640,8 +543,14 @@ static int solo_enum_input(struct file *file, void *priv,
 static int solo_set_input(struct file *file, void *priv, unsigned int index)
 {
 	struct solo_filehandle *fh = priv;
+	int ret = solo_v4l2_set_ch(fh->solo_dev, index);
+
+	if (!ret) {
+		while (erase_off(fh->solo_dev))
+			/* Do nothing */;
+	}
 
-	return solo_v4l2_set_ch(fh->solo_dev, index);
+	return ret;
 }
 
 static int solo_get_input(struct file *file, void *priv, unsigned int *index)
@@ -732,7 +641,8 @@ static int solo_reqbufs(struct file *file, void *priv,
 	return videobuf_reqbufs(&fh->vidq, req);
 }
 
-static int solo_querybuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+static int solo_querybuf(struct file *file, void *priv,
+			 struct v4l2_buffer *buf)
 {
 	struct solo_filehandle *fh = priv;
 
@@ -901,11 +811,12 @@ static struct video_device solo_v4l2_template = {
 	.current_norm		= V4L2_STD_NTSC_M,
 };
 
-int solo_v4l2_init(struct solo_dev *solo_dev)
+int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 {
 	int ret;
 	int i;
 
+	atomic_set(&solo_dev->disp_users, 0);
 	init_waitqueue_head(&solo_dev->disp_thread_wait);
 
 	solo_dev->vfd = video_device_alloc();
@@ -915,7 +826,7 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 	*solo_dev->vfd = solo_v4l2_template;
 	solo_dev->vfd->parent = &solo_dev->pdev->dev;
 
-	ret = video_register_device(solo_dev->vfd, VFL_TYPE_GRABBER, video_nr);
+	ret = video_register_device(solo_dev->vfd, VFL_TYPE_GRABBER, nr);
 	if (ret < 0) {
 		video_device_release(solo_dev->vfd);
 		solo_dev->vfd = NULL;
@@ -927,35 +838,30 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 	snprintf(solo_dev->vfd->name, sizeof(solo_dev->vfd->name), "%s (%i)",
 		 SOLO6X10_NAME, solo_dev->vfd->num);
 
-	if (video_nr != -1)
-		video_nr++;
-
-	dev_info(&solo_dev->pdev->dev, "Display as /dev/video%d with "
-		 "%d inputs (%d extended)\n", solo_dev->vfd->num,
-		 solo_dev->nr_chans, solo_dev->nr_ext);
+	dev_info(&solo_dev->pdev->dev,
+		 "Display as /dev/video%d with %d inputs (%d extended)\n",
+		 solo_dev->vfd->num, solo_dev->nr_chans, solo_dev->nr_ext);
 
 	/* Cycle all the channels and clear */
 	for (i = 0; i < solo_dev->nr_chans; i++) {
 		solo_v4l2_set_ch(solo_dev, i);
 		while (erase_off(solo_dev))
-			;/* Do nothing */
+			/* Do nothing */;
 	}
 
 	/* Set the default display channel */
 	solo_v4l2_set_ch(solo_dev, 0);
 	while (erase_off(solo_dev))
-		;/* Do nothing */
-
-	solo_irq_on(solo_dev, SOLO_IRQ_VIDEO_IN);
+		/* Do nothing */;
 
 	return 0;
 }
 
 void solo_v4l2_exit(struct solo_dev *solo_dev)
 {
-	solo_irq_off(solo_dev, SOLO_IRQ_VIDEO_IN);
-	if (solo_dev->vfd) {
-		video_unregister_device(solo_dev->vfd);
-		solo_dev->vfd = NULL;
-	}
+	if (solo_dev->vfd == NULL)
+		return;
+
+	video_unregister_device(solo_dev->vfd);
+	solo_dev->vfd = NULL;
 }
-- 
1.7.10.4

