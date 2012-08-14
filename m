Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537Ab2HNUzm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 16:55:42 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7EKtgLw019034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 16:55:42 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 07/12] [media] move parallel port/isa video drivers to drivers/media/parport/
Date: Tue, 14 Aug 2012 17:55:22 -0300
Message-Id: <1344977727-16319-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344977727-16319-1-git-send-email-mchehab@redhat.com>
References: <1344977727-16319-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should keep just the I2C drivers under drivers/media/video, and
then rename it to drivers/media/i2c.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig           |    1 +
 drivers/media/Makefile          |    8 +-
 drivers/media/parport/Kconfig   |   47 ++
 drivers/media/parport/Makefile  |    4 +
 drivers/media/parport/bw-qcam.c | 1113 +++++++++++++++++++++++++++++++++++++
 drivers/media/parport/c-qcam.c  |  883 ++++++++++++++++++++++++++++++
 drivers/media/parport/pms.c     | 1152 +++++++++++++++++++++++++++++++++++++++
 drivers/media/parport/w9966.c   |  981 +++++++++++++++++++++++++++++++++
 drivers/media/video/Kconfig     |   61 ---
 drivers/media/video/Makefile    |    4 -
 drivers/media/video/bw-qcam.c   | 1113 -------------------------------------
 drivers/media/video/c-qcam.c    |  883 ------------------------------
 drivers/media/video/pms.c       | 1152 ---------------------------------------
 drivers/media/video/w9966.c     |  981 ---------------------------------
 14 files changed, 4185 insertions(+), 4198 deletions(-)
 create mode 100644 drivers/media/parport/Kconfig
 create mode 100644 drivers/media/parport/Makefile
 create mode 100644 drivers/media/parport/bw-qcam.c
 create mode 100644 drivers/media/parport/c-qcam.c
 create mode 100644 drivers/media/parport/pms.c
 create mode 100644 drivers/media/parport/w9966.c
 delete mode 100644 drivers/media/video/bw-qcam.c
 delete mode 100644 drivers/media/video/c-qcam.c
 delete mode 100644 drivers/media/video/pms.c
 delete mode 100644 drivers/media/video/w9966.c

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 7970c24..c6d8658 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -164,6 +164,7 @@ source "drivers/media/dvb-core/Kconfig"
 source "drivers/media/pci/Kconfig"
 source "drivers/media/usb/Kconfig"
 source "drivers/media/mmc/Kconfig"
+source "drivers/media/parport/Kconfig"
 
 comment "Supported FireWire (IEEE 1394) Adapters"
 	depends on DVB_CORE && FIREWIRE
diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 3265a9a..360c44d 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -8,8 +8,8 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
   obj-$(CONFIG_MEDIA_SUPPORT) += media.o
 endif
 
-obj-y += v4l2-core/ tuners/ common/ rc/ video/
+obj-y += tuners/ common/ rc/ video/
+obj-y += pci/ usb/ mmc/ firewire/ parport/
 
