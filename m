Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755105AbcJNRrH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 13:47:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/25] [media] dvb_demux: uncomment a packet loss check code
Date: Fri, 14 Oct 2016 14:45:51 -0300
Message-Id: <80f91bcddf727c2bb50b3fc378d9b5640dd2f239.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476466574.git.mchehab@s-opensource.com>
References: <cover.1476466574.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a commented code that also detects packet loss.
Uncomment it and put into the DVB_DEMUX_SECTION_LOSS_LOG
debug Kconfig option.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_demux.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 5a69b0bda4bb..51bf5eb2df49 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -110,21 +110,23 @@ static inline int dvb_dmx_swfilter_payload(struct dvb_demux_feed *feed,
 {
 	int count = payload(buf);
 	int p;
-	//int ccok;
-	//u8 cc;
+#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
+	int ccok;
+	u8 cc;
+#endif
 
 	if (count == 0)
 		return -1;
 
 	p = 188 - count;
 
-	/*
+#ifdef CONFIG_DVB_DEMUX_SECTION_LOSS_LOG
 	cc = buf[3] & 0x0f;
 	ccok = ((feed->cc + 1) & 0x0f) == cc;
 	feed->cc = cc;
 	if (!ccok)
 		dprintk("missed packet!\n");
-	*/
+#endif
 
 	if (buf[1] & 0x40)	// PUSI ?
 		feed->peslen = 0xfffa;
-- 
2.7.4


