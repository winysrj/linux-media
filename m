Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3871 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbaGUNqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:46:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Eduardo Valentin <edubezval@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/7] radio-miropcm20: add RDS support.
Date: Mon, 21 Jul 2014 15:45:43 +0200
Message-Id: <1405950343-26892-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
References: <1405950343-26892-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Once upon a time the radio-miropcm20 driver had RDS support. However, after
some internal kernel changes that support was removed. Now that we have a
nice RDS API I have been working on adding back this support. It has been
tested with the si4713 RDS transmitter and it is working quite nicely.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-miropcm20.c | 303 ++++++++++++++++++++++++++++++++--
 1 file changed, 286 insertions(+), 17 deletions(-)

diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 3d12edf..72df00e 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -1,20 +1,35 @@
-/* Miro PCM20 radio driver for Linux radio support
+/*
+ * Miro PCM20 radio driver for Linux radio support
  * (c) 1998 Ruurd Reitsma <R.A.Reitsma@wbmt.tudelft.nl>
  * Thanks to Norberto Pellici for the ACI device interface specification
  * The API part is based on the radiotrack driver by M. Kirkwood
  * This driver relies on the aci mixer provided by the snd-miro
  * ALSA driver.
  * Look there for further info...
- */
-
-/* What ever you think about the ACI, version 0x07 is not very well!
- * I can't get frequency, 'tuner status', 'tuner flags' or mute/mono
- * conditions...                Robert
+ *
+ * From the original miro RDS sources:
+ *
+ *  (c) 2001 Robert Siemer <Robert.Siemer@gmx.de>
+ *
+ *  Many thanks to Fred Seidel <seidel@metabox.de>, the
+ *  designer of the RDS decoder hardware. With his help
+ *  I was able to code this driver.
+ *  Thanks also to Norberto Pellicci, Dominic Mounteney
+ *  <DMounteney@pinnaclesys.com> and www.teleauskunft.de
+ *  for good hints on finding Fred. It was somewhat hard
+ *  to locate him here in Germany... [:
+ *
+ * This code has been reintroduced and converted to use
+ * the new V4L2 RDS API by:
+ *
+ * Hans Verkuil <hans.verkuil@cisco.com>
  */
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/delay.h>
 #include <linux/videodev2.h>
+#include <linux/kthread.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
@@ -22,6 +37,22 @@
 #include <media/v4l2-event.h>
 #include <sound/aci.h>
 
+#define RDS_DATASHIFT          2   /* Bit 2 */
+#define RDS_DATAMASK        (1 << RDS_DATASHIFT)
+#define RDS_BUSYMASK        0x10   /* Bit 4 */
+#define RDS_CLOCKMASK       0x08   /* Bit 3 */
+#define RDS_DATA(x)         (((x) >> RDS_DATASHIFT) & 1)
+
+#define RDS_STATUS      0x01
+#define RDS_STATIONNAME 0x02
+#define RDS_TEXT        0x03
+#define RDS_ALTFREQ     0x04
+#define RDS_TIMEDATE    0x05
+#define RDS_PI_CODE     0x06
+#define RDS_PTYTATP     0x07
+#define RDS_RESET       0x08
+#define RDS_RXVALUE     0x09
+
 static int radio_nr = -1;
 module_param(radio_nr, int, 0);
 MODULE_PARM_DESC(radio_nr, "Set radio device number (/dev/radioX).  Default: -1 (autodetect)");
