Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34063 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbeA2MuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 07:50:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/2] media: dvb_demux: improve debug messages
Date: Mon, 29 Jan 2018 07:50:08 -0500
Message-Id: <0f3827351ed39aeca0bea8f99813e2964e10c497.1517230202.git.mchehab@s-opensource.com>
In-Reply-To: <fed488b3956b6dc637bec6b5a0bc10d6435da9f5.1517230202.git.mchehab@s-opensource.com>
References: <fed488b3956b6dc637bec6b5a0bc10d6435da9f5.1517230202.git.mchehab@s-opensource.com>
In-Reply-To: <fed488b3956b6dc637bec6b5a0bc10d6435da9f5.1517230202.git.mchehab@s-opensource.com>
References: <fed488b3956b6dc637bec6b5a0bc10d6435da9f5.1517230202.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Do some cleanup of debug messages, making them cleaner and
easier to be used to analyze what's going on.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.c | 43 +++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 1a6e2e61952a..210eed0269b0 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -119,7 +119,8 @@ static inline int dvb_dmx_swfilter_payload(struct dvb_demux_feed *feed,
 	ccok = ((feed->cc + 1) & 0x0f) == cc;
 	feed->cc = cc;
 	if (!ccok)
-		dprintk("missed packet!\n");
+		dprintk("missed packet: %d instead of %d!\n",
+			cc, (feed->cc + 1) & 0x0f);
 #endif
 
 	if (buf[1] & 0x40)	// PUSI ?
@@ -188,7 +189,7 @@ static void dvb_dmx_swfilter_section_new(struct dvb_demux_feed *feed)
 
 #ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 	if (sec->secbufp < sec->tsfeedp) {
-		int i, n = sec->tsfeedp - sec->secbufp;
+		int n = sec->tsfeedp - sec->secbufp;
 
 		/*
 		 * Section padding is done with 0xff bytes entirely.
@@ -196,12 +197,9 @@ static void dvb_dmx_swfilter_section_new(struct dvb_demux_feed *feed)
 		 * but just first and last.
 		 */
 		if (sec->secbuf[0] != 0xff || sec->secbuf[n - 1] != 0xff) {
-			dprintk("dvb_demux.c section ts padding loss: %d/%d\n",
+			dprintk("section ts padding loss: %d/%d\n",
 			       n, sec->tsfeedp);
-			dprintk("dvb_demux.c pad data:");
-			for (i = 0; i < n; i++)
-				pr_cont(" %02x", sec->secbuf[i]);
-			pr_cont("\n");
+			dprintk("pad data: %*ph\n", n, sec->secbuf);
 		}
 	}
 #endif
@@ -240,9 +238,9 @@ static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
 
 	if (sec->tsfeedp + len > DMX_MAX_SECFEED_SIZE) {
 #ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
-		dprintk("dvb_demux.c section buffer full loss: %d/%d\n",
-		       sec->tsfeedp + len - DMX_MAX_SECFEED_SIZE,
-		       DMX_MAX_SECFEED_SIZE);
+		dprintk("section buffer full loss: %d/%d\n",
+			sec->tsfeedp + len - DMX_MAX_SECFEED_SIZE,
+			DMX_MAX_SECFEED_SIZE);
 #endif
 		len = DMX_MAX_SECFEED_SIZE - sec->tsfeedp;
 	}
@@ -275,7 +273,7 @@ static int dvb_dmx_swfilter_section_copy_dump(struct dvb_demux_feed *feed,
 			dvb_dmx_swfilter_section_feed(feed);
 #ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 		else
-			dprintk("dvb_demux.c pusi not seen, discarding section data\n");
+			dprintk("pusi not seen, discarding section data\n");
 #endif
 		sec->secbufp += seclen;	/* secbufp and secbuf moving together is */
 		sec->secbuf += seclen;	/* redundant but saves pointer arithmetic */
@@ -310,9 +308,12 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 
 	if (!ccok || dc_i) {
 #ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
-		dprintk("discontinuity %s: %d bytes lost\n",
-			!ccok ? "detected" : "indicated",
-			count + 4);
+		if (dc_i)
+			dprintk("%d frame with disconnect indicator\n",
+				cc);
+		else
+			dprintk("discontinuity: %d instead of %d. %d bytes lost\n",
+				cc, (feed->cc + 1) & 0x0f, count + 4);
 		/*
 		 * those bytes under sume circumstances will again be reported
 		 * in the following dvb_dmx_swfilter_section_new
@@ -347,8 +348,7 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 		}
 #ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 		else if (count > 0)
-			dprintk("dvb_demux.c PUSI=1 but %d bytes lost\n",
-				count);
+			dprintk("PUSI=1 but %d bytes lost\n", count);
 #endif
 	} else {
 		/* PUSI=0 (is not set), no section boundary */
@@ -418,9 +418,10 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 						1024);
 				speed_timedelta = ktime_ms_delta(cur_time,
 							demux->speed_last_time);
-				dprintk("TS speed %llu Kbits/sec \n",
-					div64_u64(speed_bytes,
-						  speed_timedelta));
+				if (speed_timedelta)
+					dprintk("TS speed %llu Kbits/sec \n",
+						div64_u64(speed_bytes,
+							  speed_timedelta));
 			}
 
 			demux->speed_last_time = cur_time;
@@ -445,8 +446,8 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 
 				if ((buf[3] & 0xf) != demux->cnt_storage[pid]) {
 					dprintk_tscheck("TS packet counter mismatch. PID=0x%x expected 0x%x got 0x%x\n",
-						pid, demux->cnt_storage[pid],
-						buf[3] & 0xf);
+							pid, demux->cnt_storage[pid],
+							buf[3] & 0xf);
 					demux->cnt_storage[pid] = buf[3] & 0xf;
 				}
 			}
-- 
2.14.3
