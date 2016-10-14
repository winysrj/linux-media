Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755079AbcJNRrG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 12/25] [media] dvb_demux: convert an internal ifdef into a Kconfig option
Date: Fri, 14 Oct 2016 14:45:50 -0300
Message-Id: <679cbbdf8e234a74f1061e5c368e7da1f8382aa6.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some ifdefs inside the dvb_demux that are meant to
enable advanced debug capabilities, at the cost of being very
verbose.

Keeping those as internal ifdefs is a very bad idea, as it
doesn't make easy to check if the code there was broken by
some patch. So, let's add an explicit Kconfig option for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/Kconfig     | 13 +++++++++++++
 drivers/media/dvb-core/dvb_demux.c | 14 +++++---------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-core/Kconfig b/drivers/media/dvb-core/Kconfig
index fa7a2490ed5f..8964f1d3cf57 100644
--- a/drivers/media/dvb-core/Kconfig
+++ b/drivers/media/dvb-core/Kconfig
@@ -27,3 +27,16 @@ config DVB_DYNAMIC_MINORS
 	  will be required to manage the device nodes.
 
 	  If you are unsure about this, say N here.
+
+config DVB_DEMUX_SECTION_LOSS_LOG
+	bool "Enable DVB demux section packet loss log"
+	depends on DVB_CORE
+	default n
+	help
+	  Enable extra log messages meant to detect packet loss
+	  inside the Kernel.
+
+	  Should not be enabled on normal cases, as logs can
+	  be very verbose.
+
+	  If you are unsure about this, say N here.
diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index a0a1f8456c54..5a69b0bda4bb 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -37,10 +37,6 @@
 #include "dvb_demux.h"
 
 #define NOBUFS
-/*
-** #define DVB_DEMUX_SECTION_LOSS_LOG to monitor payload loss in the syslog
-*/
-// #define DVB_DEMUX_SECTION_LOSS_LOG
 
 static int dvb_demux_tscheck;
 module_param(dvb_demux_tscheck, int, 0644);
@@ -194,7 +190,7 @@ static void dvb_dmx_swfilter_section_new(struct dvb_demux_feed *feed)
 {
 	struct dmx_section_feed *sec = &feed->feed.sec;
 
-#ifdef DVB_DEMUX_SECTION_LOSS_LOG
+#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 	if (sec->secbufp < sec->tsfeedp) {
 		int i, n = sec->tsfeedp - sec->secbufp;
 
@@ -247,7 +243,7 @@ static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
 		return 0;
 
 	if (sec->tsfeedp + len > DMX_MAX_SECFEED_SIZE) {
-#ifdef DVB_DEMUX_SECTION_LOSS_LOG
+#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 		dprintk("dvb_demux.c section buffer full loss: %d/%d\n",
 		       sec->tsfeedp + len - DMX_MAX_SECFEED_SIZE,
 		       DMX_MAX_SECFEED_SIZE);
@@ -281,7 +277,7 @@ static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
 		/* dump [secbuf .. secbuf+seclen) */
 		if (feed->pusi_seen)
 			dvb_dmx_swfilter_section_feed(feed);
-#ifdef DVB_DEMUX_SECTION_LOSS_LOG
+#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 		else
 			dprintk("dvb_demux.c pusi not seen, discarding section data\n");
 #endif
@@ -317,7 +313,7 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 	}
 
 	if (!ccok || dc_i) {
-#ifdef DVB_DEMUX_SECTION_LOSS_LOG
+#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 		dprintk("dvb_demux.c discontinuity detected %d bytes lost\n",
 			count);
 		/*
@@ -349,7 +345,7 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 			dvb_dmx_swfilter_section_copy_dump(feed, after,
 							   after_len);
 		}
-#ifdef DVB_DEMUX_SECTION_LOSS_LOG
+#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 		else if (count > 0)
 			dprintk("dvb_demux.c PUSI=1 but %d bytes lost\n",
 				count);
-- 
2.7.4


