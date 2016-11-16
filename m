Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752328AbcKPQnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:14 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 26/35] [media] tuner-core: use pr_foo, instead of internal printk macros
Date: Wed, 16 Nov 2016 14:42:58 -0200
Message-Id: <6a7e040787de1046bd50dde5fd765507e67d5282.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tuner core uses its own printk internal macros, instead of the
standard debug ones, for no good reason.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/tuner-core.c | 106 +++++++++++++++--------------------
 1 file changed, 46 insertions(+), 60 deletions(-)

diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
index d3a6236b6b02..3c81ab3d3174 100644
--- a/drivers/media/v4l2-core/tuner-core.c
+++ b/drivers/media/v4l2-core/tuner-core.c
@@ -84,30 +84,16 @@ static const struct v4l2_subdev_ops tuner_ops;
  * Debug macros
  */
 
-#define tuner_warn(fmt, arg...) do {			\
-	printk(KERN_WARNING "%s %d-%04x: " fmt, PREFIX, \
-	       i2c_adapter_id(t->i2c->adapter),		\
-	       t->i2c->addr, ##arg);			\
-	 } while (0)
+#undef pr_fmt
 
-#define tuner_info(fmt, arg...) do {			\
-	printk(KERN_INFO "%s %d-%04x: " fmt, PREFIX,	\
-	       i2c_adapter_id(t->i2c->adapter),		\
-	       t->i2c->addr, ##arg);			\
-	 } while (0)
+#define pr_fmt(fmt) KBUILD_MODNAME ": %d-%04x: " fmt,		\
+	i2c_adapter_id(t->i2c->adapter), t->i2c->addr
 
-#define tuner_err(fmt, arg...) do {			\
-	printk(KERN_ERR "%s %d-%04x: " fmt, PREFIX,	\
-	       i2c_adapter_id(t->i2c->adapter),		\
-	       t->i2c->addr, ##arg);			\
-	 } while (0)
 
