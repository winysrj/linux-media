Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41036 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751187AbdBCP0h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Feb 2017 10:26:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/2] rainshadow-cec: new RainShadow Tech HDMI CEC driver
Date: Fri,  3 Feb 2017 16:26:33 +0100
Message-Id: <20170203152633.33323-3-hverkuil@xs4all.nl>
In-Reply-To: <20170203152633.33323-1-hverkuil@xs4all.nl>
References: <20170203152633.33323-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver supports the RainShadow Tech USB HDMI CEC adapter.

See: http://rainshadowtech.com/HdmiCecUsb.html

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS                                       |   7 +
 drivers/media/usb/Kconfig                         |   1 +
 drivers/media/usb/Makefile                        |   1 +
 drivers/media/usb/rainshadow-cec/Kconfig          |  10 +
 drivers/media/usb/rainshadow-cec/Makefile         |   1 +
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 388 ++++++++++++++++++++++
 6 files changed, 408 insertions(+)
 create mode 100644 drivers/media/usb/rainshadow-cec/Kconfig
 create mode 100644 drivers/media/usb/rainshadow-cec/Makefile
 create mode 100644 drivers/media/usb/rainshadow-cec/rainshadow-cec.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 421adff..4e479eb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10257,6 +10257,13 @@ L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/fbdev/aty/aty128fb.c
 