-obj-$(CONFIG_VIDEO_DEV) += radio/
-obj-$(CONFIG_DVB_CORE)  += dvb-core/ pci/ dvb-frontends/ usb/ mmc/
-obj-$(CONFIG_DVB_FIREDTV) += firewire/
+obj-$(CONFIG_VIDEO_DEV) += radio/ v4l2-core/
+obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb-frontends/
diff --git a/drivers/media/parport/Kconfig b/drivers/media/parport/Kconfig
new file mode 100644
index 0000000..48138fe
--- /dev/null
+++ b/drivers/media/parport/Kconfig
@@ -0,0 +1,47 @@
+menu "V4L ISA and parallel port devices"
+	visible if (ISA || PARPORT) && MEDIA_CAMERA_SUPPORT
+
+config VIDEO_BWQCAM
+	tristate "Quickcam BW Video For Linux"
+	depends on PARPORT && VIDEO_V4L2
+	help
+	  Say Y have if you the black and white version of the QuickCam
+	  camera. See the next option for the color version.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called bw-qcam.
+
+config VIDEO_CQCAM
+	tristate "QuickCam Colour Video For Linux"
+	depends on PARPORT && VIDEO_V4L2
+	help
+	  This is the video4linux driver for the colour version of the
+	  Connectix QuickCam.  If you have one of these cameras, say Y here,
+	  otherwise say N.  This driver does not work with the original
+	  monochrome QuickCam, QuickCam VC or QuickClip.  It is also available
+	  as a module (c-qcam).
+	  Read <file:Documentation/video4linux/CQcam.txt> for more information.
+
+config VIDEO_PMS
+	tristate "Mediavision Pro Movie Studio Video For Linux"
+	depends on ISA && VIDEO_V4L2
+	help
+	  Say Y if you have the ISA Mediavision Pro Movie Studio
+	  capture card.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pms.
+
+config VIDEO_W9966
+	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux"
+	depends on PARPORT_1284 && PARPORT && VIDEO_V4L2
+	help
+	  Video4linux driver for Winbond's w9966 based Webcams.
+	  Currently tested with the LifeView FlyCam Supra.
+	  If you have one of these cameras, say Y here
+	  otherwise say N.
+	  This driver is also available as a module (w9966).
+
+	  Check out <file:Documentation/video4linux/w9966.txt> for more
+	  information.
+endmenu
diff --git a/drivers/media/parport/Makefile b/drivers/media/parport/Makefile
new file mode 100644
index 0000000..4eea06d
--- /dev/null
+++ b/drivers/media/parport/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_VIDEO_CQCAM) += c-qcam.o
+obj-$(CONFIG_VIDEO_BWQCAM) += bw-qcam.o
+obj-$(CONFIG_VIDEO_W9966) += w9966.o
+obj-$(CONFIG_VIDEO_PMS) += pms.o
diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
new file mode 100644
index 0000000..5b75a64
--- /dev/null
+++ b/drivers/media/parport/bw-qcam.c
@@ -0,0 +1,1113 @@
+/*
+ *    QuickCam Driver For Video4Linux.
+ *
+ *	Video4Linux conversion work by Alan Cox.
+ *	Parport compatibility by Phil Blundell.
+ *	Busy loop avoidance by Mark Cooke.
+ *
+ *    Module parameters:
+ *
+ *	maxpoll=<1 - 5000>
+ *
+ *	  When polling the QuickCam for a response, busy-wait for a
+ *	  maximum of this many loops. The default of 250 gives little
+ *	  impact on interactive response.
+ *
+ *	  NOTE: If this parameter is set too high, the processor
+ *		will busy wait until this loop times out, and then
+ *		slowly poll for a further 5 seconds before failing
+ *		the transaction. You have been warned.
+ *
+ *	yieldlines=<1 - 250>
+ *
+ *	  When acquiring a frame from the camera, the data gathering
+ *	  loop will yield back to the scheduler after completing
+ *	  this many lines. The default of 4 provides a trade-off
+ *	  between increased frame acquisition time and impact on
+ *	  interactive response.
+ */
+
+/* qcam-lib.c -- Library for programming with the Connectix QuickCam.
+ * See the included documentation for usage instructions and details
+ * of the protocol involved. */
+
+
+/* Version 0.5, August 4, 1996 */
+/* Version 0.7, August 27, 1996 */
+/* Version 0.9, November 17, 1996 */
+
+
+/******************************************************************
+
+Copyright (C) 1996 by Scott Laird
+
+Permission is hereby granted, free of charge, to any person obtaining
+a copy of this software and associated documentation files (the
+"Software"), to deal in the Software without restriction, including
+without limitation the rights to use, copy, modify, merge, publish,
+distribute, sublicense, and/or sell copies of the Software, and to
+permit persons to whom the Software is furnished to do so, subject to
+the following conditions:
+
+The above copyright notice and this permission notice shall be
+included in all copies or substantial portions of the Software.
+
+THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
+IN NO EVENT SHALL SCOTT LAIRD BE LIABLE FOR ANY CLAIM, DAMAGES OR
+OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+OTHER DEALINGS IN THE SOFTWARE.
+
+******************************************************************/
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/parport.h>
+#include <linux/sched.h>
+#include <linux/videodev2.h>
+#include <linux/mutex.h>
+#include <asm/uaccess.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+
+/* One from column A... */
+#define QC_NOTSET 0
+#define QC_UNIDIR 1
+#define QC_BIDIR  2
+#define QC_SERIAL 3
+
+/* ... and one from column B */
+#define QC_ANY          0x00
+#define QC_FORCE_UNIDIR 0x10
+#define QC_FORCE_BIDIR  0x20
+#define QC_FORCE_SERIAL 0x30
+/* in the port_mode member */
+
+#define QC_MODE_MASK    0x07
+#define QC_FORCE_MASK   0x70
+
+#define MAX_HEIGHT 243
+#define MAX_WIDTH 336
+
+/* Bit fields for status flags */
+#define QC_PARAM_CHANGE	0x01 /* Camera status change has occurred */
+
+struct qcam {
+	struct v4l2_device v4l2_dev;
+	struct video_device vdev;
+	struct v4l2_ctrl_handler hdl;
+	struct pardevice *pdev;
+	struct parport *pport;
+	struct mutex lock;
+	int width, height;
+	int bpp;
+	int mode;
+	int contrast, brightness, whitebal;
+	int port_mode;
+	int transfer_scale;
+	int top, left;
+	int status;
+	unsigned int saved_bits;
+	unsigned long in_use;
+};
+
+static unsigned int maxpoll = 250;   /* Maximum busy-loop count for qcam I/O */
+static unsigned int yieldlines = 4;  /* Yield after this many during capture */
+static int video_nr = -1;
+static unsigned int force_init;		/* Whether to probe aggressively */
+
+module_param(maxpoll, int, 0);
+module_param(yieldlines, int, 0);
+module_param(video_nr, int, 0);
+
+/* Set force_init=1 to avoid detection by polling status register and
+ * immediately attempt to initialize qcam */
+module_param(force_init, int, 0);
+
+#define MAX_CAMS 4
+static struct qcam *qcams[MAX_CAMS];
+static unsigned int num_cams;
+
+static inline int read_lpstatus(struct qcam *q)
+{
+	return parport_read_status(q->pport);
+}
+
+static inline int read_lpdata(struct qcam *q)
+{
+	return parport_read_data(q->pport);
+}
+
+static inline void write_lpdata(struct qcam *q, int d)
+{
+	parport_write_data(q->pport, d);
+}
+
+static void write_lpcontrol(struct qcam *q, int d)
+{
+	if (d & 0x20) {
+		/* Set bidirectional mode to reverse (data in) */
+		parport_data_reverse(q->pport);
+	} else {
+		/* Set bidirectional mode to forward (data out) */
+		parport_data_forward(q->pport);
+	}
+
+	/* Now issue the regular port command, but strip out the
+	 * direction flag */
+	d &= ~0x20;
+	parport_write_control(q->pport, d);
+}
+
+
+/* qc_waithand busy-waits for a handshake signal from the QuickCam.
+ * Almost all communication with the camera requires handshaking. */
+
+static int qc_waithand(struct qcam *q, int val)
+{
+	int status;
+	int runs = 0;
+
+	if (val) {
+		while (!((status = read_lpstatus(q)) & 8)) {
+			/* 1000 is enough spins on the I/O for all normal
+			   cases, at that point we start to poll slowly
+			   until the camera wakes up. However, we are
+			   busy blocked until the camera responds, so
+			   setting it lower is much better for interactive
+			   response. */
+
+			if (runs++ > maxpoll)
+				msleep_interruptible(5);
+			if (runs > (maxpoll + 1000)) /* 5 seconds */
+				return -1;
+		}
+	} else {
+		while (((status = read_lpstatus(q)) & 8)) {
+			/* 1000 is enough spins on the I/O for all normal
+			   cases, at that point we start to poll slowly
+			   until the camera wakes up. However, we are
+			   busy blocked until the camera responds, so
+			   setting it lower is much better for interactive
+			   response. */
+
+			if (runs++ > maxpoll)
+				msleep_interruptible(5);
+			if (runs++ > (maxpoll + 1000)) /* 5 seconds */
+				return -1;
+		}
+	}
+
+	return status;
+}
+
+/* Waithand2 is used when the qcam is in bidirectional mode, and the
+ * handshaking signal is CamRdy2 (bit 0 of data reg) instead of CamRdy1
+ * (bit 3 of status register).  It also returns the last value read,
+ * since this data is useful. */
+
+static unsigned int qc_waithand2(struct qcam *q, int val)
+{
+	unsigned int status;
+	int runs = 0;
+
+	do {
+		status = read_lpdata(q);
+		/* 1000 is enough spins on the I/O for all normal
+		   cases, at that point we start to poll slowly
+		   until the camera wakes up. However, we are
+		   busy blocked until the camera responds, so
+		   setting it lower is much better for interactive
+		   response. */
+
+		if (runs++ > maxpoll)
+			msleep_interruptible(5);
+		if (runs++ > (maxpoll + 1000)) /* 5 seconds */
+			return 0;
+	} while ((status & 1) != val);
+
+	return status;
+}
+
+/* qc_command is probably a bit of a misnomer -- it's used to send
+ * bytes *to* the camera.  Generally, these bytes are either commands
+ * or arguments to commands, so the name fits, but it still bugs me a
+ * bit.  See the documentation for a list of commands. */
+
+static int qc_command(struct qcam *q, int command)
+{
+	int n1, n2;
+	int cmd;
+
+	write_lpdata(q, command);
+	write_lpcontrol(q, 6);
+
+	n1 = qc_waithand(q, 1);
+
+	write_lpcontrol(q, 0xe);
+	n2 = qc_waithand(q, 0);
+
+	cmd = (n1 & 0xf0) | ((n2 & 0xf0) >> 4);
+	return cmd;
+}
+
+static int qc_readparam(struct qcam *q)
+{
+	int n1, n2;
+	int cmd;
+
+	write_lpcontrol(q, 6);
+	n1 = qc_waithand(q, 1);
+
+	write_lpcontrol(q, 0xe);
+	n2 = qc_waithand(q, 0);
+
+	cmd = (n1 & 0xf0) | ((n2 & 0xf0) >> 4);
+	return cmd;
+}
+
+
+/* Try to detect a QuickCam.  It appears to flash the upper 4 bits of
+   the status register at 5-10 Hz.  This is only used in the autoprobe
+   code.  Be aware that this isn't the way Connectix detects the
+   camera (they send a reset and try to handshake), but this should be
+   almost completely safe, while their method screws up my printer if
+   I plug it in before the camera. */
+
+static int qc_detect(struct qcam *q)
+{
+	int reg, lastreg;
+	int count = 0;
+	int i;
+
+	if (force_init)
+		return 1;
+
+	lastreg = reg = read_lpstatus(q) & 0xf0;
+
+	for (i = 0; i < 500; i++) {
+		reg = read_lpstatus(q) & 0xf0;
+		if (reg != lastreg)
+			count++;
+		lastreg = reg;
+		mdelay(2);
+	}
+
+
+#if 0
+	/* Force camera detection during testing. Sometimes the camera
+	   won't be flashing these bits. Possibly unloading the module
+	   in the middle of a grab? Or some timeout condition?
+	   I've seen this parameter as low as 19 on my 450Mhz box - mpc */
+	printk(KERN_DEBUG "Debugging: QCam detection counter <30-200 counts as detected>: %d\n", count);
+	return 1;
+#endif
+
+	/* Be (even more) liberal in what you accept...  */
+
+	if (count > 20 && count < 400) {
+		return 1;	/* found */
+	} else {
+		printk(KERN_ERR "No Quickcam found on port %s\n",
+				q->pport->name);
+		printk(KERN_DEBUG "Quickcam detection counter: %u\n", count);
+		return 0;	/* not found */
+	}
+}
+
+/* Decide which scan mode to use.  There's no real requirement that
+ * the scanmode match the resolution in q->height and q-> width -- the
+ * camera takes the picture at the resolution specified in the
+ * "scanmode" and then returns the image at the resolution specified
+ * with the resolution commands.  If the scan is bigger than the
+ * requested resolution, the upper-left hand corner of the scan is
+ * returned.  If the scan is smaller, then the rest of the image
+ * returned contains garbage. */
+
+static int qc_setscanmode(struct qcam *q)
+{
+	int old_mode = q->mode;
+
+	switch (q->transfer_scale) {
+	case 1:
+		q->mode = 0;
+		break;
+	case 2:
+		q->mode = 4;
+		break;
+	case 4:
+		q->mode = 8;
+		break;
+	}
+
+	switch (q->bpp) {
+	case 4:
+		break;
+	case 6:
+		q->mode += 2;
+		break;
+	}
+
+	switch (q->port_mode & QC_MODE_MASK) {
+	case QC_BIDIR:
+		q->mode += 1;
+		break;
+	case QC_NOTSET:
+	case QC_UNIDIR:
+		break;
+	}
+
+	if (q->mode != old_mode)
+		q->status |= QC_PARAM_CHANGE;
+
+	return 0;
+}
+
+
+/* Reset the QuickCam.  This uses the same sequence the Windows
+ * QuickPic program uses.  Someone with a bi-directional port should
+ * check that bi-directional mode is detected right, and then
+ * implement bi-directional mode in qc_readbyte(). */
+
+static void qc_reset(struct qcam *q)
+{
+	switch (q->port_mode & QC_FORCE_MASK) {
+	case QC_FORCE_UNIDIR:
+		q->port_mode = (q->port_mode & ~QC_MODE_MASK) | QC_UNIDIR;
+		break;
+
+	case QC_FORCE_BIDIR:
+		q->port_mode = (q->port_mode & ~QC_MODE_MASK) | QC_BIDIR;
+		break;
+
+	case QC_ANY:
+		write_lpcontrol(q, 0x20);
+		write_lpdata(q, 0x75);
+
+		if (read_lpdata(q) != 0x75)
+			q->port_mode = (q->port_mode & ~QC_MODE_MASK) | QC_BIDIR;
+		else
+			q->port_mode = (q->port_mode & ~QC_MODE_MASK) | QC_UNIDIR;
+		break;
+	}
+
+	write_lpcontrol(q, 0xb);
+	udelay(250);
+	write_lpcontrol(q, 0xe);
+	qc_setscanmode(q);		/* in case port_mode changed */
+}
+
+
+
+/* Reset the QuickCam and program for brightness, contrast,
+ * white-balance, and resolution. */
+
+static void qc_set(struct qcam *q)
+{
+	int val;
+	int val2;
+
+	qc_reset(q);
+
+	/* Set the brightness.  Yes, this is repetitive, but it works.
+	 * Shorter versions seem to fail subtly.  Feel free to try :-). */
+	/* I think the problem was in qc_command, not here -- bls */
+
+	qc_command(q, 0xb);
+	qc_command(q, q->brightness);
+
+	val = q->height / q->transfer_scale;
+	qc_command(q, 0x11);
+	qc_command(q, val);
+	if ((q->port_mode & QC_MODE_MASK) == QC_UNIDIR && q->bpp == 6) {
+		/* The normal "transfers per line" calculation doesn't seem to work
+		   as expected here (and yet it works fine in qc_scan).  No idea
+		   why this case is the odd man out.  Fortunately, Laird's original
+		   working version gives me a good way to guess at working values.
+		   -- bls */
+		val = q->width;
+		val2 = q->transfer_scale * 4;
+	} else {
+		val = q->width * q->bpp;
+		val2 = (((q->port_mode & QC_MODE_MASK) == QC_BIDIR) ? 24 : 8) *
+			q->transfer_scale;
+	}
+	val = DIV_ROUND_UP(val, val2);
+	qc_command(q, 0x13);
+	qc_command(q, val);
+
+	/* Setting top and left -- bls */
+	qc_command(q, 0xd);
+	qc_command(q, q->top);
+	qc_command(q, 0xf);
+	qc_command(q, q->left / 2);
+
+	qc_command(q, 0x19);
+	qc_command(q, q->contrast);
+	qc_command(q, 0x1f);
+	qc_command(q, q->whitebal);
+
+	/* Clear flag that we must update the grabbing parameters on the camera
+	   before we grab the next frame */
+	q->status &= (~QC_PARAM_CHANGE);
+}
+
+/* Qc_readbytes reads some bytes from the QC and puts them in
+   the supplied buffer.  It returns the number of bytes read,
+   or -1 on error. */
+
+static inline int qc_readbytes(struct qcam *q, char buffer[])
+{
+	int ret = 1;
+	unsigned int hi, lo;
+	unsigned int hi2, lo2;
+	static int state;
+
+	if (buffer == NULL) {
+		state = 0;
+		return 0;
+	}
+
+	switch (q->port_mode & QC_MODE_MASK) {
+	case QC_BIDIR:		/* Bi-directional Port */
+		write_lpcontrol(q, 0x26);
+		lo = (qc_waithand2(q, 1) >> 1);
+		hi = (read_lpstatus(q) >> 3) & 0x1f;
+		write_lpcontrol(q, 0x2e);
+		lo2 = (qc_waithand2(q, 0) >> 1);
+		hi2 = (read_lpstatus(q) >> 3) & 0x1f;
+		switch (q->bpp) {
+		case 4:
+			buffer[0] = lo & 0xf;
+			buffer[1] = ((lo & 0x70) >> 4) | ((hi & 1) << 3);
+			buffer[2] = (hi & 0x1e) >> 1;
+			buffer[3] = lo2 & 0xf;
+			buffer[4] = ((lo2 & 0x70) >> 4) | ((hi2 & 1) << 3);
+			buffer[5] = (hi2 & 0x1e) >> 1;
+			ret = 6;
+			break;
+		case 6:
+			buffer[0] = lo & 0x3f;
+			buffer[1] = ((lo & 0x40) >> 6) | (hi << 1);
+			buffer[2] = lo2 & 0x3f;
+			buffer[3] = ((lo2 & 0x40) >> 6) | (hi2 << 1);
+			ret = 4;
+			break;
+		}
+		break;
+
+	case QC_UNIDIR:	/* Unidirectional Port */
+		write_lpcontrol(q, 6);
+		lo = (qc_waithand(q, 1) & 0xf0) >> 4;
+		write_lpcontrol(q, 0xe);
+		hi = (qc_waithand(q, 0) & 0xf0) >> 4;
+
+		switch (q->bpp) {
+		case 4:
+			buffer[0] = lo;
+			buffer[1] = hi;
+			ret = 2;
+			break;
+		case 6:
+			switch (state) {
+			case 0:
+				buffer[0] = (lo << 2) | ((hi & 0xc) >> 2);
+				q->saved_bits = (hi & 3) << 4;
+				state = 1;
+				ret = 1;
+				break;
+			case 1:
+				buffer[0] = lo | q->saved_bits;
+				q->saved_bits = hi << 2;
+				state = 2;
+				ret = 1;
+				break;
+			case 2:
+				buffer[0] = ((lo & 0xc) >> 2) | q->saved_bits;
+				buffer[1] = ((lo & 3) << 4) | hi;
+				state = 0;
+				ret = 2;
+				break;
+			}
+			break;
+		}
+		break;
+	}
+	return ret;
+}
+
+/* requests a scan from the camera.  It sends the correct instructions
+ * to the camera and then reads back the correct number of bytes.  In
+ * previous versions of this routine the return structure contained
+ * the raw output from the camera, and there was a 'qc_convertscan'
+ * function that converted that to a useful format.  In version 0.3 I
+ * rolled qc_convertscan into qc_scan and now I only return the
+ * converted scan.  The format is just an one-dimensional array of
+ * characters, one for each pixel, with 0=black up to n=white, where
+ * n=2^(bit depth)-1.  Ask me for more details if you don't understand
+ * this. */
+
+static long qc_capture(struct qcam *q, char __user *buf, unsigned long len)
+{
+	int i, j, k, yield;
+	int bytes;
+	int linestotrans, transperline;
+	int divisor;
+	int pixels_per_line;
+	int pixels_read = 0;
+	int got = 0;
+	char buffer[6];
+	int  shift = 8 - q->bpp;
+	char invert;
+
+	if (q->mode == -1)
+		return -ENXIO;
+
+	qc_command(q, 0x7);
+	qc_command(q, q->mode);
+
+	if ((q->port_mode & QC_MODE_MASK) == QC_BIDIR) {
+		write_lpcontrol(q, 0x2e);	/* turn port around */
+		write_lpcontrol(q, 0x26);
+		qc_waithand(q, 1);
+		write_lpcontrol(q, 0x2e);
+		qc_waithand(q, 0);
+	}
+
+	/* strange -- should be 15:63 below, but 4bpp is odd */
+	invert = (q->bpp == 4) ? 16 : 63;
+
+	linestotrans = q->height / q->transfer_scale;
+	pixels_per_line = q->width / q->transfer_scale;
+	transperline = q->width * q->bpp;
+	divisor = (((q->port_mode & QC_MODE_MASK) == QC_BIDIR) ? 24 : 8) *
+		q->transfer_scale;
+	transperline = DIV_ROUND_UP(transperline, divisor);
+
+	for (i = 0, yield = yieldlines; i < linestotrans; i++) {
+		for (pixels_read = j = 0; j < transperline; j++) {
+			bytes = qc_readbytes(q, buffer);
+			for (k = 0; k < bytes && (pixels_read + k) < pixels_per_line; k++) {
+				int o;
+				if (buffer[k] == 0 && invert == 16) {
+					/* 4bpp is odd (again) -- inverter is 16, not 15, but output
+					   must be 0-15 -- bls */
+					buffer[k] = 16;
+				}
+				o = i * pixels_per_line + pixels_read + k;
+				if (o < len) {
+					u8 ch = invert - buffer[k];
+					got++;
+					put_user(ch << shift, buf + o);
+				}
+			}
+			pixels_read += bytes;
+		}
+		qc_readbytes(q, NULL);	/* reset state machine */
+
+		/* Grabbing an entire frame from the quickcam is a lengthy
+		   process. We don't (usually) want to busy-block the
+		   processor for the entire frame. yieldlines is a module
+		   parameter. If we yield every line, the minimum frame
+		   time will be 240 / 200 = 1.2 seconds. The compile-time
+		   default is to yield every 4 lines. */
+		if (i >= yield) {
+			msleep_interruptible(5);
+			yield = i + yieldlines;
+		}
+	}
+
+	if ((q->port_mode & QC_MODE_MASK) == QC_BIDIR) {
+		write_lpcontrol(q, 2);
+		write_lpcontrol(q, 6);
+		udelay(3);
+		write_lpcontrol(q, 0xe);
+	}
+	if (got < len)
+		return got;
+	return len;
+}
+
+/*
+ *	Video4linux interfacing
+ */
+
+static int qcam_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *vcap)
+{
+	struct qcam *qcam = video_drvdata(file);
+
+	strlcpy(vcap->driver, qcam->v4l2_dev.name, sizeof(vcap->driver));
+	strlcpy(vcap->card, "Connectix B&W Quickcam", sizeof(vcap->card));
+	strlcpy(vcap->bus_info, qcam->pport->name, sizeof(vcap->bus_info));
+	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
+	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int qcam_enum_input(struct file *file, void *fh, struct v4l2_input *vin)
+{
+	if (vin->index > 0)
+		return -EINVAL;
+	strlcpy(vin->name, "Camera", sizeof(vin->name));
+	vin->type = V4L2_INPUT_TYPE_CAMERA;
+	vin->audioset = 0;
+	vin->tuner = 0;
+	vin->std = 0;
+	vin->status = 0;
+	return 0;
+}
+
+static int qcam_g_input(struct file *file, void *fh, unsigned int *inp)
+{
+	*inp = 0;
+	return 0;
+}
+
+static int qcam_s_input(struct file *file, void *fh, unsigned int inp)
+{
+	return (inp > 0) ? -EINVAL : 0;
+}
+
+static int qcam_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct qcam *qcam = video_drvdata(file);
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+
+	pix->width = qcam->width / qcam->transfer_scale;
+	pix->height = qcam->height / qcam->transfer_scale;
+	pix->pixelformat = (qcam->bpp == 4) ? V4L2_PIX_FMT_Y4 : V4L2_PIX_FMT_Y6;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = pix->width;
+	pix->sizeimage = pix->width * pix->height;
+	/* Just a guess */
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	return 0;
+}
+
+static int qcam_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+
+	if (pix->height <= 60 || pix->width <= 80) {
+		pix->height = 60;
+		pix->width = 80;
+	} else if (pix->height <= 120 || pix->width <= 160) {
+		pix->height = 120;
+		pix->width = 160;
+	} else {
+		pix->height = 240;
+		pix->width = 320;
+	}
+	if (pix->pixelformat != V4L2_PIX_FMT_Y4 &&
+	    pix->pixelformat != V4L2_PIX_FMT_Y6)
+		pix->pixelformat = V4L2_PIX_FMT_Y4;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = pix->width;
+	pix->sizeimage = pix->width * pix->height;
+	/* Just a guess */
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	return 0;
+}
+
+static int qcam_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct qcam *qcam = video_drvdata(file);
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+	int ret = qcam_try_fmt_vid_cap(file, fh, fmt);
+
+	if (ret)
+		return ret;
+	qcam->width = 320;
+	qcam->height = 240;
+	if (pix->height == 60)
+		qcam->transfer_scale = 4;
+	else if (pix->height == 120)
+		qcam->transfer_scale = 2;
+	else
+		qcam->transfer_scale = 1;
+	if (pix->pixelformat == V4L2_PIX_FMT_Y6)
+		qcam->bpp = 6;
+	else
+		qcam->bpp = 4;
+
+	mutex_lock(&qcam->lock);
+	qc_setscanmode(qcam);
+	/* We must update the camera before we grab. We could
+	   just have changed the grab size */
+	qcam->status |= QC_PARAM_CHANGE;
+	mutex_unlock(&qcam->lock);
+	return 0;
+}
+
+static int qcam_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdesc *fmt)
+{
+	static struct v4l2_fmtdesc formats[] = {
+		{ 0, 0, 0,
+		  "4-Bit Monochrome", V4L2_PIX_FMT_Y4,
+		  { 0, 0, 0, 0 }
+		},
+		{ 1, 0, 0,
+		  "6-Bit Monochrome", V4L2_PIX_FMT_Y6,
+		  { 0, 0, 0, 0 }
+		},
+	};
+	enum v4l2_buf_type type = fmt->type;
+
+	if (fmt->index > 1)
+		return -EINVAL;
+
+	*fmt = formats[fmt->index];
+	fmt->type = type;
+	return 0;
+}
+
+static int qcam_enum_framesizes(struct file *file, void *fh,
+					 struct v4l2_frmsizeenum *fsize)
+{
+	static const struct v4l2_frmsize_discrete sizes[] = {
+		{  80,  60 },
+		{ 160, 120 },
+		{ 320, 240 },
+	};
+
+	if (fsize->index > 2)
+		return -EINVAL;
+	if (fsize->pixel_format != V4L2_PIX_FMT_Y4 &&
+	    fsize->pixel_format != V4L2_PIX_FMT_Y6)
+		return -EINVAL;
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete = sizes[fsize->index];
+	return 0;
+}
+
+static ssize_t qcam_read(struct file *file, char __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct qcam *qcam = video_drvdata(file);
+	int len;
+	parport_claim_or_block(qcam->pdev);
+
+	mutex_lock(&qcam->lock);
+
+	qc_reset(qcam);
+
+	/* Update the camera parameters if we need to */
+	if (qcam->status & QC_PARAM_CHANGE)
+		qc_set(qcam);
+
+	len = qc_capture(qcam, buf, count);
+
+	mutex_unlock(&qcam->lock);
+
+	parport_release(qcam->pdev);
+	return len;
+}
+
+static unsigned int qcam_poll(struct file *filp, poll_table *wait)
+{
+	return v4l2_ctrl_poll(filp, wait) | POLLIN | POLLRDNORM;
+}
+
+static int qcam_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct qcam *qcam =
+		container_of(ctrl->handler, struct qcam, hdl);
+	int ret = 0;
+
+	mutex_lock(&qcam->lock);
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		qcam->brightness = ctrl->val;
+		break;
+	case V4L2_CID_CONTRAST:
+		qcam->contrast = ctrl->val;
+		break;
+	case V4L2_CID_GAMMA:
+		qcam->whitebal = ctrl->val;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	if (ret == 0) {
+		qc_setscanmode(qcam);
+		qcam->status |= QC_PARAM_CHANGE;
+	}
+	mutex_unlock(&qcam->lock);
+	return ret;
+}
+
+static const struct v4l2_file_operations qcam_fops = {
+	.owner		= THIS_MODULE,
+	.open		= v4l2_fh_open,
+	.release	= v4l2_fh_release,
+	.poll		= qcam_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.read		= qcam_read,
+};
+
+static const struct v4l2_ioctl_ops qcam_ioctl_ops = {
+	.vidioc_querycap    		    = qcam_querycap,
+	.vidioc_g_input      		    = qcam_g_input,
+	.vidioc_s_input      		    = qcam_s_input,
+	.vidioc_enum_input   		    = qcam_enum_input,
+	.vidioc_enum_fmt_vid_cap 	    = qcam_enum_fmt_vid_cap,
+	.vidioc_enum_framesizes		    = qcam_enum_framesizes,
+	.vidioc_g_fmt_vid_cap 		    = qcam_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap  		    = qcam_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap  	    = qcam_try_fmt_vid_cap,
+	.vidioc_log_status		    = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		    = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	    = v4l2_event_unsubscribe,
+};
+
+static const struct v4l2_ctrl_ops qcam_ctrl_ops = {
+	.s_ctrl = qcam_s_ctrl,
+};
+
+/* Initialize the QuickCam driver control structure.  This is where
+ * defaults are set for people who don't have a config file.*/
+
+static struct qcam *qcam_init(struct parport *port)
+{
+	struct qcam *qcam;
+	struct v4l2_device *v4l2_dev;
+
+	qcam = kzalloc(sizeof(struct qcam), GFP_KERNEL);
+	if (qcam == NULL)
+		return NULL;
+
+	v4l2_dev = &qcam->v4l2_dev;
+	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "bw-qcam%d", num_cams);
+
+	if (v4l2_device_register(port->dev, v4l2_dev) < 0) {
+		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
+		kfree(qcam);
+		return NULL;
+	}
+
+	v4l2_ctrl_handler_init(&qcam->hdl, 3);
+	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 180);
+	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
+			  V4L2_CID_CONTRAST, 0, 255, 1, 192);
+	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
+			  V4L2_CID_GAMMA, 0, 255, 1, 105);
+	if (qcam->hdl.error) {
+		v4l2_err(v4l2_dev, "couldn't register controls\n");
+		v4l2_ctrl_handler_free(&qcam->hdl);
+		kfree(qcam);
+		return NULL;
+	}
+	qcam->pport = port;
+	qcam->pdev = parport_register_device(port, v4l2_dev->name, NULL, NULL,
+			NULL, 0, NULL);
+	if (qcam->pdev == NULL) {
+		v4l2_err(v4l2_dev, "couldn't register for %s.\n", port->name);
+		v4l2_ctrl_handler_free(&qcam->hdl);
+		kfree(qcam);
+		return NULL;
+	}
+
+	strlcpy(qcam->vdev.name, "Connectix QuickCam", sizeof(qcam->vdev.name));
+	qcam->vdev.v4l2_dev = v4l2_dev;
+	qcam->vdev.ctrl_handler = &qcam->hdl;
+	qcam->vdev.fops = &qcam_fops;
+	qcam->vdev.ioctl_ops = &qcam_ioctl_ops;
+	set_bit(V4L2_FL_USE_FH_PRIO, &qcam->vdev.flags);
+	qcam->vdev.release = video_device_release_empty;
+	video_set_drvdata(&qcam->vdev, qcam);
+
+	mutex_init(&qcam->lock);
+
+	qcam->port_mode = (QC_ANY | QC_NOTSET);
+	qcam->width = 320;
+	qcam->height = 240;
+	qcam->bpp = 4;
+	qcam->transfer_scale = 2;
+	qcam->contrast = 192;
+	qcam->brightness = 180;
+	qcam->whitebal = 105;
+	qcam->top = 1;
+	qcam->left = 14;
+	qcam->mode = -1;
+	qcam->status = QC_PARAM_CHANGE;
+	return qcam;
+}
+
+static int qc_calibrate(struct qcam *q)
+{
+	/*
+	 *	Bugfix by Hanno Mueller hmueller@kabel.de, Mai 21 96
+	 *	The white balance is an individual value for each
+	 *	quickcam.
+	 */
+
+	int value;
+	int count = 0;
+
+	qc_command(q, 27);	/* AutoAdjustOffset */
+	qc_command(q, 0);	/* Dummy Parameter, ignored by the camera */
+
+	/* GetOffset (33) will read 255 until autocalibration */
+	/* is finished. After that, a value of 1-254 will be */
+	/* returned. */
+
+	do {
+		qc_command(q, 33);
+		value = qc_readparam(q);
+		mdelay(1);
+		schedule();
+		count++;
+	} while (value == 0xff && count < 2048);
+
+	q->whitebal = value;
+	return value;
+}
+
+static int init_bwqcam(struct parport *port)
+{
+	struct qcam *qcam;
+
+	if (num_cams == MAX_CAMS) {
+		printk(KERN_ERR "Too many Quickcams (max %d)\n", MAX_CAMS);
+		return -ENOSPC;
+	}
+
+	qcam = qcam_init(port);
+	if (qcam == NULL)
+		return -ENODEV;
+
+	parport_claim_or_block(qcam->pdev);
+
+	qc_reset(qcam);
+
+	if (qc_detect(qcam) == 0) {
+		parport_release(qcam->pdev);
+		parport_unregister_device(qcam->pdev);
+		kfree(qcam);
+		return -ENODEV;
+	}
+	qc_calibrate(qcam);
+	v4l2_ctrl_handler_setup(&qcam->hdl);
+
+	parport_release(qcam->pdev);
+
+	v4l2_info(&qcam->v4l2_dev, "Connectix Quickcam on %s\n", qcam->pport->name);
+
+	if (video_register_device(&qcam->vdev, VFL_TYPE_GRABBER, video_nr) < 0) {
+		parport_unregister_device(qcam->pdev);
+		kfree(qcam);
+		return -ENODEV;
+	}
+
+	qcams[num_cams++] = qcam;
+
+	return 0;
+}
+
+static void close_bwqcam(struct qcam *qcam)
+{
+	video_unregister_device(&qcam->vdev);
+	v4l2_ctrl_handler_free(&qcam->hdl);
+	parport_unregister_device(qcam->pdev);
+	kfree(qcam);
+}
+
+/* The parport parameter controls which parports will be scanned.
+ * Scanning all parports causes some printers to print a garbage page.
+ *       -- March 14, 1999  Billy Donahue <billy@escape.com> */
+#ifdef MODULE
+static char *parport[MAX_CAMS] = { NULL, };
+module_param_array(parport, charp, NULL, 0);
+#endif
+
+static int accept_bwqcam(struct parport *port)
+{
+#ifdef MODULE
+	int n;
+
+	if (parport[0] && strncmp(parport[0], "auto", 4) != 0) {
+		/* user gave parport parameters */
+		for (n = 0; n < MAX_CAMS && parport[n]; n++) {
+			char *ep;
+			unsigned long r;
+			r = simple_strtoul(parport[n], &ep, 0);
+			if (ep == parport[n]) {
+				printk(KERN_ERR
+					"bw-qcam: bad port specifier \"%s\"\n",
+					parport[n]);
+				continue;
+			}
+			if (r == port->number)
+				return 1;
+		}
+		return 0;
+	}
+#endif
+	return 1;
+}
+
+static void bwqcam_attach(struct parport *port)
+{
+	if (accept_bwqcam(port))
+		init_bwqcam(port);
+}
+
+static void bwqcam_detach(struct parport *port)
+{
+	int i;
+	for (i = 0; i < num_cams; i++) {
+		struct qcam *qcam = qcams[i];
+		if (qcam && qcam->pdev->port == port) {
+			qcams[i] = NULL;
+			close_bwqcam(qcam);
+		}
+	}
+}
+
+static struct parport_driver bwqcam_driver = {
+	.name	= "bw-qcam",
+	.attach	= bwqcam_attach,
+	.detach	= bwqcam_detach,
+};
+
+static void __exit exit_bw_qcams(void)
+{
+	parport_unregister_driver(&bwqcam_driver);
+}
+
+static int __init init_bw_qcams(void)
+{
+#ifdef MODULE
+	/* Do some sanity checks on the module parameters. */
+	if (maxpoll > 5000) {
+		printk(KERN_INFO "Connectix Quickcam max-poll was above 5000. Using 5000.\n");
+		maxpoll = 5000;
+	}
+
+	if (yieldlines < 1) {
+		printk(KERN_INFO "Connectix Quickcam yieldlines was less than 1. Using 1.\n");
+		yieldlines = 1;
+	}
+#endif
+	return parport_register_driver(&bwqcam_driver);
+}
+
+module_init(init_bw_qcams);
+module_exit(exit_bw_qcams);
+
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.3");
diff --git a/drivers/media/parport/c-qcam.c b/drivers/media/parport/c-qcam.c
new file mode 100644
index 0000000..ec51e1f
--- /dev/null
+++ b/drivers/media/parport/c-qcam.c
@@ -0,0 +1,883 @@
+/*
+ *	Video4Linux Colour QuickCam driver
+ *	Copyright 1997-2000 Philip Blundell <philb@gnu.org>
+ *
+ *    Module parameters:
+ *
+ *	parport=auto      -- probe all parports (default)
+ *	parport=0         -- parport0 becomes qcam1
+ *	parport=2,0,1     -- parports 2,0,1 are tried in that order
+ *
+ *	probe=0		  -- do no probing, assume camera is present
+ *	probe=1		  -- use IEEE-1284 autoprobe data only (default)
+ *	probe=2		  -- probe aggressively for cameras
+ *
+ *	force_rgb=1       -- force data format to RGB (default is BGR)
+ *
+ * The parport parameter controls which parports will be scanned.
+ * Scanning all parports causes some printers to print a garbage page.
+ *       -- March 14, 1999  Billy Donahue <billy@escape.com>
+ *
+ * Fixed data format to BGR, added force_rgb parameter. Added missing
+ * parport_unregister_driver() on module removal.
+ *       -- May 28, 2000  Claudio Matsuoka <claudio@conectiva.com>
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/parport.h>
+#include <linux/sched.h>
+#include <linux/mutex.h>
+#include <linux/jiffies.h>
+#include <linux/videodev2.h>
+#include <asm/uaccess.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+
+struct qcam {
+	struct v4l2_device v4l2_dev;
+	struct video_device vdev;
+	struct v4l2_ctrl_handler hdl;
+	struct pardevice *pdev;
+	struct parport *pport;
+	int width, height;
+	int ccd_width, ccd_height;
+	int mode;
+	int contrast, brightness, whitebal;
+	int top, left;
+	unsigned int bidirectional;
+	struct mutex lock;
+};
+
+/* cameras maximum */
+#define MAX_CAMS 4
+
+/* The three possible QuickCam modes */
+#define QC_MILLIONS	0x18
+#define QC_BILLIONS	0x10
+#define QC_THOUSANDS	0x08	/* with VIDEC compression (not supported) */
+
+/* The three possible decimations */
+#define QC_DECIMATION_1		0
+#define QC_DECIMATION_2		2
+#define QC_DECIMATION_4		4
+
+#define BANNER "Colour QuickCam for Video4Linux v0.06"
+
+static int parport[MAX_CAMS] = { [1 ... MAX_CAMS-1] = -1 };
+static int probe = 2;
+static bool force_rgb;
+static int video_nr = -1;
+
+/* FIXME: parport=auto would never have worked, surely? --RR */
+MODULE_PARM_DESC(parport, "parport=<auto|n[,n]...> for port detection method\n"
+			  "probe=<0|1|2> for camera detection method\n"
+			  "force_rgb=<0|1> for RGB data format (default BGR)");
+module_param_array(parport, int, NULL, 0);
+module_param(probe, int, 0);
+module_param(force_rgb, bool, 0);
+module_param(video_nr, int, 0);
+
+static struct qcam *qcams[MAX_CAMS];
+static unsigned int num_cams;
+
+static inline void qcam_set_ack(struct qcam *qcam, unsigned int i)
+{
+	/* note: the QC specs refer to the PCAck pin by voltage, not
+	   software level.  PC ports have builtin inverters. */
+	parport_frob_control(qcam->pport, 8, i ? 8 : 0);
+}
+
+static inline unsigned int qcam_ready1(struct qcam *qcam)
+{
+	return (parport_read_status(qcam->pport) & 0x8) ? 1 : 0;
+}
+
+static inline unsigned int qcam_ready2(struct qcam *qcam)
+{
+	return (parport_read_data(qcam->pport) & 0x1) ? 1 : 0;
+}
+
+static unsigned int qcam_await_ready1(struct qcam *qcam, int value)
+{
+	struct v4l2_device *v4l2_dev = &qcam->v4l2_dev;
+	unsigned long oldjiffies = jiffies;
+	unsigned int i;
+
+	for (oldjiffies = jiffies;
+	     time_before(jiffies, oldjiffies + msecs_to_jiffies(40));)
+		if (qcam_ready1(qcam) == value)
+			return 0;
+
+	/* If the camera didn't respond within 1/25 second, poll slowly
+	   for a while. */
+	for (i = 0; i < 50; i++) {
+		if (qcam_ready1(qcam) == value)
+			return 0;
+		msleep_interruptible(100);
+	}
+
+	/* Probably somebody pulled the plug out.  Not much we can do. */
+	v4l2_err(v4l2_dev, "ready1 timeout (%d) %x %x\n", value,
+	       parport_read_status(qcam->pport),
+	       parport_read_control(qcam->pport));
+	return 1;
+}
+
+static unsigned int qcam_await_ready2(struct qcam *qcam, int value)
+{
+	struct v4l2_device *v4l2_dev = &qcam->v4l2_dev;
+	unsigned long oldjiffies = jiffies;
+	unsigned int i;
+
+	for (oldjiffies = jiffies;
+	     time_before(jiffies, oldjiffies + msecs_to_jiffies(40));)
+		if (qcam_ready2(qcam) == value)
+			return 0;
+
+	/* If the camera didn't respond within 1/25 second, poll slowly
+	   for a while. */
+	for (i = 0; i < 50; i++) {
+		if (qcam_ready2(qcam) == value)
+			return 0;
+		msleep_interruptible(100);
+	}
+
+	/* Probably somebody pulled the plug out.  Not much we can do. */
+	v4l2_err(v4l2_dev, "ready2 timeout (%d) %x %x %x\n", value,
+	       parport_read_status(qcam->pport),
+	       parport_read_control(qcam->pport),
+	       parport_read_data(qcam->pport));
+	return 1;
+}
+
+static int qcam_read_data(struct qcam *qcam)
+{
+	unsigned int idata;
+
+	qcam_set_ack(qcam, 0);
+	if (qcam_await_ready1(qcam, 1))
+		return -1;
+	idata = parport_read_status(qcam->pport) & 0xf0;
+	qcam_set_ack(qcam, 1);
+	if (qcam_await_ready1(qcam, 0))
+		return -1;
+	idata |= parport_read_status(qcam->pport) >> 4;
+	return idata;
+}
+
+static int qcam_write_data(struct qcam *qcam, unsigned int data)
+{
+	struct v4l2_device *v4l2_dev = &qcam->v4l2_dev;
+	unsigned int idata;
+
+	parport_write_data(qcam->pport, data);
+	idata = qcam_read_data(qcam);
+	if (data != idata) {
+		v4l2_warn(v4l2_dev, "sent %x but received %x\n", data,
+		       idata);
+		return 1;
+	}
+	return 0;
+}
+
+static inline int qcam_set(struct qcam *qcam, unsigned int cmd, unsigned int data)
+{
+	if (qcam_write_data(qcam, cmd))
+		return -1;
+	if (qcam_write_data(qcam, data))
+		return -1;
+	return 0;
+}
+
+static inline int qcam_get(struct qcam *qcam, unsigned int cmd)
+{
+	if (qcam_write_data(qcam, cmd))
+		return -1;
+	return qcam_read_data(qcam);
+}
+
+static int qc_detect(struct qcam *qcam)
+{
+	unsigned int stat, ostat, i, count = 0;
+
+	/* The probe routine below is not very reliable.  The IEEE-1284
+	   probe takes precedence. */
+	/* XXX Currently parport provides no way to distinguish between
+	   "the IEEE probe was not done" and "the probe was done, but
+	   no device was found".  Fix this one day. */
+	if (qcam->pport->probe_info[0].class == PARPORT_CLASS_MEDIA
+	    && qcam->pport->probe_info[0].model
+	    && !strcmp(qcam->pdev->port->probe_info[0].model,
+		       "Color QuickCam 2.0")) {
+		printk(KERN_DEBUG "QuickCam: Found by IEEE1284 probe.\n");
+		return 1;
+	}
+
+	if (probe < 2)
+		return 0;
+
+	parport_write_control(qcam->pport, 0xc);
+
+	/* look for a heartbeat */
+	ostat = stat = parport_read_status(qcam->pport);
+	for (i = 0; i < 250; i++) {
+		mdelay(1);
+		stat = parport_read_status(qcam->pport);
+		if (ostat != stat) {
+			if (++count >= 3)
+				return 1;
+			ostat = stat;
+		}
+	}
+
+	/* Reset the camera and try again */
+	parport_write_control(qcam->pport, 0xc);
+	parport_write_control(qcam->pport, 0x8);
+	mdelay(1);
+	parport_write_control(qcam->pport, 0xc);
+	mdelay(1);
+	count = 0;
+
+	ostat = stat = parport_read_status(qcam->pport);
+	for (i = 0; i < 250; i++) {
+		mdelay(1);
+		stat = parport_read_status(qcam->pport);
+		if (ostat != stat) {
+			if (++count >= 3)
+				return 1;
+			ostat = stat;
+		}
+	}
+
+	/* no (or flatline) camera, give up */
+	return 0;
+}
+
+static void qc_reset(struct qcam *qcam)
+{
+	parport_write_control(qcam->pport, 0xc);
+	parport_write_control(qcam->pport, 0x8);
+	mdelay(1);
+	parport_write_control(qcam->pport, 0xc);
+	mdelay(1);
+}
+
+/* Reset the QuickCam and program for brightness, contrast,
+ * white-balance, and resolution. */
+
+static void qc_setup(struct qcam *qcam)
+{
+	qc_reset(qcam);
+
+	/* Set the brightness. */
+	qcam_set(qcam, 11, qcam->brightness);
+
+	/* Set the height and width.  These refer to the actual
+	   CCD area *before* applying the selected decimation.  */
+	qcam_set(qcam, 17, qcam->ccd_height);
+	qcam_set(qcam, 19, qcam->ccd_width / 2);
+
+	/* Set top and left.  */
+	qcam_set(qcam, 0xd, qcam->top);
+	qcam_set(qcam, 0xf, qcam->left);
+
+	/* Set contrast and white balance.  */
+	qcam_set(qcam, 0x19, qcam->contrast);
+	qcam_set(qcam, 0x1f, qcam->whitebal);
+
+	/* Set the speed.  */
+	qcam_set(qcam, 45, 2);
+}
+
+/* Read some bytes from the camera and put them in the buffer.
+   nbytes should be a multiple of 3, because bidirectional mode gives
+   us three bytes at a time.  */
+
+static unsigned int qcam_read_bytes(struct qcam *qcam, unsigned char *buf, unsigned int nbytes)
+{
+	unsigned int bytes = 0;
+
+	qcam_set_ack(qcam, 0);
+	if (qcam->bidirectional) {
+		/* It's a bidirectional port */
+		while (bytes < nbytes) {
+			unsigned int lo1, hi1, lo2, hi2;
+			unsigned char r, g, b;
+
+			if (qcam_await_ready2(qcam, 1))
+				return bytes;
+			lo1 = parport_read_data(qcam->pport) >> 1;
+			hi1 = ((parport_read_status(qcam->pport) >> 3) & 0x1f) ^ 0x10;
+			qcam_set_ack(qcam, 1);
+			if (qcam_await_ready2(qcam, 0))
+				return bytes;
+			lo2 = parport_read_data(qcam->pport) >> 1;
+			hi2 = ((parport_read_status(qcam->pport) >> 3) & 0x1f) ^ 0x10;
+			qcam_set_ack(qcam, 0);
+			r = lo1 | ((hi1 & 1) << 7);
+			g = ((hi1 & 0x1e) << 3) | ((hi2 & 0x1e) >> 1);
+			b = lo2 | ((hi2 & 1) << 7);
+			if (force_rgb) {
+				buf[bytes++] = r;
+				buf[bytes++] = g;
+				buf[bytes++] = b;
+			} else {
+				buf[bytes++] = b;
+				buf[bytes++] = g;
+				buf[bytes++] = r;
+			}
+		}
+	} else {
+		/* It's a unidirectional port */
+		int i = 0, n = bytes;
+		unsigned char rgb[3];
+
+		while (bytes < nbytes) {
+			unsigned int hi, lo;
+
+			if (qcam_await_ready1(qcam, 1))
+				return bytes;
+			hi = (parport_read_status(qcam->pport) & 0xf0);
+			qcam_set_ack(qcam, 1);
+			if (qcam_await_ready1(qcam, 0))
+				return bytes;
+			lo = (parport_read_status(qcam->pport) & 0xf0);
+			qcam_set_ack(qcam, 0);
+			/* flip some bits */
+			rgb[(i = bytes++ % 3)] = (hi | (lo >> 4)) ^ 0x88;
+			if (i >= 2) {
+get_fragment:
+				if (force_rgb) {
+					buf[n++] = rgb[0];
+					buf[n++] = rgb[1];
+					buf[n++] = rgb[2];
+				} else {
+					buf[n++] = rgb[2];
+					buf[n++] = rgb[1];
+					buf[n++] = rgb[0];
+				}
+			}
+		}
+		if (i) {
+			i = 0;
+			goto get_fragment;
+		}
+	}
+	return bytes;
+}
+
+#define BUFSZ	150
+
+static long qc_capture(struct qcam *qcam, char __user *buf, unsigned long len)
+{
+	struct v4l2_device *v4l2_dev = &qcam->v4l2_dev;
+	unsigned lines, pixelsperline;
+	unsigned int is_bi_dir = qcam->bidirectional;
+	size_t wantlen, outptr = 0;
+	char tmpbuf[BUFSZ];
+
+	if (!access_ok(VERIFY_WRITE, buf, len))
+		return -EFAULT;
+
+	/* Wait for camera to become ready */
+	for (;;) {
+		int i = qcam_get(qcam, 41);
+
+		if (i == -1) {
+			qc_setup(qcam);
+			return -EIO;
+		}
+		if ((i & 0x80) == 0)
+			break;
+		schedule();
+	}
+
+	if (qcam_set(qcam, 7, (qcam->mode | (is_bi_dir ? 1 : 0)) + 1))
+		return -EIO;
+
+	lines = qcam->height;
+	pixelsperline = qcam->width;
+
+	if (is_bi_dir) {
+		/* Turn the port around */
+		parport_data_reverse(qcam->pport);
+		mdelay(3);
+		qcam_set_ack(qcam, 0);
+		if (qcam_await_ready1(qcam, 1)) {
+			qc_setup(qcam);
+			return -EIO;
+		}
+		qcam_set_ack(qcam, 1);
+		if (qcam_await_ready1(qcam, 0)) {
+			qc_setup(qcam);
+			return -EIO;
+		}
+	}
+
+	wantlen = lines * pixelsperline * 24 / 8;
+
+	while (wantlen) {
+		size_t t, s;
+
+		s = (wantlen > BUFSZ) ? BUFSZ : wantlen;
+		t = qcam_read_bytes(qcam, tmpbuf, s);
+		if (outptr < len) {
+			size_t sz = len - outptr;
+
+			if (sz > t)
+				sz = t;
+			if (__copy_to_user(buf + outptr, tmpbuf, sz))
+				break;
+			outptr += sz;
+		}
+		wantlen -= t;
+		if (t < s)
+			break;
+		cond_resched();
+	}
+
+	len = outptr;
+
+	if (wantlen) {
+		v4l2_err(v4l2_dev, "short read.\n");
+		if (is_bi_dir)
+			parport_data_forward(qcam->pport);
+		qc_setup(qcam);
+		return len;
+	}
+
+	if (is_bi_dir) {
+		int l;
+
+		do {
+			l = qcam_read_bytes(qcam, tmpbuf, 3);
+			cond_resched();
+		} while (l && (tmpbuf[0] == 0x7e || tmpbuf[1] == 0x7e || tmpbuf[2] == 0x7e));
+		if (force_rgb) {
+			if (tmpbuf[0] != 0xe || tmpbuf[1] != 0x0 || tmpbuf[2] != 0xf)
+				v4l2_err(v4l2_dev, "bad EOF\n");
+		} else {
+			if (tmpbuf[0] != 0xf || tmpbuf[1] != 0x0 || tmpbuf[2] != 0xe)
+				v4l2_err(v4l2_dev, "bad EOF\n");
+		}
+		qcam_set_ack(qcam, 0);
+		if (qcam_await_ready1(qcam, 1)) {
+			v4l2_err(v4l2_dev, "no ack after EOF\n");
+			parport_data_forward(qcam->pport);
+			qc_setup(qcam);
+			return len;
+		}
+		parport_data_forward(qcam->pport);
+		mdelay(3);
+		qcam_set_ack(qcam, 1);
+		if (qcam_await_ready1(qcam, 0)) {
+			v4l2_err(v4l2_dev, "no ack to port turnaround\n");
+			qc_setup(qcam);
+			return len;
+		}
+	} else {
+		int l;
+
+		do {
+			l = qcam_read_bytes(qcam, tmpbuf, 1);
+			cond_resched();
+		} while (l && tmpbuf[0] == 0x7e);
+		l = qcam_read_bytes(qcam, tmpbuf + 1, 2);
+		if (force_rgb) {
+			if (tmpbuf[0] != 0xe || tmpbuf[1] != 0x0 || tmpbuf[2] != 0xf)
+				v4l2_err(v4l2_dev, "bad EOF\n");
+		} else {
+			if (tmpbuf[0] != 0xf || tmpbuf[1] != 0x0 || tmpbuf[2] != 0xe)
+				v4l2_err(v4l2_dev, "bad EOF\n");
+		}
+	}
+
+	qcam_write_data(qcam, 0);
+	return len;
+}
+
+/*
+ *	Video4linux interfacing
+ */
+
+static int qcam_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *vcap)
+{
+	struct qcam *qcam = video_drvdata(file);
+
+	strlcpy(vcap->driver, qcam->v4l2_dev.name, sizeof(vcap->driver));
+	strlcpy(vcap->card, "Color Quickcam", sizeof(vcap->card));
+	strlcpy(vcap->bus_info, "parport", sizeof(vcap->bus_info));
+	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
+	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int qcam_enum_input(struct file *file, void *fh, struct v4l2_input *vin)
+{
+	if (vin->index > 0)
+		return -EINVAL;
+	strlcpy(vin->name, "Camera", sizeof(vin->name));
+	vin->type = V4L2_INPUT_TYPE_CAMERA;
+	vin->audioset = 0;
+	vin->tuner = 0;
+	vin->std = 0;
+	vin->status = 0;
+	return 0;
+}
+
+static int qcam_g_input(struct file *file, void *fh, unsigned int *inp)
+{
+	*inp = 0;
+	return 0;
+}
+
+static int qcam_s_input(struct file *file, void *fh, unsigned int inp)
+{
+	return (inp > 0) ? -EINVAL : 0;
+}
+
+static int qcam_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct qcam *qcam = video_drvdata(file);
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+
+	pix->width = qcam->width;
+	pix->height = qcam->height;
+	pix->pixelformat = V4L2_PIX_FMT_RGB24;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = 3 * qcam->width;
+	pix->sizeimage = 3 * qcam->width * qcam->height;
+	/* Just a guess */
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	return 0;
+}
+
+static int qcam_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+
+	if (pix->height < 60 || pix->width < 80) {
+		pix->height = 60;
+		pix->width = 80;
+	} else if (pix->height < 120 || pix->width < 160) {
+		pix->height = 120;
+		pix->width = 160;
+	} else {
+		pix->height = 240;
+		pix->width = 320;
+	}
+	pix->pixelformat = V4L2_PIX_FMT_RGB24;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = 3 * pix->width;
+	pix->sizeimage = 3 * pix->width * pix->height;
+	/* Just a guess */
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	return 0;
+}
+
+static int qcam_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct qcam *qcam = video_drvdata(file);
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+	int ret = qcam_try_fmt_vid_cap(file, fh, fmt);
+
+	if (ret)
+		return ret;
+	switch (pix->height) {
+	case 60:
+		qcam->mode = QC_DECIMATION_4;
+		break;
+	case 120:
+		qcam->mode = QC_DECIMATION_2;
+		break;
+	default:
+		qcam->mode = QC_DECIMATION_1;
+		break;
+	}
+
+	mutex_lock(&qcam->lock);
+	qcam->mode |= QC_MILLIONS;
+	qcam->height = pix->height;
+	qcam->width = pix->width;
+	parport_claim_or_block(qcam->pdev);
+	qc_setup(qcam);
+	parport_release(qcam->pdev);
+	mutex_unlock(&qcam->lock);
+	return 0;
+}
+
+static int qcam_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdesc *fmt)
+{
+	static struct v4l2_fmtdesc formats[] = {
+		{ 0, 0, 0,
+		  "RGB 8:8:8", V4L2_PIX_FMT_RGB24,
+		  { 0, 0, 0, 0 }
+		},
+	};
+	enum v4l2_buf_type type = fmt->type;
+
+	if (fmt->index > 0)
+		return -EINVAL;
+
+	*fmt = formats[fmt->index];
+	fmt->type = type;
+	return 0;
+}
+
+static ssize_t qcam_read(struct file *file, char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	struct qcam *qcam = video_drvdata(file);
+	int len;
+
+	mutex_lock(&qcam->lock);
+	parport_claim_or_block(qcam->pdev);
+	/* Probably should have a semaphore against multiple users */
+	len = qc_capture(qcam, buf, count);
+	parport_release(qcam->pdev);
+	mutex_unlock(&qcam->lock);
+	return len;
+}
+
+static int qcam_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct qcam *qcam =
+		container_of(ctrl->handler, struct qcam, hdl);
+	int ret = 0;
+
+	mutex_lock(&qcam->lock);
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		qcam->brightness = ctrl->val;
+		break;
+	case V4L2_CID_CONTRAST:
+		qcam->contrast = ctrl->val;
+		break;
+	case V4L2_CID_GAMMA:
+		qcam->whitebal = ctrl->val;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	if (ret == 0) {
+		parport_claim_or_block(qcam->pdev);
+		qc_setup(qcam);
+		parport_release(qcam->pdev);
+	}
+	mutex_unlock(&qcam->lock);
+	return ret;
+}
+
+static const struct v4l2_file_operations qcam_fops = {
+	.owner		= THIS_MODULE,
+	.open		= v4l2_fh_open,
+	.release	= v4l2_fh_release,
+	.poll		= v4l2_ctrl_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.read		= qcam_read,
+};
+
+static const struct v4l2_ioctl_ops qcam_ioctl_ops = {
+	.vidioc_querycap    		    = qcam_querycap,
+	.vidioc_g_input      		    = qcam_g_input,
+	.vidioc_s_input      		    = qcam_s_input,
+	.vidioc_enum_input   		    = qcam_enum_input,
+	.vidioc_enum_fmt_vid_cap	    = qcam_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap 		    = qcam_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap  		    = qcam_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap  	    = qcam_try_fmt_vid_cap,
+	.vidioc_log_status		    = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		    = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	    = v4l2_event_unsubscribe,
+};
+
+static const struct v4l2_ctrl_ops qcam_ctrl_ops = {
+	.s_ctrl = qcam_s_ctrl,
+};
+
+/* Initialize the QuickCam driver control structure. */
+
+static struct qcam *qcam_init(struct parport *port)
+{
+	struct qcam *qcam;
+	struct v4l2_device *v4l2_dev;
+
+	qcam = kzalloc(sizeof(*qcam), GFP_KERNEL);
+	if (qcam == NULL)
+		return NULL;
+
+	v4l2_dev = &qcam->v4l2_dev;
+	strlcpy(v4l2_dev->name, "c-qcam", sizeof(v4l2_dev->name));
+
+	if (v4l2_device_register(NULL, v4l2_dev) < 0) {
+		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
+		kfree(qcam);
+		return NULL;
+	}
+
+	v4l2_ctrl_handler_init(&qcam->hdl, 3);
+	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 240);
+	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
+			  V4L2_CID_CONTRAST, 0, 255, 1, 192);
+	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
+			  V4L2_CID_GAMMA, 0, 255, 1, 128);
+	if (qcam->hdl.error) {
+		v4l2_err(v4l2_dev, "couldn't register controls\n");
+		v4l2_ctrl_handler_free(&qcam->hdl);
+		kfree(qcam);
+		return NULL;
+	}
+
+	qcam->pport = port;
+	qcam->pdev = parport_register_device(port, "c-qcam", NULL, NULL,
+					  NULL, 0, NULL);
+
+	qcam->bidirectional = (qcam->pport->modes & PARPORT_MODE_TRISTATE) ? 1 : 0;
+
+	if (qcam->pdev == NULL) {
+		v4l2_err(v4l2_dev, "couldn't register for %s.\n", port->name);
+		v4l2_ctrl_handler_free(&qcam->hdl);
+		kfree(qcam);
+		return NULL;
+	}
+
+	strlcpy(qcam->vdev.name, "Colour QuickCam", sizeof(qcam->vdev.name));
+	qcam->vdev.v4l2_dev = v4l2_dev;
+	qcam->vdev.fops = &qcam_fops;
+	qcam->vdev.ioctl_ops = &qcam_ioctl_ops;
+	qcam->vdev.release = video_device_release_empty;
+	qcam->vdev.ctrl_handler = &qcam->hdl;
+	set_bit(V4L2_FL_USE_FH_PRIO, &qcam->vdev.flags);
+	video_set_drvdata(&qcam->vdev, qcam);
+
+	mutex_init(&qcam->lock);
+	qcam->width = qcam->ccd_width = 320;
+	qcam->height = qcam->ccd_height = 240;
+	qcam->mode = QC_MILLIONS | QC_DECIMATION_1;
+	qcam->contrast = 192;
+	qcam->brightness = 240;
+	qcam->whitebal = 128;
+	qcam->top = 1;
+	qcam->left = 14;
+	return qcam;
+}
+
+static int init_cqcam(struct parport *port)
+{
+	struct qcam *qcam;
+	struct v4l2_device *v4l2_dev;
+
+	if (parport[0] != -1) {
+		/* The user gave specific instructions */
+		int i, found = 0;
+
+		for (i = 0; i < MAX_CAMS && parport[i] != -1; i++) {
+			if (parport[0] == port->number)
+				found = 1;
+		}
+		if (!found)
+			return -ENODEV;
+	}
+
+	if (num_cams == MAX_CAMS)
+		return -ENOSPC;
+
+	qcam = qcam_init(port);
+	if (qcam == NULL)
+		return -ENODEV;
+
+	v4l2_dev = &qcam->v4l2_dev;
+
+	parport_claim_or_block(qcam->pdev);
+
+	qc_reset(qcam);
+
+	if (probe && qc_detect(qcam) == 0) {
+		parport_release(qcam->pdev);
+		parport_unregister_device(qcam->pdev);
+		kfree(qcam);
+		return -ENODEV;
+	}
+
+	qc_setup(qcam);
+
+	parport_release(qcam->pdev);
+
+	if (video_register_device(&qcam->vdev, VFL_TYPE_GRABBER, video_nr) < 0) {
+		v4l2_err(v4l2_dev, "Unable to register Colour QuickCam on %s\n",
+		       qcam->pport->name);
+		parport_unregister_device(qcam->pdev);
+		kfree(qcam);
+		return -ENODEV;
+	}
+
+	v4l2_info(v4l2_dev, "%s: Colour QuickCam found on %s\n",
+	       video_device_node_name(&qcam->vdev), qcam->pport->name);
+
+	qcams[num_cams++] = qcam;
+
+	return 0;
+}
+
+static void close_cqcam(struct qcam *qcam)
+{
+	video_unregister_device(&qcam->vdev);
+	v4l2_ctrl_handler_free(&qcam->hdl);
+	parport_unregister_device(qcam->pdev);
+	kfree(qcam);
+}
+
+static void cq_attach(struct parport *port)
+{
+	init_cqcam(port);
+}
+
+static void cq_detach(struct parport *port)
+{
+	/* Write this some day. */
+}
+
+static struct parport_driver cqcam_driver = {
+	.name = "cqcam",
+	.attach = cq_attach,
+	.detach = cq_detach,
+};
+
+static int __init cqcam_init(void)
+{
+	printk(KERN_INFO BANNER "\n");
+
+	return parport_register_driver(&cqcam_driver);
+}
+
+static void __exit cqcam_cleanup(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < num_cams; i++)
+		close_cqcam(qcams[i]);
+
+	parport_unregister_driver(&cqcam_driver);
+}
+
+MODULE_AUTHOR("Philip Blundell <philb@gnu.org>");
+MODULE_DESCRIPTION(BANNER);
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.4");
+
+module_init(cqcam_init);
+module_exit(cqcam_cleanup);
diff --git a/drivers/media/parport/pms.c b/drivers/media/parport/pms.c
new file mode 100644
index 0000000..77f9c92
--- /dev/null
+++ b/drivers/media/parport/pms.c
@@ -0,0 +1,1152 @@
+/*
+ *	Media Vision Pro Movie Studio
+ *			or
+ *	"all you need is an I2C bus some RAM and a prayer"
+ *
+ *	This draws heavily on code
+ *
+ *	(c) Wolfgang Koehler,  wolf@first.gmd.de, Dec. 1994
+ *	Kiefernring 15
+ *	14478 Potsdam, Germany
+ *
+ *	Most of this code is directly derived from his userspace driver.
+ *	His driver works so send any reports to alan@lxorguk.ukuu.org.uk
+ *	unless the userspace driver also doesn't work for you...
+ *
+ *      Changes:
+ *	25-11-2009 	Hans Verkuil <hverkuil@xs4all.nl>
+ * 			- converted to version 2 of the V4L API.
+ *      08/07/2003      Daniele Bellucci <bellucda@tiscali.it>
+ *                      - pms_capture: report back -EFAULT
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/ioport.h>
+#include <linux/init.h>
+#include <linux/mutex.h>
+#include <linux/uaccess.h>
+#include <linux/isa.h>
+#include <asm/io.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-device.h>
+
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.0.5");
+
+#define MOTOROLA	1
+#define PHILIPS2	2               /* SAA7191 */
+#define PHILIPS1	3
+#define MVVMEMORYWIDTH	0x40		/* 512 bytes */
+
+struct i2c_info {
+	u8 slave;
+	u8 sub;
+	u8 data;
+	u8 hits;
+};
+
+struct pms {
+	struct v4l2_device v4l2_dev;
+	struct video_device vdev;
+	struct v4l2_ctrl_handler hdl;
+	int height;
+	int width;
+	int depth;
+	int input;
+	struct mutex lock;
+	int i2c_count;
+	struct i2c_info i2cinfo[64];
+
+	int decoder;
+	int standard;	/* 0 - auto 1 - ntsc 2 - pal 3 - secam */
+	v4l2_std_id std;
+	int io;
+	int data;
+	void __iomem *mem;
+};
+
+/*
+ *	I/O ports and Shared Memory
+ */
+
+static int io_port = 0x250;
+module_param(io_port, int, 0);
+
+static int mem_base = 0xc8000;
+module_param(mem_base, int, 0);
+
+static int video_nr = -1;
+module_param(video_nr, int, 0);
+
+
+static inline void mvv_write(struct pms *dev, u8 index, u8 value)
+{
+	outw(index | (value << 8), dev->io);
+}
+
+static inline u8 mvv_read(struct pms *dev, u8 index)
+{
+	outb(index, dev->io);
+	return inb(dev->data);
+}
+
+static int pms_i2c_stat(struct pms *dev, u8 slave)
+{
+	int counter = 0;
+	int i;
+
+	outb(0x28, dev->io);
+
+	while ((inb(dev->data) & 0x01) == 0)
+		if (counter++ == 256)
+			break;
+
+	while ((inb(dev->data) & 0x01) != 0)
+		if (counter++ == 256)
+			break;
+
+	outb(slave, dev->io);
+
+	counter = 0;
+	while ((inb(dev->data) & 0x01) == 0)
+		if (counter++ == 256)
+			break;
+
+	while ((inb(dev->data) & 0x01) != 0)
+		if (counter++ == 256)
+			break;
+
+	for (i = 0; i < 12; i++) {
+		char st = inb(dev->data);
+
+		if ((st & 2) != 0)
+			return -1;
+		if ((st & 1) == 0)
+			break;
+	}
+	outb(0x29, dev->io);
+	return inb(dev->data);
+}
+
+static int pms_i2c_write(struct pms *dev, u16 slave, u16 sub, u16 data)
+{
+	int skip = 0;
+	int count;
+	int i;
+
+	for (i = 0; i < dev->i2c_count; i++) {
+		if ((dev->i2cinfo[i].slave == slave) &&
+		    (dev->i2cinfo[i].sub == sub)) {
+			if (dev->i2cinfo[i].data == data)
+				skip = 1;
+			dev->i2cinfo[i].data = data;
+			i = dev->i2c_count + 1;
+		}
+	}
+
+	if (i == dev->i2c_count && dev->i2c_count < 64) {
+		dev->i2cinfo[dev->i2c_count].slave = slave;
+		dev->i2cinfo[dev->i2c_count].sub = sub;
+		dev->i2cinfo[dev->i2c_count].data = data;
+		dev->i2c_count++;
+	}
+
+	if (skip)
+		return 0;
+
+	mvv_write(dev, 0x29, sub);
+	mvv_write(dev, 0x2A, data);
+	mvv_write(dev, 0x28, slave);
+
+	outb(0x28, dev->io);
+
+	count = 0;
+	while ((inb(dev->data) & 1) == 0)
+		if (count > 255)
+			break;
+	while ((inb(dev->data) & 1) != 0)
+		if (count > 255)
+			break;
+
+	count = inb(dev->data);
+
+	if (count & 2)
+		return -1;
+	return count;
+}
+
+static int pms_i2c_read(struct pms *dev, int slave, int sub)
+{
+	int i;
+
+	for (i = 0; i < dev->i2c_count; i++) {
+		if (dev->i2cinfo[i].slave == slave && dev->i2cinfo[i].sub == sub)
+			return dev->i2cinfo[i].data;
+	}
+	return 0;
+}
+
+
+static void pms_i2c_andor(struct pms *dev, int slave, int sub, int and, int or)
+{
+	u8 tmp;
+
+	tmp = pms_i2c_read(dev, slave, sub);
+	tmp = (tmp & and) | or;
+	pms_i2c_write(dev, slave, sub, tmp);
+}
+
+/*
+ *	Control functions
+ */
+
+
+static void pms_videosource(struct pms *dev, short source)
+{
+	switch (dev->decoder) {
+	case MOTOROLA:
+		break;
+	case PHILIPS2:
+		pms_i2c_andor(dev, 0x8a, 0x06, 0x7f, source ? 0x80 : 0);
+		break;
+	case PHILIPS1:
+		break;
+	}
+	mvv_write(dev, 0x2E, 0x31);
+	/* Was: mvv_write(dev, 0x2E, source ? 0x31 : 0x30);
+	   But could not make this work correctly. Only Composite input
+	   worked for me. */
+}
+
+static void pms_hue(struct pms *dev, short hue)
+{
+	switch (dev->decoder) {
+	case MOTOROLA:
+		pms_i2c_write(dev, 0x8a, 0x00, hue);
+		break;
+	case PHILIPS2:
+		pms_i2c_write(dev, 0x8a, 0x07, hue);
+		break;
+	case PHILIPS1:
+		pms_i2c_write(dev, 0x42, 0x07, hue);
+		break;
+	}
+}
+
+static void pms_saturation(struct pms *dev, short sat)
+{
+	switch (dev->decoder) {
+	case MOTOROLA:
+		pms_i2c_write(dev, 0x8a, 0x00, sat);
+		break;
+	case PHILIPS1:
+		pms_i2c_write(dev, 0x42, 0x12, sat);
+		break;
+	}
+}
+
+
+static void pms_contrast(struct pms *dev, short contrast)
+{
+	switch (dev->decoder) {
+	case MOTOROLA:
+		pms_i2c_write(dev, 0x8a, 0x00, contrast);
+		break;
+	case PHILIPS1:
+		pms_i2c_write(dev, 0x42, 0x13, contrast);
+		break;
+	}
+}
+
+static void pms_brightness(struct pms *dev, short brightness)
+{
+	switch (dev->decoder) {
+	case MOTOROLA:
+		pms_i2c_write(dev, 0x8a, 0x00, brightness);
+		pms_i2c_write(dev, 0x8a, 0x00, brightness);
+		pms_i2c_write(dev, 0x8a, 0x00, brightness);
+		break;
+	case PHILIPS1:
+		pms_i2c_write(dev, 0x42, 0x19, brightness);
+		break;
+	}
+}
+
+
+static void pms_format(struct pms *dev, short format)
+{
+	int target;
+
+	dev->standard = format;
+
+	if (dev->decoder == PHILIPS1)
+		target = 0x42;
+	else if (dev->decoder == PHILIPS2)
+		target = 0x8a;
+	else
+		return;
+
+	switch (format) {
+	case 0:	/* Auto */
+		pms_i2c_andor(dev, target, 0x0d, 0xfe, 0x00);
+		pms_i2c_andor(dev, target, 0x0f, 0x3f, 0x80);
+		break;
+	case 1: /* NTSC */
+		pms_i2c_andor(dev, target, 0x0d, 0xfe, 0x00);
+		pms_i2c_andor(dev, target, 0x0f, 0x3f, 0x40);
+		break;
+	case 2: /* PAL */
+		pms_i2c_andor(dev, target, 0x0d, 0xfe, 0x00);
+		pms_i2c_andor(dev, target, 0x0f, 0x3f, 0x00);
+		break;
+	case 3:	/* SECAM */
+		pms_i2c_andor(dev, target, 0x0d, 0xfe, 0x01);
+		pms_i2c_andor(dev, target, 0x0f, 0x3f, 0x00);
+		break;
+	}
+}
+
+#ifdef FOR_FUTURE_EXPANSION
+
+/*
+ *	These features of the PMS card are not currently exposes. They
+ *	could become a private v4l ioctl for PMSCONFIG or somesuch if
+ *	people need it. We also don't yet use the PMS interrupt.
+ */
+
+static void pms_hstart(struct pms *dev, short start)
+{
+	switch (dev->decoder) {
+	case PHILIPS1:
+		pms_i2c_write(dev, 0x8a, 0x05, start);
+		pms_i2c_write(dev, 0x8a, 0x18, start);
+		break;
+	case PHILIPS2:
+		pms_i2c_write(dev, 0x42, 0x05, start);
+		pms_i2c_write(dev, 0x42, 0x18, start);
+		break;
+	}
+}
+
+/*
+ *	Bandpass filters
+ */
+
+static void pms_bandpass(struct pms *dev, short pass)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0x8a, 0x06, 0xcf, (pass & 0x03) << 4);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x06, 0xcf, (pass & 0x03) << 4);
+}
+
+static void pms_antisnow(struct pms *dev, short snow)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0x8a, 0x06, 0xf3, (snow & 0x03) << 2);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x06, 0xf3, (snow & 0x03) << 2);
+}
+
+static void pms_sharpness(struct pms *dev, short sharp)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0x8a, 0x06, 0xfc, sharp & 0x03);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x06, 0xfc, sharp & 0x03);
+}
+
+static void pms_chromaagc(struct pms *dev, short agc)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0x8a, 0x0c, 0x9f, (agc & 0x03) << 5);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x0c, 0x9f, (agc & 0x03) << 5);
+}
+
+static void pms_vertnoise(struct pms *dev, short noise)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0x8a, 0x10, 0xfc, noise & 3);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x10, 0xfc, noise & 3);
+}
+
+static void pms_forcecolour(struct pms *dev, short colour)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0x8a, 0x0c, 0x7f, (colour & 1) << 7);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x0c, 0x7, (colour & 1) << 7);
+}
+
+static void pms_antigamma(struct pms *dev, short gamma)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0xb8, 0x00, 0x7f, (gamma & 1) << 7);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x20, 0x7, (gamma & 1) << 7);
+}
+
+static void pms_prefilter(struct pms *dev, short filter)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0x8a, 0x06, 0xbf, (filter & 1) << 6);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x06, 0xbf, (filter & 1) << 6);
+}
+
+static void pms_hfilter(struct pms *dev, short filter)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0xb8, 0x04, 0x1f, (filter & 7) << 5);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x24, 0x1f, (filter & 7) << 5);
+}
+
+static void pms_vfilter(struct pms *dev, short filter)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0xb8, 0x08, 0x9f, (filter & 3) << 5);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x28, 0x9f, (filter & 3) << 5);
+}
+
+static void pms_killcolour(struct pms *dev, short colour)
+{
+	if (dev->decoder == PHILIPS2) {
+		pms_i2c_andor(dev, 0x8a, 0x08, 0x07, (colour & 0x1f) << 3);
+		pms_i2c_andor(dev, 0x8a, 0x09, 0x07, (colour & 0x1f) << 3);
+	} else if (dev->decoder == PHILIPS1) {
+		pms_i2c_andor(dev, 0x42, 0x08, 0x07, (colour & 0x1f) << 3);
+		pms_i2c_andor(dev, 0x42, 0x09, 0x07, (colour & 0x1f) << 3);
+	}
+}
+
+static void pms_chromagain(struct pms *dev, short chroma)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_write(dev, 0x8a, 0x11, chroma);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_write(dev, 0x42, 0x11, chroma);
+}
+
+
+static void pms_spacialcompl(struct pms *dev, short data)
+{
+	mvv_write(dev, 0x3b, data);
+}
+
+static void pms_spacialcomph(struct pms *dev, short data)
+{
+	mvv_write(dev, 0x3a, data);
+}
+
+static void pms_vstart(struct pms *dev, short start)
+{
+	mvv_write(dev, 0x16, start);
+	mvv_write(dev, 0x17, (start >> 8) & 0x01);
+}
+
+#endif
+
+static void pms_secamcross(struct pms *dev, short cross)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0x8a, 0x0f, 0xdf, (cross & 1) << 5);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x0f, 0xdf, (cross & 1) << 5);
+}
+
+
+static void pms_swsense(struct pms *dev, short sense)
+{
+	if (dev->decoder == PHILIPS2) {
+		pms_i2c_write(dev, 0x8a, 0x0a, sense);
+		pms_i2c_write(dev, 0x8a, 0x0b, sense);
+	} else if (dev->decoder == PHILIPS1) {
+		pms_i2c_write(dev, 0x42, 0x0a, sense);
+		pms_i2c_write(dev, 0x42, 0x0b, sense);
+	}
+}
+
+
+static void pms_framerate(struct pms *dev, short frr)
+{
+	int fps = (dev->std & V4L2_STD_525_60) ? 30 : 25;
+
+	if (frr == 0)
+		return;
+	fps = fps/frr;
+	mvv_write(dev, 0x14, 0x80 | fps);
+	mvv_write(dev, 0x15, 1);
+}
+
+static void pms_vert(struct pms *dev, u8 deciden, u8 decinum)
+{
+	mvv_write(dev, 0x1c, deciden);	/* Denominator */
+	mvv_write(dev, 0x1d, decinum);	/* Numerator */
+}
+
+/*
+ *	Turn 16bit ratios into best small ratio the chipset can grok
+ */
+
+static void pms_vertdeci(struct pms *dev, unsigned short decinum, unsigned short deciden)
+{
+	/* Knock it down by / 5 once */
+	if (decinum % 5 == 0) {
+		deciden /= 5;
+		decinum /= 5;
+	}
+	/*
+	 *	3's
+	 */
+	while (decinum % 3 == 0 && deciden % 3 == 0) {
+		deciden /= 3;
+		decinum /= 3;
+	}
+	/*
+	 *	2's
+	 */
+	while (decinum % 2 == 0 && deciden % 2 == 0) {
+		decinum /= 2;
+		deciden /= 2;
+	}
+	/*
+	 *	Fudgyify
+	 */
+	while (deciden > 32) {
+		deciden /= 2;
+		decinum = (decinum + 1) / 2;
+	}
+	if (deciden == 32)
+		deciden--;
+	pms_vert(dev, deciden, decinum);
+}
+
+static void pms_horzdeci(struct pms *dev, short decinum, short deciden)
+{
+	if (decinum <= 512) {
+		if (decinum % 5 == 0) {
+			decinum /= 5;
+			deciden /= 5;
+		}
+	} else {
+		decinum = 512;
+		deciden = 640;	/* 768 would be ideal */
+	}
+
+	while (((decinum | deciden) & 1) == 0) {
+		decinum >>= 1;
+		deciden >>= 1;
+	}
+	while (deciden > 32) {
+		deciden >>= 1;
+		decinum = (decinum + 1) >> 1;
+	}
+	if (deciden == 32)
+		deciden--;
+
+	mvv_write(dev, 0x24, 0x80 | deciden);
+	mvv_write(dev, 0x25, decinum);
+}
+
+static void pms_resolution(struct pms *dev, short width, short height)
+{
+	int fg_height;
+
+	fg_height = height;
+	if (fg_height > 280)
+		fg_height = 280;
+
+	mvv_write(dev, 0x18, fg_height);
+	mvv_write(dev, 0x19, fg_height >> 8);
+
+	if (dev->std & V4L2_STD_525_60) {
+		mvv_write(dev, 0x1a, 0xfc);
+		mvv_write(dev, 0x1b, 0x00);
+		if (height > fg_height)
+			pms_vertdeci(dev, 240, 240);
+		else
+			pms_vertdeci(dev, fg_height, 240);
+	} else {
+		mvv_write(dev, 0x1a, 0x1a);
+		mvv_write(dev, 0x1b, 0x01);
+		if (fg_height > 256)
+			pms_vertdeci(dev, 270, 270);
+		else
+			pms_vertdeci(dev, fg_height, 270);
+	}
+	mvv_write(dev, 0x12, 0);
+	mvv_write(dev, 0x13, MVVMEMORYWIDTH);
+	mvv_write(dev, 0x42, 0x00);
+	mvv_write(dev, 0x43, 0x00);
+	mvv_write(dev, 0x44, MVVMEMORYWIDTH);
+
+	mvv_write(dev, 0x22, width + 8);
+	mvv_write(dev, 0x23, (width + 8) >> 8);
+
+	if (dev->std & V4L2_STD_525_60)
+		pms_horzdeci(dev, width, 640);
+	else
+		pms_horzdeci(dev, width + 8, 768);
+
+	mvv_write(dev, 0x30, mvv_read(dev, 0x30) & 0xfe);
+	mvv_write(dev, 0x08, mvv_read(dev, 0x08) | 0x01);
+	mvv_write(dev, 0x01, mvv_read(dev, 0x01) & 0xfd);
+	mvv_write(dev, 0x32, 0x00);
+	mvv_write(dev, 0x33, MVVMEMORYWIDTH);
+}
+
+
+/*
+ *	Set Input
+ */
+
+static void pms_vcrinput(struct pms *dev, short input)
+{
+	if (dev->decoder == PHILIPS2)
+		pms_i2c_andor(dev, 0x8a, 0x0d, 0x7f, (input & 1) << 7);
+	else if (dev->decoder == PHILIPS1)
+		pms_i2c_andor(dev, 0x42, 0x0d, 0x7f, (input & 1) << 7);
+}
+
+
+static int pms_capture(struct pms *dev, char __user *buf, int rgb555, int count)
+{
+	int y;
+	int dw = 2 * dev->width;
+	char tmp[dw + 32]; /* using a temp buffer is faster than direct  */
+	int cnt = 0;
+	int len = 0;
+	unsigned char r8 = 0x5;  /* value for reg8  */
+
+	if (rgb555)
+		r8 |= 0x20; /* else use untranslated rgb = 565 */
+	mvv_write(dev, 0x08, r8); /* capture rgb555/565, init DRAM, PC enable */
+
+/*	printf("%d %d %d %d %d %x %x\n",width,height,voff,nom,den,mvv_buf); */
+
+	for (y = 0; y < dev->height; y++) {
+		writeb(0, dev->mem);  /* synchronisiert neue Zeile */
+
+		/*
+		 *	This is in truth a fifo, be very careful as if you
+		 *	forgot this odd things will occur 8)
+		 */
+
+		memcpy_fromio(tmp, dev->mem, dw + 32); /* discard 16 word   */
+		cnt -= dev->height;
+		while (cnt <= 0) {
+			/*
+			 *	Don't copy too far
+			 */
+			int dt = dw;
+			if (dt + len > count)
+				dt = count - len;
+			cnt += dev->height;
+			if (copy_to_user(buf, tmp + 32, dt))
+				return len ? len : -EFAULT;
+			buf += dt;
+			len += dt;
+		}
+	}
+	return len;
+}
+
+
+/*
+ *	Video4linux interfacing
+ */
+
+static int pms_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *vcap)
+{
+	struct pms *dev = video_drvdata(file);
+
+	strlcpy(vcap->driver, dev->v4l2_dev.name, sizeof(vcap->driver));
+	strlcpy(vcap->card, "Mediavision PMS", sizeof(vcap->card));
+	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
+			"ISA:%s", dev->v4l2_dev.name);
+	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
+	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int pms_enum_input(struct file *file, void *fh, struct v4l2_input *vin)
+{
+	static const char *inputs[4] = {
+		"Composite",
+		"S-Video",
+		"Composite (VCR)",
+		"S-Video (VCR)"
+	};
+
+	if (vin->index > 3)
+		return -EINVAL;
+	strlcpy(vin->name, inputs[vin->index], sizeof(vin->name));
+	vin->type = V4L2_INPUT_TYPE_CAMERA;
+	vin->audioset = 0;
+	vin->tuner = 0;
+	vin->std = V4L2_STD_ALL;
+	vin->status = 0;
+	return 0;
+}
+
+static int pms_g_input(struct file *file, void *fh, unsigned int *inp)
+{
+	struct pms *dev = video_drvdata(file);
+
+	*inp = dev->input;
+	return 0;
+}
+
+static int pms_s_input(struct file *file, void *fh, unsigned int inp)
+{
+	struct pms *dev = video_drvdata(file);
+
+	if (inp > 3)
+		return -EINVAL;
+
+	dev->input = inp;
+	pms_videosource(dev, inp & 1);
+	pms_vcrinput(dev, inp >> 1);
+	return 0;
+}
+
+static int pms_g_std(struct file *file, void *fh, v4l2_std_id *std)
+{
+	struct pms *dev = video_drvdata(file);
+
+	*std = dev->std;
+	return 0;
+}
+
+static int pms_s_std(struct file *file, void *fh, v4l2_std_id *std)
+{
+	struct pms *dev = video_drvdata(file);
+	int ret = 0;
+
+	dev->std = *std;
+	if (dev->std & V4L2_STD_NTSC) {
+		pms_framerate(dev, 30);
+		pms_secamcross(dev, 0);
+		pms_format(dev, 1);
+	} else if (dev->std & V4L2_STD_PAL) {
+		pms_framerate(dev, 25);
+		pms_secamcross(dev, 0);
+		pms_format(dev, 2);
+	} else if (dev->std & V4L2_STD_SECAM) {
+		pms_framerate(dev, 25);
+		pms_secamcross(dev, 1);
+		pms_format(dev, 2);
+	} else {
+		ret = -EINVAL;
+	}
+	/*
+	switch (v->mode) {
+	case VIDEO_MODE_AUTO:
+		pms_framerate(dev, 25);
+		pms_secamcross(dev, 0);
+		pms_format(dev, 0);
+		break;
+	}*/
+	return ret;
+}
+
+static int pms_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct pms *dev = container_of(ctrl->handler, struct pms, hdl);
+	int ret = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		pms_brightness(dev, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		pms_contrast(dev, ctrl->val);
+		break;
+	case V4L2_CID_SATURATION:
+		pms_saturation(dev, ctrl->val);
+		break;
+	case V4L2_CID_HUE:
+		pms_hue(dev, ctrl->val);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int pms_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct pms *dev = video_drvdata(file);
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+
+	pix->width = dev->width;
+	pix->height = dev->height;
+	pix->pixelformat = dev->width == 15 ?
+			    V4L2_PIX_FMT_RGB555 : V4L2_PIX_FMT_RGB565;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = 2 * dev->width;
+	pix->sizeimage = 2 * dev->width * dev->height;
+	/* Just a guess */
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	return 0;
+}
+
+static int pms_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+
+	if (pix->height < 16 || pix->height > 480)
+		return -EINVAL;
+	if (pix->width < 16 || pix->width > 640)
+		return -EINVAL;
+	if (pix->pixelformat != V4L2_PIX_FMT_RGB555 &&
+	    pix->pixelformat != V4L2_PIX_FMT_RGB565)
+		return -EINVAL;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = 2 * pix->width;
+	pix->sizeimage = 2 * pix->width * pix->height;
+	/* Just a guess */
+	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	return 0;
+}
+
+static int pms_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct pms *dev = video_drvdata(file);
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+	int ret = pms_try_fmt_vid_cap(file, fh, fmt);
+
+	if (ret)
+		return ret;
+	dev->width = pix->width;
+	dev->height = pix->height;
+	dev->depth = (pix->pixelformat == V4L2_PIX_FMT_RGB555) ? 15 : 16;
+	pms_resolution(dev, dev->width, dev->height);
+	/* Ok we figured out what to use from our wide choice */
+	return 0;
+}
+
+static int pms_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdesc *fmt)
+{
+	static struct v4l2_fmtdesc formats[] = {
+		{ 0, 0, 0,
+		  "RGB 5:5:5", V4L2_PIX_FMT_RGB555,
+		  { 0, 0, 0, 0 }
+		},
+		{ 1, 0, 0,
+		  "RGB 5:6:5", V4L2_PIX_FMT_RGB565,
+		  { 0, 0, 0, 0 }
+		},
+	};
+	enum v4l2_buf_type type = fmt->type;
+
+	if (fmt->index > 1)
+		return -EINVAL;
+
+	*fmt = formats[fmt->index];
+	fmt->type = type;
+	return 0;
+}
+
+static ssize_t pms_read(struct file *file, char __user *buf,
+		    size_t count, loff_t *ppos)
+{
+	struct pms *dev = video_drvdata(file);
+	int len;
+
+	len = pms_capture(dev, buf, (dev->depth == 15), count);
+	return len;
+}
+
+static unsigned int pms_poll(struct file *file, struct poll_table_struct *wait)
+{
+	struct v4l2_fh *fh = file->private_data;
+	unsigned int res = POLLIN | POLLRDNORM;
+
+	if (v4l2_event_pending(fh))
+		res |= POLLPRI;
+	poll_wait(file, &fh->wait, wait);
+	return res;
+}
+
+static const struct v4l2_file_operations pms_fops = {
+	.owner		= THIS_MODULE,
+	.open           = v4l2_fh_open,
+	.release        = v4l2_fh_release,
+	.poll           = pms_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.read           = pms_read,
+};
+
+static const struct v4l2_ioctl_ops pms_ioctl_ops = {
+	.vidioc_querycap	    = pms_querycap,
+	.vidioc_g_input		    = pms_g_input,
+	.vidioc_s_input		    = pms_s_input,
+	.vidioc_enum_input	    = pms_enum_input,
+	.vidioc_g_std		    = pms_g_std,
+	.vidioc_s_std		    = pms_s_std,
+	.vidioc_enum_fmt_vid_cap    = pms_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap	    = pms_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	    = pms_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap     = pms_try_fmt_vid_cap,
+	.vidioc_subscribe_event     = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event   = v4l2_event_unsubscribe,
+};
+
+/*
+ *	Probe for and initialise the Mediavision PMS
+ */
+
+static int init_mediavision(struct pms *dev)
+{
+	int idec, decst;
+	int i;
+	static const unsigned char i2c_defs[] = {
+		0x4c, 0x30, 0x00, 0xe8,
+		0xb6, 0xe2, 0x00, 0x00,
+		0xff, 0xff, 0x00, 0x00,
+		0x00, 0x00, 0x78, 0x98,
+		0x00, 0x00, 0x00, 0x00,
+		0x34, 0x0a, 0xf4, 0xce,
+		0xe4
+	};
+
+	dev->mem = ioremap(mem_base, 0x800);
+	if (!dev->mem)
+		return -ENOMEM;
+
+	if (!request_region(0x9a01, 1, "Mediavision PMS config")) {
+		printk(KERN_WARNING "mediavision: unable to detect: 0x9a01 in use.\n");
+		iounmap(dev->mem);
+		return -EBUSY;
+	}
+	if (!request_region(dev->io, 3, "Mediavision PMS")) {
+		printk(KERN_WARNING "mediavision: I/O port %d in use.\n", dev->io);
+		release_region(0x9a01, 1);
+		iounmap(dev->mem);
+		return -EBUSY;
+	}
+	outb(0xb8, 0x9a01);		/* Unlock */
+	outb(dev->io >> 4, 0x9a01);	/* Set IO port */
+
+
+	decst = pms_i2c_stat(dev, 0x43);
+
+	if (decst != -1)
+		idec = 2;
+	else if (pms_i2c_stat(dev, 0xb9) != -1)
+		idec = 3;
+	else if (pms_i2c_stat(dev, 0x8b) != -1)
+		idec = 1;
+	else
+		idec = 0;
+
+	printk(KERN_INFO "PMS type is %d\n", idec);
+	if (idec == 0) {
+		release_region(dev->io, 3);
+		release_region(0x9a01, 1);
+		iounmap(dev->mem);
+		return -ENODEV;
+	}
+
+	/*
+	 *	Ok we have a PMS of some sort
+	 */
+
+	mvv_write(dev, 0x04, mem_base >> 12);	/* Set the memory area */
+
+	/* Ok now load the defaults */
+
+	for (i = 0; i < 0x19; i++) {
+		if (i2c_defs[i] == 0xff)
+			pms_i2c_andor(dev, 0x8a, i, 0x07, 0x00);
+		else
+			pms_i2c_write(dev, 0x8a, i, i2c_defs[i]);
+	}
+
+	pms_i2c_write(dev, 0xb8, 0x00, 0x12);
+	pms_i2c_write(dev, 0xb8, 0x04, 0x00);
+	pms_i2c_write(dev, 0xb8, 0x07, 0x00);
+	pms_i2c_write(dev, 0xb8, 0x08, 0x00);
+	pms_i2c_write(dev, 0xb8, 0x09, 0xff);
+	pms_i2c_write(dev, 0xb8, 0x0a, 0x00);
+	pms_i2c_write(dev, 0xb8, 0x0b, 0x10);
+	pms_i2c_write(dev, 0xb8, 0x10, 0x03);
+
+	mvv_write(dev, 0x01, 0x00);
+	mvv_write(dev, 0x05, 0xa0);
+	mvv_write(dev, 0x08, 0x25);
+	mvv_write(dev, 0x09, 0x00);
+	mvv_write(dev, 0x0a, 0x20 | MVVMEMORYWIDTH);
+
+	mvv_write(dev, 0x10, 0x02);
+	mvv_write(dev, 0x1e, 0x0c);
+	mvv_write(dev, 0x1f, 0x03);
+	mvv_write(dev, 0x26, 0x06);
+
+	mvv_write(dev, 0x2b, 0x00);
+	mvv_write(dev, 0x2c, 0x20);
+	mvv_write(dev, 0x2d, 0x00);
+	mvv_write(dev, 0x2f, 0x70);
+	mvv_write(dev, 0x32, 0x00);
+	mvv_write(dev, 0x33, MVVMEMORYWIDTH);
+	mvv_write(dev, 0x34, 0x00);
+	mvv_write(dev, 0x35, 0x00);
+	mvv_write(dev, 0x3a, 0x80);
+	mvv_write(dev, 0x3b, 0x10);
+	mvv_write(dev, 0x20, 0x00);
+	mvv_write(dev, 0x21, 0x00);
+	mvv_write(dev, 0x30, 0x22);
+	return 0;
+}
+
+/*
+ *	Initialization and module stuff
+ */
+
+#ifndef MODULE
+static int enable;
+module_param(enable, int, 0);
+#endif
+
+static const struct v4l2_ctrl_ops pms_ctrl_ops = {
+	.s_ctrl = pms_s_ctrl,
+};
+
+static int pms_probe(struct device *pdev, unsigned int card)
+{
+	struct pms *dev;
+	struct v4l2_device *v4l2_dev;
+	struct v4l2_ctrl_handler *hdl;
+	int res;
+
+#ifndef MODULE
+	if (!enable) {
+		pr_err("PMS: not enabled, use pms.enable=1 to probe\n");
+		return -ENODEV;
+	}
+#endif
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (dev == NULL)
+		return -ENOMEM;
+
+	dev->decoder = PHILIPS2;
+	dev->io = io_port;
+	dev->data = io_port + 1;
+	v4l2_dev = &dev->v4l2_dev;
+	hdl = &dev->hdl;
+
+	res = v4l2_device_register(pdev, v4l2_dev);
+	if (res < 0) {
+		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
+		goto free_dev;
+	}
+	v4l2_info(v4l2_dev, "Mediavision Pro Movie Studio driver 0.05\n");
+
+	res = init_mediavision(dev);
+	if (res) {
+		v4l2_err(v4l2_dev, "Board not found.\n");
+		goto free_io;
+	}
+
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &pms_ctrl_ops,
+			V4L2_CID_BRIGHTNESS, 0, 255, 1, 139);
+	v4l2_ctrl_new_std(hdl, &pms_ctrl_ops,
+			V4L2_CID_CONTRAST, 0, 255, 1, 70);
+	v4l2_ctrl_new_std(hdl, &pms_ctrl_ops,
+			V4L2_CID_SATURATION, 0, 255, 1, 64);
+	v4l2_ctrl_new_std(hdl, &pms_ctrl_ops,
+			V4L2_CID_HUE, 0, 255, 1, 0);
+	if (hdl->error) {
+		res = hdl->error;
+		goto free_hdl;
+	}
+
+	mutex_init(&dev->lock);
+	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
+	dev->vdev.v4l2_dev = v4l2_dev;
+	dev->vdev.ctrl_handler = hdl;
+	dev->vdev.fops = &pms_fops;
+	dev->vdev.ioctl_ops = &pms_ioctl_ops;
+	dev->vdev.release = video_device_release_empty;
+	dev->vdev.lock = &dev->lock;
+	dev->vdev.tvnorms = V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM;
+	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
+	video_set_drvdata(&dev->vdev, dev);
+	dev->std = V4L2_STD_NTSC_M;
+	dev->height = 240;
+	dev->width = 320;
+	dev->depth = 16;
+	pms_swsense(dev, 75);
+	pms_resolution(dev, 320, 240);
+	pms_videosource(dev, 0);
+	pms_vcrinput(dev, 0);
+	v4l2_ctrl_handler_setup(hdl);
+	res = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, video_nr);
+	if (res >= 0)
+		return 0;
+
+free_hdl:
+	v4l2_ctrl_handler_free(hdl);
+	v4l2_device_unregister(&dev->v4l2_dev);
+free_io:
+	release_region(dev->io, 3);
+	release_region(0x9a01, 1);
+	iounmap(dev->mem);
+free_dev:
+	kfree(dev);
+	return res;
+}
+
+static int pms_remove(struct device *pdev, unsigned int card)
+{
+	struct pms *dev = dev_get_drvdata(pdev);
+
+	video_unregister_device(&dev->vdev);
+	v4l2_ctrl_handler_free(&dev->hdl);
+	release_region(dev->io, 3);
+	release_region(0x9a01, 1);
+	iounmap(dev->mem);
+	return 0;
+}
+
+static struct isa_driver pms_driver = {
+	.probe		= pms_probe,
+	.remove		= pms_remove,
+	.driver		= {
+		.name	= "pms",
+	},
+};
+
+static int __init pms_init(void)
+{
+	return isa_register_driver(&pms_driver, 1);
+}
+
+static void __exit pms_exit(void)
+{
+	isa_unregister_driver(&pms_driver);
+}
+
+module_init(pms_init);
+module_exit(pms_exit);
diff --git a/drivers/media/parport/w9966.c b/drivers/media/parport/w9966.c
new file mode 100644
index 0000000..db2a600
--- /dev/null
+++ b/drivers/media/parport/w9966.c
@@ -0,0 +1,981 @@
+/*
+	Winbond w9966cf Webcam parport driver.
+
+	Version 0.33
+
+	Copyright (C) 2001 Jakob Kemi <jakob.kemi@post.utfors.se>
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+/*
+	Supported devices:
+	*Lifeview FlyCam Supra (using the Philips saa7111a chip)
+
+	Does any other model using the w9966 interface chip exist ?
+
+	Todo:
+
+	*Add a working EPP mode, since DMA ECP read isn't implemented
+	in the parport drivers. (That's why it's so sloow)
+
+	*Add support for other ccd-control chips than the saa7111
+	please send me feedback on what kind of chips you have.
+
+	*Add proper probing. I don't know what's wrong with the IEEE1284
+	parport drivers but (IEEE1284_MODE_NIBBLE|IEEE1284_DEVICE_ID)
+	and nibble read seems to be broken for some peripherals.
+
+	*Add probing for onboard SRAM, port directions etc. (if possible)
+
+	*Add support for the hardware compressed modes (maybe using v4l2)
+
+	*Fix better support for the capture window (no skewed images, v4l
+	interface to capt. window)
+
+	*Probably some bugs that I don't know of
+
+	Please support me by sending feedback!
+
+	Changes:
+
+	Alan Cox:	Removed RGB mode for kernel merge, added THIS_MODULE
+			and owner support for newer module locks
+*/
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <linux/slab.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fh.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <linux/parport.h>
+
+/*#define DEBUG*/				/* Undef me for production */
+
+#ifdef DEBUG
+#define DPRINTF(x, a...) printk(KERN_DEBUG "W9966: %s(): "x, __func__ , ##a)
+#else
+#define DPRINTF(x...)
+#endif
+
+/*
+ *	Defines, simple typedefs etc.
+ */
+
+#define W9966_DRIVERNAME	"W9966CF Webcam"
+#define W9966_MAXCAMS		4	/* Maximum number of cameras */
+#define W9966_RBUFFER		2048	/* Read buffer (must be an even number) */
+#define W9966_SRAMSIZE		131072	/* 128kb */
+#define W9966_SRAMID		0x02	/* check w9966cf.pdf */
+
+/* Empirically determined window limits */
+#define W9966_WND_MIN_X		16
+#define W9966_WND_MIN_Y		14
+#define W9966_WND_MAX_X		705
+#define W9966_WND_MAX_Y		253
+#define W9966_WND_MAX_W		(W9966_WND_MAX_X - W9966_WND_MIN_X)
+#define W9966_WND_MAX_H		(W9966_WND_MAX_Y - W9966_WND_MIN_Y)
+
+/* Keep track of our current state */
+#define W9966_STATE_PDEV	0x01
+#define W9966_STATE_CLAIMED	0x02
+#define W9966_STATE_VDEV	0x04
+
+#define W9966_I2C_W_ID		0x48
+#define W9966_I2C_R_ID		0x49
+#define W9966_I2C_R_DATA	0x08
+#define W9966_I2C_R_CLOCK	0x04
+#define W9966_I2C_W_DATA	0x02
+#define W9966_I2C_W_CLOCK	0x01
+
+struct w9966 {
+	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler hdl;
+	unsigned char dev_state;
+	unsigned char i2c_state;
+	unsigned short ppmode;
+	struct parport *pport;
+	struct pardevice *pdev;
+	struct video_device vdev;
+	unsigned short width;
+	unsigned short height;
+	unsigned char brightness;
+	signed char contrast;
+	signed char color;
+	signed char hue;
+	struct mutex lock;
+};
+
+/*
+ *	Module specific properties
+ */
+
+MODULE_AUTHOR("Jakob Kemi <jakob.kemi@post.utfors.se>");
+MODULE_DESCRIPTION("Winbond w9966cf WebCam driver (0.32)");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("0.33.1");
+
+#ifdef MODULE
+static char *pardev[] = {[0 ... W9966_MAXCAMS] = ""};
+#else
+static char *pardev[] = {[0 ... W9966_MAXCAMS] = "aggressive"};
+#endif
+module_param_array(pardev, charp, NULL, 0);
+MODULE_PARM_DESC(pardev, "pardev: where to search for\n"
+		"\teach camera. 'aggressive' means brute-force search.\n"
+		"\tEg: >pardev=parport3,aggressive,parport2,parport1< would assign\n"
+		"\tcam 1 to parport3 and search every parport for cam 2 etc...");
+
+static int parmode;
+module_param(parmode, int, 0);
+MODULE_PARM_DESC(parmode, "parmode: transfer mode (0=auto, 1=ecp, 2=epp");
+
+static int video_nr = -1;
+module_param(video_nr, int, 0);
+
+static struct w9966 w9966_cams[W9966_MAXCAMS];
+
+/*
+ *	Private function defines
+ */
+
+
+/* Set camera phase flags, so we know what to uninit when terminating */
+static inline void w9966_set_state(struct w9966 *cam, int mask, int val)
+{
+	cam->dev_state = (cam->dev_state & ~mask) ^ val;
+}
+
+/* Get camera phase flags */
+static inline int w9966_get_state(struct w9966 *cam, int mask, int val)
+{
+	return ((cam->dev_state & mask) == val);
+}
+
+/* Claim parport for ourself */
+static void w9966_pdev_claim(struct w9966 *cam)
+{
+	if (w9966_get_state(cam, W9966_STATE_CLAIMED, W9966_STATE_CLAIMED))
+		return;
+	parport_claim_or_block(cam->pdev);
+	w9966_set_state(cam, W9966_STATE_CLAIMED, W9966_STATE_CLAIMED);
+}
+
+/* Release parport for others to use */
+static void w9966_pdev_release(struct w9966 *cam)
+{
+	if (w9966_get_state(cam, W9966_STATE_CLAIMED, 0))
+		return;
+	parport_release(cam->pdev);
+	w9966_set_state(cam, W9966_STATE_CLAIMED, 0);
+}
+
+/* Read register from W9966 interface-chip
+   Expects a claimed pdev
+   -1 on error, else register data (byte) */
+static int w9966_read_reg(struct w9966 *cam, int reg)
+{
+	/* ECP, read, regtransfer, REG, REG, REG, REG, REG */
+	const unsigned char addr = 0x80 | (reg & 0x1f);
+	unsigned char val;
+
+	if (parport_negotiate(cam->pport, cam->ppmode | IEEE1284_ADDR) != 0)
+		return -1;
+	if (parport_write(cam->pport, &addr, 1) != 1)
+		return -1;
+	if (parport_negotiate(cam->pport, cam->ppmode | IEEE1284_DATA) != 0)
+		return -1;
+	if (parport_read(cam->pport, &val, 1) != 1)
+		return -1;
+
+	return val;
+}
+
+/* Write register to W9966 interface-chip
+   Expects a claimed pdev
+   -1 on error */
+static int w9966_write_reg(struct w9966 *cam, int reg, int data)
+{
+	/* ECP, write, regtransfer, REG, REG, REG, REG, REG */
+	const unsigned char addr = 0xc0 | (reg & 0x1f);
+	const unsigned char val = data;
+
+	if (parport_negotiate(cam->pport, cam->ppmode | IEEE1284_ADDR) != 0)
+		return -1;
+	if (parport_write(cam->pport, &addr, 1) != 1)
+		return -1;
+	if (parport_negotiate(cam->pport, cam->ppmode | IEEE1284_DATA) != 0)
+		return -1;
+	if (parport_write(cam->pport, &val, 1) != 1)
+		return -1;
+
+	return 0;
+}
+
+/*
+ *	Ugly and primitive i2c protocol functions
+ */
+
+/* Sets the data line on the i2c bus.
+   Expects a claimed pdev. */
+static void w9966_i2c_setsda(struct w9966 *cam, int state)
+{
+	if (state)
+		cam->i2c_state |= W9966_I2C_W_DATA;
+	else
+		cam->i2c_state &= ~W9966_I2C_W_DATA;
+
+	w9966_write_reg(cam, 0x18, cam->i2c_state);
+	udelay(5);
+}
+
+/* Get peripheral clock line
+   Expects a claimed pdev. */
+static int w9966_i2c_getscl(struct w9966 *cam)
+{
+	const unsigned char state = w9966_read_reg(cam, 0x18);
+	return ((state & W9966_I2C_R_CLOCK) > 0);
+}
+
+/* Sets the clock line on the i2c bus.
+   Expects a claimed pdev. -1 on error */
+static int w9966_i2c_setscl(struct w9966 *cam, int state)
+{
+	unsigned long timeout;
+
+	if (state)
+		cam->i2c_state |= W9966_I2C_W_CLOCK;
+	else
+		cam->i2c_state &= ~W9966_I2C_W_CLOCK;
+
+	w9966_write_reg(cam, 0x18, cam->i2c_state);
+	udelay(5);
+
+	/* we go to high, we also expect the peripheral to ack. */
+	if (state) {
+		timeout = jiffies + 100;
+		while (!w9966_i2c_getscl(cam)) {
+			if (time_after(jiffies, timeout))
+				return -1;
+		}
+	}
+	return 0;
+}
+
+#if 0
+/* Get peripheral data line
+   Expects a claimed pdev. */
+static int w9966_i2c_getsda(struct w9966 *cam)
+{
+	const unsigned char state = w9966_read_reg(cam, 0x18);
+	return ((state & W9966_I2C_R_DATA) > 0);
+}
+#endif
+
+/* Write a byte with ack to the i2c bus.
+   Expects a claimed pdev. -1 on error */
+static int w9966_i2c_wbyte(struct w9966 *cam, int data)
+{
+	int i;
+
+	for (i = 7; i >= 0; i--) {
+		w9966_i2c_setsda(cam, (data >> i) & 0x01);
+
+		if (w9966_i2c_setscl(cam, 1) == -1)
+			return -1;
+		w9966_i2c_setscl(cam, 0);
+	}
+
+	w9966_i2c_setsda(cam, 1);
+
+	if (w9966_i2c_setscl(cam, 1) == -1)
+		return -1;
+	w9966_i2c_setscl(cam, 0);
+
+	return 0;
+}
+
+/* Read a data byte with ack from the i2c-bus
+   Expects a claimed pdev. -1 on error */
+#if 0
+static int w9966_i2c_rbyte(struct w9966 *cam)
+{
+	unsigned char data = 0x00;
+	int i;
+
+	w9966_i2c_setsda(cam, 1);
+
+	for (i = 0; i < 8; i++) {
+		if (w9966_i2c_setscl(cam, 1) == -1)
+			return -1;
+		data = data << 1;
+		if (w9966_i2c_getsda(cam))
+			data |= 0x01;
+
+		w9966_i2c_setscl(cam, 0);
+	}
+	return data;
+}
+#endif
+
+/* Read a register from the i2c device.
+   Expects claimed pdev. -1 on error */
+#if 0
+static int w9966_read_reg_i2c(struct w9966 *cam, int reg)
+{
+	int data;
+
+	w9966_i2c_setsda(cam, 0);
+	w9966_i2c_setscl(cam, 0);
+
+	if (w9966_i2c_wbyte(cam, W9966_I2C_W_ID) == -1 ||
+	    w9966_i2c_wbyte(cam, reg) == -1)
+		return -1;
+
+	w9966_i2c_setsda(cam, 1);
+	if (w9966_i2c_setscl(cam, 1) == -1)
+		return -1;
+	w9966_i2c_setsda(cam, 0);
+	w9966_i2c_setscl(cam, 0);
+
+	if (w9966_i2c_wbyte(cam, W9966_I2C_R_ID) == -1)
+		return -1;
+	data = w9966_i2c_rbyte(cam);
+	if (data == -1)
+		return -1;
+
+	w9966_i2c_setsda(cam, 0);
+
+	if (w9966_i2c_setscl(cam, 1) == -1)
+		return -1;
+	w9966_i2c_setsda(cam, 1);
+
+	return data;
+}
+#endif
+
+/* Write a register to the i2c device.
+   Expects claimed pdev. -1 on error */
+static int w9966_write_reg_i2c(struct w9966 *cam, int reg, int data)
+{
+	w9966_i2c_setsda(cam, 0);
+	w9966_i2c_setscl(cam, 0);
+
+	if (w9966_i2c_wbyte(cam, W9966_I2C_W_ID) == -1 ||
+			w9966_i2c_wbyte(cam, reg) == -1 ||
+			w9966_i2c_wbyte(cam, data) == -1)
+		return -1;
+
+	w9966_i2c_setsda(cam, 0);
+	if (w9966_i2c_setscl(cam, 1) == -1)
+		return -1;
+
+	w9966_i2c_setsda(cam, 1);
+
+	return 0;
+}
+
+/* Find a good length for capture window (used both for W and H)
+   A bit ugly but pretty functional. The capture length
+   have to match the downscale */
+static int w9966_findlen(int near, int size, int maxlen)
+{
+	int bestlen = size;
+	int besterr = abs(near - bestlen);
+	int len;
+
+	for (len = size + 1; len < maxlen; len++) {
+		int err;
+		if (((64 * size) % len) != 0)
+			continue;
+
+		err = abs(near - len);
+
+		/* Only continue as long as we keep getting better values */
+		if (err > besterr)
+			break;
+
+		besterr = err;
+		bestlen = len;
+	}
+
+	return bestlen;
+}
+
+/* Modify capture window (if necessary)
+   and calculate downscaling
+   Return -1 on error */
+static int w9966_calcscale(int size, int min, int max, int *beg, int *end, unsigned char *factor)
+{
+	int maxlen = max - min;
+	int len = *end - *beg + 1;
+	int newlen = w9966_findlen(len, size, maxlen);
+	int err = newlen - len;
+
+	/* Check for bad format */
+	if (newlen > maxlen || newlen < size)
+		return -1;
+
+	/* Set factor (6 bit fixed) */
+	*factor = (64 * size) / newlen;
+	if (*factor == 64)
+		*factor = 0x00;	/* downscale is disabled */
+	else
+		*factor |= 0x80; /* set downscale-enable bit */
+
+	/* Modify old beginning and end */
+	*beg -= err / 2;
+	*end += err - (err / 2);
+
+	/* Move window if outside borders */
+	if (*beg < min) {
+		*end += min - *beg;
+		*beg += min - *beg;
+	}
+	if (*end > max) {
+		*beg -= *end - max;
+		*end -= *end - max;
+	}
+
+	return 0;
+}
+
+/* Setup the cameras capture window etc.
+   Expects a claimed pdev
+   return -1 on error */
+static int w9966_setup(struct w9966 *cam, int x1, int y1, int x2, int y2, int w, int h)
+{
+	unsigned int i;
+	unsigned int enh_s, enh_e;
+	unsigned char scale_x, scale_y;
+	unsigned char regs[0x1c];
+	unsigned char saa7111_regs[] = {
+		0x21, 0x00, 0xd8, 0x23, 0x00, 0x80, 0x80, 0x00,
+		0x88, 0x10, 0x80, 0x40, 0x40, 0x00, 0x01, 0x00,
+		0x48, 0x0c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x71, 0xe7, 0x00, 0x00, 0xc0
+	};
+
+
+	if (w * h * 2 > W9966_SRAMSIZE) {
+		DPRINTF("capture window exceeds SRAM size!.\n");
+		w = 200; h = 160;	/* Pick default values */
+	}
+
+	w &= ~0x1;
+	if (w < 2)
+		w = 2;
+	if (h < 1)
+		h = 1;
+	if (w > W9966_WND_MAX_W)
+		w = W9966_WND_MAX_W;
+	if (h > W9966_WND_MAX_H)
+		h = W9966_WND_MAX_H;
+
+	cam->width = w;
+	cam->height = h;
+
+	enh_s = 0;
+	enh_e = w * h * 2;
+
+	/* Modify capture window if necessary and calculate downscaling */
+	if (w9966_calcscale(w, W9966_WND_MIN_X, W9966_WND_MAX_X, &x1, &x2, &scale_x) != 0 ||
+			w9966_calcscale(h, W9966_WND_MIN_Y, W9966_WND_MAX_Y, &y1, &y2, &scale_y) != 0)
+		return -1;
+
+	DPRINTF("%dx%d, x: %d<->%d, y: %d<->%d, sx: %d/64, sy: %d/64.\n",
+			w, h, x1, x2, y1, y2, scale_x & ~0x80, scale_y & ~0x80);
+
+	/* Setup registers */
+	regs[0x00] = 0x00;			/* Set normal operation */
+	regs[0x01] = 0x18;			/* Capture mode */
+	regs[0x02] = scale_y;			/* V-scaling */
+	regs[0x03] = scale_x;			/* H-scaling */
+
+	/* Capture window */
+	regs[0x04] = (x1 & 0x0ff);		/* X-start (8 low bits) */
+	regs[0x05] = (x1 & 0x300)>>8;		/* X-start (2 high bits) */
+	regs[0x06] = (y1 & 0x0ff);		/* Y-start (8 low bits) */
+	regs[0x07] = (y1 & 0x300)>>8;		/* Y-start (2 high bits) */
+	regs[0x08] = (x2 & 0x0ff);		/* X-end (8 low bits) */
+	regs[0x09] = (x2 & 0x300)>>8;		/* X-end (2 high bits) */
+	regs[0x0a] = (y2 & 0x0ff);		/* Y-end (8 low bits) */
+
+	regs[0x0c] = W9966_SRAMID;		/* SRAM-banks (1x 128kb) */
+
+	/* Enhancement layer */
+	regs[0x0d] = (enh_s & 0x000ff);		/* Enh. start (0-7) */
+	regs[0x0e] = (enh_s & 0x0ff00) >> 8;	/* Enh. start (8-15) */
+	regs[0x0f] = (enh_s & 0x70000) >> 16;	/* Enh. start (16-17/18??) */
+	regs[0x10] = (enh_e & 0x000ff);		/* Enh. end (0-7) */
+	regs[0x11] = (enh_e & 0x0ff00) >> 8;	/* Enh. end (8-15) */
+	regs[0x12] = (enh_e & 0x70000) >> 16;	/* Enh. end (16-17/18??) */
+
+	/* Misc */
+	regs[0x13] = 0x40;			/* VEE control (raw 4:2:2) */
+	regs[0x17] = 0x00;			/* ??? */
+	regs[0x18] = cam->i2c_state = 0x00;	/* Serial bus */
+	regs[0x19] = 0xff;			/* I/O port direction control */
+	regs[0x1a] = 0xff;			/* I/O port data register */
+	regs[0x1b] = 0x10;			/* ??? */
+
+	/* SAA7111 chip settings */
+	saa7111_regs[0x0a] = cam->brightness;
+	saa7111_regs[0x0b] = cam->contrast;
+	saa7111_regs[0x0c] = cam->color;
+	saa7111_regs[0x0d] = cam->hue;
+
+	/* Reset (ECP-fifo & serial-bus) */
+	if (w9966_write_reg(cam, 0x00, 0x03) == -1)
+		return -1;
+
+	/* Write regs to w9966cf chip */
+	for (i = 0; i < 0x1c; i++)
+		if (w9966_write_reg(cam, i, regs[i]) == -1)
+			return -1;
+
+	/* Write regs to saa7111 chip */
+	for (i = 0; i < 0x20; i++)
+		if (w9966_write_reg_i2c(cam, i, saa7111_regs[i]) == -1)
+			return -1;
+
+	return 0;
+}
+
+/*
+ *	Video4linux interfacing
+ */
+
+static int cam_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *vcap)
+{
+	struct w9966 *cam = video_drvdata(file);
+
+	strlcpy(vcap->driver, cam->v4l2_dev.name, sizeof(vcap->driver));
+	strlcpy(vcap->card, W9966_DRIVERNAME, sizeof(vcap->card));
+	strlcpy(vcap->bus_info, "parport", sizeof(vcap->bus_info));
+	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
+	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int cam_enum_input(struct file *file, void *fh, struct v4l2_input *vin)
+{
+	if (vin->index > 0)
+		return -EINVAL;
+	strlcpy(vin->name, "Camera", sizeof(vin->name));
+	vin->type = V4L2_INPUT_TYPE_CAMERA;
+	vin->audioset = 0;
+	vin->tuner = 0;
+	vin->std = 0;
+	vin->status = 0;
+	return 0;
+}
+
+static int cam_g_input(struct file *file, void *fh, unsigned int *inp)
+{
+	*inp = 0;
+	return 0;
+}
+
+static int cam_s_input(struct file *file, void *fh, unsigned int inp)
+{
+	return (inp > 0) ? -EINVAL : 0;
+}
+
+static int cam_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct w9966 *cam =
+		container_of(ctrl->handler, struct w9966, hdl);
+	int ret = 0;
+
+	mutex_lock(&cam->lock);
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		cam->brightness = ctrl->val;
+		break;
+	case V4L2_CID_CONTRAST:
+		cam->contrast = ctrl->val;
+		break;
+	case V4L2_CID_SATURATION:
+		cam->color = ctrl->val;
+		break;
+	case V4L2_CID_HUE:
+		cam->hue = ctrl->val;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (ret == 0) {
+		w9966_pdev_claim(cam);
+
+		if (w9966_write_reg_i2c(cam, 0x0a, cam->brightness) == -1 ||
+		    w9966_write_reg_i2c(cam, 0x0b, cam->contrast) == -1 ||
+		    w9966_write_reg_i2c(cam, 0x0c, cam->color) == -1 ||
+		    w9966_write_reg_i2c(cam, 0x0d, cam->hue) == -1) {
+			ret = -EIO;
+		}
+
+		w9966_pdev_release(cam);
+	}
+	mutex_unlock(&cam->lock);
+	return ret;
+}
+
+static int cam_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct w9966 *cam = video_drvdata(file);
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+
+	pix->width = cam->width;
+	pix->height = cam->height;
+	pix->pixelformat = V4L2_PIX_FMT_YUYV;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = 2 * cam->width;
+	pix->sizeimage = 2 * cam->width * cam->height;
+	/* Just a guess */
+	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	return 0;
+}
+
+static int cam_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+
+	if (pix->width < 2)
+		pix->width = 2;
+	if (pix->height < 1)
+		pix->height = 1;
+	if (pix->width > W9966_WND_MAX_W)
+		pix->width = W9966_WND_MAX_W;
+	if (pix->height > W9966_WND_MAX_H)
+		pix->height = W9966_WND_MAX_H;
+	pix->pixelformat = V4L2_PIX_FMT_YUYV;
+	pix->field = V4L2_FIELD_NONE;
+	pix->bytesperline = 2 * pix->width;
+	pix->sizeimage = 2 * pix->width * pix->height;
+	/* Just a guess */
+	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	return 0;
+}
+
+static int cam_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
+{
+	struct w9966 *cam = video_drvdata(file);
+	struct v4l2_pix_format *pix = &fmt->fmt.pix;
+	int ret = cam_try_fmt_vid_cap(file, fh, fmt);
+
+	if (ret)
+		return ret;
+
+	mutex_lock(&cam->lock);
+	/* Update camera regs */
+	w9966_pdev_claim(cam);
+	ret = w9966_setup(cam, 0, 0, 1023, 1023, pix->width, pix->height);
+	w9966_pdev_release(cam);
+	mutex_unlock(&cam->lock);
+	return ret;
+}
+
+static int cam_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdesc *fmt)
+{
+	static struct v4l2_fmtdesc formats[] = {
+		{ 0, 0, 0,
+		  "YUV 4:2:2", V4L2_PIX_FMT_YUYV,
+		  { 0, 0, 0, 0 }
+		},
+	};
+	enum v4l2_buf_type type = fmt->type;
+
+	if (fmt->index > 0)
+		return -EINVAL;
+
+	*fmt = formats[fmt->index];
+	fmt->type = type;
+	return 0;
+}
+
+/* Capture data */
+static ssize_t w9966_v4l_read(struct file *file, char  __user *buf,
+		size_t count, loff_t *ppos)
+{
+	struct w9966 *cam = video_drvdata(file);
+	unsigned char addr = 0xa0;	/* ECP, read, CCD-transfer, 00000 */
+	unsigned char __user *dest = (unsigned char __user *)buf;
+	unsigned long dleft = count;
+	unsigned char *tbuf;
+
+	/* Why would anyone want more than this?? */
+	if (count > cam->width * cam->height * 2)
+		return -EINVAL;
+
+	mutex_lock(&cam->lock);
+	w9966_pdev_claim(cam);
+	w9966_write_reg(cam, 0x00, 0x02);	/* Reset ECP-FIFO buffer */
+	w9966_write_reg(cam, 0x00, 0x00);	/* Return to normal operation */
+	w9966_write_reg(cam, 0x01, 0x98);	/* Enable capture */
+
+	/* write special capture-addr and negotiate into data transfer */
+	if ((parport_negotiate(cam->pport, cam->ppmode|IEEE1284_ADDR) != 0) ||
+			(parport_write(cam->pport, &addr, 1) != 1) ||
+			(parport_negotiate(cam->pport, cam->ppmode|IEEE1284_DATA) != 0)) {
+		w9966_pdev_release(cam);
+		mutex_unlock(&cam->lock);
+		return -EFAULT;
+	}
+
+	tbuf = kmalloc(W9966_RBUFFER, GFP_KERNEL);
+	if (tbuf == NULL) {
+		count = -ENOMEM;
+		goto out;
+	}
+
+	while (dleft > 0) {
+		unsigned long tsize = (dleft > W9966_RBUFFER) ? W9966_RBUFFER : dleft;
+
+		if (parport_read(cam->pport, tbuf, tsize) < tsize) {
+			count = -EFAULT;
+			goto out;
+		}
+		if (copy_to_user(dest, tbuf, tsize) != 0) {
+			count = -EFAULT;
+			goto out;
+		}
+		dest += tsize;
+		dleft -= tsize;
+	}
+
+	w9966_write_reg(cam, 0x01, 0x18);	/* Disable capture */
+
+out:
+	kfree(tbuf);
+	w9966_pdev_release(cam);
+	mutex_unlock(&cam->lock);
+
+	return count;
+}
+
+static const struct v4l2_file_operations w9966_fops = {
+	.owner		= THIS_MODULE,
+	.open		= v4l2_fh_open,
+	.release	= v4l2_fh_release,
+	.poll		= v4l2_ctrl_poll,
+	.unlocked_ioctl = video_ioctl2,
+	.read           = w9966_v4l_read,
+};
+
+static const struct v4l2_ioctl_ops w9966_ioctl_ops = {
+	.vidioc_querycap    		    = cam_querycap,
+	.vidioc_g_input      		    = cam_g_input,
+	.vidioc_s_input      		    = cam_s_input,
+	.vidioc_enum_input   		    = cam_enum_input,
+	.vidioc_enum_fmt_vid_cap 	    = cam_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap 		    = cam_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap  		    = cam_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap  	    = cam_try_fmt_vid_cap,
+	.vidioc_log_status		    = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		    = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	    = v4l2_event_unsubscribe,
+};
+
+static const struct v4l2_ctrl_ops cam_ctrl_ops = {
+	.s_ctrl = cam_s_ctrl,
+};
+
+
+/* Initialize camera device. Setup all internal flags, set a
+   default video mode, setup ccd-chip, register v4l device etc..
+   Also used for 'probing' of hardware.
+   -1 on error */
+static int w9966_init(struct w9966 *cam, struct parport *port)
+{
+	struct v4l2_device *v4l2_dev = &cam->v4l2_dev;
+
+	if (cam->dev_state != 0)
+		return -1;
+
+	strlcpy(v4l2_dev->name, "w9966", sizeof(v4l2_dev->name));
+
+	if (v4l2_device_register(NULL, v4l2_dev) < 0) {
+		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
+		return -1;
+	}
+
+	v4l2_ctrl_handler_init(&cam->hdl, 4);
+	v4l2_ctrl_new_std(&cam->hdl, &cam_ctrl_ops,
+			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&cam->hdl, &cam_ctrl_ops,
+			  V4L2_CID_CONTRAST, -64, 64, 1, 64);
+	v4l2_ctrl_new_std(&cam->hdl, &cam_ctrl_ops,
+			  V4L2_CID_SATURATION, -64, 64, 1, 64);
+	v4l2_ctrl_new_std(&cam->hdl, &cam_ctrl_ops,
+			  V4L2_CID_HUE, -128, 127, 1, 0);
+	if (cam->hdl.error) {
+		v4l2_err(v4l2_dev, "couldn't register controls\n");
+		return -1;
+	}
+	cam->pport = port;
+	cam->brightness = 128;
+	cam->contrast = 64;
+	cam->color = 64;
+	cam->hue = 0;
+
+	/* Select requested transfer mode */
+	switch (parmode) {
+	default:	/* Auto-detect (priority: hw-ecp, hw-epp, sw-ecp) */
+	case 0:
+		if (port->modes & PARPORT_MODE_ECP)
+			cam->ppmode = IEEE1284_MODE_ECP;
+		else if (port->modes & PARPORT_MODE_EPP)
+			cam->ppmode = IEEE1284_MODE_EPP;
+		else
+			cam->ppmode = IEEE1284_MODE_ECP;
+		break;
+	case 1:		/* hw- or sw-ecp */
+		cam->ppmode = IEEE1284_MODE_ECP;
+		break;
+	case 2:		/* hw- or sw-epp */
+		cam->ppmode = IEEE1284_MODE_EPP;
+		break;
+	}
+
+	/* Tell the parport driver that we exists */
+	cam->pdev = parport_register_device(port, "w9966", NULL, NULL, NULL, 0, NULL);
+	if (cam->pdev == NULL) {
+		DPRINTF("parport_register_device() failed\n");
+		return -1;
+	}
+	w9966_set_state(cam, W9966_STATE_PDEV, W9966_STATE_PDEV);
+
+	w9966_pdev_claim(cam);
+
+	/* Setup a default capture mode */
+	if (w9966_setup(cam, 0, 0, 1023, 1023, 200, 160) != 0) {
+		DPRINTF("w9966_setup() failed.\n");
+		return -1;
+	}
+
+	w9966_pdev_release(cam);
+
+	/* Fill in the video_device struct and register us to v4l */
+	strlcpy(cam->vdev.name, W9966_DRIVERNAME, sizeof(cam->vdev.name));
+	cam->vdev.v4l2_dev = v4l2_dev;
+	cam->vdev.fops = &w9966_fops;
+	cam->vdev.ioctl_ops = &w9966_ioctl_ops;
+	cam->vdev.release = video_device_release_empty;
+	cam->vdev.ctrl_handler = &cam->hdl;
+	set_bit(V4L2_FL_USE_FH_PRIO, &cam->vdev.flags);
+	video_set_drvdata(&cam->vdev, cam);
+
+	mutex_init(&cam->lock);
+
+	if (video_register_device(&cam->vdev, VFL_TYPE_GRABBER, video_nr) < 0)
+		return -1;
+
+	w9966_set_state(cam, W9966_STATE_VDEV, W9966_STATE_VDEV);
+
+	/* All ok */
+	v4l2_info(v4l2_dev, "Found and initialized a webcam on %s.\n",
+			cam->pport->name);
+	return 0;
+}
+
+
+/* Terminate everything gracefully */
+static void w9966_term(struct w9966 *cam)
+{
+	/* Unregister from v4l */
+	if (w9966_get_state(cam, W9966_STATE_VDEV, W9966_STATE_VDEV)) {
+		video_unregister_device(&cam->vdev);
+		w9966_set_state(cam, W9966_STATE_VDEV, 0);
+	}
+
+	v4l2_ctrl_handler_free(&cam->hdl);
+
+	/* Terminate from IEEE1284 mode and release pdev block */
+	if (w9966_get_state(cam, W9966_STATE_PDEV, W9966_STATE_PDEV)) {
+		w9966_pdev_claim(cam);
+		parport_negotiate(cam->pport, IEEE1284_MODE_COMPAT);
+		w9966_pdev_release(cam);
+	}
+
+	/* Unregister from parport */
+	if (w9966_get_state(cam, W9966_STATE_PDEV, W9966_STATE_PDEV)) {
+		parport_unregister_device(cam->pdev);
+		w9966_set_state(cam, W9966_STATE_PDEV, 0);
+	}
+	memset(cam, 0, sizeof(*cam));
+}
+
+
+/* Called once for every parport on init */
+static void w9966_attach(struct parport *port)
+{
+	int i;
+
+	for (i = 0; i < W9966_MAXCAMS; i++) {
+		if (w9966_cams[i].dev_state != 0)	/* Cam is already assigned */
+			continue;
+		if (strcmp(pardev[i], "aggressive") == 0 || strcmp(pardev[i], port->name) == 0) {
+			if (w9966_init(&w9966_cams[i], port) != 0)
+				w9966_term(&w9966_cams[i]);
+			break;	/* return */
+		}
+	}
+}
+
+/* Called once for every parport on termination */
+static void w9966_detach(struct parport *port)
+{
+	int i;
+
+	for (i = 0; i < W9966_MAXCAMS; i++)
+		if (w9966_cams[i].dev_state != 0 && w9966_cams[i].pport == port)
+			w9966_term(&w9966_cams[i]);
+}
+
+
+static struct parport_driver w9966_ppd = {
+	.name = W9966_DRIVERNAME,
+	.attach = w9966_attach,
+	.detach = w9966_detach,
+};
+
+/* Module entry point */
+static int __init w9966_mod_init(void)
+{
+	int i;
+
+	for (i = 0; i < W9966_MAXCAMS; i++)
+		w9966_cams[i].dev_state = 0;
+
+	return parport_register_driver(&w9966_ppd);
+}
+
+/* Module cleanup */
+static void __exit w9966_mod_term(void)
+{
+	parport_unregister_driver(&w9966_ppd);
+}
+
+module_init(w9966_mod_init);
+module_exit(w9966_mod_term);
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index d545d93..f9703a0 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -606,67 +606,6 @@ config VIDEO_VIVI
 	  In doubt, say N.
 
 #
