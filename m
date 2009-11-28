Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40304 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751977AbZK1LLM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 06:11:12 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: vandrove@vc.cvut.cz
Subject: radio-sf16fmi: fix mute, add SF16-FMP to texts
Date: Sat, 28 Nov 2009 12:04:30 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911281204.32570.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix completely broken mute handling radio-sf16fmi.
The sound was muted immediately after tuning in KRadio.
Also fix typos and add SF16-FMP to the texts.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff -urp linux-source-2.6.31-orig/drivers/media/radio/Kconfig linux-source-2.6.31/drivers/media/radio/Kconfig
--- linux-source-2.6.31-orig/drivers/media/radio/Kconfig	2009-09-10 00:13:59.000000000 +0200
+++ linux-source-2.6.31/drivers/media/radio/Kconfig	2009-11-28 11:51:42.000000000 +0100
@@ -196,7 +196,7 @@ config RADIO_MAESTRO
 	  module will be called radio-maestro.
 
 config RADIO_SF16FMI
-	tristate "SF16FMI Radio"
+	tristate "SF16-FMI/SF16-FMP Radio"
 	depends on ISA && VIDEO_V4L2
 	---help---
 	  Choose Y here if you have one of these FM radio cards.  If you
diff -urp linux-source-2.6.31-orig/drivers/media/radio/radio-sf16fmi.c linux-source-2.6.31/drivers/media/radio/radio-sf16fmi.c
--- linux-source-2.6.31-orig/drivers/media/radio/radio-sf16fmi.c	2009-09-10 00:13:59.000000000 +0200
+++ linux-source-2.6.31/drivers/media/radio/radio-sf16fmi.c	2009-11-28 11:39:35.000000000 +0100
@@ -1,4 +1,4 @@
-/* SF16FMI radio driver for Linux radio support
+/* SF16-FMI and SF16-FMP radio driver for Linux radio support
  * heavily based on rtrack driver...
  * (c) 1997 M. Kirkwood
  * (c) 1998 Petr Vandrovec, vandrove@vc.cvut.cz
@@ -11,7 +11,7 @@
  *
  *  Frequency control is done digitally -- ie out(port,encodefreq(95.8));
  *  No volume control - only mute/unmute - you have to use line volume
- *  control on SB-part of SF16FMI
+ *  control on SB-part of SF16-FMI/SF16-FMP
  *
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
  */
@@ -30,14 +30,14 @@
 #include <media/v4l2-ioctl.h>
 
 MODULE_AUTHOR("Petr Vandrovec, vandrove@vc.cvut.cz and M. Kirkwood");
-MODULE_DESCRIPTION("A driver for the SF16MI radio.");
+MODULE_DESCRIPTION("A driver for the SF16-FMI and SF16-FMP radio.");
 MODULE_LICENSE("GPL");
 
 static int io = -1;
 static int radio_nr = -1;
 
 module_param(io, int, 0);
-MODULE_PARM_DESC(io, "I/O address of the SF16MI card (0x284 or 0x384)");
+MODULE_PARM_DESC(io, "I/O address of the SF16-FMI or SF16-FMP card (0x284 or 0x384)");
 module_param(radio_nr, int, 0);
 
 #define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
@@ -47,7 +47,7 @@ struct fmi
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
 	int io;
-	int curvol; /* 1 or 0 */
+	bool mute;
 	unsigned long curfreq; /* freq in kHz */
 	struct mutex lock;
 };
@@ -105,7 +105,7 @@ static inline int fmi_setfreq(struct fmi
 	outbits(8, 0xC0, fmi->io);
 	msleep(143);		/* was schedule_timeout(HZ/7) */
 	mutex_unlock(&fmi->lock);
-	if (fmi->curvol)
+	if (!fmi->mute)
 		fmi_unmute(fmi);
 	return 0;
 }
@@ -116,7 +116,7 @@ static inline int fmi_getsigstr(struct f
 	int res;
 
 	mutex_lock(&fmi->lock);
-	val = fmi->curvol ? 0x08 : 0x00;	/* unmute/mute */
+	val = fmi->mute ? 0x00 : 0x08;	/* mute/unmute */
 	outb(val, fmi->io);
 	outb(val | 0x10, fmi->io);
 	msleep(143); 		/* was schedule_timeout(HZ/7) */
@@ -204,7 +204,7 @@ static int vidioc_g_ctrl(struct file *fi
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		ctrl->value = fmi->curvol;
+		ctrl->value = fmi->mute;
 		return 0;
 	}
 	return -EINVAL;
@@ -221,7 +221,7 @@ static int vidioc_s_ctrl(struct file *fi
 			fmi_mute(fmi);
 		else
 			fmi_unmute(fmi);
-		fmi->curvol = ctrl->value;
+		fmi->mute = ctrl->value;
 		return 0;
 	}
 	return -EINVAL;

-- 
Ondrej Zary
