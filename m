Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44103 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1FSAKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2011 20:10:18 -0400
Received: by iyb12 with SMTP id 12so1098404iyb.19
        for <linux-media@vger.kernel.org>; Sat, 18 Jun 2011 17:10:17 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 19 Jun 2011 02:10:15 +0200
Message-ID: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
Subject: [RFC] vtunerc - virtual DVB device driver
From: HoP <jpetrous@gmail.com>
To: linux-media@vger.kernel.org, k@linux.com,
	Ales Jurik <ajurik@smartimp.cz>,
	Honza Petrous <jpetrous@smartimp.cz>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

get inspired by (unfortunately close-source) solution on stb
Dreambox 800 I have made my own implementation
of virtual DVB device, based on the same device API.

In conjunction with "Dreamtuner" userland project
[http://code.google.com/p/dreamtuner/] by Ronald Mieslinger
user can create virtual DVB device on client side and connect it
to the server. When connected, user is able to use any Linux DVB API
compatible application on client side (like VDR, MeTV, MythTV, etc)
without any need of code modification. As server can be used any
Linux DVB API compatible device.

Here is the small and ugly big picture :-)

            CLIENT                                    SERVER
--------------------------------      ---------------------------------
|  Favourite Linux DVB API |     |      Real DVB tuner HW       |
|  compatible application    |     |         (any S, C or T)          |
---------------------------------      ---------------------------------
                 |                                                  ^
    Linux DVB API layer                   Linux DVB API layer
                 |                                                  |
                v                                                  |
---------------------------------                          |
|           vtunerc.ko              |                          |
|     (virtual DVB device )    |                          |
---------------------------------                          |
                 |                                                  |
    /dev/vtunerX API layer                               |
                 |                                                  |
                v                                                  |
---------------------------------           ---------------------------------
|          vtunerc.x86            |            |          vtuners.arm
           |
|   (dreamtuner client app)  |           |  (dreamtuner server app)  |
--------------------------------            ---------------------------------
                 |                                                   ^
                 |                TCP/IP network             |
                 ------------------------------------------
                        dreamtuner network protocol


Note: current code was tested on kernels from 2.6.22 up to 2.6.38
and that is the reason of codeversion preprocessor ifdefs there.
I understand fully that such code must be removed for possible
code submission.

Signed-off-by: Honza Petrous <jpetrous@smartimp.cz>


