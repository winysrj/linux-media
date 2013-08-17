Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:63836 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3HQQcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 12:32:09 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Ming Lei <ming.lei@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v1 42/49] media: dvb-core: prepare for enabling irq in complete()
Date: Sun, 18 Aug 2013 00:25:07 +0800
Message-Id: <1376756714-25479-43-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-1-git-send-email-ming.lei@canonical.com>
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

These functions may be called inside URB->complete(), so use
spin_lock_irqsave().

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/dvb-core/dvb_demux.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
index 3485655..58de441 100644
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -476,7 +476,9 @@ static void dvb_dmx_swfilter_packet(struct dvb_demux *demux, const u8 *buf)
 void dvb_dmx_swfilter_packets(struct dvb_demux *demux, const u8 *buf,
 			      size_t count)
 {
-	spin_lock(&demux->lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&demux->lock, flags);
 
 	while (count--) {
 		if (buf[0] == 0x47)
@@ -484,7 +486,7 @@ void dvb_dmx_swfilter_packets(struct dvb_demux *demux, const u8 *buf,
 		buf += 188;
 	}
 
-	spin_unlock(&demux->lock);
+	spin_unlock_irqrestore(&demux->lock, flags);
 }
 
 EXPORT_SYMBOL(dvb_dmx_swfilter_packets);
@@ -519,8 +521,9 @@ static inline void _dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf,
 {
 	int p = 0, i, j;
 	const u8 *q;
+	unsigned long flags;
 
-	spin_lock(&demux->lock);
+	spin_lock_irqsave(&demux->lock, flags);
 
 	if (demux->tsbufp) { /* tsbuf[0] is now 0x47. */
 		i = demux->tsbufp;
@@ -564,7 +567,7 @@ static inline void _dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf,
 	}
 
 bailout:
-	spin_unlock(&demux->lock);
+	spin_unlock_irqrestore(&demux->lock, flags);
 }
 
 void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count)
@@ -581,11 +584,13 @@ EXPORT_SYMBOL(dvb_dmx_swfilter_204);
 
 void dvb_dmx_swfilter_raw(struct dvb_demux *demux, const u8 *buf, size_t count)
 {
-	spin_lock(&demux->lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&demux->lock, flags);
 
 	demux->feed->cb.ts(buf, count, NULL, 0, &demux->feed->feed.ts, DMX_OK);
 
-	spin_unlock(&demux->lock);
+	spin_unlock_irqrestore(&demux->lock, flags);
 }
 EXPORT_SYMBOL(dvb_dmx_swfilter_raw);
 
-- 
1.7.9.5

