Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4424 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab2APNKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 08:10:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/10] radio-aztech: Convert to radio-isa.
Date: Mon, 16 Jan 2012 14:09:59 +0100
Message-Id: <587fbbb1b6cec1bc085bb3a2f15abe1f00633d27.1326717025.git.hans.verkuil@cisco.com>
In-Reply-To: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
References: <1326719406-4538-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
References: <30958c9eb2499987a608cdf411e578984b617046.1326717025.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Tested with actual hardware and the Keene USB FM Transmitter.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/Kconfig        |    6 +-
 drivers/media/radio/radio-aztech.c |  371 ++++++++----------------------------
 2 files changed, 80 insertions(+), 297 deletions(-)

diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
index 366fed4..803f31a 100644
--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -246,15 +246,11 @@ config RADIO_RTRACK2_PORT
 config RADIO_AZTECH
 	tristate "Aztech/Packard Bell Radio"
 	depends on ISA && VIDEO_V4L2
+	select RADIO_ISA
 	---help---
 	  Choose Y here if you have one of these FM radio cards, and then fill
 	  in the port address below.
 
-	  In order to control your radio card, you will need to use programs
-	  that are compatible with the Video For Linux API.  Information on
-	  this API and pointers to "v4l" programs may be found at
-	  <file:Documentation/video4linux/API.html>.
-
 	  To compile this driver as a module, choose M here: the
 	  module will be called radio-aztech.
 
diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index eed7b08..8117fdf 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -1,5 +1,7 @@
-/* radio-aztech.c - Aztech radio card driver for Linux 2.2
+/*
+ * radio-aztech.c - Aztech radio card driver
  *
+ * Converted to the radio-isa framework by Hans Verkuil <hans.verkuil@xs4all.nl>
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
  * Adapted to support the Video for Linux API by
  * Russell Kroll <rkroll@exploits.org>.  Based on original tuner code by:
@@ -10,19 +12,7 @@
  * Scott McGrath    (smcgrath@twilight.vtc.vsc.edu)
  * William McGrath  (wmcgrath@twilight.vtc.vsc.edu)
  *
- * The basis for this code may be found at http://bigbang.vtc.vsc.edu/fmradio/
- * along with more information on the card itself.
- *
- * History:
- * 1999-02-24	Russell Kroll <rkroll@exploits.org>
- *		Fine tuning/VIDEO_TUNER_LOW
- * 		Range expanded to 87-108 MHz (from 87.9-107.8)
- *
- * Notable changes from the original source:
- * - includes stripped down to the essentials
- * - for loops used as delays replaced with udelay()
- * - #defines removed, changed to static values
- * - tuning structure changed - no more character arrays, other changes
+ * Fully tested with the Keene USB FM Transmitter and the v4l2-compliance tool.
 */
 
 #include <linux/module.h>	/* Modules 			*/
@@ -33,124 +23,69 @@
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-ctrls.h>
+#include "radio-isa.h"
 
 MODULE_AUTHOR("Russell Kroll, Quay Lu, Donald Song, Jason Lewis, Scott McGrath, William McGrath");
 MODULE_DESCRIPTION("A driver for the Aztech radio card.");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.3");
+MODULE_VERSION("1.0.0");
 
 /* acceptable ports: 0x350 (JP3 shorted), 0x358 (JP3 open) */
-
 #ifndef CONFIG_RADIO_AZTECH_PORT
 #define CONFIG_RADIO_AZTECH_PORT -1
 #endif
 
-static int io = CONFIG_RADIO_AZTECH_PORT;
-static int radio_nr = -1;
-static int radio_wait_time = 1000;
+#define AZTECH_MAX 2
 
-module_param(io, int, 0);
-module_param(radio_nr, int, 0);
-MODULE_PARM_DESC(io, "I/O address of the Aztech card (0x350 or 0x358)");
+static int io[AZTECH_MAX] = { [0] = CONFIG_RADIO_AZTECH_PORT,
+			      [1 ... (AZTECH_MAX - 1)] = -1 };
+static int radio_nr[AZTECH_MAX]	= { [0 ... (AZTECH_MAX - 1)] = -1 };
+static const int radio_wait_time = 1000;
 
