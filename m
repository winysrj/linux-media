Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43842 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbZJTIOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:45 -0400
Message-Id: <20091020011214.851560002@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:12 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 02/14] v4l-mc: Merge input and output pads
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=v4l-mc-merge-inputs-outputs.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media controller doesn't need separate counts of input and output
pads. Merge them into a pads count.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/v4l2-device.c
+++ v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
@@ -107,15 +107,12 @@ static long mc_enum_entities(struct v4l2
 		strlcpy(mc_ent.descr, ent->descr, sizeof(mc_ent.descr));
 	mc_ent.type = ent->type;
 	mc_ent.subtype = ent->subtype;
-	mc_ent.inputs = ent->inputs;
-	mc_ent.outputs = ent->outputs;
+	mc_ent.pads = ent->pads;
 	mc_ent.total_possible_links = 0;
 	if (ent->links) {
 		int l;
 
-		for (l = 0; l < ent->inputs; l++)
-			mc_ent.total_possible_links += ent->links[l].nr_of_remote_pads;
-		for (l = ent->num_inputs; l < ent->num_inputs + ent->outputs; l++)
+		for (l = 0; l < ent->pads; l++)
 			mc_ent.total_possible_links += ent->links[l].nr_of_remote_pads;
 	}
 	mc_ent.v4l.major = ent->v4l.major;
@@ -139,25 +136,13 @@ static long mc_enum_links(struct v4l2_de
 	if (ent == NULL)
 		return -EINVAL;
 	if (ent->links) {
-		for (l = 0; l < ent->inputs; l++)
-			total_possible_links += ent->links[l].nr_of_remote_pads;
-		for (l = ent->num_inputs; l < ent->num_inputs + ent->outputs; l++)
+		for (l = 0; l < ent->pads; l++)
 			total_possible_links += ent->links[l].nr_of_remote_pads;
 	}
 	if (ios.status) {
 		int s = 0;
 
-		for (l = 0; l < ent->inputs; l++, s++) {
-			struct v4l2_mc_io_status stat = { 0, 0 };
-
-			if (ent->links) {
-				stat.active_pads = ent->links[l].active;
-				stat.nr_of_remote_pads = ent->links[l].nr_of_remote_pads;
-			}
-			if (copy_to_user(uios->status + s, &stat, sizeof(stat)))
-				return -EFAULT;
-		}
-		for (l = ent->num_inputs; l < ent->num_inputs + ent->outputs; l++, s++) {
+		for (l = 0; l < ent->pads; l++, s++) {
 			struct v4l2_mc_io_status stat = { 0, 0 };
 
 			if (ent->links) {
@@ -172,13 +157,7 @@ static long mc_enum_links(struct v4l2_de
 	if (ios.remote_pads && total_possible_links) {
 		int p = 0;
 
-		for (l = 0; l < ent->inputs; l++) {
-			if (copy_to_user(uios->remote_pads + p, ent->links[l].remote_pads,
-					ent->links[l].nr_of_remote_pads * sizeof(ent->links[l].remote_pads[0])))
-				return -EFAULT;
-			p += ent->links[l].nr_of_remote_pads;
-		}
-		for (l = ent->num_inputs; l < ent->num_inputs + ent->outputs; l++) {
+		for (l = 0; l < ent->pads; l++) {
 			if (copy_to_user(uios->remote_pads + p, ent->links[l].remote_pads,
 					ent->links[l].nr_of_remote_pads * sizeof(ent->links[l].remote_pads[0])))
 				return -EFAULT;
Index: v4l-dvb-mc/linux/include/linux/videodev2.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/linux/videodev2.h
+++ v4l-dvb-mc/linux/include/linux/videodev2.h
@@ -1554,15 +1554,18 @@ struct v4l2_dbg_chip_ident {
 #define V4L2_SUBDEV_TYPE_VID_ENCODER 2
 #define V4L2_SUBDEV_TYPE_MISC 	     3
 
+#define V4L2_PAD_TYPE_INPUT		1
+#define V4L2_PAD_TYPE_OUTPUT		2
 
 struct v4l2_mc_io {
 	__u32 entity;	/* entity ID */
-	__u8 io;		/* input or output index */
+	__u8 pad;	/* pad index */
 };
 
 struct v4l2_mc_io_status {
 	__u32 active_pads;
 	__u8 nr_of_remote_pads;
+	__u32 type;	/* pad type */
 };
 
 struct v4l2_mc_entity {
@@ -1571,8 +1574,7 @@ struct v4l2_mc_entity {
 	char descr[256];
 	__u32 type;
 	__u32 subtype;
-	__u8 inputs;
-	__u8 outputs;
+	__u8 pads;
 	__u32 total_possible_links;
 
 	union {
@@ -1595,7 +1597,7 @@ struct v4l2_mc_entity {
 
 struct v4l2_mc_ios {
 	__u32 entity;
-	/* Should have enough room for inputs+outputs elements */
+	/* Should have enough room for pads elements */
 	struct v4l2_mc_io_status *status;
 	/* Should have enough room for total_possible_links elements */
 	struct v4l2_mc_io *remote_pads;
Index: v4l-dvb-mc/linux/include/media/v4l2-mc.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/media/v4l2-mc.h
+++ v4l-dvb-mc/linux/include/media/v4l2-mc.h
@@ -17,11 +17,9 @@ struct v4l2_entity {
 	const char *descr;
 	u32 type;
 	u32 subtype;
-	u8 inputs;
-	u8 outputs;
-	u8 num_inputs;
-	u8 num_outputs;
-	/* points to a v4l2_entity_io array of size num_inputs + num_outputs links */
+	u8 pads;
+	u8 num_pads;
+	/* points to a v4l2_entity_io array of size num_pads links */
 	struct v4l2_entity_io *links;
 
 	/* The entity's ioctl, accessible through the media controller */
@@ -45,15 +43,14 @@ struct v4l2_entity {
 	};
 };
 
-static inline void v4l2_entity_prep(struct v4l2_entity *ent, u8 num_inputs, u8 num_outputs,
+static inline void v4l2_entity_prep(struct v4l2_entity *ent, u8 num_pads,
 		struct v4l2_entity_io *links, struct v4l2_mc_io *remote_pads)
 {
 	int i;
 
-	ent->num_inputs = num_inputs;
-	ent->num_outputs = num_outputs;
+	ent->num_pads = num_pads;
 	ent->links = links;
-	for (i = 0; i < num_inputs + num_outputs; i++) {
+	for (i = 0; i < num_pads; i++) {
 		links[i].nr_of_remote_pads = 1;
 		links[i].remote_pads = remote_pads + i;
 	}
@@ -64,18 +61,16 @@ static inline void v4l2_entity_connect(s
 {
 	int source_link, sink_link;
 
-	if (source == NULL || sink == NULL ||
-			source->outputs >= source->num_outputs ||
-			sink->inputs >= sink->num_inputs)
+	if (source == NULL || sink == NULL || source->pads >= source->num_pads)
 		return;
 
-	source_link = source->num_inputs + source->outputs++;
-	sink_link = sink->inputs++;
+	source_link = source->pads++;
+	sink_link = sink->pads++;
 	source->links[source_link].remote_pads[0].entity = sink->id;
-	source->links[source_link].remote_pads[0].io = sink_link;
+	source->links[source_link].remote_pads[0].pad = sink_link;
 	source->links[source_link].active = active;
 	sink->links[sink_link].remote_pads[0].entity = source->id;
-	sink->links[sink_link].remote_pads[0].io = source_link;
+	sink->links[sink_link].remote_pads[0].pad = source_link;
 	sink->links[sink_link].active = active;
 }
 
Index: v4l-dvb-mc/v4l2-apps/util/v4l2-mc.cpp
===================================================================
--- v4l-dvb-mc.orig/v4l2-apps/util/v4l2-mc.cpp
+++ v4l-dvb-mc/v4l2-apps/util/v4l2-mc.cpp
@@ -170,6 +170,18 @@ static std::string entity2s(int fd, unsi
 	return ent.name;
 }
 
+static std::string padtype2s(unsigned type)
+{
+	switch (type) {
+	case V4L2_PAD_TYPE_INPUT:
+		return "input";
+	case V4L2_PAD_TYPE_OUTPUT:
+		return "output";
+	default:
+		return "unknown";
+	}
+}
+
 static void show_topology(int fd)
 {
 	struct v4l2_mc_entity ent;
@@ -193,8 +205,7 @@ static void show_topology(int fd)
 		printf("\tDescription: %s\n", ent.descr);
 		printf("\tType:        %s\n", enttype2s(ent.type).c_str());
 		printf("\tSubtype:     %s\n", subtype2s(ent.type, ent.subtype).c_str());
-		printf("\tInputs:      %d\n", ent.inputs);
-		printf("\tOutputs:     %d\n", ent.outputs);
+		printf("\tPads:        %d\n", ent.pads);
 		printf("\tTotal Links: %d\n", ent.total_possible_links);
 
 		if (ent.type == V4L2_ENTITY_TYPE_NODE) {
@@ -222,54 +233,33 @@ static void show_topology(int fd)
 
 		ios.entity = ent.id;
 		ios.status = (struct v4l2_mc_io_status *)
-			malloc((ent.inputs + ent.outputs) * sizeof(struct v4l2_mc_io_status));
+			malloc(ent.pads * sizeof(struct v4l2_mc_io_status));
 		ios.remote_pads = (struct v4l2_mc_io *)
 			malloc(ent.total_possible_links * sizeof(struct v4l2_mc_io));
 		if (ioctl(fd, VIDIOC_MC_ENUM_LINKS, &ios) >= 0) {
 			int i;
 			int p = 0;
 
-			for (i = 0; i < ent.inputs; i++) {
+			for (i = 0; i < ent.pads; i++) {
 				int j;
 
-				printf("\tInput %d:     ", i);
+				printf("\tPad %d (%s):     ", i, padtype2s(ios.status[i].type).c_str());
 				if (ios.status[i].nr_of_remote_pads == 1) {
 					printf("%s/%d %s\n",
 						entity2s(fd, ios.remote_pads[p].entity).c_str(),
-						ios.remote_pads[p].io,
+						ios.remote_pads[p].pad,
 						ios.status[i].active_pads == 1 ? "(active)" : "");
 				}
 				else {
 					for (j = 0; j < ios.status[i].nr_of_remote_pads; j++) {
 						printf("\t\t\t%s/%d %s\n",
 							entity2s(fd, ios.remote_pads[p+j].entity).c_str(),
-							ios.remote_pads[p+j].io,
+							ios.remote_pads[p+j].pad,
 							(ios.status[i].active_pads & (1 << j)) ? "(active)" : "");
 					}
 				}
 				p += ios.status[i].nr_of_remote_pads;
 			}
-
-			for (i = 0; i < ent.outputs; i++) {
-				int j;
-
-				printf("\tOutput %d:    ", i);
-				if (ios.status[ent.inputs + i].nr_of_remote_pads == 1) {
-					printf("%s/%d %s\n",
-						entity2s(fd, ios.remote_pads[p].entity).c_str(),
-						ios.remote_pads[p].io,
-						ios.status[ent.inputs + i].active_pads == 1 ? "(active)" : "");
-				}
-				else {
-					for (j = 0; j < ios.status[ent.inputs + i].nr_of_remote_pads; j++) {
-						printf("\t\t\t%s/%d %s\n",
-							entity2s(fd, ios.remote_pads[p+j].entity).c_str(),
-							ios.remote_pads[p+j].io,
-							(ios.status[ent.inputs + i].active_pads & (1 << j)) ? "(active)" : "");
-					}
-				}
-				p += ios.status[ent.inputs + i].nr_of_remote_pads;
-			}
 		}
 		free(ios.status);
 		free(ios.remote_pads);
@@ -298,26 +288,28 @@ static void dot_topology(int fd)
 			ent.type == V4L2_ENTITY_TYPE_NODE ? "oval" : "box");
 		ios.entity = ent.id;
 		ios.status = (struct v4l2_mc_io_status *)
-			malloc((ent.inputs + ent.outputs) * sizeof(struct v4l2_mc_io_status));
+			malloc(ent.pads * sizeof(struct v4l2_mc_io_status));
 		ios.remote_pads = (struct v4l2_mc_io *)
 			malloc(ent.total_possible_links * sizeof(struct v4l2_mc_io));
 		if (ioctl(fd, VIDIOC_MC_ENUM_LINKS, &ios) >= 0) {
 			int i;
 			int p = 0;
 
-			for (i = 0; i < ent.inputs; i++)
-				p += ios.status[i].nr_of_remote_pads;
-
-			for (i = 0; i < ent.outputs; i++) {
+			for (i = 0; i < ent.pads; i++) {
 				int j;
 
-				for (j = 0; j < ios.status[ent.inputs + i].nr_of_remote_pads; j++) {
+				if (ios.status[i].type != V4L2_PAD_TYPE_OUTPUT) {
+					p += ios.status[i].nr_of_remote_pads;
+					continue;
+				}
+
+				for (j = 0; j < ios.status[i].nr_of_remote_pads; j++) {
 					printf("\tn%08x -> n%08x ", ent.id, ios.remote_pads[p+j].entity);
-					if (!(ios.status[ent.inputs + i].active_pads & (1 << j)))
+					if (!(ios.status[i].active_pads & (1 << j)))
 						printf("[style=dashed]");
 					printf("\n");
 				}
-				p += ios.status[ent.inputs + i].nr_of_remote_pads;
+				p += ios.status[i].nr_of_remote_pads;
 			}
 		}
 		free(ios.status);
Index: v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/ivtv/ivtv-driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-driver.c
@@ -697,9 +697,9 @@ static int __devinit ivtv_init_struct1(s
 	v4l2_subdev_init(&itv->sd_encoder, NULL);
 	v4l2_subdev_init(&itv->sd_decoder, NULL);
 	strlcpy(itv->sd_encoder.name, "MPEG encoder", sizeof(itv->sd_encoder.name));
-	v4l2_entity_prep(&itv->sd_encoder.entity, SD_ENC_NUM_INPUTS, SD_ENC_NUM_OUTPUTS,
+	v4l2_entity_prep(&itv->sd_encoder.entity, SD_ENC_NUM_INPUTS + SD_ENC_NUM_OUTPUTS,
 		itv->sd_enc_links, itv->sd_enc_remote);
-	v4l2_entity_prep(&itv->sd_decoder.entity, SD_DEC_NUM_INPUTS, SD_DEC_NUM_OUTPUTS,
+	v4l2_entity_prep(&itv->sd_decoder.entity, SD_DEC_NUM_INPUTS + SD_DEC_NUM_OUTPUTS,
 		itv->sd_dec_links, itv->sd_dec_remote);
 	strlcpy(itv->sd_decoder.name, "MPEG decoder", sizeof(itv->sd_decoder.name));
 	err = v4l2_device_register_subdev(&itv->v4l2_dev, &itv->sd_encoder);
Index: v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-gpio.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/ivtv/ivtv-gpio.c
+++ v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-gpio.c
@@ -374,7 +374,7 @@ int ivtv_gpio_init(struct ivtv *itv)
 	write_reg(itv->card->gpio_init.direction | pin, IVTV_REG_GPIO_DIR);
 	v4l2_subdev_init(&itv->sd_gpio, &subdev_ops);
 	snprintf(itv->sd_gpio.name, sizeof(itv->sd_gpio.name), "%s-gpio", itv->v4l2_dev.name);
-	v4l2_entity_prep(&itv->sd_gpio.entity, 0, 1, &itv->sd_gpio_links, &itv->sd_gpio_remote);
+	v4l2_entity_prep(&itv->sd_gpio.entity, 1, &itv->sd_gpio_links, &itv->sd_gpio_remote);
 	itv->sd_gpio.grp_id = IVTV_HW_GPIO;
 	v4l2_entity_connect(&itv->sd_gpio.entity, &itv->sd_encoder.entity, 1);
 	return v4l2_device_register_subdev(&itv->v4l2_dev, &itv->sd_gpio);
Index: v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-streams.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/ivtv/ivtv-streams.c
+++ v4l-dvb-mc/linux/drivers/media/video/ivtv/ivtv-streams.c
@@ -269,10 +269,10 @@ static int ivtv_reg_dev(struct ivtv *itv
 		return -ENOMEM;
 	}
 	if (type <= IVTV_ENC_STREAM_TYPE_RAD || type == IVTV_DEC_STREAM_TYPE_VBI)
-		v4l2_entity_prep(&s->vdev->entity, 1, 0,
+		v4l2_entity_prep(&s->vdev->entity, 1,
 			itv->stream_links + type, itv->stream_remote + type);
 	else
-		v4l2_entity_prep(&s->vdev->entity, 0, 1,
+		v4l2_entity_prep(&s->vdev->entity, 1,
 			itv->stream_links + type, itv->stream_remote + type);
 	if (type <= IVTV_ENC_STREAM_TYPE_RAD)
 		v4l2_entity_connect(&itv->sd_encoder.entity, &s->vdev->entity, 1);
Index: v4l-dvb-mc/linux/drivers/media/video/msp3400-driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/msp3400-driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/msp3400-driver.c
@@ -764,7 +764,7 @@ static int msp_probe(struct i2c_client *
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &msp_ops);
-	v4l2_entity_prep(&sd->entity, 0, 1, &state->sd_output, &state->remote_input);
+	v4l2_entity_prep(&sd->entity, 1, &state->sd_output, &state->remote_input);
 
 	state->v4l2_std = V4L2_STD_NTSC;
 	state->audmode = V4L2_TUNER_MODE_STEREO;
Index: v4l-dvb-mc/linux/drivers/media/video/saa7115.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/saa7115.c
+++ v4l-dvb-mc/linux/drivers/media/video/saa7115.c
@@ -1604,7 +1604,7 @@ static int saa711x_probe(struct i2c_clie
 		return -ENOMEM;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &saa711x_ops);
-	v4l2_entity_prep(&sd->entity, 0, 1, &state->sd_output, &state->remote_input);
+	v4l2_entity_prep(&sd->entity, 1, &state->sd_output, &state->remote_input);
 	state->input = -1;
 	state->output = SAA7115_IPORT_ON;
 	state->enable = 1;
Index: v4l-dvb-mc/linux/drivers/media/video/saa7127.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/saa7127.c
+++ v4l-dvb-mc/linux/drivers/media/video/saa7127.c
@@ -740,7 +740,7 @@ static int saa7127_probe(struct i2c_clie
 
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &saa7127_ops);
-	v4l2_entity_prep(&sd->entity, 1, 0, &state->sd_input, &state->remote_output);
+	v4l2_entity_prep(&sd->entity, 1, &state->sd_input, &state->remote_output);
 
 	/* First test register 0: Bits 5-7 are a version ID (should be 0),
 	   and bit 2 should also be 0.
Index: v4l-dvb-mc/linux/drivers/media/video/tuner-core.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/tuner-core.c
+++ v4l-dvb-mc/linux/drivers/media/video/tuner-core.c
@@ -1041,7 +1041,7 @@ static int tuner_probe(struct i2c_client
 	if (NULL == t)
 		return -ENOMEM;
 	v4l2_i2c_subdev_init(&t->sd, client, &tuner_ops);
-	v4l2_entity_prep(&t->sd.entity, 0, 1, &t->sd_output, &t->remote_input);
+	v4l2_entity_prep(&t->sd.entity, 1, &t->sd_output, &t->remote_input);
 	t->i2c = client;
 	t->name = "(tuner unset)";
 	t->type = UNSET;


