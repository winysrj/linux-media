Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49654 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753764AbcKPQnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:14 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 29/35] [media] msp3400: convert it to use dev_foo() macros
Date: Wed, 16 Nov 2016 14:43:01 -0200
Message-Id: <0be07450654b7dcacf83ea3961a737633a0b886d.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using the v4l_foo() macros, just use the
kernel-wide dev_foo() macros, as there's no good reason
to use something else.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/i2c/msp3400-driver.c   |  54 ++++++++--------
 drivers/media/i2c/msp3400-kthreads.c | 115 +++++++++++++++++------------------
 2 files changed, 84 insertions(+), 85 deletions(-)

diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 8b5913188bc8..e0b962578a4a 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -146,11 +146,11 @@ int msp_reset(struct i2c_client *client)
 		},
 	};
 
-	v4l_dbg(3, msp_debug, client, "msp_reset\n");
+	dev_dbg_lvl(&client->dev, 3, msp_debug, "msp_reset\n");
 	if (i2c_transfer(client->adapter, &reset[0], 1) != 1 ||
 	    i2c_transfer(client->adapter, &reset[1], 1) != 1 ||
 	    i2c_transfer(client->adapter, test, 2) != 2) {
-		v4l_err(client, "chip reset failed\n");
+		dev_err(&client->dev, "chip reset failed\n");
 		return -1;
 	}
 	return 0;
