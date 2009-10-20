Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43881 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbZJTIOv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:51 -0400
Message-Id: <20091020011215.141339755@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:15 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 05/14] v4l-mc: Clean up link API
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=v4l-mc-clean-up-link-api.patch
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the link API easier to use and more intuitive by introducing pad
and link objects.

The entity API is now made of two functions:

- v4l2_entity_init() initializes an entity. The caller must provide an
array of pads as well as an estimated number of links. The links array
is allocated dynamically and will be reallocated if it grows beyond the
initial estimate.

- v4l2_entity_connect() connects two entities. An entry in the link
array of each entity is allocated and stores pointers to source and sink
pads.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/drivers/media/video/Makefile
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/Makefile
+++ v4l-dvb-mc/linux/drivers/media/video/Makefile
@@ -10,7 +10,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-senso
 
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
-videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
+videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-mc.o
 
 # V4L2 core modules
 
Index: v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/ivtv/ivtv-driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-driver.c
@@ -697,11 +697,11 @@ static int __devinit ivtv_init_struct1(s
 	v4l2_subdev_init(&itv->sd_encoder, NULL);
 	v4l2_subdev_init(&itv->sd_decoder, NULL);
 	strlcpy(itv->sd_encoder.name, "MPEG encoder", sizeof(itv->sd_encoder.name));
-	v4l2_entity_prep(&itv->sd_encoder.entity, SD_ENC_NUM_INPUTS + SD_ENC_NUM_OUTPUTS,
-		itv->sd_enc_links, itv->sd_enc_remote);
-	v4l2_entity_prep(&itv->sd_decoder.entity, SD_DEC_NUM_INPUTS + SD_DEC_NUM_OUTPUTS,
-		itv->sd_dec_links, itv->sd_dec_remote);
 	strlcpy(itv->sd_decoder.name, "MPEG decoder", sizeof(itv->sd_decoder.name));
+	v4l2_entity_init(&itv->sd_encoder.entity, SD_ENC_NUM_PADS,
+			 itv->sd_encoder_pads, 0);
+	v4l2_entity_init(&itv->sd_decoder.entity, SD_DEC_NUM_PADS,
+			 itv->sd_decoder_pads, 0);
 	err = v4l2_device_register_subdev(&itv->v4l2_dev, &itv->sd_encoder);
 	if (err)
 		return err;
@@ -1020,7 +1020,7 @@ static int __devinit ivtv_probe(struct p
 		retval = v4l2_device_register_subdev(&itv->v4l2_dev, &itv->sd_decoder);
 		if (retval)
 			goto free_io;
-		v4l2_entity_connect(&itv->sd_encoder.entity, &itv->sd_decoder.entity, 0);
+		v4l2_entity_connect(&itv->sd_encoder.entity, 0, &itv->sd_decoder.entity, 0, 0);
 	}
 	else {
 		itv->dec_mem = itv->enc_mem;
Index: v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-driver.h
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/ivtv/ivtv-driver.h
+++ v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-driver.h
@@ -321,6 +321,8 @@ struct ivtv_stream {
 	const char *name;		/* name of the stream */
 	int type;			/* stream type */
 
+	struct v4l2_entity_pad pad;
+
 	u32 id;
 	spinlock_t qlock; 		/* locks access to the queues */
 	unsigned long s_flags;		/* status flags, see above */
@@ -615,18 +617,13 @@ struct ivtv {
 
 	struct v4l2_device v4l2_dev;
 	struct v4l2_subdev sd_gpio;	/* GPIO sub-device */
-	struct v4l2_entity_io sd_gpio_links;
-	struct v4l2_mc_io sd_gpio_remote;
+	struct v4l2_entity_pad sd_gpio_pad;
 	struct v4l2_subdev sd_encoder;	/* Bridge encoder sub-device */
-#define SD_ENC_NUM_INPUTS (10)
-#define SD_ENC_NUM_OUTPUTS (10)
-	struct v4l2_entity_io sd_enc_links[SD_ENC_NUM_INPUTS + SD_ENC_NUM_OUTPUTS];
-	struct v4l2_mc_io sd_enc_remote[SD_ENC_NUM_INPUTS + SD_ENC_NUM_OUTPUTS];
+#define SD_ENC_NUM_PADS		20	/* 10 inputs, 10 outputs */
+	struct v4l2_entity_pad sd_encoder_pads[SD_ENC_NUM_PADS];
 	struct v4l2_subdev sd_decoder;	/* Bridge decoder sub-device */
-#define SD_DEC_NUM_INPUTS (10)
-#define SD_DEC_NUM_OUTPUTS (10)
-	struct v4l2_entity_io sd_dec_links[SD_DEC_NUM_INPUTS + SD_DEC_NUM_OUTPUTS];
-	struct v4l2_mc_io sd_dec_remote[SD_DEC_NUM_INPUTS + SD_DEC_NUM_OUTPUTS];
+#define SD_DEC_NUM_PADS		20	/* 10 inputs, 10 outputs */
+	struct v4l2_entity_pad sd_decoder_pads[SD_DEC_NUM_PADS];
 	u16 instance;
 
 	/* High-level state info */
@@ -653,8 +650,6 @@ struct ivtv {
 	/* Streams */
 	int stream_buf_size[IVTV_MAX_STREAMS];          /* stream buffer size */
 	struct ivtv_stream streams[IVTV_MAX_STREAMS]; 	/* stream data */
-	struct v4l2_entity_io stream_links[IVTV_MAX_STREAMS];
-	struct v4l2_mc_io stream_remote[IVTV_MAX_STREAMS];
 	atomic_t capturing;		/* count number of active capture streams */
 	atomic_t decoding;		/* count number of active decoding streams */
 
Index: v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-gpio.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/ivtv/ivtv-gpio.c
+++ v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-gpio.c
@@ -374,8 +374,10 @@ int ivtv_gpio_init(struct ivtv *itv)
 	write_reg(itv->card->gpio_init.direction | pin, IVTV_REG_GPIO_DIR);
 	v4l2_subdev_init(&itv->sd_gpio, &subdev_ops);
 	snprintf(itv->sd_gpio.name, sizeof(itv->sd_gpio.name), "%s-gpio", itv->v4l2_dev.name);
-	v4l2_entity_prep(&itv->sd_gpio.entity, 1, &itv->sd_gpio_links, &itv->sd_gpio_remote);
+	itv->sd_gpio_pad.type = V4L2_PAD_TYPE_OUTPUT;
+	v4l2_entity_init(&itv->sd_gpio.entity, 1, &itv->sd_gpio_pad, 0);
 	itv->sd_gpio.grp_id = IVTV_HW_GPIO;
-	v4l2_entity_connect(&itv->sd_gpio.entity, &itv->sd_encoder.entity, 1);
+	v4l2_entity_connect(&itv->sd_gpio.entity, 0, &itv->sd_encoder.entity, 0,
+			    V4L2_LINK_FLAG_ACTIVE);
 	return v4l2_device_register_subdev(&itv->v4l2_dev, &itv->sd_gpio);
 }
Index: v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-i2c.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/ivtv/ivtv-i2c.c
+++ v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-i2c.c
@@ -170,21 +170,24 @@ int ivtv_i2c_register(struct ivtv *itv, 
 				0, itv->card_i2c->radio);
 		if (sd) {
 			sd->grp_id = 1 << idx;
-			v4l2_entity_connect(&sd->entity, &itv->sd_encoder.entity, 1);
+			v4l2_entity_connect(&sd->entity, 0, &itv->sd_encoder.entity, 0,
+					    V4L2_LINK_FLAG_ACTIVE);
 		}
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
 				adap, mod, type,
 				0, itv->card_i2c->demod);
 		if (sd) {
 			sd->grp_id = 1 << idx;
-			v4l2_entity_connect(&sd->entity, &itv->sd_encoder.entity, 1);
+			v4l2_entity_connect(&sd->entity, 0, &itv->sd_encoder.entity, 0,
+					    V4L2_LINK_FLAG_ACTIVE);
 		}
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
 				adap, mod, type,
 				0, itv->card_i2c->tv);
 		if (sd) {
 			sd->grp_id = 1 << idx;
-			v4l2_entity_connect(&sd->entity, &itv->sd_encoder.entity, 1);
+			v4l2_entity_connect(&sd->entity, 0, &itv->sd_encoder.entity, 0,
+					    V4L2_LINK_FLAG_ACTIVE);
 		}
 		return sd ? 0 : -1;
 	}
@@ -193,15 +196,16 @@ int ivtv_i2c_register(struct ivtv *itv, 
 	if (hw == IVTV_HW_UPD64031A || hw == IVTV_HW_UPD6408X) {
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
 				adap, mod, type, 0, I2C_ADDRS(hw_addrs[idx]));
-		v4l2_entity_connect(&sd->entity, &itv->sd_encoder.entity, 1);
 	} else {
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
 				adap, mod, type, hw_addrs[idx], NULL);
-		if (hw == IVTV_HW_SAA7127)
-			v4l2_entity_connect(&itv->sd_decoder.entity, &sd->entity, 1);
-		else
-			v4l2_entity_connect(&sd->entity, &itv->sd_encoder.entity, 1);
 	}
