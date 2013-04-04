Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763982Ab3DDRZp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Apr 2013 13:25:45 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r34HPiOA021515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 4 Apr 2013 13:25:45 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] demux.h: Remove duplicated enum
Date: Thu,  4 Apr 2013 14:25:30 -0300
Message-Id: <1365096330-21039-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"enum dmx_ts_pes" and "typedef enum dmx_pes_type_t" are just the
same enum declared twice, since Kernel (2.6.12). There's no reason
to duplicate it there, and sparse complains about that:

	drivers/media/dvb-core/dmxdev.c:600:55: warning: mixing different enum types

So, remove the internal define, keeping just the external one.

Internally, use only "enum dmx_ts_pes", as it is too late to drop
dmx_pes_type_t from the userspace API.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-core/demux.h                    | 39 -----------------------
 drivers/media/dvb-core/dmxdev.c                   |  2 +-
 drivers/media/dvb-core/dvb_demux.c                |  6 ++--
 drivers/media/dvb-core/dvb_demux.h                |  4 +--
 drivers/media/dvb-core/dvb_net.c                  |  2 +-
 drivers/media/firewire/firedtv-dvb.c              | 14 ++++----
 drivers/media/pci/ttpci/av7110.c                  |  6 ++--
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 10 +++---
 drivers/media/usb/ttusb-dec/ttusb_dec.c           | 20 ++++++------
 include/uapi/linux/dvb/dmx.h                      |  2 +-
 10 files changed, 33 insertions(+), 72 deletions(-)

