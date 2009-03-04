Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4038 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZCDRpn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 12:45:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: saa7134 and RDS
Date: Wed, 4 Mar 2009 18:45:45 +0100
Cc: "Hans J. Koch" <hjk@linutronix.de>,
	"hermann pitton" <hermann-pitton@arcor.de>,
	"Hans J. Koch" <koch@hjk-az.de>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
References: <28050.62.70.2.252.1236161035.squirrel@webmail.xs4all.nl> <20090304210246.75a5b602@glory.loctelecom.ru>
In-Reply-To: <20090304210246.75a5b602@glory.loctelecom.ru>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_J5rrJjOb+z5IFzY"
Message-Id: <200903041845.45469.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_J5rrJjOb+z5IFzY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 04 March 2009 13:02:46 Dmitri Belimov wrote:
> > Dmitri,
> >
> > I have a patch pending to fix this for the saa7134 driver. The i2c
> > problems are resolved, so this shouldn't be a problem anymore.
>
> Good news!
>
> > The one thing that is holding this back is that I first want to
> > finalize the RFC regarding the RDS support. I posted an RFC a few
> > weeks ago, but I need to make a second version and for that I need to
> > do a bit of research into the US version of RDS. And I haven't found
> > the time to do that yet.
>
> Yes, I found your discussion in linux-media mailing list. If you
> need any information from chip vendor I'll try find. I can get it
> under NDA and help you.
>
> > I'll see if I can get the patch merged anyway.

I've attached my patch for the saa7134. I want to wait with the final pull 
request until I've finished the RDS RFC, but this gives you something to 
play with.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--Boundary-00=_J5rrJjOb+z5IFzY
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="saa7134-rds.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="saa7134-rds.diff"

diff -r 54ae11f1e777 linux/drivers/media/video/saa6588.c
--- a/linux/drivers/media/video/saa6588.c	Wed Feb 11 23:28:30 2009 +0100
+++ b/linux/drivers/media/video/saa6588.c	Fri Feb 13 09:07:20 2009 +0100
@@ -541,7 +541,6 @@
 	.command = saa6588_command,
 	.probe = saa6588_probe,
 	.remove = saa6588_remove,
-	.legacy_class = I2C_CLASS_TV_ANALOG,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
 	.id_table = saa6588_id,
 #endif
diff -r 54ae11f1e777 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Feb 11 23:28:30 2009 +0100
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Feb 13 09:07:20 2009 +0100
@@ -1699,6 +1699,7 @@
 		.radio_type     = UNSET,
 		.tuner_addr	= ADDR_UNSET,
 		.radio_addr	= ADDR_UNSET,
+		.rds_addr 	= 0x10,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.inputs         = {{
 			.name = name_tv,
diff -r 54ae11f1e777 linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Wed Feb 11 23:28:30 2009 +0100
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Fri Feb 13 09:07:20 2009 +0100
@@ -1050,6 +1050,17 @@
 			sd->grp_id = GRP_EMPRESS;
 	}
 
+	if (saa7134_boards[dev->board].rds_addr) {
+		unsigned short addrs[2] = { 0, I2C_CLIENT_END };
+		struct v4l2_subdev *sd;
+
+		addrs[0] = saa7134_boards[dev->board].rds_addr;
+		sd = v4l2_i2c_new_probed_subdev(&dev->i2c_adap, "saa6588",
+			    "saa6588", addrs);
+		if (sd)
+			printk(KERN_INFO "%s: found RDS decoder\n", dev->name);
+	}
+
 	request_submodules(dev);
 
 	v4l2_prio_init(&dev->prio);
diff -r 54ae11f1e777 linux/drivers/media/video/saa7134/saa7134-video.c
--- a/linux/drivers/media/video/saa7134/saa7134-video.c	Wed Feb 11 23:28:30 2009 +0100
+++ b/linux/drivers/media/video/saa7134/saa7134-video.c	Fri Feb 13 09:07:20 2009 +0100
@@ -30,6 +30,7 @@
 #include "saa7134-reg.h"
 #include "saa7134.h"
 #include <media/v4l2-common.h>
+#include <media/rds.h>
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 /* Include V4L1 specific functions. Should be removed soon */
@@ -1467,6 +1468,7 @@
 {
 	struct saa7134_fh  *fh  = file->private_data;
 	struct saa7134_dev *dev = fh->dev;
+	struct rds_command cmd;
 	unsigned long flags;
 
 	/* turn off overlay */
@@ -1500,6 +1502,8 @@
 	saa_andorb(SAA7134_OFMT_DATA_B, 0x1f, 0);
 
 	saa_call_all(dev, core, s_standby, 0);
+	if (fh->radio)
+		saa_call_all(dev, core, ioctl, RDS_CMD_CLOSE, &cmd);
 
 	/* free stuff */
 	videobuf_mmap_free(&fh->cap);
@@ -1518,6 +1522,37 @@
 	struct saa7134_fh *fh = file->private_data;
 
 	return videobuf_mmap_mapper(saa7134_queue(fh), vma);
+}
+
+static ssize_t radio_read(struct file *file, char __user *data,
+			 size_t count, loff_t *ppos)
+{
+	struct saa7134_fh *fh = file->private_data;
+	struct saa7134_dev *dev = fh->dev;
+	struct rds_command cmd;
+
+	cmd.block_count = count/3;
+	cmd.buffer = data;
+	cmd.instance = file;
+	cmd.result = -ENODEV;
+
+	saa_call_all(dev, core, ioctl, RDS_CMD_READ, &cmd);
+
+	return cmd.result;
+}
+
+static unsigned int radio_poll(struct file *file, poll_table *wait)
+{
+	struct saa7134_fh *fh = file->private_data;
+	struct saa7134_dev *dev = fh->dev;
+	struct rds_command cmd;
+
+	cmd.instance = file;
+	cmd.event_list = wait;
+	cmd.result = -ENODEV;
+	saa_call_all(dev, core, ioctl, RDS_CMD_POLL, &cmd);
+
+	return cmd.result;
 }
 
 /* ------------------------------------------------------------------ */
@@ -2451,8 +2486,10 @@
 static const struct v4l2_file_operations radio_fops = {
 	.owner	  = THIS_MODULE,
 	.open	  = video_open,
+	.read     = radio_read,
 	.release  = video_release,
 	.ioctl	  = video_ioctl2,
+	.poll     = radio_poll,
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
diff -r 54ae11f1e777 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Wed Feb 11 23:28:30 2009 +0100
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Fri Feb 13 09:07:20 2009 +0100
@@ -326,6 +326,7 @@
 	unsigned int		radio_type;
 	unsigned char		tuner_addr;
 	unsigned char		radio_addr;
+	unsigned char		rds_addr;
 
 	unsigned int            tda9887_conf;
 	unsigned int            tuner_config;

--Boundary-00=_J5rrJjOb+z5IFzY--
