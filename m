Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:36527 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751188AbeCIUMK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 15:12:10 -0500
Subject: [PATCH v3] [media] Use common error handling code in 19 functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Shyti <andi.shyti@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Brian Johnson <brijohn@gmail.com>,
        =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph@boehmwalder.at>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Daniele Nicolodi <daniele@grinta.net>,
        =?UTF-8?Q?David_H=c3=a4rdeman?= <david@hardeman.nu>,
        Devendra Sharma <devendra.sharma9091@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Mike Isely <isely@pobox.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Santosh Kumar Singh <kumar.san1093@gmail.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Sean Young <sean@mess.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Shyam Saini <mayhs11saini@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Todor Tomov <todor.tomov@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <227d2d7c-5aee-1190-1624-26596a048d9c@users.sourceforge.net>
Message-ID: <57ef3a56-2578-1d5f-1268-348b49b0c573@users.sourceforge.net>
Date: Fri, 9 Mar 2018 21:10:33 +0100
MIME-Version: 1.0
In-Reply-To: <227d2d7c-5aee-1190-1624-26596a048d9c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 9 Mar 2018 21:00:12 +0100

Adjust jump targets so that a bit of exception handling can be better
reused at the end of these functions.

This issue was partly detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---

v3:
Laurent Pinchart and Todor Tomov requested a few adjustments.
Updates were rebased on source files from Linux next-20180308.

v2:
Hans Verkuil insisted on patch squashing. Thus several changes
were recombined based on source files from Linux next-20180216.

The implementation of the function "tda8261_set_params" was improved
after a notification by Christoph Böhmwalder on 2017-09-26.

 drivers/media/dvb-core/dmxdev.c                    | 16 ++++----
 drivers/media/dvb-frontends/tda1004x.c             | 20 ++++++----
 drivers/media/dvb-frontends/tda8261.c              | 19 ++++++----
 drivers/media/pci/bt8xx/dst.c                      | 19 ++++++----
 drivers/media/pci/bt8xx/dst_ca.c                   | 30 +++++++--------
 drivers/media/pci/cx88/cx88-input.c                | 17 +++++----
 drivers/media/platform/omap3isp/ispvideo.c         | 28 ++++++--------
 .../media/platform/qcom/camss-8x16/camss-csid.c    | 19 +++++-----
 drivers/media/tuners/tuner-xc2028.c                | 30 +++++++--------
 drivers/media/usb/cpia2/cpia2_usb.c                | 13 ++++---
 drivers/media/usb/gspca/gspca.c                    | 17 +++++----
 drivers/media/usb/gspca/sn9c20x.c                  | 17 +++++----
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c         | 10 +++--
 drivers/media/usb/tm6000/tm6000-cards.c            |  7 ++--
 drivers/media/usb/tm6000/tm6000-dvb.c              | 11 ++++--
 drivers/media/usb/tm6000/tm6000-video.c            | 13 ++++---
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  | 13 +++----
 drivers/media/usb/ttusb-dec/ttusb_dec.c            | 43 ++++++++--------------
 18 files changed, 171 insertions(+), 171 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 61a750fae465..17d05b05fa9d 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -656,18 +656,18 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
 	tsfeed->priv = filter;
 
 	ret = tsfeed->set(tsfeed, feed->pid, ts_type, ts_pes, timeout);
-	if (ret < 0) {
-		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
-		return ret;
-	}
+	if (ret < 0)
+		goto release_feed;
 
 	ret = tsfeed->start_filtering(tsfeed);
-	if (ret < 0) {
-		dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
-		return ret;
-	}
+	if (ret < 0)
+		goto release_feed;
 
 	return 0;
+
+release_feed:
+	dmxdev->demux->release_ts_feed(dmxdev->demux, tsfeed);
+	return ret;
 }
 
 static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