+	if (hw == IVTV_HW_SAA7127)
+		v4l2_entity_connect(&itv->sd_decoder.entity, 0, &sd->entity, 0,
+				    V4L2_LINK_FLAG_ACTIVE);
+	else
+		v4l2_entity_connect(&sd->entity, 0, &itv->sd_encoder.entity, 0,
+				    V4L2_LINK_FLAG_ACTIVE);
 	if (sd)
 		sd->grp_id = 1 << idx;
 	return sd ? 0 : -1;
Index: v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-streams.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/ivtv/ivtv-streams.c
+++ v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-streams.c
@@ -268,18 +268,20 @@ static int ivtv_reg_dev(struct ivtv *itv
 		s->vdev = NULL;
 		return -ENOMEM;
 	}
-	if (type <= IVTV_ENC_STREAM_TYPE_RAD || type == IVTV_DEC_STREAM_TYPE_VBI)
-		v4l2_entity_prep(&s->vdev->entity, 1,
-			itv->stream_links + type, itv->stream_remote + type);
-	else
-		v4l2_entity_prep(&s->vdev->entity, 1,
-			itv->stream_links + type, itv->stream_remote + type);
-	if (type <= IVTV_ENC_STREAM_TYPE_RAD)
-		v4l2_entity_connect(&itv->sd_encoder.entity, &s->vdev->entity, 1);
-	else if (type == IVTV_DEC_STREAM_TYPE_VBI)
-		v4l2_entity_connect(&itv->sd_decoder.entity, &s->vdev->entity, 1);
-	else
-		v4l2_entity_connect(&s->vdev->entity, &itv->sd_decoder.entity, 1);
+	v4l2_entity_init(&s->vdev->entity, 1, &s->pad, 0);
+	if (type <= IVTV_ENC_STREAM_TYPE_RAD) {
+		s->pad.type = V4L2_PAD_TYPE_INPUT;
+		v4l2_entity_connect(&itv->sd_encoder.entity, 0, &s->vdev->entity, 0,
+				    V4L2_LINK_FLAG_ACTIVE);
+	} else if (type == IVTV_DEC_STREAM_TYPE_VBI) {
+		s->pad.type = V4L2_PAD_TYPE_INPUT;
+		v4l2_entity_connect(&itv->sd_decoder.entity, 0, &s->vdev->entity, 0,
+				    V4L2_LINK_FLAG_ACTIVE);
+	} else {
+		s->pad.type = V4L2_PAD_TYPE_OUTPUT;
+		v4l2_entity_connect(&s->vdev->entity, 0, &itv->sd_decoder.entity, 0,
+				    V4L2_LINK_FLAG_ACTIVE);
+	}
 
 	num = s->vdev->num;
 
