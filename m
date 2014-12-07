Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38141 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaLGTW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 14:22:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Paulo Assis <pj.assis@gmail.com>
Subject: Re: (bisected) Logitech C920 (uvcvideo) stutters since 3.9
Date: Sun, 07 Dec 2014 21:23:06 +0200
Message-ID: <1717818.6PrJVEWcvp@avalon>
In-Reply-To: <CANOLnOMvBFiR2n0BMBO+DQ+b21Veb3r1dsw7C72OSyskxorY0w@mail.gmail.com>
References: <CANOLnONA8jaVJNna36sNOeoKtU=+iBFEEnG2h1K+KGg5Y3q7dA@mail.gmail.com> <10129477.C7LMJl3dKC@avalon> <CANOLnOMvBFiR2n0BMBO+DQ+b21Veb3r1dsw7C72OSyskxorY0w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Grazvydas,

(CC'ing Paulo Assis)

On Saturday 06 December 2014 02:25:25 Grazvydas Ignotas wrote:
> On Fri, Dec 5, 2014 at 1:46 PM, Laurent Pinchart wrote:
> > On Thursday 06 November 2014 00:29:53 Grazvydas Ignotas wrote:
> >> On Wed, Nov 5, 2014 at 4:05 PM, Laurent Pinchart wrote:
> >> > Would you be able to capture images from the C920 using yavta, with the
> >> > uvcvideo trace parameter set to 4096, and send me both the yavta log
> >> > and the kernel log ? Let's start with a capture sequence of 50 to 100
> >> > images.
> >> 
> >> I've done 2 captures, if that helps:
> >> http://notaz.gp2x.de/tmp/c920_yavta/
> >> 
> >> The second one was done using low exposure setting, which allows
> >> camera to achieve higher frame rate.
> > 
> > Thank you for the log, they were very helpful. They revealed that the USB
> > SOF (Start Of Frame) counter values on the device and host side are not
> > in sync. The counters get incremented are very different rates. What USB
> > controller are you using ?
> 
> 00:1d.7 USB controller: Intel Corporation NM10/ICH7 Family USB2 EHCI
> Controller (rev 01) (prog-if 20 [EHCI])
>         Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7592
>         Flags: bus master, medium devsel, latency 0, IRQ 23
>         Memory at fe9fbc00 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Kernel driver in use: ehci-pci
> 
> If it helps, I could try on an ARM board, currently don't have any
> other x86 hardware around.

Actually the frequencies I've computed from the log are correct on the host
side but quite off on the device side. I'm puzzled.

The following patch allows accessing the contents of the clock data buffer
through debugfs. Would you be able to apply it and execute the following
steps ?

1. Load the uvcvideo module with the clock trace flag (0x1000) set.

2. Start capturing clock data.

while true; do
	cat /sys/kernel/debug/usb/uvcvideo/2-6/clocks ;
done > ~/samples.log

3. Capture 100 frames.

yavta -c100 > yavta.log

4. Stop the "while true" with ctrl-C.

5. Capture the uvcvideo stats.

cat /sys/kernel/debug/usb/uvcvideo/2-6/stats > stats.log

6. Capture the kernel log.

dmesg > dmesg.log

7. Send me all the log files.

>From 801372be5eeac86326bc7eb230783a4d2a491c2e Mon Sep 17 00:00:00 2001
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Sun, 7 Dec 2014 17:02:05 +0200
Subject: [PATCH] uvcvideo: Expose clock samples through debugfs

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_debugfs.c | 71 ++++++++++++++++++++++++++++---------
 drivers/media/usb/uvc/uvc_video.c   | 44 +++++++++++++++++++++++
 drivers/media/usb/uvc/uvcvideo.h    |  5 +++
 3 files changed, 104 insertions(+), 16 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_debugfs.c b/drivers/media/usb/uvc/uvc_debugfs.c
index 14561a5..4013dc5 100644
--- a/drivers/media/usb/uvc/uvc_debugfs.c
+++ b/drivers/media/usb/uvc/uvc_debugfs.c
@@ -19,16 +19,37 @@
 #include "uvcvideo.h"
 
 /* -----------------------------------------------------------------------------
- * Statistics
+ * Common Helpers
  */
 
-#define UVC_DEBUGFS_BUF_SIZE	1024
+#define UVC_DEBUGFS_BUF_SIZE	2048
 
 struct uvc_debugfs_buffer {
 	size_t count;
 	char data[UVC_DEBUGFS_BUF_SIZE];
 };
 
+static ssize_t uvc_debugfs_read(struct file *file, char __user *user_buf,
+				size_t nbytes, loff_t *ppos)
+{
+	struct uvc_debugfs_buffer *buf = file->private_data;
+
+	return simple_read_from_buffer(user_buf, nbytes, ppos, buf->data,
+				       buf->count);
+}
+
+static int uvc_debugfs_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	file->private_data = NULL;
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * Statistics
+ */
+
 static int uvc_debugfs_stats_open(struct inode *inode, struct file *file)
 {
 	struct uvc_streaming *stream = inode->i_private;
@@ -44,29 +65,39 @@ static int uvc_debugfs_stats_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t uvc_debugfs_stats_read(struct file *file, char __user *user_buf,
-				      size_t nbytes, loff_t *ppos)
-{
-	struct uvc_debugfs_buffer *buf = file->private_data;
+static const struct file_operations uvc_debugfs_stats_fops = {
+	.owner = THIS_MODULE,
+	.open = uvc_debugfs_stats_open,
+	.llseek = no_llseek,
+	.read = uvc_debugfs_read,
+	.release = uvc_debugfs_release,
+};
 
-	return simple_read_from_buffer(user_buf, nbytes, ppos, buf->data,
-				       buf->count);
-}
+/* -----------------------------------------------------------------------------
+ * Clocks
+ */
 
-static int uvc_debugfs_stats_release(struct inode *inode, struct file *file)
+static int uvc_debugfs_clocks_open(struct inode *inode, struct file *file)
 {
-	kfree(file->private_data);
-	file->private_data = NULL;
+	struct uvc_streaming *stream = inode->i_private;
+	struct uvc_debugfs_buffer *buf;
+
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
 
+	buf->count = uvc_video_clocks_dump(stream, buf->data, sizeof(buf->data));
+
+	file->private_data = buf;
 	return 0;
 }
 
-static const struct file_operations uvc_debugfs_stats_fops = {
+static const struct file_operations uvc_debugfs_clocks_fops = {
 	.owner = THIS_MODULE,
-	.open = uvc_debugfs_stats_open,
+	.open = uvc_debugfs_clocks_open,
 	.llseek = no_llseek,
-	.read = uvc_debugfs_stats_read,
-	.release = uvc_debugfs_stats_release,
+	.read = uvc_debugfs_read,
+	.release = uvc_debugfs_release,
 };
 
 /* -----------------------------------------------------------------------------
@@ -95,6 +126,14 @@ int uvc_debugfs_init_stream(struct uvc_streaming *stream)
 
 	stream->debugfs_dir = dent;
 
+	dent = debugfs_create_file("clocks", 0444, stream->debugfs_dir,
+				   stream, &uvc_debugfs_clocks_fops);
+	if (IS_ERR_OR_NULL(dent)) {
+		uvc_printk(KERN_INFO, "Unable to create debugfs clocks file.\n");
+		uvc_debugfs_cleanup_stream(stream);
+		return -ENODEV;
+	}
+
 	dent = debugfs_create_file("stats", 0444, stream->debugfs_dir,
 				   stream, &uvc_debugfs_stats_fops);
 	if (IS_ERR_OR_NULL(dent)) {
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 9637e8b..831f6ea 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -466,12 +466,15 @@ uvc_video_clock_decode(struct uvc_streaming *stream, struct uvc_buffer *buf,
 	sample->dev_sof = dev_sof;
 	sample->host_sof = host_sof;
 	sample->host_ts = ts;
+	sample->index = stream->clock.index++;
 
 	/* Update the sliding window head and count. */
 	stream->clock.head = (stream->clock.head + 1) % stream->clock.size;
 
 	if (stream->clock.count < stream->clock.size)
 		stream->clock.count++;
+	if (stream->clock.print < stream->clock.size)
+		stream->clock.print++;
 
 	spin_unlock_irqrestore(&stream->clock.lock, flags);
 }
@@ -480,10 +483,51 @@ static void uvc_video_clock_reset(struct uvc_streaming *stream)
 {
 	struct uvc_clock *clock = &stream->clock;
 
+	spin_lock_irq(&clock->lock);
+
 	clock->head = 0;
 	clock->count = 0;
+	clock->print = 0;
+	clock->index = 0;
 	clock->last_sof = -1;
 	clock->sof_offset = -1;
+
+	spin_unlock_irq(&clock->lock);
+}
+
+size_t uvc_video_clocks_dump(struct uvc_streaming *stream, char *buf,
+			     size_t size)
+{
+	struct uvc_clock *clock = &stream->clock;
+	unsigned int pos;
+	size_t count = 0;
+
+	mutex_lock(&stream->mutex);
+
+	if (!clock->samples)
+		goto done;
+
+	spin_lock_irq(&clock->lock);
+
+	pos = (clock->head - clock->print) % clock->size;
+
+	for (; clock->print; clock->print--) {
+		struct uvc_clock_sample *sample = &clock->samples[pos];
+
+		count += scnprintf(buf + count, size - count,
+				   "%04x %08x %04x %04x %08lx %08lx\n",
+				   sample->index, sample->dev_stc, sample->dev_sof,
+				   sample->host_sof, sample->host_ts.tv_sec,
+				   sample->host_ts.tv_nsec);
+		pos = (pos + 1) % clock->size;
+	}
+
+	spin_unlock_irq(&clock->lock);
+
+done:
+	mutex_unlock(&stream->mutex);
+
+	return count;
 }
 
 static int uvc_video_clock_init(struct uvc_streaming *stream)
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index f0a04b5..e0950b4 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -501,11 +501,14 @@ struct uvc_streaming {
 			u16 dev_sof;
 			struct timespec host_ts;
 			u16 host_sof;
+			u16 index;
 		} *samples;
 
 		unsigned int head;
 		unsigned int count;
 		unsigned int size;
+		unsigned int print;
+		u16 index;
 
 		u16 last_sof;
 		u16 sof_offset;
@@ -737,6 +740,8 @@ void uvc_debugfs_cleanup(void);
 int uvc_debugfs_init_stream(struct uvc_streaming *stream);
 void uvc_debugfs_cleanup_stream(struct uvc_streaming *stream);
 
+size_t uvc_video_clocks_dump(struct uvc_streaming *stream, char *buf,
+			     size_t size);
 size_t uvc_video_stats_dump(struct uvc_streaming *stream, char *buf,
 			    size_t size);
 
-- 
Regards,

Laurent Pinchart

