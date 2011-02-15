Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:29323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1BONgy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 08:36:54 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1FDasev030793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 08:36:54 -0500
Received: from pedra (vpn-239-107.phx2.redhat.com [10.3.239.107])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1FDXmP2005481
	for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 08:36:53 -0500
Date: Tue, 15 Feb 2011 11:33:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/4] [media] tuner-core: Improve function documentation
Message-ID: <20110215113335.08107b84@pedra>
In-Reply-To: <cover.1297776328.git.mchehab@redhat.com>
References: <cover.1297776328.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This driver is complex, and used by everyone. Better to have it
properly documented.

No functional changes are done in this patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 5e1437c..2c7fe18 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1,7 +1,17 @@
 /*
- *
  * i2c tv tuner chip device driver
  * core core, i.e. kernel interfaces, registering and so on
+ *
+ * Copyright(c) by Ralph Metzler, Gerd Knorr, Gunther Mayer
+ *
+ * Copyright(c) 2005-2011 by Mauro Carvalho Chehab
+ *	- Added support for a separate Radio tuner
+ *	- Major rework and cleanups at the code
+ *
+ * This driver supports many devices and the idea is to let the driver
+ * detect which device is present. So rather than listing all supported
+ * devices here, we pretend to support a single, fake device type that will
+ * handle both radio and analog TV tuning.
  */
 
 #include <linux/module.h>
@@ -67,6 +77,7 @@ module_param_string(ntsc, ntsc, sizeof(ntsc), 0644);
  */
 
 static LIST_HEAD(tuner_list);
+static const struct v4l2_subdev_ops tuner_ops;
 
 /*
  * Debug macros
@@ -125,6 +136,13 @@ struct tuner {
 };
 
 /*
+ * Function prototypes
+ */
+
+static void set_tv_freq(struct i2c_client *c, unsigned int freq);
+static void set_radio_freq(struct i2c_client *c, unsigned int freq);
+
+/*
  * tuner attach/detach logic
  */
 
@@ -233,13 +251,24 @@ static struct analog_demod_ops tuner_analog_ops = {
 };
 
 /*
- * Functions that are common to both TV and radio
+ * Functions to select between radio and TV and tuner probe functions
  */
 
-static void set_tv_freq(struct i2c_client *c, unsigned int freq);
-static void set_radio_freq(struct i2c_client *c, unsigned int freq);
-static const struct v4l2_subdev_ops tuner_ops;
-
+/**
+ * set_type - Sets the tuner type for a given device
+ *
+ * @c:			i2c_client descriptoy
+ * @type:		type of the tuner (e. g. tuner number)
+ * @new_mode_mask:	Indicates if tuner supports TV and/or Radio
+ * @new_config:		an optional parameter ranging from 0-255 used by
+			a few tuners to adjust an internal parameter,
+			like LNA mode
+ * @tuner_callback:	an optional function to be called when switching
+ *			to analog mode
+ *
+ * This function applys the tuner config to tuner specified
+ * by tun_setup structure. It contains several per-tuner initialization "magic"
+ */
 static void set_type(struct i2c_client *c, unsigned int type,
 		     unsigned int new_mode_mask, unsigned int new_config,
 		     int (*tuner_callback) (void *dev, int component, int cmd, int arg))
@@ -452,6 +481,15 @@ static int tuner_s_type_addr(struct v4l2_subdev *sd,
 	return 0;
 }
 
+/**
+ * tuner_s_config - Sets tuner configuration
+ *
+ * @sd:		subdev descriptor
+ * @cfg:	tuner configuration
+ *
+ * Calls tuner set_config() private function to set some tuner-internal
+ * parameters
+ */
 static int tuner_s_config(struct v4l2_subdev *sd,
 			  const struct v4l2_priv_tun_config *cfg)
 {
@@ -470,10 +508,20 @@ static int tuner_s_config(struct v4l2_subdev *sd,
 	return 0;
 }
 
-/* Search for existing radio and/or TV tuners on the given I2C adapter.
-   Note that when this function is called from tuner_probe you can be
-   certain no other devices will be added/deleted at the same time, I2C
-   core protects against that. */
+/**
+ * tuner_lookup - Seek for tuner adapters
+ *
+ * @adap:	i2c_adapter struct
+ * @radio:	pointer to be filled if the adapter is radio
+ * @tv:		pointer to be filled if the adapter is TV
+ *
+ * Search for existing radio and/or TV tuners on the given I2C adapter,
+ * discarding demod-only adapters (tda9887).
+ *
+ * Note that when this function is called from tuner_probe you can be
+ * certain no other devices will be added/deleted at the same time, I2C
+ * core protects against that.
+ */
 static void tuner_lookup(struct i2c_adapter *adap,
 		struct tuner **radio, struct tuner **tv)
 {
@@ -502,8 +550,20 @@ static void tuner_lookup(struct i2c_adapter *adap,
 	}
 }
 
-/* During client attach, set_type is called by adapter's attach_inform callback.
-   set_type must then be completed by tuner_probe.
+/**
+ *tuner_probe - Probes the existing tuners on an I2C bus
+ *
+ * @client:	i2c_client descriptor
+ * @id:		not used
+ *
+ * This routine probes for tuners at the expected I2C addresses. On most
+ * cases, if a device answers to a given I2C address, it assumes that the
+ * device is a tuner. On a few cases, however, an additional logic is needed
+ * to double check if the device is really a tuner, or to identify the tuner
+ * type, like on tea5767/5761 devices.
+ *
+ * During client attach, set_type is called by adapter's attach_inform callback.
+ * set_type must then be completed by tuner_probe.
  */
 static int tuner_probe(struct i2c_client *client,
 		       const struct i2c_device_id *id)
@@ -618,6 +678,12 @@ register_client:
 	return 0;
 }
 