@@ -182,17 +182,17 @@ static int msp_read(struct i2c_client *client, int dev, int addr)
 	for (err = 0; err < 3; err++) {
 		if (i2c_transfer(client->adapter, msgs, 2) == 2)
 			break;
-		v4l_warn(client, "I/O error #%d (read 0x%02x/0x%02x)\n", err,
+		dev_warn(&client->dev, "I/O error #%d (read 0x%02x/0x%02x)\n", err,
 		       dev, addr);
 		schedule_timeout_interruptible(msecs_to_jiffies(10));
 	}
 	if (err == 3) {
-		v4l_warn(client, "resetting chip, sound will go off.\n");
+		dev_warn(&client->dev, "resetting chip, sound will go off.\n");
 		msp_reset(client);
 		return -1;
 	}
 	retval = read[0] << 8 | read[1];
-	v4l_dbg(3, msp_debug, client, "msp_read(0x%x, 0x%x): 0x%x\n",
+	dev_dbg_lvl(&client->dev, 3, msp_debug, "msp_read(0x%x, 0x%x): 0x%x\n",
 			dev, addr, retval);
 	return retval;
 }
@@ -218,17 +218,17 @@ static int msp_write(struct i2c_client *client, int dev, int addr, int val)
 	buffer[3] = val  >> 8;
 	buffer[4] = val  &  0xff;
 
-	v4l_dbg(3, msp_debug, client, "msp_write(0x%x, 0x%x, 0x%x)\n",
+	dev_dbg_lvl(&client->dev, 3, msp_debug, "msp_write(0x%x, 0x%x, 0x%x)\n",
 			dev, addr, val);
 	for (err = 0; err < 3; err++) {
 		if (i2c_master_send(client, buffer, 5) == 5)
 			break;
-		v4l_warn(client, "I/O error #%d (write 0x%02x/0x%02x)\n", err,
+		dev_warn(&client->dev, "I/O error #%d (write 0x%02x/0x%02x)\n", err,
 		       dev, addr);
 		schedule_timeout_interruptible(msecs_to_jiffies(10));
 	}
 	if (err == 3) {
-		v4l_warn(client, "resetting chip, sound will go off.\n");
+		dev_warn(&client->dev, "resetting chip, sound will go off.\n");
 		msp_reset(client);
 		return -1;
 	}
@@ -301,7 +301,7 @@ void msp_set_scart(struct i2c_client *client, int in, int out)
 	} else
 		state->acb = 0xf60; /* Mute Input and SCART 1 Output */
 
-	v4l_dbg(1, msp_debug, client, "scart switch: %s => %d (ACB=0x%04x)\n",
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "scart switch: %s => %d (ACB=0x%04x)\n",
 					scart_names[in], out, state->acb);
 	msp_write_dsp(client, 0x13, state->acb);
 
@@ -359,7 +359,7 @@ static int msp_s_ctrl(struct v4l2_ctrl *ctrl)
 		if (!reallymuted)
 			val = (val * 0x7f / 65535) << 8;
 
-		v4l_dbg(1, msp_debug, client, "mute=%s scanning=%s volume=%d\n",
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "mute=%s scanning=%s volume=%d\n",
 				state->muted->val ? "on" : "off",
 				state->scan_in_progress ? "yes" : "no",
 				state->volume->val);
@@ -426,7 +426,7 @@ static int msp_s_radio(struct v4l2_subdev *sd)
 	if (state->radio)
 		return 0;
 	state->radio = 1;
-	v4l_dbg(1, msp_debug, client, "switching to radio mode\n");
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "switching to radio mode\n");
 	state->watch_stereo = 0;
 	switch (state->opmode) {
 	case OPMODE_MANUAL:
@@ -461,7 +461,7 @@ static int msp_querystd(struct v4l2_subdev *sd, v4l2_std_id *id)
 
 	*id &= state->detected_std;
 
-	v4l_dbg(2, msp_debug, client,
+	dev_dbg_lvl(&client->dev, 2, msp_debug,
 		"detected standard: %s(0x%08Lx)\n",
 		msp_standard_std_name(state->std), state->detected_std);
 
@@ -555,7 +555,7 @@ static int msp_s_i2s_clock_freq(struct v4l2_subdev *sd, u32 freq)
 	struct msp_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	v4l_dbg(1, msp_debug, client, "Setting I2S speed to %d\n", freq);
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "Setting I2S speed to %d\n", freq);
 
 	switch (freq) {
 		case 1024000:
@@ -579,7 +579,7 @@ static int msp_log_status(struct v4l2_subdev *sd)
 
 	if (state->opmode == OPMODE_AUTOSELECT)
 		msp_detect_stereo(client);
-	v4l_info(client, "%s rev1 = 0x%04x rev2 = 0x%04x\n",
+	dev_info(&client->dev, "%s rev1 = 0x%04x rev2 = 0x%04x\n",
 			client->name, state->rev1, state->rev2);
 	snprintf(prefix, sizeof(prefix), "%s: Audio:    ", sd->name);
 	v4l2_ctrl_handler_log_status(&state->hdl, prefix);
@@ -596,23 +596,23 @@ static int msp_log_status(struct v4l2_subdev *sd)
 		default: p = "unknown"; break;
 	}
 	if (state->mode == MSP_MODE_EXTERN) {
-		v4l_info(client, "Mode:     %s\n", p);
+		dev_info(&client->dev, "Mode:     %s\n", p);
 	} else if (state->opmode == OPMODE_MANUAL) {
-		v4l_info(client, "Mode:     %s (%s%s)\n", p,
+		dev_info(&client->dev, "Mode:     %s (%s%s)\n", p,
 				(state->rxsubchans & V4L2_TUNER_SUB_STEREO) ? "stereo" : "mono",
 				(state->rxsubchans & V4L2_TUNER_SUB_LANG2) ? ", dual" : "");
 	} else {
 		if (state->opmode == OPMODE_AUTODETECT)
-			v4l_info(client, "Mode:     %s\n", p);
-		v4l_info(client, "Standard: %s (%s%s)\n",
+			dev_info(&client->dev, "Mode:     %s\n", p);
+		dev_info(&client->dev, "Standard: %s (%s%s)\n",
 				msp_standard_std_name(state->std),
 				(state->rxsubchans & V4L2_TUNER_SUB_STEREO) ? "stereo" : "mono",
 				(state->rxsubchans & V4L2_TUNER_SUB_LANG2) ? ", dual" : "");
 	}
-	v4l_info(client, "Audmode:  0x%04x\n", state->audmode);
-	v4l_info(client, "Routing:  0x%08x (input) 0x%08x (output)\n",
+	dev_info(&client->dev, "Audmode:  0x%04x\n", state->audmode);
+	dev_info(&client->dev, "Routing:  0x%08x (input) 0x%08x (output)\n",
 			state->route_in, state->route_out);
-	v4l_info(client, "ACB:      0x%04x\n", state->acb);
+	dev_info(&client->dev, "ACB:      0x%04x\n", state->acb);
 	return 0;
 }
 
@@ -620,7 +620,7 @@ static int msp_log_status(struct v4l2_subdev *sd)
 static int msp_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	v4l_dbg(1, msp_debug, client, "suspend\n");
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "suspend\n");
 	msp_reset(client);
 	return 0;
 }
@@ -628,7 +628,7 @@ static int msp_suspend(struct device *dev)
 static int msp_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	v4l_dbg(1, msp_debug, client, "resume\n");
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "resume\n");
 	msp_wake_thread(client);
 	return 0;
 }
@@ -696,7 +696,7 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		strlcpy(client->name, "msp3400", sizeof(client->name));
 
 	if (msp_reset(client) == -1) {
-		v4l_dbg(1, msp_debug, client, "msp3400 not found\n");
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "msp3400 not found\n");
 		return -ENODEV;
 	}
 
