Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43811 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbZJTIOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:14:45 -0400
Message-Id: <20091020011214.954146615@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:13 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 03/14] v4l-mc: Replace the active pads bitmask by a link flag
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=v4l-mc-replace-active-bitflag.diff
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/v4l2-device.c
+++ v4l-dvb-mc/linux/drivers/media/video/v4l2-device.c
@@ -145,10 +145,8 @@ static long mc_enum_links(struct v4l2_de
 		for (l = 0; l < ent->pads; l++, s++) {
 			struct v4l2_mc_io_status stat = { 0, 0 };
 
-			if (ent->links) {
-				stat.active_pads = ent->links[l].active;
+			if (ent->links)
 				stat.nr_of_remote_pads = ent->links[l].nr_of_remote_pads;
-			}
 			if (copy_to_user(uios->status + s, &stat, sizeof(stat)))
 				return -EFAULT;
 		}
Index: v4l-dvb-mc/linux/include/linux/videodev2.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/linux/videodev2.h
+++ v4l-dvb-mc/linux/include/linux/videodev2.h
@@ -1560,10 +1560,10 @@ struct v4l2_dbg_chip_ident {
 struct v4l2_mc_io {
 	__u32 entity;	/* entity ID */
 	__u8 pad;	/* pad index */
+	__u8 active;	/* link is active */
 };
 
 struct v4l2_mc_io_status {
-	__u32 active_pads;
 	__u8 nr_of_remote_pads;
 	__u32 type;	/* pad type */
 };
Index: v4l-dvb-mc/linux/include/media/v4l2-mc.h
===================================================================
--- v4l-dvb-mc.orig/linux/include/media/v4l2-mc.h
+++ v4l-dvb-mc/linux/include/media/v4l2-mc.h
@@ -4,7 +4,6 @@
 #include <linux/list.h>
 
 struct v4l2_entity_io {
-	u32 active;	/* bitmask of active remote pads */
 	u8 nr_of_remote_pads; /* number of remote pads */
 	struct v4l2_mc_io *remote_pads; /* specify possible remote pads */
 };
@@ -68,10 +67,10 @@ static inline void v4l2_entity_connect(s
 	sink_link = sink->pads++;
 	source->links[source_link].remote_pads[0].entity = sink->id;
 	source->links[source_link].remote_pads[0].pad = sink_link;
-	source->links[source_link].active = active;
+	source->links[source_link].remote_pads[0].active = active;
 	sink->links[sink_link].remote_pads[0].entity = source->id;
 	sink->links[sink_link].remote_pads[0].pad = source_link;
-	sink->links[sink_link].active = active;
+	sink->links[sink_link].remote_pads[0].active = active;
 }
 
 #endif