+/**
+ * tuner_remove - detaches a tuner
+ *
+ * @client:	i2c_client descriptor
+ */
+
 static int tuner_remove(struct i2c_client *client)
 {
 	struct tuner *t = to_tuner(i2c_get_clientdata(client));
@@ -635,7 +701,12 @@ static int tuner_remove(struct i2c_client *client)
  * Functions that are specific for TV mode
  */
 
-/* Set tuner frequency,  freq in Units of 62.5kHz = 1/16MHz */
+/**
+ * set_tv_freq - Set tuner frequency,  freq in Units of 62.5 kHz = 1/16MHz
+ *
+ * @c:	i2c_client descriptor
+ * @freq: frequency
+ */
 static void set_tv_freq(struct i2c_client *c, unsigned int freq)
 {
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
@@ -675,7 +746,19 @@ static void set_tv_freq(struct i2c_client *c, unsigned int freq)
 	analog_ops->set_params(&t->fe, &params);
 }
 
-/* get more precise norm info from insmod option */
+/**
+ * tuner_fixup_std - force a given video standard variant
+ *
+ * @t:	tuner internal struct
+ *
+ * A few devices or drivers have problem to detect some standard variations.
+ * On other operational systems, the drivers generally have a per-country
+ * code, and some logic to apply per-country hacks. V4L2 API doesn't provide
+ * such hacks. Instead, it relies on a proper video standard selection from
+ * the userspace application. However, as some apps are buggy, not allowing
+ * to distinguish all video standard variations, a modprobe parameter can
+ * be used to force a video standard match.
+ */
 static int tuner_fixup_std(struct tuner *t)
 {
 	if ((t->std & V4L2_STD_PAL) == V4L2_STD_PAL) {
@@ -797,6 +880,12 @@ static int tuner_fixup_std(struct tuner *t)
  * Functions that are specific for Radio mode
  */
 
+/**
+ * set_radio_freq - Set tuner frequency,  freq in Units of 62.5 Hz  = 1/16kHz
+ *
+ * @c:	i2c_client descriptor
+ * @freq: frequency
+ */
 static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 {
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
@@ -972,7 +1061,9 @@ static int tuner_s_power(struct v4l2_subdev *sd, int on)
 	return 0;
 }
 
-/* ---------------------------------------------------------------------- */
+/*
+ * Function to splicitly change mode to radio. Probably not needed anymore
+ */
 
 static int tuner_s_radio(struct v4l2_subdev *sd)
 {
@@ -984,9 +1075,10 @@ static int tuner_s_radio(struct v4l2_subdev *sd)
 	return 0;
 }
 
-/* --- v4l ioctls --- */
-/* take care: bttv does userspace copying, we'll get a
-   kernel pointer here... */
+/*
+ * Tuner callbacks to handle userspace ioctl's
+ */
+
 static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 {
 	struct tuner *t = to_tuner(sd);
@@ -1137,7 +1229,9 @@ static int tuner_command(struct i2c_client *client, unsigned cmd, void *arg)
 	return -ENOIOCTLCMD;
 }
 
-/* ----------------------------------------------------------------------- */
+/*
+ * Callback structs
+ */
 
 static const struct v4l2_subdev_core_ops tuner_core_ops = {
 	.log_status = tuner_log_status,
@@ -1160,11 +1254,10 @@ static const struct v4l2_subdev_ops tuner_ops = {
 	.tuner = &tuner_tuner_ops,
 };
 
-/* ----------------------------------------------------------------------- */
+/*
+ * I2C structs and module init functions
+ */
 
-/* This driver supports many devices and the idea is to let the driver
-   detect which device is present. So rather than listing all supported
-   devices here, we pretend to support a single, fake device type. */
 static const struct i2c_device_id tuner_id[] = {
 	{ "tuner", }, /* autodetect */
 	{ }
-- 
1.7.1