diff --git a/drivers/media/dvb-frontends/tda1004x.c b/drivers/media/dvb-frontends/tda1004x.c
index 58e3beff5adc..85ca111fc8c4 100644
--- a/drivers/media/dvb-frontends/tda1004x.c
+++ b/drivers/media/dvb-frontends/tda1004x.c
@@ -1299,20 +1299,22 @@ struct dvb_frontend* tda10045_attach(const struct tda1004x_config* config,
 	id = tda1004x_read_byte(state, TDA1004X_CHIPID);
 	if (id < 0) {
 		printk(KERN_ERR "tda10045: chip is not answering. Giving up.\n");
-		kfree(state);
-		return NULL;
+		goto free_state;
 	}
 
 	if (id != 0x25) {
 		printk(KERN_ERR "Invalid tda1004x ID = 0x%02x. Can't proceed\n", id);
-		kfree(state);
-		return NULL;
+		goto free_state;
 	}
 
 	/* create dvb_frontend */
 	memcpy(&state->frontend.ops, &tda10045_ops, sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
 	return &state->frontend;
+
+free_state:
+	kfree(state);
+	return NULL;
 }
 
 static const struct dvb_frontend_ops tda10046_ops = {
@@ -1369,19 +1371,21 @@ struct dvb_frontend* tda10046_attach(const struct tda1004x_config* config,
 	id = tda1004x_read_byte(state, TDA1004X_CHIPID);
 	if (id < 0) {
 		printk(KERN_ERR "tda10046: chip is not answering. Giving up.\n");
-		kfree(state);
-		return NULL;
+		goto free_state;
 	}
 	if (id != 0x46) {
 		printk(KERN_ERR "Invalid tda1004x ID = 0x%02x. Can't proceed\n", id);
-		kfree(state);
-		return NULL;
+		goto free_state;
 	}
 
 	/* create dvb_frontend */
 	memcpy(&state->frontend.ops, &tda10046_ops, sizeof(struct dvb_frontend_ops));
 	state->frontend.demodulator_priv = state;
 	return &state->frontend;
+
+free_state:
+	kfree(state);
+	return NULL;
 }
 
 module_param(debug, int, 0644);
diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index f72a54e7eb23..7b9a29939b74 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -129,18 +129,17 @@ static int tda8261_set_params(struct dvb_frontend *fe)
 
 	/* Set params */
 	err = tda8261_write(state, buf);
-	if (err < 0) {
-		pr_err("%s: I/O Error\n", __func__);
-		return err;
-	}
+	if (err < 0)
+		goto report_failure;
+
 	/* sleep for some time */
 	pr_debug("%s: Waiting to Phase LOCK\n", __func__);
 	msleep(20);
 	/* check status */
-	if ((err = tda8261_get_status(fe, &status)) < 0) {
-		pr_err("%s: I/O Error\n", __func__);
-		return err;
-	}
+	err = tda8261_get_status(fe, &status);
+	if (err < 0)
+		goto report_failure;
+
 	if (status == 1) {
 		pr_debug("%s: Tuner Phase locked: status=%d\n", __func__,
 			 status);
@@ -150,6 +149,10 @@ static int tda8261_set_params(struct dvb_frontend *fe)
 	}
 
 	return 0;
+
+report_failure:
+	pr_err("%s: I/O Error\n", __func__);
+	return err;
 }
 
 static void tda8261_release(struct dvb_frontend *fe)
diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index 4f0bba9e4c48..7014cb6a0ad6 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -134,17 +134,20 @@ EXPORT_SYMBOL(rdc_reset_state);
 static int rdc_8820_reset(struct dst_state *state)
 {
 	dprintk(3, "Resetting DST\n");
-	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, 0, NO_DELAY) < 0) {
-		pr_err("dst_gpio_outb ERROR !\n");
-		return -1;
-	}
+	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, 0, NO_DELAY)
+	    < 0)
+		goto report_failure;
+
 	udelay(1000);
-	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET, RDC_8820_RESET, DELAY) < 0) {
-		pr_err("dst_gpio_outb ERROR !\n");
-		return -1;
-	}
+	if (dst_gpio_outb(state, RDC_8820_RESET, RDC_8820_RESET,
+			  RDC_8820_RESET, DELAY) < 0)
+		goto report_failure;
 
 	return 0;
+
+report_failure:
+	pr_err("dst_gpio_outb ERROR !\n");
+	return -1;
 }
 
 static int dst_pio_enable(struct dst_state *state)
