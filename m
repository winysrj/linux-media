Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:36140 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163Ab0HGJrV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Aug 2010 05:47:21 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id E7EBFC79B5
	for <linux-media@vger.kernel.org>; Sat,  7 Aug 2010 12:47:19 +0300 (EEST)
Received: from tammi.koti (a88-114-153-83.elisa-laajakaista.fi [88.114.153.83])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id CE13E2BD45
	for <linux-media@vger.kernel.org>; Sat,  7 Aug 2010 12:47:18 +0300 (EEST)
Message-ID: <4C5D2BA1.60804@kolumbus.fi>
Date: Sat, 07 Aug 2010 12:47:13 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Avoid unnecessary data copying inside dvb_dmx_swfilter_204()
 function
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi.

This patch is like the original, but without mangled spaces.
I found Documentation/email-clients.txt to be useful for tuning Thunderbird.

DVB-S2 users with high volume stream data are interested in trying this patch too.

Signed-off-by: Marko Ristola <marko.ristola@kolumbus.fi>

diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
index 977ddba..b71d77d 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -478,97 +478,96 @@ void dvb_dmx_swfilter_packets(struct dvb_demux *demux, const u8 *buf,
 
 EXPORT_SYMBOL(dvb_dmx_swfilter_packets);
 
-void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count)
+static inline int findNextPacket(const u8 *buf, int pos, size_t count,
+				   const int pktsize)
 {
-	int p = 0, i, j;
+	int start = pos, lost;
 
-	spin_lock(&demux->lock);
-
-	if (demux->tsbufp) {
-		i = demux->tsbufp;
-		j = 188 - i;
-		if (count < j) {
-			memcpy(&demux->tsbuf[i], buf, count);
-			demux->tsbufp += count;
-			goto bailout;
-		}
-		memcpy(&demux->tsbuf[i], buf, j);
-		if (demux->tsbuf[0] == 0x47)
-			dvb_dmx_swfilter_packet(demux, demux->tsbuf);
-		demux->tsbufp = 0;
-		p += j;
+	while(likely(pos < count)) {
+		if (likely(buf[pos] == 0x47 ||
+		    (pktsize == 204 && buf[pos] == 0xB8)))
+			break;
+		pos++;
 	}
 
-	while (p < count) {
-		if (buf[p] == 0x47) {
-			if (count - p >= 188) {
-				dvb_dmx_swfilter_packet(demux, &buf[p]);
-				p += 188;
-			} else {
-				i = count - p;
-				memcpy(demux->tsbuf, &buf[p], i);
-				demux->tsbufp = i;
-				goto bailout;
-			}
-		} else
-			p++;
+	if (unlikely(lost = pos - start)) {
+		/* This garbage is part of a valid packet? */
+		int backtrack = pos - pktsize;
+		if (backtrack >= 0 && (buf[backtrack] == 0x47 ||
+		    (pktsize == 204 && buf[backtrack] == 0xB8))) {
+			/* printk("demux: backtracked %d bytes"
+			 * "\n", start - backtrack); */
+			return backtrack;
+		}
+		/*printk("demux: skipped %d bytes at %d\n", lost, start); */
 	}
 
-bailout:
-	spin_unlock(&demux->lock);
+	return pos;
 }
 
-EXPORT_SYMBOL(dvb_dmx_swfilter);
-
-void dvb_dmx_swfilter_204(struct dvb_demux *demux, const u8 *buf, size_t count)
+/* Filter all pktsize= 188 or 204 sized packets and skip garbage. */
+static inline void _dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf,
+		size_t count, const int pktsize)
 {
 	int p = 0, i, j;
-	u8 tmppack[188];
+	const u8 *q;
 
 	spin_lock(&demux->lock);
 
-	if (demux->tsbufp) {
+	if (likely(demux->tsbufp)) { /* tsbuf[0] is now 0x47. */
 		i = demux->tsbufp;
-		j = 204 - i;
-		if (count < j) {
+		j = pktsize - i;
+		if (unlikely(count < j)) {
 			memcpy(&demux->tsbuf[i], buf, count);
 			demux->tsbufp += count;
 			goto bailout;
 		}
 		memcpy(&demux->tsbuf[i], buf, j);
-		if ((demux->tsbuf[0] == 0x47) || (demux->tsbuf[0] == 0xB8)) {
-			memcpy(tmppack, demux->tsbuf, 188);
-			if (tmppack[0] == 0xB8)
-				tmppack[0] = 0x47;
-			dvb_dmx_swfilter_packet(demux, tmppack);
-		}
+		if (likely(demux->tsbuf[0] == 0x47)) /* double check */
+			dvb_dmx_swfilter_packet(demux, demux->tsbuf);
 		demux->tsbufp = 0;
 		p += j;
 	}
 
-	while (p < count) {
-		if ((buf[p] == 0x47) || (buf[p] == 0xB8)) {
-			if (count - p >= 204) {
-				memcpy(tmppack, &buf[p], 188);
-				if (tmppack[0] == 0xB8)
-					tmppack[0] = 0x47;
-				dvb_dmx_swfilter_packet(demux, tmppack);
-				p += 204;
-			} else {
-				i = count - p;
-				memcpy(demux->tsbuf, &buf[p], i);
-				demux->tsbufp = i;
-				goto bailout;
-			}
-		} else {
-			p++;
+	while (likely((p = findNextPacket(buf, p, count, pktsize)) < count)) {
+		if (unlikely(count - p < pktsize))
+			break;
+
+		q = &buf[p];
+
+		if (unlikely(pktsize == 204 && (*q == 0xB8))) {
+			memcpy(demux->tsbuf, q, 188);
+			demux->tsbuf[0] = 0x47;
+			q = demux->tsbuf;
 		}
+		dvb_dmx_swfilter_packet(demux, q);
+		p += pktsize;
+	}
+
+	i = count - p;
+	if (likely(i)) {
+		memcpy(demux->tsbuf, &buf[p], i);
+		demux->tsbufp = i;
+		if (unlikely(pktsize == 204 && demux->tsbuf[0] == 0xB8))
+			demux->tsbuf[0] = 0x47;
 	}
 
 bailout:
 	spin_unlock(&demux->lock);
 }
 
+void dvb_dmx_swfilter(struct dvb_demux *demux, const u8 *buf, size_t count)
+{
+	_dvb_dmx_swfilter(demux, buf, count, 188);
+}
+
+EXPORT_SYMBOL(dvb_dmx_swfilter);
+
+void dvb_dmx_swfilter_204(struct dvb_demux *demux, const u8 *buf, size_t count)
+{
+	_dvb_dmx_swfilter(demux, buf, count, 204);
+}
+
 EXPORT_SYMBOL(dvb_dmx_swfilter_204);
 
 static struct dvb_demux_filter *dvb_dmx_filter_alloc(struct dvb_demux *demux)