diff --git a/drivers/media/dvb-core/demux.h b/drivers/media/dvb-core/demux.h
index eb91fd8..833191b 100644
--- a/drivers/media/dvb-core/demux.h
+++ b/drivers/media/dvb-core/demux.h
@@ -83,45 +83,6 @@ enum dmx_success {
 #define TS_DEMUX        8   /* in case TS_PACKET is set, send the TS to
 			       the demux device, not to the dvr device */
 
-/* PES type for filters which write to built-in decoder */
-/* these should be kept identical to the types in dmx.h */
-
-enum dmx_ts_pes
-{  /* also send packets to decoder (if it exists) */
-	DMX_TS_PES_AUDIO0,
-	DMX_TS_PES_VIDEO0,
-	DMX_TS_PES_TELETEXT0,
-	DMX_TS_PES_SUBTITLE0,
-	DMX_TS_PES_PCR0,
-
-	DMX_TS_PES_AUDIO1,
-	DMX_TS_PES_VIDEO1,
-	DMX_TS_PES_TELETEXT1,
-	DMX_TS_PES_SUBTITLE1,
-	DMX_TS_PES_PCR1,
-
-	DMX_TS_PES_AUDIO2,
-	DMX_TS_PES_VIDEO2,
-	DMX_TS_PES_TELETEXT2,
-	DMX_TS_PES_SUBTITLE2,
-	DMX_TS_PES_PCR2,
-
-	DMX_TS_PES_AUDIO3,
-	DMX_TS_PES_VIDEO3,
-	DMX_TS_PES_TELETEXT3,
-	DMX_TS_PES_SUBTITLE3,
-	DMX_TS_PES_PCR3,
-
-	DMX_TS_PES_OTHER
-};
-
-#define DMX_TS_PES_AUDIO    DMX_TS_PES_AUDIO0
-#define DMX_TS_PES_VIDEO    DMX_TS_PES_VIDEO0
-#define DMX_TS_PES_TELETEXT DMX_TS_PES_TELETEXT0
-#define DMX_TS_PES_SUBTITLE DMX_TS_PES_SUBTITLE0
-#define DMX_TS_PES_PCR      DMX_TS_PES_PCR0
-
-
 struct dmx_ts_feed {
 	int is_filtering; /* Set to non-zero when filtering in progress */
 	struct dmx_demux *parent; /* Back-pointer */
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 8896993..a1a3a51 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -569,7 +569,7 @@ static int dvb_dmxdev_start_feed(struct dmxdev *dmxdev,
 	dmx_output_t otype;
 	int ret;
 	int ts_type;
-	dmx_pes_type_t ts_pes;
+	enum dmx_ts_pes ts_pes;
 	struct dmx_ts_feed *tsfeed;
 
 	feed->ts = NULL;
diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 71641b2..3485655 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -674,7 +674,7 @@ static int dmx_ts_feed_set(struct dmx_ts_feed *ts_feed, u16 pid, int ts_type,
 		return -ERESTARTSYS;
 
 	if (ts_type & TS_DECODER) {
-		if (pes_type >= DMX_TS_PES_OTHER) {
+		if (pes_type >= DMX_PES_OTHER) {
 			mutex_unlock(&demux->mutex);
 			return -EINVAL;
 		}
@@ -846,7 +846,7 @@ static int dvbdmx_release_ts_feed(struct dmx_demux *dmx,
 
 	feed->pid = 0xffff;
 
-	if (feed->ts_type & TS_DECODER && feed->pes_type < DMX_TS_PES_OTHER)
+	if (feed->ts_type & TS_DECODER && feed->pes_type < DMX_PES_OTHER)
 		demux->pesfilter[feed->pes_type] = NULL;
 
 	mutex_unlock(&demux->mutex);
@@ -1268,7 +1268,7 @@ int dvb_dmx_init(struct dvb_demux *dvbdemux)
 
 	INIT_LIST_HEAD(&dvbdemux->frontend_list);
 
-	for (i = 0; i < DMX_TS_PES_OTHER; i++) {
+	for (i = 0; i < DMX_PES_OTHER; i++) {
 		dvbdemux->pesfilter[i] = NULL;
 		dvbdemux->pids[i] = 0xffff;
 	}
diff --git a/drivers/media/dvb-core/dvb_demux.h b/drivers/media/dvb-core/dvb_demux.h
index fa7188a..ae7fc33 100644
--- a/drivers/media/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb-core/dvb_demux.h
@@ -119,8 +119,8 @@ struct dvb_demux {
 
 	struct list_head frontend_list;
 
-	struct dvb_demux_feed *pesfilter[DMX_TS_PES_OTHER];
-	u16 pids[DMX_TS_PES_OTHER];
+	struct dvb_demux_feed *pesfilter[DMX_PES_OTHER];
+	u16 pids[DMX_PES_OTHER];
 	int playing;
 	int recording;
 
diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 44225b1..e17cb85 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -1044,7 +1044,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 		ret = priv->tsfeed->set(priv->tsfeed,
 					priv->pid, /* pid */
 					TS_PACKET, /* type */
-					DMX_TS_PES_OTHER, /* pes type */
+					DMX_PES_OTHER, /* pes type */
 					32768,     /* circular buffer size */
 					timeout    /* timeout */
 					);
diff --git a/drivers/media/firewire/firedtv-dvb.c b/drivers/media/firewire/firedtv-dvb.c
index eb7496e..f710e17 100644
--- a/drivers/media/firewire/firedtv-dvb.c
+++ b/drivers/media/firewire/firedtv-dvb.c
@@ -71,11 +71,11 @@ int fdtv_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 
 	if (dvbdmxfeed->type == DMX_TYPE_TS) {
 		switch (dvbdmxfeed->pes_type) {
-		case DMX_TS_PES_VIDEO:
-		case DMX_TS_PES_AUDIO:
-		case DMX_TS_PES_TELETEXT:
-		case DMX_TS_PES_PCR:
-		case DMX_TS_PES_OTHER:
+		case DMX_PES_VIDEO:
+		case DMX_PES_AUDIO:
+		case DMX_PES_TELETEXT:
+		case DMX_PES_PCR:
+		case DMX_PES_OTHER:
 			c = alloc_channel(fdtv);
 			break;
 		default:
@@ -132,7 +132,7 @@ int fdtv_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	      (demux->dmx.frontend->source != DMX_MEMORY_FE))) {
 
 		if (dvbdmxfeed->ts_type & TS_DECODER) {
-			if (dvbdmxfeed->pes_type >= DMX_TS_PES_OTHER ||
+			if (dvbdmxfeed->pes_type >= DMX_PES_OTHER ||
 			    !demux->pesfilter[dvbdmxfeed->pes_type])
 				return -EINVAL;
 
@@ -141,7 +141,7 @@ int fdtv_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 		}
 
 		if (!(dvbdmxfeed->ts_type & TS_DECODER &&
-		      dvbdmxfeed->pes_type < DMX_TS_PES_OTHER))
+		      dvbdmxfeed->pes_type < DMX_PES_OTHER))
 			return 0;
 	}
 
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 3dc7aa9..f38329d 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -990,7 +990,7 @@ static int av7110_start_feed(struct dvb_demux_feed *feed)
 
 	if (feed->type == DMX_TYPE_TS) {
 		if ((feed->ts_type & TS_DECODER) &&
-		    (feed->pes_type <= DMX_TS_PES_PCR)) {
+		    (feed->pes_type <= DMX_PES_PCR)) {
 			switch (demux->dmx.frontend->source) {
 			case DMX_MEMORY_FE:
 				if (feed->ts_type & TS_DECODER)
@@ -1051,14 +1051,14 @@ static int av7110_stop_feed(struct dvb_demux_feed *feed)
 
 	if (feed->type == DMX_TYPE_TS) {
 		if (feed->ts_type & TS_DECODER) {
-			if (feed->pes_type >= DMX_TS_PES_OTHER ||
+			if (feed->pes_type >= DMX_PES_OTHER ||
 			    !demux->pesfilter[feed->pes_type])
 				return -EINVAL;
 			demux->pids[feed->pes_type] |= 0x8000;
 			demux->pesfilter[feed->pes_type] = NULL;
 		}
 		if (feed->ts_type & TS_DECODER &&
-		    feed->pes_type < DMX_TS_PES_OTHER) {
+		    feed->pes_type < DMX_PES_OTHER) {
 			ret = dvb_feed_stop_pid(feed);
 		} else
 			if ((feed->ts_type & TS_PACKET) &&
diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index e407185..21b9049 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -930,11 +930,11 @@ static int ttusb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 
 	if (dvbdmxfeed->type == DMX_TYPE_TS) {
 		switch (dvbdmxfeed->pes_type) {
-		case DMX_TS_PES_VIDEO:
-		case DMX_TS_PES_AUDIO:
-		case DMX_TS_PES_TELETEXT:
-		case DMX_TS_PES_PCR:
-		case DMX_TS_PES_OTHER:
+		case DMX_PES_VIDEO:
+		case DMX_PES_AUDIO:
+		case DMX_PES_TELETEXT:
+		case DMX_PES_PCR:
+		case DMX_PES_OTHER:
 			break;
 		default:
 			return -EINVAL;
diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 504c812..e52c3b9 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -951,34 +951,34 @@ static int ttusb_dec_start_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
 
 	switch (dvbdmxfeed->pes_type) {
 
-	case DMX_TS_PES_VIDEO:
-		dprintk("  pes_type: DMX_TS_PES_VIDEO\n");
+	case DMX_PES_VIDEO:
+		dprintk("  pes_type: DMX_PES_VIDEO\n");
 		dec->pid[DMX_PES_PCR] = dvbdmxfeed->pid;
 		dec->pid[DMX_PES_VIDEO] = dvbdmxfeed->pid;
 		dec->video_filter = dvbdmxfeed->filter;
 		ttusb_dec_set_pids(dec);
 		break;
 
-	case DMX_TS_PES_AUDIO:
-		dprintk("  pes_type: DMX_TS_PES_AUDIO\n");
+	case DMX_PES_AUDIO:
+		dprintk("  pes_type: DMX_PES_AUDIO\n");
 		dec->pid[DMX_PES_AUDIO] = dvbdmxfeed->pid;
 		dec->audio_filter = dvbdmxfeed->filter;
 		ttusb_dec_set_pids(dec);
 		break;
 
-	case DMX_TS_PES_TELETEXT:
+	case DMX_PES_TELETEXT:
 		dec->pid[DMX_PES_TELETEXT] = dvbdmxfeed->pid;
-		dprintk("  pes_type: DMX_TS_PES_TELETEXT(not supported)\n");
+		dprintk("  pes_type: DMX_PES_TELETEXT(not supported)\n");
 		return -ENOSYS;
 
-	case DMX_TS_PES_PCR:
-		dprintk("  pes_type: DMX_TS_PES_PCR\n");
+	case DMX_PES_PCR:
+		dprintk("  pes_type: DMX_PES_PCR\n");
 		dec->pid[DMX_PES_PCR] = dvbdmxfeed->pid;
 		ttusb_dec_set_pids(dec);
 		break;
 
-	case DMX_TS_PES_OTHER:
-		dprintk("  pes_type: DMX_TS_PES_OTHER(not supported)\n");
+	case DMX_PES_OTHER:
+		dprintk("  pes_type: DMX_PES_OTHER(not supported)\n");
 		return -ENOSYS;
 
 	default:
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index b2a9ad8..b4fb650 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -51,7 +51,7 @@ typedef enum
 } dmx_input_t;
 
 
-typedef enum
+typedef enum dmx_ts_pes
 {
 	DMX_PES_AUDIO0,
 	DMX_PES_VIDEO0,
-- 
1.8.1.4