@@ -30,6 +61,14 @@ struct pcm20 {
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
 	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl *rds_pty;
+	struct v4l2_ctrl *rds_ps_name;
+	struct v4l2_ctrl *rds_radio_test;
+	struct v4l2_ctrl *rds_ta;
+	struct v4l2_ctrl *rds_tp;
+	struct v4l2_ctrl *rds_ms;
+	/* thread for periodic RDS status checking */
+	struct task_struct *kthread;
 	unsigned long freq;
 	u32 audmode;
 	struct snd_miro_aci *aci;
@@ -41,6 +80,103 @@ static struct pcm20 pcm20_card = {
 	.audmode = V4L2_TUNER_MODE_STEREO,
 };
 
+
+static int rds_waitread(struct snd_miro_aci *aci)
+{
+	u8 byte;
+	int i = 2000;
+
+	do {
+		byte = inb(aci->aci_port + ACI_REG_RDS);
+		i--;
+	} while ((byte & RDS_BUSYMASK) && i);
+
+	/*
+	 * It's magic, but without this the data that you read later on
+	 * is unreliable and full of bit errors. With this 1 usec delay
+	 * everything is fine.
+	 */
+	udelay(1);
+	return i ? byte : -1;
+}
+
+static int rds_rawwrite(struct snd_miro_aci *aci, u8 byte)
+{
+	if (rds_waitread(aci) >= 0) {
+		outb(byte, aci->aci_port + ACI_REG_RDS);
+		return 0;
+	}
+	return -1;
+}
+
+static int rds_write(struct snd_miro_aci *aci, u8 byte)
+{
+	u8 sendbuffer[8];
+	int i;
+
+	for (i = 7; i >= 0; i--)
+		sendbuffer[7 - i] = (byte & (1 << i)) ? RDS_DATAMASK : 0;
+	sendbuffer[0] |= RDS_CLOCKMASK;
+
+	for (i = 0; i < 8; i++)
+		rds_rawwrite(aci, sendbuffer[i]);
+	return 0;
+}
+
+static int rds_readcycle_nowait(struct snd_miro_aci *aci)
+{
+	outb(0, aci->aci_port + ACI_REG_RDS);
+	return rds_waitread(aci);
+}
+
+static int rds_readcycle(struct snd_miro_aci *aci)
+{
+	if (rds_rawwrite(aci, 0) < 0)
+		return -1;
+	return rds_waitread(aci);
+}
+
+static int rds_ack(struct snd_miro_aci *aci)
+{
+	int i = rds_readcycle(aci);
+
+	if (i < 0)
+		return -1;
+	if (i & RDS_DATAMASK)
+		return 0;  /* ACK  */
+	return 1;  /* NACK */
+}
+
+static int rds_cmd(struct snd_miro_aci *aci, u8 cmd, u8 databuffer[], u8 datasize)
+{
+	int i, j;
+
+	rds_write(aci, cmd);
+
+	/* RDS_RESET doesn't need further processing */
+	if (cmd == RDS_RESET)
+		return 0;
+	if (rds_ack(aci))
+		return -EIO;
+	if (datasize == 0)
+		return 0;
+
+	/* to be able to use rds_readcycle_nowait()
+	   I have to waitread() here */
+	if (rds_waitread(aci) < 0)
+		return -1;
+
+	memset(databuffer, 0, datasize);
+
+	for (i = 0; i < 8 * datasize; i++) {
+		j = rds_readcycle_nowait(aci);
+		if (j < 0)
+			return -EIO;
+		databuffer[i / 8] |= RDS_DATA(j) << (7 - (i % 8));
+	}
+	return 0;
+}
+
 static int pcm20_setfreq(struct pcm20 *dev, unsigned long freq)
 {
 	unsigned char freql;
@@ -54,17 +190,10 @@ static int pcm20_setfreq(struct pcm20 *dev, unsigned long freq)
 	freql = freq & 0xff;
 	freqh = freq >> 8;
 
+	rds_cmd(aci, RDS_RESET, 0, 0);
 	return snd_aci_cmd(aci, ACI_WRITE_TUNE, freql, freqh);
 }
 
-static const struct v4l2_file_operations pcm20_fops = {
-	.owner		= THIS_MODULE,
-	.open		= v4l2_fh_open,
-	.poll		= v4l2_ctrl_poll,
-	.release	= v4l2_fh_release,
-	.unlocked_ioctl	= video_ioctl2,
-};
-
 static int vidioc_querycap(struct file *file, void *priv,
 				struct v4l2_capability *v)
 {
@@ -73,16 +202,31 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "Miro PCM20", sizeof(v->driver));
 	strlcpy(v->card, "Miro PCM20", sizeof(v->card));
 	snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", dev->v4l2_dev.name);
-	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO | V4L2_CAP_RDS_CAPTURE;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
+static bool sanitize(char *p, int size)
+{
+	int i;
+	bool ret = true;
+
+	for (i = 0; i < size; i++) {
+		if (p[i] < 32 || p[i] >= 128) {
+			p[i] = ' ';
+			ret = false;
+		}
+	}
+	return ret;
+}
+
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *v)
 {
 	struct pcm20 *dev = video_drvdata(file);
 	int res;
+	u8 buf;
 
 	if (v->index)
 		return -EINVAL;
@@ -97,8 +241,12 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	res = snd_aci_cmd(dev->aci, ACI_READ_TUNERSTEREO, -1, -1);
 	v->rxsubchans = (res & 0x40) ? V4L2_TUNER_SUB_MONO :
 					V4L2_TUNER_SUB_STEREO;
-	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
+	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
+			V4L2_TUNER_CAP_RDS | V4L2_TUNER_CAP_RDS_CONTROLS;
 	v->audmode = dev->audmode;
+	res = rds_cmd(dev->aci, RDS_RXVALUE, &buf, 1);
+	if (res >= 0 && buf)
+		v->rxsubchans |= V4L2_TUNER_SUB_RDS;
 	return 0;
 }
 
