Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.telros.ru ([83.136.244.21]:52826 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab2IGKvs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Sep 2012 06:51:48 -0400
Date: Fri, 7 Sep 2012 18:18:31 +0400
From: volokh@telros.ru
To: Adam Rosi-Kessel <adam@rosi-kessel.org>
Cc: linux-media@vger.kernel.org, volokh84@gmail.com
Subject: Re: go7007 question
Message-ID: <20120907141831.GA12333@VPir.telros.ru>
References: <5044F8DC.20509@rosi-kessel.org>
 <20120906191014.GA2540@VPir.Home>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <20120906191014.GA2540@VPir.Home>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 06, 2012 at 11:10:14PM +0400, Volokh Konstantin wrote:
> On Mon, Sep 03, 2012 at 02:37:16PM -0400, Adam Rosi-Kessel wrote:
> > 
> > [469.928881] wis-saa7115: initializing SAA7115 at address 32 on WIS
> > GO7007SB EZ-USB
> > 
> > [469.989083] go7007: probing for module i2c:wis_saa7115 failed
> > 
> > [470.004785] wis-uda1342: initializing UDA1342 at address 26 on WIS
> > GO7007SB EZ-USB
> > 
> > [470.005454] go7007: probing for module i2c:wis_uda1342 failed
> > 
> > [470.011659] wis-sony-tuner: initializing tuner at address 96 on WIS
> > GO7007SB EZ-USB
Hi, I generated patchs, that u may in your own go7007/ folder
It contains go7007 initialization and i2c_subdev fixing

It was checked for 3.6 branch (compile only)
 
Regards,
Volokh Konstantin

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch.diff"

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index ece2dd1..2dff9b5 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -173,6 +173,11 @@ static int go7007_init_encoder(struct go7007 *go)
 		go7007_write_addr(go, 0x3c82, 0x0001);
 		go7007_write_addr(go, 0x3c80, 0x00fe);
 	}
+	if (go->board_id == GO7007_BOARDID_ADLINK_MPG24) {
+		/* set GPIO5 to be an output, currently low */
+		go7007_write_addr(go, 0x3c82, 0x0000);
+		go7007_write_addr(go, 0x3c80, 0x00df);
+	}
 	return 0;
 }
 
@@ -192,17 +197,23 @@ int go7007_reset_encoder(struct go7007 *go)
 /*
  * Attempt to instantiate an I2C client by ID, probably loading a module.
  */
-static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
-			   int addr)
+static int init_i2c_module(struct i2c_adapter *adapter, const struct go_i2c *const i2c)
 {
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct v4l2_device *v4l2_dev = &go->v4l2_dev;
+	struct i2c_board_info info;
+
+	memset(&info, 0, sizeof(info));
+	strlcpy(info.type, i2c->type, sizeof(info.type));
+	info.addr = i2c->addr;
 
-	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, type, addr, NULL))
+	if (i2c->id == I2C_DRIVERID_WIS_TW2804)
+		info.flags |= I2C_CLIENT_TEN;
+	if (v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, NULL))
 		return 0;
 
-	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", type);
-	return -1;
+	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", i2c->type);
+	return -EINVAL;
 }
 
 /*
@@ -238,9 +249,7 @@ int go7007_register_encoder(struct go7007 *go)
 	}
 	if (go->i2c_adapter_online) {
 		for (i = 0; i < go->board_info->num_i2c_devs; ++i)
-			init_i2c_module(&go->i2c_adapter,
-					go->board_info->i2c_devs[i].type,
-					go->board_info->i2c_devs[i].addr);
+			init_i2c_module(&go->i2c_adapter, &go->board_info->i2c_devs[i]);
 		if (go->board_id == GO7007_BOARDID_ADLINK_MPG24)
 			i2c_clients_command(&go->i2c_adapter,
 				DECODER_SET_CHANNEL, &go->channel_number);
@@ -571,7 +580,7 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	struct go7007 *go;
 	int i;
 
-	go = kmalloc(sizeof(struct go7007), GFP_KERNEL);
+	go = kzalloc(sizeof(struct go7007), GFP_KERNEL);
 	if (go == NULL)
 		return NULL;
 	go->dev = dev;
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index b58c394..b7b939a 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -88,7 +88,7 @@ struct go7007_board_info {
 	int audio_bclk_div;
 	int audio_main_div;
 	int num_i2c_devs;
-	struct {
+	struct go_i2c {
 		const char *type;
 		int id;
 		int addr;
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 5443e25..9dbf5ec 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1110,9 +1110,6 @@ static int go7007_usb_probe(struct usb_interface *intf,
 			} else {
 				u16 channel;
 
-				/* set GPIO5 to be an output, currently low */
-				go7007_write_addr(go, 0x3c82, 0x0000);
-				go7007_write_addr(go, 0x3c80, 0x00df);
 				/* read channel number from GPIO[1:0] */
 				go7007_read_addr(go, 0x3c81, &channel);
 				channel &= 0x3;