@@ -731,10 +731,10 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	state->rev1 = msp_read_dsp(client, 0x1e);
 	if (state->rev1 != -1)
 		state->rev2 = msp_read_dsp(client, 0x1f);
-	v4l_dbg(1, msp_debug, client, "rev1=0x%04x, rev2=0x%04x\n",
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "rev1=0x%04x, rev2=0x%04x\n",
 			state->rev1, state->rev2);
 	if (state->rev1 == -1 || (state->rev1 == 0 && state->rev2 == 0)) {
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 				"not an msp3400 (cannot read chip version)\n");
 		return -ENODEV;
 	}
@@ -865,7 +865,7 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		state->kthread = kthread_run(thread_func, client, "msp34xx");
 
 		if (IS_ERR(state->kthread))
-			v4l_warn(client, "kernel_thread() failed\n");
+			dev_warn(&client->dev, "kernel_thread() failed\n");
 		msp_wake_thread(client);
 	}
 	return 0;
diff --git a/drivers/media/i2c/msp3400-kthreads.c b/drivers/media/i2c/msp3400-kthreads.c
index 17120804fab7..eec7aa4c6f98 100644
--- a/drivers/media/i2c/msp3400-kthreads.c
+++ b/drivers/media/i2c/msp3400-kthreads.c
@@ -220,7 +220,7 @@ void msp3400c_set_mode(struct i2c_client *client, int mode)
 	int tuner = (state->route_in >> 3) & 1;
 	int i;
 
-	v4l_dbg(1, msp_debug, client, "set_mode: %d\n", mode);
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "set_mode: %d\n", mode);
 	state->mode = mode;
 	state->rxsubchans = V4L2_TUNER_SUB_MONO;
 
@@ -266,7 +266,7 @@ static void msp3400c_set_audmode(struct i2c_client *client)
 		/* this method would break everything, let's make sure
 		 * it's never called
 		 */
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"set_audmode called with mode=%d instead of set_source (ignored)\n",
 			state->audmode);
 		return;
@@ -295,7 +295,7 @@ static void msp3400c_set_audmode(struct i2c_client *client)
 	/* switch demodulator */
 	switch (state->mode) {
 	case MSP_MODE_FM_TERRA:
-		v4l_dbg(1, msp_debug, client, "FM set_audmode: %s\n", modestr);
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "FM set_audmode: %s\n", modestr);
 		switch (audmode) {
 		case V4L2_TUNER_MODE_STEREO:
 			msp_write_dsp(client, 0x000e, 0x3001);
@@ -309,7 +309,7 @@ static void msp3400c_set_audmode(struct i2c_client *client)
 		}
 		break;
 	case MSP_MODE_FM_SAT:
