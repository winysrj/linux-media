Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60930 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2EAEMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 00:12:49 -0400
Received: by vcqp1 with SMTP id p1so2537620vcq.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 21:12:48 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 07/10] dvb-demux: add functionality to send raw payload to the dvr device
Date: Tue,  1 May 2012 00:12:22 -0400
Message-Id: <1335845545-20879-7-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
References: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Michael Krufky <mkrufky@kernellabs.com>

If your driver needs to deliver the raw payload to userspace without
passing through the kernel demux, use function: dvb_dmx_swfilter_raw

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_demux.c |   10 ++++++++++
 drivers/media/dvb/dvb-core/dvb_demux.h |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
index faa3671..d82469f 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -568,6 +568,16 @@ void dvb_dmx_swfilter_204(struct dvb_demux *demux, const u8 *buf, size_t count)
 }
 EXPORT_SYMBOL(dvb_dmx_swfilter_204);
 
+void dvb_dmx_swfilter_raw(struct dvb_demux *demux, const u8 *buf, size_t count)
+{
+	spin_lock(&demux->lock);
+
+	demux->feed->cb.ts(buf, count, NULL, 0, &demux->feed->feed.ts, DMX_OK);
+
+	spin_unlock(&demux->lock);
+}
+EXPORT_SYMBOL(dvb_dmx_swfilter_raw);
+
 static struct dvb_demux_filter *dvb_dmx_filter_alloc(struct dvb_demux *demux)
 {
 	int i;
diff --git a/drivers/media/dvb/dvb-core/dvb_demux.h b/drivers/media/dvb/dvb-core/dvb_demux.h
index a7d876f..fa7188a 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.h
+++ b/drivers/media/dvb/dvb-core/dvb_demux.h
@@ -145,5 +145,7 @@ void dvb_dmx_swfilter_packets(struct dvb_demux *dvbdmx, const u8 *buf,
 void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count);
 void dvb_dmx_swfilter_204(struct dvb_demux *demux, const u8 *buf,
 			  size_t count);
+void dvb_dmx_swfilter_raw(struct dvb_demux *demux, const u8 *buf,
+			  size_t count);
 
 #endif /* _DVB_DEMUX_H_ */
-- 
1.7.5.4