@@ -1245,7 +1242,6 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 	struct urb *vurb, *aurb;
 	int i;
 
-	go->status = STATUS_SHUTDOWN;
 	usb_kill_urb(usb->intr_urb);
 
 	/* Free USB-related structs */
@@ -1269,6 +1265,7 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
 	kfree(go->hpi_context);
 
 	go7007_remove(go);
+	go->status = STATUS_SHUTDOWN;
 }
 
 static struct usb_driver go7007_usb_driver = {
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index c184ad3..b8f2eb6 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -98,7 +98,7 @@ static int go7007_open(struct file *file)
 
 	if (go->status != STATUS_ONLINE)
 		return -EBUSY;
-	gofh = kmalloc(sizeof(struct go7007_file), GFP_KERNEL);
+	gofh = kzalloc(sizeof(struct go7007_file), GFP_KERNEL);
 	if (gofh == NULL)
 		return -ENOMEM;
 	++go->ref_count;
@@ -953,6 +953,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 	}
 	mutex_unlock(&go->hw_lock);
 	mutex_unlock(&gofh->lock);
+	call_all(&go->v4l2_dev, video, s_stream, 1);
 
 	return retval;
 }
@@ -968,6 +969,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	mutex_lock(&gofh->lock);
 	go7007_streamoff(go);
 	mutex_unlock(&gofh->lock);
+	call_all(&go->v4l2_dev, video, s_stream, 0);
 
 	return 0;
 }
@@ -1832,5 +1834,6 @@ void go7007_v4l2_remove(struct go7007 *go)
 	mutex_unlock(&go->hw_lock);
 	if (go->video_dev)
 		video_unregister_device(go->video_dev);
-	v4l2_device_unregister(&go->v4l2_dev);
+	if (go->status != STATUS_SHUTDOWN)
+		v4l2_device_unregister(&go->v4l2_dev);
 }
diff --git a/drivers/staging/media/go7007/wis-saa7115.c b/drivers/staging/media/go7007/wis-saa7115.c
index 46cff59..9065cc7 100644
--- a/drivers/staging/media/go7007/wis-saa7115.c
+++ b/drivers/staging/media/go7007/wis-saa7115.c
@@ -21,10 +21,17 @@
 #include <linux/videodev2.h>
 #include <linux/ioctl.h>
 #include <linux/slab.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
 
 #include "wis-i2c.h"
 
 struct wis_saa7115 {
+  struct v4l2_subdev sd;
+  struct v4l2_ctrl_handler hdl;
 	int norm;
 	int brightness;
 	int contrast;
@@ -182,6 +189,15 @@ static u8 initial_registers[] =
 	0x00, 0x00, /* Terminator (reg 0x00 is read-only) */
 };
 
+static const struct v4l2_subdev_core_ops wis_saa7115_core_ops = {
+};
+
+static const struct v4l2_subdev_video_ops wis_saa7115_video_ops = {
+/*  .s_routing = tw2804_s_video_routing,
+  .s_mbus_fmt = tw2804_s_mbus_fmt,
+  .s_stream = tw2804_s_stream,*/
+};
+
 static int write_reg(struct i2c_client *client, u8 reg, u8 value)
 {
 	return i2c_smbus_write_byte_data(client, reg, value);
@@ -197,10 +213,16 @@ static int write_regs(struct i2c_client *client, u8 *regs)
 	return 0;
 }
 