diff --git a/drivers/media/pci/bt8xx/dst_ca.c b/drivers/media/pci/bt8xx/dst_ca.c
index 0a7623c0fc8e..26e05a8457e6 100644
--- a/drivers/media/pci/bt8xx/dst_ca.c
+++ b/drivers/media/pci/bt8xx/dst_ca.c
@@ -83,33 +83,33 @@ static int dst_ci_command(struct dst_state* state, u8 * data, u8 *ca_string, u8
 
 	if (write_dst(state, data, len)) {
 		dprintk(verbose, DST_CA_INFO, 1, " Write not successful, trying to recover");
-		dst_error_recovery(state);
-		goto error;
+		goto error_recovery;
 	}
 	if ((dst_pio_disable(state)) < 0) {
 		dprintk(verbose, DST_CA_ERROR, 1, " DST PIO disable failed.");
-		goto error;
-	}
-	if (read_dst(state, &reply, GET_ACK) < 0) {
-		dprintk(verbose, DST_CA_INFO, 1, " Read not successful, trying to recover");
-		dst_error_recovery(state);
-		goto error;
+		goto unlock;
 	}
+	if (read_dst(state, &reply, GET_ACK) < 0)
+		goto report_read_failure;
+
 	if (read) {
 		if (! dst_wait_dst_ready(state, LONG_DELAY)) {
 			dprintk(verbose, DST_CA_NOTICE, 1, " 8820 not ready");
-			goto error;
-		}
-		if (read_dst(state, ca_string, 128) < 0) {	/*	Try to make this dynamic	*/
-			dprintk(verbose, DST_CA_INFO, 1, " Read not successful, trying to recover");
-			dst_error_recovery(state);
-			goto error;
+			goto unlock;
 		}
+		/* Try to make this dynamic */
+		if (read_dst(state, ca_string, 128) < 0)
+			goto report_read_failure;
 	}
 	mutex_unlock(&state->dst_mutex);
 	return 0;
 
-error:
+report_read_failure:
+	dprintk(verbose, DST_CA_INFO, 1,
+		" Read not successful, trying to recover");
+error_recovery:
+	dst_error_recovery(state);
+unlock:
 	mutex_unlock(&state->dst_mutex);
 	return -EIO;
 }
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 6f4e6923a91a..9df9a8506c1f 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -566,20 +566,17 @@ static int get_key_pvr2000(struct IR_i2c *ir, enum rc_proto *protocol,
 
 	/* poll IR chip */
 	flags = i2c_smbus_read_byte_data(ir->c, 0x10);
-	if (flags < 0) {
-		dprintk("read error\n");
-		return 0;
-	}
+	if (flags < 0)
+		goto report_read_failure;
+
 	/* key pressed ? */
 	if (0 == (flags & 0x80))
 		return 0;
 
 	/* read actual key code */
 	code = i2c_smbus_read_byte_data(ir->c, 0x00);
-	if (code < 0) {
-		dprintk("read error\n");
-		return 0;
-	}
+	if (code < 0)
+		goto report_read_failure;
 
 	dprintk("IR Key/Flags: (0x%02x/0x%02x)\n",
 		code & 0xff, flags & 0xff);
@@ -588,6 +585,10 @@ static int get_key_pvr2000(struct IR_i2c *ir, enum rc_proto *protocol,
 	*scancode = code & 0xff;
 	*toggle = 0;
 	return 1;
+
+report_read_failure:
+	dprintk("read error\n");
+	return 0;
 }
 
 void cx88_i2c_init_ir(struct cx88_core *core)
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index a751c89a3ea8..038b8c5d058b 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1315,14 +1315,12 @@ static int isp_video_open(struct file *file)
 	/* If this is the first user, initialise the pipeline. */
 	if (omap3isp_get(video->isp) == NULL) {
 		ret = -EBUSY;
-		goto done;
+		goto error_delete_fh;
 	}
 
 	ret = v4l2_pipeline_pm_use(&video->video.entity, 1);
-	if (ret < 0) {
-		omap3isp_put(video->isp);
-		goto done;
-	}
+	if (ret < 0)
+		goto error_put_isp;
 
 	queue = &handle->queue;
 	queue->type = video->type;
@@ -1335,10 +1333,8 @@ static int isp_video_open(struct file *file)
 	queue->dev = video->isp->dev;
 
 	ret = vb2_queue_init(&handle->queue);
-	if (ret < 0) {
-		omap3isp_put(video->isp);
-		goto done;
-	}
+	if (ret < 0)
+		goto error_put_isp;
 
 	memset(&handle->format, 0, sizeof(handle->format));
 	handle->format.type = video->type;
@@ -1346,14 +1342,14 @@ static int isp_video_open(struct file *file)
 
 	handle->video = video;
 	file->private_data = &handle->vfh;
+	return 0;
 
-done:
-	if (ret < 0) {
-		v4l2_fh_del(&handle->vfh);
-		v4l2_fh_exit(&handle->vfh);
-		kfree(handle);
-	}
-
+error_put_isp:
+	omap3isp_put(video->isp);
+error_delete_fh:
+	v4l2_fh_del(&handle->vfh);
+	v4l2_fh_exit(&handle->vfh);
+	kfree(handle);
 	return ret;
 }
 
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.c b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
index 64df82817de3..5c790d8c1f80 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csid.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
@@ -328,16 +328,12 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 			return ret;
 
 		ret = csid_set_clock_rates(csid);
