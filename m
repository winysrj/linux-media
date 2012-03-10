Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp509.mail.kks.yahoo.co.jp ([114.111.99.158]:23435 "HELO
	smtp509.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755223Ab2CJPpb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Mar 2012 10:45:31 -0500
From: tskd2@yahoo.co.jp
To: linux-media@vger.kernel.org
Cc: Akihiro Tsukada <tskd2@yahoo.co.jp>
Subject: [PATCH 2/4] dvb: earth-pt1: add an error check/report on the incoming data
Date: Sun, 11 Mar 2012 00:38:14 +0900
Message-Id: <1331393896-17902-2-git-send-email-tskd2@yahoo.co.jp>
In-Reply-To: <1331393896-17902-1-git-send-email-tskd2@yahoo.co.jp>
References: <1331393896-17902-1-git-send-email-tskd2@yahoo.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd2@yahoo.co.jp>

This patch adds a data integrity check using the sequence counter and error flags added by the bridge chip.

Signed-off-by: Akihiro Tsukada <tskd2@yahoo.co.jp>
---
 drivers/media/dvb/pt1/pt1.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/pt1/pt1.c b/drivers/media/dvb/pt1/pt1.c
index 463f784..8229a91 100644
--- a/drivers/media/dvb/pt1/pt1.c
+++ b/drivers/media/dvb/pt1/pt1.c
@@ -28,6 +28,7 @@
 #include <linux/pci.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/ratelimit.h>
 
 #include "dvbdev.h"
 #include "dvb_demux.h"
@@ -92,6 +93,7 @@ struct pt1_adapter {
 	u8 *buf;
 	int upacket_count;
 	int packet_count;
+	int st_count;
 
 	struct dvb_adapter adap;
 	struct dvb_demux demux;
@@ -266,6 +268,7 @@ static int pt1_filter(struct pt1 *pt1, struct pt1_buffer_page *page)
 	struct pt1_adapter *adap;
 	int offset;
 	u8 *buf;
+	int sc;
 
 	if (!page->upackets[PT1_NR_UPACKETS - 1])
 		return 0;
@@ -282,6 +285,16 @@ static int pt1_filter(struct pt1 *pt1, struct pt1_buffer_page *page)
 		else if (!adap->upacket_count)
 			continue;
 
+		if (upacket >> 24 & 1)
+			printk_ratelimited(KERN_INFO "earth-pt1: device "
+				"buffer overflowing. table[%d] buf[%d]\n",
+				pt1->table_index, pt1->buf_index);
+		sc = upacket >> 26 & 0x7;
+		if (adap->st_count != -1 && sc != ((adap->st_count + 1) & 0x7))
+			printk_ratelimited(KERN_INFO "earth-pt1: data loss"
+				" in streamID(adapter)[%d]\n", index);
+		adap->st_count = sc;
+
 		buf = adap->buf;
 		offset = adap->packet_count * 188 + adap->upacket_count * 3;
 		buf[offset] = upacket >> 16;
@@ -652,6 +665,7 @@ pt1_alloc_adapter(struct pt1 *pt1)
 	adap->buf = buf;
 	adap->upacket_count = 0;
 	adap->packet_count = 0;
+	adap->st_count = -1;
 
 	dvb_adap = &adap->adap;
 	dvb_adap->priv = adap;
-- 
1.7.7.6

