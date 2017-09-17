Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:51188 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751352AbdIQUSb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 16:18:31 -0400
Subject: [PATCH 2/8] [media] cx231xx: Adjust 56 checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Bhumika Goyal <bhumirks@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Johan Hovold <johan@kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Peter Rosin <peda@axentia.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Message-ID: <a928e43e-8b73-8d27-79a4-696540adae2b@users.sourceforge.net>
Date: Sun, 17 Sep 2017 22:17:51 +0200
MIME-Version: 1.0
In-Reply-To: <f2c1ca56-ecdc-318c-f18f-9bef6c670ffb@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 18:23:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/cx231xx/cx231xx-417.c   |  6 ++--
 drivers/media/usb/cx231xx/cx231xx-audio.c |  2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c | 16 +++++-----
 drivers/media/usb/cx231xx/cx231xx-core.c  | 20 ++++++------
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 51 ++++++++++++-------------------
 drivers/media/usb/cx231xx/cx231xx-vbi.c   |  6 ++--
 drivers/media/usb/cx231xx/cx231xx-video.c |  4 +--
 7 files changed, 45 insertions(+), 60 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index d538fa407742..d43345593172 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -954,13 +954,13 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 
 	p_current_fw = vmalloc(1884180 * 4);
 	p_fw = p_current_fw;
