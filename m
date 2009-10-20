Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43811 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751112AbZJTIOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:43 -0400
Message-Id: <20091020011214.770473615@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:11 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 01/14] v4l-mc: Rename pins to pads
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=v4l-mc-pin-to-pad.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Entities "connection points" are now named pads to avoid confusing them with
physical pins.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/include/linux/videodev2.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/linux/videodev2.h
+++ v4l-dvb-mc/linux/include/linux/videodev2.h
@@ -1561,8 +1561,8 @@ struct v4l2_mc_io {
 };
 
 struct v4l2_mc_io_status {
-	__u32 active_pins;
-	__u8 nr_of_remote_pins;
+	__u32 active_pads;
+	__u8 nr_of_remote_pads;
 };
 
 struct v4l2_mc_entity {
@@ -1598,7 +1598,7 @@ struct v4l2_mc_ios {
 	/* Should have enough room for inputs+outputs elements */
 	struct v4l2_mc_io_status *status;
 	/* Should have enough room for total_possible_links elements */
-	struct v4l2_mc_io *remote_pins;
+	struct v4l2_mc_io *remote_pads;
 };
 
 struct v4l2_mc_link {
Index: v4l-dvb-mc/linux/include/media/v4l2-mc.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/media/v4l2-mc.h
+++ v4l-dvb-mc/linux/include/media/v4l2-mc.h
@@ -4,9 +4,9 @@
 #include <linux/list.h>
 
 struct v4l2_entity_io {
-	u32 active;	/* bitmask of active remote pins */
-	u8 nr_of_remote_pins; /* number of remote pins */
-	struct v4l2_mc_io *remote_pins; /* specify possible remote pins */
+	u32 active;	/* bitmask of active remote pads */
+	u8 nr_of_remote_pads; /* number of remote pads */
+	struct v4l2_mc_io *remote_pads; /* specify possible remote pads */
 };
 
 struct v4l2_entity {
@@ -46,7 +46,7 @@ struct v4l2_entity {
 };
 
 static inline void v4l2_entity_prep(struct v4l2_entity *ent, u8 num_inputs, u8 num_outputs,
-		struct v4l2_entity_io *links, struct v4l2_mc_io *remote_pins)
+		struct v4l2_entity_io *links, struct v4l2_mc_io *remote_pads)
 {
 	int i;
 
@@ -54,8 +54,8 @@ static inline void v4l2_entity_prep(stru
 	ent->num_outputs = num_outputs;
 	ent->links = links;
 	for (i = 0; i < num_inputs + num_outputs; i++) {
-		links[i].nr_of_remote_pins = 1;
-		links[i].remote_pins = remote_pins + i;
+		links[i].nr_of_remote_pads = 1;
+		links[i].remote_pads = remote_pads + i;
 	}
 }
 
@@ -71,11 +71,11 @@ static inline void v4l2_entity_connect(s
 
 	source_link = source->num_inputs + source->outputs++;
 	sink_link = sink->inputs++;
-	source->links[source_link].remote_pins[0].entity = sink->id;
-	source->links[source_link].remote_pins[0].io = sink_link;
+	source->links[source_link].remote_pads[0].entity = sink->id;
+	source->links[source_link].remote_pads[0].io = sink_link;
 	source->links[source_link].active = active;
-	sink->links[sink_link].remote_pins[0].entity = source->id;
-	sink->links[sink_link].remote_pins[0].io = source_link;
+	sink->links[sink_link].remote_pads[0].entity = source->id;
+	sink->links[sink_link].remote_pads[0].io = source_link;
 	sink->links[sink_link].active = active;
 }
 
Index: v4l-dvb-mc/v4l2-apps/util/v4l2-mc.cpp
===================================================================
--- v4l-dvb-mc.orig/v4l2-apps/util/v4l2-mc.cpp
+++ v4l-dvb-mc/v4l2-apps/util/v4l2-mc.cpp
@@ -223,7 +223,7 @@ static void show_topology(int fd)
 		ios.entity = ent.id;
 		ios.status = (struct v4l2_mc_io_status *)
 			malloc((ent.inputs + ent.outputs) * sizeof(struct v4l2_mc_io_status));
-		ios.remote_pins = (struct v4l2_mc_io *)
+		ios.remote_pads = (struct v4l2_mc_io *)
 			malloc(ent.total_possible_links * sizeof(struct v4l2_mc_io));
 		if (ioctl(fd, VIDIOC_MC_ENUM_LINKS, &ios) >= 0) {
 			int i;
@@ -233,46 +233,46 @@ static void show_topology(int fd)
 				int j;
 
 				printf("\tInput %d:     ", i);
-				if (ios.status[i].nr_of_remote_pins == 1) {
+				if (ios.status[i].nr_of_remote_pads == 1) {
 					printf("%s/%d %s\n",
-						entity2s(fd, ios.remote_pins[p].entity).c_str(),
-						ios.remote_pins[p].io,
-						ios.status[i].active_pins == 1 ? "(active)" : "");
+						entity2s(fd, ios.remote_pads[p].entity).c_str(),
+						ios.remote_pads[p].io,
+						ios.status[i].active_pads == 1 ? "(active)" : "");
 				}
 				else {
-					for (j = 0; j < ios.status[i].nr_of_remote_pins; j++) {
+					for (j = 0; j < ios.status[i].nr_of_remote_pads; j++) {
 						printf("\t\t\t%s/%d %s\n",
-							entity2s(fd, ios.remote_pins[p+j].entity).c_str(),
-							ios.remote_pins[p+j].io,
-							(ios.status[i].active_pins & (1 << j)) ? "(active)" : "");
+							entity2s(fd, ios.remote_pads[p+j].entity).c_str(),
+							ios.remote_pads[p+j].io,
+							(ios.status[i].active_pads & (1 << j)) ? "(active)" : "");
 					}
 				}
-				p += ios.status[i].nr_of_remote_pins;
+				p += ios.status[i].nr_of_remote_pads;
 			}
 
 			for (i = 0; i < ent.outputs; i++) {
 				int j;
 
 				printf("\tOutput %d:    ", i);
-				if (ios.status[ent.inputs + i].nr_of_remote_pins == 1) {
+				if (ios.status[ent.inputs + i].nr_of_remote_pads == 1) {
 					printf("%s/%d %s\n",
-						entity2s(fd, ios.remote_pins[p].entity).c_str(),
-						ios.remote_pins[p].io,
-						ios.status[ent.inputs + i].active_pins == 1 ? "(active)" : "");
+						entity2s(fd, ios.remote_pads[p].entity).c_str(),
+						ios.remote_pads[p].io,
+						ios.status[ent.inputs + i].active_pads == 1 ? "(active)" : "");
 				}
 				else {
-					for (j = 0; j < ios.status[ent.inputs + i].nr_of_remote_pins; j++) {
+					for (j = 0; j < ios.status[ent.inputs + i].nr_of_remote_pads; j++) {
 						printf("\t\t\t%s/%d %s\n",
-							entity2s(fd, ios.remote_pins[p+j].entity).c_str(),
-							ios.remote_pins[p+j].io,
-							(ios.status[ent.inputs + i].active_pins & (1 << j)) ? "(active)" : "");
+							entity2s(fd, ios.remote_pads[p+j].entity).c_str(),
+							ios.remote_pads[p+j].io,
+							(ios.status[ent.inputs + i].active_pads & (1 << j)) ? "(active)" : "");
 					}
 				}
-				p += ios.status[ent.inputs + i].nr_of_remote_pins;
+				p += ios.status[ent.inputs + i].nr_of_remote_pads;
 			}
 		}
 		free(ios.status);
-		free(ios.remote_pins);
+		free(ios.remote_pads);
 		printf("\n");
 	}
 }
