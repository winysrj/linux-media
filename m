Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36325 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbZKHVar (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Nov 2009 16:30:47 -0500
Date: Sun, 8 Nov 2009 22:29:41 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/4] firedtv: add missing include, rename a constant
To: linux-media@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
Message-ID: <tkrat.1ab97b506a89a2bd@s5r6.in-berlin.de>
References: <tkrat.ce889fb60854a648@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add #include <dvb_demux.h> for dvb_dmx_swfilter_packets().  This was
already indirectly included via firedtv.h, but don't rely on it.

The 4 bytes which were referred to as FIREWIRE_HEADER_SIZE are actually
the source packet header from IEC 61883-4 (MPEG2-TS data transmission
over 1394), not e.g. the IEEE 1394 isochronous packet header.  So choose
a more precise name.

Also, express the payload size as a preprocessor constant too.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/firedtv-1394.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-1394.c
===================================================================
--- linux-2.6.31.4.orig/drivers/media/dvb/firewire/firedtv-1394.c
+++ linux-2.6.31.4/drivers/media/dvb/firewire/firedtv-1394.c
@@ -26,13 +26,16 @@
 #include <iso.h>
 #include <nodemgr.h>
 
+#include <dvb_demux.h>
+
 #include "firedtv.h"
 
 static LIST_HEAD(node_list);
 static DEFINE_SPINLOCK(node_list_lock);
 
-#define FIREWIRE_HEADER_SIZE	4
-#define CIP_HEADER_SIZE		8
+#define CIP_HEADER_SIZE			8
+#define MPEG2_TS_HEADER_SIZE		4
+#define MPEG2_TS_SOURCE_PACKET_SIZE	(4 + 188)
 
 static void rawiso_activity_cb(struct hpsb_iso *iso)
 {
@@ -62,20 +65,20 @@ static void rawiso_activity_cb(struct hp
 		buf = dma_region_i(&iso->data_buf, unsigned char,
 			iso->infos[packet].offset + CIP_HEADER_SIZE);
 		count = (iso->infos[packet].len - CIP_HEADER_SIZE) /
-			(188 + FIREWIRE_HEADER_SIZE);
+			MPEG2_TS_SOURCE_PACKET_SIZE;
 
 		/* ignore empty packet */
 		if (iso->infos[packet].len <= CIP_HEADER_SIZE)
 			continue;
 
 		while (count--) {
-			if (buf[FIREWIRE_HEADER_SIZE] == 0x47)
+			if (buf[MPEG2_TS_HEADER_SIZE] == 0x47)
 				dvb_dmx_swfilter_packets(&fdtv->demux,
-						&buf[FIREWIRE_HEADER_SIZE], 1);
+						&buf[MPEG2_TS_HEADER_SIZE], 1);
 			else
 				dev_err(fdtv->device,
 					"skipping invalid packet\n");
-			buf += 188 + FIREWIRE_HEADER_SIZE;
+			buf += MPEG2_TS_SOURCE_PACKET_SIZE;
 		}
 	}
 out:

-- 
Stefan Richter
-=====-==--= =-== -=---
http://arcgraph.de/sr/