-# ISA & parallel port drivers configuration
-#	All devices here are webcam or grabber devices
-#
-
-menuconfig V4L_ISA_PARPORT_DRIVERS
-	bool "V4L ISA and parallel port devices"
-	depends on ISA || PARPORT
-	depends on MEDIA_CAMERA_SUPPORT
-	default n
-	---help---
-	  Say Y here to enable support for these ISA and parallel port drivers.
-
-if V4L_ISA_PARPORT_DRIVERS
-
-config VIDEO_BWQCAM
-	tristate "Quickcam BW Video For Linux"
-	depends on PARPORT && VIDEO_V4L2
-	help
-	  Say Y have if you the black and white version of the QuickCam
-	  camera. See the next option for the color version.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called bw-qcam.
-
-config VIDEO_CQCAM
-	tristate "QuickCam Colour Video For Linux"
-	depends on PARPORT && VIDEO_V4L2
-	help
-	  This is the video4linux driver for the colour version of the
-	  Connectix QuickCam.  If you have one of these cameras, say Y here,
-	  otherwise say N.  This driver does not work with the original
-	  monochrome QuickCam, QuickCam VC or QuickClip.  It is also available
-	  as a module (c-qcam).
-	  Read <file:Documentation/video4linux/CQcam.txt> for more information.
-
-config VIDEO_PMS
-	tristate "Mediavision Pro Movie Studio Video For Linux"
-	depends on ISA && VIDEO_V4L2
-	help
-	  Say Y if you have the ISA Mediavision Pro Movie Studio
-	  capture card.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called pms.
-
-config VIDEO_W9966
-	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux"
-	depends on PARPORT_1284 && PARPORT && VIDEO_V4L2
-	help
-	  Video4linux driver for Winbond's w9966 based Webcams.
-	  Currently tested with the LifeView FlyCam Supra.
-	  If you have one of these cameras, say Y here
-	  otherwise say N.
-	  This driver is also available as a module (w9966).
-
-	  Check out <file:Documentation/video4linux/w9966.txt> for more
-	  information.
-
-endif # V4L_ISA_PARPORT_DRIVERS
-
-#
 # Platform drivers
 #	All drivers here are currently for webcam support
 
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index f212af3..a0c6692 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -87,10 +87,6 @@ obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 
 # And now the v4l2 drivers:
 
