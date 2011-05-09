Return-path: <mchehab@gaivota>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:42198 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754704Ab1EIVju (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 17:39:50 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: [PATCH 1/3] tea575x: unify read/write functions
Date: Mon, 9 May 2011 23:39:26 +0200
Cc: linux-media@vger.kernel.org,
	"Kernel development list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105092339.29143.linux@rainbow-software.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Implement generic read/write functions to access TEA575x tuners. They're now
implemented 4 times (once in es1968 and 3 times in fm801).
This also allows mute to work on all cards.
Also improve tuner detection/initialization.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.39-rc2-/include/sound/tea575x-tuner.h	2011-04-29 22:48:34.000000000 +0200
+++ linux-2.6.39-rc2/include/sound/tea575x-tuner.h	2011-05-06 22:20:46.000000000 +0200
@@ -26,12 +26,17 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
 
+#define TEA575X_DATA	(1 << 0)
+#define TEA575X_CLK	(1 << 1)
+#define TEA575X_WREN	(1 << 2)
+#define TEA575X_MOST	(1 << 3)
+
 struct snd_tea575x;
 
 struct snd_tea575x_ops {
-	void (*write)(struct snd_tea575x *tea, unsigned int val);
-	unsigned int (*read)(struct snd_tea575x *tea);
-	void (*mute)(struct snd_tea575x *tea, unsigned int mute);
+	void (*set_pins)(struct snd_tea575x *tea, u8 pins);
+	u8 (*get_pins)(struct snd_tea575x *tea);
+	void (*set_direction)(struct snd_tea575x *tea, bool output);
 };
 
 struct snd_tea575x {
@@ -49,7 +54,7 @@ struct snd_tea575x {
 	void *private_data;
 };
 
-void snd_tea575x_init(struct snd_tea575x *tea);
+int snd_tea575x_init(struct snd_tea575x *tea);
 void snd_tea575x_exit(struct snd_tea575x *tea);
 
 #endif /* __SOUND_TEA575X_TUNER_H */
--- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-05-06 22:44:14.000000000 +0200
+++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-05-06 22:21:09.000000000 +0200
@@ -77,11 +77,65 @@ static struct v4l2_queryctrl radio_qctrl
  * lowlevel part
  */
 
+static void snd_tea575x_write(struct snd_tea575x *tea, unsigned int val)
+{
+	u16 l;
+	u8 data;
+
+	tea->ops->set_direction(tea, 1);
+	udelay(16);
+
+	for (l = 25; l > 0; l--) {
+		data = (val >> 24) & TEA575X_DATA;
+		val <<= 1;			/* shift data */
+		tea->ops->set_pins(tea, data | TEA575X_WREN);
+		udelay(2);
+		tea->ops->set_pins(tea, data | TEA575X_WREN | TEA575X_CLK);
+		udelay(2);
+		tea->ops->set_pins(tea, data | TEA575X_WREN);
+		udelay(2);
+	}
+
+	if (!tea->mute)
+		tea->ops->set_pins(tea, 0);
+}
+
+static unsigned int snd_tea575x_read(struct snd_tea575x *tea)
+{
+	u16 l, rdata;
+	u32 data = 0;
+
+	tea->ops->set_direction(tea, 0);
+	tea->ops->set_pins(tea, 0);
+	udelay(16);
+
+	for (l = 24; l--;) {
+		tea->ops->set_pins(tea, TEA575X_CLK);
+		udelay(2);
+		if (!l)
+			tea->tuned = tea->ops->get_pins(tea) & TEA575X_MOST ? 0 : 1;
+		tea->ops->set_pins(tea, 0);
+		udelay(2);
+		data <<= 1;			/* shift data */
+		rdata = tea->ops->get_pins(tea);
+		if (!l)
+			tea->stereo = (rdata & TEA575X_MOST) ?  0 : 1;
+		if (rdata & TEA575X_DATA)
+			data++;
+		udelay(2);
+	}
+
+	if (tea->mute)
+		tea->ops->set_pins(tea, TEA575X_WREN);
+
+	return data;
+}
+
 static void snd_tea575x_get_freq(struct snd_tea575x *tea)
 {
 	unsigned long freq;
 
-	freq = tea->ops->read(tea) & TEA575X_BIT_FREQ_MASK;
+	freq = snd_tea575x_read(tea) & TEA575X_BIT_FREQ_MASK;
 	/* freq *= 12.5 */
 	freq *= 125;
 	freq /= 10;
@@ -111,7 +165,7 @@ static void snd_tea575x_set_freq(struct
 
 	tea->val &= ~TEA575X_BIT_FREQ_MASK;
 	tea->val |= freq & TEA575X_BIT_FREQ_MASK;
-	tea->ops->write(tea, tea->val);
+	snd_tea575x_write(tea, tea->val);
 }
 
 /*
@@ -139,7 +193,7 @@ static int vidioc_g_tuner(struct file *f
 	if (v->index > 0)
 		return -EINVAL;
 
-	tea->ops->read(tea);
+	snd_tea575x_read(tea);
 
 	strcpy(v->name, "FM");
 	v->type = V4L2_TUNER_RADIO;
@@ -233,10 +287,8 @@ static int vidioc_g_ctrl(struct file *fi
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		if (tea->ops->mute) {
-			ctrl->value = tea->mute;
-			return 0;
-		}
+		ctrl->value = tea->mute;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -248,11 +300,11 @@ static int vidioc_s_ctrl(struct file *fi
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
-		if (tea->ops->mute) {
-			tea->ops->mute(tea, ctrl->value);
+		if (tea->mute != ctrl->value) {
 			tea->mute = ctrl->value;
-			return 0;
+			snd_tea575x_set_freq(tea);
 		}
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -317,18 +369,16 @@ static struct video_device tea575x_radio
 /*
  * initialize all the tea575x chips
  */
-void snd_tea575x_init(struct snd_tea575x *tea)
+int snd_tea575x_init(struct snd_tea575x *tea)
 {
 	int retval;
-	unsigned int val;
 	struct video_device *tea575x_radio_inst;
 
-	val = tea->ops->read(tea);
-	if (val == 0x1ffffff || val == 0) {
-		snd_printk(KERN_ERR
-			   "tea575x-tuner: Cannot find TEA575x chip\n");
-		return;
-	}
+	tea->mute = 1;
+
+	snd_tea575x_write(tea, 0x55AA);
+	if (snd_tea575x_read(tea) != 0x55AA)
+		return -ENODEV;
 
 	tea->in_use = 0;
 	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_10_40;
@@ -337,7 +387,7 @@ void snd_tea575x_init(struct snd_tea575x
 	tea575x_radio_inst = video_device_alloc();
 	if (tea575x_radio_inst == NULL) {
 		printk(KERN_ERR "tea575x-tuner: not enough memory\n");
-		return;
+		return -ENOMEM;
 	}
 
 	memcpy(tea575x_radio_inst, &tea575x_radio, sizeof(tea575x_radio));
@@ -352,17 +402,13 @@ void snd_tea575x_init(struct snd_tea575x
 	if (retval) {
 		printk(KERN_ERR "tea575x-tuner: can't register video device!\n");
 		kfree(tea575x_radio_inst);
-		return;
+		return retval;
 	}
 
 	snd_tea575x_set_freq(tea);
-
-	/* mute on init */
-	if (tea->ops->mute) {
-		tea->ops->mute(tea, 1);
-		tea->mute = 1;
-	}
 	tea->vd = tea575x_radio_inst;
+
+	return 0;
 }
 
 void snd_tea575x_exit(struct snd_tea575x *tea)


-- 
Ondrej Zary
