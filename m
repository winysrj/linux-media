Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51081 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751480AbeA2MuO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 07:50:14 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/2] media: dvb_demux: Better handle discontinuity errors
Date: Mon, 29 Jan 2018 07:50:07 -0500
Message-Id: <fed488b3956b6dc637bec6b5a0bc10d6435da9f5.1517230202.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

When a packet discontinuity happens, it is not just the payload
that was lost. The headers are lost too. So, the max size is not
184 but, instead 188.

Also, while printing warnings, make a distinction between
MPEG-TS indicated discontinuity and detected one.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 5047a1f87050..1a6e2e61952a 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -310,8 +310,9 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 
 	if (!ccok || dc_i) {
 #ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
-		dprintk("dvb_demux.c discontinuity detected %d bytes lost\n",
-			count);
+		dprintk("discontinuity %s: %d bytes lost\n",
+			!ccok ? "detected" : "indicated",
+			count + 4);
 		/*
 		 * those bytes under sume circumstances will again be reported
 		 * in the following dvb_dmx_swfilter_section_new
@@ -320,6 +321,9 @@ static int dvb_dmx_swfilter_section_packet(struct dvb_demux_feed *feed,
 		/*
 		 * Discontinuity detected. Reset pusi_seen to
 		 * stop feeding of suspicious data until next PUSI=1 arrives
+		 *
+		 * FIXME: does it make sense if the MPEG-TS is the one
+		 *	reporting discontinuity?
 		 */
 		feed->pusi_seen = false;
 		dvb_dmx_swfilter_section_new(feed);
-- 
2.14.3