-		if (ret < 0) {
-			regulator_disable(csid->vdda);
-			return ret;
-		}
+		if (ret < 0)
+			goto disable_regulator;
 
 		ret = camss_enable_clocks(csid->nclocks, csid->clock, dev);
-		if (ret < 0) {
-			regulator_disable(csid->vdda);
-			return ret;
-		}
+		if (ret < 0)
+			goto disable_regulator;
 
 		enable_irq(csid->irq);
 
@@ -345,8 +341,7 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 		if (ret < 0) {
 			disable_irq(csid->irq);
 			camss_disable_clocks(csid->nclocks, csid->clock);
-			regulator_disable(csid->vdda);
-			return ret;
+			goto disable_regulator;
 		}
 
 		hw_version = readl_relaxed(csid->base + CAMSS_CSID_HW_VERSION);
@@ -358,6 +353,10 @@ static int csid_set_power(struct v4l2_subdev *sd, int on)
 	}
 
 	return ret;
+
+disable_regulator:
+	regulator_disable(csid->vdda);
+	return ret;
 }
 
 /*
diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index fca85e08ebd7..2199b04c0ba9 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -571,7 +571,7 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 		/* Checks if there's enough bytes to read */
 		if (p + sizeof(size) > endp) {
 			tuner_err("Firmware chunk size is wrong\n");
-			return -EINVAL;
+			goto e_inval;
 		}
 
 		size = le16_to_cpu(*(__le16 *) p);
@@ -583,28 +583,23 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 		if (!size) {
 			/* Special callback command received */
 			rc = do_tuner_callback(fe, XC2028_TUNER_RESET, 0);
-			if (rc < 0) {
-				tuner_err("Error at RESET code %d\n",
-					   (*p) & 0x7f);
-				return -EINVAL;
-			}
+			if (rc < 0)
+				goto report_failure;
+
 			continue;
 		}
 		if (size >= 0xff00) {
 			switch (size) {
 			case 0xff00:
 				rc = do_tuner_callback(fe, XC2028_RESET_CLK, 0);
-				if (rc < 0) {
-					tuner_err("Error at RESET code %d\n",
-						  (*p) & 0x7f);
-					return -EINVAL;
-				}
+				if (rc < 0)
+					goto report_failure;
+
 				break;
 			default:
 				tuner_info("Invalid RESET code %d\n",
 					   size & 0x7f);
-				return -EINVAL;
-
+				goto e_inval;
 			}
 			continue;
 		}
@@ -618,7 +613,7 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 		if ((size + p > endp)) {
 			tuner_err("missing bytes: need %d, have %d\n",
 				   size, (int)(endp - p));
-			return -EINVAL;
+			goto e_inval;
 		}
 
 		buf[0] = *p;
@@ -635,7 +630,7 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 			rc = i2c_send(priv, buf, len + 1);
 			if (rc < 0) {
 				tuner_err("%d returned from send\n", rc);
-				return -EINVAL;
+				goto e_inval;
 			}
 
 			p += len;
@@ -650,6 +645,11 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 		}
 	}
 	return 0;