@@ -157,6 +305,115 @@ static int pcm20_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
+static int pcm20_thread(void *data)
+{
+	struct pcm20 *dev = data;
+	const unsigned no_rds_start_counter = 5;
+	const unsigned sleep_msecs = 2000;
+	unsigned no_rds_counter = no_rds_start_counter;
+
+	for (;;) {
+		char text_buffer[66];
+		u8 buf;
+		int res;
+
+		msleep_interruptible(sleep_msecs);
+
+		if (kthread_should_stop())
+			break;
+
+		res = rds_cmd(dev->aci, RDS_RXVALUE, &buf, 1);
+		if (res)
+			continue;
+		if (buf == 0) {
+			if (no_rds_counter == 0)
+				continue;
+			no_rds_counter--;
+			if (no_rds_counter)
+				continue;
+
+			/*
+			 * No RDS seen for no_rds_start_counter * sleep_msecs
+			 * milliseconds, clear all RDS controls to their
+			 * default values.
+			 */
+			v4l2_ctrl_s_ctrl_string(dev->rds_ps_name, "");
+			v4l2_ctrl_s_ctrl(dev->rds_ms, 1);
+			v4l2_ctrl_s_ctrl(dev->rds_ta, 0);
+			v4l2_ctrl_s_ctrl(dev->rds_tp, 0);
+			v4l2_ctrl_s_ctrl(dev->rds_pty, 0);
+			v4l2_ctrl_s_ctrl_string(dev->rds_radio_test, "");
+			continue;
+		}
+		no_rds_counter = no_rds_start_counter;
+
+		res = rds_cmd(dev->aci, RDS_STATUS, &buf, 1);
+		if (res)
+			continue;
+		if ((buf >> 3) & 1) {
+			res = rds_cmd(dev->aci, RDS_STATIONNAME, text_buffer, 8);
+			text_buffer[8] = 0;
+			if (!res && sanitize(text_buffer, 8))
+				v4l2_ctrl_s_ctrl_string(dev->rds_ps_name, text_buffer);
+		}
+		if ((buf >> 6) & 1) {
+			u8 pty;
+
+			res = rds_cmd(dev->aci, RDS_PTYTATP, &pty, 1);
+			if (!res) {
+				v4l2_ctrl_s_ctrl(dev->rds_ms, !!(pty & 0x01));
+				v4l2_ctrl_s_ctrl(dev->rds_ta, !!(pty & 0x02));
+				v4l2_ctrl_s_ctrl(dev->rds_tp, !!(pty & 0x80));
+				v4l2_ctrl_s_ctrl(dev->rds_pty, (pty >> 2) & 0x1f);
+			}
+		}
+		if ((buf >> 4) & 1) {
+			res = rds_cmd(dev->aci, RDS_TEXT, text_buffer, 65);
+			text_buffer[65] = 0;
+			if (!res && sanitize(text_buffer + 1, 64))
+				v4l2_ctrl_s_ctrl_string(dev->rds_radio_test, text_buffer + 1);
+		}
+	}
+	return 0;
+}
+
+static int pcm20_open(struct file *file)
+{
+	struct pcm20 *dev = video_drvdata(file);
+	int res = v4l2_fh_open(file);
+
+	if (!res && v4l2_fh_is_singular_file(file) &&
+	    IS_ERR_OR_NULL(dev->kthread)) {
+		dev->kthread = kthread_run(pcm20_thread, dev, "%s",
+					   dev->v4l2_dev.name);
+		if (IS_ERR(dev->kthread)) {
+			v4l2_err(&dev->v4l2_dev, "kernel_thread() failed\n");
+			v4l2_fh_release(file);
+			return PTR_ERR(dev->kthread);
+		}
+	}
+	return res;
+}
+
+static int pcm20_release(struct file *file)
+{
+	struct pcm20 *dev = video_drvdata(file);
+
+	if (v4l2_fh_is_singular_file(file) && !IS_ERR_OR_NULL(dev->kthread)) {
+		kthread_stop(dev->kthread);
+		dev->kthread = NULL;
+	}
+	return v4l2_fh_release(file);
+}
+
+static const struct v4l2_file_operations pcm20_fops = {
+	.owner		= THIS_MODULE,
+	.open		= pcm20_open,
+	.poll		= v4l2_ctrl_poll,
+	.release	= pcm20_release,
+	.unlocked_ioctl	= video_ioctl2,
+};
+
 static const struct v4l2_ioctl_ops pcm20_ioctl_ops = {
 	.vidioc_querycap    = vidioc_querycap,
 	.vidioc_g_tuner     = vidioc_g_tuner,
@@ -195,9 +452,21 @@ static int __init pcm20_init(void)
 	}
 
 	hdl = &dev->ctrl_handler;