-		v4l_dbg(1, msp_debug, client, "SAT set_audmode: %s\n", modestr);
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "SAT set_audmode: %s\n", modestr);
 		switch (audmode) {
 		case V4L2_TUNER_MODE_MONO:
 			msp3400c_set_carrier(client, MSP_CARRIER(6.5), MSP_CARRIER(6.5));
@@ -329,31 +329,31 @@ static void msp3400c_set_audmode(struct i2c_client *client)
 	case MSP_MODE_FM_NICAM1:
 	case MSP_MODE_FM_NICAM2:
 	case MSP_MODE_AM_NICAM:
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"NICAM set_audmode: %s\n", modestr);
 		if (state->nicam_on)
 			src = 0x0100;  /* NICAM */
 		break;
 	case MSP_MODE_BTSC:
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"BTSC set_audmode: %s\n", modestr);
 		break;
 	case MSP_MODE_EXTERN:
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"extern set_audmode: %s\n", modestr);
 		src = 0x0200;  /* SCART */
 		break;
 	case MSP_MODE_FM_RADIO:
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"FM-Radio set_audmode: %s\n", modestr);
 		break;
 	default:
-		v4l_dbg(1, msp_debug, client, "mono set_audmode\n");
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "mono set_audmode\n");
 		return;
 	}
 
 	/* switch audio */
-	v4l_dbg(1, msp_debug, client, "set audmode %d\n", audmode);
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "set audmode %d\n", audmode);
 	switch (audmode) {
 	case V4L2_TUNER_MODE_STEREO:
 	case V4L2_TUNER_MODE_LANG1_LANG2:
@@ -361,7 +361,7 @@ static void msp3400c_set_audmode(struct i2c_client *client)
 		break;
 	case V4L2_TUNER_MODE_MONO:
 		if (state->mode == MSP_MODE_AM_NICAM) {
-			v4l_dbg(1, msp_debug, client, "switching to AM mono\n");
+			dev_dbg_lvl(&client->dev, 1, msp_debug, "switching to AM mono\n");
 			/* AM mono decoding is handled by tuner, not MSP chip */
 			/* SCART switching control register */
 			msp_set_scart(client, SCART_MONO, 0);
@@ -377,7 +377,7 @@ static void msp3400c_set_audmode(struct i2c_client *client)
 		src |= 0x0010;
 		break;
 	}
-	v4l_dbg(1, msp_debug, client,
+	dev_dbg_lvl(&client->dev, 1, msp_debug,
 		"set_audmode final source/matrix = 0x%x\n", src);
 
 	msp_set_source(client, src);
@@ -388,23 +388,23 @@ static void msp3400c_print_mode(struct i2c_client *client)
 	struct msp_state *state = to_state(i2c_get_clientdata(client));
 
 	if (state->main == state->second)
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"mono sound carrier: %d.%03d MHz\n",
 			state->main / 910000, (state->main / 910) % 1000);
 	else
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"main sound carrier: %d.%03d MHz\n",
 			state->main / 910000, (state->main / 910) % 1000);
 	if (state->mode == MSP_MODE_FM_NICAM1 || state->mode == MSP_MODE_FM_NICAM2)
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"NICAM/FM carrier  : %d.%03d MHz\n",
 			state->second / 910000, (state->second/910) % 1000);
 	if (state->mode == MSP_MODE_AM_NICAM)
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"NICAM/AM carrier  : %d.%03d MHz\n",
 			state->second / 910000, (state->second / 910) % 1000);
 	if (state->mode == MSP_MODE_FM_TERRA && state->main != state->second) {
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"FM-stereo carrier : %d.%03d MHz\n",
 			state->second / 910000, (state->second / 910) % 1000);
 	}
@@ -425,7 +425,7 @@ static int msp3400c_detect_stereo(struct i2c_client *client)
 		val = msp_read_dsp(client, 0x18);
 		if (val > 32767)
 			val -= 65536;