-obj-$(CONFIG_VIDEO_CQCAM) += c-qcam.o
-obj-$(CONFIG_VIDEO_BWQCAM) += bw-qcam.o
-obj-$(CONFIG_VIDEO_W9966) += w9966.o
-obj-$(CONFIG_VIDEO_PMS) += pms.o
 obj-$(CONFIG_VIDEO_VINO) += vino.o
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
 
diff --git a/drivers/media/video/bw-qcam.c b/drivers/media/video/bw-qcam.c
deleted file mode 100644
index 5b75a64..0000000
--- a/drivers/media/video/bw-qcam.c
+++ /dev/null
@@ -1,1113 +0,0 @@
-/*
- *    QuickCam Driver For Video4Linux.
- *
- *	Video4Linux conversion work by Alan Cox.
- *	Parport compatibility by Phil Blundell.
- *	Busy loop avoidance by Mark Cooke.
- *
- *    Module parameters:
- *
- *	maxpoll=<1 - 5000>
- *
- *	  When polling the QuickCam for a response, busy-wait for a
- *	  maximum of this many loops. The default of 250 gives little
- *	  impact on interactive response.
- *
- *	  NOTE: If this parameter is set too high, the processor
- *		will busy wait until this loop times out, and then
- *		slowly poll for a further 5 seconds before failing
- *		the transaction. You have been warned.
- *
- *	yieldlines=<1 - 250>
- *
- *	  When acquiring a frame from the camera, the data gathering
- *	  loop will yield back to the scheduler after completing
- *	  this many lines. The default of 4 provides a trade-off
- *	  between increased frame acquisition time and impact on
- *	  interactive response.
- */
-
-/* qcam-lib.c -- Library for programming with the Connectix QuickCam.
- * See the included documentation for usage instructions and details
- * of the protocol involved. */
-
-
-/* Version 0.5, August 4, 1996 */
-/* Version 0.7, August 27, 1996 */
-/* Version 0.9, November 17, 1996 */
-
-
-/******************************************************************
-
-Copyright (C) 1996 by Scott Laird
-
-Permission is hereby granted, free of charge, to any person obtaining
-a copy of this software and associated documentation files (the
-"Software"), to deal in the Software without restriction, including
-without limitation the rights to use, copy, modify, merge, publish,
-distribute, sublicense, and/or sell copies of the Software, and to
-permit persons to whom the Software is furnished to do so, subject to
-the following conditions:
-
-The above copyright notice and this permission notice shall be
-included in all copies or substantial portions of the Software.
-
-THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-IN NO EVENT SHALL SCOTT LAIRD BE LIABLE FOR ANY CLAIM, DAMAGES OR
-OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-OTHER DEALINGS IN THE SOFTWARE.
-
-******************************************************************/
-
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/mm.h>
-#include <linux/parport.h>
-#include <linux/sched.h>
-#include <linux/videodev2.h>
-#include <linux/mutex.h>
-#include <asm/uaccess.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-fh.h>
-#include <media/v4l2-ctrls.h>
-#include <media/v4l2-event.h>
-
-/* One from column A... */
-#define QC_NOTSET 0
-#define QC_UNIDIR 1
-#define QC_BIDIR  2
-#define QC_SERIAL 3
-
-/* ... and one from column B */
-#define QC_ANY          0x00
-#define QC_FORCE_UNIDIR 0x10
-#define QC_FORCE_BIDIR  0x20
-#define QC_FORCE_SERIAL 0x30
-/* in the port_mode member */
-
-#define QC_MODE_MASK    0x07
-#define QC_FORCE_MASK   0x70
-
-#define MAX_HEIGHT 243
-#define MAX_WIDTH 336
-
-/* Bit fields for status flags */
-#define QC_PARAM_CHANGE	0x01 /* Camera status change has occurred */
-
-struct qcam {
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	struct v4l2_ctrl_handler hdl;
-	struct pardevice *pdev;
-	struct parport *pport;
-	struct mutex lock;
-	int width, height;
-	int bpp;
-	int mode;
-	int contrast, brightness, whitebal;
-	int port_mode;
-	int transfer_scale;
-	int top, left;
-	int status;
-	unsigned int saved_bits;
-	unsigned long in_use;
-};
-
-static unsigned int maxpoll = 250;   /* Maximum busy-loop count for qcam I/O */
-static unsigned int yieldlines = 4;  /* Yield after this many during capture */
-static int video_nr = -1;
-static unsigned int force_init;		/* Whether to probe aggressively */
-
-module_param(maxpoll, int, 0);
-module_param(yieldlines, int, 0);
-module_param(video_nr, int, 0);
-
-/* Set force_init=1 to avoid detection by polling status register and
- * immediately attempt to initialize qcam */
-module_param(force_init, int, 0);
-
-#define MAX_CAMS 4
-static struct qcam *qcams[MAX_CAMS];
-static unsigned int num_cams;
-
-static inline int read_lpstatus(struct qcam *q)
-{
-	return parport_read_status(q->pport);
-}
-
-static inline int read_lpdata(struct qcam *q)
-{
-	return parport_read_data(q->pport);
-}
-
-static inline void write_lpdata(struct qcam *q, int d)
-{
-	parport_write_data(q->pport, d);
-}
-
-static void write_lpcontrol(struct qcam *q, int d)
-{
-	if (d & 0x20) {
-		/* Set bidirectional mode to reverse (data in) */
-		parport_data_reverse(q->pport);
-	} else {
-		/* Set bidirectional mode to forward (data out) */
-		parport_data_forward(q->pport);
-	}
-
-	/* Now issue the regular port command, but strip out the
-	 * direction flag */
-	d &= ~0x20;
-	parport_write_control(q->pport, d);
-}
-
-
-/* qc_waithand busy-waits for a handshake signal from the QuickCam.
- * Almost all communication with the camera requires handshaking. */
-
-static int qc_waithand(struct qcam *q, int val)
-{
-	int status;
-	int runs = 0;
-
-	if (val) {
-		while (!((status = read_lpstatus(q)) & 8)) {
-			/* 1000 is enough spins on the I/O for all normal
-			   cases, at that point we start to poll slowly
-			   until the camera wakes up. However, we are
-			   busy blocked until the camera responds, so
-			   setting it lower is much better for interactive
-			   response. */
-
-			if (runs++ > maxpoll)
-				msleep_interruptible(5);
-			if (runs > (maxpoll + 1000)) /* 5 seconds */
-				return -1;
-		}
-	} else {
-		while (((status = read_lpstatus(q)) & 8)) {
-			/* 1000 is enough spins on the I/O for all normal
-			   cases, at that point we start to poll slowly
-			   until the camera wakes up. However, we are
-			   busy blocked until the camera responds, so
-			   setting it lower is much better for interactive
-			   response. */
-
-			if (runs++ > maxpoll)
-				msleep_interruptible(5);
-			if (runs++ > (maxpoll + 1000)) /* 5 seconds */
-				return -1;
-		}
-	}
-
-	return status;
-}
-
-/* Waithand2 is used when the qcam is in bidirectional mode, and the
- * handshaking signal is CamRdy2 (bit 0 of data reg) instead of CamRdy1
- * (bit 3 of status register).  It also returns the last value read,
- * since this data is useful. */
-
-static unsigned int qc_waithand2(struct qcam *q, int val)
-{
-	unsigned int status;
-	int runs = 0;
-
-	do {
-		status = read_lpdata(q);
-		/* 1000 is enough spins on the I/O for all normal
-		   cases, at that point we start to poll slowly
-		   until the camera wakes up. However, we are
-		   busy blocked until the camera responds, so
-		   setting it lower is much better for interactive
-		   response. */
-
-		if (runs++ > maxpoll)
-			msleep_interruptible(5);
-		if (runs++ > (maxpoll + 1000)) /* 5 seconds */
-			return 0;
-	} while ((status & 1) != val);
-
-	return status;
-}
-
-/* qc_command is probably a bit of a misnomer -- it's used to send
- * bytes *to* the camera.  Generally, these bytes are either commands
- * or arguments to commands, so the name fits, but it still bugs me a
- * bit.  See the documentation for a list of commands. */
-
-static int qc_command(struct qcam *q, int command)
-{
-	int n1, n2;
-	int cmd;
-
-	write_lpdata(q, command);
-	write_lpcontrol(q, 6);
-
-	n1 = qc_waithand(q, 1);
-
-	write_lpcontrol(q, 0xe);
-	n2 = qc_waithand(q, 0);
-
-	cmd = (n1 & 0xf0) | ((n2 & 0xf0) >> 4);
-	return cmd;
-}
-
-static int qc_readparam(struct qcam *q)
-{
-	int n1, n2;
-	int cmd;
-
-	write_lpcontrol(q, 6);
-	n1 = qc_waithand(q, 1);
-
-	write_lpcontrol(q, 0xe);
-	n2 = qc_waithand(q, 0);
-
-	cmd = (n1 & 0xf0) | ((n2 & 0xf0) >> 4);
-	return cmd;
-}
-
-
-/* Try to detect a QuickCam.  It appears to flash the upper 4 bits of
-   the status register at 5-10 Hz.  This is only used in the autoprobe
-   code.  Be aware that this isn't the way Connectix detects the
-   camera (they send a reset and try to handshake), but this should be
-   almost completely safe, while their method screws up my printer if
-   I plug it in before the camera. */
-
-static int qc_detect(struct qcam *q)
-{
-	int reg, lastreg;
-	int count = 0;
-	int i;
-
-	if (force_init)
-		return 1;
-
-	lastreg = reg = read_lpstatus(q) & 0xf0;
-
-	for (i = 0; i < 500; i++) {
-		reg = read_lpstatus(q) & 0xf0;
-		if (reg != lastreg)
-			count++;
-		lastreg = reg;
-		mdelay(2);
-	}
-
-
-#if 0
-	/* Force camera detection during testing. Sometimes the camera
-	   won't be flashing these bits. Possibly unloading the module
-	   in the middle of a grab? Or some timeout condition?
-	   I've seen this parameter as low as 19 on my 450Mhz box - mpc */
-	printk(KERN_DEBUG "Debugging: QCam detection counter <30-200 counts as detected>: %d\n", count);
-	return 1;
-#endif
-
-	/* Be (even more) liberal in what you accept...  */
-
-	if (count > 20 && count < 400) {
-		return 1;	/* found */
-	} else {
-		printk(KERN_ERR "No Quickcam found on port %s\n",
-				q->pport->name);
-		printk(KERN_DEBUG "Quickcam detection counter: %u\n", count);
-		return 0;	/* not found */
-	}
-}
-
-/* Decide which scan mode to use.  There's no real requirement that
- * the scanmode match the resolution in q->height and q-> width -- the
- * camera takes the picture at the resolution specified in the
- * "scanmode" and then returns the image at the resolution specified
- * with the resolution commands.  If the scan is bigger than the
- * requested resolution, the upper-left hand corner of the scan is
- * returned.  If the scan is smaller, then the rest of the image
- * returned contains garbage. */
-
-static int qc_setscanmode(struct qcam *q)
-{
-	int old_mode = q->mode;
-
-	switch (q->transfer_scale) {
-	case 1:
-		q->mode = 0;
-		break;
-	case 2:
-		q->mode = 4;
-		break;
-	case 4:
-		q->mode = 8;
-		break;
-	}
-
-	switch (q->bpp) {
-	case 4:
-		break;
-	case 6:
-		q->mode += 2;
-		break;
-	}
-
-	switch (q->port_mode & QC_MODE_MASK) {
-	case QC_BIDIR:
-		q->mode += 1;
-		break;
-	case QC_NOTSET:
-	case QC_UNIDIR:
-		break;
-	}
-
-	if (q->mode != old_mode)
-		q->status |= QC_PARAM_CHANGE;
-
-	return 0;
-}
-
-
-/* Reset the QuickCam.  This uses the same sequence the Windows
- * QuickPic program uses.  Someone with a bi-directional port should
- * check that bi-directional mode is detected right, and then
- * implement bi-directional mode in qc_readbyte(). */
-
-static void qc_reset(struct qcam *q)
-{
-	switch (q->port_mode & QC_FORCE_MASK) {
-	case QC_FORCE_UNIDIR:
-		q->port_mode = (q->port_mode & ~QC_MODE_MASK) | QC_UNIDIR;
-		break;
-
-	case QC_FORCE_BIDIR:
-		q->port_mode = (q->port_mode & ~QC_MODE_MASK) | QC_BIDIR;
-		break;
-
-	case QC_ANY:
-		write_lpcontrol(q, 0x20);
-		write_lpdata(q, 0x75);
-
-		if (read_lpdata(q) != 0x75)
-			q->port_mode = (q->port_mode & ~QC_MODE_MASK) | QC_BIDIR;
-		else
-			q->port_mode = (q->port_mode & ~QC_MODE_MASK) | QC_UNIDIR;
-		break;
-	}
-
-	write_lpcontrol(q, 0xb);
-	udelay(250);
-	write_lpcontrol(q, 0xe);
-	qc_setscanmode(q);		/* in case port_mode changed */
-}
-
-
-
-/* Reset the QuickCam and program for brightness, contrast,
- * white-balance, and resolution. */
-
-static void qc_set(struct qcam *q)
-{
-	int val;
-	int val2;
-
-	qc_reset(q);
-
-	/* Set the brightness.  Yes, this is repetitive, but it works.
-	 * Shorter versions seem to fail subtly.  Feel free to try :-). */
-	/* I think the problem was in qc_command, not here -- bls */
-
-	qc_command(q, 0xb);
-	qc_command(q, q->brightness);
-
-	val = q->height / q->transfer_scale;
-	qc_command(q, 0x11);
-	qc_command(q, val);
-	if ((q->port_mode & QC_MODE_MASK) == QC_UNIDIR && q->bpp == 6) {
-		/* The normal "transfers per line" calculation doesn't seem to work
-		   as expected here (and yet it works fine in qc_scan).  No idea
-		   why this case is the odd man out.  Fortunately, Laird's original
-		   working version gives me a good way to guess at working values.
-		   -- bls */
-		val = q->width;
-		val2 = q->transfer_scale * 4;
-	} else {
-		val = q->width * q->bpp;
-		val2 = (((q->port_mode & QC_MODE_MASK) == QC_BIDIR) ? 24 : 8) *
-			q->transfer_scale;
-	}
-	val = DIV_ROUND_UP(val, val2);
-	qc_command(q, 0x13);
-	qc_command(q, val);
-
-	/* Setting top and left -- bls */
-	qc_command(q, 0xd);
-	qc_command(q, q->top);
-	qc_command(q, 0xf);
-	qc_command(q, q->left / 2);
-
-	qc_command(q, 0x19);
-	qc_command(q, q->contrast);
-	qc_command(q, 0x1f);
-	qc_command(q, q->whitebal);
-
-	/* Clear flag that we must update the grabbing parameters on the camera
-	   before we grab the next frame */
-	q->status &= (~QC_PARAM_CHANGE);
-}
-
-/* Qc_readbytes reads some bytes from the QC and puts them in
-   the supplied buffer.  It returns the number of bytes read,
-   or -1 on error. */
-
-static inline int qc_readbytes(struct qcam *q, char buffer[])
-{
-	int ret = 1;
-	unsigned int hi, lo;
-	unsigned int hi2, lo2;
-	static int state;
-
-	if (buffer == NULL) {
-		state = 0;
-		return 0;
-	}
-
-	switch (q->port_mode & QC_MODE_MASK) {
-	case QC_BIDIR:		/* Bi-directional Port */
-		write_lpcontrol(q, 0x26);
-		lo = (qc_waithand2(q, 1) >> 1);
-		hi = (read_lpstatus(q) >> 3) & 0x1f;
-		write_lpcontrol(q, 0x2e);
-		lo2 = (qc_waithand2(q, 0) >> 1);
-		hi2 = (read_lpstatus(q) >> 3) & 0x1f;
-		switch (q->bpp) {
-		case 4:
-			buffer[0] = lo & 0xf;
-			buffer[1] = ((lo & 0x70) >> 4) | ((hi & 1) << 3);
-			buffer[2] = (hi & 0x1e) >> 1;
-			buffer[3] = lo2 & 0xf;
-			buffer[4] = ((lo2 & 0x70) >> 4) | ((hi2 & 1) << 3);
-			buffer[5] = (hi2 & 0x1e) >> 1;
-			ret = 6;
-			break;
-		case 6:
-			buffer[0] = lo & 0x3f;
-			buffer[1] = ((lo & 0x40) >> 6) | (hi << 1);
-			buffer[2] = lo2 & 0x3f;
-			buffer[3] = ((lo2 & 0x40) >> 6) | (hi2 << 1);
-			ret = 4;
-			break;
-		}
-		break;
-
-	case QC_UNIDIR:	/* Unidirectional Port */
-		write_lpcontrol(q, 6);
-		lo = (qc_waithand(q, 1) & 0xf0) >> 4;
-		write_lpcontrol(q, 0xe);
-		hi = (qc_waithand(q, 0) & 0xf0) >> 4;
-
-		switch (q->bpp) {
-		case 4:
-			buffer[0] = lo;
-			buffer[1] = hi;
-			ret = 2;
-			break;
-		case 6:
-			switch (state) {
-			case 0:
-				buffer[0] = (lo << 2) | ((hi & 0xc) >> 2);
-				q->saved_bits = (hi & 3) << 4;
-				state = 1;
-				ret = 1;
-				break;
-			case 1:
-				buffer[0] = lo | q->saved_bits;
-				q->saved_bits = hi << 2;
-				state = 2;
-				ret = 1;
-				break;
-			case 2:
-				buffer[0] = ((lo & 0xc) >> 2) | q->saved_bits;
-				buffer[1] = ((lo & 3) << 4) | hi;
-				state = 0;
-				ret = 2;
-				break;
-			}
-			break;
-		}
-		break;
-	}
-	return ret;
-}
-
-/* requests a scan from the camera.  It sends the correct instructions
- * to the camera and then reads back the correct number of bytes.  In
- * previous versions of this routine the return structure contained
- * the raw output from the camera, and there was a 'qc_convertscan'
- * function that converted that to a useful format.  In version 0.3 I
- * rolled qc_convertscan into qc_scan and now I only return the
- * converted scan.  The format is just an one-dimensional array of
- * characters, one for each pixel, with 0=black up to n=white, where
- * n=2^(bit depth)-1.  Ask me for more details if you don't understand
- * this. */
-
-static long qc_capture(struct qcam *q, char __user *buf, unsigned long len)
-{
-	int i, j, k, yield;
-	int bytes;
-	int linestotrans, transperline;
-	int divisor;
-	int pixels_per_line;
-	int pixels_read = 0;
-	int got = 0;
-	char buffer[6];
-	int  shift = 8 - q->bpp;
-	char invert;
-
-	if (q->mode == -1)
-		return -ENXIO;
-
-	qc_command(q, 0x7);
-	qc_command(q, q->mode);
-
-	if ((q->port_mode & QC_MODE_MASK) == QC_BIDIR) {
-		write_lpcontrol(q, 0x2e);	/* turn port around */
-		write_lpcontrol(q, 0x26);
-		qc_waithand(q, 1);
-		write_lpcontrol(q, 0x2e);
-		qc_waithand(q, 0);
-	}
-
-	/* strange -- should be 15:63 below, but 4bpp is odd */
-	invert = (q->bpp == 4) ? 16 : 63;
-
-	linestotrans = q->height / q->transfer_scale;
-	pixels_per_line = q->width / q->transfer_scale;
-	transperline = q->width * q->bpp;
-	divisor = (((q->port_mode & QC_MODE_MASK) == QC_BIDIR) ? 24 : 8) *
-		q->transfer_scale;
-	transperline = DIV_ROUND_UP(transperline, divisor);
-
-	for (i = 0, yield = yieldlines; i < linestotrans; i++) {
-		for (pixels_read = j = 0; j < transperline; j++) {
-			bytes = qc_readbytes(q, buffer);
-			for (k = 0; k < bytes && (pixels_read + k) < pixels_per_line; k++) {
-				int o;
-				if (buffer[k] == 0 && invert == 16) {
-					/* 4bpp is odd (again) -- inverter is 16, not 15, but output
-					   must be 0-15 -- bls */
-					buffer[k] = 16;
-				}
-				o = i * pixels_per_line + pixels_read + k;
-				if (o < len) {
-					u8 ch = invert - buffer[k];
-					got++;
-					put_user(ch << shift, buf + o);
-				}
-			}
-			pixels_read += bytes;
-		}
-		qc_readbytes(q, NULL);	/* reset state machine */
-
-		/* Grabbing an entire frame from the quickcam is a lengthy
-		   process. We don't (usually) want to busy-block the
-		   processor for the entire frame. yieldlines is a module
-		   parameter. If we yield every line, the minimum frame
-		   time will be 240 / 200 = 1.2 seconds. The compile-time
-		   default is to yield every 4 lines. */
-		if (i >= yield) {
-			msleep_interruptible(5);
-			yield = i + yieldlines;
-		}
-	}
-
-	if ((q->port_mode & QC_MODE_MASK) == QC_BIDIR) {
-		write_lpcontrol(q, 2);
-		write_lpcontrol(q, 6);
-		udelay(3);
-		write_lpcontrol(q, 0xe);
-	}
-	if (got < len)
-		return got;
-	return len;
-}
-
-/*
- *	Video4linux interfacing
- */
-
-static int qcam_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *vcap)
-{
-	struct qcam *qcam = video_drvdata(file);
-
-	strlcpy(vcap->driver, qcam->v4l2_dev.name, sizeof(vcap->driver));
-	strlcpy(vcap->card, "Connectix B&W Quickcam", sizeof(vcap->card));
-	strlcpy(vcap->bus_info, qcam->pport->name, sizeof(vcap->bus_info));
-	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
-	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	return 0;
-}
-
-static int qcam_enum_input(struct file *file, void *fh, struct v4l2_input *vin)
-{
-	if (vin->index > 0)
-		return -EINVAL;
-	strlcpy(vin->name, "Camera", sizeof(vin->name));
-	vin->type = V4L2_INPUT_TYPE_CAMERA;
-	vin->audioset = 0;
-	vin->tuner = 0;
-	vin->std = 0;
-	vin->status = 0;
-	return 0;
-}
-
-static int qcam_g_input(struct file *file, void *fh, unsigned int *inp)
-{
-	*inp = 0;
-	return 0;
-}
-
-static int qcam_s_input(struct file *file, void *fh, unsigned int inp)
-{
-	return (inp > 0) ? -EINVAL : 0;
-}
-
-static int qcam_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct qcam *qcam = video_drvdata(file);
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-
-	pix->width = qcam->width / qcam->transfer_scale;
-	pix->height = qcam->height / qcam->transfer_scale;
-	pix->pixelformat = (qcam->bpp == 4) ? V4L2_PIX_FMT_Y4 : V4L2_PIX_FMT_Y6;
-	pix->field = V4L2_FIELD_NONE;
-	pix->bytesperline = pix->width;
-	pix->sizeimage = pix->width * pix->height;
-	/* Just a guess */
-	pix->colorspace = V4L2_COLORSPACE_SRGB;
-	return 0;
-}
-
-static int qcam_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-
-	if (pix->height <= 60 || pix->width <= 80) {
-		pix->height = 60;
-		pix->width = 80;
-	} else if (pix->height <= 120 || pix->width <= 160) {
-		pix->height = 120;
-		pix->width = 160;
-	} else {
-		pix->height = 240;
-		pix->width = 320;
-	}
-	if (pix->pixelformat != V4L2_PIX_FMT_Y4 &&
-	    pix->pixelformat != V4L2_PIX_FMT_Y6)
-		pix->pixelformat = V4L2_PIX_FMT_Y4;
-	pix->field = V4L2_FIELD_NONE;
-	pix->bytesperline = pix->width;
-	pix->sizeimage = pix->width * pix->height;
-	/* Just a guess */
-	pix->colorspace = V4L2_COLORSPACE_SRGB;
-	return 0;
-}
-
-static int qcam_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct qcam *qcam = video_drvdata(file);
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-	int ret = qcam_try_fmt_vid_cap(file, fh, fmt);
-
-	if (ret)
-		return ret;
-	qcam->width = 320;
-	qcam->height = 240;
-	if (pix->height == 60)
-		qcam->transfer_scale = 4;
-	else if (pix->height == 120)
-		qcam->transfer_scale = 2;
-	else
-		qcam->transfer_scale = 1;
-	if (pix->pixelformat == V4L2_PIX_FMT_Y6)
-		qcam->bpp = 6;
-	else
-		qcam->bpp = 4;
-
-	mutex_lock(&qcam->lock);
-	qc_setscanmode(qcam);
-	/* We must update the camera before we grab. We could
-	   just have changed the grab size */
-	qcam->status |= QC_PARAM_CHANGE;
-	mutex_unlock(&qcam->lock);
-	return 0;
-}
-
-static int qcam_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdesc *fmt)
-{
-	static struct v4l2_fmtdesc formats[] = {
-		{ 0, 0, 0,
-		  "4-Bit Monochrome", V4L2_PIX_FMT_Y4,
-		  { 0, 0, 0, 0 }
-		},
-		{ 1, 0, 0,
-		  "6-Bit Monochrome", V4L2_PIX_FMT_Y6,
-		  { 0, 0, 0, 0 }
-		},
-	};
-	enum v4l2_buf_type type = fmt->type;
-
-	if (fmt->index > 1)
-		return -EINVAL;
-
-	*fmt = formats[fmt->index];
-	fmt->type = type;
-	return 0;
-}
-
-static int qcam_enum_framesizes(struct file *file, void *fh,
-					 struct v4l2_frmsizeenum *fsize)
-{
-	static const struct v4l2_frmsize_discrete sizes[] = {
-		{  80,  60 },
-		{ 160, 120 },
-		{ 320, 240 },
-	};
-
-	if (fsize->index > 2)
-		return -EINVAL;
-	if (fsize->pixel_format != V4L2_PIX_FMT_Y4 &&
-	    fsize->pixel_format != V4L2_PIX_FMT_Y6)
-		return -EINVAL;
-	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
-	fsize->discrete = sizes[fsize->index];
-	return 0;
-}
-
-static ssize_t qcam_read(struct file *file, char __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct qcam *qcam = video_drvdata(file);
-	int len;
-	parport_claim_or_block(qcam->pdev);
-
-	mutex_lock(&qcam->lock);
-
-	qc_reset(qcam);
-
-	/* Update the camera parameters if we need to */
-	if (qcam->status & QC_PARAM_CHANGE)
-		qc_set(qcam);
-
-	len = qc_capture(qcam, buf, count);
-
-	mutex_unlock(&qcam->lock);
-
-	parport_release(qcam->pdev);
-	return len;
-}
-
-static unsigned int qcam_poll(struct file *filp, poll_table *wait)
-{
-	return v4l2_ctrl_poll(filp, wait) | POLLIN | POLLRDNORM;
-}
-
-static int qcam_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct qcam *qcam =
-		container_of(ctrl->handler, struct qcam, hdl);
-	int ret = 0;
-
-	mutex_lock(&qcam->lock);
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		qcam->brightness = ctrl->val;
-		break;
-	case V4L2_CID_CONTRAST:
-		qcam->contrast = ctrl->val;
-		break;
-	case V4L2_CID_GAMMA:
-		qcam->whitebal = ctrl->val;
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	if (ret == 0) {
-		qc_setscanmode(qcam);
-		qcam->status |= QC_PARAM_CHANGE;
-	}
-	mutex_unlock(&qcam->lock);
-	return ret;
-}
-
-static const struct v4l2_file_operations qcam_fops = {
-	.owner		= THIS_MODULE,
-	.open		= v4l2_fh_open,
-	.release	= v4l2_fh_release,
-	.poll		= qcam_poll,
-	.unlocked_ioctl = video_ioctl2,
-	.read		= qcam_read,
-};
-
-static const struct v4l2_ioctl_ops qcam_ioctl_ops = {
-	.vidioc_querycap    		    = qcam_querycap,
-	.vidioc_g_input      		    = qcam_g_input,
-	.vidioc_s_input      		    = qcam_s_input,
-	.vidioc_enum_input   		    = qcam_enum_input,
-	.vidioc_enum_fmt_vid_cap 	    = qcam_enum_fmt_vid_cap,
-	.vidioc_enum_framesizes		    = qcam_enum_framesizes,
-	.vidioc_g_fmt_vid_cap 		    = qcam_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap  		    = qcam_s_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap  	    = qcam_try_fmt_vid_cap,
-	.vidioc_log_status		    = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		    = v4l2_ctrl_subscribe_event,
-	.vidioc_unsubscribe_event	    = v4l2_event_unsubscribe,
-};
-
-static const struct v4l2_ctrl_ops qcam_ctrl_ops = {
-	.s_ctrl = qcam_s_ctrl,
-};
-
-/* Initialize the QuickCam driver control structure.  This is where
- * defaults are set for people who don't have a config file.*/
-
-static struct qcam *qcam_init(struct parport *port)
-{
-	struct qcam *qcam;
-	struct v4l2_device *v4l2_dev;
-
-	qcam = kzalloc(sizeof(struct qcam), GFP_KERNEL);
-	if (qcam == NULL)
-		return NULL;
-
-	v4l2_dev = &qcam->v4l2_dev;
-	snprintf(v4l2_dev->name, sizeof(v4l2_dev->name), "bw-qcam%d", num_cams);
-
-	if (v4l2_device_register(port->dev, v4l2_dev) < 0) {
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		kfree(qcam);
-		return NULL;
-	}
-
-	v4l2_ctrl_handler_init(&qcam->hdl, 3);
-	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
-			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 180);
-	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
-			  V4L2_CID_CONTRAST, 0, 255, 1, 192);
-	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
-			  V4L2_CID_GAMMA, 0, 255, 1, 105);
-	if (qcam->hdl.error) {
-		v4l2_err(v4l2_dev, "couldn't register controls\n");
-		v4l2_ctrl_handler_free(&qcam->hdl);
-		kfree(qcam);
-		return NULL;
-	}
-	qcam->pport = port;
-	qcam->pdev = parport_register_device(port, v4l2_dev->name, NULL, NULL,
-			NULL, 0, NULL);
-	if (qcam->pdev == NULL) {
-		v4l2_err(v4l2_dev, "couldn't register for %s.\n", port->name);
-		v4l2_ctrl_handler_free(&qcam->hdl);
-		kfree(qcam);
-		return NULL;
-	}
-
-	strlcpy(qcam->vdev.name, "Connectix QuickCam", sizeof(qcam->vdev.name));
-	qcam->vdev.v4l2_dev = v4l2_dev;
-	qcam->vdev.ctrl_handler = &qcam->hdl;
-	qcam->vdev.fops = &qcam_fops;
-	qcam->vdev.ioctl_ops = &qcam_ioctl_ops;
-	set_bit(V4L2_FL_USE_FH_PRIO, &qcam->vdev.flags);
-	qcam->vdev.release = video_device_release_empty;
-	video_set_drvdata(&qcam->vdev, qcam);
-
-	mutex_init(&qcam->lock);
-
-	qcam->port_mode = (QC_ANY | QC_NOTSET);
-	qcam->width = 320;
-	qcam->height = 240;
-	qcam->bpp = 4;
-	qcam->transfer_scale = 2;
-	qcam->contrast = 192;
-	qcam->brightness = 180;
-	qcam->whitebal = 105;
-	qcam->top = 1;
-	qcam->left = 14;
-	qcam->mode = -1;
-	qcam->status = QC_PARAM_CHANGE;
-	return qcam;
-}
-
-static int qc_calibrate(struct qcam *q)
-{
-	/*
-	 *	Bugfix by Hanno Mueller hmueller@kabel.de, Mai 21 96
-	 *	The white balance is an individual value for each
-	 *	quickcam.
-	 */
-
-	int value;
-	int count = 0;
-
-	qc_command(q, 27);	/* AutoAdjustOffset */
-	qc_command(q, 0);	/* Dummy Parameter, ignored by the camera */
-
-	/* GetOffset (33) will read 255 until autocalibration */
-	/* is finished. After that, a value of 1-254 will be */
-	/* returned. */
-
-	do {
-		qc_command(q, 33);
-		value = qc_readparam(q);
-		mdelay(1);
-		schedule();
-		count++;
-	} while (value == 0xff && count < 2048);
-
-	q->whitebal = value;
-	return value;
-}
-
-static int init_bwqcam(struct parport *port)
-{
-	struct qcam *qcam;
-
-	if (num_cams == MAX_CAMS) {
-		printk(KERN_ERR "Too many Quickcams (max %d)\n", MAX_CAMS);
-		return -ENOSPC;
-	}
-
-	qcam = qcam_init(port);
-	if (qcam == NULL)
-		return -ENODEV;
-
-	parport_claim_or_block(qcam->pdev);
-
-	qc_reset(qcam);
-
-	if (qc_detect(qcam) == 0) {
-		parport_release(qcam->pdev);
-		parport_unregister_device(qcam->pdev);
-		kfree(qcam);
-		return -ENODEV;
-	}
-	qc_calibrate(qcam);
-	v4l2_ctrl_handler_setup(&qcam->hdl);
-
-	parport_release(qcam->pdev);
-
-	v4l2_info(&qcam->v4l2_dev, "Connectix Quickcam on %s\n", qcam->pport->name);
-
-	if (video_register_device(&qcam->vdev, VFL_TYPE_GRABBER, video_nr) < 0) {
-		parport_unregister_device(qcam->pdev);
-		kfree(qcam);
-		return -ENODEV;
-	}
-
-	qcams[num_cams++] = qcam;
-
-	return 0;
-}
-
-static void close_bwqcam(struct qcam *qcam)
-{
-	video_unregister_device(&qcam->vdev);
-	v4l2_ctrl_handler_free(&qcam->hdl);
-	parport_unregister_device(qcam->pdev);
-	kfree(qcam);
-}
-
-/* The parport parameter controls which parports will be scanned.
- * Scanning all parports causes some printers to print a garbage page.
- *       -- March 14, 1999  Billy Donahue <billy@escape.com> */
-#ifdef MODULE
-static char *parport[MAX_CAMS] = { NULL, };
-module_param_array(parport, charp, NULL, 0);
-#endif
-
-static int accept_bwqcam(struct parport *port)
-{
-#ifdef MODULE
-	int n;
-
-	if (parport[0] && strncmp(parport[0], "auto", 4) != 0) {
-		/* user gave parport parameters */
-		for (n = 0; n < MAX_CAMS && parport[n]; n++) {
-			char *ep;
-			unsigned long r;
-			r = simple_strtoul(parport[n], &ep, 0);
-			if (ep == parport[n]) {
-				printk(KERN_ERR
-					"bw-qcam: bad port specifier \"%s\"\n",
-					parport[n]);
-				continue;
-			}
-			if (r == port->number)
-				return 1;
-		}
-		return 0;
-	}
-#endif
-	return 1;
-}
-
-static void bwqcam_attach(struct parport *port)
-{
-	if (accept_bwqcam(port))
-		init_bwqcam(port);
-}
-
-static void bwqcam_detach(struct parport *port)
-{
-	int i;
-	for (i = 0; i < num_cams; i++) {
-		struct qcam *qcam = qcams[i];
-		if (qcam && qcam->pdev->port == port) {
-			qcams[i] = NULL;
-			close_bwqcam(qcam);
-		}
-	}
-}
-
-static struct parport_driver bwqcam_driver = {
-	.name	= "bw-qcam",
-	.attach	= bwqcam_attach,
-	.detach	= bwqcam_detach,
-};
-
-static void __exit exit_bw_qcams(void)
-{
-	parport_unregister_driver(&bwqcam_driver);
-}
-
-static int __init init_bw_qcams(void)
-{
-#ifdef MODULE
-	/* Do some sanity checks on the module parameters. */
-	if (maxpoll > 5000) {
-		printk(KERN_INFO "Connectix Quickcam max-poll was above 5000. Using 5000.\n");
-		maxpoll = 5000;
-	}
-
-	if (yieldlines < 1) {
-		printk(KERN_INFO "Connectix Quickcam yieldlines was less than 1. Using 1.\n");
-		yieldlines = 1;
-	}
-#endif
-	return parport_register_driver(&bwqcam_driver);
-}
-
-module_init(init_bw_qcams);
-module_exit(exit_bw_qcams);
-
-MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.3");
diff --git a/drivers/media/video/c-qcam.c b/drivers/media/video/c-qcam.c
deleted file mode 100644
index ec51e1f..0000000
--- a/drivers/media/video/c-qcam.c
+++ /dev/null
@@ -1,883 +0,0 @@
-/*
- *	Video4Linux Colour QuickCam driver
- *	Copyright 1997-2000 Philip Blundell <philb@gnu.org>
- *
- *    Module parameters:
- *
- *	parport=auto      -- probe all parports (default)
- *	parport=0         -- parport0 becomes qcam1
- *	parport=2,0,1     -- parports 2,0,1 are tried in that order
- *
- *	probe=0		  -- do no probing, assume camera is present
- *	probe=1		  -- use IEEE-1284 autoprobe data only (default)
- *	probe=2		  -- probe aggressively for cameras
- *
- *	force_rgb=1       -- force data format to RGB (default is BGR)
- *
- * The parport parameter controls which parports will be scanned.
- * Scanning all parports causes some printers to print a garbage page.
- *       -- March 14, 1999  Billy Donahue <billy@escape.com>
- *
- * Fixed data format to BGR, added force_rgb parameter. Added missing
- * parport_unregister_driver() on module removal.
- *       -- May 28, 2000  Claudio Matsuoka <claudio@conectiva.com>
- */
-
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/mm.h>
-#include <linux/parport.h>
-#include <linux/sched.h>
-#include <linux/mutex.h>
-#include <linux/jiffies.h>
-#include <linux/videodev2.h>
-#include <asm/uaccess.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-fh.h>
-#include <media/v4l2-ctrls.h>
-#include <media/v4l2-event.h>
-
-struct qcam {
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	struct v4l2_ctrl_handler hdl;
-	struct pardevice *pdev;
-	struct parport *pport;
-	int width, height;
-	int ccd_width, ccd_height;
-	int mode;
-	int contrast, brightness, whitebal;
-	int top, left;
-	unsigned int bidirectional;
-	struct mutex lock;
-};
-
-/* cameras maximum */
-#define MAX_CAMS 4
-
-/* The three possible QuickCam modes */
-#define QC_MILLIONS	0x18
-#define QC_BILLIONS	0x10
-#define QC_THOUSANDS	0x08	/* with VIDEC compression (not supported) */
-
-/* The three possible decimations */
-#define QC_DECIMATION_1		0
-#define QC_DECIMATION_2		2
-#define QC_DECIMATION_4		4
-
-#define BANNER "Colour QuickCam for Video4Linux v0.06"
-
-static int parport[MAX_CAMS] = { [1 ... MAX_CAMS-1] = -1 };
-static int probe = 2;
-static bool force_rgb;
-static int video_nr = -1;
-
-/* FIXME: parport=auto would never have worked, surely? --RR */
-MODULE_PARM_DESC(parport, "parport=<auto|n[,n]...> for port detection method\n"
-			  "probe=<0|1|2> for camera detection method\n"
-			  "force_rgb=<0|1> for RGB data format (default BGR)");
-module_param_array(parport, int, NULL, 0);
-module_param(probe, int, 0);
-module_param(force_rgb, bool, 0);
-module_param(video_nr, int, 0);
-
-static struct qcam *qcams[MAX_CAMS];
-static unsigned int num_cams;
-
-static inline void qcam_set_ack(struct qcam *qcam, unsigned int i)
-{
-	/* note: the QC specs refer to the PCAck pin by voltage, not
-	   software level.  PC ports have builtin inverters. */
-	parport_frob_control(qcam->pport, 8, i ? 8 : 0);
-}
-
-static inline unsigned int qcam_ready1(struct qcam *qcam)
-{
-	return (parport_read_status(qcam->pport) & 0x8) ? 1 : 0;
-}
-
-static inline unsigned int qcam_ready2(struct qcam *qcam)
-{
-	return (parport_read_data(qcam->pport) & 0x1) ? 1 : 0;
-}
-
-static unsigned int qcam_await_ready1(struct qcam *qcam, int value)
-{
-	struct v4l2_device *v4l2_dev = &qcam->v4l2_dev;
-	unsigned long oldjiffies = jiffies;
-	unsigned int i;
-
-	for (oldjiffies = jiffies;
-	     time_before(jiffies, oldjiffies + msecs_to_jiffies(40));)
-		if (qcam_ready1(qcam) == value)
-			return 0;
-
-	/* If the camera didn't respond within 1/25 second, poll slowly
-	   for a while. */
-	for (i = 0; i < 50; i++) {
-		if (qcam_ready1(qcam) == value)
-			return 0;
-		msleep_interruptible(100);
-	}
-
-	/* Probably somebody pulled the plug out.  Not much we can do. */
-	v4l2_err(v4l2_dev, "ready1 timeout (%d) %x %x\n", value,
-	       parport_read_status(qcam->pport),
-	       parport_read_control(qcam->pport));
-	return 1;
-}
-
-static unsigned int qcam_await_ready2(struct qcam *qcam, int value)
-{
-	struct v4l2_device *v4l2_dev = &qcam->v4l2_dev;
-	unsigned long oldjiffies = jiffies;
-	unsigned int i;
-
-	for (oldjiffies = jiffies;
-	     time_before(jiffies, oldjiffies + msecs_to_jiffies(40));)
-		if (qcam_ready2(qcam) == value)
-			return 0;
-
-	/* If the camera didn't respond within 1/25 second, poll slowly
-	   for a while. */
-	for (i = 0; i < 50; i++) {
-		if (qcam_ready2(qcam) == value)
-			return 0;
-		msleep_interruptible(100);
-	}
-
-	/* Probably somebody pulled the plug out.  Not much we can do. */
-	v4l2_err(v4l2_dev, "ready2 timeout (%d) %x %x %x\n", value,
-	       parport_read_status(qcam->pport),
-	       parport_read_control(qcam->pport),
-	       parport_read_data(qcam->pport));
-	return 1;
-}
-
-static int qcam_read_data(struct qcam *qcam)
-{
-	unsigned int idata;
-
-	qcam_set_ack(qcam, 0);
-	if (qcam_await_ready1(qcam, 1))
-		return -1;
-	idata = parport_read_status(qcam->pport) & 0xf0;
-	qcam_set_ack(qcam, 1);
-	if (qcam_await_ready1(qcam, 0))
-		return -1;
-	idata |= parport_read_status(qcam->pport) >> 4;
-	return idata;
-}
-
-static int qcam_write_data(struct qcam *qcam, unsigned int data)
-{
-	struct v4l2_device *v4l2_dev = &qcam->v4l2_dev;
-	unsigned int idata;
-
-	parport_write_data(qcam->pport, data);
-	idata = qcam_read_data(qcam);
-	if (data != idata) {
-		v4l2_warn(v4l2_dev, "sent %x but received %x\n", data,
-		       idata);
-		return 1;
-	}
-	return 0;
-}
-
-static inline int qcam_set(struct qcam *qcam, unsigned int cmd, unsigned int data)
-{
-	if (qcam_write_data(qcam, cmd))
-		return -1;
-	if (qcam_write_data(qcam, data))
-		return -1;
-	return 0;
-}
-
-static inline int qcam_get(struct qcam *qcam, unsigned int cmd)
-{
-	if (qcam_write_data(qcam, cmd))
-		return -1;
-	return qcam_read_data(qcam);
-}
-
-static int qc_detect(struct qcam *qcam)
-{
-	unsigned int stat, ostat, i, count = 0;
-
-	/* The probe routine below is not very reliable.  The IEEE-1284
-	   probe takes precedence. */
-	/* XXX Currently parport provides no way to distinguish between
-	   "the IEEE probe was not done" and "the probe was done, but
-	   no device was found".  Fix this one day. */
-	if (qcam->pport->probe_info[0].class == PARPORT_CLASS_MEDIA
-	    && qcam->pport->probe_info[0].model
-	    && !strcmp(qcam->pdev->port->probe_info[0].model,
-		       "Color QuickCam 2.0")) {
-		printk(KERN_DEBUG "QuickCam: Found by IEEE1284 probe.\n");
-		return 1;
-	}
-
-	if (probe < 2)
-		return 0;
-
-	parport_write_control(qcam->pport, 0xc);
-
-	/* look for a heartbeat */
-	ostat = stat = parport_read_status(qcam->pport);
-	for (i = 0; i < 250; i++) {
-		mdelay(1);
-		stat = parport_read_status(qcam->pport);
-		if (ostat != stat) {
-			if (++count >= 3)
-				return 1;
-			ostat = stat;
-		}
-	}
-
-	/* Reset the camera and try again */
-	parport_write_control(qcam->pport, 0xc);
-	parport_write_control(qcam->pport, 0x8);
-	mdelay(1);
-	parport_write_control(qcam->pport, 0xc);
-	mdelay(1);
-	count = 0;
-
-	ostat = stat = parport_read_status(qcam->pport);
-	for (i = 0; i < 250; i++) {
-		mdelay(1);
-		stat = parport_read_status(qcam->pport);
-		if (ostat != stat) {
-			if (++count >= 3)
-				return 1;
-			ostat = stat;
-		}
-	}
-
-	/* no (or flatline) camera, give up */
-	return 0;
-}
-
-static void qc_reset(struct qcam *qcam)
-{
-	parport_write_control(qcam->pport, 0xc);
-	parport_write_control(qcam->pport, 0x8);
-	mdelay(1);
-	parport_write_control(qcam->pport, 0xc);
-	mdelay(1);
-}
-
-/* Reset the QuickCam and program for brightness, contrast,
- * white-balance, and resolution. */
-
-static void qc_setup(struct qcam *qcam)
-{
-	qc_reset(qcam);
-
-	/* Set the brightness. */
-	qcam_set(qcam, 11, qcam->brightness);
-
-	/* Set the height and width.  These refer to the actual
-	   CCD area *before* applying the selected decimation.  */
-	qcam_set(qcam, 17, qcam->ccd_height);
-	qcam_set(qcam, 19, qcam->ccd_width / 2);
-
-	/* Set top and left.  */
-	qcam_set(qcam, 0xd, qcam->top);
-	qcam_set(qcam, 0xf, qcam->left);
-
-	/* Set contrast and white balance.  */
-	qcam_set(qcam, 0x19, qcam->contrast);
-	qcam_set(qcam, 0x1f, qcam->whitebal);
-
-	/* Set the speed.  */
-	qcam_set(qcam, 45, 2);
-}
-
-/* Read some bytes from the camera and put them in the buffer.
-   nbytes should be a multiple of 3, because bidirectional mode gives
-   us three bytes at a time.  */
-
-static unsigned int qcam_read_bytes(struct qcam *qcam, unsigned char *buf, unsigned int nbytes)
-{
-	unsigned int bytes = 0;
-
-	qcam_set_ack(qcam, 0);
-	if (qcam->bidirectional) {
-		/* It's a bidirectional port */
-		while (bytes < nbytes) {
-			unsigned int lo1, hi1, lo2, hi2;
-			unsigned char r, g, b;
-
-			if (qcam_await_ready2(qcam, 1))
-				return bytes;
-			lo1 = parport_read_data(qcam->pport) >> 1;
-			hi1 = ((parport_read_status(qcam->pport) >> 3) & 0x1f) ^ 0x10;
-			qcam_set_ack(qcam, 1);
-			if (qcam_await_ready2(qcam, 0))
-				return bytes;
-			lo2 = parport_read_data(qcam->pport) >> 1;
-			hi2 = ((parport_read_status(qcam->pport) >> 3) & 0x1f) ^ 0x10;
-			qcam_set_ack(qcam, 0);
-			r = lo1 | ((hi1 & 1) << 7);
-			g = ((hi1 & 0x1e) << 3) | ((hi2 & 0x1e) >> 1);
-			b = lo2 | ((hi2 & 1) << 7);
-			if (force_rgb) {
-				buf[bytes++] = r;
-				buf[bytes++] = g;
-				buf[bytes++] = b;
-			} else {
-				buf[bytes++] = b;
-				buf[bytes++] = g;
-				buf[bytes++] = r;
-			}
-		}
-	} else {
-		/* It's a unidirectional port */
-		int i = 0, n = bytes;
-		unsigned char rgb[3];
-
-		while (bytes < nbytes) {
-			unsigned int hi, lo;
-
-			if (qcam_await_ready1(qcam, 1))
-				return bytes;
-			hi = (parport_read_status(qcam->pport) & 0xf0);
-			qcam_set_ack(qcam, 1);
-			if (qcam_await_ready1(qcam, 0))
-				return bytes;
-			lo = (parport_read_status(qcam->pport) & 0xf0);
-			qcam_set_ack(qcam, 0);
-			/* flip some bits */
-			rgb[(i = bytes++ % 3)] = (hi | (lo >> 4)) ^ 0x88;
-			if (i >= 2) {
-get_fragment:
-				if (force_rgb) {
-					buf[n++] = rgb[0];
-					buf[n++] = rgb[1];
-					buf[n++] = rgb[2];
-				} else {
-					buf[n++] = rgb[2];
-					buf[n++] = rgb[1];
-					buf[n++] = rgb[0];
-				}
-			}
-		}
-		if (i) {
-			i = 0;
-			goto get_fragment;
-		}
-	}
-	return bytes;
-}
-
-#define BUFSZ	150
-
-static long qc_capture(struct qcam *qcam, char __user *buf, unsigned long len)
-{
-	struct v4l2_device *v4l2_dev = &qcam->v4l2_dev;
-	unsigned lines, pixelsperline;
-	unsigned int is_bi_dir = qcam->bidirectional;
-	size_t wantlen, outptr = 0;
-	char tmpbuf[BUFSZ];
-
-	if (!access_ok(VERIFY_WRITE, buf, len))
-		return -EFAULT;
-
-	/* Wait for camera to become ready */
-	for (;;) {
-		int i = qcam_get(qcam, 41);
-
-		if (i == -1) {
-			qc_setup(qcam);
-			return -EIO;
-		}
-		if ((i & 0x80) == 0)
-			break;
-		schedule();
-	}
-
-	if (qcam_set(qcam, 7, (qcam->mode | (is_bi_dir ? 1 : 0)) + 1))
-		return -EIO;
-
-	lines = qcam->height;
-	pixelsperline = qcam->width;
-
-	if (is_bi_dir) {
-		/* Turn the port around */
-		parport_data_reverse(qcam->pport);
-		mdelay(3);
-		qcam_set_ack(qcam, 0);
-		if (qcam_await_ready1(qcam, 1)) {
-			qc_setup(qcam);
-			return -EIO;
-		}
-		qcam_set_ack(qcam, 1);
-		if (qcam_await_ready1(qcam, 0)) {
-			qc_setup(qcam);
-			return -EIO;
-		}
-	}
-
-	wantlen = lines * pixelsperline * 24 / 8;
-
-	while (wantlen) {
-		size_t t, s;
-
-		s = (wantlen > BUFSZ) ? BUFSZ : wantlen;
-		t = qcam_read_bytes(qcam, tmpbuf, s);
-		if (outptr < len) {
-			size_t sz = len - outptr;
-
-			if (sz > t)
-				sz = t;
-			if (__copy_to_user(buf + outptr, tmpbuf, sz))
-				break;
-			outptr += sz;
-		}
-		wantlen -= t;
-		if (t < s)
-			break;
-		cond_resched();
-	}
-
-	len = outptr;
-
-	if (wantlen) {
-		v4l2_err(v4l2_dev, "short read.\n");
-		if (is_bi_dir)
-			parport_data_forward(qcam->pport);
-		qc_setup(qcam);
-		return len;
-	}
-
-	if (is_bi_dir) {
-		int l;
-
-		do {
-			l = qcam_read_bytes(qcam, tmpbuf, 3);
-			cond_resched();
-		} while (l && (tmpbuf[0] == 0x7e || tmpbuf[1] == 0x7e || tmpbuf[2] == 0x7e));
-		if (force_rgb) {
-			if (tmpbuf[0] != 0xe || tmpbuf[1] != 0x0 || tmpbuf[2] != 0xf)
-				v4l2_err(v4l2_dev, "bad EOF\n");
-		} else {
-			if (tmpbuf[0] != 0xf || tmpbuf[1] != 0x0 || tmpbuf[2] != 0xe)
-				v4l2_err(v4l2_dev, "bad EOF\n");
-		}
-		qcam_set_ack(qcam, 0);
-		if (qcam_await_ready1(qcam, 1)) {
-			v4l2_err(v4l2_dev, "no ack after EOF\n");
-			parport_data_forward(qcam->pport);
-			qc_setup(qcam);
-			return len;
-		}
-		parport_data_forward(qcam->pport);
-		mdelay(3);
-		qcam_set_ack(qcam, 1);
-		if (qcam_await_ready1(qcam, 0)) {
-			v4l2_err(v4l2_dev, "no ack to port turnaround\n");
-			qc_setup(qcam);
-			return len;
-		}
-	} else {
-		int l;
-
-		do {
-			l = qcam_read_bytes(qcam, tmpbuf, 1);
-			cond_resched();
-		} while (l && tmpbuf[0] == 0x7e);
-		l = qcam_read_bytes(qcam, tmpbuf + 1, 2);
-		if (force_rgb) {
-			if (tmpbuf[0] != 0xe || tmpbuf[1] != 0x0 || tmpbuf[2] != 0xf)
-				v4l2_err(v4l2_dev, "bad EOF\n");
-		} else {
-			if (tmpbuf[0] != 0xf || tmpbuf[1] != 0x0 || tmpbuf[2] != 0xe)
-				v4l2_err(v4l2_dev, "bad EOF\n");
-		}
-	}
-
-	qcam_write_data(qcam, 0);
-	return len;
-}
-
-/*
- *	Video4linux interfacing
- */
-
-static int qcam_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *vcap)
-{
-	struct qcam *qcam = video_drvdata(file);
-
-	strlcpy(vcap->driver, qcam->v4l2_dev.name, sizeof(vcap->driver));
-	strlcpy(vcap->card, "Color Quickcam", sizeof(vcap->card));
-	strlcpy(vcap->bus_info, "parport", sizeof(vcap->bus_info));
-	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
-	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	return 0;
-}
-
-static int qcam_enum_input(struct file *file, void *fh, struct v4l2_input *vin)
-{
-	if (vin->index > 0)
-		return -EINVAL;
-	strlcpy(vin->name, "Camera", sizeof(vin->name));
-	vin->type = V4L2_INPUT_TYPE_CAMERA;
-	vin->audioset = 0;
-	vin->tuner = 0;
-	vin->std = 0;
-	vin->status = 0;
-	return 0;
-}
-
-static int qcam_g_input(struct file *file, void *fh, unsigned int *inp)
-{
-	*inp = 0;
-	return 0;
-}
-
-static int qcam_s_input(struct file *file, void *fh, unsigned int inp)
-{
-	return (inp > 0) ? -EINVAL : 0;
-}
-
-static int qcam_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct qcam *qcam = video_drvdata(file);
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-
-	pix->width = qcam->width;
-	pix->height = qcam->height;
-	pix->pixelformat = V4L2_PIX_FMT_RGB24;
-	pix->field = V4L2_FIELD_NONE;
-	pix->bytesperline = 3 * qcam->width;
-	pix->sizeimage = 3 * qcam->width * qcam->height;
-	/* Just a guess */
-	pix->colorspace = V4L2_COLORSPACE_SRGB;
-	return 0;
-}
-
-static int qcam_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-
-	if (pix->height < 60 || pix->width < 80) {
-		pix->height = 60;
-		pix->width = 80;
-	} else if (pix->height < 120 || pix->width < 160) {
-		pix->height = 120;
-		pix->width = 160;
-	} else {
-		pix->height = 240;
-		pix->width = 320;
-	}
-	pix->pixelformat = V4L2_PIX_FMT_RGB24;
-	pix->field = V4L2_FIELD_NONE;
-	pix->bytesperline = 3 * pix->width;
-	pix->sizeimage = 3 * pix->width * pix->height;
-	/* Just a guess */
-	pix->colorspace = V4L2_COLORSPACE_SRGB;
-	return 0;
-}
-
-static int qcam_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct qcam *qcam = video_drvdata(file);
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-	int ret = qcam_try_fmt_vid_cap(file, fh, fmt);
-
-	if (ret)
-		return ret;
-	switch (pix->height) {
-	case 60:
-		qcam->mode = QC_DECIMATION_4;
-		break;
-	case 120:
-		qcam->mode = QC_DECIMATION_2;
-		break;
-	default:
-		qcam->mode = QC_DECIMATION_1;
-		break;
-	}
-
-	mutex_lock(&qcam->lock);
-	qcam->mode |= QC_MILLIONS;
-	qcam->height = pix->height;
-	qcam->width = pix->width;
-	parport_claim_or_block(qcam->pdev);
-	qc_setup(qcam);
-	parport_release(qcam->pdev);
-	mutex_unlock(&qcam->lock);
-	return 0;
-}
-
-static int qcam_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdesc *fmt)
-{
-	static struct v4l2_fmtdesc formats[] = {
-		{ 0, 0, 0,
-		  "RGB 8:8:8", V4L2_PIX_FMT_RGB24,
-		  { 0, 0, 0, 0 }
-		},
-	};
-	enum v4l2_buf_type type = fmt->type;
-
-	if (fmt->index > 0)
-		return -EINVAL;
-
-	*fmt = formats[fmt->index];
-	fmt->type = type;
-	return 0;
-}
-
-static ssize_t qcam_read(struct file *file, char __user *buf,
-			 size_t count, loff_t *ppos)
-{
-	struct qcam *qcam = video_drvdata(file);
-	int len;
-
-	mutex_lock(&qcam->lock);
-	parport_claim_or_block(qcam->pdev);
-	/* Probably should have a semaphore against multiple users */
-	len = qc_capture(qcam, buf, count);
-	parport_release(qcam->pdev);
-	mutex_unlock(&qcam->lock);
-	return len;
-}
-
-static int qcam_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct qcam *qcam =
-		container_of(ctrl->handler, struct qcam, hdl);
-	int ret = 0;
-
-	mutex_lock(&qcam->lock);
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		qcam->brightness = ctrl->val;
-		break;
-	case V4L2_CID_CONTRAST:
-		qcam->contrast = ctrl->val;
-		break;
-	case V4L2_CID_GAMMA:
-		qcam->whitebal = ctrl->val;
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	if (ret == 0) {
-		parport_claim_or_block(qcam->pdev);
-		qc_setup(qcam);
-		parport_release(qcam->pdev);
-	}
-	mutex_unlock(&qcam->lock);
-	return ret;
-}
-
-static const struct v4l2_file_operations qcam_fops = {
-	.owner		= THIS_MODULE,
-	.open		= v4l2_fh_open,
-	.release	= v4l2_fh_release,
-	.poll		= v4l2_ctrl_poll,
-	.unlocked_ioctl	= video_ioctl2,
-	.read		= qcam_read,
-};
-
-static const struct v4l2_ioctl_ops qcam_ioctl_ops = {
-	.vidioc_querycap    		    = qcam_querycap,
-	.vidioc_g_input      		    = qcam_g_input,
-	.vidioc_s_input      		    = qcam_s_input,
-	.vidioc_enum_input   		    = qcam_enum_input,
-	.vidioc_enum_fmt_vid_cap	    = qcam_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap 		    = qcam_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap  		    = qcam_s_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap  	    = qcam_try_fmt_vid_cap,
-	.vidioc_log_status		    = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		    = v4l2_ctrl_subscribe_event,
-	.vidioc_unsubscribe_event	    = v4l2_event_unsubscribe,
-};
-
-static const struct v4l2_ctrl_ops qcam_ctrl_ops = {
-	.s_ctrl = qcam_s_ctrl,
-};
-
-/* Initialize the QuickCam driver control structure. */
-
-static struct qcam *qcam_init(struct parport *port)
-{
-	struct qcam *qcam;
-	struct v4l2_device *v4l2_dev;
-
-	qcam = kzalloc(sizeof(*qcam), GFP_KERNEL);
-	if (qcam == NULL)
-		return NULL;
-
-	v4l2_dev = &qcam->v4l2_dev;
-	strlcpy(v4l2_dev->name, "c-qcam", sizeof(v4l2_dev->name));
-
-	if (v4l2_device_register(NULL, v4l2_dev) < 0) {
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		kfree(qcam);
-		return NULL;
-	}
-
-	v4l2_ctrl_handler_init(&qcam->hdl, 3);
-	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
-			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 240);
-	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
-			  V4L2_CID_CONTRAST, 0, 255, 1, 192);
-	v4l2_ctrl_new_std(&qcam->hdl, &qcam_ctrl_ops,
-			  V4L2_CID_GAMMA, 0, 255, 1, 128);
-	if (qcam->hdl.error) {
-		v4l2_err(v4l2_dev, "couldn't register controls\n");
-		v4l2_ctrl_handler_free(&qcam->hdl);
-		kfree(qcam);
-		return NULL;
-	}
-
-	qcam->pport = port;
-	qcam->pdev = parport_register_device(port, "c-qcam", NULL, NULL,
-					  NULL, 0, NULL);
-
-	qcam->bidirectional = (qcam->pport->modes & PARPORT_MODE_TRISTATE) ? 1 : 0;
-
-	if (qcam->pdev == NULL) {
-		v4l2_err(v4l2_dev, "couldn't register for %s.\n", port->name);
-		v4l2_ctrl_handler_free(&qcam->hdl);
-		kfree(qcam);
-		return NULL;
-	}
-
-	strlcpy(qcam->vdev.name, "Colour QuickCam", sizeof(qcam->vdev.name));
-	qcam->vdev.v4l2_dev = v4l2_dev;
-	qcam->vdev.fops = &qcam_fops;
-	qcam->vdev.ioctl_ops = &qcam_ioctl_ops;
-	qcam->vdev.release = video_device_release_empty;
-	qcam->vdev.ctrl_handler = &qcam->hdl;
-	set_bit(V4L2_FL_USE_FH_PRIO, &qcam->vdev.flags);
-	video_set_drvdata(&qcam->vdev, qcam);
-
-	mutex_init(&qcam->lock);
-	qcam->width = qcam->ccd_width = 320;
-	qcam->height = qcam->ccd_height = 240;
-	qcam->mode = QC_MILLIONS | QC_DECIMATION_1;
-	qcam->contrast = 192;
-	qcam->brightness = 240;
-	qcam->whitebal = 128;
-	qcam->top = 1;
-	qcam->left = 14;
-	return qcam;
-}
-
-static int init_cqcam(struct parport *port)
-{
-	struct qcam *qcam;
-	struct v4l2_device *v4l2_dev;
-
-	if (parport[0] != -1) {
-		/* The user gave specific instructions */
-		int i, found = 0;
-
-		for (i = 0; i < MAX_CAMS && parport[i] != -1; i++) {
-			if (parport[0] == port->number)
-				found = 1;
-		}
-		if (!found)
-			return -ENODEV;
-	}
-
-	if (num_cams == MAX_CAMS)
-		return -ENOSPC;
-
-	qcam = qcam_init(port);
-	if (qcam == NULL)
-		return -ENODEV;
-
-	v4l2_dev = &qcam->v4l2_dev;
-
-	parport_claim_or_block(qcam->pdev);
-
-	qc_reset(qcam);
-
-	if (probe && qc_detect(qcam) == 0) {
-		parport_release(qcam->pdev);
-		parport_unregister_device(qcam->pdev);
-		kfree(qcam);
-		return -ENODEV;
-	}
-
-	qc_setup(qcam);
-
-	parport_release(qcam->pdev);
-
-	if (video_register_device(&qcam->vdev, VFL_TYPE_GRABBER, video_nr) < 0) {
-		v4l2_err(v4l2_dev, "Unable to register Colour QuickCam on %s\n",
-		       qcam->pport->name);
-		parport_unregister_device(qcam->pdev);
-		kfree(qcam);
-		return -ENODEV;
-	}
-
-	v4l2_info(v4l2_dev, "%s: Colour QuickCam found on %s\n",
-	       video_device_node_name(&qcam->vdev), qcam->pport->name);
-
-	qcams[num_cams++] = qcam;
-
-	return 0;
-}
-
-static void close_cqcam(struct qcam *qcam)
-{
-	video_unregister_device(&qcam->vdev);
-	v4l2_ctrl_handler_free(&qcam->hdl);
-	parport_unregister_device(qcam->pdev);
-	kfree(qcam);
-}
-
-static void cq_attach(struct parport *port)
-{
-	init_cqcam(port);
-}
-
-static void cq_detach(struct parport *port)
-{
-	/* Write this some day. */
-}
-
-static struct parport_driver cqcam_driver = {
-	.name = "cqcam",
-	.attach = cq_attach,
-	.detach = cq_detach,
-};
-
-static int __init cqcam_init(void)
-{
-	printk(KERN_INFO BANNER "\n");
-
-	return parport_register_driver(&cqcam_driver);
-}
-
-static void __exit cqcam_cleanup(void)
-{
-	unsigned int i;
-
-	for (i = 0; i < num_cams; i++)
-		close_cqcam(qcams[i]);
-
-	parport_unregister_driver(&cqcam_driver);
-}
-
-MODULE_AUTHOR("Philip Blundell <philb@gnu.org>");
-MODULE_DESCRIPTION(BANNER);
-MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.4");
-
-module_init(cqcam_init);
-module_exit(cqcam_cleanup);
diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
deleted file mode 100644
index 77f9c92..0000000
--- a/drivers/media/video/pms.c
+++ /dev/null
@@ -1,1152 +0,0 @@
-/*
- *	Media Vision Pro Movie Studio
- *			or
- *	"all you need is an I2C bus some RAM and a prayer"
- *
- *	This draws heavily on code
- *
- *	(c) Wolfgang Koehler,  wolf@first.gmd.de, Dec. 1994
- *	Kiefernring 15
- *	14478 Potsdam, Germany
- *
- *	Most of this code is directly derived from his userspace driver.
- *	His driver works so send any reports to alan@lxorguk.ukuu.org.uk
- *	unless the userspace driver also doesn't work for you...
- *
- *      Changes:
- *	25-11-2009 	Hans Verkuil <hverkuil@xs4all.nl>
- * 			- converted to version 2 of the V4L API.
- *      08/07/2003      Daniele Bellucci <bellucda@tiscali.it>
- *                      - pms_capture: report back -EFAULT
- */
-
-#include <linux/module.h>
-#include <linux/delay.h>
-#include <linux/errno.h>
-#include <linux/fs.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/slab.h>
-#include <linux/ioport.h>
-#include <linux/init.h>
-#include <linux/mutex.h>
-#include <linux/uaccess.h>
-#include <linux/isa.h>
-#include <asm/io.h>
-
-#include <linux/videodev2.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-ctrls.h>
-#include <media/v4l2-fh.h>
-#include <media/v4l2-event.h>
-#include <media/v4l2-device.h>
-
-MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.5");
-
-#define MOTOROLA	1
-#define PHILIPS2	2               /* SAA7191 */
-#define PHILIPS1	3
-#define MVVMEMORYWIDTH	0x40		/* 512 bytes */
-
-struct i2c_info {
-	u8 slave;
-	u8 sub;
-	u8 data;
-	u8 hits;
-};
-
-struct pms {
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	struct v4l2_ctrl_handler hdl;
-	int height;
-	int width;
-	int depth;
-	int input;
-	struct mutex lock;
-	int i2c_count;
-	struct i2c_info i2cinfo[64];
-
-	int decoder;
-	int standard;	/* 0 - auto 1 - ntsc 2 - pal 3 - secam */
-	v4l2_std_id std;
-	int io;
-	int data;
-	void __iomem *mem;
-};
-
-/*
- *	I/O ports and Shared Memory
- */
-
-static int io_port = 0x250;
-module_param(io_port, int, 0);
-
-static int mem_base = 0xc8000;
-module_param(mem_base, int, 0);
-
-static int video_nr = -1;
-module_param(video_nr, int, 0);
-
-
-static inline void mvv_write(struct pms *dev, u8 index, u8 value)
-{
-	outw(index | (value << 8), dev->io);
-}
-
-static inline u8 mvv_read(struct pms *dev, u8 index)
-{
-	outb(index, dev->io);
-	return inb(dev->data);
-}
-
-static int pms_i2c_stat(struct pms *dev, u8 slave)
-{
-	int counter = 0;
-	int i;
-
-	outb(0x28, dev->io);
-
-	while ((inb(dev->data) & 0x01) == 0)
-		if (counter++ == 256)
-			break;
-
-	while ((inb(dev->data) & 0x01) != 0)
-		if (counter++ == 256)
-			break;
-
-	outb(slave, dev->io);
-
-	counter = 0;
-	while ((inb(dev->data) & 0x01) == 0)
-		if (counter++ == 256)
-			break;
-
-	while ((inb(dev->data) & 0x01) != 0)
-		if (counter++ == 256)
-			break;
-
-	for (i = 0; i < 12; i++) {
-		char st = inb(dev->data);
-
-		if ((st & 2) != 0)
-			return -1;
-		if ((st & 1) == 0)
-			break;
-	}
-	outb(0x29, dev->io);
-	return inb(dev->data);
-}
-
-static int pms_i2c_write(struct pms *dev, u16 slave, u16 sub, u16 data)
-{
-	int skip = 0;
-	int count;
-	int i;
-
-	for (i = 0; i < dev->i2c_count; i++) {
-		if ((dev->i2cinfo[i].slave == slave) &&
-		    (dev->i2cinfo[i].sub == sub)) {
-			if (dev->i2cinfo[i].data == data)
-				skip = 1;
-			dev->i2cinfo[i].data = data;
-			i = dev->i2c_count + 1;
-		}
-	}
-
-	if (i == dev->i2c_count && dev->i2c_count < 64) {
-		dev->i2cinfo[dev->i2c_count].slave = slave;
-		dev->i2cinfo[dev->i2c_count].sub = sub;
-		dev->i2cinfo[dev->i2c_count].data = data;
-		dev->i2c_count++;
-	}
-
-	if (skip)
-		return 0;
-
-	mvv_write(dev, 0x29, sub);
-	mvv_write(dev, 0x2A, data);
-	mvv_write(dev, 0x28, slave);
-
-	outb(0x28, dev->io);
-
-	count = 0;
-	while ((inb(dev->data) & 1) == 0)
-		if (count > 255)
-			break;
-	while ((inb(dev->data) & 1) != 0)
-		if (count > 255)
-			break;
-
-	count = inb(dev->data);
-
-	if (count & 2)
-		return -1;
-	return count;
-}
-
-static int pms_i2c_read(struct pms *dev, int slave, int sub)
-{
-	int i;
-
-	for (i = 0; i < dev->i2c_count; i++) {
-		if (dev->i2cinfo[i].slave == slave && dev->i2cinfo[i].sub == sub)
-			return dev->i2cinfo[i].data;
-	}
-	return 0;
-}
-
-
-static void pms_i2c_andor(struct pms *dev, int slave, int sub, int and, int or)
-{
-	u8 tmp;
-
-	tmp = pms_i2c_read(dev, slave, sub);
-	tmp = (tmp & and) | or;
-	pms_i2c_write(dev, slave, sub, tmp);
-}
-
-/*
- *	Control functions
- */
-
-
-static void pms_videosource(struct pms *dev, short source)
-{
-	switch (dev->decoder) {
-	case MOTOROLA:
-		break;
-	case PHILIPS2:
-		pms_i2c_andor(dev, 0x8a, 0x06, 0x7f, source ? 0x80 : 0);
-		break;
-	case PHILIPS1:
-		break;
-	}
-	mvv_write(dev, 0x2E, 0x31);
-	/* Was: mvv_write(dev, 0x2E, source ? 0x31 : 0x30);
-	   But could not make this work correctly. Only Composite input
-	   worked for me. */
-}
-
-static void pms_hue(struct pms *dev, short hue)
-{
-	switch (dev->decoder) {
-	case MOTOROLA:
-		pms_i2c_write(dev, 0x8a, 0x00, hue);
-		break;
-	case PHILIPS2:
-		pms_i2c_write(dev, 0x8a, 0x07, hue);
-		break;
-	case PHILIPS1:
-		pms_i2c_write(dev, 0x42, 0x07, hue);
-		break;
-	}
-}
-
-static void pms_saturation(struct pms *dev, short sat)
-{
-	switch (dev->decoder) {
-	case MOTOROLA:
-		pms_i2c_write(dev, 0x8a, 0x00, sat);
-		break;
-	case PHILIPS1:
-		pms_i2c_write(dev, 0x42, 0x12, sat);
-		break;
-	}
-}
-
-
-static void pms_contrast(struct pms *dev, short contrast)
-{
-	switch (dev->decoder) {
-	case MOTOROLA:
-		pms_i2c_write(dev, 0x8a, 0x00, contrast);
-		break;
-	case PHILIPS1:
-		pms_i2c_write(dev, 0x42, 0x13, contrast);
-		break;
-	}
-}
-
-static void pms_brightness(struct pms *dev, short brightness)
-{
-	switch (dev->decoder) {
-	case MOTOROLA:
-		pms_i2c_write(dev, 0x8a, 0x00, brightness);
-		pms_i2c_write(dev, 0x8a, 0x00, brightness);
-		pms_i2c_write(dev, 0x8a, 0x00, brightness);
-		break;
-	case PHILIPS1:
-		pms_i2c_write(dev, 0x42, 0x19, brightness);
-		break;
-	}
-}
-
-
-static void pms_format(struct pms *dev, short format)
-{
-	int target;
-
-	dev->standard = format;
-
-	if (dev->decoder == PHILIPS1)
-		target = 0x42;
-	else if (dev->decoder == PHILIPS2)
-		target = 0x8a;
-	else
-		return;
-
-	switch (format) {
-	case 0:	/* Auto */
-		pms_i2c_andor(dev, target, 0x0d, 0xfe, 0x00);
-		pms_i2c_andor(dev, target, 0x0f, 0x3f, 0x80);
-		break;
-	case 1: /* NTSC */
-		pms_i2c_andor(dev, target, 0x0d, 0xfe, 0x00);
-		pms_i2c_andor(dev, target, 0x0f, 0x3f, 0x40);
-		break;
-	case 2: /* PAL */
-		pms_i2c_andor(dev, target, 0x0d, 0xfe, 0x00);
-		pms_i2c_andor(dev, target, 0x0f, 0x3f, 0x00);
-		break;
-	case 3:	/* SECAM */
-		pms_i2c_andor(dev, target, 0x0d, 0xfe, 0x01);
-		pms_i2c_andor(dev, target, 0x0f, 0x3f, 0x00);
-		break;
-	}
-}
-
-#ifdef FOR_FUTURE_EXPANSION
-
-/*
- *	These features of the PMS card are not currently exposes. They
- *	could become a private v4l ioctl for PMSCONFIG or somesuch if
- *	people need it. We also don't yet use the PMS interrupt.
- */
-
-static void pms_hstart(struct pms *dev, short start)
-{
-	switch (dev->decoder) {
-	case PHILIPS1:
-		pms_i2c_write(dev, 0x8a, 0x05, start);
-		pms_i2c_write(dev, 0x8a, 0x18, start);
-		break;
-	case PHILIPS2:
-		pms_i2c_write(dev, 0x42, 0x05, start);
-		pms_i2c_write(dev, 0x42, 0x18, start);
-		break;
-	}
-}
-
-/*
- *	Bandpass filters
- */
-
-static void pms_bandpass(struct pms *dev, short pass)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0x8a, 0x06, 0xcf, (pass & 0x03) << 4);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x06, 0xcf, (pass & 0x03) << 4);
-}
-
-static void pms_antisnow(struct pms *dev, short snow)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0x8a, 0x06, 0xf3, (snow & 0x03) << 2);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x06, 0xf3, (snow & 0x03) << 2);
-}
-
-static void pms_sharpness(struct pms *dev, short sharp)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0x8a, 0x06, 0xfc, sharp & 0x03);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x06, 0xfc, sharp & 0x03);
-}
-
-static void pms_chromaagc(struct pms *dev, short agc)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0x8a, 0x0c, 0x9f, (agc & 0x03) << 5);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x0c, 0x9f, (agc & 0x03) << 5);
-}
-
-static void pms_vertnoise(struct pms *dev, short noise)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0x8a, 0x10, 0xfc, noise & 3);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x10, 0xfc, noise & 3);
-}
-
-static void pms_forcecolour(struct pms *dev, short colour)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0x8a, 0x0c, 0x7f, (colour & 1) << 7);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x0c, 0x7, (colour & 1) << 7);
-}
-
-static void pms_antigamma(struct pms *dev, short gamma)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0xb8, 0x00, 0x7f, (gamma & 1) << 7);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x20, 0x7, (gamma & 1) << 7);
-}
-
-static void pms_prefilter(struct pms *dev, short filter)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0x8a, 0x06, 0xbf, (filter & 1) << 6);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x06, 0xbf, (filter & 1) << 6);
-}
-
-static void pms_hfilter(struct pms *dev, short filter)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0xb8, 0x04, 0x1f, (filter & 7) << 5);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x24, 0x1f, (filter & 7) << 5);
-}
-
-static void pms_vfilter(struct pms *dev, short filter)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0xb8, 0x08, 0x9f, (filter & 3) << 5);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x28, 0x9f, (filter & 3) << 5);
-}
-
-static void pms_killcolour(struct pms *dev, short colour)
-{
-	if (dev->decoder == PHILIPS2) {
-		pms_i2c_andor(dev, 0x8a, 0x08, 0x07, (colour & 0x1f) << 3);
-		pms_i2c_andor(dev, 0x8a, 0x09, 0x07, (colour & 0x1f) << 3);
-	} else if (dev->decoder == PHILIPS1) {
-		pms_i2c_andor(dev, 0x42, 0x08, 0x07, (colour & 0x1f) << 3);
-		pms_i2c_andor(dev, 0x42, 0x09, 0x07, (colour & 0x1f) << 3);
-	}
-}
-
-static void pms_chromagain(struct pms *dev, short chroma)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_write(dev, 0x8a, 0x11, chroma);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_write(dev, 0x42, 0x11, chroma);
-}
-
-
-static void pms_spacialcompl(struct pms *dev, short data)
-{
-	mvv_write(dev, 0x3b, data);
-}
-
-static void pms_spacialcomph(struct pms *dev, short data)
-{
-	mvv_write(dev, 0x3a, data);
-}
-
-static void pms_vstart(struct pms *dev, short start)
-{
-	mvv_write(dev, 0x16, start);
-	mvv_write(dev, 0x17, (start >> 8) & 0x01);
-}
-
-#endif
-
-static void pms_secamcross(struct pms *dev, short cross)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0x8a, 0x0f, 0xdf, (cross & 1) << 5);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x0f, 0xdf, (cross & 1) << 5);
-}
-
-
-static void pms_swsense(struct pms *dev, short sense)
-{
-	if (dev->decoder == PHILIPS2) {
-		pms_i2c_write(dev, 0x8a, 0x0a, sense);
-		pms_i2c_write(dev, 0x8a, 0x0b, sense);
-	} else if (dev->decoder == PHILIPS1) {
-		pms_i2c_write(dev, 0x42, 0x0a, sense);
-		pms_i2c_write(dev, 0x42, 0x0b, sense);
-	}
-}
-
-
-static void pms_framerate(struct pms *dev, short frr)
-{
-	int fps = (dev->std & V4L2_STD_525_60) ? 30 : 25;
-
-	if (frr == 0)
-		return;
-	fps = fps/frr;
-	mvv_write(dev, 0x14, 0x80 | fps);
-	mvv_write(dev, 0x15, 1);
-}
-
-static void pms_vert(struct pms *dev, u8 deciden, u8 decinum)
-{
-	mvv_write(dev, 0x1c, deciden);	/* Denominator */
-	mvv_write(dev, 0x1d, decinum);	/* Numerator */
-}
-
-/*
- *	Turn 16bit ratios into best small ratio the chipset can grok
- */
-
-static void pms_vertdeci(struct pms *dev, unsigned short decinum, unsigned short deciden)
-{
-	/* Knock it down by / 5 once */
-	if (decinum % 5 == 0) {
-		deciden /= 5;
-		decinum /= 5;
-	}
-	/*
-	 *	3's
-	 */
-	while (decinum % 3 == 0 && deciden % 3 == 0) {
-		deciden /= 3;
-		decinum /= 3;
-	}
-	/*
-	 *	2's
-	 */
-	while (decinum % 2 == 0 && deciden % 2 == 0) {
-		decinum /= 2;
-		deciden /= 2;
-	}
-	/*
-	 *	Fudgyify
-	 */
-	while (deciden > 32) {
-		deciden /= 2;
-		decinum = (decinum + 1) / 2;
-	}
-	if (deciden == 32)
-		deciden--;
-	pms_vert(dev, deciden, decinum);
-}
-
-static void pms_horzdeci(struct pms *dev, short decinum, short deciden)
-{
-	if (decinum <= 512) {
-		if (decinum % 5 == 0) {
-			decinum /= 5;
-			deciden /= 5;
-		}
-	} else {
-		decinum = 512;
-		deciden = 640;	/* 768 would be ideal */
-	}
-
-	while (((decinum | deciden) & 1) == 0) {
-		decinum >>= 1;
-		deciden >>= 1;
-	}
-	while (deciden > 32) {
-		deciden >>= 1;
-		decinum = (decinum + 1) >> 1;
-	}
-	if (deciden == 32)
-		deciden--;
-
-	mvv_write(dev, 0x24, 0x80 | deciden);
-	mvv_write(dev, 0x25, decinum);
-}
-
-static void pms_resolution(struct pms *dev, short width, short height)
-{
-	int fg_height;
-
-	fg_height = height;
-	if (fg_height > 280)
-		fg_height = 280;
-
-	mvv_write(dev, 0x18, fg_height);
-	mvv_write(dev, 0x19, fg_height >> 8);
-
-	if (dev->std & V4L2_STD_525_60) {
-		mvv_write(dev, 0x1a, 0xfc);
-		mvv_write(dev, 0x1b, 0x00);
-		if (height > fg_height)
-			pms_vertdeci(dev, 240, 240);
-		else
-			pms_vertdeci(dev, fg_height, 240);
-	} else {
-		mvv_write(dev, 0x1a, 0x1a);
-		mvv_write(dev, 0x1b, 0x01);
-		if (fg_height > 256)
-			pms_vertdeci(dev, 270, 270);
-		else
-			pms_vertdeci(dev, fg_height, 270);
-	}
-	mvv_write(dev, 0x12, 0);
-	mvv_write(dev, 0x13, MVVMEMORYWIDTH);
-	mvv_write(dev, 0x42, 0x00);
-	mvv_write(dev, 0x43, 0x00);
-	mvv_write(dev, 0x44, MVVMEMORYWIDTH);
-
-	mvv_write(dev, 0x22, width + 8);
-	mvv_write(dev, 0x23, (width + 8) >> 8);
-
-	if (dev->std & V4L2_STD_525_60)
-		pms_horzdeci(dev, width, 640);
-	else
-		pms_horzdeci(dev, width + 8, 768);
-
-	mvv_write(dev, 0x30, mvv_read(dev, 0x30) & 0xfe);
-	mvv_write(dev, 0x08, mvv_read(dev, 0x08) | 0x01);
-	mvv_write(dev, 0x01, mvv_read(dev, 0x01) & 0xfd);
-	mvv_write(dev, 0x32, 0x00);
-	mvv_write(dev, 0x33, MVVMEMORYWIDTH);
-}
-
-
-/*
- *	Set Input
- */
-
-static void pms_vcrinput(struct pms *dev, short input)
-{
-	if (dev->decoder == PHILIPS2)
-		pms_i2c_andor(dev, 0x8a, 0x0d, 0x7f, (input & 1) << 7);
-	else if (dev->decoder == PHILIPS1)
-		pms_i2c_andor(dev, 0x42, 0x0d, 0x7f, (input & 1) << 7);
-}
-
-
-static int pms_capture(struct pms *dev, char __user *buf, int rgb555, int count)
-{
-	int y;
-	int dw = 2 * dev->width;
-	char tmp[dw + 32]; /* using a temp buffer is faster than direct  */
-	int cnt = 0;
-	int len = 0;
-	unsigned char r8 = 0x5;  /* value for reg8  */
-
-	if (rgb555)
-		r8 |= 0x20; /* else use untranslated rgb = 565 */
-	mvv_write(dev, 0x08, r8); /* capture rgb555/565, init DRAM, PC enable */
-
-/*	printf("%d %d %d %d %d %x %x\n",width,height,voff,nom,den,mvv_buf); */
-
-	for (y = 0; y < dev->height; y++) {
-		writeb(0, dev->mem);  /* synchronisiert neue Zeile */
-
-		/*
-		 *	This is in truth a fifo, be very careful as if you
-		 *	forgot this odd things will occur 8)
-		 */
-
-		memcpy_fromio(tmp, dev->mem, dw + 32); /* discard 16 word   */
-		cnt -= dev->height;
-		while (cnt <= 0) {
-			/*
-			 *	Don't copy too far
-			 */
-			int dt = dw;
-			if (dt + len > count)
-				dt = count - len;
-			cnt += dev->height;
-			if (copy_to_user(buf, tmp + 32, dt))
-				return len ? len : -EFAULT;
-			buf += dt;
-			len += dt;
-		}
-	}
-	return len;
-}
-
-
-/*
- *	Video4linux interfacing
- */
-
-static int pms_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *vcap)
-{
-	struct pms *dev = video_drvdata(file);
-
-	strlcpy(vcap->driver, dev->v4l2_dev.name, sizeof(vcap->driver));
-	strlcpy(vcap->card, "Mediavision PMS", sizeof(vcap->card));
-	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
-			"ISA:%s", dev->v4l2_dev.name);
-	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
-	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	return 0;
-}
-
-static int pms_enum_input(struct file *file, void *fh, struct v4l2_input *vin)
-{
-	static const char *inputs[4] = {
-		"Composite",
-		"S-Video",
-		"Composite (VCR)",
-		"S-Video (VCR)"
-	};
-
-	if (vin->index > 3)
-		return -EINVAL;
-	strlcpy(vin->name, inputs[vin->index], sizeof(vin->name));
-	vin->type = V4L2_INPUT_TYPE_CAMERA;
-	vin->audioset = 0;
-	vin->tuner = 0;
-	vin->std = V4L2_STD_ALL;
-	vin->status = 0;
-	return 0;
-}
-
-static int pms_g_input(struct file *file, void *fh, unsigned int *inp)
-{
-	struct pms *dev = video_drvdata(file);
-
-	*inp = dev->input;
-	return 0;
-}
-
-static int pms_s_input(struct file *file, void *fh, unsigned int inp)
-{
-	struct pms *dev = video_drvdata(file);
-
-	if (inp > 3)
-		return -EINVAL;
-
-	dev->input = inp;
-	pms_videosource(dev, inp & 1);
-	pms_vcrinput(dev, inp >> 1);
-	return 0;
-}
-
-static int pms_g_std(struct file *file, void *fh, v4l2_std_id *std)
-{
-	struct pms *dev = video_drvdata(file);
-
-	*std = dev->std;
-	return 0;
-}
-
-static int pms_s_std(struct file *file, void *fh, v4l2_std_id *std)
-{
-	struct pms *dev = video_drvdata(file);
-	int ret = 0;
-
-	dev->std = *std;
-	if (dev->std & V4L2_STD_NTSC) {
-		pms_framerate(dev, 30);
-		pms_secamcross(dev, 0);
-		pms_format(dev, 1);
-	} else if (dev->std & V4L2_STD_PAL) {
-		pms_framerate(dev, 25);
-		pms_secamcross(dev, 0);
-		pms_format(dev, 2);
-	} else if (dev->std & V4L2_STD_SECAM) {
-		pms_framerate(dev, 25);
-		pms_secamcross(dev, 1);
-		pms_format(dev, 2);
-	} else {
-		ret = -EINVAL;
-	}
-	/*
-	switch (v->mode) {
-	case VIDEO_MODE_AUTO:
-		pms_framerate(dev, 25);
-		pms_secamcross(dev, 0);
-		pms_format(dev, 0);
-		break;
-	}*/
-	return ret;
-}
-
-static int pms_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct pms *dev = container_of(ctrl->handler, struct pms, hdl);
-	int ret = 0;
-
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		pms_brightness(dev, ctrl->val);
-		break;
-	case V4L2_CID_CONTRAST:
-		pms_contrast(dev, ctrl->val);
-		break;
-	case V4L2_CID_SATURATION:
-		pms_saturation(dev, ctrl->val);
-		break;
-	case V4L2_CID_HUE:
-		pms_hue(dev, ctrl->val);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	return ret;
-}
-
-static int pms_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct pms *dev = video_drvdata(file);
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-
-	pix->width = dev->width;
-	pix->height = dev->height;
-	pix->pixelformat = dev->width == 15 ?
-			    V4L2_PIX_FMT_RGB555 : V4L2_PIX_FMT_RGB565;
-	pix->field = V4L2_FIELD_NONE;
-	pix->bytesperline = 2 * dev->width;
-	pix->sizeimage = 2 * dev->width * dev->height;
-	/* Just a guess */
-	pix->colorspace = V4L2_COLORSPACE_SRGB;
-	return 0;
-}
-
-static int pms_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-
-	if (pix->height < 16 || pix->height > 480)
-		return -EINVAL;
-	if (pix->width < 16 || pix->width > 640)
-		return -EINVAL;
-	if (pix->pixelformat != V4L2_PIX_FMT_RGB555 &&
-	    pix->pixelformat != V4L2_PIX_FMT_RGB565)
-		return -EINVAL;
-	pix->field = V4L2_FIELD_NONE;
-	pix->bytesperline = 2 * pix->width;
-	pix->sizeimage = 2 * pix->width * pix->height;
-	/* Just a guess */
-	pix->colorspace = V4L2_COLORSPACE_SRGB;
-	return 0;
-}
-
-static int pms_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct pms *dev = video_drvdata(file);
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-	int ret = pms_try_fmt_vid_cap(file, fh, fmt);
-
-	if (ret)
-		return ret;
-	dev->width = pix->width;
-	dev->height = pix->height;
-	dev->depth = (pix->pixelformat == V4L2_PIX_FMT_RGB555) ? 15 : 16;
-	pms_resolution(dev, dev->width, dev->height);
-	/* Ok we figured out what to use from our wide choice */
-	return 0;
-}
-
-static int pms_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdesc *fmt)
-{
-	static struct v4l2_fmtdesc formats[] = {
-		{ 0, 0, 0,
-		  "RGB 5:5:5", V4L2_PIX_FMT_RGB555,
-		  { 0, 0, 0, 0 }
-		},
-		{ 1, 0, 0,
-		  "RGB 5:6:5", V4L2_PIX_FMT_RGB565,
-		  { 0, 0, 0, 0 }
-		},
-	};
-	enum v4l2_buf_type type = fmt->type;
-
-	if (fmt->index > 1)
-		return -EINVAL;
-
-	*fmt = formats[fmt->index];
-	fmt->type = type;
-	return 0;
-}
-
-static ssize_t pms_read(struct file *file, char __user *buf,
-		    size_t count, loff_t *ppos)
-{
-	struct pms *dev = video_drvdata(file);
-	int len;
-
-	len = pms_capture(dev, buf, (dev->depth == 15), count);
-	return len;
-}
-
-static unsigned int pms_poll(struct file *file, struct poll_table_struct *wait)
-{
-	struct v4l2_fh *fh = file->private_data;
-	unsigned int res = POLLIN | POLLRDNORM;
-
-	if (v4l2_event_pending(fh))
-		res |= POLLPRI;
-	poll_wait(file, &fh->wait, wait);
-	return res;
-}
-
-static const struct v4l2_file_operations pms_fops = {
-	.owner		= THIS_MODULE,
-	.open           = v4l2_fh_open,
-	.release        = v4l2_fh_release,
-	.poll           = pms_poll,
-	.unlocked_ioctl	= video_ioctl2,
-	.read           = pms_read,
-};
-
-static const struct v4l2_ioctl_ops pms_ioctl_ops = {
-	.vidioc_querycap	    = pms_querycap,
-	.vidioc_g_input		    = pms_g_input,
-	.vidioc_s_input		    = pms_s_input,
-	.vidioc_enum_input	    = pms_enum_input,
-	.vidioc_g_std		    = pms_g_std,
-	.vidioc_s_std		    = pms_s_std,
-	.vidioc_enum_fmt_vid_cap    = pms_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap	    = pms_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap	    = pms_s_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap     = pms_try_fmt_vid_cap,
-	.vidioc_subscribe_event     = v4l2_ctrl_subscribe_event,
-	.vidioc_unsubscribe_event   = v4l2_event_unsubscribe,
-};
-
-/*
- *	Probe for and initialise the Mediavision PMS
- */
-
-static int init_mediavision(struct pms *dev)
-{
-	int idec, decst;
-	int i;
-	static const unsigned char i2c_defs[] = {
-		0x4c, 0x30, 0x00, 0xe8,
-		0xb6, 0xe2, 0x00, 0x00,
-		0xff, 0xff, 0x00, 0x00,
-		0x00, 0x00, 0x78, 0x98,
-		0x00, 0x00, 0x00, 0x00,
-		0x34, 0x0a, 0xf4, 0xce,
-		0xe4
-	};
-
-	dev->mem = ioremap(mem_base, 0x800);
-	if (!dev->mem)
-		return -ENOMEM;
-
-	if (!request_region(0x9a01, 1, "Mediavision PMS config")) {
-		printk(KERN_WARNING "mediavision: unable to detect: 0x9a01 in use.\n");
-		iounmap(dev->mem);
-		return -EBUSY;
-	}
-	if (!request_region(dev->io, 3, "Mediavision PMS")) {
-		printk(KERN_WARNING "mediavision: I/O port %d in use.\n", dev->io);
-		release_region(0x9a01, 1);
-		iounmap(dev->mem);
-		return -EBUSY;
-	}
-	outb(0xb8, 0x9a01);		/* Unlock */
-	outb(dev->io >> 4, 0x9a01);	/* Set IO port */
-
-
-	decst = pms_i2c_stat(dev, 0x43);
-
-	if (decst != -1)
-		idec = 2;
-	else if (pms_i2c_stat(dev, 0xb9) != -1)
-		idec = 3;
-	else if (pms_i2c_stat(dev, 0x8b) != -1)
-		idec = 1;
-	else
-		idec = 0;
-
-	printk(KERN_INFO "PMS type is %d\n", idec);
-	if (idec == 0) {
-		release_region(dev->io, 3);
-		release_region(0x9a01, 1);
-		iounmap(dev->mem);
-		return -ENODEV;
-	}
-
-	/*
-	 *	Ok we have a PMS of some sort
-	 */
-
-	mvv_write(dev, 0x04, mem_base >> 12);	/* Set the memory area */
-
-	/* Ok now load the defaults */
-
-	for (i = 0; i < 0x19; i++) {
-		if (i2c_defs[i] == 0xff)
-			pms_i2c_andor(dev, 0x8a, i, 0x07, 0x00);
-		else
-			pms_i2c_write(dev, 0x8a, i, i2c_defs[i]);
-	}
-
-	pms_i2c_write(dev, 0xb8, 0x00, 0x12);
-	pms_i2c_write(dev, 0xb8, 0x04, 0x00);
-	pms_i2c_write(dev, 0xb8, 0x07, 0x00);
-	pms_i2c_write(dev, 0xb8, 0x08, 0x00);
-	pms_i2c_write(dev, 0xb8, 0x09, 0xff);
-	pms_i2c_write(dev, 0xb8, 0x0a, 0x00);
-	pms_i2c_write(dev, 0xb8, 0x0b, 0x10);
-	pms_i2c_write(dev, 0xb8, 0x10, 0x03);
-
-	mvv_write(dev, 0x01, 0x00);
-	mvv_write(dev, 0x05, 0xa0);
-	mvv_write(dev, 0x08, 0x25);
-	mvv_write(dev, 0x09, 0x00);
-	mvv_write(dev, 0x0a, 0x20 | MVVMEMORYWIDTH);
-
-	mvv_write(dev, 0x10, 0x02);
-	mvv_write(dev, 0x1e, 0x0c);
-	mvv_write(dev, 0x1f, 0x03);
-	mvv_write(dev, 0x26, 0x06);
-
-	mvv_write(dev, 0x2b, 0x00);
-	mvv_write(dev, 0x2c, 0x20);
-	mvv_write(dev, 0x2d, 0x00);
-	mvv_write(dev, 0x2f, 0x70);
-	mvv_write(dev, 0x32, 0x00);
-	mvv_write(dev, 0x33, MVVMEMORYWIDTH);
-	mvv_write(dev, 0x34, 0x00);
-	mvv_write(dev, 0x35, 0x00);
-	mvv_write(dev, 0x3a, 0x80);
-	mvv_write(dev, 0x3b, 0x10);
-	mvv_write(dev, 0x20, 0x00);
-	mvv_write(dev, 0x21, 0x00);
-	mvv_write(dev, 0x30, 0x22);
-	return 0;
-}
-
-/*
- *	Initialization and module stuff
- */
-
-#ifndef MODULE
-static int enable;
-module_param(enable, int, 0);
-#endif
-
-static const struct v4l2_ctrl_ops pms_ctrl_ops = {
-	.s_ctrl = pms_s_ctrl,
-};
-
-static int pms_probe(struct device *pdev, unsigned int card)
-{
-	struct pms *dev;
-	struct v4l2_device *v4l2_dev;
-	struct v4l2_ctrl_handler *hdl;
-	int res;
-
-#ifndef MODULE
-	if (!enable) {
-		pr_err("PMS: not enabled, use pms.enable=1 to probe\n");
-		return -ENODEV;
-	}
-#endif
-
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL)
-		return -ENOMEM;
-
-	dev->decoder = PHILIPS2;
-	dev->io = io_port;
-	dev->data = io_port + 1;
-	v4l2_dev = &dev->v4l2_dev;
-	hdl = &dev->hdl;
-
-	res = v4l2_device_register(pdev, v4l2_dev);
-	if (res < 0) {
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		goto free_dev;
-	}
-	v4l2_info(v4l2_dev, "Mediavision Pro Movie Studio driver 0.05\n");
-
-	res = init_mediavision(dev);
-	if (res) {
-		v4l2_err(v4l2_dev, "Board not found.\n");
-		goto free_io;
-	}
-
-	v4l2_ctrl_handler_init(hdl, 4);
-	v4l2_ctrl_new_std(hdl, &pms_ctrl_ops,
-			V4L2_CID_BRIGHTNESS, 0, 255, 1, 139);
-	v4l2_ctrl_new_std(hdl, &pms_ctrl_ops,
-			V4L2_CID_CONTRAST, 0, 255, 1, 70);
-	v4l2_ctrl_new_std(hdl, &pms_ctrl_ops,
-			V4L2_CID_SATURATION, 0, 255, 1, 64);
-	v4l2_ctrl_new_std(hdl, &pms_ctrl_ops,
-			V4L2_CID_HUE, 0, 255, 1, 0);
-	if (hdl->error) {
-		res = hdl->error;
-		goto free_hdl;
-	}
-
-	mutex_init(&dev->lock);
-	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
-	dev->vdev.v4l2_dev = v4l2_dev;
-	dev->vdev.ctrl_handler = hdl;
-	dev->vdev.fops = &pms_fops;
-	dev->vdev.ioctl_ops = &pms_ioctl_ops;
-	dev->vdev.release = video_device_release_empty;
-	dev->vdev.lock = &dev->lock;
-	dev->vdev.tvnorms = V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM;
-	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
-	video_set_drvdata(&dev->vdev, dev);
-	dev->std = V4L2_STD_NTSC_M;
-	dev->height = 240;
-	dev->width = 320;
-	dev->depth = 16;
-	pms_swsense(dev, 75);
-	pms_resolution(dev, 320, 240);
-	pms_videosource(dev, 0);
-	pms_vcrinput(dev, 0);
-	v4l2_ctrl_handler_setup(hdl);
-	res = video_register_device(&dev->vdev, VFL_TYPE_GRABBER, video_nr);
-	if (res >= 0)
-		return 0;
-
-free_hdl:
-	v4l2_ctrl_handler_free(hdl);
-	v4l2_device_unregister(&dev->v4l2_dev);
-free_io:
-	release_region(dev->io, 3);
-	release_region(0x9a01, 1);
-	iounmap(dev->mem);
-free_dev:
-	kfree(dev);
-	return res;
-}
-
-static int pms_remove(struct device *pdev, unsigned int card)
-{
-	struct pms *dev = dev_get_drvdata(pdev);
-
-	video_unregister_device(&dev->vdev);
-	v4l2_ctrl_handler_free(&dev->hdl);
-	release_region(dev->io, 3);
-	release_region(0x9a01, 1);
-	iounmap(dev->mem);
-	return 0;
-}
-
-static struct isa_driver pms_driver = {
-	.probe		= pms_probe,
-	.remove		= pms_remove,
-	.driver		= {
-		.name	= "pms",
-	},
-};
-
-static int __init pms_init(void)
-{
-	return isa_register_driver(&pms_driver, 1);
-}
-
-static void __exit pms_exit(void)
-{
-	isa_unregister_driver(&pms_driver);
-}
-
-module_init(pms_init);
-module_exit(pms_exit);
diff --git a/drivers/media/video/w9966.c b/drivers/media/video/w9966.c
deleted file mode 100644
index db2a600..0000000
--- a/drivers/media/video/w9966.c
+++ /dev/null
@@ -1,981 +0,0 @@
-/*
-	Winbond w9966cf Webcam parport driver.
-
-	Version 0.33
-
-	Copyright (C) 2001 Jakob Kemi <jakob.kemi@post.utfors.se>
-
-	This program is free software; you can redistribute it and/or modify
-	it under the terms of the GNU General Public License as published by
-	the Free Software Foundation; either version 2 of the License, or
-	(at your option) any later version.
-
-	This program is distributed in the hope that it will be useful,
-	but WITHOUT ANY WARRANTY; without even the implied warranty of
-	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-	GNU General Public License for more details.
-
-	You should have received a copy of the GNU General Public License
-	along with this program; if not, write to the Free Software
-	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-/*
-	Supported devices:
-	*Lifeview FlyCam Supra (using the Philips saa7111a chip)
-
-	Does any other model using the w9966 interface chip exist ?
-
-	Todo:
-
-	*Add a working EPP mode, since DMA ECP read isn't implemented
-	in the parport drivers. (That's why it's so sloow)
-
-	*Add support for other ccd-control chips than the saa7111
-	please send me feedback on what kind of chips you have.
-
-	*Add proper probing. I don't know what's wrong with the IEEE1284
-	parport drivers but (IEEE1284_MODE_NIBBLE|IEEE1284_DEVICE_ID)
-	and nibble read seems to be broken for some peripherals.
-
-	*Add probing for onboard SRAM, port directions etc. (if possible)
-
-	*Add support for the hardware compressed modes (maybe using v4l2)
-
-	*Fix better support for the capture window (no skewed images, v4l
-	interface to capt. window)
-
-	*Probably some bugs that I don't know of
-
-	Please support me by sending feedback!
-
-	Changes:
-
-	Alan Cox:	Removed RGB mode for kernel merge, added THIS_MODULE
-			and owner support for newer module locks
-*/
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/delay.h>
-#include <linux/videodev2.h>
-#include <linux/slab.h>
-#include <media/v4l2-common.h>
-#include <media/v4l2-ioctl.h>
-#include <media/v4l2-device.h>
-#include <media/v4l2-fh.h>
-#include <media/v4l2-ctrls.h>
-#include <media/v4l2-event.h>
-#include <linux/parport.h>
-
-/*#define DEBUG*/				/* Undef me for production */
-
-#ifdef DEBUG
-#define DPRINTF(x, a...) printk(KERN_DEBUG "W9966: %s(): "x, __func__ , ##a)
-#else
-#define DPRINTF(x...)
-#endif
-
-/*
- *	Defines, simple typedefs etc.
- */
-
-#define W9966_DRIVERNAME	"W9966CF Webcam"
-#define W9966_MAXCAMS		4	/* Maximum number of cameras */
-#define W9966_RBUFFER		2048	/* Read buffer (must be an even number) */
-#define W9966_SRAMSIZE		131072	/* 128kb */
-#define W9966_SRAMID		0x02	/* check w9966cf.pdf */
-
-/* Empirically determined window limits */
-#define W9966_WND_MIN_X		16
-#define W9966_WND_MIN_Y		14
-#define W9966_WND_MAX_X		705
-#define W9966_WND_MAX_Y		253
-#define W9966_WND_MAX_W		(W9966_WND_MAX_X - W9966_WND_MIN_X)
-#define W9966_WND_MAX_H		(W9966_WND_MAX_Y - W9966_WND_MIN_Y)
-
-/* Keep track of our current state */
-#define W9966_STATE_PDEV	0x01
-#define W9966_STATE_CLAIMED	0x02
-#define W9966_STATE_VDEV	0x04
-
-#define W9966_I2C_W_ID		0x48
-#define W9966_I2C_R_ID		0x49
-#define W9966_I2C_R_DATA	0x08
-#define W9966_I2C_R_CLOCK	0x04
-#define W9966_I2C_W_DATA	0x02
-#define W9966_I2C_W_CLOCK	0x01
-
-struct w9966 {
-	struct v4l2_device v4l2_dev;
-	struct v4l2_ctrl_handler hdl;
-	unsigned char dev_state;
-	unsigned char i2c_state;
-	unsigned short ppmode;
-	struct parport *pport;
-	struct pardevice *pdev;
-	struct video_device vdev;
-	unsigned short width;
-	unsigned short height;
-	unsigned char brightness;
-	signed char contrast;
-	signed char color;
-	signed char hue;
-	struct mutex lock;
-};
-
-/*
- *	Module specific properties
- */
-
-MODULE_AUTHOR("Jakob Kemi <jakob.kemi@post.utfors.se>");
-MODULE_DESCRIPTION("Winbond w9966cf WebCam driver (0.32)");
-MODULE_LICENSE("GPL");
-MODULE_VERSION("0.33.1");
-
-#ifdef MODULE
-static char *pardev[] = {[0 ... W9966_MAXCAMS] = ""};
-#else
-static char *pardev[] = {[0 ... W9966_MAXCAMS] = "aggressive"};
-#endif
-module_param_array(pardev, charp, NULL, 0);
-MODULE_PARM_DESC(pardev, "pardev: where to search for\n"
-		"\teach camera. 'aggressive' means brute-force search.\n"
-		"\tEg: >pardev=parport3,aggressive,parport2,parport1< would assign\n"
-		"\tcam 1 to parport3 and search every parport for cam 2 etc...");
-
-static int parmode;
-module_param(parmode, int, 0);
-MODULE_PARM_DESC(parmode, "parmode: transfer mode (0=auto, 1=ecp, 2=epp");
-
-static int video_nr = -1;
-module_param(video_nr, int, 0);
-
-static struct w9966 w9966_cams[W9966_MAXCAMS];
-
-/*
- *	Private function defines
- */
-
-
-/* Set camera phase flags, so we know what to uninit when terminating */
-static inline void w9966_set_state(struct w9966 *cam, int mask, int val)
-{
-	cam->dev_state = (cam->dev_state & ~mask) ^ val;
-}
-
-/* Get camera phase flags */
-static inline int w9966_get_state(struct w9966 *cam, int mask, int val)
-{
-	return ((cam->dev_state & mask) == val);
-}
-
-/* Claim parport for ourself */
-static void w9966_pdev_claim(struct w9966 *cam)
-{
-	if (w9966_get_state(cam, W9966_STATE_CLAIMED, W9966_STATE_CLAIMED))
-		return;
-	parport_claim_or_block(cam->pdev);
-	w9966_set_state(cam, W9966_STATE_CLAIMED, W9966_STATE_CLAIMED);
-}
-
-/* Release parport for others to use */
-static void w9966_pdev_release(struct w9966 *cam)
-{
-	if (w9966_get_state(cam, W9966_STATE_CLAIMED, 0))
-		return;
-	parport_release(cam->pdev);
-	w9966_set_state(cam, W9966_STATE_CLAIMED, 0);
-}
-
-/* Read register from W9966 interface-chip
-   Expects a claimed pdev
-   -1 on error, else register data (byte) */
-static int w9966_read_reg(struct w9966 *cam, int reg)
-{
-	/* ECP, read, regtransfer, REG, REG, REG, REG, REG */
-	const unsigned char addr = 0x80 | (reg & 0x1f);
-	unsigned char val;
-
-	if (parport_negotiate(cam->pport, cam->ppmode | IEEE1284_ADDR) != 0)
-		return -1;
-	if (parport_write(cam->pport, &addr, 1) != 1)
-		return -1;
-	if (parport_negotiate(cam->pport, cam->ppmode | IEEE1284_DATA) != 0)
-		return -1;
-	if (parport_read(cam->pport, &val, 1) != 1)
-		return -1;
-
-	return val;
-}
-
-/* Write register to W9966 interface-chip
-   Expects a claimed pdev
-   -1 on error */
-static int w9966_write_reg(struct w9966 *cam, int reg, int data)
-{
-	/* ECP, write, regtransfer, REG, REG, REG, REG, REG */
-	const unsigned char addr = 0xc0 | (reg & 0x1f);
-	const unsigned char val = data;
-
-	if (parport_negotiate(cam->pport, cam->ppmode | IEEE1284_ADDR) != 0)
-		return -1;
-	if (parport_write(cam->pport, &addr, 1) != 1)
-		return -1;
-	if (parport_negotiate(cam->pport, cam->ppmode | IEEE1284_DATA) != 0)
-		return -1;
-	if (parport_write(cam->pport, &val, 1) != 1)
-		return -1;
-
-	return 0;
-}
-
-/*
- *	Ugly and primitive i2c protocol functions
- */
-
-/* Sets the data line on the i2c bus.
-   Expects a claimed pdev. */
-static void w9966_i2c_setsda(struct w9966 *cam, int state)
-{
-	if (state)
-		cam->i2c_state |= W9966_I2C_W_DATA;
-	else
-		cam->i2c_state &= ~W9966_I2C_W_DATA;
-
-	w9966_write_reg(cam, 0x18, cam->i2c_state);
-	udelay(5);
-}
-
-/* Get peripheral clock line
-   Expects a claimed pdev. */
-static int w9966_i2c_getscl(struct w9966 *cam)
-{
-	const unsigned char state = w9966_read_reg(cam, 0x18);
-	return ((state & W9966_I2C_R_CLOCK) > 0);
-}
-
-/* Sets the clock line on the i2c bus.
-   Expects a claimed pdev. -1 on error */
-static int w9966_i2c_setscl(struct w9966 *cam, int state)
-{
-	unsigned long timeout;
-
-	if (state)
-		cam->i2c_state |= W9966_I2C_W_CLOCK;
-	else
-		cam->i2c_state &= ~W9966_I2C_W_CLOCK;
-
-	w9966_write_reg(cam, 0x18, cam->i2c_state);
-	udelay(5);
-
-	/* we go to high, we also expect the peripheral to ack. */
-	if (state) {
-		timeout = jiffies + 100;
-		while (!w9966_i2c_getscl(cam)) {
-			if (time_after(jiffies, timeout))
-				return -1;
-		}
-	}
-	return 0;
-}
-
-#if 0
-/* Get peripheral data line
-   Expects a claimed pdev. */
-static int w9966_i2c_getsda(struct w9966 *cam)
-{
-	const unsigned char state = w9966_read_reg(cam, 0x18);
-	return ((state & W9966_I2C_R_DATA) > 0);
-}
-#endif
-
-/* Write a byte with ack to the i2c bus.
-   Expects a claimed pdev. -1 on error */
-static int w9966_i2c_wbyte(struct w9966 *cam, int data)
-{
-	int i;
-
-	for (i = 7; i >= 0; i--) {
-		w9966_i2c_setsda(cam, (data >> i) & 0x01);
-
-		if (w9966_i2c_setscl(cam, 1) == -1)
-			return -1;
-		w9966_i2c_setscl(cam, 0);
-	}
-
-	w9966_i2c_setsda(cam, 1);
-
-	if (w9966_i2c_setscl(cam, 1) == -1)
-		return -1;
-	w9966_i2c_setscl(cam, 0);
-
-	return 0;
-}
-
-/* Read a data byte with ack from the i2c-bus
-   Expects a claimed pdev. -1 on error */
-#if 0
-static int w9966_i2c_rbyte(struct w9966 *cam)
-{
-	unsigned char data = 0x00;
-	int i;
-
-	w9966_i2c_setsda(cam, 1);
-
-	for (i = 0; i < 8; i++) {
-		if (w9966_i2c_setscl(cam, 1) == -1)
-			return -1;
-		data = data << 1;
-		if (w9966_i2c_getsda(cam))
-			data |= 0x01;
-
-		w9966_i2c_setscl(cam, 0);
-	}
-	return data;
-}
-#endif
-
-/* Read a register from the i2c device.
-   Expects claimed pdev. -1 on error */
-#if 0
-static int w9966_read_reg_i2c(struct w9966 *cam, int reg)
-{
-	int data;
-
-	w9966_i2c_setsda(cam, 0);
-	w9966_i2c_setscl(cam, 0);
-
-	if (w9966_i2c_wbyte(cam, W9966_I2C_W_ID) == -1 ||
-	    w9966_i2c_wbyte(cam, reg) == -1)
-		return -1;
-
-	w9966_i2c_setsda(cam, 1);
-	if (w9966_i2c_setscl(cam, 1) == -1)
-		return -1;
-	w9966_i2c_setsda(cam, 0);
-	w9966_i2c_setscl(cam, 0);
-
-	if (w9966_i2c_wbyte(cam, W9966_I2C_R_ID) == -1)
-		return -1;
-	data = w9966_i2c_rbyte(cam);
-	if (data == -1)
-		return -1;
-
-	w9966_i2c_setsda(cam, 0);
-
-	if (w9966_i2c_setscl(cam, 1) == -1)
-		return -1;
-	w9966_i2c_setsda(cam, 1);
-
-	return data;
-}
-#endif
-
-/* Write a register to the i2c device.
-   Expects claimed pdev. -1 on error */
-static int w9966_write_reg_i2c(struct w9966 *cam, int reg, int data)
-{
-	w9966_i2c_setsda(cam, 0);
-	w9966_i2c_setscl(cam, 0);
-
-	if (w9966_i2c_wbyte(cam, W9966_I2C_W_ID) == -1 ||
-			w9966_i2c_wbyte(cam, reg) == -1 ||
-			w9966_i2c_wbyte(cam, data) == -1)
-		return -1;
-
-	w9966_i2c_setsda(cam, 0);
-	if (w9966_i2c_setscl(cam, 1) == -1)
-		return -1;
-
-	w9966_i2c_setsda(cam, 1);
-
-	return 0;
-}
-
-/* Find a good length for capture window (used both for W and H)
-   A bit ugly but pretty functional. The capture length
-   have to match the downscale */
-static int w9966_findlen(int near, int size, int maxlen)
-{
-	int bestlen = size;
-	int besterr = abs(near - bestlen);
-	int len;
-
-	for (len = size + 1; len < maxlen; len++) {
-		int err;
-		if (((64 * size) % len) != 0)
-			continue;
-
-		err = abs(near - len);
-
-		/* Only continue as long as we keep getting better values */
-		if (err > besterr)
-			break;
-
-		besterr = err;
-		bestlen = len;
-	}
-
-	return bestlen;
-}
-
-/* Modify capture window (if necessary)
-   and calculate downscaling
-   Return -1 on error */
-static int w9966_calcscale(int size, int min, int max, int *beg, int *end, unsigned char *factor)
-{
-	int maxlen = max - min;
-	int len = *end - *beg + 1;
-	int newlen = w9966_findlen(len, size, maxlen);
-	int err = newlen - len;
-
-	/* Check for bad format */
-	if (newlen > maxlen || newlen < size)
-		return -1;
-
-	/* Set factor (6 bit fixed) */
-	*factor = (64 * size) / newlen;
-	if (*factor == 64)
-		*factor = 0x00;	/* downscale is disabled */
-	else
-		*factor |= 0x80; /* set downscale-enable bit */
-
-	/* Modify old beginning and end */
-	*beg -= err / 2;
-	*end += err - (err / 2);
-
-	/* Move window if outside borders */
-	if (*beg < min) {
-		*end += min - *beg;
-		*beg += min - *beg;
-	}
-	if (*end > max) {
-		*beg -= *end - max;
-		*end -= *end - max;
-	}
-
-	return 0;
-}
-
-/* Setup the cameras capture window etc.
-   Expects a claimed pdev
-   return -1 on error */
-static int w9966_setup(struct w9966 *cam, int x1, int y1, int x2, int y2, int w, int h)
-{
-	unsigned int i;
-	unsigned int enh_s, enh_e;
-	unsigned char scale_x, scale_y;
-	unsigned char regs[0x1c];
-	unsigned char saa7111_regs[] = {
-		0x21, 0x00, 0xd8, 0x23, 0x00, 0x80, 0x80, 0x00,
-		0x88, 0x10, 0x80, 0x40, 0x40, 0x00, 0x01, 0x00,
-		0x48, 0x0c, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-		0x00, 0x00, 0x00, 0x71, 0xe7, 0x00, 0x00, 0xc0
-	};
-
-
-	if (w * h * 2 > W9966_SRAMSIZE) {
-		DPRINTF("capture window exceeds SRAM size!.\n");
-		w = 200; h = 160;	/* Pick default values */
-	}
-
-	w &= ~0x1;
-	if (w < 2)
-		w = 2;
-	if (h < 1)
-		h = 1;
-	if (w > W9966_WND_MAX_W)
-		w = W9966_WND_MAX_W;
-	if (h > W9966_WND_MAX_H)
-		h = W9966_WND_MAX_H;
-
-	cam->width = w;
-	cam->height = h;
-
-	enh_s = 0;
-	enh_e = w * h * 2;
-
-	/* Modify capture window if necessary and calculate downscaling */
-	if (w9966_calcscale(w, W9966_WND_MIN_X, W9966_WND_MAX_X, &x1, &x2, &scale_x) != 0 ||
-			w9966_calcscale(h, W9966_WND_MIN_Y, W9966_WND_MAX_Y, &y1, &y2, &scale_y) != 0)
-		return -1;
-
-	DPRINTF("%dx%d, x: %d<->%d, y: %d<->%d, sx: %d/64, sy: %d/64.\n",
-			w, h, x1, x2, y1, y2, scale_x & ~0x80, scale_y & ~0x80);
-
-	/* Setup registers */
-	regs[0x00] = 0x00;			/* Set normal operation */
-	regs[0x01] = 0x18;			/* Capture mode */
-	regs[0x02] = scale_y;			/* V-scaling */
-	regs[0x03] = scale_x;			/* H-scaling */
-
-	/* Capture window */
-	regs[0x04] = (x1 & 0x0ff);		/* X-start (8 low bits) */
-	regs[0x05] = (x1 & 0x300)>>8;		/* X-start (2 high bits) */
-	regs[0x06] = (y1 & 0x0ff);		/* Y-start (8 low bits) */
-	regs[0x07] = (y1 & 0x300)>>8;		/* Y-start (2 high bits) */
-	regs[0x08] = (x2 & 0x0ff);		/* X-end (8 low bits) */
-	regs[0x09] = (x2 & 0x300)>>8;		/* X-end (2 high bits) */
-	regs[0x0a] = (y2 & 0x0ff);		/* Y-end (8 low bits) */
-
-	regs[0x0c] = W9966_SRAMID;		/* SRAM-banks (1x 128kb) */
-
-	/* Enhancement layer */
-	regs[0x0d] = (enh_s & 0x000ff);		/* Enh. start (0-7) */
-	regs[0x0e] = (enh_s & 0x0ff00) >> 8;	/* Enh. start (8-15) */
-	regs[0x0f] = (enh_s & 0x70000) >> 16;	/* Enh. start (16-17/18??) */
-	regs[0x10] = (enh_e & 0x000ff);		/* Enh. end (0-7) */
-	regs[0x11] = (enh_e & 0x0ff00) >> 8;	/* Enh. end (8-15) */
-	regs[0x12] = (enh_e & 0x70000) >> 16;	/* Enh. end (16-17/18??) */
-
-	/* Misc */
-	regs[0x13] = 0x40;			/* VEE control (raw 4:2:2) */
-	regs[0x17] = 0x00;			/* ??? */
-	regs[0x18] = cam->i2c_state = 0x00;	/* Serial bus */
-	regs[0x19] = 0xff;			/* I/O port direction control */
-	regs[0x1a] = 0xff;			/* I/O port data register */
-	regs[0x1b] = 0x10;			/* ??? */
-
-	/* SAA7111 chip settings */
-	saa7111_regs[0x0a] = cam->brightness;
-	saa7111_regs[0x0b] = cam->contrast;
-	saa7111_regs[0x0c] = cam->color;
-	saa7111_regs[0x0d] = cam->hue;
-
-	/* Reset (ECP-fifo & serial-bus) */
-	if (w9966_write_reg(cam, 0x00, 0x03) == -1)
-		return -1;
-
-	/* Write regs to w9966cf chip */
-	for (i = 0; i < 0x1c; i++)
-		if (w9966_write_reg(cam, i, regs[i]) == -1)
-			return -1;
-
-	/* Write regs to saa7111 chip */
-	for (i = 0; i < 0x20; i++)
-		if (w9966_write_reg_i2c(cam, i, saa7111_regs[i]) == -1)
-			return -1;
-
-	return 0;
-}
-
-/*
- *	Video4linux interfacing
- */
-
-static int cam_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *vcap)
-{
-	struct w9966 *cam = video_drvdata(file);
-
-	strlcpy(vcap->driver, cam->v4l2_dev.name, sizeof(vcap->driver));
-	strlcpy(vcap->card, W9966_DRIVERNAME, sizeof(vcap->card));
-	strlcpy(vcap->bus_info, "parport", sizeof(vcap->bus_info));
-	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
-	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	return 0;
-}
-
-static int cam_enum_input(struct file *file, void *fh, struct v4l2_input *vin)
-{
-	if (vin->index > 0)
-		return -EINVAL;
-	strlcpy(vin->name, "Camera", sizeof(vin->name));
-	vin->type = V4L2_INPUT_TYPE_CAMERA;
-	vin->audioset = 0;
-	vin->tuner = 0;
-	vin->std = 0;
-	vin->status = 0;
-	return 0;
-}
-
-static int cam_g_input(struct file *file, void *fh, unsigned int *inp)
-{
-	*inp = 0;
-	return 0;
-}
-
-static int cam_s_input(struct file *file, void *fh, unsigned int inp)
-{
-	return (inp > 0) ? -EINVAL : 0;
-}
-
-static int cam_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct w9966 *cam =
-		container_of(ctrl->handler, struct w9966, hdl);
-	int ret = 0;
-
-	mutex_lock(&cam->lock);
-	switch (ctrl->id) {
-	case V4L2_CID_BRIGHTNESS:
-		cam->brightness = ctrl->val;
-		break;
-	case V4L2_CID_CONTRAST:
-		cam->contrast = ctrl->val;
-		break;
-	case V4L2_CID_SATURATION:
-		cam->color = ctrl->val;
-		break;
-	case V4L2_CID_HUE:
-		cam->hue = ctrl->val;
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	if (ret == 0) {
-		w9966_pdev_claim(cam);
-
-		if (w9966_write_reg_i2c(cam, 0x0a, cam->brightness) == -1 ||
-		    w9966_write_reg_i2c(cam, 0x0b, cam->contrast) == -1 ||
-		    w9966_write_reg_i2c(cam, 0x0c, cam->color) == -1 ||
-		    w9966_write_reg_i2c(cam, 0x0d, cam->hue) == -1) {
-			ret = -EIO;
-		}
-
-		w9966_pdev_release(cam);
-	}
-	mutex_unlock(&cam->lock);
-	return ret;
-}
-
-static int cam_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct w9966 *cam = video_drvdata(file);
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-
-	pix->width = cam->width;
-	pix->height = cam->height;
-	pix->pixelformat = V4L2_PIX_FMT_YUYV;
-	pix->field = V4L2_FIELD_NONE;
-	pix->bytesperline = 2 * cam->width;
-	pix->sizeimage = 2 * cam->width * cam->height;
-	/* Just a guess */
-	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
-	return 0;
-}
-
-static int cam_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-
-	if (pix->width < 2)
-		pix->width = 2;
-	if (pix->height < 1)
-		pix->height = 1;
-	if (pix->width > W9966_WND_MAX_W)
-		pix->width = W9966_WND_MAX_W;
-	if (pix->height > W9966_WND_MAX_H)
-		pix->height = W9966_WND_MAX_H;
-	pix->pixelformat = V4L2_PIX_FMT_YUYV;
-	pix->field = V4L2_FIELD_NONE;
-	pix->bytesperline = 2 * pix->width;
-	pix->sizeimage = 2 * pix->width * pix->height;
-	/* Just a guess */
-	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
-	return 0;
-}
-
-static int cam_s_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *fmt)
-{
-	struct w9966 *cam = video_drvdata(file);
-	struct v4l2_pix_format *pix = &fmt->fmt.pix;
-	int ret = cam_try_fmt_vid_cap(file, fh, fmt);
-
-	if (ret)
-		return ret;
-
-	mutex_lock(&cam->lock);
-	/* Update camera regs */
-	w9966_pdev_claim(cam);
-	ret = w9966_setup(cam, 0, 0, 1023, 1023, pix->width, pix->height);
-	w9966_pdev_release(cam);
-	mutex_unlock(&cam->lock);
-	return ret;
-}
-
-static int cam_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdesc *fmt)
-{
-	static struct v4l2_fmtdesc formats[] = {
-		{ 0, 0, 0,
-		  "YUV 4:2:2", V4L2_PIX_FMT_YUYV,
-		  { 0, 0, 0, 0 }
-		},
-	};
-	enum v4l2_buf_type type = fmt->type;
-
-	if (fmt->index > 0)
-		return -EINVAL;
-
-	*fmt = formats[fmt->index];
-	fmt->type = type;
-	return 0;
-}
-
-/* Capture data */
-static ssize_t w9966_v4l_read(struct file *file, char  __user *buf,
-		size_t count, loff_t *ppos)
-{
-	struct w9966 *cam = video_drvdata(file);
-	unsigned char addr = 0xa0;	/* ECP, read, CCD-transfer, 00000 */
-	unsigned char __user *dest = (unsigned char __user *)buf;
-	unsigned long dleft = count;
-	unsigned char *tbuf;
-
-	/* Why would anyone want more than this?? */
-	if (count > cam->width * cam->height * 2)
-		return -EINVAL;
-
-	mutex_lock(&cam->lock);
-	w9966_pdev_claim(cam);
-	w9966_write_reg(cam, 0x00, 0x02);	/* Reset ECP-FIFO buffer */
-	w9966_write_reg(cam, 0x00, 0x00);	/* Return to normal operation */
-	w9966_write_reg(cam, 0x01, 0x98);	/* Enable capture */
-
-	/* write special capture-addr and negotiate into data transfer */
-	if ((parport_negotiate(cam->pport, cam->ppmode|IEEE1284_ADDR) != 0) ||
-			(parport_write(cam->pport, &addr, 1) != 1) ||
-			(parport_negotiate(cam->pport, cam->ppmode|IEEE1284_DATA) != 0)) {
-		w9966_pdev_release(cam);
-		mutex_unlock(&cam->lock);
-		return -EFAULT;
-	}
-
-	tbuf = kmalloc(W9966_RBUFFER, GFP_KERNEL);
-	if (tbuf == NULL) {
-		count = -ENOMEM;
-		goto out;
-	}
-
-	while (dleft > 0) {
-		unsigned long tsize = (dleft > W9966_RBUFFER) ? W9966_RBUFFER : dleft;
-
-		if (parport_read(cam->pport, tbuf, tsize) < tsize) {
-			count = -EFAULT;
-			goto out;
-		}
-		if (copy_to_user(dest, tbuf, tsize) != 0) {
-			count = -EFAULT;
-			goto out;
-		}
-		dest += tsize;
-		dleft -= tsize;
-	}
-
-	w9966_write_reg(cam, 0x01, 0x18);	/* Disable capture */
-
-out:
-	kfree(tbuf);
-	w9966_pdev_release(cam);
-	mutex_unlock(&cam->lock);
-
-	return count;
-}
-
-static const struct v4l2_file_operations w9966_fops = {
-	.owner		= THIS_MODULE,
-	.open		= v4l2_fh_open,
-	.release	= v4l2_fh_release,
-	.poll		= v4l2_ctrl_poll,
-	.unlocked_ioctl = video_ioctl2,
-	.read           = w9966_v4l_read,
-};
-
-static const struct v4l2_ioctl_ops w9966_ioctl_ops = {
-	.vidioc_querycap    		    = cam_querycap,
-	.vidioc_g_input      		    = cam_g_input,
-	.vidioc_s_input      		    = cam_s_input,
-	.vidioc_enum_input   		    = cam_enum_input,
-	.vidioc_enum_fmt_vid_cap 	    = cam_enum_fmt_vid_cap,
-	.vidioc_g_fmt_vid_cap 		    = cam_g_fmt_vid_cap,
-	.vidioc_s_fmt_vid_cap  		    = cam_s_fmt_vid_cap,
-	.vidioc_try_fmt_vid_cap  	    = cam_try_fmt_vid_cap,
-	.vidioc_log_status		    = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		    = v4l2_ctrl_subscribe_event,
-	.vidioc_unsubscribe_event	    = v4l2_event_unsubscribe,
-};
-
-static const struct v4l2_ctrl_ops cam_ctrl_ops = {
-	.s_ctrl = cam_s_ctrl,
-};
-
-
-/* Initialize camera device. Setup all internal flags, set a
-   default video mode, setup ccd-chip, register v4l device etc..
-   Also used for 'probing' of hardware.
-   -1 on error */
-static int w9966_init(struct w9966 *cam, struct parport *port)
-{
-	struct v4l2_device *v4l2_dev = &cam->v4l2_dev;
-
-	if (cam->dev_state != 0)
-		return -1;
-
-	strlcpy(v4l2_dev->name, "w9966", sizeof(v4l2_dev->name));
-
-	if (v4l2_device_register(NULL, v4l2_dev) < 0) {
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		return -1;
-	}
-
-	v4l2_ctrl_handler_init(&cam->hdl, 4);
-	v4l2_ctrl_new_std(&cam->hdl, &cam_ctrl_ops,
-			  V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
-	v4l2_ctrl_new_std(&cam->hdl, &cam_ctrl_ops,
-			  V4L2_CID_CONTRAST, -64, 64, 1, 64);
-	v4l2_ctrl_new_std(&cam->hdl, &cam_ctrl_ops,
-			  V4L2_CID_SATURATION, -64, 64, 1, 64);
-	v4l2_ctrl_new_std(&cam->hdl, &cam_ctrl_ops,
-			  V4L2_CID_HUE, -128, 127, 1, 0);
-	if (cam->hdl.error) {
-		v4l2_err(v4l2_dev, "couldn't register controls\n");
-		return -1;
-	}
-	cam->pport = port;
-	cam->brightness = 128;
-	cam->contrast = 64;
-	cam->color = 64;
-	cam->hue = 0;
-
-	/* Select requested transfer mode */
-	switch (parmode) {
-	default:	/* Auto-detect (priority: hw-ecp, hw-epp, sw-ecp) */
-	case 0:
-		if (port->modes & PARPORT_MODE_ECP)
-			cam->ppmode = IEEE1284_MODE_ECP;
-		else if (port->modes & PARPORT_MODE_EPP)
-			cam->ppmode = IEEE1284_MODE_EPP;
-		else
-			cam->ppmode = IEEE1284_MODE_ECP;
-		break;
-	case 1:		/* hw- or sw-ecp */
-		cam->ppmode = IEEE1284_MODE_ECP;
-		break;
-	case 2:		/* hw- or sw-epp */
-		cam->ppmode = IEEE1284_MODE_EPP;
-		break;
-	}
-
-	/* Tell the parport driver that we exists */
-	cam->pdev = parport_register_device(port, "w9966", NULL, NULL, NULL, 0, NULL);
-	if (cam->pdev == NULL) {
-		DPRINTF("parport_register_device() failed\n");
-		return -1;
-	}
-	w9966_set_state(cam, W9966_STATE_PDEV, W9966_STATE_PDEV);
-
-	w9966_pdev_claim(cam);
-
-	/* Setup a default capture mode */
-	if (w9966_setup(cam, 0, 0, 1023, 1023, 200, 160) != 0) {
-		DPRINTF("w9966_setup() failed.\n");
-		return -1;
-	}
-
-	w9966_pdev_release(cam);
-
-	/* Fill in the video_device struct and register us to v4l */
-	strlcpy(cam->vdev.name, W9966_DRIVERNAME, sizeof(cam->vdev.name));
-	cam->vdev.v4l2_dev = v4l2_dev;
-	cam->vdev.fops = &w9966_fops;
-	cam->vdev.ioctl_ops = &w9966_ioctl_ops;
-	cam->vdev.release = video_device_release_empty;
-	cam->vdev.ctrl_handler = &cam->hdl;
-	set_bit(V4L2_FL_USE_FH_PRIO, &cam->vdev.flags);
-	video_set_drvdata(&cam->vdev, cam);
-
-	mutex_init(&cam->lock);
-
-	if (video_register_device(&cam->vdev, VFL_TYPE_GRABBER, video_nr) < 0)
-		return -1;
-
-	w9966_set_state(cam, W9966_STATE_VDEV, W9966_STATE_VDEV);
-
-	/* All ok */
-	v4l2_info(v4l2_dev, "Found and initialized a webcam on %s.\n",
-			cam->pport->name);
-	return 0;
-}
-
-
-/* Terminate everything gracefully */
-static void w9966_term(struct w9966 *cam)
-{
-	/* Unregister from v4l */
-	if (w9966_get_state(cam, W9966_STATE_VDEV, W9966_STATE_VDEV)) {
-		video_unregister_device(&cam->vdev);
-		w9966_set_state(cam, W9966_STATE_VDEV, 0);
-	}
-
-	v4l2_ctrl_handler_free(&cam->hdl);
-
-	/* Terminate from IEEE1284 mode and release pdev block */
-	if (w9966_get_state(cam, W9966_STATE_PDEV, W9966_STATE_PDEV)) {
-		w9966_pdev_claim(cam);
-		parport_negotiate(cam->pport, IEEE1284_MODE_COMPAT);
-		w9966_pdev_release(cam);
-	}
-
-	/* Unregister from parport */
-	if (w9966_get_state(cam, W9966_STATE_PDEV, W9966_STATE_PDEV)) {
-		parport_unregister_device(cam->pdev);
-		w9966_set_state(cam, W9966_STATE_PDEV, 0);
-	}
-	memset(cam, 0, sizeof(*cam));
-}
-
-
-/* Called once for every parport on init */
-static void w9966_attach(struct parport *port)
-{
-	int i;
-
-	for (i = 0; i < W9966_MAXCAMS; i++) {
-		if (w9966_cams[i].dev_state != 0)	/* Cam is already assigned */
-			continue;
-		if (strcmp(pardev[i], "aggressive") == 0 || strcmp(pardev[i], port->name) == 0) {
-			if (w9966_init(&w9966_cams[i], port) != 0)
-				w9966_term(&w9966_cams[i]);
-			break;	/* return */
-		}
-	}
-}
-
-/* Called once for every parport on termination */
-static void w9966_detach(struct parport *port)
-{
-	int i;
-
-	for (i = 0; i < W9966_MAXCAMS; i++)
-		if (w9966_cams[i].dev_state != 0 && w9966_cams[i].pport == port)
-			w9966_term(&w9966_cams[i]);
-}
-
-
-static struct parport_driver w9966_ppd = {
-	.name = W9966_DRIVERNAME,
-	.attach = w9966_attach,
-	.detach = w9966_detach,
-};
-
-/* Module entry point */
-static int __init w9966_mod_init(void)
-{
-	int i;
-
-	for (i = 0; i < W9966_MAXCAMS; i++)
-		w9966_cams[i].dev_state = 0;
-
-	return parport_register_driver(&w9966_ppd);
-}
-
-/* Module cleanup */
-static void __exit w9966_mod_term(void)
-{
-	parport_unregister_driver(&w9966_ppd);
-}
-
-module_init(w9966_mod_init);
-module_exit(w9966_mod_term);
-- 
1.7.11.2

