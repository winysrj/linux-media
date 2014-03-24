Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.comexp.ru ([78.110.60.213]:48567 "EHLO mail.comexp.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbaCXMmi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 08:42:38 -0400
Message-ID: <1395661349.2916.3.camel@localhost.localdomain>
Subject: [PATCH] saa7134: automatic norm detection
From: Mikhail Domrachev <mihail.domrychev@comexp.ru>
To: linux-media@vger.kernel.org
Cc: =?koi8-r?Q?=E1=CC=C5=CB=D3=C5=CA_?=
	 =?koi8-r?Q?=E9=C7=CF=CE=C9=CE?= <aleksey.igonin@comexp.ru>
Date: Mon, 24 Mar 2014 15:42:29 +0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

saa7134: automatic norm detection switched on
saa7134: vidioc_querystd added
saa7134: notification about TV norm changes via V4L2 event interface added
videodev2: new event type added

Signed-off-by: Mikhail Domrachev <mihail.domrychev@comexp.ru>

---
 drivers/media/pci/saa7134/saa7134-empress.c |   1 +
 drivers/media/pci/saa7134/saa7134-reg.h     |   7 +
 drivers/media/pci/saa7134/saa7134-tvaudio.c |  56 +++---
 drivers/media/pci/saa7134/saa7134-video.c   | 274 ++++++++++++++++++++++++++--
 drivers/media/pci/saa7134/saa7134.h         |  14 +-
 include/uapi/linux/videodev2.h              |   2 +
 6 files changed, 311 insertions(+), 43 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 0a9047e..a150deb 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -262,6 +262,7 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_s_input			= saa7134_s_input,
 	.vidioc_s_std			= saa7134_s_std,
 	.vidioc_g_std			= saa7134_g_std,
+	.vidioc_querystd		= saa7134_querystd,
 	.vidioc_log_status		= v4l2_ctrl_log_status,
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
diff --git a/drivers/media/pci/saa7134/saa7134-reg.h b/drivers/media/pci/saa7134/saa7134-reg.h
index e7e0af1..d3be05c 100644
--- a/drivers/media/pci/saa7134/saa7134-reg.h
+++ b/drivers/media/pci/saa7134/saa7134-reg.h
@@ -369,6 +369,13 @@
 #define SAA7135_DSP_RWCLEAR_RERR		    1
 
 #define SAA7133_I2S_AUDIO_CONTROL               0x591
+
+#define SAA7134_STDDETECT_AUFD                  (1 << 7)
+#define SAA7134_STDDETECT_FCTC                  (1 << 2)
+#define SAA7134_STDDETECT_LDEL                  (1 << 5)
+#define SAA7134_STDDETECT_AUTO0                 (1 << 1)
+#define SAA7134_STDDETECT_AUTO1                 (1 << 2)
+
 /* ------------------------------------------------------------------ */
 /*
  * Local variables:
diff --git a/drivers/media/pci/saa7134/saa7134-tvaudio.c b/drivers/media/pci/saa7134/saa7134-tvaudio.c
index 0f34e09..6380e49 100644
--- a/drivers/media/pci/saa7134/saa7134-tvaudio.c
+++ b/drivers/media/pci/saa7134/saa7134-tvaudio.c
@@ -315,7 +315,7 @@ static void tvaudio_setmode(struct saa7134_dev *dev,
 
 static int tvaudio_sleep(struct saa7134_dev *dev, int timeout)
 {
-	if (dev->thread.scan1 == dev->thread.scan2 &&
+	if (dev->audio_thread.scan1 == dev->audio_thread.scan2 &&
 	    !kthread_should_stop()) {
 		if (timeout < 0) {
 			set_current_state(TASK_INTERRUPTIBLE);
@@ -325,7 +325,7 @@ static int tvaudio_sleep(struct saa7134_dev *dev, int timeout)
 						(msecs_to_jiffies(timeout));
 		}
 	}
-	return dev->thread.scan1 != dev->thread.scan2;
+	return dev->audio_thread.scan1 != dev->audio_thread.scan2;
 }
 
 static int tvaudio_checkcarrier(struct saa7134_dev *dev, struct mainscan *scan)
@@ -488,8 +488,8 @@ static int tvaudio_thread(void *data)
 	restart:
 		try_to_freeze();
 
-		dev->thread.scan1 = dev->thread.scan2;
-		dprintk("tvaudio thread scan start [%d]\n",dev->thread.scan1);
+		dev->audio_thread.scan1 = dev->audio_thread.scan2;
+		dprintk("tvaudio thread scan start [%d]\n",dev->audio_thread.scan1);
 		dev->tvaudio  = NULL;
 
 		saa_writeb(SAA7134_MONITOR_SELECT,   0xa0);
@@ -528,7 +528,7 @@ static int tvaudio_thread(void *data)
 			tvaudio_setmode(dev,&tvaudio[0],NULL);
 			for (i = 0; i < ARRAY_SIZE(mainscan); i++) {
 				carr_vals[i] = tvaudio_checkcarrier(dev, mainscan+i);
-				if (dev->thread.scan1 != dev->thread.scan2)
+				if (dev->audio_thread.scan1 != dev->audio_thread.scan2)
 					goto restart;
 			}
 			for (max1 = 0, max2 = 0, i = 0; i < ARRAY_SIZE(mainscan); i++) {
@@ -604,11 +604,11 @@ static int tvaudio_thread(void *data)
 				goto restart;
 			if (kthread_should_stop())
 				break;
-			if (UNSET == dev->thread.mode) {
+			if (UNSET == dev->audio_thread.mode) {
 				rx = tvaudio_getstereo(dev, &tvaudio[audio]);
 				mode = saa7134_tvaudio_rx2mode(rx);
 			} else {
-				mode = dev->thread.mode;
+				mode = dev->audio_thread.mode;
 			}
 			if (lastmode != mode) {
 				tvaudio_setstereo(dev,&tvaudio[audio],mode);
@@ -618,7 +618,7 @@ static int tvaudio_thread(void *data)
 	}
 
  done:
-	dev->thread.stopped = 1;
+	dev->audio_thread.stopped = 1;
 	return 0;
 }
 
@@ -785,8 +785,8 @@ static int tvaudio_thread_ddep(void *data)
 	restart:
 		try_to_freeze();
 
-		dev->thread.scan1 = dev->thread.scan2;
-		dprintk("tvaudio thread scan start [%d]\n",dev->thread.scan1);
+		dev->audio_thread.scan1 = dev->audio_thread.scan2;
+		dprintk("tvaudio thread scan start [%d]\n",dev->audio_thread.scan1);
 
 		if (audio_ddep >= 0x04 && audio_ddep <= 0x0e) {
 			/* insmod option override */
@@ -803,16 +803,18 @@ static int tvaudio_thread_ddep(void *data)
 			}
 		} else {
 			/* (let chip) scan for sound carrier */
+			v4l2_std_id id = dev->tvnorm->id;
 			norms = 0;
-			if (dev->tvnorm->id & (V4L2_STD_B | V4L2_STD_GH))
+
+			if (id & (V4L2_STD_B | V4L2_STD_GH))
 				norms |= 0x04;
-			if (dev->tvnorm->id & V4L2_STD_PAL_I)
+			if (id & V4L2_STD_PAL_I)
 				norms |= 0x20;
-			if (dev->tvnorm->id & V4L2_STD_DK)
+			if (id & V4L2_STD_DK)
 				norms |= 0x08;
-			if (dev->tvnorm->id & V4L2_STD_MN)
+			if (id & V4L2_STD_MN)
 				norms |= 0x40;
-			if (dev->tvnorm->id & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))
+			if (id & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))
 				norms |= 0x10;
 			if (0 == norms)
 				norms = 0x7c; /* all */
