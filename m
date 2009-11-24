Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp240.poczta.interia.pl ([217.74.64.240]:48128 "EHLO
	smtp240.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441AbZKXVLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 16:11:36 -0500
Date: Tue, 24 Nov 2009 22:12:36 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: linux-media@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] New driver for the radio FM module on Miro PCM20 sound card
Message-Id: <20091124221236.92859c90.krzysztof.h1@poczta.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Krzysztof Helt <krzysztof.h1@wp.pl>

This is recreated driver for the FM module found on Miro
PCM20 sound cards. This driver was removed around the 2.6.2x
kernels because it relied on the removed OSS module. Now, it
uses a current ALSA module (snd-miro) and is adapted to v4l2
layer.

It provides only basic functionality: frequency changing and
FM module muting.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
This driver depends on changes to the snd-miro driver. These changes
are already accepted to the ALSA tree, but these changes 
won't be pushed into the 2.6.33 kernel.

 drivers/media/radio/Kconfig           |   17 ++
 drivers/media/radio/Makefile          |    1 +
 drivers/media/radio/radio-miropcm20.c |  271 +++++++++++++++++++++++++++++++++
 3 files changed, 289 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/radio/radio-miropcm20.c

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index a87a477..1c12f99 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -195,6 +195,23 @@ config RADIO_MAESTRO
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-maestro.
 
+config RADIO_MIROPCM20
+	tristate "miroSOUND PCM20 radio"
+	depends on ISA && VIDEO_V4L2
+	select SND_MIRO
+	---help---
+	  Choose Y here if you have this FM radio card. You also need to select
+	  the "Miro miroSOUND PCM1pro/PCM12/PCM20radio driver" ALSA sound card
+	  driver for this to work.
+
+	  In order to control your radio card, you will need to use programs
+	  that are compatible with the Video For Linux API.  Information on
+	  this API and pointers to "v4l" programs may be found at
+	  <file:Documentation/video4linux/API.html>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called radio-miropcm20.
+
 config RADIO_SF16FMI
 	tristate "SF16FMI Radio"
 	depends on ISA && VIDEO_V4L2
diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
index 2a1be3b..8a63d54 100644
--- a/drivers/media/radio/Makefile
+++ b/drivers/media/radio/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
 obj-$(CONFIG_I2C_SI4713) += si4713-i2c.o
 obj-$(CONFIG_RADIO_SI4713) += radio-si4713.o
 obj-$(CONFIG_RADIO_MAESTRO) += radio-maestro.o
+obj-$(CONFIG_RADIO_MIROPCM20) += radio-miropcm20.o
 obj-$(CONFIG_USB_DSBR) += dsbr100.o
 obj-$(CONFIG_RADIO_SI470X) += si470x/
 obj-$(CONFIG_USB_MR800) += radio-mr800.o
diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
new file mode 100644
index 0000000..0b6940c
--- /dev/null
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -0,0 +1,271 @@
+/* Miro PCM20 radio driver for Linux radio support
+ * (c) 1998 Ruurd Reitsma <R.A.Reitsma@wbmt.tudelft.nl>
+ * Thanks to Norberto Pellici for the ACI device interface specification
+ * The API part is based on the radiotrack driver by M. Kirkwood
+ * This driver relies on the aci mixer provided by the snd-miro
+ * ALSA driver.
+ * Look there for further info...
+ */
+
+/* Revision history:
+ *
+ *   1998        Ruurd Reitsma <R.A.Reitsma@wbmt.tudelft.nl>
+ *   2000-09-05  Robert Siemer <Robert.Siemer@gmx.de>
+ *        removed unfinished volume control (maybe adding it later again)
+ *        use OSS-mixer; added stereo control
+ */
+
+/* What ever you think about the ACI, version 0x07 is not very well!
+ * I can't get frequency, 'tuner status', 'tuner flags' or mute/mono
+ * conditions...                Robert
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <sound/aci.h>
+
+static int radio_nr = -1;
+module_param(radio_nr, int, 0);
+
+static int mono;
+module_param(mono, bool, 0);
+MODULE_PARM_DESC(mono, "Force tuner into mono mode.");
+
+struct pcm20 {
+	struct v4l2_device v4l2_dev;
+	struct video_device vdev;
+	unsigned long freq;
+	int muted;
+	struct snd_miro_aci *aci;
+};
+
+static struct pcm20 pcm20_card = {
+	.freq   = 87*16000,
+	.muted  = 1,
+};
+
+static int pcm20_mute(struct pcm20 *dev, unsigned char mute)
+{
+	dev->muted = mute;
+	return snd_aci_cmd(dev->aci, ACI_SET_TUNERMUTE, mute, -1);
+}
+
+static int pcm20_stereo(struct pcm20 *dev, unsigned char stereo)
+{
+	return snd_aci_cmd(dev->aci, ACI_SET_TUNERMONO, !stereo, -1);
+}
+
+static int pcm20_setfreq(struct pcm20 *dev, unsigned long freq)
+{
+	unsigned char freql;
+	unsigned char freqh;
+	struct snd_miro_aci *aci = dev->aci;
+
+	dev->freq = freq;
+
+	freq /= 160;
+	if (!(aci->aci_version == 0x07 || aci->aci_version >= 0xb0))
+		freq /= 10;  /* I don't know exactly which version
+			      * needs this hack */
+	freql = freq & 0xff;
+	freqh = freq >> 8;
+
+	pcm20_stereo(dev, !mono);
+	return snd_aci_cmd(aci, ACI_WRITE_TUNE, freql, freqh);
+}
+
+static const struct v4l2_file_operations pcm20_fops = {
+	.owner		= THIS_MODULE,
+	.ioctl		= video_ioctl2,
+};
+
+static int vidioc_querycap(struct file *file, void *priv,
+				struct v4l2_capability *v)
+{
+	strlcpy(v->driver, "Miro PCM20", sizeof(v->driver));
+	strlcpy(v->card, "Miro PCM20", sizeof(v->card));
+	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
+	v->version = 0x1;
+	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	return 0;
+}
+
+static int vidioc_g_tuner(struct file *file, void *priv,
+				struct v4l2_tuner *v)
+{
+	if (v->index)	/* Only 1 tuner */
+		return -EINVAL;
+	strlcpy(v->name, "FM", sizeof(v->name));
+	v->type = V4L2_TUNER_RADIO;
+	v->rangelow = 87*16000;
+	v->rangehigh = 108*16000;
+	v->signal = 0xffff;
+	v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
+	v->capability = V4L2_TUNER_CAP_LOW;
+	v->audmode = V4L2_TUNER_MODE_MONO;
+	return 0;
+}
+
+static int vidioc_s_tuner(struct file *file, void *priv,
+				struct v4l2_tuner *v)
+{
+	return v->index ? -EINVAL : 0;
+}
+
+static int vidioc_g_frequency(struct file *file, void *priv,
+				struct v4l2_frequency *f)
+{
+	struct pcm20 *dev = video_drvdata(file);
+
+	f->type = V4L2_TUNER_RADIO;
+	f->frequency = dev->freq;
+	return 0;
+}
+
+
+static int vidioc_s_frequency(struct file *file, void *priv,
+				struct v4l2_frequency *f)
+{
+	struct pcm20 *dev = video_drvdata(file);
+
+	dev->freq = f->frequency;
+	pcm20_setfreq(dev, f->frequency);
+	return 0;
+}
+
+static int vidioc_queryctrl(struct file *file, void *priv,
+				struct v4l2_queryctrl *qc)
+{
+	switch (qc->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
+	}
+	return -EINVAL;
+}
+
+static int vidioc_g_ctrl(struct file *file, void *priv,
+				struct v4l2_control *ctrl)
+{
+	struct pcm20 *dev = video_drvdata(file);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		ctrl->value = dev->muted;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int vidioc_s_ctrl(struct file *file, void *priv,
+				struct v4l2_control *ctrl)
+{
+	struct pcm20 *dev = video_drvdata(file);
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUDIO_MUTE:
+		pcm20_mute(dev, ctrl->value);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
+{
+	return i ? -EINVAL : 0;
+}
+
+static int vidioc_g_audio(struct file *file, void *priv,
+				struct v4l2_audio *a)
+{
+	a->index = 0;
+	strlcpy(a->name, "Radio", sizeof(a->name));
+	a->capability = V4L2_AUDCAP_STEREO;
+	return 0;
+}
+
+static int vidioc_s_audio(struct file *file, void *priv,
+				struct v4l2_audio *a)
+{
+	return a->index ? -EINVAL : 0;
+}
+
+static const struct v4l2_ioctl_ops pcm20_ioctl_ops = {
+	.vidioc_querycap    = vidioc_querycap,
+	.vidioc_g_tuner     = vidioc_g_tuner,
+	.vidioc_s_tuner     = vidioc_s_tuner,
+	.vidioc_g_frequency = vidioc_g_frequency,
+	.vidioc_s_frequency = vidioc_s_frequency,
+	.vidioc_queryctrl   = vidioc_queryctrl,
+	.vidioc_g_ctrl      = vidioc_g_ctrl,
+	.vidioc_s_ctrl      = vidioc_s_ctrl,
+	.vidioc_g_audio     = vidioc_g_audio,
+	.vidioc_s_audio     = vidioc_s_audio,
+	.vidioc_g_input     = vidioc_g_input,
+	.vidioc_s_input     = vidioc_s_input,
+};
+
+static int __init pcm20_init(void)
+{
+	struct pcm20 *dev = &pcm20_card;
+	struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
+	int res;
+
+	dev->aci = snd_aci_get_aci();
+	if (dev->aci == NULL) {
+		v4l2_err(v4l2_dev,
+			 "you must load the snd-miro driver first!\n");
+		return -ENODEV;
+	}
+	strlcpy(v4l2_dev->name, "miropcm20", sizeof(v4l2_dev->name));
+
+
+	res = v4l2_device_register(NULL, v4l2_dev);
+	if (res < 0) {
+		v4l2_err(v4l2_dev, "could not register v4l2_device\n");
+		return -EINVAL;
+	}
+
+	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
+	dev->vdev.v4l2_dev = v4l2_dev;
+	dev->vdev.fops = &pcm20_fops;
+	dev->vdev.ioctl_ops = &pcm20_ioctl_ops;
+	dev->vdev.release = video_device_release_empty;
+	video_set_drvdata(&dev->vdev, dev);
+
+	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0)
+		goto fail;
+
+	v4l2_info(v4l2_dev, "Mirosound PCM20 Radio tuner\n");
+	return 0;
+fail:
+	v4l2_device_unregister(v4l2_dev);
+	return -EINVAL;
+}
+
+MODULE_AUTHOR("Ruurd Reitsma, Krzysztof Helt");
+MODULE_DESCRIPTION("A driver for the Miro PCM20 radio card.");
+MODULE_LICENSE("GPL");
+
+static void __exit pcm20_cleanup(void)
+{
+	struct pcm20 *dev = &pcm20_card;
+
+	video_unregister_device(&dev->vdev);
+	v4l2_device_unregister(&dev->v4l2_dev);
+}
+
+module_init(pcm20_init);
+module_exit(pcm20_cleanup);
-- 
1.6.4


----------------------------------------------------------------------
Kawalerka za 79 000 zl!
Sprawdz >>> http://link.interia.pl/f2425