+
+report_failure:
+	tuner_err("Error at RESET code %d\n", (*p) & 0x7f);
+e_inval:
+	return -EINVAL;
 }
 
 static int load_scode(struct dvb_frontend *fe, unsigned int type,
diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index f3a1e5b1e57c..c6eaecbac831 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -848,15 +848,13 @@ static int cpia2_usb_probe(struct usb_interface *intf,
 	ret = set_alternate(cam, USBIF_CMDONLY);
 	if (ret < 0) {
 		ERR("%s: usb_set_interface error (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto free_data;
 	}
 
 
 	if((ret = cpia2_init_camera(cam)) < 0) {
 		ERR("%s: failed to initialize cpia2 camera (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto free_data;
 	}
 	LOG("  CPiA Version: %d.%02d (%d.%d)\n",
 	       cam->params.version.firmware_revision_hi,
@@ -876,11 +874,14 @@ static int cpia2_usb_probe(struct usb_interface *intf,
 	ret = cpia2_register_camera(cam);
 	if (ret < 0) {
 		ERR("%s: Failed to register cpia2 camera (ret = %d)\n", __func__, ret);
-		kfree(cam);
-		return ret;
+		goto free_data;
 	}
 
 	return 0;
+
+free_data:
+	kfree(cam);
+	return ret;
 }
 
 /******************************************************************************
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index d29773b8f696..7ca44e109a69 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -907,10 +907,8 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 			ret = create_urbs(gspca_dev,
 				alt_xfer(&intf->altsetting[alt], xfer,
 					 gspca_dev->xfer_ep));
-			if (ret < 0) {
-				destroy_urbs(gspca_dev);
-				goto out;
-			}
+			if (ret < 0)
+				goto destroy_urbs;
 		}
 
 		/* clear the bulk endpoint */
@@ -920,10 +918,9 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 
 		/* start the cam */
 		ret = gspca_dev->sd_desc->start(gspca_dev);
-		if (ret < 0) {
-			destroy_urbs(gspca_dev);
-			goto out;
-		}
+		if (ret < 0)
+			goto destroy_urbs;
+
 		gspca_dev->streaming = 1;
 		v4l2_ctrl_handler_setup(gspca_dev->vdev.ctrl_handler);
 
@@ -974,6 +971,10 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
 out:
 	gspca_input_create_urb(gspca_dev);
 	return ret;
+
+destroy_urbs:
+	destroy_urbs(gspca_dev);
+	goto out;
 }
 
 static void gspca_set_default_mode(struct gspca_dev *gspca_dev)
diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index cfa2a04d9f3f..06ec3a3253e1 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -1788,10 +1788,8 @@ static int sd_init(struct gspca_dev *gspca_dev)
 	for (i = 0; i < ARRAY_SIZE(bridge_init); i++) {
 		value = bridge_init[i][1];
 		reg_w(gspca_dev, bridge_init[i][0], &value, 1);
-		if (gspca_dev->usb_err < 0) {
-			pr_err("Device initialization failed\n");
-			return gspca_dev->usb_err;
-		}
+		if (gspca_dev->usb_err < 0)
+			goto report_failure;
 	}
 
 	if (sd->flags & LED_REVERSE)
@@ -1800,10 +1798,8 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		reg_w1(gspca_dev, 0x1006, 0x20);
 
 	reg_w(gspca_dev, 0x10c0, i2c_init, 9);
-	if (gspca_dev->usb_err < 0) {
-		pr_err("Device initialization failed\n");
-		return gspca_dev->usb_err;
-	}
+	if (gspca_dev->usb_err < 0)
+		goto report_failure;
 
 	switch (sd->sensor) {
 	case SENSOR_OV9650:
@@ -1869,6 +1865,11 @@ static int sd_init(struct gspca_dev *gspca_dev)
 		pr_err("Unsupported sensor\n");
 		gspca_dev->usb_err = -ENODEV;
 	}
+	goto exit;
+
+report_failure:
+	pr_err("Device initialization failed\n");
+exit:
 	return gspca_dev->usb_err;
 }
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
index 602097bdcf14..0218614ce988 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
@@ -266,8 +266,7 @@ static int pvr2_ioread_get_buffer(struct pvr2_ioread *cp)
 				pvr2_trace(PVR2_TRACE_DATA_FLOW,
 					   "/*---TRACE_READ---*/ pvr2_ioread_read id=%p queue_error=%d",
 					   cp,stat);
-				pvr2_ioread_stop(cp);
-				return 0;
+				goto stop_read;
 			}
 			cp->c_buf = NULL;
 			cp->c_data_ptr = NULL;
@@ -286,9 +285,8 @@ static int pvr2_ioread_get_buffer(struct pvr2_ioread *cp)
 				pvr2_trace(PVR2_TRACE_DATA_FLOW,
 					   "/*---TRACE_READ---*/ pvr2_ioread_read id=%p buffer_error=%d",
 					   cp,stat);
-				pvr2_ioread_stop(cp);
 				// Give up.
-				return 0;
+				goto stop_read;
 			}
 			// Start over...
 			continue;
@@ -298,6 +296,10 @@ static int pvr2_ioread_get_buffer(struct pvr2_ioread *cp)
 			pvr2_buffer_get_id(cp->c_buf)];
 	}
 	return !0;