@@ -299,29 +299,29 @@ static void dot_topology(int fd)
 		ios.entity = ent.id;
 		ios.status = (struct v4l2_mc_io_status *)
 			malloc((ent.inputs + ent.outputs) * sizeof(struct v4l2_mc_io_status));
-		ios.remote_pins = (struct v4l2_mc_io *)
+		ios.remote_pads = (struct v4l2_mc_io *)
 			malloc(ent.total_possible_links * sizeof(struct v4l2_mc_io));
 		if (ioctl(fd, VIDIOC_MC_ENUM_LINKS, &ios) >= 0) {
 			int i;
 			int p = 0;
 
 			for (i = 0; i < ent.inputs; i++)
-				p += ios.status[i].nr_of_remote_pins;
+				p += ios.status[i].nr_of_remote_pads;
 
 			for (i = 0; i < ent.outputs; i++) {
 				int j;
 
-				for (j = 0; j < ios.status[ent.inputs + i].nr_of_remote_pins; j++) {
-					printf("\tn%08x -> n%08x ", ent.id, ios.remote_pins[p+j].entity);
-					if (!(ios.status[ent.inputs + i].active_pins & (1 << j)))
+				for (j = 0; j < ios.status[ent.inputs + i].nr_of_remote_pads; j++) {
+					printf("\tn%08x -> n%08x ", ent.id, ios.remote_pads[p+j].entity);
+					if (!(ios.status[ent.inputs + i].active_pads & (1 << j)))
 						printf("[style=dashed]");
 					printf("\n");
 				}
-				p += ios.status[ent.inputs + i].nr_of_remote_pins;
+				p += ios.status[ent.inputs + i].nr_of_remote_pads;
 			}
 		}
 		free(ios.status);
-		free(ios.remote_pins);
+		free(ios.remote_pads);
 	}
 	printf("}\n");
 }