-#define tuner_dbg(fmt, arg...) do {				\
-	if (tuner_debug)					\
-		printk(KERN_DEBUG "%s %d-%04x: " fmt, PREFIX,	\
-		       i2c_adapter_id(t->i2c->adapter),		\
-		       t->i2c->addr, ##arg);			\
-	 } while (0)
+#define dprintk(fmt, arg...) do {					\
+	if (tuner_debug)						\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt), __func__, ##arg);	\
+} while(0)
 
 /*
  * Internal struct used inside the driver
@@ -208,7 +194,7 @@ static void fe_set_params(struct dvb_frontend *fe,
 	struct tuner *t = fe->analog_demod_priv;
 
 	if (NULL == fe_tuner_ops->set_analog_params) {
-		tuner_warn("Tuner frontend module has no way to set freq\n");
+		pr_warn("Tuner frontend module has no way to set freq\n");
 		return;
 	}
 	fe_tuner_ops->set_analog_params(fe, params);
@@ -230,7 +216,7 @@ static int fe_set_config(struct dvb_frontend *fe, void *priv_cfg)
 	if (fe_tuner_ops->set_config)
 		return fe_tuner_ops->set_config(fe, priv_cfg);
 
-	tuner_warn("Tuner frontend module has no way to set config\n");
+	pr_warn("Tuner frontend module has no way to set config\n");
 
 	return 0;
 }
@@ -273,14 +259,14 @@ static void set_type(struct i2c_client *c, unsigned int type,
 	int tune_now = 1;
 
 	if (type == UNSET || type == TUNER_ABSENT) {
-		tuner_dbg("tuner 0x%02x: Tuner type absent\n", c->addr);
+		dprintk("tuner 0x%02x: Tuner type absent\n", c->addr);
 		return;
 	}
 
 	t->type = type;
 	t->config = new_config;
 	if (tuner_callback != NULL) {
-		tuner_dbg("defining GPIO callback\n");
+		dprintk("defining GPIO callback\n");
 		t->fe.callback = tuner_callback;
 	}
 
@@ -442,7 +428,7 @@ static void set_type(struct i2c_client *c, unsigned int type,
 	t->sd.entity.name = t->name;
 #endif
 
-	tuner_dbg("type set to %s\n", t->name);
+	dprintk("type set to %s\n", t->name);
 
 	t->mode_mask = new_mode_mask;
 
@@ -459,13 +445,13 @@ static void set_type(struct i2c_client *c, unsigned int type,
 			set_tv_freq(c, t->tv_freq);
 	}
 
-	tuner_dbg("%s %s I2C addr 0x%02x with type %d used for 0x%02x\n",
+	dprintk("%s %s I2C addr 0x%02x with type %d used for 0x%02x\n",
 		  c->adapter->name, c->dev.driver->name, c->addr << 1, type,
 		  t->mode_mask);
 	return;
 
 attach_failed:
-	tuner_dbg("Tuner attach for type = %d failed.\n", t->type);
+	dprintk("Tuner attach for type = %d failed.\n", t->type);
 	t->type = TUNER_ABSENT;
 
 	return;
@@ -491,7 +477,7 @@ static int tuner_s_type_addr(struct v4l2_subdev *sd,
 	struct tuner *t = to_tuner(sd);
 	struct i2c_client *c = v4l2_get_subdevdata(sd);
 
-	tuner_dbg("Calling set_type_addr for type=%d, addr=0x%02x, mode=0x%02x, config=%p\n",
+	dprintk("Calling set_type_addr for type=%d, addr=0x%02x, mode=0x%02x, config=%p\n",
 			tun_setup->type,
 			tun_setup->addr,
 			tun_setup->mode_mask,
@@ -503,7 +489,7 @@ static int tuner_s_type_addr(struct v4l2_subdev *sd,
 		set_type(c, tun_setup->type, tun_setup->mode_mask,
 			 tun_setup->config, tun_setup->tuner_callback);
 	} else
-		tuner_dbg("set addr discarded for type %i, mask %x. Asked to change tuner at addr 0x%02x, with mask %x\n",
+		dprintk("set addr discarded for type %i, mask %x. Asked to change tuner at addr 0x%02x, with mask %x\n",
 			  t->type, t->mode_mask,
 			  tun_setup->addr, tun_setup->mode_mask);
 
@@ -533,7 +519,7 @@ static int tuner_s_config(struct v4l2_subdev *sd,
 		return 0;
 	}
 
-	tuner_dbg("Tuner frontend module has no way to set config\n");
+	dprintk("Tuner frontend module has no way to set config\n");
 	return 0;
 }
 
@@ -622,7 +608,7 @@ static int tuner_probe(struct i2c_client *client,
 		memset(buffer, 0, sizeof(buffer));
 		rc = i2c_master_recv(client, buffer, sizeof(buffer));
 		if (rc >= 0)
-			tuner_info("I2C RECV = %*ph\n", rc, buffer);
+			pr_info("I2C RECV = %*ph\n", rc, buffer);
 	}
 
 	/* autodetection code based on the i2c addr */