+
+stop_read:
+	pvr2_ioread_stop(cp);
+	return 0;
 }
 
 static void pvr2_ioread_filter(struct pvr2_ioread *cp)
diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 70939e96b856..9c467fdf4209 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -861,15 +861,14 @@ int tm6000_cards_setup(struct tm6000_core *dev)
 		for (i = 0; i < 2; i++) {
 			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 						dev->gpio.tuner_reset, 0x00);
-			if (rc < 0) {
-				printk(KERN_ERR "Error %i doing tuner reset\n", rc);
-				return rc;
-			}
+			if (rc < 0)
+				goto report_failure;
 
 			msleep(10); /* Just to be conservative */
 			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
 						dev->gpio.tuner_reset, 0x01);
 			if (rc < 0) {
+report_failure:
 				printk(KERN_ERR "Error %i doing tuner reset\n", rc);
 				return rc;
 			}
diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index c811fc6cf48a..7cc5c5aa08c2 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -134,8 +134,8 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 
 	dvb->bulk_urb->transfer_buffer = kzalloc(size, GFP_KERNEL);
 	if (!dvb->bulk_urb->transfer_buffer) {
-		usb_free_urb(dvb->bulk_urb);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto free_urb;
 	}
 
 	usb_fill_bulk_urb(dvb->bulk_urb, dev->udev, pipe,
@@ -160,11 +160,14 @@ static int tm6000_start_stream(struct tm6000_core *dev)
 									ret);
 
 		kfree(dvb->bulk_urb->transfer_buffer);
-		usb_free_urb(dvb->bulk_urb);
-		return ret;
+		goto free_urb;
 	}
 
 	return 0;
+
+free_urb:
+	usb_free_urb(dvb->bulk_urb);
+	return ret;
 }
 
 static void tm6000_stop_stream(struct tm6000_core *dev)
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 8314d3fa9241..7c1d5e259ea3 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -589,10 +589,8 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
 
 	dev->isoc_ctl.transfer_buffer = kmalloc(sizeof(void *)*num_bufs,
 				   GFP_KERNEL);
-	if (!dev->isoc_ctl.transfer_buffer) {
-		kfree(dev->isoc_ctl.urb);
-		return -ENOMEM;
-	}
+	if (!dev->isoc_ctl.transfer_buffer)
+		goto free_urb;
 
 	dprintk(dev, V4L2_DEBUG_QUEUE, "Allocating %d x %d packets (%d bytes) of %d bytes each to handle %u size\n",
 		    max_packets, num_bufs, sb_size,
@@ -604,9 +602,8 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
 
 		/* call free, as some buffers might have been allocated */
 		tm6000_free_urb_buffers(dev);
-		kfree(dev->isoc_ctl.urb);
 		kfree(dev->isoc_ctl.transfer_buffer);
-		return -ENOMEM;
+		goto free_urb;
 	}
 
 	/* allocate urbs and transfer buffers */
@@ -636,6 +633,10 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
 	}
 
 	return 0;
+
+free_urb:
+	kfree(dev->isoc_ctl.urb);
+	return -ENOMEM;
 }
 
 static int tm6000_start_thread(struct tm6000_core *dev)
diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index eed56895c2b9..b093a843644b 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -1665,8 +1665,7 @@ static int ttusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	if (result < 0) {
 		dprintk("%s: ttusb_alloc_iso_urbs - failed\n", __func__);
 		mutex_unlock(&ttusb->semi2c);
-		kfree(ttusb);
-		return result;
+		goto err_free_usb;
 	}
 
 	if (ttusb_init_controller(ttusb))
@@ -1677,11 +1676,9 @@ static int ttusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	result = dvb_register_adapter(&ttusb->adapter,
 				      "Technotrend/Hauppauge Nova-USB",
 				      THIS_MODULE, &udev->dev, adapter_nr);
-	if (result < 0) {
-		ttusb_free_iso_urbs(ttusb);
-		kfree(ttusb);
-		return result;
-	}
+	if (result < 0)
+		goto err_free_iso_urbs;
+
 	ttusb->adapter.priv = ttusb;
 
 	/* i2c */
@@ -1752,7 +1749,9 @@ static int ttusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	i2c_del_adapter(&ttusb->i2c_adap);
 err_unregister_adapter:
 	dvb_unregister_adapter (&ttusb->adapter);
+err_free_iso_urbs:
 	ttusb_free_iso_urbs(ttusb);
+err_free_usb:
 	kfree(ttusb);
 	return result;
 }
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 44ca66cb9b8f..d3ba5fb47c6f 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -1498,10 +1498,7 @@ static int ttusb_dec_init_dvb(struct ttusb_dec *dec)
 	if ((result = dvb_dmx_init(&dec->demux)) < 0) {
 		printk("%s: dvb_dmx_init failed: error %d\n", __func__,
 		       result);
-
-		dvb_unregister_adapter(&dec->adapter);
-
-		return result;
+		goto unregister_adapter;
 	}
 
 	dec->dmxdev.filternum = 32;
@@ -1511,43 +1508,33 @@ static int ttusb_dec_init_dvb(struct ttusb_dec *dec)
 	if ((result = dvb_dmxdev_init(&dec->dmxdev, &dec->adapter)) < 0) {
 		printk("%s: dvb_dmxdev_init failed: error %d\n",
 		       __func__, result);
-
-		dvb_dmx_release(&dec->demux);
-		dvb_unregister_adapter(&dec->adapter);
-
-		return result;
+		goto release_demux;
 	}
 
 	dec->frontend.source = DMX_FRONTEND_0;
 
-	if ((result = dec->demux.dmx.add_frontend(&dec->demux.dmx,
-						  &dec->frontend)) < 0) {
-		printk("%s: dvb_dmx_init failed: error %d\n", __func__,
-		       result);
-
-		dvb_dmxdev_release(&dec->dmxdev);
-		dvb_dmx_release(&dec->demux);
-		dvb_unregister_adapter(&dec->adapter);
-
-		return result;
-	}
+	result = dec->demux.dmx.add_frontend(&dec->demux.dmx, &dec->frontend);
+	if (result < 0)
+		goto report_failure;
 
 	if ((result = dec->demux.dmx.connect_frontend(&dec->demux.dmx,
 						      &dec->frontend)) < 0) {
-		printk("%s: dvb_dmx_init failed: error %d\n", __func__,
-		       result);
-
 		dec->demux.dmx.remove_frontend(&dec->demux.dmx, &dec->frontend);
-		dvb_dmxdev_release(&dec->dmxdev);
-		dvb_dmx_release(&dec->demux);
-		dvb_unregister_adapter(&dec->adapter);
-
-		return result;
+		goto report_failure;
 	}
 
 	dvb_net_init(&dec->adapter, &dec->dvb_net, &dec->demux.dmx);
 
 	return 0;
+
+report_failure:
+	printk("%s: dvb_dmx_init failed: error %d\n", __func__, result);
+	dvb_dmxdev_release(&dec->dmxdev);
+release_demux:
+	dvb_dmx_release(&dec->demux);
+unregister_adapter:
+	dvb_unregister_adapter(&dec->adapter);
+	return result;
 }
 
 static void ttusb_dec_exit_dvb(struct ttusb_dec *dec)
-- 
2.16.2
