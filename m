Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.comexp.ru ([78.110.60.213]:32988 "EHLO mail.comexp.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbaCaMnF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Mar 2014 08:43:05 -0400
Message-ID: <1396264485.4328.11.camel@localhost.localdomain>
Subject: [PATCH v2 3/3] saa7134: add notification about TV standard changes
From: Mikhail Domrachev <mihail.domrychev@comexp.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Aleksey Igonin <aleksey.igonin@comexp.ru>
Date: Mon, 31 Mar 2014 15:14:45 +0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2 event of type V4L2_EVENT_SIGNALCHANGED is emitted
when the current TV standard changes.

Signed-off-by: Mikhail Domrachev <mihail.domrychev@comexp.ru>
---
 drivers/media/pci/saa7134/saa7134-video.c | 125 +++++++++++++++++++++++++++++-
 drivers/media/pci/saa7134/saa7134.h       |  11 +++
 2 files changed, 135 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index bc85d84..0c0f218 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -24,6 +24,9 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
+#include <linux/freezer.h>
 #include <linux/slab.h>
 #include <linux/sort.h>
 
@@ -51,6 +54,7 @@ MODULE_PARM_DESC(noninterlaced,"capture non interlaced video");
 module_param_string(secam, secam, sizeof(secam), 0644);
 MODULE_PARM_DESC(secam, "force SECAM variant, either DK,L or Lc");
 
+static int saa7134_standard_detector_thread(void *arg);
 
 #define dprintk(fmt, arg...)	if (video_debug&0x04) \
 	printk(KERN_DEBUG "%s/video: " fmt, dev->name , ## arg)
@@ -2097,6 +2101,17 @@ static int radio_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
+static int saa7134_subscribe_event(struct v4l2_fh *fh,
+		const struct v4l2_event_subscription *sub)
+{
+	if (sub->type == V4L2_EVENT_SIGNALCHANGED) {
+		return v4l2_event_subscribe(fh, sub,
+				SAA7134_EVENTS_QUEUE_SIZE, NULL);
+	} else {
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	}
+}
+
 static const struct v4l2_file_operations video_fops =
 {
 	.owner	  = THIS_MODULE,
@@ -2148,7 +2163,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_register              = vidioc_s_register,
 #endif
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= saa7134_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
@@ -2317,6 +2332,11 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 
 void saa7134_video_fini(struct saa7134_dev *dev)
 {
+	if (dev->std_thread.thread && !dev->std_thread.stopped) {
+		kthread_stop(dev->std_thread.thread);
+		dev->std_thread.thread = NULL;
+	}
+
 	/* free stuff */
 	saa7134_pgtable_free(dev->pci, &dev->pt_cap);
 	saa7134_pgtable_free(dev->pci, &dev->pt_vbi);
@@ -2369,6 +2389,107 @@ int saa7134_video_init2(struct saa7134_dev *dev)
 	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
 	saa7134_tvaudio_setmute(dev);
 	saa7134_tvaudio_setvolume(dev,dev->ctl_volume);
+
+	dev->std_thread.thread = NULL;
+	dev->std_thread.stopped = 0;
+	atomic_set(&dev->std_thread.scan1, 0);
+	atomic_set(&dev->std_thread.scan2, 0);
+
+	dev->std_thread.thread = kthread_run(saa7134_standard_detector_thread,
+			dev, "%s", dev->name);
+	if (IS_ERR(dev->std_thread.thread)) {
+		dev_alert(dev->v4l2_dev.dev, "%s: kthread_run(saa7134_standard_detector_thread) failed\n",
+				dev->name);
+		dev->std_thread.thread = NULL;
+		dev->std_thread.stopped = 1;
+	}
+	return 0;
+}
+
+static const char *saa7134_std_to_str(v4l2_std_id std)
+{
+	switch (std) {
+	case V4L2_STD_NTSC:
+		return "NTSC";
+	case V4L2_STD_PAL:
+		return "PAL";
+	case V4L2_STD_SECAM:
+		return "SECAM";
+	default:
+		return "(no signal)";
+	}
+}
+
+static int saa7134_std_sleep(struct saa7134_dev *dev, int timeout)
+{
+	int cmp = (atomic_read(&dev->std_thread.scan1)
+			== atomic_read(&dev->std_thread.scan2));
+
+	if (cmp && !kthread_should_stop()) {
+		if (timeout < 0) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+		} else {
+			schedule_timeout_interruptible(
+					msecs_to_jiffies(timeout));
+		}
+	}
+	cmp = (atomic_read(&dev->std_thread.scan1)
+			!= atomic_read(&dev->std_thread.scan2));
+	return cmp;
+}
+
+static int saa7134_standard_detector_thread(void *arg)
+{
+	struct saa7134_dev *dev = arg;
+	v4l2_std_id dcstd = 0;
+	struct v4l2_event event;
+	static const int detect_time = 10; /* msec */
+	static const int max_detect_time = 2000; /* msec */
+	int time_spent = 0;
+
+	set_freezable();
+	for (;;) {
+		saa7134_std_sleep(dev, -1);
+restart:
+		if (kthread_should_stop())
+			goto done;
+		try_to_freeze();
+
+		atomic_set(&dev->std_thread.scan1,
+				atomic_read(&dev->std_thread.scan2));
+
+		if (saa7134_std_sleep(dev, detect_time)) {
+			time_spent = 0;
+			goto restart;
+		}
+		time_spent += detect_time;
+		dcstd = saa7134_read_std(dev);
+		if (dcstd == V4L2_STD_ALL && time_spent < max_detect_time)
+			goto restart;
+
+		dprintk("Standard detected in %d msecs: %s\n", time_spent,
+				saa7134_std_to_str(dcstd));
+		time_spent = 0;
+
+		memset(&event, 0, sizeof(event));
+		event.type = V4L2_EVENT_SIGNALCHANGED;
+		memcpy(event.u.data, &dcstd, sizeof(dcstd));
+		v4l2_event_queue(dev->video_dev, &event);
+	}
+
+done:
+	dev->std_thread.stopped = 1;
+	return 0;
+}
+
+static int saa7134_std_do_scan(struct saa7134_dev *dev)
+{
+	if (dev->std_thread.thread) {
+		atomic_inc(&dev->std_thread.scan2);
+		if (!dev->insuspend && !dev->std_thread.stopped)
+			wake_up_process(dev->std_thread.thread);
+	}
 	return 0;
 }
 
@@ -2403,6 +2524,8 @@ void saa7134_irq_video_signalchange(struct saa7134_dev *dev)
 
 	if (dev->mops && dev->mops->signal_change)
 		dev->mops->signal_change(dev);
+
+	saa7134_std_do_scan(dev);
 }
 
 
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 9c2249b..2dac74a 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -342,6 +342,8 @@ struct saa7134_card_ir {
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
 
+#define SAA7134_EVENTS_QUEUE_SIZE 10
+
 /* ----------------------------------------------------------- */
 /* Since we support 2 remote types, lets tell them apart       */
 
@@ -450,6 +452,14 @@ struct saa7134_thread {
 	unsigned int		   stopped;
 };
 
+/* tv standard thread status */
+struct saa7134_thread_std {
+	struct task_struct             *thread;
+	atomic_t                       scan1;
+	atomic_t                       scan2;
+	unsigned int                   stopped;
+};
+
 /* buffer for one video/vbi/ts frame */
 struct saa7134_buf {
 	/* common v4l buffer stuff -- must be first */
@@ -624,6 +634,7 @@ struct saa7134_dev {
 	/* other global state info */
 	unsigned int               automute;
 	struct saa7134_thread      thread;
+	struct saa7134_thread_std  std_thread;
 	struct saa7134_input       *input;
 	struct saa7134_input       *hw_input;
 	unsigned int               hw_mute;
-- 
1.8.5.3