Index: v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/v4l2-device.c
+++ v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
@@ -114,9 +114,9 @@ static long mc_enum_entities(struct v4l2
 		int l;
 
 		for (l = 0; l < ent->inputs; l++)
-			mc_ent.total_possible_links += ent->links[l].nr_of_remote_pins;
+			mc_ent.total_possible_links += ent->links[l].nr_of_remote_pads;
 		for (l = ent->num_inputs; l < ent->num_inputs + ent->outputs; l++)
-			mc_ent.total_possible_links += ent->links[l].nr_of_remote_pins;
+			mc_ent.total_possible_links += ent->links[l].nr_of_remote_pads;
 	}
 	mc_ent.v4l.major = ent->v4l.major;
 	mc_ent.v4l.minor = ent->v4l.minor;
@@ -140,9 +140,9 @@ static long mc_enum_links(struct v4l2_de
 		return -EINVAL;
 	if (ent->links) {
 		for (l = 0; l < ent->inputs; l++)
-			total_possible_links += ent->links[l].nr_of_remote_pins;
+			total_possible_links += ent->links[l].nr_of_remote_pads;
 		for (l = ent->num_inputs; l < ent->num_inputs + ent->outputs; l++)
-			total_possible_links += ent->links[l].nr_of_remote_pins;
+			total_possible_links += ent->links[l].nr_of_remote_pads;
 	}
 	if (ios.status) {
 		int s = 0;
@@ -151,8 +151,8 @@ static long mc_enum_links(struct v4l2_de
 			struct v4l2_mc_io_status stat = { 0, 0 };
 
 			if (ent->links) {
-				stat.active_pins = ent->links[l].active;
-				stat.nr_of_remote_pins = ent->links[l].nr_of_remote_pins;
+				stat.active_pads = ent->links[l].active;
+				stat.nr_of_remote_pads = ent->links[l].nr_of_remote_pads;
 			}
 			if (copy_to_user(uios->status + s, &stat, sizeof(stat)))
 				return -EFAULT;
@@ -161,28 +161,28 @@ static long mc_enum_links(struct v4l2_de
 			struct v4l2_mc_io_status stat = { 0, 0 };
 
 			if (ent->links) {
-				stat.active_pins = ent->links[l].active;
-				stat.nr_of_remote_pins = ent->links[l].nr_of_remote_pins;
+				stat.active_pads = ent->links[l].active;
+				stat.nr_of_remote_pads = ent->links[l].nr_of_remote_pads;
 			}
 			if (copy_to_user(uios->status + s, &stat, sizeof(stat)))
 				return -EFAULT;
 		}
 	}
 
-	if (ios.remote_pins && total_possible_links) {
+	if (ios.remote_pads && total_possible_links) {
 		int p = 0;
 
 		for (l = 0; l < ent->inputs; l++) {
-			if (copy_to_user(uios->remote_pins + p, ent->links[l].remote_pins,
-					ent->links[l].nr_of_remote_pins * sizeof(ent->links[l].remote_pins[0])))
+			if (copy_to_user(uios->remote_pads + p, ent->links[l].remote_pads,
+					ent->links[l].nr_of_remote_pads * sizeof(ent->links[l].remote_pads[0])))
 				return -EFAULT;
-			p += ent->links[l].nr_of_remote_pins;
+			p += ent->links[l].nr_of_remote_pads;
 		}
 		for (l = ent->num_inputs; l < ent->num_inputs + ent->outputs; l++) {
-			if (copy_to_user(uios->remote_pins + p, ent->links[l].remote_pins,
-					ent->links[l].nr_of_remote_pins * sizeof(ent->links[l].remote_pins[0])))
+			if (copy_to_user(uios->remote_pads + p, ent->links[l].remote_pads,
+					ent->links[l].nr_of_remote_pads * sizeof(ent->links[l].remote_pads[0])))
 				return -EFAULT;
-			p += ent->links[l].nr_of_remote_pins;
+			p += ent->links[l].nr_of_remote_pads;
 		}
 	}
 	if (copy_to_user(uios, &ios, sizeof(*uios)))