diff -r a43a9e31be8b drivers/media/dvb/vtunerc/Kconfig
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/media/dvb/vtunerc/Kconfig	Sun Jun 19 01:55:52 2011 +0200
@@ -0,0 +1,13 @@
+config DVB_VTUNERC
+	tristate "Virtual DVB adapters support"
+	depends on DVB_CORE
+	---help---
+	  Support for virtual DVB adapter.
+
+	  Choose Y here if you want to access DVB device residing on other
+	  computers using vtuner protocol.  To compile this driver as a module,
+	  choose M here: the module will be called vtunerc.
+
+	  To connect remote DVB device, you also need to install the user space
+	  vtunerc command which can be found in the Dreamtuner package, available
+	  from http://code.google.com/p/dreamtuner/.
diff -r a43a9e31be8b drivers/media/dvb/vtunerc/Makefile
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/media/dvb/vtunerc/Makefile	Sun Jun 19 01:55:52 2011 +0200
@@ -0,0 +1,14 @@
+#
+# Makefile for the nGene device driver
+#
+
+vtunerc-objs = vtunerc_main.o vtunerc_ctrldev.o vtunerc_proxyfe.o
+
+obj-$(CONFIG_DVB_VTUNERC) += vtunerc.o
+
+EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
+EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
+EXTRA_CFLAGS += -Idrivers/media/common/tuners
+EXTRA_CFLAGS += -Iinclude/linux
+
+EXTRA_CFLAGS += -DHAVE_DVB_API_VERSION=5
diff -r a43a9e31be8b drivers/media/dvb/vtunerc/vtuner.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/media/dvb/vtunerc/vtuner.h	Sun Jun 19 01:55:52 2011 +0200
@@ -0,0 +1,163 @@
+/*
+ * vtunerc: /dev/vtunerc API
+ *
+ * Copyright (C) 2010-11 Honza Petrous <jpetrous@smartimp.cz>
+ * [based on dreamtuner userland code by Roland Mieslinger]
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VTUNER_H_
+#define _VTUNER_H_
+
+#ifndef HAVE_DVB_API_VERSION
+#define HAVE_DVB_API_VERSION 5
+#endif
+
+#if HAVE_DVB_API_VERSION < 3
+  #include <ost/frontend.h>
+  #include <ost/dmx.h>
+  #include <ost/sec.h>
+#else
+  #include <linux/dvb/version.h>
+  #include <linux/dvb/frontend.h>
+  #include <linux/dvb/dmx.h>
+#endif
+
+#define VT_S   0x01
+#define VT_C   0x02
+#define VT_T   0x04
+#define VT_S2  0x08
+
+#define MSG_SET_FRONTEND		1
+#define MSG_GET_FRONTEND		2
+#define MSG_READ_STATUS			3
+#define MSG_READ_BER			4
+#define MSG_READ_SIGNAL_STRENGTH	5
+#define MSG_READ_SNR			6
+#define MSG_READ_UCBLOCKS		7
+#define MSG_SET_TONE			8
+#define MSG_SET_VOLTAGE			9
+#define MSG_ENABLE_HIGH_VOLTAGE		10
+#define MSG_SEND_DISEQC_MSG		11
+#define MSG_SEND_DISEQC_BURST		13
+#define MSG_PIDLIST			14
+#define MSG_TYPE_CHANGED		15
+#define MSG_SET_PROPERTY		16
+#define MSG_GET_PROPERTY		17
+
+#define MSG_NULL			1024
+#define MSG_DISCOVER			1025
+#define MSG_UPDATE       		1026
+
+struct diseqc_master_cmd {
+	__u8 msg[6];
+	__u8 msg_len;
+};
+
+#if DVB_API_VERSION < 5
+struct dtv_property {
+	__u32 cmd;
+	__u32 reserved[3];
+	union {
+		__u32 data;
+		struct {
+			__u8 data[32];
+			__u32 len;
+			__u32 reserved1[3];
+			void *reserved2;
+		} buffer;
+	} u;
+	int result;
+} __attribute__ ((packed));
+
+#define DTV_UNDEFINED		0
+#define DTV_TUNE		1
+#define DTV_CLEAR		2
+#define DTV_FREQUENCY		3
+#define DTV_MODULATION		4
+#define DTV_BANDWIDTH_HZ	5
+#define DTV_INVERSION		6
+#define DTV_DISEQC_MASTER	7
+#define DTV_SYMBOL_RATE		8
+#define DTV_INNER_FEC		9
+#define DTV_VOLTAGE		10
+#define DTV_TONE		11
+#define DTV_PILOT		12
+#define DTV_ROLLOFF		13
+#define DTV_DISEQC_SLAVE_REPLY	14
+#define DTV_FE_CAPABILITY_COUNT	15
+#define DTV_FE_CAPABILITY	16
+#define DTV_DELIVERY_SYSTEM	17
+
+#define DTV_IOCTL_MAX_MSGS	64
+
+#endif
+
+struct vtuner_message {
+	__s32 type;
+	union {
+		struct {
+			__u32	frequency;
+			__u8	inversion;
+			union {
+				struct {
+					__u32	symbol_rate;
+					__u32	fec_inner;
+				} qpsk;
+				struct {
+					__u32   symbol_rate;
+					__u32   fec_inner;
+					__u32	modulation;
+				} qam;
+				struct {
+					__u32	bandwidth;
+					__u32	code_rate_HP;
+					__u32	code_rate_LP;
+					__u32	constellation;
+					__u32	transmission_mode;
+					__u32	guard_interval;
+					__u32	hierarchy_information;
+				} ofdm;
+				struct {
+					__u32	modulation;
+				} vsb;
+			} u;
+		} fe_params;
+		struct dtv_property prop;
+		__u32 status;
+		__u32 ber;
+		__u16 ss;
+		__u16 snr;
+		__u32 ucb;
+		__u8 tone;
+		__u8 voltage;
+		struct diseqc_master_cmd diseqc_master_cmd;
+		__u8 burst;
+		__u16 pidlist[30];
+		__u8  pad[72];
+		__u32 type_changed;
+	} body;
+};
+
+#define VTUNER_MAJOR		226
+
+/*#define PVR_FLUSH_BUFFER	_IO(VTUNER_MAJOR, 0)*/
+#define VTUNER_GET_MESSAGE	_IOR(VTUNER_MAJOR, 1, struct vtuner_message *)
+#define VTUNER_SET_RESPONSE 	_IOW(VTUNER_MAJOR, 2, struct vtuner_message *)
+#define VTUNER_SET_NAME		_IOW(VTUNER_MAJOR, 3, char *)
+#define VTUNER_SET_TYPE		_IOW(VTUNER_MAJOR, 4, char *)
+#define VTUNER_SET_HAS_OUTPUTS	_IOW(VTUNER_MAJOR, 5, char *)
+#define VTUNER_SET_FE_INFO	_IOW(VTUNER_MAJOR, 6, struct dvb_frontend_info *)
+#define VTUNER_SET_NUM_MODES	_IOW(VTUNER_MAJOR, 7, int)
+#define VTUNER_SET_MODES	_IOW(VTUNER_MAJOR, 8, char *)
+
+#endif
+
diff -r a43a9e31be8b drivers/media/dvb/vtunerc/vtunerc_ctrldev.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/media/dvb/vtunerc/vtunerc_ctrldev.c	Sun Jun 19 01:55:52 2011 +0200
@@ -0,0 +1,427 @@
+/*
+ * vtunerc: /dev/vtunerc device
+ *
+ * Copyright (C) 2010-11 Honza Petrous <jpetrous@smartimp.cz>
+ * [Created 2010-03-23]
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+
+#include <linux/time.h>
+#include <linux/poll.h>
+
+#include "vtunerc_priv.h"
+
+#define VTUNERC_CTRLDEV_MAJOR	266
+#define VTUNERC_CTRLDEV_NAME	"vtunerc"
+
+#define VTUNER_MSG_LEN (sizeof(struct vtuner_message))
+
+static ssize_t vtunerc_ctrldev_write(struct file *filp, const char *buff,
+					size_t len, loff_t *off)
+{
+	struct vtunerc_ctx *vtunerc = filp->private_data;
+	struct dvb_demux *demux = &vtunerc->demux;
+	char *kernel_buf;
+	size_t origlen = len;
+
+	if (vtunerc->closing)
+		return -EINTR;
+
+	kernel_buf = kmalloc(len + vtunerc->trailsize, GFP_KERNEL);
+
+	if (kernel_buf == NULL)
+		return -ENOMEM;
+
+	if (down_interruptible(&vtunerc->tswrite_sem))
+		return -ERESTARTSYS;
+
+	if (vtunerc->trailsize)
+		memcpy(kernel_buf, vtunerc->trail, vtunerc->trailsize);
+
+	if (copy_from_user(kernel_buf + vtunerc->trailsize, buff, len)) {
+		printk(PRINTK_ERR "%s: ERR: in userdata passing\n", __func__);
+		up(&vtunerc->tswrite_sem);
+		return 0;
+	}
+
+	if (kernel_buf[0] != 0x47) { /* start of TS packet */
+		printk(PRINTK_ERR "%s: WARN: Data not start on packet boundary:
%02x %02x %02x %02x %02x ...\n",
+				__func__, kernel_buf[0], kernel_buf[1],
+				kernel_buf[2], kernel_buf[3], kernel_buf[4]);
+	}
+
+	len += vtunerc->trailsize;
+	vtunerc->trailsize = len % 188;
+	if ((vtunerc->trailsize)) {
+		/* saving last partial TS packet */
+		len -= vtunerc->trailsize;
+		memcpy(vtunerc->trail, kernel_buf + len, vtunerc->trailsize);
+	}
+
+	vtunerc->stat_wr_data += len;
+	dvb_dmx_swfilter_packets(demux, kernel_buf, len / 188);
+
+	up(&vtunerc->tswrite_sem);
+
+#ifdef CONFIG_PROC_FS
+	/* TODO:  analyze injected data for statistics */
+#endif
+
+	kfree(kernel_buf);
+
+	return origlen;
+}
+
+static ssize_t vtunerc_ctrldev_read(struct file *filp, char __user *buff,
+		size_t len, loff_t *off)
+{
+	struct vtunerc_ctx *vtunerc = filp->private_data;
+
+	vtunerc->stat_rd_data += len;
+
+	/* read op is not using in current vtuner protocol */
+	return 0 ;
+}
+
+static int vtunerc_ctrldev_open(struct inode *inode, struct file *filp)
+{
+	struct vtunerc_ctx *vtunerc;
+	int minor;
+
+	minor = MINOR(inode->i_rdev);
+	vtunerc = filp->private_data = vtunerc_get_ctx(minor);
+	if (vtunerc == NULL)
+		return -ENOMEM;
+
+	vtunerc->stat_ctrl_sess++;
+
+	/*FIXME: clear pidtab */
+
+	vtunerc->fd_opened++;
+	vtunerc->closing = 0;
+
+	return 0;
+}
+
+static int vtunerc_ctrldev_close(struct inode *inode, struct file *filp)
+{
+	struct vtunerc_ctx *vtunerc = filp->private_data;
+	int minor;
+	struct vtuner_message fakemsg;
+
+	vtunerc->fd_opened--;
+	vtunerc->closing = 1;
+
+	minor = MINOR(inode->i_rdev);
+
+	/* set FAKE response, to allow finish any waiters
+	   in vtunerc_ctrldev_xchange_message() */
+	vtunerc->ctrldev_response.type = 0;
+	wake_up_interruptible(&vtunerc->ctrldev_wait_response_wq);
+
+	/* clear pidtab */
+	if (down_interruptible(&vtunerc->xchange_sem))
+		return -ERESTARTSYS;
+	memset(&fakemsg, 0, sizeof(fakemsg));
+	vtunerc_ctrldev_xchange_message(vtunerc, &fakemsg, 0);
+	up(&vtunerc->xchange_sem);
+
+	return 0;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 16)
+static long vtunerc_ctrldev_ioctl(struct file *file, unsigned int cmd,
+					unsigned long arg)
+#else
+static int vtunerc_ctrldev_ioctl(struct inode *inode, struct file *file,
+					unsigned int cmd, unsigned long arg)
+#endif
+{
+	struct vtunerc_ctx *vtunerc = file->private_data;
+	int len, ret = 0;
+	int i;
+
+	if (vtunerc->closing)
+		return -EINTR;
+
+	if (down_interruptible(&vtunerc->ioctl_sem))
+		return -ERESTARTSYS;
+
+	switch (cmd) {
+	case VTUNER_SET_NAME:
+		len = strlen((char *)arg) + 1;
+		vtunerc->name = kmalloc(len, GFP_KERNEL);
+		if (vtunerc->name == NULL) {
+			printk(PRINTK_ERR "%s returns no mem\n", __func__);
+			ret = -ENOMEM;
+			break;
+		}
+		if (copy_from_user(vtunerc->name, (char *)arg, len)) {
+			ret = -EFAULT;
+			break;
+		}
+		break;
+
+	case VTUNER_SET_HAS_OUTPUTS:
+		/* TODO: faked for now */
+		break;
+
+	case VTUNER_SET_MODES:
+		for (i = 0; i < vtunerc->num_modes; i++)
+			vtunerc->ctypes[i] = &(((char *)(arg))[i*32]);
+		if (vtunerc->num_modes != 1) {
+			printk(PRINTK_ERR "%s currently supported only num_modes = 1!\n",
+					__func__);
+			break;
+		}
+		/* follow into old code for compatibility */
+
+	case VTUNER_SET_TYPE:
+		if (strcasecmp((char *)arg, "DVB-S") == 0) {
+			vtunerc->vtype = VT_S;
+			printk(PRINTK_NOTICE "%s setting DVB-S tuner vtype\n",
+					__func__);
+		} else
+		if (strcasecmp((char *)arg, "DVB-S2") == 0) {
+			vtunerc->vtype = VT_S2;
+			printk(PRINTK_NOTICE "%s setting DVB-S2 tuner vtype\n",
+					__func__);
+		} else
+		if (strcasecmp((char *)arg, "DVB-T") == 0) {
+			vtunerc->vtype = VT_T;
+			printk(PRINTK_NOTICE "%s setting DVB-T tuner vtype\n",
+					__func__);
+		} else
+		if (strcasecmp((char *)arg, "DVB-C") == 0) {
+			vtunerc->vtype = VT_C;
+			printk(PRINTK_NOTICE "%s setting DVB-C tuner vtype\n",
+					__func__);
+		} else {
+			printk(PRINTK_ERR "%s unregognized tuner vtype '%s'\n",
+					__func__, (char *)arg);
+			ret = -ENODEV;
+			break;
+		}
+
+		if ((vtunerc_frontend_init(vtunerc))) {
+			vtunerc->vtype = 0;
+			printk(PRINTK_ERR "%s failed to initialize tuner's internals\n",
+					__func__);
+			ret = -ENODEV;
+			break;
+		}
+
+		break;
+
+
+	case VTUNER_SET_FE_INFO:
+		len = sizeof(struct dvb_frontend_info);
+		vtunerc->feinfo = kmalloc(len, GFP_KERNEL);
+		if (vtunerc->feinfo == NULL) {
+			printk(PRINTK_ERR "%s return no mem<\n", __func__);
+			ret = -ENOMEM;
+			break;
+		}
+		if (copy_from_user(vtunerc->feinfo, (char *)arg, len)) {
+			ret = -EFAULT;
+			break;
+		}
+		break;
+
+	case VTUNER_GET_MESSAGE:
+		if (wait_event_interruptible(vtunerc->ctrldev_wait_request_wq,
+					vtunerc->ctrldev_request.type != -1)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		BUG_ON(vtunerc->ctrldev_request.type == -1);
+
+		if (copy_to_user((char *)arg, &vtunerc->ctrldev_request,
+					VTUNER_MSG_LEN)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		vtunerc->ctrldev_request.type = -1;
+
+		if (vtunerc->noresponse)
+			up(&vtunerc->xchange_sem);
+
+		break;
+
+	case VTUNER_SET_RESPONSE:
+		if (copy_from_user(&vtunerc->ctrldev_response, (char *)arg,
+					VTUNER_MSG_LEN)) {
+			ret = -EFAULT;
+		}
+		wake_up_interruptible(&vtunerc->ctrldev_wait_response_wq);
+
+		break;
+
+	case VTUNER_SET_NUM_MODES:
+		vtunerc->num_modes = (int) arg;
+		break;
+
+	default:
+		printk(PRINTK_WARN "vtunerc: WARN: unknown IOCTL 0x%x\n", cmd);
+
+		break;
+	}
+	up(&vtunerc->ioctl_sem);
+
+	return ret;
+}
+
+static unsigned int vtunerc_ctrldev_poll(struct file *filp, poll_table *wait)
+{
+	struct vtunerc_ctx *vtunerc = filp->private_data;
+	unsigned int mask = 0;
+
+	if (vtunerc->closing)
+		return -EINTR;
+
+	poll_wait(filp, &vtunerc->ctrldev_wait_request_wq, wait);
+
+	if (vtunerc->ctrldev_request.type >= -1 ||
+			vtunerc->ctrldev_response.type >= -1) {
+		mask = POLLPRI;
+	}
+
+  return mask;
+}
+
+/* ------------------------------------------------ */
+
+static const struct file_operations vtunerc_ctrldev_fops = {
+	.owner = THIS_MODULE,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 16) /* see:
http://lwn.net/Articles/119652/ */
+	.unlocked_ioctl = vtunerc_ctrldev_ioctl,
+#else
+	.ioctl = vtunerc_ctrldev_ioctl,
+#endif
+	.write = vtunerc_ctrldev_write,
+	.read  = vtunerc_ctrldev_read,
+	.poll  = (void *) vtunerc_ctrldev_poll,
+	.open  = vtunerc_ctrldev_open,
+	.release  = vtunerc_ctrldev_close
+};
+
+static struct class *pclass;
+static struct cdev cdev;
+static dev_t chdev;
+extern int adapters;
+
+int vtunerc_register_ctrldev()
+{
+	int idx;
+
+	chdev = MKDEV(VTUNERC_CTRLDEV_MAJOR, 0);
+
+	if (register_chrdev_region(chdev, adapters, VTUNERC_CTRLDEV_NAME)) {
+		printk(PRINTK_ERR "vtunerc: ERR: unable to get major %d\n",
+				VTUNERC_CTRLDEV_MAJOR);
+		return -EINVAL;
+	}
+
+	cdev_init(&cdev, &vtunerc_ctrldev_fops);
+
+	cdev.owner = THIS_MODULE;
+	cdev.ops = &vtunerc_ctrldev_fops;
+
+	if (cdev_add(&cdev, chdev, adapters) < 0)
+		printk(PRINTK_WARN "vtunerc: WARN: unable to create dev\n");
+
+	pclass = class_create(THIS_MODULE, "vtuner");
+	if (IS_ERR(pclass)) {
+		printk(PRINTK_ERR "vtunerc: ERR: unable to register major %d\n",
+				VTUNERC_CTRLDEV_MAJOR);
+		return PTR_ERR(pclass);
+	}
+
+	for (idx = 0; idx < adapters; idx++) {
+		struct device *clsdev;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 27)
+		clsdev = device_create(pclass, NULL,
+				MKDEV(VTUNERC_CTRLDEV_MAJOR, idx),
+				"vtunerc%d", idx);
+#else
+		clsdev = device_create(pclass, NULL,
+				MKDEV(VTUNERC_CTRLDEV_MAJOR, idx),
+				/*ctx*/ NULL, "vtunerc%d", idx);
+#endif
+		printk(PRINTK_NOTICE "vtunerc: registered /dev/vtunerc%d\n",
+				idx);
+	}
+
+	return 0;
+}
+
+void vtunerc_unregister_ctrldev()
+{
+	int idx;
+
+	printk(PRINTK_NOTICE "vtunerc: unregistering\n");
+
+	unregister_chrdev_region(chdev, adapters);
+
+	for (idx = 0; idx < adapters; idx++)
+		device_destroy(pclass, MKDEV(VTUNERC_CTRLDEV_MAJOR, idx));
+
+	cdev_del(&cdev);
+
+	class_destroy(pclass);
+}
+
+
+int vtunerc_ctrldev_xchange_message(struct vtunerc_ctx *vtunerc,
+		struct vtuner_message *msg, int wait4response)
+{
+	if (down_interruptible(&vtunerc->xchange_sem))
+		return -ERESTARTSYS;
+
+	if (vtunerc->fd_opened < 1) {
+		up(&vtunerc->xchange_sem);
+		return 0;
+	}
+
+	BUG_ON(vtunerc->ctrldev_request.type != -1);
+
+	memcpy(&vtunerc->ctrldev_request, msg, sizeof(struct vtuner_message));
+	vtunerc->ctrldev_response.type = -1;
+	vtunerc->noresponse = !wait4response;
+	wake_up_interruptible(&vtunerc->ctrldev_wait_request_wq);
+
+	if (!wait4response)
+		return 0;
+
+	if (wait_event_interruptible(vtunerc->ctrldev_wait_response_wq,
+				vtunerc->ctrldev_response.type != -1)) {
+		up(&vtunerc->xchange_sem);
+		return -ERESTARTSYS;
+	}
+
+	BUG_ON(vtunerc->ctrldev_response.type == -1);
+
+	memcpy(msg, &vtunerc->ctrldev_response, sizeof(struct vtuner_message));
+	vtunerc->ctrldev_response.type = -1;
+
+	up(&vtunerc->xchange_sem);
+
+	return 0;
+}
diff -r a43a9e31be8b drivers/media/dvb/vtunerc/vtunerc_main.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/media/dvb/vtunerc/vtunerc_main.c	Sun Jun 19 01:55:52 2011 +0200
@@ -0,0 +1,396 @@
+/*
+ * vtunerc: Virtual adapter driver
+ *
+ * Copyright (C) 2010-11 Honza Petrous <jpetrous@smartimp.cz>
+ * [Created 2010-03-23]
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>	/* Specifically, a module */
+#include <linux/kernel.h>	/* We're doing kernel work */
+#include <linux/proc_fs.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <asm/uaccess.h>
+#include <linux/delay.h>
+
+#include "demux.h"
+#include "dmxdev.h"
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
+#include "dvb_net.h"
+#include "dvbdev.h"
+
+#include "vtuner.h"
+
+#include "vtunerc_priv.h"
+
+#define VTUNERC_MODULE_VERSION "0.12"
+
+#define MSGHEADER "[vtunerc]: "
+
+DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
+
+#define DRIVER_NAME		"vTuner proxy"
+
+#define VTUNERC_PROC_FILENAME	"vtunerc%i"
+
+#define VTUNERC_MAX_ADAPTERS	4
+
+static struct vtunerc_ctx *vtunerc_tbl[VTUNERC_MAX_ADAPTERS] = { NULL };
+
+int adapters = 1;
+
+static int pidtab_find_index(unsigned short *pidtab, int pid)
+{
+	int i = 0;
+
+	while (i < MAX_PIDTAB_LEN) {
+		if (pidtab[i] == pid)
+			return i;
+		i++;
+	}
+
+	return -1;
+}
+
+static int pidtab_add_pid(unsigned short *pidtab, int pid)
+{
+	int i;
+
+	/* TODO: speed-up hint: add pid sorted */
+
+	for (i = 0; i < MAX_PIDTAB_LEN; i++)
+		if (pidtab[i] == PID_UNKNOWN) {
+			pidtab[i] = pid;
+			return 0;
+		}
+
+	return -1;
+}
+
+static int pidtab_del_pid(unsigned short *pidtab, int pid)
+{
+	int i;
+
+	/* TODO: speed-up hint: delete sorted */
+
+	for (i = 0; i < MAX_PIDTAB_LEN; i++)
+		if (pidtab[i] == pid) {
+			pidtab[i] = PID_UNKNOWN;
+			/* TODO: move rest */
+			return 0;
+		}
+
+	return -1;
+}
+
+static void pidtab_copy_to_msg(struct vtunerc_ctx *vtunerc,
+				struct vtuner_message *msg)
+{
+	int i;
+
+	for (i = 0; i < (MAX_PIDTAB_LEN - 1); i++)
+		msg->body.pidlist[i] = vtunerc->pidtab[i]; /*TODO: optimize it*/
+	msg->body.pidlist[MAX_PIDTAB_LEN - 1] = 0;
+}
+
+static int vtunerc_start_feed(struct dvb_demux_feed *feed)
+{
+	struct dvb_demux *demux = feed->demux;
+	struct vtunerc_ctx *vtunerc = demux->priv;
+	struct vtuner_message msg;
+
+	switch (feed->type) {
+	case DMX_TYPE_TS:
+		break;
+	case DMX_TYPE_SEC:
+		break;
+	case DMX_TYPE_PES:
+		printk(MSGHEADER " feed type PES is not supported\n");
+		return -EINVAL;
+	default:
+		printk(MSGHEADER " feed type %d is not supported\n",
+				feed->type);
+		return -EINVAL;
+	}
+
+	/* organize PID list table */
+
+	if (pidtab_find_index(vtunerc->pidtab, feed->pid) < 0) {
+		pidtab_add_pid(vtunerc->pidtab, feed->pid);
+
+		pidtab_copy_to_msg(vtunerc, &msg);
+
+		msg.type = MSG_PIDLIST;
+		vtunerc_ctrldev_xchange_message(vtunerc, &msg, 0);
+	}
+
+	return 0;
+}
+
+static int vtunerc_stop_feed(struct dvb_demux_feed *feed)
+{
+	struct dvb_demux *demux = feed->demux;
+	struct vtunerc_ctx *vtunerc = demux->priv;
+	struct vtuner_message msg;
+
+	/* organize PID list table */
+
+	if (pidtab_find_index(vtunerc->pidtab, feed->pid) > -1) {
+		pidtab_del_pid(vtunerc->pidtab, feed->pid);
+
+		pidtab_copy_to_msg(vtunerc, &msg);
+
+		msg.type = MSG_PIDLIST;
+		vtunerc_ctrldev_xchange_message(vtunerc, &msg, 0);
+	}
+
+	return 0;
+}
+
+/* ----------------------------------------------------------- */
+
+
+#ifdef CONFIG_PROC_FS
+#define MAXBUF 512
+/**
+ * @brief  procfs file handler
+ * @param  buffer:
+ * @param  start:
+ * @param  offset:
+ * @param  size:
+ * @param  eof:
+ * @param  data:
+ * @return =0: success <br/>
+ *         <0: if any error occur
+ */
+int vtunerc_read_proc(char *buffer, char **start, off_t offset, int size,
+			int *eof, void *data)
+{
+	char outbuf[MAXBUF] = "[ vtunerc driver, version "
+				VTUNERC_MODULE_VERSION " ]\n";
+	int blen, i, pcnt;
+	struct vtunerc_ctx *vtunerc = (struct vtunerc_ctx *)data;
+
+	blen = strlen(outbuf);
+	sprintf(outbuf+blen, "  sessions: %u\n", vtunerc->stat_ctrl_sess);
+	blen = strlen(outbuf);
+	sprintf(outbuf+blen, "  read    : %u\n", vtunerc->stat_rd_data);
+	blen = strlen(outbuf);
+	sprintf(outbuf+blen, "  write   : %u\n", vtunerc->stat_wr_data);
+	blen = strlen(outbuf);
+	sprintf(outbuf+blen, "  PID tab :");
+	pcnt = 0;
+	for (i = 0; i < MAX_PIDTAB_LEN; i++) {
+		blen = strlen(outbuf);
+		if (vtunerc->pidtab[i] != PID_UNKNOWN) {
+			sprintf(outbuf+blen, " %x", vtunerc->pidtab[i]);
+			pcnt++;
+		}
+	}
+	blen = strlen(outbuf);
+	sprintf(outbuf+blen, " (len=%d)\n", pcnt);
+
+	blen = strlen(outbuf);
+
+	if (size < blen)
+		return -EINVAL;
+
+	if (offset != 0)
+		return 0;
+
+	strcpy(buffer, outbuf);
+
+	/* signal EOF */
+	*eof = 1;
+
+	return blen;
+
+}
+#endif
+
+static char *my_strdup(const char *s)
+{
+	char *rv = kmalloc(strlen(s)+1, GFP_KERNEL);
+	if (rv)
+		strcpy(rv, s);
+	return rv;
+}
+
+struct vtunerc_ctx *vtunerc_get_ctx(int minor)
+{
+	if (minor >= VTUNERC_MAX_ADAPTERS)
+		return NULL;
+
+	return vtunerc_tbl[minor];
+}
+
+static int __init vtunerc_init(void)
+{
+	struct vtunerc_ctx *vtunerc;
+	struct dvb_demux *dvbdemux;
+	struct dmx_demux *dmx;
+	int ret = -EINVAL, i, idx;
+
+	printk(KERN_INFO "vTunerc DVB multi adapter driver, version "
+			VTUNERC_MODULE_VERSION
+			", (c) 2010-11 Honza Petrous, SmartImp.cz\n");
+
+	request_module("dvb-core"); /* FIXME: dunno which way it should work :-/ */
+
+	for (idx = 0; idx < adapters; idx++) {
+		vtunerc = kzalloc(sizeof(struct vtunerc_ctx), GFP_KERNEL);
+		if (!vtunerc)
+			return -ENOMEM;
+
+		vtunerc_tbl[idx] = vtunerc;
+
+		vtunerc->idx = idx;
+		vtunerc->ctrldev_request.type = -1;
+		vtunerc->ctrldev_response.type = -1;
+		init_waitqueue_head(&vtunerc->ctrldev_wait_request_wq);
+		init_waitqueue_head(&vtunerc->ctrldev_wait_response_wq);
+
+		/* dvb */
+
+		/* create new adapter */
+		ret = dvb_register_adapter(&vtunerc->dvb_adapter, DRIVER_NAME,
+					   THIS_MODULE, NULL, adapter_nr);
+		if (ret < 0)
+			goto err_kfree;
+
+		vtunerc->dvb_adapter.priv = vtunerc;
+
+		memset(&vtunerc->demux, 0, sizeof(vtunerc->demux));
+		dvbdemux = &vtunerc->demux;
+		dvbdemux->priv = vtunerc;
+		dvbdemux->filternum = MAX_PIDTAB_LEN;
+		dvbdemux->feednum = MAX_PIDTAB_LEN;
+		dvbdemux->start_feed = vtunerc_start_feed;
+		dvbdemux->stop_feed = vtunerc_stop_feed;
+		dvbdemux->dmx.capabilities = 0;
+		ret = dvb_dmx_init(dvbdemux);
+		if (ret < 0)
+			goto err_dvb_unregister_adapter;
+
+		dmx = &dvbdemux->dmx;
+
+		vtunerc->hw_frontend.source = DMX_FRONTEND_0;
+		vtunerc->mem_frontend.source = DMX_MEMORY_FE;
+		vtunerc->dmxdev.filternum = MAX_PIDTAB_LEN;
+		vtunerc->dmxdev.demux = dmx;
+
+		ret = dvb_dmxdev_init(&vtunerc->dmxdev, &vtunerc->dvb_adapter);
+		if (ret < 0)
+			goto err_dvb_dmx_release;
+
+		ret = dmx->add_frontend(dmx, &vtunerc->hw_frontend);
+		if (ret < 0)
+			goto err_dvb_dmxdev_release;
+
+		ret = dmx->add_frontend(dmx, &vtunerc->mem_frontend);
+		if (ret < 0)
+			goto err_remove_hw_frontend;
+
+		ret = dmx->connect_frontend(dmx, &vtunerc->hw_frontend);
+		if (ret < 0)
+			goto err_remove_mem_frontend;
+
+		sema_init(&vtunerc->xchange_sem, 1);
+		sema_init(&vtunerc->ioctl_sem, 1);
+		sema_init(&vtunerc->tswrite_sem, 1);
+
+		/* init pid table */
+		for (i = 0; i < MAX_PIDTAB_LEN; i++)
+			vtunerc->pidtab[i] = PID_UNKNOWN;
+
+#ifdef CONFIG_PROC_FS
+		{
+			char procfilename[64];
+
+			sprintf(procfilename, VTUNERC_PROC_FILENAME,
+					vtunerc->idx);
+			vtunerc->procname = my_strdup(procfilename);
+			if (create_proc_read_entry(vtunerc->procname, 0, NULL,
+							vtunerc_read_proc,
+							vtunerc) == 0)
+				printk(MSGHEADER
+					"Unable to register '%s' proc file\n",
+					vtunerc->procname);
+		}
+#endif
+	}
+
+	vtunerc_register_ctrldev();
+
+out:
+	return ret;
+
+	dmx->disconnect_frontend(dmx);
+err_remove_mem_frontend:
+	dmx->remove_frontend(dmx, &vtunerc->mem_frontend);
+err_remove_hw_frontend:
+	dmx->remove_frontend(dmx, &vtunerc->hw_frontend);
+err_dvb_dmxdev_release:
+	dvb_dmxdev_release(&vtunerc->dmxdev);
+err_dvb_dmx_release:
+	dvb_dmx_release(dvbdemux);
+err_dvb_unregister_adapter:
+	dvb_unregister_adapter(&vtunerc->dvb_adapter);
+err_kfree:
+	kfree(vtunerc);
+	goto out;
+}
+
+static void __exit vtunerc_exit(void)
+{
+	struct dvb_demux *dvbdemux;
+	struct dmx_demux *dmx;
+	int idx;
+
+	vtunerc_unregister_ctrldev();
+
+	for (idx = 0; idx < adapters; idx++) {
+		struct vtunerc_ctx *vtunerc = vtunerc_tbl[idx];
+#ifdef CONFIG_PROC_FS
+		remove_proc_entry(vtunerc->procname, NULL);
+		kfree(vtunerc->procname);
+#endif
+
+		vtunerc_frontend_clear(vtunerc);
+
+		dvbdemux = &vtunerc->demux;
+		dmx = &dvbdemux->dmx;
+
+		dmx->disconnect_frontend(dmx);
+		dmx->remove_frontend(dmx, &vtunerc->mem_frontend);
+		dmx->remove_frontend(dmx, &vtunerc->hw_frontend);
+		dvb_dmxdev_release(&vtunerc->dmxdev);
+		dvb_dmx_release(dvbdemux);
+		dvb_unregister_adapter(&vtunerc->dvb_adapter);
+		kfree(vtunerc);
+	}
+
+	printk(MSGHEADER " unloaded successfully\n");
+}
+
+module_init(vtunerc_init);
+module_exit(vtunerc_exit);
+
+MODULE_AUTHOR("Honza Petrous");
+MODULE_DESCRIPTION("virtual DVB device");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(VTUNERC_MODULE_VERSION);
+
+module_param(adapters, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
+MODULE_PARM_DESC(adapters, "Number of virtual adapters (default is 1)");
+
diff -r a43a9e31be8b drivers/media/dvb/vtunerc/vtunerc_priv.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/media/dvb/vtunerc/vtunerc_priv.h	Sun Jun 19 01:55:52 2011 +0200
@@ -0,0 +1,100 @@
+/*
+ * vtunerc: Internal defines
+ *
+ * Copyright (C) 2010-11 Honza Petrous <jpetrous@smartimp.cz>
+ * [Created 2010-03-23]
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _VTUNERC_PRIV_H
+#define _VTUNERC_PRIV_H
+
+#include <linux/module.h>	/* Specifically, a module */
+#include <linux/kernel.h>	/* We're doing kernel work */
+#include <linux/cdev.h>
+
+#include "demux.h"
+#include "dmxdev.h"
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
+#include "dvb_net.h"
+#include "dvbdev.h"
+
+#include "vtuner.h"
+
+#define MAX_PIDTAB_LEN 30
+
+#define PID_UNKNOWN 0x0FFFF
+
+#define MAX_NUM_VTUNER_MODES 3
+
+struct vtunerc_ctx {
+
+	/* DVB api */
+	struct dmx_frontend hw_frontend;
+	struct dmx_frontend mem_frontend;
+	struct dmxdev dmxdev;
+	struct dmxdev dmxdev1;
+	struct dmxdev dmxdev2;
+	struct dvb_adapter dvb_adapter;
+	struct dvb_demux demux;
+	struct dvb_frontend *fe;
+	struct dvb_net dvbnet;
+	struct dvb_device *ca;
+
+	/* internals */
+	int idx;
+	char *name;
+	__u8 vtype;
+	struct dvb_frontend_info *feinfo;
+
+	unsigned short pidtab[MAX_PIDTAB_LEN];
+
+	struct semaphore xchange_sem;
+	struct semaphore ioctl_sem;
+	struct semaphore tswrite_sem;
+	int fd_opened;
+	int closing;
+
+	char *procname;
+
+	/* ctrldev */
+	char trail[188];
+	unsigned int trailsize;
+	int noresponse;
+	int num_modes;
+	char *ctypes[MAX_NUM_VTUNER_MODES];
+	struct vtuner_message ctrldev_request;
+	struct vtuner_message ctrldev_response;
+	wait_queue_head_t ctrldev_wait_request_wq;
+	wait_queue_head_t ctrldev_wait_response_wq;
+
+	/* proc statistics */
+	unsigned int stat_wr_data;
+	unsigned int stat_rd_data;
+	unsigned int stat_ctrl_sess;
+	unsigned short pidstat[MAX_PIDTAB_LEN];
+};
+
+int vtunerc_register_ctrldev(void);
+void vtunerc_unregister_ctrldev(void);
+struct vtunerc_ctx *vtunerc_get_ctx(int minor);
+int /*__devinit*/ vtunerc_frontend_init(struct vtunerc_ctx *ctx);
+int /*__devinit*/ vtunerc_frontend_clear(struct vtunerc_ctx *ctx);
+int vtunerc_ctrldev_xchange_message(struct vtunerc_ctx *ctx,
+					struct vtuner_message *msg,
+					int wait4response);
+
+#define PRINTK_ERR ""
+#define PRINTK_WARN ""
+#define PRINTK_NOTICE ""
+
+#endif
diff -r a43a9e31be8b drivers/media/dvb/vtunerc/vtunerc_proxyfe.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/media/dvb/vtunerc/vtunerc_proxyfe.c	Sun Jun 19 01:55:52 2011 +0200
@@ -0,0 +1,573 @@
+/*
+ * vtunerc: Driver for Proxy Frontend
+ *
+ * Copyright (C) 2010-11 Honza Petrous <jpetrous@smartimp.cz>
+ * [Inspired on proxy frontend by Emard <emard@softhome.net>]
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+#include "dvb_frontend.h"
+
+#include "vtunerc_priv.h"
+
+struct dvb_proxyfe_state {
+	struct dvb_frontend frontend;
+	struct vtunerc_ctx *vtunerc;
+};
+
+
+static int dvb_proxyfe_read_status(struct dvb_frontend *fe,
fe_status_t *status)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	msg.type = MSG_READ_STATUS;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	*status = msg.body.status;
+
+	return 0;
+}
+
+static int dvb_proxyfe_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	msg.type = MSG_READ_BER;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	*ber = msg.body.ber;
+
+	return 0;
+}
+
+static int dvb_proxyfe_read_signal_strength(struct dvb_frontend *fe,
+						u16 *strength)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	msg.type = MSG_READ_SIGNAL_STRENGTH;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	*strength = msg.body.ss;
+
+	return 0;
+}
+
+static int dvb_proxyfe_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	msg.type = MSG_READ_SNR;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	*snr = msg.body.snr;
+
+	return 0;
+}
+
+static int dvb_proxyfe_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	msg.type = MSG_READ_UCBLOCKS;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	*ucblocks = msg.body.ucb;
+
+	return 0;
+}
+
+static int dvb_proxyfe_get_frontend(struct dvb_frontend *fe,
+					struct dvb_frontend_parameters *p)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	msg.type = MSG_GET_FRONTEND;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	switch (vtunerc->vtype) {
+	case VT_S:
+	case VT_S2:
+		/*FIXME*/
+		{
+			struct dvb_qpsk_parameters *op = &p->u.qpsk;
+
+			op->symbol_rate = msg.body.fe_params.u.qpsk.symbol_rate;
+			op->fec_inner = msg.body.fe_params.u.qpsk.fec_inner;
+		}
+		break;
+	case VT_T:
+		{
+			struct dvb_ofdm_parameters *op = &p->u.ofdm;
+
+			op->bandwidth = msg.body.fe_params.u.ofdm.bandwidth;
+			op->code_rate_HP = msg.body.fe_params.u.ofdm.code_rate_HP;
+			op->code_rate_LP = msg.body.fe_params.u.ofdm.code_rate_LP;
+			op->constellation = msg.body.fe_params.u.ofdm.constellation;
+			op->transmission_mode = msg.body.fe_params.u.ofdm.transmission_mode;
+			op->guard_interval = msg.body.fe_params.u.ofdm.guard_interval;
+			op->hierarchy_information = msg.body.fe_params.u.ofdm.hierarchy_information;
+		}
+		break;
+	case VT_C:
+		/*FIXME*/
+		break;
+	default:
+		printk(PRINTK_ERR "%s unregognized tuner vtype = %d\n", __func__,
vtunerc->vtype);
+		return -EINVAL;
+	}
+	p->frequency = msg.body.fe_params.frequency;
+	p->inversion = msg.body.fe_params.inversion;
+	return 0;
+}
+
+static int dvb_proxyfe_set_frontend(struct dvb_frontend *fe,
+					struct dvb_frontend_parameters *p)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	memset(&msg, 0, sizeof(msg));
+	msg.body.fe_params.frequency = p->frequency;
+	msg.body.fe_params.inversion = p->inversion;
+
+	switch (vtunerc->vtype) {
+	case VT_S:
+	case VT_S2:
+		{
+			struct dvb_qpsk_parameters *op = &p->u.qpsk;
+#if HAVE_DVB_API_VERSION >= 5
+			struct dtv_frontend_properties *props = &fe->dtv_property_cache;
+#endif
+
+			msg.body.fe_params.u.qpsk.symbol_rate = op->symbol_rate;
+			msg.body.fe_params.u.qpsk.fec_inner = op->fec_inner;
+
+#if HAVE_DVB_API_VERSION >= 5
+			if (vtunerc->vtype == VT_S2 && props->delivery_system == SYS_DVBS2) {
+				/* DELIVERY SYSTEM: S2 delsys in use */
+				msg.body.fe_params.u.qpsk.fec_inner = 9;
+
+				/* MODULATION */
+				if (props->modulation == PSK_8)
+					/* signal PSK_8 modulation used */
+					msg.body.fe_params.u.qpsk.fec_inner += 9;
+
+				/* FEC */
+				switch (props->fec_inner) {
+				case FEC_1_2:
+					msg.body.fe_params.u.qpsk.fec_inner += 1;
+					break;
+				case FEC_2_3:
+					msg.body.fe_params.u.qpsk.fec_inner += 2;
+					break;
+				case FEC_3_4:
+					msg.body.fe_params.u.qpsk.fec_inner += 3;
+					break;
+				case FEC_4_5:
+					msg.body.fe_params.u.qpsk.fec_inner += 8;
+					break;
+				case FEC_5_6:
+					msg.body.fe_params.u.qpsk.fec_inner += 4;
+					break;
+				/*case FEC_6_7: // undefined
+					msg.body.fe_params.u.qpsk.fec_inner += 2;
+					break;*/
+				case FEC_7_8:
+					msg.body.fe_params.u.qpsk.fec_inner += 5;
+					break;
+				case FEC_8_9:
+					msg.body.fe_params.u.qpsk.fec_inner += 6;
+					break;
+				/*case FEC_AUTO: // undefined
+					msg.body.fe_params.u.qpsk.fec_inner += 2;
+					break;*/
+				case FEC_3_5:
+					msg.body.fe_params.u.qpsk.fec_inner += 7;
+					break;
+				case FEC_9_10:
+					msg.body.fe_params.u.qpsk.fec_inner += 9;
+					break;
+				default:
+					; /*FIXME: what now? */
+					break;
+				}
+
+				/* ROLLOFF */
+				switch (props->rolloff) {
+				case ROLLOFF_20:
+					msg.body.fe_params.inversion |= 0x08;
+					break;
+				case ROLLOFF_25:
+					msg.body.fe_params.inversion |= 0x04;
+					break;
+				case ROLLOFF_35:
+				default:
+					break;
+				}
+
+				/* PILOT */
+				switch (props->pilot) {
+				case PILOT_ON:
+					msg.body.fe_params.inversion |= 0x10;
+					break;
+				case PILOT_AUTO:
+					msg.body.fe_params.inversion |= 0x20;
+					break;
+				case PILOT_OFF:
+				default:
+					break;
+				}
+			}
+#endif /* HAVE_DVB_API_VERSION >= 5 */
+		}
+		break;
+	case VT_T:
+		{
+			struct dvb_ofdm_parameters *op = &p->u.ofdm;
+
+			msg.body.fe_params.u.ofdm.bandwidth = op->bandwidth;
+			msg.body.fe_params.u.ofdm.code_rate_HP = op->code_rate_HP;
+			msg.body.fe_params.u.ofdm.code_rate_LP = op->code_rate_LP;
+			msg.body.fe_params.u.ofdm.constellation = op->constellation;
+			msg.body.fe_params.u.ofdm.transmission_mode = op->transmission_mode;
+			msg.body.fe_params.u.ofdm.guard_interval = op->guard_interval;
+			msg.body.fe_params.u.ofdm.hierarchy_information = op->hierarchy_information;
+		}
+		break;
+	case VT_C:
+		/*TODO*/
+	default:
+		printk(PRINTK_ERR "%s: unregognized tuner vtype = %d\n", __func__,
+				vtunerc->vtype);
+		return -EINVAL;
+	}
+
+	msg.type = MSG_SET_FRONTEND;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	return 0;
+}
+
+#if HAVE_DVB_API_VERSION >= 5
+static int dvb_proxyfe_get_property(struct dvb_frontend *fe, struct
dtv_property* tvp)
+{
+	return 0;
+}
+
+static enum dvbfe_algo dvb_proxyfe_get_frontend_algo(struct dvb_frontend *fe)
+{
+	return DVBFE_ALGO_SW;
+}
+
+#endif /* HAVE_DVB_API_VERSION >= 5 */
+
+static int dvb_proxyfe_sleep(struct dvb_frontend *fe)
+{
+	return 0;
+}
+
+static int dvb_proxyfe_init(struct dvb_frontend *fe)
+{
+	return 0;
+}
+
+static int dvb_proxyfe_set_tone(struct dvb_frontend *fe,
fe_sec_tone_mode_t tone)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	msg.body.tone = tone;
+	msg.type = MSG_SET_TONE;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	return 0;
+}
+
+static int dvb_proxyfe_set_voltage(struct dvb_frontend *fe,
fe_sec_voltage_t voltage)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	msg.body.voltage = voltage;
+	msg.type = MSG_SET_VOLTAGE;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	return 0;
+}
+
+static int dvb_proxyfe_send_diseqc_msg(struct dvb_frontend *fe,
struct dvb_diseqc_master_cmd *cmd)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	memcpy(&msg.body.diseqc_master_cmd, cmd, sizeof(struct
dvb_diseqc_master_cmd));
+	msg.type = MSG_SEND_DISEQC_MSG;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	return 0;
+}
+
+static int dvb_proxyfe_send_diseqc_burst(struct dvb_frontend *fe,
fe_sec_mini_cmd_t burst)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+	struct vtunerc_ctx *vtunerc = state->vtunerc;
+	struct vtuner_message msg;
+
+	msg.body.burst = burst;
+	msg.type = MSG_SEND_DISEQC_BURST;
+	vtunerc_ctrldev_xchange_message(vtunerc, &msg, 1);
+
+	return 0;
+}
+
+static void dvb_proxyfe_release(struct dvb_frontend *fe)
+{
+	struct dvb_proxyfe_state *state = fe->demodulator_priv;
+
+	kfree(state);
+}
+
+static struct dvb_frontend_ops dvb_proxyfe_ofdm_ops;
+
+static struct dvb_frontend *dvb_proxyfe_ofdm_attach(struct
vtunerc_ctx *vtunerc)
+{
+	struct dvb_proxyfe_state *state = NULL;
+
+	/* allocate memory for the internal state */
+	state = kmalloc(sizeof(struct dvb_proxyfe_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+
+	/* create dvb_frontend */
+	memcpy(&state->frontend.ops, &dvb_proxyfe_ofdm_ops, sizeof(struct
dvb_frontend_ops));
+	state->frontend.demodulator_priv = state;
+	state->vtunerc = vtunerc;
+	return &state->frontend;
+
+error:
+	kfree(state);
+	return NULL;
+}
+
+static struct dvb_frontend_ops dvb_proxyfe_qpsk_ops;
+
+static struct dvb_frontend *dvb_proxyfe_qpsk_attach(struct
vtunerc_ctx *vtunerc, int can_2g_modulation)
+{
+	struct dvb_proxyfe_state *state = NULL;
+
+	/* allocate memory for the internal state */
+	state = kmalloc(sizeof(struct dvb_proxyfe_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+
+	/* create dvb_frontend */
+	memcpy(&state->frontend.ops, &dvb_proxyfe_qpsk_ops, sizeof(struct
dvb_frontend_ops));
+#if HAVE_DVB_API_VERSION >= 5
+	if (can_2g_modulation) {
+		state->frontend.ops.info.caps |= FE_CAN_2G_MODULATION;
+		strcpy(state->frontend.ops.info.name, "vTuner proxyFE DVB-S2");
+	}
+#endif
+	state->frontend.demodulator_priv = state;
+	state->vtunerc = vtunerc;
+	return &state->frontend;
+
+error:
+	kfree(state);
+	return NULL;
+}
+
+static struct dvb_frontend_ops dvb_proxyfe_qam_ops;
+
+static struct dvb_frontend *dvb_proxyfe_qam_attach(struct vtunerc_ctx *vtunerc)
+{
+	struct dvb_proxyfe_state *state = NULL;
+
+	/* allocate memory for the internal state */
+	state = kmalloc(sizeof(struct dvb_proxyfe_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+
+	/* create dvb_frontend */
+	memcpy(&state->frontend.ops, &dvb_proxyfe_qam_ops, sizeof(struct
dvb_frontend_ops));
+	state->frontend.demodulator_priv = state;
+	state->vtunerc = vtunerc;
+	return &state->frontend;
+
+error:
+	kfree(state);
+	return NULL;
+}
+
+static struct dvb_frontend_ops dvb_proxyfe_ofdm_ops = {
+
+	.info = {
+		.name			= "vTuner proxyFE DVB-T",
+		.type			= FE_OFDM,
+		.frequency_min		= 51000000,
+		.frequency_max		= 863250000,
+		.frequency_stepsize	= 62500,
+		.caps = FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+				FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
+				FE_CAN_FEC_7_8 | FE_CAN_FEC_8_9 | FE_CAN_FEC_AUTO |
+				FE_CAN_QAM_16 | FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
+				FE_CAN_TRANSMISSION_MODE_AUTO |
+				FE_CAN_GUARD_INTERVAL_AUTO |
+				FE_CAN_HIERARCHY_AUTO,
+	},
+
+	.release = dvb_proxyfe_release,
+
+	.init = dvb_proxyfe_init,
+	.sleep = dvb_proxyfe_sleep,
+
+	.set_frontend = dvb_proxyfe_set_frontend,
+	.get_frontend = dvb_proxyfe_get_frontend,
+
+	.read_status = dvb_proxyfe_read_status,
+	.read_ber = dvb_proxyfe_read_ber,
+	.read_signal_strength = dvb_proxyfe_read_signal_strength,
+	.read_snr = dvb_proxyfe_read_snr,
+	.read_ucblocks = dvb_proxyfe_read_ucblocks,
+};
+
+static struct dvb_frontend_ops dvb_proxyfe_qam_ops = {
+
+	.info = {
+		.name			= "vTuner proxyFE DVB-C",
+		.type			= FE_QAM,
+		.frequency_stepsize	= 62500,
+		.frequency_min		= 51000000,
+		.frequency_max		= 858000000,
+		.symbol_rate_min	= (57840000/2)/64,     /* SACLK/64 == (XIN/2)/64 */
+		.symbol_rate_max	= (57840000/2)/4,      /* SACLK/4 */
+		.caps = FE_CAN_QAM_16 | FE_CAN_QAM_32 | FE_CAN_QAM_64 |
+			FE_CAN_QAM_128 | FE_CAN_QAM_256 |
+			FE_CAN_FEC_AUTO | FE_CAN_INVERSION_AUTO
+	},
+
+	.release = dvb_proxyfe_release,
+
+	.init = dvb_proxyfe_init,
+	.sleep = dvb_proxyfe_sleep,
+
+	.set_frontend = dvb_proxyfe_set_frontend,
+	.get_frontend = dvb_proxyfe_get_frontend,
+
+	.read_status = dvb_proxyfe_read_status,
+	.read_ber = dvb_proxyfe_read_ber,
+	.read_signal_strength = dvb_proxyfe_read_signal_strength,
+	.read_snr = dvb_proxyfe_read_snr,
+	.read_ucblocks = dvb_proxyfe_read_ucblocks,
+};
+
+static struct dvb_frontend_ops dvb_proxyfe_qpsk_ops = {
+
+	.info = {
+		.name			= "vTuner proxyFE DVB-S",
+		.type			= FE_QPSK,
+		.frequency_min		= 950000,
+		.frequency_max		= 2150000,
+		.frequency_stepsize	= 250,           /* kHz for QPSK frontends */
+		.frequency_tolerance	= 29500,
+		.symbol_rate_min	= 1000000,
+		.symbol_rate_max	= 45000000,
+		.caps = FE_CAN_INVERSION_AUTO |
+			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
+			FE_CAN_QPSK
+	},
+
+	.release = dvb_proxyfe_release,
+
+	.init = dvb_proxyfe_init,
+	.sleep = dvb_proxyfe_sleep,
+
+	.get_frontend = dvb_proxyfe_get_frontend,
+#if HAVE_DVB_API_VERSION >= 5
+	.get_property = dvb_proxyfe_get_property,
+	.get_frontend_algo = dvb_proxyfe_get_frontend_algo,
+	.set_frontend = dvb_proxyfe_set_frontend,
+#else
+	.set_frontend = dvb_proxyfe_set_frontend,
+#endif
+
+	.read_status = dvb_proxyfe_read_status,
+	.read_ber = dvb_proxyfe_read_ber,
+	.read_signal_strength = dvb_proxyfe_read_signal_strength,
+	.read_snr = dvb_proxyfe_read_snr,
+	.read_ucblocks = dvb_proxyfe_read_ucblocks,
+
+	.set_voltage = dvb_proxyfe_set_voltage,
+	.set_tone = dvb_proxyfe_set_tone,
+
+	.diseqc_send_master_cmd         = dvb_proxyfe_send_diseqc_msg,
+	.diseqc_send_burst              = dvb_proxyfe_send_diseqc_burst,
+
+};
+
+int /*__devinit*/ vtunerc_frontend_init(struct vtunerc_ctx *vtunerc)
+{
+	int ret;
+
+	if (vtunerc->fe) {
+		printk(PRINTK_NOTICE "%s: FE already initialized as type=%d\n",
__func__, vtunerc->vtype);
+		return 0;
+	}
+
+	switch (vtunerc->vtype) {
+	case VT_S:
+		vtunerc->fe = dvb_proxyfe_qpsk_attach(vtunerc, 0);
+		break;
+	case VT_S2:
+		vtunerc->fe = dvb_proxyfe_qpsk_attach(vtunerc, 1);
+		break;
+	case VT_T:
+		vtunerc->fe = dvb_proxyfe_ofdm_attach(vtunerc);
+		break;
+	case VT_C:
+		vtunerc->fe = dvb_proxyfe_qam_attach(vtunerc);
+		break;
+	default:
+		printk(PRINTK_ERR "%s unregognized tuner vtype = %d\n", __func__,
vtunerc->vtype);
+		return -EINVAL;
+	}
+	ret = dvb_register_frontend(&vtunerc->dvb_adapter, vtunerc->fe);
+
+	return 0;
+}
+
+int /*__devinit*/ vtunerc_frontend_clear(struct vtunerc_ctx *vtunerc)
+{
+	return vtunerc->fe ? dvb_unregister_frontend(vtunerc->fe) : 0;
+}