-		v4l_dbg(2, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 2, msp_debug,
 			"stereo detect register: %d\n", val);
 		if (val > 8192) {
 			rxsubchans = V4L2_TUNER_SUB_STEREO;
@@ -440,7 +440,7 @@ static int msp3400c_detect_stereo(struct i2c_client *client)
 	case MSP_MODE_FM_NICAM2:
 	case MSP_MODE_AM_NICAM:
 		val = msp_read_dem(client, 0x23);
-		v4l_dbg(2, msp_debug, client, "nicam sync=%d, mode=%d\n",
+		dev_dbg_lvl(&client->dev, 2, msp_debug, "nicam sync=%d, mode=%d\n",
 			val & 1, (val & 0x1e) >> 1);
 
 		if (val & 1) {
@@ -471,14 +471,14 @@ static int msp3400c_detect_stereo(struct i2c_client *client)
 	}
 	if (rxsubchans != state->rxsubchans) {
 		update = 1;
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"watch: rxsubchans %02x => %02x\n",
 			state->rxsubchans, rxsubchans);
 		state->rxsubchans = rxsubchans;
 	}
 	if (newnicam != state->nicam_on) {
 		update = 1;
-		v4l_dbg(1, msp_debug, client, "watch: nicam %d => %d\n",
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "watch: nicam %d => %d\n",
 			state->nicam_on, newnicam);
 		state->nicam_on = newnicam;
 	}
@@ -508,23 +508,23 @@ int msp3400c_thread(void *data)
 	struct msp3400c_carrier_detect *cd;
 	int count, max1, max2, val1, val2, val, i;
 
-	v4l_dbg(1, msp_debug, client, "msp3400 daemon started\n");
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "msp3400 daemon started\n");
 	state->detected_std = V4L2_STD_ALL;
 	set_freezable();
 	for (;;) {
-		v4l_dbg(2, msp_debug, client, "msp3400 thread: sleep\n");
+		dev_dbg_lvl(&client->dev, 2, msp_debug, "msp3400 thread: sleep\n");
 		msp_sleep(state, -1);
-		v4l_dbg(2, msp_debug, client, "msp3400 thread: wakeup\n");
+		dev_dbg_lvl(&client->dev, 2, msp_debug, "msp3400 thread: wakeup\n");
 
 restart:
-		v4l_dbg(2, msp_debug, client, "thread: restart scan\n");
+		dev_dbg_lvl(&client->dev, 2, msp_debug, "thread: restart scan\n");
 		state->restart = 0;
 		if (kthread_should_stop())
 			break;
 
 		if (state->radio || MSP_MODE_EXTERN == state->mode) {
 			/* no carrier scan, just unmute */
-			v4l_dbg(1, msp_debug, client,
+			dev_dbg_lvl(&client->dev, 1, msp_debug,
 				"thread: no carrier scan\n");
 			state->scan_in_progress = 0;
 			msp_update_volume(state);
@@ -553,7 +553,7 @@ int msp3400c_thread(void *data)
 			/* autodetect doesn't work well with AM ... */
 			max1 = 3;
 			count = 0;
-			v4l_dbg(1, msp_debug, client, "AM sound override\n");
+			dev_dbg_lvl(&client->dev, 1, msp_debug, "AM sound override\n");
 		}
 
 		for (i = 0; i < count; i++) {
@@ -565,7 +565,7 @@ int msp3400c_thread(void *data)
 				val -= 65536;
 			if (val1 < val)
 				val1 = val, max1 = i;
-			v4l_dbg(1, msp_debug, client,
+			dev_dbg_lvl(&client->dev, 1, msp_debug,
 				"carrier1 val: %5d / %s\n", val, cd[i].name);
 		}
 
@@ -602,7 +602,7 @@ int msp3400c_thread(void *data)
 				val -= 65536;
 			if (val2 < val)
 				val2 = val, max2 = i;
-			v4l_dbg(1, msp_debug, client,
+			dev_dbg_lvl(&client->dev, 1, msp_debug,
 				"carrier2 val: %5d / %s\n", val, cd[i].name);
 		}
 
@@ -687,7 +687,7 @@ int msp3400c_thread(void *data)
 			watch_stereo(client);
 		}
 	}
-	v4l_dbg(1, msp_debug, client, "thread: exit\n");
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "thread: exit\n");
 	return 0;
 }
 
@@ -698,23 +698,23 @@ int msp3410d_thread(void *data)
 	struct msp_state *state = to_state(i2c_get_clientdata(client));
 	int val, i, std, count;
 