+RAINSHADOW-CEC DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/usb/rainshadow-cec/*
+
 RALINK MIPS ARCHITECTURE
 M:	John Crispin <john@phrozen.org>
 L:	linux-mips@linux-mips.org
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index c9644b6..b24e753 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -63,6 +63,7 @@ endif
 if MEDIA_CEC_SUPPORT
 	comment "USB HDMI CEC adapters"
 source "drivers/media/usb/pulse8-cec/Kconfig"
+source "drivers/media/usb/rainshadow-cec/Kconfig"
 endif
 
 endif #MEDIA_USB_SUPPORT
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 0f15e33..738b993 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -25,3 +25,4 @@ obj-$(CONFIG_VIDEO_USBTV) += usbtv/
 obj-$(CONFIG_VIDEO_GO7007) += go7007/
 obj-$(CONFIG_DVB_AS102) += as102/
 obj-$(CONFIG_USB_PULSE8_CEC) += pulse8-cec/
+obj-$(CONFIG_USB_RAINSHADOW_CEC) += rainshadow-cec/
diff --git a/drivers/media/usb/rainshadow-cec/Kconfig b/drivers/media/usb/rainshadow-cec/Kconfig
new file mode 100644
index 0000000..447291b
--- /dev/null
+++ b/drivers/media/usb/rainshadow-cec/Kconfig
@@ -0,0 +1,10 @@
+config USB_RAINSHADOW_CEC
+	tristate "RainShadow Tech HDMI CEC"
+	depends on USB_ACM && MEDIA_CEC_SUPPORT
+	select SERIO
+	select SERIO_SERPORT
+	---help---
+	  This is a cec driver for the RainShadow Tech HDMI CEC device.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rainshadow-cec.
diff --git a/drivers/media/usb/rainshadow-cec/Makefile b/drivers/media/usb/rainshadow-cec/Makefile
new file mode 100644
index 0000000..a79fbc7
--- /dev/null
+++ b/drivers/media/usb/rainshadow-cec/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_USB_RAINSHADOW_CEC) += rainshadow-cec.o
diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
new file mode 100644
index 0000000..f7fc86f
--- /dev/null
+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
@@ -0,0 +1,388 @@
+/*
+ * RainShadow Tech HDMI CEC driver
+ *
+ * Copyright 2016 Hans Verkuil <hverkuil@xs4all.nl
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version of 2 of the License, or (at your
+ * option) any later version. See the file COPYING in the main directory of
+ * this archive for more details.
+ */
+
+/*
+ * Notes:
+ *
+ * The higher level protocols are currently disabled. This can be added
+ * later, similar to how this is done for the Pulse Eight CEC driver.
+ *
+ * Documentation of the protocol is available here:
+ *
+ * http://rainshadowtech.com/doc/HDMICECtoUSBandRS232v2.0.pdf
+ */
+
+#include <linux/completion.h>
+#include <linux/ctype.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/serio.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/time.h>
+#include <linux/workqueue.h>
+
+#include <media/cec.h>
+
+MODULE_AUTHOR("Hans Verkuil <hverkuil@xs4all.nl>");
+MODULE_DESCRIPTION("RainShadow Tech HDMI CEC driver");
+MODULE_LICENSE("GPL");
+
+#define DATA_SIZE 256
+
+struct rain {
+	struct device *dev;
+	struct serio *serio;
+	struct cec_adapter *adap;
+	struct completion cmd_done;
+	struct work_struct work;
+
+	/* Low-level ringbuffer, collecting incoming characters */
+	char buf[DATA_SIZE];
+	unsigned int buf_rd_idx;
+	unsigned int buf_wr_idx;
+	unsigned int buf_len;
+	spinlock_t buf_lock;
+
+	/* command buffer */
+	char cmd[DATA_SIZE];
+	unsigned int cmd_idx;
+	bool cmd_started;
+
+	/* reply to a command, only used to store the firmware version */
+	char cmd_reply[DATA_SIZE];
+
+	struct mutex write_lock;
+};
+
+static void rain_process_msg(struct rain *rain)
+{
+	struct cec_msg msg = {};
+	const char *cmd = rain->cmd + 3;
+	int stat = -1;
+
+	for (; *cmd; cmd++) {
+		if (!isxdigit(*cmd))
+			continue;
+		if (isxdigit(cmd[0]) && isxdigit(cmd[1])) {
+			if (msg.len == CEC_MAX_MSG_SIZE)
+				break;
+			if (hex2bin(msg.msg + msg.len, cmd, 1))
+				continue;
+			msg.len++;
+			cmd++;
+			continue;
+		}
+		if (!cmd[1])
+			stat = hex_to_bin(cmd[0]);
+		break;
+	}
+
+	if (rain->cmd[0] == 'R') {
+		if (stat == 1 || stat == 2)
+			cec_received_msg(rain->adap, &msg);
+		return;
+	}
+
+	switch (stat) {
+	case 1:
+		cec_transmit_done(rain->adap, CEC_TX_STATUS_OK,
+				  0, 0, 0, 0);
+		break;
+	case 2:
+		cec_transmit_done(rain->adap, CEC_TX_STATUS_NACK,
+				  0, 1, 0, 0);
+		break;
+	default:
+		cec_transmit_done(rain->adap, CEC_TX_STATUS_LOW_DRIVE,
+				  0, 0, 0, 1);
+		break;
+	}
+}
+
+static void rain_irq_work_handler(struct work_struct *work)
+{
+	struct rain *rain =
+		container_of(work, struct rain, work);
+
+	while (true) {
+		unsigned long flags;
+		bool exit_loop;
+		char data;
+
+		spin_lock_irqsave(&rain->buf_lock, flags);
+		exit_loop = rain->buf_len == 0;
+		if (rain->buf_len) {
+			data = rain->buf[rain->buf_rd_idx];
+			rain->buf_len--;
+			rain->buf_rd_idx = (rain->buf_rd_idx + 1) & 0xff;
+		}
+		spin_unlock_irqrestore(&rain->buf_lock, flags);
+
+		if (exit_loop)
+			break;
+
+		if (!rain->cmd_started && data != '?')
+			continue;
+
+		switch (data) {
+		case '\r':
+			rain->cmd[rain->cmd_idx] = '\0';
+			dev_dbg(rain->dev, "received: %s\n", rain->cmd);
+			if (!memcmp(rain->cmd, "REC", 3) ||
+			    !memcmp(rain->cmd, "STA", 3)) {
+				rain_process_msg(rain);
+			} else {
+				strcpy(rain->cmd_reply, rain->cmd);
+				complete(&rain->cmd_done);
+			}
+			rain->cmd_idx = 0;
+			rain->cmd_started = false;
+			break;
+
+		case '\n':
+			rain->cmd_idx = 0;
+			rain->cmd_started = false;
+			break;
+
+		case '?':
+			rain->cmd_idx = 0;
+			rain->cmd_started = true;
+			break;
+
+		default:
+			if (rain->cmd_idx >= DATA_SIZE - 1) {
+				dev_dbg(rain->dev,
+					"throwing away %d bytes of garbage\n", rain->cmd_idx);
+				rain->cmd_idx = 0;
+			}
+			rain->cmd[rain->cmd_idx++] = data;
+			break;
+		}
+	}
+}
+
+static irqreturn_t rain_interrupt(struct serio *serio, unsigned char data,
+				    unsigned int flags)
+{
+	struct rain *rain = serio_get_drvdata(serio);
+
+	if (rain->buf_len == DATA_SIZE) {
+		dev_warn_once(rain->dev, "buffer overflow\n");
+		return IRQ_HANDLED;
+	}
+	spin_lock(&rain->buf_lock);
+	rain->buf_len++;
+	rain->buf[rain->buf_wr_idx] = data;
+	rain->buf_wr_idx = (rain->buf_wr_idx + 1) & 0xff;
+	spin_unlock(&rain->buf_lock);
+	schedule_work(&rain->work);
+	return IRQ_HANDLED;
+}
+
+static void rain_disconnect(struct serio *serio)
+{
+	struct rain *rain = serio_get_drvdata(serio);
+
+	cancel_work_sync(&rain->work);
+	cec_unregister_adapter(rain->adap);
+	dev_info(&serio->dev, "disconnected\n");
+	serio_close(serio);
+	serio_set_drvdata(serio, NULL);
+	kfree(rain);
+}
+
+static int rain_send(struct rain *rain, const char *command)
+{
+	int err = serio_write(rain->serio, '!');
+
+	dev_dbg(rain->dev, "send: %s\n", command);
+	while (!err && *command)
+		err = serio_write(rain->serio, *command++);
+	if (!err)
+		err = serio_write(rain->serio, '~');
+
+	return err;
+}
+
+static int rain_send_and_wait(struct rain *rain,
+			      const char *cmd, const char *reply)
+{
+	int err;
+
+	init_completion(&rain->cmd_done);
+
+	mutex_lock(&rain->write_lock);
+	err = rain_send(rain, cmd);
+	if (err)
+		goto err;
+
+	if (!wait_for_completion_timeout(&rain->cmd_done, HZ)) {
+		err = -ETIMEDOUT;
+		goto err;
+	}
+	if (reply && strncmp(rain->cmd_reply, reply, strlen(reply))) {
+		dev_dbg(rain->dev,
+			 "transmit of '%s': received '%s' instead of '%s'\n",
+			 cmd, rain->cmd_reply, reply);
+		err = -EIO;
+	}
+err:
+	mutex_unlock(&rain->write_lock);
+	return err;
+}
+
+static int rain_setup(struct rain *rain, struct serio *serio,
+			struct cec_log_addrs *log_addrs, u16 *pa)
+{
+	int err;
+
+	err = rain_send_and_wait(rain, "R", "REV");
+	if (err)
+		return err;
+	dev_info(rain->dev, "Firmware version %s\n", rain->cmd_reply + 4);
+
+	err = rain_send_and_wait(rain, "Q 1", "QTY");
+	if (err)
+		return err;
+	err = rain_send_and_wait(rain, "c0000", "CFG");
+	if (err)
+		return err;
+	return rain_send_and_wait(rain, "A F 0000", "ADR");
+}
+
+static int rain_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	return 0;
+}
+
+static int rain_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
+{
+	struct rain *rain = adap->priv;
+	u8 cmd[16];
+
+	if (log_addr == CEC_LOG_ADDR_INVALID)
+		log_addr = CEC_LOG_ADDR_UNREGISTERED;
+	snprintf(cmd, sizeof(cmd), "A %x", log_addr);
+	return rain_send_and_wait(rain, cmd, "ADR");
+}
+
+static int rain_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				    u32 signal_free_time, struct cec_msg *msg)
+{
+	struct rain *rain = adap->priv;
+	char cmd[2 * CEC_MAX_MSG_SIZE + 16];
+	unsigned int i;
+	int err;
+
+	if (msg->len == 1) {
+		snprintf(cmd, sizeof(cmd), "x%x", cec_msg_destination(msg));
+	} else {
+		char hex[3];
+
+		snprintf(cmd, sizeof(cmd), "x%x %02x ",
+			 cec_msg_destination(msg), msg->msg[1]);
+		for (i = 2; i < msg->len; i++) {
+			snprintf(hex, sizeof(hex), "%02x", msg->msg[i]);
+			strncat(cmd, hex, sizeof(cmd));
+		}
+	}
+	mutex_lock(&rain->write_lock);
+	err = rain_send(rain, cmd);
+	mutex_unlock(&rain->write_lock);
+	return err;
+}
+
+static const struct cec_adap_ops rain_cec_adap_ops = {
+	.adap_enable = rain_cec_adap_enable,
+	.adap_log_addr = rain_cec_adap_log_addr,
+	.adap_transmit = rain_cec_adap_transmit,
+};
+
+static int rain_connect(struct serio *serio, struct serio_driver *drv)
+{
+	u32 caps = CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS | CEC_CAP_PHYS_ADDR |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC | CEC_CAP_MONITOR_ALL;
+	struct rain *rain;
+	int err = -ENOMEM;
+	struct cec_log_addrs log_addrs = {};
+	u16 pa = CEC_PHYS_ADDR_INVALID;
+
+	rain = kzalloc(sizeof(*rain), GFP_KERNEL);
+
+	if (!rain)
+		return -ENOMEM;
+
+	rain->serio = serio;
+	rain->adap = cec_allocate_adapter(&rain_cec_adap_ops, rain,
+		"HDMI CEC", caps, 1);
+	err = PTR_ERR_OR_ZERO(rain->adap);
+	if (err < 0)
+		goto free_device;
+
+	rain->dev = &serio->dev;
+	serio_set_drvdata(serio, rain);
+	INIT_WORK(&rain->work, rain_irq_work_handler);
+	mutex_init(&rain->write_lock);
+
+	err = serio_open(serio, drv);
+	if (err)
+		goto delete_adap;
+
+	err = rain_setup(rain, serio, &log_addrs, &pa);
+	if (err)
+		goto close_serio;
+
+	err = cec_register_adapter(rain->adap, &serio->dev);
+	if (err < 0)
+		goto close_serio;
+
+	rain->dev = &rain->adap->devnode.dev;
+	return 0;
+
+close_serio:
+	serio_close(serio);
+delete_adap:
+	cec_delete_adapter(rain->adap);
+	serio_set_drvdata(serio, NULL);
+free_device:
+	kfree(rain);
+	return err;
+}
+
+static struct serio_device_id rain_serio_ids[] = {
+	{
+		.type	= SERIO_RS232,
+		.proto	= SERIO_RAINSHADOW_CEC,
+		.id	= SERIO_ANY,
+		.extra	= SERIO_ANY,
+	},
+	{ 0 }
+};
+
+MODULE_DEVICE_TABLE(serio, rain_serio_ids);
+
+static struct serio_driver rain_drv = {
+	.driver		= {
+		.name	= "rainshadow-cec",
+	},
+	.description	= "RainShadow Tech HDMI CEC driver",
+	.id_table	= rain_serio_ids,
+	.interrupt	= rain_interrupt,
+	.connect	= rain_connect,
+	.disconnect	= rain_disconnect,
+};
+
+module_serio_driver(rain_drv);
-- 
2.10.2

