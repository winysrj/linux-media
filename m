Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2958 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2GEK0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 06:26:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/6] radio-cadet: implement frequency band enumeration.
Date: Thu,  5 Jul 2012 12:25:33 +0200
Message-Id: <0bbc202fa6e51396937574c2b81ad91b74d47c5c.1341483687.git.hans.verkuil@cisco.com>
In-Reply-To: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
References: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9f434bb4733245d7342b1547f65e40dae1603cd5.1341483687.git.hans.verkuil@cisco.com>
References: <9f434bb4733245d7342b1547f65e40dae1603cd5.1341483687.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-cadet.c |  129 +++++++++++++++++++++----------------
 1 file changed, 72 insertions(+), 57 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index d1fb427..18b8c71 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -66,7 +66,8 @@ struct cadet {
 	struct video_device vdev;
 	struct v4l2_ctrl_handler ctrl_handler;
 	int io;
-	int curtuner;
+	bool is_fm_band;
+	u32 curfreq;
 	int tunestat;
 	int sigstrength;
 	wait_queue_head_t read_queue;
@@ -84,9 +85,9 @@ static struct cadet cadet_card;
  * The V4L API spec does not define any particular unit for the signal
  * strength value.  These values are in microvolts of RF at the tuner's input.
  */
-static __u16 sigtable[2][4] = {
+static u16 sigtable[2][4] = {
+	{ 1835, 2621,  4128, 65535 },
 	{ 2185, 4369, 13107, 65535 },
-	{ 1835, 2621,  4128, 65535 }
 };
 
 
@@ -94,7 +95,7 @@ static int cadet_getstereo(struct cadet *dev)
 {
 	int ret = V4L2_TUNER_SUB_MONO;
 
-	if (dev->curtuner != 0)	/* Only FM has stereo capability! */
+	if (!dev->is_fm_band)	/* Only FM has stereo capability! */
 		return V4L2_TUNER_SUB_MONO;
 
 	outb(7, dev->io);          /* Select tuner control */
@@ -149,20 +150,18 @@ static unsigned cadet_getfreq(struct cadet *dev)
 	/*
 	 * Convert to actual frequency
 	 */
-	if (dev->curtuner == 0) {    /* FM */
-		test = 12500;
-		for (i = 0; i < 14; i++) {
-			if ((fifo & 0x01) != 0)
-				freq += test;
-			test = test << 1;
-			fifo = fifo >> 1;
-		}
-		freq -= 10700000;           /* IF frequency is 10.7 MHz */
-		freq = (freq * 16) / 1000;   /* Make it 1/16 kHz */
+	if (!dev->is_fm_band)    /* AM */
+		return ((fifo & 0x7fff) - 450) * 16;
+
+	test = 12500;
+	for (i = 0; i < 14; i++) {
+		if ((fifo & 0x01) != 0)
+			freq += test;
+		test = test << 1;
+		fifo = fifo >> 1;
 	}
-	if (dev->curtuner == 1)    /* AM */
-		freq = ((fifo & 0x7fff) - 2010) * 16;
-
+	freq -= 10700000;           /* IF frequency is 10.7 MHz */
+	freq = (freq * 16) / 1000;   /* Make it 1/16 kHz */
 	return freq;
 }
 
@@ -197,11 +196,12 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 	int i, j, test;
 	int curvol;
 
+	dev->curfreq = freq;
 	/*
 	 * Formulate a fifo command
 	 */
 	fifo = 0;
-	if (dev->curtuner == 0) {    /* FM */
+	if (dev->is_fm_band) {    /* FM */
 		test = 102400;
 		freq = freq / 16;       /* Make it kHz */
 		freq += 10700;               /* IF is 10700 kHz */
@@ -213,10 +213,9 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 			}
 			test = test >> 1;
 		}
-	}
-	if (dev->curtuner == 1) {    /* AM */
-		fifo = (freq / 16) + 2010;            /* Make it kHz */
-		fifo |= 0x100000;            /* Select AM Band */
+	} else {	/* AM */
+		fifo = (freq / 16) + 450;	/* Make it kHz */
+		fifo |= 0x100000;		/* Select AM Band */
 	}
 
 	/*
@@ -239,7 +238,7 @@ static void cadet_setfreq(struct cadet *dev, unsigned freq)
 
 		cadet_gettune(dev);
 		if ((dev->tunestat & 0x40) == 0) {   /* Tuned */
-			dev->sigstrength = sigtable[dev->curtuner][j];
+			dev->sigstrength = sigtable[dev->is_fm_band][j];
 			goto reset_rds;
 		}
 	}
@@ -338,39 +337,50 @@ static int vidioc_querycap(struct file *file, void *priv,
 	return 0;
 }
 
+static const struct v4l2_frequency_band bands[] = {
+	{
+		.index = 0,
+		.name = "AM MW",
+		.capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow = 8320,      /* 520 kHz */
+		.rangehigh = 26400,    /* 1650 kHz */
+	}, {
+		.index = 1,
+		.name = "FM",
+		.capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
+			V4L2_TUNER_CAP_RDS_BLOCK_IO | V4L2_TUNER_CAP_LOW |
+			V4L2_TUNER_CAP_FREQ_BANDS,
+		.rangelow = 1400000,   /* 87.5 MHz */
+		.rangehigh = 1728000,  /* 108.0 MHz */
+	},
+};
+
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
 	struct cadet *dev = video_drvdata(file);
 
