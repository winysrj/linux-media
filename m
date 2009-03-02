Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n224WvSS016964
	for <video4linux-list@redhat.com>; Sun, 1 Mar 2009 23:32:57 -0500
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n224WPMu029849
	for <video4linux-list@redhat.com>; Sun, 1 Mar 2009 23:32:25 -0500
Received: by fg-out-1718.google.com with SMTP id 19so802728fgg.7
	for <video4linux-list@redhat.com>; Sun, 01 Mar 2009 20:32:24 -0800 (PST)
Date: Mon, 2 Mar 2009 13:33:33 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20090302133333.6f89aef0@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: saa7134 and RDS
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi All.

I want use RDS on our TV cards. But now saa7134 not work with saa6588.
I found this old patch from Hans J. Koch. Why this patch is not in mercurial??
Yes I know that patch for v4l ver.1 and for old kernel. But why not?? 
v4l has other way for RDS on saa7134 boards?

I finally succeeded adding support for the saa6588 RDS decoder to the saa7134 
driver. I tested it with a Terratec Cinergy 600, and it seems to work. With 
the attached patch applied to saa7134-video.c, I can do

modprobe saa6588 xtal=1

and can then read RDS data from /dev/radio.

I'd be pleased if you could apply that patch.

Cheers,
Hans

Signed-off-by: Hans J. Koch <koch@xxxxxxxxx>

--- orig/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-video.c	2006-05-06 13:27:49.000000000 +0200
+++ mine/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-video.c	2006-05-05 14:38:11.000000000 +0200
@@ -31,6 +31,7 @@
 #include "saa7134-reg.h"
 #include "saa7134.h"
 #include <media/v4l2-common.h>
+#include <media/rds.h>
 
 #ifdef CONFIG_VIDEO_V4L1_COMPAT
 /* Include V4L1 specific functions. Should be removed soon */
@@ -1374,6 +1375,7 @@ static int video_release(struct inode *i
 	struct saa7134_fh  *fh  = file->private_data;
 	struct saa7134_dev *dev = fh->dev;
 	unsigned long flags;
+	struct rds_command cmd;
 
 	/* turn off overlay */
 	if (res_check(fh, RESOURCE_OVERLAY)) {
@@ -1409,6 +1411,7 @@ static int video_release(struct inode *i
 	saa_andorb(SAA7134_OFMT_DATA_B, 0x1f, 0);
 
 	saa7134_i2c_call_clients(dev, TUNER_SET_STANDBY, NULL);
+	saa7134_i2c_call_clients(dev, RDS_CMD_CLOSE, &cmd);
 
 	/* free stuff */
 	videobuf_mmap_free(&fh->cap);
@@ -2284,6 +2287,35 @@ static int radio_ioctl(struct inode *ino
 	return video_usercopy(inode, file, cmd, arg, radio_do_ioctl);
 }
 
+static ssize_t radio_read(struct file *file, char __user *data,
+			 size_t count, loff_t *ppos)
+{
+	struct saa7134_fh *fh = file->private_data;
+	struct saa7134_dev *dev = fh->dev;
+	struct rds_command cmd;
+	cmd.block_count = count/3;
+	cmd.buffer = data;
+	cmd.instance = file;
+	cmd.result = -ENODEV;
+
+	saa7134_i2c_call_clients(dev, RDS_CMD_READ, &cmd);
+
+	return cmd.result;
+}
+
+static unsigned int radio_poll(struct file *file, poll_table *wait)
+{
+	struct saa7134_fh *fh = file->private_data;
+	struct saa7134_dev *dev = fh->dev;
+	struct rds_command cmd;
+	cmd.instance = file;
+	cmd.event_list = wait;
+	cmd.result = -ENODEV;
+	saa7134_i2c_call_clients(dev, RDS_CMD_POLL, &cmd);
+
+	return cmd.result;
+}
+
 static struct file_operations video_fops =
 {
 	.owner	  = THIS_MODULE,
@@ -2305,6 +2337,8 @@ static struct file_operations radio_fops
 	.open	  = video_open,
 	.release  = video_release,
 	.ioctl	  = radio_ioctl,
+	.read	  = radio_read,
+	.poll	  = radio_poll,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,11)
 	.compat_ioctl	= v4l_compat_ioctl32,
 #endif

--


With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