-	v4l2_ctrl_handler_init(hdl, 1);
+	v4l2_ctrl_handler_init(hdl, 7);
 	v4l2_ctrl_new_std(hdl, &pcm20_ctrl_ops,
 			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
+	dev->rds_pty = v4l2_ctrl_new_std(hdl, NULL,
+			V4L2_CID_RDS_RX_PTY, 0, 0x1f, 1, 0);
+	dev->rds_ps_name = v4l2_ctrl_new_std(hdl, NULL,
+			V4L2_CID_RDS_RX_PS_NAME, 0, 8, 8, 0);
+	dev->rds_radio_test = v4l2_ctrl_new_std(hdl, NULL,
+			V4L2_CID_RDS_RX_RADIO_TEXT, 0, 64, 64, 0);
+	dev->rds_ta = v4l2_ctrl_new_std(hdl, NULL,
+			V4L2_CID_RDS_RX_TRAFFIC_ANNOUNCEMENT, 0, 1, 1, 0);
+	dev->rds_tp = v4l2_ctrl_new_std(hdl, NULL,
+			V4L2_CID_RDS_RX_TRAFFIC_PROGRAM, 0, 1, 1, 0);
+	dev->rds_ms = v4l2_ctrl_new_std(hdl, NULL,
+			V4L2_CID_RDS_RX_MUSIC_SPEECH, 0, 1, 1, 1);
 	v4l2_dev->ctrl_handler = hdl;
 	if (hdl->error) {
 		res = hdl->error;
-- 
2.0.1