-	if (p_current_fw == NULL) {
+	if (!p_current_fw) {
 		dprintk(2, "FAIL!!!\n");
 		return -ENOMEM;
 	}
 
 	p_buffer = vmalloc(4096);
-	if (p_buffer == NULL) {
+	if (!p_buffer) {
 		dprintk(2, "FAIL!!!\n");
 		vfree(p_current_fw);
 		return -ENOMEM;
@@ -1711,7 +1711,7 @@ static int mpeg_open(struct file *file)
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	if (NULL == fh) {
+	if (!fh) {
 		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index 06f10d7fc4b0..f98ba0c66f8f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -745,7 +745,7 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 
 static int cx231xx_audio_fini(struct cx231xx *dev)
 {
-	if (dev == NULL)
+	if (!dev)
 		return 0;
 
 	if (dev->has_alsa_audio != 1) {
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index e0daa9b6c2a0..d204f220dfe5 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1156,7 +1156,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 					cx231xx_get_i2c_adap(dev, I2C_0),
 					"cx25840", 0x88 >> 1, NULL);
-		if (dev->sd_cx25840 == NULL)
+		if (!dev->sd_cx25840)
 			dev_err(dev->dev,
 				"cx25840 subdev registration failure\n");
 		cx25840_call(dev, core, load_fw);
@@ -1171,7 +1171,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 						    tuner_i2c,
 						    "tuner",
 						    dev->tuner_addr, NULL);
-		if (dev->sd_tuner == NULL)
+		if (!dev->sd_tuner)
 			dev_err(dev->dev,
 				"tuner subdev registration failure\n");
 		else
@@ -1190,7 +1190,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 			};
 			struct eeprom *e = kzalloc(sizeof(*e), GFP_KERNEL);
 
-			if (e == NULL) {
+			if (!e) {
 				dev_err(dev->dev,
 					"failed to allocate memory to read eeprom\n");
 				break;
@@ -1471,7 +1471,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 		 dev->video_mode.num_alt);
 
 	dev->video_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->video_mode.num_alt, GFP_KERNEL);
-	if (dev->video_mode.alt_max_pkt_size == NULL)
+	if (!dev->video_mode.alt_max_pkt_size)
 		return -ENOMEM;
 
 	for (i = 0; i < dev->video_mode.num_alt; i++) {
@@ -1512,7 +1512,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 
 	/* compute alternate max packet sizes for vbi */
 	dev->vbi_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->vbi_mode.num_alt, GFP_KERNEL);
-	if (dev->vbi_mode.alt_max_pkt_size == NULL)
+	if (!dev->vbi_mode.alt_max_pkt_size)
 		return -ENOMEM;
 
 	for (i = 0; i < dev->vbi_mode.num_alt; i++) {
@@ -1554,7 +1554,7 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 		 dev->sliced_cc_mode.end_point_addr,
 		 dev->sliced_cc_mode.num_alt);
 	dev->sliced_cc_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->sliced_cc_mode.num_alt, GFP_KERNEL);
-	if (dev->sliced_cc_mode.alt_max_pkt_size == NULL)
+	if (!dev->sliced_cc_mode.alt_max_pkt_size)
 		return -ENOMEM;
 
 	for (i = 0; i < dev->sliced_cc_mode.num_alt; i++) {
@@ -1618,7 +1618,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 
 	/* allocate memory for our device state and initialize it */
 	dev = devm_kzalloc(&udev->dev, sizeof(*dev), GFP_KERNEL);
-	if (dev == NULL) {
+	if (!dev) {
 		retval = -ENOMEM;
 		goto err_if;
 	}
@@ -1748,7 +1748,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 			 dev->ts1_mode.num_alt);
 
 		dev->ts1_mode.alt_max_pkt_size = devm_kmalloc_array(&udev->dev, 32, dev->ts1_mode.num_alt, GFP_KERNEL);
-		if (dev->ts1_mode.alt_max_pkt_size == NULL) {
+		if (!dev->ts1_mode.alt_max_pkt_size) {
 			retval = -ENOMEM;
 			goto err_video_alt;
 		}
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index d9f4ae50e869..76ce18cf2383 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -69,9 +69,9 @@ static DEFINE_MUTEX(cx231xx_devlist_mutex);
 */
 void cx231xx_remove_from_devlist(struct cx231xx *dev)
 {
-	if (dev == NULL)
+	if (!dev)
 		return;
-	if (dev->udev == NULL)
+	if (!dev->udev)
 		return;
 
 	if (atomic_read(&dev->devlist_count) > 0) {
@@ -508,7 +508,7 @@ int cx231xx_set_video_alternate(struct cx231xx *dev)
 		cx231xx_coredbg("minimum isoc packet size: %u (alt=%d)\n",
 				min_pkt_size, dev->video_mode.alt);
 
-		if (dev->video_mode.alt_max_pkt_size != NULL)
+		if (dev->video_mode.alt_max_pkt_size)
 			dev->video_mode.max_pkt_size =
 			dev->video_mode.alt_max_pkt_size[dev->video_mode.alt];
 		cx231xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
@@ -539,7 +539,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 		    dev->current_pcb_config.hs_config_info[0].interface_info.
 		    ts1_index + 1;
 		dev->ts1_mode.alt = alt;
-		if (dev->ts1_mode.alt_max_pkt_size != NULL)
+		if (dev->ts1_mode.alt_max_pkt_size)
 			max_pkt_size = dev->ts1_mode.max_pkt_size =
 			    dev->ts1_mode.alt_max_pkt_size[dev->ts1_mode.alt];
 		break;
@@ -553,7 +553,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 		    dev->current_pcb_config.hs_config_info[0].interface_info.
 		    audio_index + 1;
 		dev->adev.alt = alt;
-		if (dev->adev.alt_max_pkt_size != NULL)
+		if (dev->adev.alt_max_pkt_size)
 			max_pkt_size = dev->adev.max_pkt_size =
 			    dev->adev.alt_max_pkt_size[dev->adev.alt];
 		break;
@@ -562,7 +562,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 		    dev->current_pcb_config.hs_config_info[0].interface_info.
 		    video_index + 1;
 		dev->video_mode.alt = alt;
-		if (dev->video_mode.alt_max_pkt_size != NULL)
+		if (dev->video_mode.alt_max_pkt_size)
 			max_pkt_size = dev->video_mode.max_pkt_size =
 			    dev->video_mode.alt_max_pkt_size[dev->video_mode.
 							     alt];
@@ -574,7 +574,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 		    dev->current_pcb_config.hs_config_info[0].interface_info.
 		    vanc_index + 1;
 		dev->vbi_mode.alt = alt;
-		if (dev->vbi_mode.alt_max_pkt_size != NULL)
+		if (dev->vbi_mode.alt_max_pkt_size)
 			max_pkt_size = dev->vbi_mode.max_pkt_size =
 			    dev->vbi_mode.alt_max_pkt_size[dev->vbi_mode.alt];
 		break;
@@ -583,7 +583,7 @@ int cx231xx_set_alt_setting(struct cx231xx *dev, u8 index, u8 alt)
 		    dev->current_pcb_config.hs_config_info[0].interface_info.
 		    hanc_index + 1;
 		dev->sliced_cc_mode.alt = alt;
-		if (dev->sliced_cc_mode.alt_max_pkt_size != NULL)
+		if (dev->sliced_cc_mode.alt_max_pkt_size)
 			max_pkt_size = dev->sliced_cc_mode.max_pkt_size =
 			    dev->sliced_cc_mode.alt_max_pkt_size[dev->
 								 sliced_cc_mode.
@@ -768,7 +768,7 @@ int cx231xx_ep5_bulkout(struct cx231xx *dev, u8 *firmware, u16 size)
 	u32 *buffer;
 
 	buffer = kzalloc(4096, GFP_KERNEL);
-	if (buffer == NULL)
+	if (!buffer)
 		return -ENOMEM;
 	memcpy(&buffer[0], firmware, 4096);
 
@@ -1009,7 +1009,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	cx231xx_uninit_isoc(dev);
 
 	dma_q->p_left_data = kzalloc(4096, GFP_KERNEL);
-	if (dma_q->p_left_data == NULL)
+	if (!dma_q->p_left_data)
 		return -ENOMEM;
 
 	dev->video_mode.isoc_ctl.isoc_copy = isoc_copy;
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 248b62e2099c..0813f368fb3c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -408,11 +408,10 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
 
 int cx231xx_set_analog_freq(struct cx231xx *dev, u32 freq)
 {
-	if ((dev->dvb != NULL) && (dev->dvb->frontend != NULL)) {
-
+	if (dev->dvb && dev->dvb->frontend) {
 		struct dvb_tuner_ops *dops = &dev->dvb->frontend->ops.tuner_ops;
 
-		if (dops->set_analog_params != NULL) {
+		if (dops->set_analog_params) {
 			struct analog_parameters params;
 
 			params.frequency = freq;
@@ -433,12 +432,10 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev)
 {
 	int status = 0;
 
-	if ((dev->dvb != NULL) && (dev->dvb->frontend != NULL)) {
-
+	if (dev->dvb && dev->dvb->frontend) {
 		struct dvb_tuner_ops *dops = &dev->dvb->frontend->ops.tuner_ops;
 
-		if (dops->init != NULL && !dev->xc_fw_load_done) {
-
+		if (dops->init && !dev->xc_fw_load_done) {
 			dev_dbg(dev->dev,
 				"Reloading firmware for XC5000\n");
 			status = dops->init(dev->dvb->frontend);
@@ -635,8 +632,7 @@ static int dvb_init(struct cx231xx *dev)
 		dev->dvb->frontend = dvb_attach(s5h1432_attach,
 					&dvico_s5h1432_config,
 					demod_i2c);
-
-		if (dev->dvb->frontend == NULL) {
+		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach s5h1432 front end\n");
 			result = -EINVAL;
@@ -660,8 +656,7 @@ static int dvb_init(struct cx231xx *dev)
 		dev->dvb->frontend = dvb_attach(s5h1411_attach,
 					       &xc5000_s5h1411_config,
 					       demod_i2c);
-
-		if (dev->dvb->frontend == NULL) {
+		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach s5h1411 front end\n");
 			result = -EINVAL;
@@ -683,8 +678,7 @@ static int dvb_init(struct cx231xx *dev)
 		dev->dvb->frontend = dvb_attach(s5h1432_attach,
 					&dvico_s5h1432_config,
 					demod_i2c);
-
-		if (dev->dvb->frontend == NULL) {
+		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach s5h1432 front end\n");
 			result = -EINVAL;
@@ -707,8 +701,7 @@ static int dvb_init(struct cx231xx *dev)
 		dev->dvb->frontend = dvb_attach(s5h1411_attach,
 					       &tda18271_s5h1411_config,
 					       demod_i2c);
-
-		if (dev->dvb->frontend == NULL) {
+		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach s5h1411 front end\n");
 			result = -EINVAL;
@@ -734,8 +727,7 @@ static int dvb_init(struct cx231xx *dev)
 		dev->dvb->frontend = dvb_attach(lgdt3305_attach,
 						&hcw_lgdt3305_config,
 						demod_i2c);
-
-		if (dev->dvb->frontend == NULL) {
+		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach LG3305 front end\n");
 			result = -EINVAL;
@@ -768,7 +760,7 @@ static int dvb_init(struct cx231xx *dev)
 		info.platform_data = &si2165_pdata;
 		request_module(info.type);
 		client = i2c_new_device(demod_i2c, &info);
-		if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend == NULL) {
+		if (!client || !client->dev.driver || !dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach SI2165 front end\n");
 			result = -EINVAL;
@@ -815,7 +807,7 @@ static int dvb_init(struct cx231xx *dev)
 		info.platform_data = &si2165_pdata;
 		request_module(info.type);
 		client = i2c_new_device(demod_i2c, &info);
-		if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend == NULL) {
+		if (!client || !client->dev.driver || !dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach SI2165 front end\n");
 			result = -EINVAL;
@@ -853,7 +845,7 @@ static int dvb_init(struct cx231xx *dev)
 		client = i2c_new_device(
 			tuner_i2c,
 			&info);
-		if (client == NULL || client->dev.driver == NULL) {
+		if (!client || !client->dev.driver) {
 			dvb_frontend_detach(dev->dvb->frontend);
 			result = -ENODEV;
 			goto out_free;
@@ -883,8 +875,7 @@ static int dvb_init(struct cx231xx *dev)
 			&hauppauge_955q_lgdt3306a_config,
 			demod_i2c
 			);
-
-		if (dev->dvb->frontend == NULL) {
+		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach LGDT3306A frontend.\n");
 			result = -EINVAL;
@@ -912,7 +903,7 @@ static int dvb_init(struct cx231xx *dev)
 		client = i2c_new_device(
 			tuner_i2c,
 			&info);
-		if (client == NULL || client->dev.driver == NULL) {
+		if (!client || !client->dev.driver) {
 			dvb_frontend_detach(dev->dvb->frontend);
 			result = -ENODEV;
 			goto out_free;
@@ -940,8 +931,7 @@ static int dvb_init(struct cx231xx *dev)
 		dev->dvb->frontend = dvb_attach(mb86a20s_attach,
 						&pv_mb86a20s_config,
 						demod_i2c);
-
-		if (dev->dvb->frontend == NULL) {
+		if (!dev->dvb->frontend) {
 			dev_err(dev->dev,
 				"Failed to attach mb86a20s demod\n");
 			result = -EINVAL;
@@ -976,8 +966,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		request_module(info.type);
 		client = i2c_new_device(demod_i2c, &info);
-
-		if (client == NULL || client->dev.driver == NULL) {
+		if (!client || !client->dev.driver) {
 			result = -ENODEV;
 			goto out_free;
 		}
@@ -1005,8 +994,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		request_module(info.type);
 		client = i2c_new_device(tuner_i2c, &info);
-
-		if (client == NULL || client->dev.driver == NULL) {
+		if (!client || !client->dev.driver) {
 			module_put(dvb->i2c_client_demod->dev.driver->owner);
 			i2c_unregister_device(dvb->i2c_client_demod);
 			result = -ENODEV;
@@ -1042,8 +1030,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		request_module(info.type);
 		client = i2c_new_device(demod_i2c, &info);
-
-		if (client == NULL || client->dev.driver == NULL) {
+		if (!client || !client->dev.driver) {
 			result = -ENODEV;
 			goto out_free;
 		}
@@ -1071,7 +1058,7 @@ static int dvb_init(struct cx231xx *dev)
 			dev->name);
 		break;
 	}
-	if (NULL == dvb->frontend) {
+	if (!dvb->frontend) {
 		dev_err(dev->dev,
 		       "%s/2: frontend initialization failed\n", dev->name);
 		result = -EINVAL;
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 9c27db16db2a..8ec53017da2b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -630,8 +630,7 @@ void cx231xx_reset_vbi_buffer(struct cx231xx *dev,
 	struct cx231xx_buffer *buf;
 
 	buf = dev->vbi_mode.bulk_ctl.buf;
-
-	if (buf == NULL) {
+	if (!buf) {
 		/* first try to get the buffer */
 		get_next_vbi_buf(dma_q, &buf);
 
@@ -654,8 +653,7 @@ int cx231xx_do_vbi_copy(struct cx231xx *dev, struct cx231xx_dmaqueue *dma_q,
 	int offset, lencopy;
 
 	buf = dev->vbi_mode.bulk_ctl.buf;
-
-	if (buf == NULL)
+	if (!buf)
 		return -EINVAL;
 
 	p_out_buffer = videobuf_to_vmalloc(&buf->vb);
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 179b8481a870..956f8cbcb454 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -634,7 +634,7 @@ void cx231xx_reset_video_buffer(struct cx231xx *dev,
 	else
 		buf = dev->video_mode.bulk_ctl.buf;
 
-	if (buf == NULL) {
+	if (!buf) {
 		/* first try to get the buffer */
 		get_next_buf(dma_q, &buf);
 
@@ -663,7 +663,7 @@ int cx231xx_do_copy(struct cx231xx *dev, struct cx231xx_dmaqueue *dma_q,
 	else
 		buf = dev->video_mode.bulk_ctl.buf;
 
-	if (buf == NULL)
+	if (!buf)
 		return -1;
 
 	p_out_buffer = videobuf_to_vmalloc(&buf->vb);
-- 
2.14.1