@@ -650,7 +636,7 @@ static int tuner_probe(struct i2c_client *client,
 			   since it can be tda9887*/
 			if (tuner_symbol_probe(tda829x_probe, t->i2c->adapter,
 					       t->i2c->addr) >= 0) {
-				tuner_dbg("tda829x detected\n");
+				dprintk("tda829x detected\n");
 			} else {
 				/* Default is being tda9887 */
 				t->type = TUNER_TDA9887;
@@ -687,7 +673,7 @@ static int tuner_probe(struct i2c_client *client,
 		t->mode_mask = T_ANALOG_TV;
 		if (radio == NULL)
 			t->mode_mask |= T_RADIO;
-		tuner_dbg("Setting mode_mask to 0x%02x\n", t->mode_mask);
+		dprintk("Setting mode_mask to 0x%02x\n", t->mode_mask);
 	}
 
 	/* Should be just before return */
@@ -716,7 +702,7 @@ static int tuner_probe(struct i2c_client *client,
 	}
 
 	if (ret < 0) {
-		tuner_err("failed to initialize media entity!\n");
+		pr_err("failed to initialize media entity!\n");
 		kfree(t);
 		return ret;
 	}
@@ -729,7 +715,7 @@ static int tuner_probe(struct i2c_client *client,
 	set_type(client, t->type, t->mode_mask, t->config, t->fe.callback);
 	list_add_tail(&t->list, &tuner_list);
 
-	tuner_info("Tuner %d found with type(s)%s%s.\n",
+	pr_info("Tuner %d found with type(s)%s%s.\n",
 		   t->type,
 		   t->mode_mask & T_RADIO ? " Radio" : "",
 		   t->mode_mask & T_ANALOG_TV ? " TV" : "");
@@ -806,7 +792,7 @@ static int set_mode(struct tuner *t, enum v4l2_tuner_type mode)
 
 	if (mode != t->mode) {
 		if (check_mode(t, mode) == -EINVAL) {
-			tuner_dbg("Tuner doesn't support mode %d. Putting tuner to sleep\n",
+			dprintk("Tuner doesn't support mode %d. Putting tuner to sleep\n",
 				  mode);
 			t->standby = true;
 			if (analog_ops->standby)
@@ -814,7 +800,7 @@ static int set_mode(struct tuner *t, enum v4l2_tuner_type mode)
 			return -EINVAL;
 		}
 		t->mode = mode;
-		tuner_dbg("Changing to mode %d\n", mode);
+		dprintk("Changing to mode %d\n", mode);
 	}
 	return 0;
 }
@@ -861,15 +847,15 @@ static void set_tv_freq(struct i2c_client *c, unsigned int freq)
 	};
 
 	if (t->type == UNSET) {
-		tuner_warn("tuner type not set\n");
+		pr_warn("tuner type not set\n");
 		return;
 	}
 	if (NULL == analog_ops->set_params) {
-		tuner_warn("Tuner has no way to set tv freq\n");
+		pr_warn("Tuner has no way to set tv freq\n");
 		return;
 	}
 	if (freq < tv_range[0] * 16 || freq > tv_range[1] * 16) {
-		tuner_dbg("TV freq (%d.%02d) out of range (%d-%d)\n",
+		dprintk("TV freq (%d.%02d) out of range (%d-%d)\n",
 			   freq / 16, freq % 16 * 100 / 16, tv_range[0],
 			   tv_range[1]);
 		/* V4L2 spec: if the freq is not possible then the closest
@@ -880,7 +866,7 @@ static void set_tv_freq(struct i2c_client *c, unsigned int freq)
 			freq = tv_range[1] * 16;
 	}
 	params.frequency = freq;
-	tuner_dbg("tv freq set to %d.%02d\n",
+	dprintk("tv freq set to %d.%02d\n",
 			freq / 16, freq % 16 * 100 / 16);
 	t->tv_freq = freq;
 	t->standby = false;
@@ -930,7 +916,7 @@ static v4l2_std_id tuner_fixup_std(struct tuner *t, v4l2_std_id std)
 				return V4L2_STD_PAL_Nc;
 			return V4L2_STD_PAL_N;
 		default:
-			tuner_warn("pal= argument not recognised\n");
+			pr_warn("pal= argument not recognised\n");
 			break;
 		}
 	}
@@ -956,7 +942,7 @@ static v4l2_std_id tuner_fixup_std(struct tuner *t, v4l2_std_id std)
 				return V4L2_STD_SECAM_LC;
 			return V4L2_STD_SECAM_L;
 		default:
-			tuner_warn("secam= argument not recognised\n");
+			pr_warn("secam= argument not recognised\n");
 			break;
 		}
 	}
@@ -973,7 +959,7 @@ static v4l2_std_id tuner_fixup_std(struct tuner *t, v4l2_std_id std)
 		case 'K':
 			return V4L2_STD_NTSC_M_KR;
 		default:
-			tuner_info("ntsc= argument not recognised\n");
+			pr_info("ntsc= argument not recognised\n");
 			break;
 		}
 	}
@@ -1002,15 +988,15 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 	};
 
 	if (t->type == UNSET) {
-		tuner_warn("tuner type not set\n");
+		pr_warn("tuner type not set\n");
 		return;
 	}
 	if (NULL == analog_ops->set_params) {
-		tuner_warn("tuner has no way to set radio frequency\n");
+		pr_warn("tuner has no way to set radio frequency\n");
 		return;
 	}
 	if (freq < radio_range[0] * 16000 || freq > radio_range[1] * 16000) {
-		tuner_dbg("radio freq (%d.%02d) out of range (%d-%d)\n",
+		dprintk("radio freq (%d.%02d) out of range (%d-%d)\n",
 			   freq / 16000, freq % 16000 * 100 / 16000,
 			   radio_range[0], radio_range[1]);
 		/* V4L2 spec: if the freq is not possible then the closest
@@ -1021,7 +1007,7 @@ static void set_radio_freq(struct i2c_client *c, unsigned int freq)
 			freq = radio_range[1] * 16000;
 	}
 	params.frequency = freq;
-	tuner_dbg("radio freq set to %d.%02d\n",
+	dprintk("radio freq set to %d.%02d\n",
 			freq / 16000, freq % 16000 * 100 / 16000);
 	t->radio_freq = freq;
 	t->standby = false;
@@ -1072,10 +1058,10 @@ static void tuner_status(struct dvb_frontend *fe)
 		freq = t->tv_freq / 16;
 		freq_fraction = (t->tv_freq % 16) * 100 / 16;
 	}
-	tuner_info("Tuner mode:      %s%s\n", p,
+	pr_info("Tuner mode:      %s%s\n", p,
 		   t->standby ? " on standby mode" : "");
-	tuner_info("Frequency:       %lu.%02lu MHz\n", freq, freq_fraction);
-	tuner_info("Standard:        0x%08lx\n", (unsigned long)t->std);
+	pr_info("Frequency:       %lu.%02lu MHz\n", freq, freq_fraction);
+	pr_info("Standard:        0x%08lx\n", (unsigned long)t->std);
 	if (t->mode != V4L2_TUNER_RADIO)
 		return;
 	if (fe_tuner_ops->get_status) {
@@ -1083,15 +1069,15 @@ static void tuner_status(struct dvb_frontend *fe)
 
 		fe_tuner_ops->get_status(&t->fe, &tuner_status);
 		if (tuner_status & TUNER_STATUS_LOCKED)
-			tuner_info("Tuner is locked.\n");
+			pr_info("Tuner is locked.\n");
 		if (tuner_status & TUNER_STATUS_STEREO)
-			tuner_info("Stereo:          yes\n");
+			pr_info("Stereo:          yes\n");
 	}
 	if (analog_ops->has_signal) {
 		u16 signal;
 
 		if (!analog_ops->has_signal(fe, &signal))
-			tuner_info("Signal strength: %hu\n", signal);
+			pr_info("Signal strength: %hu\n", signal);
 	}
 }
 
@@ -1124,13 +1110,13 @@ static int tuner_s_power(struct v4l2_subdev *sd, int on)
 
 	if (on) {
 		if (t->standby && set_mode(t, t->mode) == 0) {
-			tuner_dbg("Waking up tuner\n");
+			dprintk("Waking up tuner\n");
 			set_freq(t, 0);
 		}
 		return 0;
 	}
 
-	tuner_dbg("Putting tuner to sleep\n");
+	dprintk("Putting tuner to sleep\n");
 	t->standby = true;
 	if (analog_ops->standby)
 		analog_ops->standby(&t->fe);
@@ -1146,7 +1132,7 @@ static int tuner_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 
 	t->std = tuner_fixup_std(t, std);
 	if (t->std != std)
-		tuner_dbg("Fixup standard %llx to %llx\n", std, t->std);
+		dprintk("Fixup standard %llx to %llx\n", std, t->std);
 	set_freq(t, 0);
 	return 0;
 }
@@ -1295,7 +1281,7 @@ static int tuner_suspend(struct device *dev)
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 	struct analog_demod_ops *analog_ops = &t->fe.ops.analog_ops;
 
-	tuner_dbg("suspend\n");
+	dprintk("suspend\n");
 
 	if (t->fe.ops.tuner_ops.suspend)
 		t->fe.ops.tuner_ops.suspend(&t->fe);
@@ -1310,7 +1296,7 @@ static int tuner_resume(struct device *dev)
 	struct i2c_client *c = to_i2c_client(dev);
 	struct tuner *t = to_tuner(i2c_get_clientdata(c));
 
-	tuner_dbg("resume\n");
+	dprintk("resume\n");
 
 	if (t->fe.ops.tuner_ops.resume)
 		t->fe.ops.tuner_ops.resume(&t->fe);
-- 
2.7.4


