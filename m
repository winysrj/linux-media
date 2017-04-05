Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33353 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751856AbdDEA0Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 20:26:24 -0400
Date: Tue, 4 Apr 2017 17:26:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        linux-input <linux-input@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/2] rainshadow-cec: new RainShadow Tech HDMI CEC driver
Message-ID: <20170405002620.GC19744@dtor-ws>
References: <20161215130207.12913-1-hverkuil@xs4all.nl>
 <20161215130207.12913-3-hverkuil@xs4all.nl>
 <20170103065105.GC5743@dtor-ws>
 <2bae1ade-aa82-6143-6836-5f0598e80929@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bae1ade-aa82-6143-6836-5f0598e80929@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Feb 03, 2017 at 03:46:01PM +0100, Hans Verkuil wrote:
> Hi Dmitry,
> 
> Thanks for the feedback. See my comments below:
> 
> On 03/01/17 07:51, Dmitry Torokhov wrote:
> >Hi Hans,
> >
> >On Thu, Dec 15, 2016 at 02:02:07PM +0100, Hans Verkuil wrote:
> >>From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >>This driver supports the RainShadow Tech USB HDMI CEC adapter.
> >>
> >>See: http://rainshadowtech.com/HdmiCecUsb.html
> >>
> >>Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>---
> >> MAINTAINERS                                       |   7 +
> >> drivers/media/usb/Kconfig                         |   1 +
> >> drivers/media/usb/Makefile                        |   1 +
> >> drivers/media/usb/rainshadow-cec/Kconfig          |  10 +
> >> drivers/media/usb/rainshadow-cec/Makefile         |   1 +
> >> drivers/media/usb/rainshadow-cec/rainshadow-cec.c | 344 ++++++++++++++++++++++
> >> 6 files changed, 364 insertions(+)
> >> create mode 100644 drivers/media/usb/rainshadow-cec/Kconfig
> >> create mode 100644 drivers/media/usb/rainshadow-cec/Makefile
> >> create mode 100644 drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> >>
> >>diff --git a/MAINTAINERS b/MAINTAINERS
> >>index 52cc077..78ebc5d 100644
> >>--- a/MAINTAINERS
> >>+++ b/MAINTAINERS
> >>@@ -10069,6 +10069,13 @@ L:	linux-fbdev@vger.kernel.org
> >> S:	Maintained
> >> F:	drivers/video/fbdev/aty/aty128fb.c
> >>
> >>+RAINSHADOW-CEC DRIVER
> >>+M:	Hans Verkuil <hverkuil@xs4all.nl>
> >>+L:	linux-media@vger.kernel.org
> >>+T:	git git://linuxtv.org/media_tree.git
> >>+S:	Maintained
> >>+F:	drivers/media/usb/rainshadow-cec/*
> >>+
> >> RALINK MIPS ARCHITECTURE
> >> M:	John Crispin <john@phrozen.org>
> >> L:	linux-mips@linux-mips.org
> >>diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
> >>index c9644b6..b24e753 100644
> >>--- a/drivers/media/usb/Kconfig
> >>+++ b/drivers/media/usb/Kconfig
> >>@@ -63,6 +63,7 @@ endif
> >> if MEDIA_CEC_SUPPORT
> >> 	comment "USB HDMI CEC adapters"
> >> source "drivers/media/usb/pulse8-cec/Kconfig"
> >>+source "drivers/media/usb/rainshadow-cec/Kconfig"
> >> endif
> >>
> >> endif #MEDIA_USB_SUPPORT
> >>diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
> >>index 0f15e33..738b993 100644
> >>--- a/drivers/media/usb/Makefile
> >>+++ b/drivers/media/usb/Makefile
> >>@@ -25,3 +25,4 @@ obj-$(CONFIG_VIDEO_USBTV) += usbtv/
> >> obj-$(CONFIG_VIDEO_GO7007) += go7007/
> >> obj-$(CONFIG_DVB_AS102) += as102/
> >> obj-$(CONFIG_USB_PULSE8_CEC) += pulse8-cec/
> >>+obj-$(CONFIG_USB_RAINSHADOW_CEC) += rainshadow-cec/
> >>diff --git a/drivers/media/usb/rainshadow-cec/Kconfig b/drivers/media/usb/rainshadow-cec/Kconfig
> >>new file mode 100644
> >>index 0000000..447291b
> >>--- /dev/null
> >>+++ b/drivers/media/usb/rainshadow-cec/Kconfig
> >>@@ -0,0 +1,10 @@
> >>+config USB_RAINSHADOW_CEC
> >>+	tristate "RainShadow Tech HDMI CEC"
> >>+	depends on USB_ACM && MEDIA_CEC_SUPPORT
> >>+	select SERIO
> >>+	select SERIO_SERPORT
> >>+	---help---
> >>+	  This is a cec driver for the RainShadow Tech HDMI CEC device.
> >>+
> >>+	  To compile this driver as a module, choose M here: the
> >>+	  module will be called rainshadow-cec.
> >>diff --git a/drivers/media/usb/rainshadow-cec/Makefile b/drivers/media/usb/rainshadow-cec/Makefile
> >>new file mode 100644
> >>index 0000000..a79fbc7
> >>--- /dev/null
> >>+++ b/drivers/media/usb/rainshadow-cec/Makefile
> >>@@ -0,0 +1 @@
> >>+obj-$(CONFIG_USB_RAINSHADOW_CEC) += rainshadow-cec.o
> >>diff --git a/drivers/media/usb/rainshadow-cec/rainshadow-cec.c b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> >>new file mode 100644
> >>index 0000000..dc7f287
> >>--- /dev/null
> >>+++ b/drivers/media/usb/rainshadow-cec/rainshadow-cec.c
> >>@@ -0,0 +1,344 @@
> >>+/*
> >>+ * RainShadow Tech HDMI CEC driver
> >>+ *
> >>+ * Copyright 2016 Hans Verkuil <hverkuil@xs4all.nl
> >>+ *
> >>+ * This program is free software; you can redistribute it and/or modify it
> >>+ * under the terms of the GNU General Public License as published by the
> >>+ * Free Software Foundation; either version of 2 of the License, or (at your
> >>+ * option) any later version. See the file COPYING in the main directory of
> >>+ * this archive for more details.
> >>+ */
> >>+
> >>+/*
> >>+ * Notes:
> >>+ *
> >>+ * The higher level protocols are currently disabled. This can be added
> >>+ * later, similar to how this is done for the Pulse Eight CEC driver.
> >>+ *
> >>+ * Documentation of the protocol is available here:
> >>+ *
> >>+ * http://rainshadowtech.com/doc/HDMICECtoUSBandRS232v2.0.pdf
> >>+ */
> >>+
> >>+#include <linux/completion.h>
> >>+#include <linux/init.h>
> >>+#include <linux/interrupt.h>
> >>+#include <linux/kernel.h>
> >>+#include <linux/module.h>
> >>+#include <linux/workqueue.h>
> >>+#include <linux/serio.h>
> >>+#include <linux/slab.h>
> >>+#include <linux/time.h>
> >>+#include <linux/delay.h>
> >>+#include <linux/ctype.h>
> >>+
> >>+#include <media/cec.h>
> >>+
> >>+MODULE_AUTHOR("Hans Verkuil <hverkuil@xs4all.nl>");
> >>+MODULE_DESCRIPTION("RainShadow Tech HDMI CEC driver");
> >>+MODULE_LICENSE("GPL");
> >>+
> >>+static int debug;
> >>+module_param(debug, int, 0644);
> >>+MODULE_PARM_DESC(debug, "debug level (0-1)");
> >>+
> >>+#define DATA_SIZE 256
> >>+
> >>+struct rain {
> >>+	struct device *dev;
> >>+	struct serio *serio;
> >>+	struct cec_adapter *adap;
> >>+	struct completion cmd_done;
> >>+	struct work_struct work;
> >>+	struct cec_msg rx_msg;
> >>+	char data[DATA_SIZE];
> >>+	char buf[DATA_SIZE];
> >>+	unsigned int idx;
> >>+	bool started;
> >>+	struct mutex write_lock;
> >>+};
> >>+
> >>+static void rain_irq_work_handler(struct work_struct *work)
> >>+{
> >>+	struct rain *rain =
> >>+		container_of(work, struct rain, work);
> >>+	struct cec_msg *msg = &rain->rx_msg;
> >>+	const char *data = rain->data + 3;
> >>+	int stat = -1;
> >>+
> >>+	msg->len = 0;
> >>+	for (; *data; data++) {
> >>+		if (!isxdigit(*data))
> >>+			continue;
> >>+		if (isxdigit(data[0]) && isxdigit(data[1])) {
> >>+			if (msg->len == CEC_MAX_MSG_SIZE)
> >>+				break;
> >>+			hex2bin(msg->msg + msg->len, data, 2);
> >>+			msg->len++;
> >>+			data++;
> >>+			continue;
> >>+		}
> >>+		if (!data[1])
> >>+			stat = hex_to_bin(data[0]);
> >>+		break;
> >>+	}
> >>+
> >>+	if (rain->data[0] == 'R') {
> >>+		if (stat == 1 || stat == 2)
> >>+			cec_received_msg(rain->adap, msg);
> >>+		return;
> >>+	}
> >>+
> >>+	switch (stat) {
> >>+	case 1:
> >>+		cec_transmit_done(rain->adap, CEC_TX_STATUS_OK,
> >>+				  0, 0, 0, 0);
> >>+		break;
> >>+	case 2:
> >>+		cec_transmit_done(rain->adap, CEC_TX_STATUS_NACK,
> >>+				  0, 1, 0, 0);
> >>+		break;
> >>+	default:
> >>+		cec_transmit_done(rain->adap, CEC_TX_STATUS_LOW_DRIVE,
> >>+				  0, 0, 0, 1);
> >>+		break;
> >>+	}
> >>+}
> >>+
> >>+static irqreturn_t rain_interrupt(struct serio *serio, unsigned char data,
> >>+				    unsigned int flags)
> >>+{
> >>+	struct rain *rain = serio_get_drvdata(serio);
> >>+
> >>+	if (!rain->started && data != '?')
> >>+		return IRQ_HANDLED;
> >>+	if (data == '\r') {
> >>+		rain->buf[rain->idx] = '\0';
> >>+		if (debug)
> >>+			dev_info(rain->dev, "received: %s\n", rain->buf);
> >
> >Just dev_dbg() please. I think everyone is using dynamic debug.
> 
> OK.
> 
> >
> >>+		strcpy(rain->data, rain->buf);
> >>+		if (!memcmp(rain->data, "REC", 3) ||
> >>+		    !memcmp(rain->data, "STA", 3))
> >>+			schedule_work(&rain->work);
> >>+		else
> >>+			complete(&rain->cmd_done);
> >>+		rain->idx = 0;
> >>+		rain->started = false;
> >>+		return IRQ_HANDLED;
> >
> >This relies on work to complete before you receive the next message,
> >which is not always the case as far as I can understand.
> 
> I reworked this. This was in fact buggy, mainly because this adapter has the bad
> behavior of echoing the CEC messages it transmits. So I would get a REC and a STA
> message in quick succession.
> 
> >
> >>+	} else if (data == '?') {
> >>+		rain->idx = 0;
> >>+		rain->started = true;
> >>+		return IRQ_HANDLED;
> >>+	}
> >>+
> >>+	if (data == '\n') {
> >
> >Should it be a "switch (data) {" ?
> 
> Done. That's indeed better.
> 
> >
> >>+		rain->idx = 0;
> >>+		rain->started = false;
> >>+		return IRQ_HANDLED;
> >>+	}
> >>+	if (rain->idx >= DATA_SIZE - 1) {
> >>+		dev_dbg(rain->dev,
> >>+			"throwing away %d bytes of garbage\n", rain->idx);
> >>+		rain->idx = 0;
> >>+	}
> >>+	rain->buf[rain->idx++] = data;
> >>+	return IRQ_HANDLED;
> >>+}
> >>+
> >>+static void rain_disconnect(struct serio *serio)
> >>+{
> >>+	struct rain *rain = serio_get_drvdata(serio);
> >>+
> >>+	cec_unregister_adapter(rain->adap);
> >>+	dev_info(&serio->dev, "disconnected\n");
> >>+	serio_close(serio);
> >>+	serio_set_drvdata(serio, NULL);
> >>+	kfree(rain);
> >>+}
> >>+
> >>+static int rain_send(struct rain *rain, const char *command)
> >>+{
> >>+	int err = serio_write(rain->serio, '!');
> >>+
> >>+	if (debug)
> >>+		dev_info(rain->dev, "send: %s\n", command);
> >>+	while (!err && *command)
> >>+		err = serio_write(rain->serio, *command++);
> >>+	if (!err)
> >>+		err = serio_write(rain->serio, '~');
> >>+
> >>+	return err;
> >>+}
> >>+
> >>+static int rain_send_and_wait(struct rain *rain,
> >>+			      const char *cmd, const char *reply)
> >>+{
> >>+	int err;
> >>+
> >>+	init_completion(&rain->cmd_done);
> >>+
> >>+	mutex_lock(&rain->write_lock);
> >>+	err = rain_send(rain, cmd);
> >>+	if (err)
> >>+		goto err;
> >>+
> >>+	if (!wait_for_completion_timeout(&rain->cmd_done, HZ)) {
> >>+		err = -ETIMEDOUT;
> >>+		goto err;
> >>+	}
> >>+	if (reply && strncmp(rain->data, reply, strlen(reply))) {
> >>+		if (debug)
> >>+			dev_info(rain->dev,
> >>+				 "transmit of '%s': received '%s' instead of '%s'\n",
> >>+				 cmd, rain->data, reply);
> >>+		err = -EIO;
> >>+	}
> >>+err:
> >>+	mutex_unlock(&rain->write_lock);
> >>+	return err;
> >>+}
> >>+
> >>+static int rain_setup(struct rain *rain, struct serio *serio,
> >>+			struct cec_log_addrs *log_addrs, u16 *pa)
> >>+{
> >>+	u16 res;
> >>+	int err;
> >>+
> >>+	err = rain_send_and_wait(rain, "R", "REV");
> >>+	if (err)
> >>+		return err;
> >>+	dev_info(rain->dev, "Firmware version %s\n", rain->data + 4);
> >>+
> >>+	err = rain_send_and_wait(rain, "Q 1", "QTY");
> >>+	if (err)
> >>+		return err;
> >>+	err = rain_send_and_wait(rain, "c0000", "CFG");
> >>+	if (err)
> >>+		return err;
> >>+	return rain_send_and_wait(rain, "A F 0000", "ADR");
> >
> >Given that this is instantiated via serport + inputattach the setup
> >sequence should be done in inputattach, not kernel.
> 
> Certainly not. inputattach knows nothing about CEC, it just sets the right
> line discipline.
> 
> You don't want to have part of the adapter setup in inputattach and another
> part in the CEC driver, that would be impossible to maintain and keep in sync.

I'd recommend you reconsider. inputattach does not need to know about
CEC protocol at all, it just needs to know the "magic" activation
sequence that is needed to start the device. If you look at inputattach,
you will see that most of the devices have initialization sequence
there. It makes kernel code smaller and much simpler.

> 
> Ideally inputattach wouldn't be needed at all, but to my knowledge it is still
> not possible to do without this userspace component. Some work was done for
> TTY slave devices, but I am not aware of anything being merged. Please let me
> know if I am wrong.

I see Rob has merged serdev, so maybe this is something that could work
for you as well.

Thanks.

-- 
Dmitry