-struct aztech
-{
-	struct v4l2_device v4l2_dev;
-	struct video_device vdev;
-	int io;
+module_param_array(io, int, NULL, 0444);
+MODULE_PARM_DESC(io, "I/O addresses of the Aztech card (0x350 or 0x358)");
+module_param_array(radio_nr, int, NULL, 0444);
+MODULE_PARM_DESC(radio_nr, "Radio device numbers");
+
+struct aztech {
+	struct radio_isa_card isa;
 	int curvol;
-	unsigned long curfreq;
-	int stereo;
-	struct mutex lock;
 };
 
-static struct aztech aztech_card;
-
-static int volconvert(int level)
-{
-	level >>= 14;		/* Map 16bits down to 2 bit */
-	level &= 3;
-
-	/* convert to card-friendly values */
-	switch (level) {
-	case 0:
-		return 0;
-	case 1:
-		return 1;
-	case 2:
-		return 4;
-	case 3:
-		return 5;
-	}
-	return 0;	/* Quieten gcc */
-}
-
 static void send_0_byte(struct aztech *az)
 {
 	udelay(radio_wait_time);
-	outb_p(2 + volconvert(az->curvol), az->io);
-	outb_p(64 + 2 + volconvert(az->curvol), az->io);
+	outb_p(2 + az->curvol, az->isa.io);
+	outb_p(64 + 2 + az->curvol, az->isa.io);
 }
 
 static void send_1_byte(struct aztech *az)
 {
-	udelay (radio_wait_time);
-	outb_p(128 + 2 + volconvert(az->curvol), az->io);
-	outb_p(128 + 64 + 2 + volconvert(az->curvol), az->io);
-}
-
-static int az_setvol(struct aztech *az, int vol)
-{
-	mutex_lock(&az->lock);
-	outb(volconvert(vol), az->io);
-	mutex_unlock(&az->lock);
-	return 0;
-}
-
-/* thanks to Michael Dwyer for giving me a dose of clues in
- * the signal strength department..
- *
- * This card has a stereo bit - bit 0 set = mono, not set = stereo
- * It also has a "signal" bit - bit 1 set = bad signal, not set = good
- *
- */
-
-static int az_getsigstr(struct aztech *az)
-{
-	int sig = 1;
-
-	mutex_lock(&az->lock);
-	if (inb(az->io) & 2)	/* bit set = no signal present */
-		sig = 0;
-	mutex_unlock(&az->lock);
-	return sig;
+	udelay(radio_wait_time);
+	outb_p(128 + 2 + az->curvol, az->isa.io);
+	outb_p(128 + 64 + 2 + az->curvol, az->isa.io);
 }
 
-static int az_getstereo(struct aztech *az)
+static struct radio_isa_card *aztech_alloc(void)
 {
-	int stereo = 1;
+	struct aztech *az = kzalloc(sizeof(*az), GFP_KERNEL);
 
-	mutex_lock(&az->lock);
-	if (inb(az->io) & 1) 	/* bit set = mono */
-		stereo = 0;
-	mutex_unlock(&az->lock);
-	return stereo;
+	return az ? &az->isa : NULL;
 }
 
-static int az_setfreq(struct aztech *az, unsigned long frequency)
+static int aztech_s_frequency(struct radio_isa_card *isa, u32 freq)
 {
+	struct aztech *az = container_of(isa, struct aztech, isa);
 	int  i;
 
-	mutex_lock(&az->lock);
-
-	az->curfreq = frequency;
-	frequency += 171200;		/* Add 10.7 MHz IF		*/
-	frequency /= 800;		/* Convert to 50 kHz units	*/
+	freq += 171200;			/* Add 10.7 MHz IF		*/
+	freq /= 800;			/* Convert to 50 kHz units	*/
 
 	send_0_byte(az);		/*  0: LSB of frequency       */
 
 	for (i = 0; i < 13; i++)	/*   : frequency bits (1-13)  */
-		if (frequency & (1 << i))
+		if (freq & (1 << i))
 			send_1_byte(az);
 		else
 			send_0_byte(az);
@@ -158,7 +93,7 @@ static int az_setfreq(struct aztech *az, unsigned long frequency)
 	send_0_byte(az);		/* 14: test bit - always 0    */
 	send_0_byte(az);		/* 15: test bit - always 0    */
 	send_0_byte(az);		/* 16: band data 0 - always 0 */
-	if (az->stereo)		/* 17: stereo (1 to enable)   */
+	if (isa->stereo)		/* 17: stereo (1 to enable)   */
 		send_1_byte(az);
 	else
 		send_0_byte(az);
@@ -173,225 +108,77 @@ static int az_setfreq(struct aztech *az, unsigned long frequency)
 	/* latch frequency */
 
 	udelay(radio_wait_time);
-	outb_p(128 + 64 + volconvert(az->curvol), az->io);
-
-	mutex_unlock(&az->lock);
-
-	return 0;
-}
-
-static int vidioc_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *v)
-{
-	strlcpy(v->driver, "radio-aztech", sizeof(v->driver));
-	strlcpy(v->card, "Aztech Radio", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
-	return 0;
-}
-
-static int vidioc_g_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
-{
-	struct aztech *az = video_drvdata(file);
-
-	if (v->index > 0)
-		return -EINVAL;
-
-	strlcpy(v->name, "FM", sizeof(v->name));
-	v->type = V4L2_TUNER_RADIO;
-
-	v->rangelow = 87 * 16000;
-	v->rangehigh = 108 * 16000;
-	v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
-	v->capability = V4L2_TUNER_CAP_LOW;
-	if (az_getstereo(az))
-		v->audmode = V4L2_TUNER_MODE_STEREO;
-	else
-		v->audmode = V4L2_TUNER_MODE_MONO;
-	v->signal = 0xFFFF * az_getsigstr(az);
-
-	return 0;
-}
-
-static int vidioc_s_tuner(struct file *file, void *priv,
-				struct v4l2_tuner *v)
-{
-	return v->index ? -EINVAL : 0;
-}
+	outb_p(128 + 64 + az->curvol, az->isa.io);
 
-static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
 	return 0;
 }
 