-	v4l_dbg(1, msp_debug, client, "msp3410 daemon started\n");
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "msp3410 daemon started\n");
 	state->detected_std = V4L2_STD_ALL;
 	set_freezable();
 	for (;;) {
-		v4l_dbg(2, msp_debug, client, "msp3410 thread: sleep\n");
+		dev_dbg_lvl(&client->dev, 2, msp_debug, "msp3410 thread: sleep\n");
 		msp_sleep(state, -1);
-		v4l_dbg(2, msp_debug, client, "msp3410 thread: wakeup\n");
+		dev_dbg_lvl(&client->dev, 2, msp_debug, "msp3410 thread: wakeup\n");
 
 restart:
-		v4l_dbg(2, msp_debug, client, "thread: restart scan\n");
+		dev_dbg_lvl(&client->dev, 2, msp_debug, "thread: restart scan\n");
 		state->restart = 0;
 		if (kthread_should_stop())
 			break;
 
 		if (state->mode == MSP_MODE_EXTERN) {
 			/* no carrier scan needed, just unmute */
-			v4l_dbg(1, msp_debug, client,
+			dev_dbg_lvl(&client->dev, 1, msp_debug,
 				"thread: no carrier scan\n");
 			state->scan_in_progress = 0;
 			msp_update_volume(state);
@@ -740,7 +740,7 @@ int msp3410d_thread(void *data)
 			goto restart;
 
 		if (msp_debug)
-			v4l_dbg(2, msp_debug, client,
+			dev_dbg_lvl(&client->dev, 2, msp_debug,
 				"setting standard: %s (0x%04x)\n",
 				msp_standard_std_name(std), std);
 
@@ -758,14 +758,14 @@ int msp3410d_thread(void *data)
 				val = msp_read_dem(client, 0x7e);
 				if (val < 0x07ff)
 					break;
-				v4l_dbg(2, msp_debug, client,
+				dev_dbg_lvl(&client->dev, 2, msp_debug,
 					"detection still in progress\n");
 			}
 		}
 		for (i = 0; msp_stdlist[i].name != NULL; i++)
 			if (msp_stdlist[i].retval == val)
 				break;
-		v4l_dbg(1, msp_debug, client, "current standard: %s (0x%04x)\n",
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "current standard: %s (0x%04x)\n",
 			msp_standard_std_name(val), val);
 		state->main   = msp_stdlist[i].main;
 		state->second = msp_stdlist[i].second;
@@ -775,8 +775,7 @@ int msp3410d_thread(void *data)
 		if (msp_amsound && !state->radio &&
 		    (state->v4l2_std & V4L2_STD_SECAM) && (val != 0x0009)) {
 			/* autodetection has failed, let backup */
-			v4l_dbg(1, msp_debug, client, "autodetection failed,"
-				" switching to backup standard: %s (0x%04x)\n",
+			dev_dbg_lvl(&client->dev, 1, msp_debug, "autodetection failed, switching to backup standard: %s (0x%04x)\n",
 				msp_stdlist[8].name ?
 					msp_stdlist[8].name : "unknown", val);
 			state->std = val = 0x0009;
@@ -850,7 +849,7 @@ int msp3410d_thread(void *data)
 			watch_stereo(client);
 		}
 	}
-	v4l_dbg(1, msp_debug, client, "thread: exit\n");
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "thread: exit\n");
 	return 0;
 }
 
@@ -867,23 +866,23 @@ static int msp34xxg_modus(struct i2c_client *client)
 	struct msp_state *state = to_state(i2c_get_clientdata(client));
 
 	if (state->radio) {
-		v4l_dbg(1, msp_debug, client, "selected radio modus\n");
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "selected radio modus\n");
 		return 0x0001;
 	}
 	if (state->v4l2_std == V4L2_STD_NTSC_M_JP) {
-		v4l_dbg(1, msp_debug, client, "selected M (EIA-J) modus\n");
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "selected M (EIA-J) modus\n");
 		return 0x4001;
 	}
 	if (state->v4l2_std == V4L2_STD_NTSC_M_KR) {
-		v4l_dbg(1, msp_debug, client, "selected M (A2) modus\n");
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "selected M (A2) modus\n");
 		return 0x0001;
 	}
 	if (state->v4l2_std == V4L2_STD_SECAM_L) {
-		v4l_dbg(1, msp_debug, client, "selected SECAM-L modus\n");
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "selected SECAM-L modus\n");
 		return 0x6001;
 	}
 	if (state->v4l2_std & V4L2_STD_MN) {
-		v4l_dbg(1, msp_debug, client, "selected M (BTSC) modus\n");
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "selected M (BTSC) modus\n");
 		return 0x2001;
 	}
 	return 0x7001;
