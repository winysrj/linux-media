Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab0BAOuv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 09:50:51 -0500
Message-ID: <4B66EA42.9060108@redhat.com>
Date: Mon, 01 Feb 2010 12:50:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] dvb_demux: Don't use vmalloc at dvb_dmx_swfilter_packet
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As dvb_dmx_swfilter_packet() is protected by a spinlock, it shouldn't sleep.
However, vmalloc() may call sleep. So, move the initialization of
dvb_demux::cnt_storage field to a better place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_demux.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
index a78408e..67f189b 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -426,16 +426,7 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 		};
 	};
 
-	if (dvb_demux_tscheck) {
-		if (!demux->cnt_storage)
-			demux->cnt_storage = vmalloc(MAX_PID + 1);
-
-		if (!demux->cnt_storage) {
-			printk(KERN_WARNING "Couldn't allocate memory for TS/TEI check. Disabling it\n");
-			dvb_demux_tscheck = 0;
-			goto no_dvb_demux_tscheck;
-		}
-
+	if (demux->cnt_storage) {
 		/* check pkt counter */
 		if (pid < MAX_PID) {
 			if (buf[1] & 0x80)
@@ -454,7 +445,6 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 		};
 		/* end check */
 	};
-no_dvb_demux_tscheck:
 
 	list_for_each_entry(feed, &demux->feed_list, list_head) {
 		if ((feed->pid != pid) && (feed->pid != 0x2000))
@@ -1258,6 +1248,13 @@ int dvb_dmx_init(struct dvb_demux *dvbdemux)
 		dvbdemux->feed[i].index = i;
 	}
 
+	if (dvb_demux_tscheck) {
+		dvbdemux->cnt_storage = vmalloc(MAX_PID + 1);
+
+		if (!dvbdemux->cnt_storage)
+			printk(KERN_WARNING "Couldn't allocate memory for TS/TEI check. Disabling it\n");
+	}
+
 	INIT_LIST_HEAD(&dvbdemux->frontend_list);
 
 	for (i = 0; i < DMX_TS_PES_OTHER; i++) {
-- 
1.6.6.1