-static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	return i ? -EINVAL : 0;
-}
-
-static int vidioc_g_audio(struct file *file, void *priv,
-			   struct v4l2_audio *a)
-{
-	a->index = 0;
-	strlcpy(a->name, "Radio", sizeof(a->name));
-	a->capability = V4L2_AUDCAP_STEREO;
-	return 0;
-}
-
-static int vidioc_s_audio(struct file *file, void *priv,
-			   struct v4l2_audio *a)
+/* thanks to Michael Dwyer for giving me a dose of clues in
+ * the signal strength department..
+ *
+ * This card has a stereo bit - bit 0 set = mono, not set = stereo
+ */
+static u32 aztech_g_rxsubchans(struct radio_isa_card *isa)
 {
-	return a->index ? -EINVAL : 0;
+	if (inb(isa->io) & 1)
+		return V4L2_TUNER_SUB_MONO;
+	return V4L2_TUNER_SUB_STEREO;
 }
 
-static int vidioc_s_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+static int aztech_s_stereo(struct radio_isa_card *isa, bool stereo)
 {
-	struct aztech *az = video_drvdata(file);
-
-	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
-	az_setfreq(az, f->frequency);
-	return 0;
+	return aztech_s_frequency(isa, isa->freq);
 }
 
-static int vidioc_g_frequency(struct file *file, void *priv,
-				struct v4l2_frequency *f)
+static int aztech_s_mute_volume(struct radio_isa_card *isa, bool mute, int vol)
 {
-	struct aztech *az = video_drvdata(file);
+	struct aztech *az = container_of(isa, struct aztech, isa);
 
-	if (f->tuner != 0)
-		return -EINVAL;
-	f->type = V4L2_TUNER_RADIO;
-	f->frequency = az->curfreq;
+	if (mute)
+		vol = 0;
+	az->curvol = (vol & 1) + ((vol & 2) << 1);
+	outb(az->curvol, isa->io);
 	return 0;
 }
 
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qc)
-{
-	switch (qc->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
-	case V4L2_CID_AUDIO_VOLUME:
-		return v4l2_ctrl_query_fill(qc, 0, 0xff, 1, 0xff);
-	}
-	return -EINVAL;
-}
-
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			    struct v4l2_control *ctrl)
-{
-	struct aztech *az = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (az->curvol == 0)
-			ctrl->value = 1;
-		else
-			ctrl->value = 0;
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		ctrl->value = az->curvol * 6554;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			    struct v4l2_control *ctrl)
-{
-	struct aztech *az = video_drvdata(file);
-
-	switch (ctrl->id) {
-	case V4L2_CID_AUDIO_MUTE:
-		if (ctrl->value)
-			az_setvol(az, 0);
-		else
-			az_setvol(az, az->curvol);
-		return 0;
-	case V4L2_CID_AUDIO_VOLUME:
-		az_setvol(az, ctrl->value);
-		return 0;
-	}
-	return -EINVAL;
-}
-
-static const struct v4l2_file_operations aztech_fops = {
-	.owner		= THIS_MODULE,
-	.unlocked_ioctl	= video_ioctl2,
+static const struct radio_isa_ops aztech_ops = {
+	.alloc = aztech_alloc,
+	.s_mute_volume = aztech_s_mute_volume,
+	.s_frequency = aztech_s_frequency,
+	.s_stereo = aztech_s_stereo,
+	.g_rxsubchans = aztech_g_rxsubchans,
 };
 
-static const struct v4l2_ioctl_ops aztech_ioctl_ops = {
-	.vidioc_querycap    = vidioc_querycap,
-	.vidioc_g_tuner     = vidioc_g_tuner,
-	.vidioc_s_tuner     = vidioc_s_tuner,
-	.vidioc_g_audio     = vidioc_g_audio,
-	.vidioc_s_audio     = vidioc_s_audio,
-	.vidioc_g_input     = vidioc_g_input,
-	.vidioc_s_input     = vidioc_s_input,
-	.vidioc_g_frequency = vidioc_g_frequency,
-	.vidioc_s_frequency = vidioc_s_frequency,
-	.vidioc_queryctrl   = vidioc_queryctrl,
-	.vidioc_g_ctrl      = vidioc_g_ctrl,
-	.vidioc_s_ctrl      = vidioc_s_ctrl,
+static const int aztech_ioports[] = { 0x350, 0x358 };
+
+static struct radio_isa_driver aztech_driver = {
+	.driver = {
+		.match		= radio_isa_match,
+		.probe		= radio_isa_probe,
+		.remove		= radio_isa_remove,
+		.driver		= {
+			.name	= "radio-aztech",
+		},
+	},
+	.io_params = io,
+	.radio_nr_params = radio_nr,
+	.io_ports = aztech_ioports,
+	.num_of_io_ports = ARRAY_SIZE(aztech_ioports),
+	.region_size = 2,
+	.card = "Aztech Radio",
+	.ops = &aztech_ops,
+	.has_stereo = true,
+	.max_volume = 3,
 };
 
 static int __init aztech_init(void)
 {
-	struct aztech *az = &aztech_card;
-	struct v4l2_device *v4l2_dev = &az->v4l2_dev;
-	int res;
-
-	strlcpy(v4l2_dev->name, "aztech", sizeof(v4l2_dev->name));
-	az->io = io;
-
-	if (az->io == -1) {
-		v4l2_err(v4l2_dev, "you must set an I/O address with io=0x350 or 0x358\n");
-		return -EINVAL;
-	}
-
-	if (!request_region(az->io, 2, "aztech")) {
-		v4l2_err(v4l2_dev, "port 0x%x already in use\n", az->io);
-		return -EBUSY;
-	}
-
-	res = v4l2_device_register(NULL, v4l2_dev);
-	if (res < 0) {
-		release_region(az->io, 2);
-		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
-		return res;
-	}
-
-	mutex_init(&az->lock);
-	strlcpy(az->vdev.name, v4l2_dev->name, sizeof(az->vdev.name));
-	az->vdev.v4l2_dev = v4l2_dev;
-	az->vdev.fops = &aztech_fops;
-	az->vdev.ioctl_ops = &aztech_ioctl_ops;
-	az->vdev.release = video_device_release_empty;
-	video_set_drvdata(&az->vdev, az);
-	/* mute card - prevents noisy bootups */
-	outb(0, az->io);
-
-	if (video_register_device(&az->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
-		v4l2_device_unregister(v4l2_dev);
-		release_region(az->io, 2);
-		return -EINVAL;
-	}
-
-	v4l2_info(v4l2_dev, "Aztech radio card driver v1.00/19990224 rkroll@exploits.org\n");
-	return 0;
+	return isa_register_driver(&aztech_driver.driver, AZTECH_MAX);
 }
 
 static void __exit aztech_exit(void)
 {
-	struct aztech *az = &aztech_card;
-
-	video_unregister_device(&az->vdev);
-	v4l2_device_unregister(&az->v4l2_dev);
-	release_region(az->io, 2);
+	isa_unregister_driver(&aztech_driver.driver);
 }
 
 module_init(aztech_init);
-- 
1.7.7.3