+inline struct wis_saa7115 *to_state(struct v4l2_subdev *sd)
+{
+  return container_of(sd, struct wis_saa7115, sd);
+}
+
 static int wis_saa7115_command(struct i2c_client *client,
 				unsigned int cmd, void *arg)
 {
-	struct wis_saa7115 *dec = i2c_get_clientdata(client);
+  struct v4l2_subdev *sd = i2c_get_clientdata(client);
+  struct wis_saa7115 *dec = to_state(sd);
 
 	switch (cmd) {
 	case VIDIOC_S_INPUT:
@@ -395,11 +417,18 @@ static int wis_saa7115_command(struct i2c_client *client,
 	return 0;
 }
 
+static const struct v4l2_subdev_ops wis_saa7115_ops = {
+  .core = &wis_saa7115_core_ops,
+  .video = &wis_saa7115_video_ops,
+//  .video = &wis_sony_tuner_video_ops,
+};
+
 static int wis_saa7115_probe(struct i2c_client *client,
 			     const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct wis_saa7115 *dec;
+  struct v4l2_subdev *sd;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -ENODEV;
@@ -407,13 +436,14 @@ static int wis_saa7115_probe(struct i2c_client *client,
 	dec = kmalloc(sizeof(struct wis_saa7115), GFP_KERNEL);
 	if (dec == NULL)
 		return -ENOMEM;
+  sd = &dec->sd;
+  v4l2_i2c_subdev_init(sd, client, &wis_saa7115_ops);
 
 	dec->norm = V4L2_STD_NTSC;
 	dec->brightness = 128;
 	dec->contrast = 64;
 	dec->saturation = 64;
 	dec->hue = 0;
-	i2c_set_clientdata(client, dec);
 
 	printk(KERN_DEBUG
 		"wis-saa7115: initializing SAA7115 at address %d on %s\n",
@@ -431,8 +461,10 @@ static int wis_saa7115_probe(struct i2c_client *client,
 
 static int wis_saa7115_remove(struct i2c_client *client)
 {
-	struct wis_saa7115 *dec = i2c_get_clientdata(client);
+  struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct wis_saa7115 *dec = to_state(sd);
 
+  v4l2_device_unregister_subdev(sd);
 	kfree(dec);
 	return 0;
 }
diff --git a/drivers/staging/media/go7007/wis-sony-tuner.c b/drivers/staging/media/go7007/wis-sony-tuner.c
index 8f1b7d4..884a261 100644
--- a/drivers/staging/media/go7007/wis-sony-tuner.c
+++ b/drivers/staging/media/go7007/wis-sony-tuner.c
@@ -23,6 +23,9 @@
 #include <media/tuner.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
 
 #include "wis-i2c.h"
 
@@ -67,6 +70,8 @@ static struct sony_tunertype sony_tuners[] = {
 };
 
 struct wis_sony_tuner {
+  struct v4l2_subdev sd;
+  struct v4l2_ctrl_handler hdl;
 	int type;
 	v4l2_std_id std;
 	unsigned int freq;
@@ -74,10 +79,32 @@ struct wis_sony_tuner {
 	u32 audmode;
 };
 
+inline struct wis_sony_tuner *to_state(struct v4l2_subdev *sd)
+{
+  return container_of(sd, struct wis_sony_tuner, sd);
+}
+
+static const struct v4l2_subdev_tuner_ops wis_sony_tuner_ops = {
+};
+
+static const struct v4l2_subdev_core_ops wis_sony_core_ops = {
+/*  .log_status = wis_sony_tuner_log_status,
+  .g_chip_ident = wis_sony_tuner_g_chip_ident,
+  .g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
+  .try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
+  .s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
+  .g_ctrl = v4l2_subdev_g_ctrl,
+  .s_ctrl = v4l2_subdev_s_ctrl,
+  .queryctrl = v4l2_subdev_queryctrl,
+  .querymenu = v4l2_subdev_querymenu,
+  .s_std = wis_sony_tuner_s_std,*/
+};
+
 /* Basically the same as default_set_tv_freq() in tuner.c */
 static int set_freq(struct i2c_client *client, int freq)
 {
-	struct wis_sony_tuner *t = i2c_get_clientdata(client);
+  struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct wis_sony_tuner *t = to_state(sd);
 	char *band_name;
 	int n;
 	int band_select;
@@ -220,7 +247,8 @@ static struct {
 
 static int mpx_setup(struct i2c_client *client)
 {
-	struct wis_sony_tuner *t = i2c_get_clientdata(client);
+  struct v4l2_subdev *sd = i2c_get_clientdata(client);
+  struct wis_sony_tuner *t = to_state(sd);
 	u16 source = 0;
 	u8 buffer[3];
 	struct i2c_msg msg;
@@ -336,7 +364,8 @@ static int mpx_setup(struct i2c_client *client)
 
 static int set_if(struct i2c_client *client)
 {
-	struct wis_sony_tuner *t = i2c_get_clientdata(client);
+  struct v4l2_subdev *sd = i2c_get_clientdata(client);
+  struct wis_sony_tuner *t = to_state(sd);
 	u8 buffer[4];
 	struct i2c_msg msg;
 	int default_mpx_mode = 0;
@@ -384,7 +413,8 @@ static int set_if(struct i2c_client *client)
 
 static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 {
-	struct wis_sony_tuner *t = i2c_get_clientdata(client);
+  struct v4l2_subdev *sd = i2c_get_clientdata(client);
+  struct wis_sony_tuner *t = to_state(sd);
 
 	switch (cmd) {
 #if 0
@@ -654,24 +684,33 @@ static int tuner_command(struct i2c_client *client, unsigned int cmd, void *arg)
 	return 0;
 }
 
+
+static const struct v4l2_subdev_ops wis_sony_ops = {
+  .core = &wis_sony_core_ops,
+  .tuner = &wis_sony_tuner_ops,
+//  .video = &wis_sony_tuner_video_ops,
+};
+
 static int wis_sony_tuner_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
 	struct wis_sony_tuner *t;
+  struct v4l2_subdev *sd;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -ENODEV;
 
-	t = kmalloc(sizeof(struct wis_sony_tuner), GFP_KERNEL);
+	t = kzalloc(sizeof(struct wis_sony_tuner), GFP_KERNEL);
 	if (t == NULL)
 		return -ENOMEM;
+  sd = &t->sd;
+  v4l2_i2c_subdev_init(sd, client, &wis_sony_ops);
 
 	t->type = -1;
 	t->freq = 0;
 	t->mpxmode = 0;
 	t->audmode = V4L2_TUNER_MODE_STEREO;
-	i2c_set_clientdata(client, t);
 
 	printk(KERN_DEBUG
 		"wis-sony-tuner: initializing tuner at address %d on %s\n",
@@ -682,8 +721,10 @@ static int wis_sony_tuner_probe(struct i2c_client *client,
 
 static int wis_sony_tuner_remove(struct i2c_client *client)
 {
-	struct wis_sony_tuner *t = i2c_get_clientdata(client);
+  struct v4l2_subdev *sd = i2c_get_clientdata(client);
+  struct wis_sony_tuner *t = to_state(sd);
 
+  v4l2_device_unregister_subdev(sd);
 	kfree(t);
 	return 0;
 }
diff --git a/drivers/staging/media/go7007/wis-uda1342.c b/drivers/staging/media/go7007/wis-uda1342.c
index 0127be2..83aa1b9 100644
--- a/drivers/staging/media/go7007/wis-uda1342.c
+++ b/drivers/staging/media/go7007/wis-uda1342.c
@@ -18,9 +18,14 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/tvaudio.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
 
 #include "wis-i2c.h"
 
@@ -31,6 +36,9 @@ static int write_reg(struct i2c_client *client, int reg, int value)
 	return 0;
 }
 
+static const struct v4l2_subdev_audio_ops wis_uda1342_audio_ops = {
+};
+
 static int wis_uda1342_command(struct i2c_client *client,
 				unsigned int cmd, void *arg)
 {
@@ -59,10 +67,16 @@ static int wis_uda1342_command(struct i2c_client *client,
 	return 0;
 }
 
+static const struct v4l2_subdev_ops wis_uda1342_ops = {
+//  .core = &wis_uda1342_core_ops,
+  .audio = &wis_uda1342_audio_ops,
+};
+
 static int wis_uda1342_probe(struct i2c_client *client,
 			     const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = client->adapter;
+  struct v4l2_subdev *sd;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -ENODEV;
@@ -70,7 +84,11 @@ static int wis_uda1342_probe(struct i2c_client *client,
 	printk(KERN_DEBUG
 		"wis-uda1342: initializing UDA1342 at address %d on %s\n",
 		client->addr, adapter->name);
+  sd=kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+  if (sd == NULL)
+    return -ENOMEM;
 
+  v4l2_i2c_subdev_init(sd, client, &wis_uda1342_ops);
 	write_reg(client, 0x00, 0x8000); /* reset registers */
 	write_reg(client, 0x00, 0x1241); /* select input 1 */
 
@@ -79,6 +97,10 @@ static int wis_uda1342_probe(struct i2c_client *client,
 
 static int wis_uda1342_remove(struct i2c_client *client)
 {
+  struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+  v4l2_device_unregister_subdev(sd);
+  kfree(sd);
 	return 0;
 }
 

--CE+1k2dSO48ffgeK--