+	if (v->index)
+		return -EINVAL;
 	v->type = V4L2_TUNER_RADIO;
-	switch (v->index) {
-	case 0:
-		strlcpy(v->name, "FM", sizeof(v->name));
-		v->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_RDS |
-			V4L2_TUNER_CAP_RDS_BLOCK_IO | V4L2_TUNER_CAP_LOW;
-		v->rangelow = 1400000;     /* 87.5 MHz */
-		v->rangehigh = 1728000;    /* 108.0 MHz */
+	strlcpy(v->name, "Radio", sizeof(v->name));
+	v->capability = bands[0].capability | bands[1].capability;
+	v->rangelow = bands[0].rangelow;	   /* 520 kHz (start of AM band) */
+	v->rangehigh = bands[1].rangehigh;    /* 108.0 MHz (end of FM band) */
+	if (dev->is_fm_band) {
 		v->rxsubchans = cadet_getstereo(dev);
-		v->audmode = V4L2_TUNER_MODE_STEREO;
 		outb(3, dev->io);
 		outb(inb(dev->io + 1) & 0x7f, dev->io + 1);
 		mdelay(100);
 		outb(3, dev->io);
 		if (inb(dev->io + 1) & 0x80)
 			v->rxsubchans |= V4L2_TUNER_SUB_RDS;
-		break;
-	case 1:
-		strlcpy(v->name, "AM", sizeof(v->name));
-		v->capability = V4L2_TUNER_CAP_LOW;
+	} else {
 		v->rangelow = 8320;      /* 520 kHz */
 		v->rangehigh = 26400;    /* 1650 kHz */
 		v->rxsubchans = V4L2_TUNER_SUB_MONO;
-		v->audmode = V4L2_TUNER_MODE_MONO;
-		break;
-	default:
-		return -EINVAL;
 	}
+	v->audmode = V4L2_TUNER_MODE_STEREO;
 	v->signal = dev->sigstrength; /* We might need to modify scaling of this */
 	return 0;
 }
@@ -378,8 +388,17 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
-	if (v->index != 0 && v->index != 1)
+	return v->index ? -EINVAL : 0;
+}
+
+static int vidioc_enum_freq_bands(struct file *file, void *priv,
+				struct v4l2_frequency_band *band)
+{
+	if (band->tuner)
+		return -EINVAL;
+	if (band->index >= ARRAY_SIZE(bands))
 		return -EINVAL;
+	*band = bands[band->index];
 	return 0;
 }
 
@@ -388,10 +407,10 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 {
 	struct cadet *dev = video_drvdata(file);
 
-	if (f->tuner > 1)
+	if (f->tuner)
 		return -EINVAL;
 	f->type = V4L2_TUNER_RADIO;
-	f->frequency = cadet_getfreq(dev);
+	f->frequency = dev->curfreq;
 	return 0;
 }
 
@@ -401,20 +420,12 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 {
 	struct cadet *dev = video_drvdata(file);
 
-	if (f->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
-	if (f->tuner == 0) {
-		if (f->frequency < 1400000)
-			f->frequency = 1400000;
-		else if (f->frequency > 1728000)
-			f->frequency = 1728000;
-	} else if (f->tuner == 1) {
-		if (f->frequency < 8320)
-			f->frequency = 8320;
-		else if (f->frequency > 26400)
-			f->frequency = 26400;
-	} else
+	if (f->tuner)
 		return -EINVAL;
+	dev->is_fm_band =
+		f->frequency >= (bands[0].rangehigh + bands[1].rangelow) / 2;
+	clamp(f->frequency, bands[dev->is_fm_band].rangelow,
+			    bands[dev->is_fm_band].rangehigh);
 	cadet_setfreq(dev, f->frequency);
 	return 0;
 }
@@ -499,6 +510,7 @@ static const struct v4l2_ioctl_ops cadet_ioctl_ops = {
 	.vidioc_s_tuner     = vidioc_s_tuner,
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
+	.vidioc_enum_freq_bands = vidioc_enum_freq_bands,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
@@ -555,8 +567,8 @@ static void cadet_probe(struct cadet *dev)
 	for (i = 0; i < 8; i++) {
 		dev->io = iovals[i];
 		if (request_region(dev->io, 2, "cadet-probe")) {
-			cadet_setfreq(dev, 1410);
-			if (cadet_getfreq(dev) == 1410) {
+			cadet_setfreq(dev, bands[1].rangelow);
+			if (cadet_getfreq(dev) == bands[1].rangelow) {
 				release_region(dev->io, 2);
 				return;
 			}
@@ -619,6 +631,9 @@ static int __init cadet_init(void)
 		goto err_hdl;
 	}
 
+	dev->is_fm_band = true;
+	dev->curfreq = bands[dev->is_fm_band].rangelow;
+	cadet_setfreq(dev, dev->curfreq);
 	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
 	dev->vdev.v4l2_dev = v4l2_dev;
 	dev->vdev.fops = &cadet_fops;
-- 
1.7.10