@@ -927,7 +926,7 @@ static void msp34xxg_set_source(struct i2c_client *client, u16 reg, int in)
 	else
 		source = (in << 8) | matrix;
 
-	v4l_dbg(1, msp_debug, client,
+	dev_dbg_lvl(&client->dev, 1, msp_debug,
 		"set source to %d (0x%x) for output %02x\n", in, source, reg);
 	msp_write_dsp(client, reg, source);
 }
@@ -996,23 +995,23 @@ int msp34xxg_thread(void *data)
 	struct msp_state *state = to_state(i2c_get_clientdata(client));
 	int val, i;
 
-	v4l_dbg(1, msp_debug, client, "msp34xxg daemon started\n");
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "msp34xxg daemon started\n");
 	state->detected_std = V4L2_STD_ALL;
 	set_freezable();
 	for (;;) {
-		v4l_dbg(2, msp_debug, client, "msp34xxg thread: sleep\n");
+		dev_dbg_lvl(&client->dev, 2, msp_debug, "msp34xxg thread: sleep\n");
 		msp_sleep(state, -1);
-		v4l_dbg(2, msp_debug, client, "msp34xxg thread: wakeup\n");
+		dev_dbg_lvl(&client->dev, 2, msp_debug, "msp34xxg thread: wakeup\n");
 
 restart:
-		v4l_dbg(1, msp_debug, client, "thread: restart scan\n");
+		dev_dbg_lvl(&client->dev, 1, msp_debug, "thread: restart scan\n");
 		state->restart = 0;
 		if (kthread_should_stop())
 			break;
 
 		if (state->mode == MSP_MODE_EXTERN) {
 			/* no carrier scan needed, just unmute */
-			v4l_dbg(1, msp_debug, client,
+			dev_dbg_lvl(&client->dev, 1, msp_debug,
 				"thread: no carrier scan\n");
 			state->scan_in_progress = 0;
 			msp_update_volume(state);
@@ -1029,7 +1028,7 @@ int msp34xxg_thread(void *data)
 			goto unmute;
 
 		/* watch autodetect */
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"started autodetect, waiting for result\n");
 		for (i = 0; i < 10; i++) {
 			if (msp_sleep(state, 100))
@@ -1041,17 +1040,17 @@ int msp34xxg_thread(void *data)
 				state->std = val;
 				break;
 			}
-			v4l_dbg(2, msp_debug, client,
+			dev_dbg_lvl(&client->dev, 2, msp_debug,
 				"detection still in progress\n");
 		}
 		if (state->std == 1) {
-			v4l_dbg(1, msp_debug, client,
+			dev_dbg_lvl(&client->dev, 1, msp_debug,
 				"detection still in progress after 10 tries. giving up.\n");
 			continue;
 		}
 
 unmute:
-		v4l_dbg(1, msp_debug, client,
+		dev_dbg_lvl(&client->dev, 1, msp_debug,
 			"detected standard: %s (0x%04x)\n",
 			msp_standard_std_name(state->std), state->std);
 		state->detected_std = msp_standard_std(state->std);
@@ -1084,7 +1083,7 @@ int msp34xxg_thread(void *data)
 				goto restart;
 		}
 	}
-	v4l_dbg(1, msp_debug, client, "thread: exit\n");
+	dev_dbg_lvl(&client->dev, 1, msp_debug, "thread: exit\n");
 	return 0;
 }
 
@@ -1111,7 +1110,7 @@ static int msp34xxg_detect_stereo(struct i2c_client *client)
 			state->rxsubchans =
 				V4L2_TUNER_SUB_LANG1 | V4L2_TUNER_SUB_LANG2;
 	}
-	v4l_dbg(1, msp_debug, client,
+	dev_dbg_lvl(&client->dev, 1, msp_debug,
 		"status=0x%x, stereo=%d, bilingual=%d -> rxsubchans=%d\n",
 		status, is_stereo, is_bilingual, state->rxsubchans);
 	return (oldrx != state->rxsubchans);
-- 
2.7.4