@@ -862,7 +864,7 @@ static int tvaudio_thread_ddep(void *data)
 	}
 
  done:
-	dev->thread.stopped = 1;
+	dev->audio_thread.stopped = 1;
 	return 0;
 }
 
@@ -1024,13 +1026,13 @@ int saa7134_tvaudio_init2(struct saa7134_dev *dev)
 		break;
 	}
 
-	dev->thread.thread = NULL;
-	dev->thread.scan1 = dev->thread.scan2 = 0;
+	dev->audio_thread.thread = NULL;
+	dev->audio_thread.scan1 = dev->audio_thread.scan2 = 0;
 	if (my_thread) {
 		saa7134_tvaudio_init(dev);
 		/* start tvaudio thread */
-		dev->thread.thread = kthread_run(my_thread, dev, "%s", dev->name);
-		if (IS_ERR(dev->thread.thread)) {
+		dev->audio_thread.thread = kthread_run(my_thread, dev, "%s", dev->name);
+		if (IS_ERR(dev->audio_thread.thread)) {
 			printk(KERN_WARNING "%s: kernel_thread() failed\n",
 			       dev->name);
 			/* XXX: missing error handling here */
@@ -1051,8 +1053,8 @@ int saa7134_tvaudio_close(struct saa7134_dev *dev)
 int saa7134_tvaudio_fini(struct saa7134_dev *dev)
 {
 	/* shutdown tvaudio thread */
-	if (dev->thread.thread && !dev->thread.stopped)
-		kthread_stop(dev->thread.thread);
+	if (dev->audio_thread.thread && !dev->audio_thread.stopped)
+		kthread_stop(dev->audio_thread.thread);
 
 	saa_andorb(SAA7134_ANALOG_IO_SELECT, 0x07, 0x00); /* LINE1 */
 	return 0;
@@ -1064,12 +1066,12 @@ int saa7134_tvaudio_do_scan(struct saa7134_dev *dev)
 		dprintk("sound IF not in use, skipping scan\n");
 		dev->automute = 0;
 		saa7134_tvaudio_setmute(dev);
-	} else if (dev->thread.thread) {
-		dev->thread.mode = UNSET;
-		dev->thread.scan2++;
+	} else if (dev->audio_thread.thread) {
+		dev->audio_thread.mode = UNSET;
+		dev->audio_thread.scan2++;
 
-		if (!dev->insuspend && !dev->thread.stopped)
-			wake_up_process(dev->thread.thread);
+		if (!dev->insuspend && !dev->audio_thread.stopped)
+			wake_up_process(dev->audio_thread.thread);
 	} else {
 		dev->automute = 0;
 		saa7134_tvaudio_setmute(dev);
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index eb472b5..2528b6d 100644
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
 
@@ -452,19 +455,28 @@ static void video_mux(struct saa7134_dev *dev, int input)
 
 static void saa7134_set_decoder(struct saa7134_dev *dev)
 {
-	int luma_control, sync_control, mux;
+	int luma_control, sync_control, chroma_ctrl1, analog_adc, vgate_misc, mux;
 
 	struct saa7134_tvnorm *norm = dev->tvnorm;
 	mux = card_in(dev, dev->ctl_input).vmux;
 
 	luma_control = norm->luma_control;
 	sync_control = norm->sync_control;
+	chroma_ctrl1 = norm->chroma_ctrl1;
+	analog_adc = 0x01;
+	vgate_misc = norm->vgate_misc;
 
 	if (mux > 5)
 		luma_control |= 0x80; /* svideo */
 	if (noninterlaced || dev->nosignal)
 		sync_control |= 0x20;
 
+	/* switch on auto standard detection */
+	sync_control |= SAA7134_STDDETECT_AUFD;
+	chroma_ctrl1 |= SAA7134_STDDETECT_AUTO0;
+	chroma_ctrl1 &= ~SAA7134_STDDETECT_FCTC;
+	luma_control &= ~SAA7134_STDDETECT_LDEL;
+
 	/* setup video decoder */
 	saa_writeb(SAA7134_INCR_DELAY,            0x08);
 	saa_writeb(SAA7134_ANALOG_IN_CTRL1,       0xc0 | mux);
@@ -487,16 +499,16 @@ static void saa7134_set_decoder(struct saa7134_dev *dev)
 		dev->ctl_invert ? -dev->ctl_saturation : dev->ctl_saturation);
 
 	saa_writeb(SAA7134_DEC_CHROMA_HUE,        dev->ctl_hue);
-	saa_writeb(SAA7134_CHROMA_CTRL1,          norm->chroma_ctrl1);
+	saa_writeb(SAA7134_CHROMA_CTRL1,          chroma_ctrl1);
 	saa_writeb(SAA7134_CHROMA_GAIN,           norm->chroma_gain);
 
 	saa_writeb(SAA7134_CHROMA_CTRL2,          norm->chroma_ctrl2);
 	saa_writeb(SAA7134_MODE_DELAY_CTRL,       0x00);
 
-	saa_writeb(SAA7134_ANALOG_ADC,            0x01);
+	saa_writeb(SAA7134_ANALOG_ADC,            analog_adc);
 	saa_writeb(SAA7134_VGATE_START,           0x11);
 	saa_writeb(SAA7134_VGATE_STOP,            0xfe);
-	saa_writeb(SAA7134_MISC_VGATE_MSB,        norm->vgate_misc);
+	saa_writeb(SAA7134_MISC_VGATE_MSB,        vgate_misc);
 	saa_writeb(SAA7134_RAW_DATA_GAIN,         0x40);
 	saa_writeb(SAA7134_RAW_DATA_OFFSET,       0x80);
 }
@@ -1686,6 +1698,98 @@ int saa7134_g_std(struct file *file, void *priv, v4l2_std_id *id)
 }
 EXPORT_SYMBOL_GPL(saa7134_g_std);
 
+static v4l2_std_id saa7134_read_std(struct saa7134_dev* dev)
+{
+    static v4l2_std_id stds[] = { V4L2_STD_ALL, V4L2_STD_NTSC, V4L2_STD_PAL, V4L2_STD_SECAM };
+    v4l2_std_id result = 0;
+
+    u8 st1 = saa_readb(SAA7134_STATUS_VIDEO1);
+    u8 st2 = saa_readb(SAA7134_STATUS_VIDEO2);
+
+    if (!(st2 & 0x1)) //RDCAP == 0
+        result = V4L2_STD_ALL;
+    else
+        result = stds[st1 & 0x03];
+
+    return result;
+}
+
+static const char* saa7134_std_to_str(v4l2_std_id std)
+{
+    switch (std) {
+    case V4L2_STD_NTSC:
+        return "NTSC";
+    case V4L2_STD_PAL:
+        return "PAL";
+    case V4L2_STD_SECAM:
+        return "SECAM";
+    default:
+        return "(no signal)";
+    }
+}
+
+int saa7134_querystd(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct saa7134_dev *dev = video_drvdata(file);
+
+	v4l2_std_id dcstd = saa7134_read_std(dev);
+	if (dcstd != V4L2_STD_ALL)
+	    *std &= dcstd;
+	else
+	    *std = dcstd;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(saa7134_querystd);
+
+static int saa7134_std_sleep(struct saa7134_dev *dev, int timeout)
+{
+    int cmp = (atomic_read(&dev->std_thread.scan1) == atomic_read(&dev->std_thread.scan2));
+
+    if (cmp && !kthread_should_stop()) {
+        if (timeout < 0) {
+            set_current_state(TASK_INTERRUPTIBLE);
+            schedule();
+        } else {
+            schedule_timeout_interruptible(msecs_to_jiffies(timeout));
+        }
+    }
+    cmp = (atomic_read(&dev->std_thread.scan1) != atomic_read(&dev->std_thread.scan2));
+    return cmp;
+}
+
+static int saa7134_standard_detector_thread(void* arg)
+{
+    struct saa7134_dev *dev = arg;
+    v4l2_std_id dcstd = 0;
+    struct v4l2_event event;
+
+    set_freezable();
+    for (;;) {
+        saa7134_std_sleep(dev,-1);
+        if (kthread_should_stop())
+            goto done;
+restart:
+        try_to_freeze();
+
+        atomic_set(&dev->std_thread.scan1, atomic_read(&dev->std_thread.scan2));
+
+        if (saa7134_std_sleep(dev,3000))
+            goto restart;
+        dcstd = saa7134_read_std(dev);
+
+        dprintk("Standard detected: %s", saa7134_std_to_str(dcstd));
+        memset(&event, 0, sizeof(event));
+        event.type = V4L2_EVENT_SIGNALCHANGED;
+        memcpy(event.u.data, &dcstd, sizeof(dcstd));
+        v4l2_event_queue(dev->video_dev, &event);
+    }
+
+done:
+    dev->std_thread.stopped = 1;
+    return 0;
+}
+
 static int saa7134_cropcap(struct file *file, void *priv,
 					struct v4l2_cropcap *cap)
 {
@@ -1793,13 +1897,13 @@ int saa7134_s_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
-	mode = dev->thread.mode;
+	mode = dev->audio_thread.mode;
 	if (UNSET == mode) {
 		rx   = saa7134_tvaudio_getstereo(dev);
 		mode = saa7134_tvaudio_rx2mode(rx);
 	}
 	if (mode != t->audmode)
-		dev->thread.mode = t->audmode;
+		dev->audio_thread.mode = t->audmode;
 
 	return 0;
 }
@@ -2053,6 +2157,18 @@ static int radio_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
+static int saa7134_subscribe_event(struct v4l2_fh *fh, const struct v4l2_event_subscription *sub)
+{
+	if (sub->type == V4L2_EVENT_SIGNALCHANGED)
+	{
+		return v4l2_event_subscribe(fh, sub, SAA7134_EVENTS_QUEUE_SIZE, NULL);
+	}
+	else
+	{
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	}
+}
+
 static const struct v4l2_file_operations video_fops =
 {
 	.owner	  = THIS_MODULE,
@@ -2084,6 +2200,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_dqbuf			= saa7134_dqbuf,
 	.vidioc_s_std			= saa7134_s_std,
 	.vidioc_g_std			= saa7134_g_std,
+	.vidioc_querystd		= saa7134_querystd,
 	.vidioc_enum_input		= saa7134_enum_input,
 	.vidioc_g_input			= saa7134_g_input,
 	.vidioc_s_input			= saa7134_s_input,
@@ -2103,7 +2220,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_register              = vidioc_s_register,
 #endif
 	.vidioc_log_status		= v4l2_ctrl_log_status,
-	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event		= saa7134_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
@@ -2272,6 +2389,9 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 
 void saa7134_video_fini(struct saa7134_dev *dev)
 {
+    if (dev->std_thread.thread && !dev->std_thread.stopped)
+        kthread_stop(dev->std_thread.thread);
+
 	/* free stuff */
 	saa7134_pgtable_free(dev->pci, &dev->pt_cap);
 	saa7134_pgtable_free(dev->pci, &dev->pt_vbi);
@@ -2324,23 +2444,144 @@ int saa7134_video_init2(struct saa7134_dev *dev)
 	v4l2_ctrl_handler_setup(&dev->ctrl_handler);
 	saa7134_tvaudio_setmute(dev);
 	saa7134_tvaudio_setvolume(dev,dev->ctl_volume);
+
+
+    dev->std_thread.thread = NULL;
+    dev->std_thread.stopped = 0;
+    atomic_set(&dev->std_thread.scan1, 0);
+    atomic_set(&dev->std_thread.scan2, 0);
+
+    dev->std_thread.thread = kthread_run(saa7134_standard_detector_thread, dev, "%s", dev->name);
+    if (IS_ERR(dev->std_thread.thread)) {
+        printk(KERN_ALERT "%s: kthread_run(saa7134_standard_detector_thread) failed\n", dev->name);
+        dev->std_thread.thread = NULL;
+        dev->std_thread.stopped = 1;
+    }
+    return 0;
+}
+
+static int saa7134_std_do_scan(struct saa7134_dev *dev)
+{
+    if (dev->std_thread.thread) {
+        atomic_inc(&dev->std_thread.scan2);
+        if (!dev->insuspend && !dev->std_thread.stopped)
+            wake_up_process(dev->std_thread.thread);
+    }
 	return 0;
 }
 
 void saa7134_irq_video_signalchange(struct saa7134_dev *dev)
 {
-	static const char *st[] = {
-		"(no signal)", "NTSC", "PAL", "SECAM" };
-	u32 st1,st2;
+	static const char* st1_6_hlck[] =
+	{
+	[0] = "HPLL is locked; clock LLC is locked to line frequency",
+	[1] = "HPLL is not locked"
+	};
+	static const char* st1_5_sltca[] =
+	{
+	[0] = "Video AGC is in normal operation mode",
+	[1] = "Video AGC is in gain recover mode (increase) after peak attack"
+	};
+	static const char* st1_4_glimt[] =
+	{
+	[0] = "Video AGC is in normal operation mode",
+	[1] = "Video AGC is on its top limit, i.e. input signal is too large, out of AGC range"
+	};
+	static const char* st1_3_glimb[] =
+	{
+	[0] = "video AGC is in normal operation mode",
+	[1] = "video AGC is on its bottom limit. Input signal is too small, out of AGC range"
+	};
+	static const char* st1_2_wipa[] =
+	{
+	[0] = "White or Color Peak Control loop is not activated",
+	[1] = "White or Color Peak Control was triggered in previous line"
+	};
+	struct st1_1_0_dcstd_descr
+	{
+		const char* name;
+		v4l2_std_id stdid;
+	};
+	static struct st1_1_0_dcstd_descr st1_1_0_dcstd[] =
+	{
+	[0] = { "No color signal could be detected. The video is assumed being B/W", V4L2_STD_UNKNOWN},
+	[1] = { "NTSC signal detected", V4L2_STD_NTSC},
+	[2] = { "PAL signal detected", V4L2_STD_PAL},
+	[3] = { "SECAM signal detected", V4L2_STD_SECAM}
+	};
+	static const char* st2_7_intl[] =
+	{
+	[0] = "Video input is detected as non-interlaced",
+	[1] = "Video input is detected as interlaced"
+	};
+	static const char* st2_6_hlvln[] =
+	{
+	[0] = "Horizontal and vertical synchronization is achieved",
+	[1] = "Either horizontal or vertical synchronization is lost"
+	};
+	static const char* st2_5_fidt[] =
+	{
+	[0] = "Video input is detected with 50 Hz field rate",
+	[1] = "Video input is detected with 60 Hz field rate"
+	};
+	static const char* st2_3_type3[] =
+	{
+	[0] = "normal video signal",
+	[1] = "Macrovision copy protection type 3 detected"
+	};
+	static const char* st2_2_colstr[] =
+	{
+	[0] = "normal video signal",
+	[1] = "Macrovision Color Stripe scheme detected"
+	};
+	static const char* st2_1_copro[] =
+	{
+	[0] = "normal video signal, No Macrovision copy protection scheme detected",
+	[1] = "Copy protection detected according Macrovision (including 7.01)"
+	};
+	static const char* st2_0_rdcap[] =
+	{
+	[0] = "One or more of the decoder control loops are not locked",
+	[1] = "Ready for capture. All control loops are locked: Horizontal, Vertical, color subcarrier, chroma gain control"
+	};
+
+	u8 st1,st2;
 
 	st1 = saa_readb(SAA7134_STATUS_VIDEO1);
 	st2 = saa_readb(SAA7134_STATUS_VIDEO2);
-	dprintk("DCSDT: pll: %s, sync: %s, norm: %s\n",
-		(st1 & 0x40) ? "not locked" : "locked",
-		(st2 & 0x40) ? "no"         : "yes",
-		st[st1 & 0x03]);
-	dev->nosignal = (st1 & 0x40) || (st2 & 0x40)  || !(st2 & 0x1);
 
+	dprintk("saa7134: DEBUG. Status byte 1:\n"
+			"HLCK  = %s\n"
+			"SLTCA = %s\n"
+			"GLIMT = %s\n"
+			"GLIMB = %s\n"
+			"WIPA  = %s\n"
+			"DCSTD = %s\n",
+			st1_6_hlck[((st1 & (1 << 6)) ? 1 : 0)],
+			st1_5_sltca[((st1 & (1 << 5)) ? 1 : 0)],
+			st1_4_glimt[((st1 & (1 << 4)) ? 1 : 0)],
+			st1_3_glimb[((st1 & (1 << 3)) ? 1 : 0)],
+			st1_2_wipa[((st1 & (1 << 2)) ? 1 : 0)],
+			st1_1_0_dcstd[st1 & 0x03].name
+			);
+	dprintk("saa7134: DEBUG. Status byte 2:\n"
+			"INTL  = %s\n"
+			"HLVLN = %s\n"
+			"FIDT = %s\n"
+			"TYPE3 = %s\n"
+			"COLSTR  = %s\n"
+			"COPRO = %s\n"
+			"RDCAP = %s\n",
+			st2_7_intl[((st2 & (1 << 7)) ? 1 : 0)],
+			st2_6_hlvln[((st2 & (1 << 6)) ? 1 : 0)],
+			st2_5_fidt[((st2 & (1 << 5)) ? 1 : 0)],
+			st2_3_type3[((st2 & (1 << 3)) ? 1 : 0)],
+			st2_2_colstr[((st2 & (1 << 2)) ? 1 : 0)],
+			st2_1_copro[((st2 & (1 << 1)) ? 1 : 0)],
+			st2_0_rdcap[((st2 & (1 << 0)) ? 1 : 0)]
+			);
+
+	dev->nosignal = (st1 & 0x40) || (st2 & 0x40)  || !(st2 & 0x1);
 	if (dev->nosignal) {
 		/* no video signal -> mute audio */
 		if (dev->ctl_automute)
@@ -2358,6 +2599,8 @@ void saa7134_irq_video_signalchange(struct saa7134_dev *dev)
 
 	if (dev->mops && dev->mops->signal_change)
 		dev->mops->signal_change(dev);
+
+	saa7134_std_do_scan(dev);
 }
 

@@ -2393,6 +2636,7 @@ void saa7134_irq_video_done(struct saa7134_dev *dev, unsigned long status)
 	spin_unlock(&dev->slock);
 }
 
+
 /* ----------------------------------------------------------- */
 /*
  * Local variables:
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 2474e84..0e5bd3d 100644
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
+    struct task_struct             *thread;
+    atomic_t                       scan1;
+    atomic_t                       scan2;
+    unsigned int                   stopped;
+};
+
 /* buffer for one video/vbi/ts frame */
 struct saa7134_buf {
 	/* common v4l buffer stuff -- must be first */
@@ -623,7 +633,8 @@ struct saa7134_dev {
 
 	/* other global state info */
 	unsigned int               automute;
-	struct saa7134_thread      thread;
+	struct saa7134_thread      audio_thread;
+	struct saa7134_thread_std  std_thread;
 	struct saa7134_input       *input;
 	struct saa7134_input       *hw_input;
 	unsigned int               hw_mute;
@@ -779,6 +790,7 @@ extern struct video_device saa7134_radio_template;
 
 int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id);
 int saa7134_g_std(struct file *file, void *priv, v4l2_std_id *id);
+int saa7134_querystd(struct file *file, void *priv, v4l2_std_id *std);
 int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i);
 int saa7134_g_input(struct file *file, void *priv, unsigned int *i);
 int saa7134_s_input(struct file *file, void *priv, unsigned int i);
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index e35ad6c..806057b 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1765,8 +1765,10 @@ struct v4l2_streamparm {
 #define V4L2_EVENT_EOS				2
 #define V4L2_EVENT_CTRL				3
 #define V4L2_EVENT_FRAME_SYNC			4
+#define V4L2_EVENT_SIGNALCHANGED                5
 #define V4L2_EVENT_PRIVATE_START		0x08000000
 
+
 /* Payload for V4L2_EVENT_VSYNC */
 struct v4l2_event_vsync {
 	/* Can be V4L2_FIELD_ANY, _NONE, _TOP or _BOTTOM */
-- 
1.8.5.3