Index: v4l-dvb-mc/linux/drivers/media/video/msp3400-driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/msp3400-driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/msp3400-driver.c
@@ -764,7 +764,8 @@ static int msp_probe(struct i2c_client *
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &msp_ops);
-	v4l2_entity_prep(&sd->entity, 1, &state->sd_output, &state->remote_input);
+	state->sd_pad.type = V4L2_PAD_TYPE_OUTPUT;
+	v4l2_entity_init(&sd->entity, 1, &state->sd_pad, 0);
 
 	state->v4l2_std = V4L2_STD_NTSC;
 	state->audmode = V4L2_TUNER_MODE_STEREO;
Index: v4l-dvb-mc/linux/drivers/media/video/msp3400-driver.h
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/msp3400-driver.h
+++ v4l-dvb-mc/linux/drivers/media/video/msp3400-driver.h
@@ -51,8 +51,7 @@ extern int msp_stereo_thresh;
 
 struct msp_state {
 	struct v4l2_subdev sd;
-	struct v4l2_entity_io sd_output;
-	struct v4l2_mc_io remote_input;
+	struct v4l2_entity_pad sd_pad;
 	int rev1, rev2;
 	int ident;
 	u8 has_nicam;
Index: v4l-dvb-mc/linux/drivers/media/video/saa7115.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/saa7115.c
+++ v4l-dvb-mc/linux/drivers/media/video/saa7115.c
@@ -74,8 +74,7 @@ I2C_CLIENT_INSMOD;
 
 struct saa711x_state {
 	struct v4l2_subdev sd;
-	struct v4l2_entity_io sd_output;
-	struct v4l2_mc_io remote_input;
+	struct v4l2_entity_pad sd_pad;
 	v4l2_std_id std;
 	int input;
 	int output;
@@ -1604,7 +1603,8 @@ static int saa711x_probe(struct i2c_clie
 		return -ENOMEM;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &saa711x_ops);
-	v4l2_entity_prep(&sd->entity, 1, &state->sd_output, &state->remote_input);
+	state->sd_pad.type = V4L2_PAD_TYPE_OUTPUT;
+	v4l2_entity_init(&sd->entity, 1, &state->sd_pad, 0);
 	state->input = -1;
 	state->output = SAA7115_IPORT_ON;
 	state->enable = 1;
Index: v4l-dvb-mc/linux/drivers/media/video/saa7127.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/saa7127.c
+++ v4l-dvb-mc/linux/drivers/media/video/saa7127.c
@@ -238,8 +238,7 @@ static struct i2c_reg_value saa7127_init
 
 struct saa7127_state {
 	struct v4l2_subdev sd;
-	struct v4l2_entity_io sd_input;
-	struct v4l2_mc_io remote_output;
+	struct v4l2_entity_pad sd_pad;
 	v4l2_std_id std;
 	u32 ident;
 	enum saa7127_input_type input_type;
@@ -740,7 +739,8 @@ static int saa7127_probe(struct i2c_clie
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &saa7127_ops);
-	v4l2_entity_prep(&sd->entity, 1, &state->sd_input, &state->remote_output);
+	state->sd_pad.type = V4L2_PAD_TYPE_OUTPUT;
+	v4l2_entity_init(&sd->entity, 1, &state->sd_pad, 0);
 
 	/* First test register 0: Bits 5-7 are a version ID (should be 0),
 	   and bit 2 should also be 0.
Index: v4l-dvb-mc/linux/drivers/media/video/tuner-core.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/tuner-core.c
+++ v4l-dvb-mc/linux/drivers/media/video/tuner-core.c
@@ -80,8 +80,7 @@ struct tuner {
 	struct dvb_frontend fe;
 	struct i2c_client   *i2c;
 	struct v4l2_subdev  sd;
-	struct v4l2_entity_io sd_output;
-	struct v4l2_mc_io remote_input;
+	struct v4l2_entity_pad sd_pad;
 	struct list_head    list;
 	unsigned int        using_v4l2:1;
 
@@ -1041,7 +1040,8 @@ static int tuner_probe(struct i2c_client
 	if (NULL == t)
 		return -ENOMEM;
 	v4l2_i2c_subdev_init(&t->sd, client, &tuner_ops);
-	v4l2_entity_prep(&t->sd.entity, 1, &t->sd_output, &t->remote_input);
+	t->sd_pad.type = V4L2_PAD_TYPE_OUTPUT;
+	v4l2_entity_init(&t->sd.entity, 1, &t->sd_pad, 0);
 	t->i2c = client;
 	t->name = "(tuner unset)";
 	t->type = UNSET;
Index: v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/v4l2-device.c
+++ v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
@@ -107,14 +107,8 @@ static long mc_enum_entities(struct v4l2
 		strlcpy(mc_ent.descr, ent->descr, sizeof(mc_ent.descr));
 	mc_ent.type = ent->type;
 	mc_ent.subtype = ent->subtype;
-	mc_ent.pads = ent->pads;
-	mc_ent.total_possible_links = 0;
-	if (ent->links) {
-		int l;
-
-		for (l = 0; l < ent->pads; l++)
-			mc_ent.total_possible_links += ent->links[l].nr_of_remote_pads;
-	}
+	mc_ent.pads = ent->num_pads;
+	mc_ent.links = ent->num_links;
 	mc_ent.v4l.major = ent->v4l.major;
 	mc_ent.v4l.minor = ent->v4l.minor;
 	if (copy_to_user(uent, &mc_ent, sizeof(mc_ent)))
@@ -122,12 +116,17 @@ static long mc_enum_entities(struct v4l2
 	return 0;
 }
 
+static void mc_kpad_to_upad(const struct v4l2_entity_pad *kpad, struct v4l2_mc_pad *upad)
+{
+	upad->entity = kpad->entity->id;
+	upad->index = kpad - kpad->entity->pads;
+	upad->type = kpad->type;
+}
+
 static long mc_enum_links(struct v4l2_device *v4l2_dev, struct v4l2_mc_ios __user *uios)
 {
 	struct v4l2_entity *ent;
 	struct v4l2_mc_ios ios;
-	u32 total_possible_links = 0;
-	int l;
 
 	if (copy_from_user(&ios, uios, sizeof(ios)))
 		return -EFAULT;
@@ -135,31 +134,29 @@ static long mc_enum_links(struct v4l2_de
 	ent = find_entity(v4l2_dev, ios.entity);
 	if (ent == NULL)
 		return -EINVAL;
-	if (ent->links) {
-		for (l = 0; l < ent->pads; l++)
-			total_possible_links += ent->links[l].nr_of_remote_pads;
-	}
-	if (ios.status) {
-		int s = 0;
 
-		for (l = 0; l < ent->pads; l++, s++) {
-			struct v4l2_mc_io_status stat = { 0, 0 };
+	if (ios.pads) {
+		unsigned int p;
 
-			if (ent->links)
-				stat.nr_of_remote_pads = ent->links[l].nr_of_remote_pads;
-			if (copy_to_user(uios->status + s, &stat, sizeof(stat)))
+		for (p = 0; p < ent->num_pads; p++) {
+			struct v4l2_mc_pad pad;
+			mc_kpad_to_upad(&ent->pads[p], &pad);
+			if (copy_to_user(&uios->pads[p], &pad, sizeof(pad)))
 				return -EFAULT;
 		}
 	}
 
-	if (ios.remote_pads && total_possible_links) {
-		int p = 0;
+	if (ios.links) {
+		unsigned int l;
+
+		for (l = 0; l < ent->num_links; l++) {
+			struct v4l2_mc_link link;
 
-		for (l = 0; l < ent->pads; l++) {
-			if (copy_to_user(uios->remote_pads + p, ent->links[l].remote_pads,
-					ent->links[l].nr_of_remote_pads * sizeof(ent->links[l].remote_pads[0])))
+			mc_kpad_to_upad(ent->links[l].source, &link.source);
+			mc_kpad_to_upad(ent->links[l].sink, &link.sink);
+			link.flags = ent->links[l].flags;
+			if (copy_to_user(&uios->links[l], &link, sizeof(link)))
 				return -EFAULT;
-			p += ent->links[l].nr_of_remote_pads;
 		}
 	}
 	if (copy_to_user(uios, &ios, sizeof(*uios)))
Index: v4l-dvb-mc/linux/drivers/media/video/v4l2-mc.c
===================================================================
--- /dev/null
+++ v4l-dvb-mc/linux/drivers/media/video/v4l2-mc.c
@@ -0,0 +1,118 @@
+/*
+ *  V4L2 Media Controller support
+ *
+ *  Copyright (C) 2009 Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <media/v4l2-mc.h>
+
+/**
+ * v4l2_entity_init - Initialize a V4L2 entity
+ *
+ * @num_pads: Total number of input and output pads.
+ * @extra_links: Initial estimate of the number of extra links.
+ * @pads: Array of 'num_pads' pads.
+ *
+ * The total number of pads is an intrinsic property of entities known by the
+ * entity driver, while the total number of links depends on hardware design
+ * and is an extrinsic property unknown to the entity driver. However, in most
+ * use cases the entity driver can guess the number of links which can safely
+ * be assumed to be equal to or larger than the number of pads.
+ *
+ * For those reasons the links array can be preallocated based on the entity
+ * driver guess and will be reallocated later if extra links need to be
+ * created.
+ *
+ * This function allocates a links array with enough space to hold at least
+ * 'num_pads' + 'extra_links' elements. The v4l2_entity::max_links field will
+ * be set to the number of allocated elements.
+ *
+ * The pads array is managed by the entity driver and passed to
+ * v4l2_entity_init() where its pointer will be stored in the entity structure.
+ */
+int
+v4l2_entity_init(struct v4l2_entity *entity, u8 num_pads,
+		 struct v4l2_entity_pad *pads, u8 extra_links)
+{
+	struct v4l2_entity_link *links;
+	unsigned int max_links = num_pads + extra_links;
+	unsigned int i;
+
+	links = kzalloc(max_links * sizeof(links[0]), GFP_KERNEL);
+	if (links == NULL)
+		return -ENOMEM;
+
+	entity->max_links = max_links;
+	entity->num_links = 0;
+	entity->num_pads = num_pads;
+	entity->pads = pads;
+	entity->links = links;
+
+	for (i = 0; i < num_pads; i++)
+		pads[i].entity = entity;
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_entity_init);
+
+static struct
+v4l2_entity_link *v4l2_entity_add_link(struct v4l2_entity *entity)
+{
+	if (entity->num_links >= entity->max_links) {
+		struct v4l2_entity_link *links = entity->links;
+		unsigned int max_links = entity->max_links + 2;
+
+		links = krealloc(links, max_links * sizeof(*links), GFP_KERNEL);
+		if (links == NULL)
+			return NULL;
+
+		entity->max_links = max_links;
+		entity->links = links;
+	}
+
+	return &entity->links[entity->num_links++];
+}
+
+int
+v4l2_entity_connect(struct v4l2_entity *source, u8 source_pad,
+		    struct v4l2_entity *sink, u8 sink_pad, u32 flags)
+{
+	struct v4l2_entity_link *source_link;
+	struct v4l2_entity_link *sink_link;
+
+	BUG_ON(source == NULL || sink == NULL);
+	BUG_ON(source_pad >= source->num_pads);
+	BUG_ON(sink_pad >= sink->num_pads);
+
+	source_link = v4l2_entity_add_link(source);
+	sink_link = v4l2_entity_add_link(sink);
+	if (source_link == NULL || sink_link == NULL)
+		return -ENOMEM;
+
+	source_link->source = &source->pads[source_pad];
+	source_link->sink = &sink->pads[sink_pad];
+	source_link->flags = flags;
+	sink_link->source = &source->pads[source_pad];
+	sink_link->sink = &sink->pads[sink_pad];
+	sink_link->flags = flags;
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_entity_connect);
+
Index: v4l-dvb-mc/linux/include/linux/videodev2.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/linux/videodev2.h
+++ v4l-dvb-mc/linux/include/linux/videodev2.h
@@ -1557,14 +1557,9 @@ struct v4l2_dbg_chip_ident {
 #define V4L2_PAD_TYPE_INPUT		1
 #define V4L2_PAD_TYPE_OUTPUT		2
 
-struct v4l2_mc_io {
+struct v4l2_mc_pad {
 	__u32 entity;	/* entity ID */
-	__u8 pad;	/* pad index */
-	__u8 active;	/* link is active */
-};
-
-struct v4l2_mc_io_status {
-	__u8 nr_of_remote_pads;
+	__u32 index;	/* pad index */
 	__u32 type;	/* pad type */
 };
 
@@ -1575,7 +1570,7 @@ struct v4l2_mc_entity {
 	__u32 type;
 	__u32 subtype;
 	__u8 pads;
-	__u32 total_possible_links;
+	__u32 links;
 
 	union {
 		/* Node specifications */
@@ -1595,17 +1590,21 @@ struct v4l2_mc_entity {
 	};
 };
 
+#define V4L2_LINK_FLAG_ACTIVE		(1 << 0)
+#define V4L2_LINK_FLAG_PERMANENT	(1 << 1)
+
+struct v4l2_mc_link {
+	struct v4l2_mc_pad source;
+	struct v4l2_mc_pad sink;
+	__u32 flags;
+};
+
 struct v4l2_mc_ios {
 	__u32 entity;
 	/* Should have enough room for pads elements */
-	struct v4l2_mc_io_status *status;
+	struct v4l2_mc_pad *pads;
 	/* Should have enough room for total_possible_links elements */
-	struct v4l2_mc_io *remote_pads;
-};
-
-struct v4l2_mc_link {
-	struct v4l2_mc_io source;
-	struct v4l2_mc_io sink;
+	struct v4l2_mc_link *links;
 };
 
 /*
Index: v4l-dvb-mc/linux/include/media/v4l2-mc.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/media/v4l2-mc.h
+++ v4l-dvb-mc/linux/include/media/v4l2-mc.h
@@ -3,23 +3,35 @@
 
 #include <linux/list.h>
 
-struct v4l2_entity_io {
-	u8 nr_of_remote_pads; /* number of remote pads */
-	struct v4l2_mc_io *remote_pads; /* specify possible remote pads */
+struct v4l2_entity_link {
+	struct v4l2_entity_pad *source;	/* Source pad */
+	struct v4l2_entity_pad *sink;	/* Sink pad  */
+	u32 flags;			/* Link flags (V4L2_LINK_FLAG_*) */
+};
+
+struct v4l2_entity_pad {
+	struct v4l2_entity *entity;	/* Entity this pad belongs to */
+	u32 type;			/* Pad type (V4L2_PAD_TYPE_*) */
 };
 
 struct v4l2_entity {
 	struct list_head list;
-	struct v4l2_device *parent;
-	u32 id;
-	const char *name;
-	const char *descr;
-	u32 type;
-	u32 subtype;
-	u8 pads;
-	u8 num_pads;
-	/* points to a v4l2_entity_io array of size num_pads links */
-	struct v4l2_entity_io *links;
+	struct v4l2_device *parent;	/* Media controller this entity belongs
+					 * to */
+	u32 id;				/* Entity ID, unique in the parent media
+					 * controller context */
+	const char *name;		/* Entity name */
+	const char *descr;		/* Entity description, will be a string control */
+	u32 type;			/* Entity type (V4L2_ENTITY_TYPE_*) */
+	u32 subtype;			/* Entity subtype (type-specific) */
+
+	u8 num_pads;			/* Number of input and output pads */
+	u8 num_links;			/* Number of existing links, both active
+					 * and inactive */
+	u8 max_links;			/* Maximum number of links */
+
+	struct v4l2_entity_pad *pads;	/* Array of pads (num_pads elements) */
+	struct v4l2_entity_link *links;	/* Array of links (max_links elements) */
 
 	/* The entity's ioctl, accessible through the media controller */
 	long (*ioctl)(struct v4l2_entity *ent, unsigned int cmd, unsigned long arg);
@@ -42,35 +54,9 @@ struct v4l2_entity {
 	};
 };
 
-static inline void v4l2_entity_prep(struct v4l2_entity *ent, u8 num_pads,
-		struct v4l2_entity_io *links, struct v4l2_mc_io *remote_pads)
-{
-	int i;
-
-	ent->num_pads = num_pads;
-	ent->links = links;
-	for (i = 0; i < num_pads; i++) {
-		links[i].nr_of_remote_pads = 1;
-		links[i].remote_pads = remote_pads + i;
-	}
-}
-
-static inline void v4l2_entity_connect(struct v4l2_entity *source,
-	       struct v4l2_entity *sink, int active)
-{
-	int source_link, sink_link;
-
-	if (source == NULL || sink == NULL || source->pads >= source->num_pads)
-		return;
-
-	source_link = source->pads++;
-	sink_link = sink->pads++;
-	source->links[source_link].remote_pads[0].entity = sink->id;
-	source->links[source_link].remote_pads[0].pad = sink_link;
-	source->links[source_link].remote_pads[0].active = active;
-	sink->links[sink_link].remote_pads[0].entity = source->id;
-	sink->links[sink_link].remote_pads[0].pad = source_link;
-	sink->links[sink_link].remote_pads[0].active = active;
-}
+extern int v4l2_entity_init(struct v4l2_entity *entity, u8 num_pads,
+		struct v4l2_entity_pad *pads, u8 extra_links);
+extern int v4l2_entity_connect(struct v4l2_entity *source, u8 source_pad,
+		struct v4l2_entity *sink, u8 sink_pad, u32 flags);
 
 #endif
Index: v4l-dvb-mc/v4l2-apps/util/v4l2-mc.cpp
===================================================================
--- v4l-dvb-mc.orig/v4l2-apps/util/v4l2-mc.cpp
+++ v4l-dvb-mc/v4l2-apps/util/v4l2-mc.cpp
@@ -170,9 +170,9 @@ static std::string entity2s(int fd, unsi
 	return ent.name;
 }
 
-static std::string padtype2s(unsigned type)
+static std::string padtype2s(struct v4l2_mc_pad *pad)
 {
-	switch (type) {
+	switch (pad->type) {
 	case V4L2_PAD_TYPE_INPUT:
 		return "input";
 	case V4L2_PAD_TYPE_OUTPUT:
@@ -206,7 +206,7 @@ static void show_topology(int fd)
 		printf("\tType:        %s\n", enttype2s(ent.type).c_str());
 		printf("\tSubtype:     %s\n", subtype2s(ent.type, ent.subtype).c_str());
 		printf("\tPads:        %d\n", ent.pads);
-		printf("\tTotal Links: %d\n", ent.total_possible_links);
+		printf("\tLinks:       %d\n", ent.links);
 
 		if (ent.type == V4L2_ENTITY_TYPE_NODE) {
 			/* Output node-specific properties */
@@ -232,37 +232,40 @@ static void show_topology(int fd)
 		}
 
 		ios.entity = ent.id;
-		ios.status = (struct v4l2_mc_io_status *)
-			malloc(ent.pads * sizeof(struct v4l2_mc_io_status));
-		ios.remote_pads = (struct v4l2_mc_io *)
-			malloc(ent.total_possible_links * sizeof(struct v4l2_mc_io));
+		ios.pads = (struct v4l2_mc_pad *)
+			malloc(ent.pads * sizeof(struct v4l2_mc_pad));
+		ios.links = (struct v4l2_mc_link *)
+			malloc(ent.links * sizeof(struct v4l2_mc_link));
 		if (ioctl(fd, VIDIOC_MC_ENUM_LINKS, &ios) >= 0) {
 			int i;
 			int p = 0;
 
 			for (i = 0; i < ent.pads; i++) {
+				struct v4l2_mc_pad *pad = &ios.pads[i];
 				int j;
 
-				printf("\tPad %d (%s):     ", i, padtype2s(ios.status[i].type).c_str());
-				if (ios.status[i].nr_of_remote_pads == 1) {
-					printf("%s/%d %s\n",
-						entity2s(fd, ios.remote_pads[p].entity).c_str(),
-						ios.remote_pads[p].pad,
-						ios.status[i].active_pads == 1 ? "(active)" : "");
+				printf("\tPad %d (%s):     ", i, padtype2s(pad).c_str());
+				for (j = 0; j < ent.links; j++) {
+					struct v4l2_mc_link *link = &ios.links[j];
+					struct v4l2_mc_pad *remote;
+
+					if (link->source.index == pad->index)
+						remote = &ios.pads[link->sink.index];
+					else if (link->sink.index == pad->index)
+						remote = &ios.pads[link->source.index];
+					else
+						continue;
+
+					printf("\t\t\t%s %s/%d %s\n",
+						remote->type == V4L2_PAD_TYPE_INPUT ? "->" : "<-",
+						entity2s(fd, remote->entity).c_str(),
+						remote->index,
+						link->flags & V4L2_LINK_FLAG_ACTIVE ? "(active)" : "");
 				}
-				else {
-					for (j = 0; j < ios.status[i].nr_of_remote_pads; j++) {
-						printf("\t\t\t%s/%d %s\n",
-							entity2s(fd, ios.remote_pads[p+j].entity).c_str(),
-							ios.remote_pads[p+j].pad,
-							(ios.status[i].active_pads & (1 << j)) ? "(active)" : "");
-					}
-				}
-				p += ios.status[i].nr_of_remote_pads;
 			}
 		}
-		free(ios.status);
-		free(ios.remote_pads);
+		free(ios.pads);
+		free(ios.links);
 		printf("\n");
 	}
 }
@@ -287,33 +290,25 @@ static void dot_topology(int fd)
 		printf("\tn%08x [label=\"%s\",shape=%s]\n", ent.id, ent.name,
 			ent.type == V4L2_ENTITY_TYPE_NODE ? "oval" : "box");
 		ios.entity = ent.id;
-		ios.status = (struct v4l2_mc_io_status *)
-			malloc(ent.pads * sizeof(struct v4l2_mc_io_status));
-		ios.remote_pads = (struct v4l2_mc_io *)
-			malloc(ent.total_possible_links * sizeof(struct v4l2_mc_io));
+		ios.pads = (struct v4l2_mc_pad *)
+			malloc(ent.pads * sizeof(struct v4l2_mc_pad));
+		ios.links = (struct v4l2_mc_link *)
+			malloc(ent.links * sizeof(struct v4l2_mc_link));
 		if (ioctl(fd, VIDIOC_MC_ENUM_LINKS, &ios) >= 0) {
 			int i;
-			int p = 0;
 
-			for (i = 0; i < ent.pads; i++) {
-				int j;
-
-				if (ios.status[i].type != V4L2_PAD_TYPE_OUTPUT) {
-					p += ios.status[i].nr_of_remote_pads;
+			for (i = 0; i < ent.links; i++) {
+				if (ios.links[i].source.entity != ent.id)
 					continue;
-				}
 
-				for (j = 0; j < ios.status[i].nr_of_remote_pads; j++) {
-					printf("\tn%08x -> n%08x ", ent.id, ios.remote_pads[p+j].entity);
-					if (!(ios.status[i].active_pads & (1 << j)))
+				printf("\tn%08x -> n%08x ", ent.id, ios.links[i].sink.entity);
+					if (!(ios.links[i].flags & V4L2_LINK_FLAG_ACTIVE))
 						printf("[style=dashed]");
 					printf("\n");
-				}
-				p += ios.status[i].nr_of_remote_pads;
 			}
 		}
-		free(ios.status);
-		free(ios.remote_pads);
+		free(ios.pads);
+		free(ios.links);
 	}
 	printf("}\n");
 }


