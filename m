Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752754AbcKSO5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 09:57:07 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] [media] dvb_net: prepare to split a very complex function
Date: Sat, 19 Nov 2016 12:56:58 -0200
Message-Id: <ede5fe8a813bd439768fe37036b37eddc2fcf7e4.1479567006.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479567006.git.mchehab@s-opensource.com>
References: <20161027150848.3623829-1-arnd@arndb.de>
 <cover.1479567006.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479567006.git.mchehab@s-opensource.com>
References: <cover.1479567006.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb_net code has a really complex function, meant to handle
DVB network packages: it is long, has several loops and ifs
inside, and even cause warnings with gcc5.

Prepare it to be split into smaller functions by storing all
arguments and internal vars inside a struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_net.c | 465 +++++++++++++++++++++------------------
 1 file changed, 245 insertions(+), 220 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index b9a46d5a1bb5..6fef0fc61cd2 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -311,323 +311,348 @@ static inline void reset_ule( struct dvb_net_priv *p )
  * Decode ULE SNDUs according to draft-ietf-ipdvb-ule-03.txt from a sequence of
  * TS cells of a single PID.
  */
-static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
-{
-	struct dvb_net_priv *priv = netdev_priv(dev);
-	unsigned long skipped = 0L;
-	const u8 *ts, *ts_end, *from_where = NULL;
-	u8 ts_remain = 0, how_much = 0, new_ts = 1;
-	struct ethhdr *ethh = NULL;
-	bool error = false;
 
+struct dvb_net_ule_handle {
+	struct net_device *dev;
+	struct dvb_net_priv *priv;
+	struct ethhdr *ethh;
+	const u8 *buf;
+	size_t buf_len;
+	unsigned long skipped;
+	const u8 *ts, *ts_end, *from_where;
+	u8 ts_remain, how_much, new_ts;
+	bool error;
 #ifdef ULE_DEBUG
-	/* The code inside ULE_DEBUG keeps a history of the last 100 TS cells processed. */
+	/*
+	 * The code inside ULE_DEBUG keeps a history of the
+	 * last 100 TS cells processed.
+	 */
 	static unsigned char ule_hist[100*TS_SZ];
 	static unsigned char *ule_where = ule_hist, ule_dump;
 #endif
+};
+
+static void dvb_net_ule(struct net_device *dev, const u8 *buf, size_t buf_len)
+{
+	struct dvb_net_ule_handle h = {
+		.dev = dev,
+		.buf = buf,
+		.buf_len = buf_len,
+		.skipped = 0L,
+		.ts = NULL,
+		.ts_end = NULL,
+		.from_where = NULL,
+		.ts_remain = 0,
+		.how_much = 0,
+		.new_ts = 1,
+		.ethh = NULL,
+		.error = false,
+#ifdef ULE_DEBUG
+		.ule_where = ule_hist,
+#endif
+	};
 
 	/* For all TS cells in current buffer.
 	 * Appearently, we are called for every single TS cell.
 	 */
-	for (ts = buf, ts_end = buf + buf_len; ts < ts_end; /* no default incr. */ ) {
-
-		if (new_ts) {
+	for (h.ts = h.buf, h.ts_end = h.buf + h.buf_len; h.ts < h.ts_end; /* no incr. */ ) {
+		if (h.new_ts) {
 			/* We are about to process a new TS cell. */
 
 #ifdef ULE_DEBUG
-			if (ule_where >= &ule_hist[100*TS_SZ]) ule_where = ule_hist;
-			memcpy( ule_where, ts, TS_SZ );
-			if (ule_dump) {
-				hexdump( ule_where, TS_SZ );
-				ule_dump = 0;
+			if (h.ule_where >= &h.ule_hist[100*TS_SZ]) h.ule_where = h.ule_hist;
+			memcpy( h.ule_where, h.ts, TS_SZ );
+			if (h.ule_dump) {
+				hexdump( h.ule_where, TS_SZ );
+				h.ule_dump = 0;
 			}
-			ule_where += TS_SZ;
+			h.ule_where += TS_SZ;
 #endif
 
-			/* Check TS error conditions: sync_byte, transport_error_indicator, scrambling_control . */
-			if ((ts[0] != TS_SYNC) || (ts[1] & TS_TEI) || ((ts[3] & TS_SC) != 0)) {
+			/* Check TS h.error conditions: sync_byte, transport_error_indicator, scrambling_control . */
+			if ((h.ts[0] != TS_SYNC) || (h.ts[1] & TS_TEI) || ((h.ts[3] & TS_SC) != 0)) {
 				pr_warn("%lu: Invalid TS cell: SYNC %#x, TEI %u, SC %#x.\n",
-				       priv->ts_count, ts[0],
-				       (ts[1] & TS_TEI) >> 7,
-				       (ts[3] & TS_SC) >> 6);
+				       h.priv->ts_count, h.ts[0],
+				       (h.ts[1] & TS_TEI) >> 7,
+				       (h.ts[3] & TS_SC) >> 6);
 
 				/* Drop partly decoded SNDU, reset state, resync on PUSI. */
-				if (priv->ule_skb) {
-					dev_kfree_skb( priv->ule_skb );
+				if (h.priv->ule_skb) {
+					dev_kfree_skb( h.priv->ule_skb );
 					/* Prepare for next SNDU. */
-					dev->stats.rx_errors++;
-					dev->stats.rx_frame_errors++;
+					h.dev->stats.rx_errors++;
+					h.dev->stats.rx_frame_errors++;
 				}
-				reset_ule(priv);
-				priv->need_pusi = 1;
+				reset_ule(h.priv);
+				h.priv->need_pusi = 1;
 
 				/* Continue with next TS cell. */
-				ts += TS_SZ;
-				priv->ts_count++;
+				h.ts += TS_SZ;
+				h.priv->ts_count++;
 				continue;
 			}
 
-			ts_remain = 184;
-			from_where = ts + 4;
+			h.ts_remain = 184;
+			h.from_where = h.ts + 4;
 		}
 		/* Synchronize on PUSI, if required. */
-		if (priv->need_pusi) {
-			if (ts[1] & TS_PUSI) {
+		if (h.priv->need_pusi) {
+			if (h.ts[1] & TS_PUSI) {
 				/* Find beginning of first ULE SNDU in current TS cell. */
 				/* Synchronize continuity counter. */
-				priv->tscc = ts[3] & 0x0F;
+				h.priv->tscc = h.ts[3] & 0x0F;
 				/* There is a pointer field here. */
-				if (ts[4] > ts_remain) {
+				if (h.ts[4] > h.ts_remain) {
 					pr_err("%lu: Invalid ULE packet (pointer field %d)\n",
-					       priv->ts_count, ts[4]);
-					ts += TS_SZ;
-					priv->ts_count++;
+					       h.priv->ts_count, h.ts[4]);
+					h.ts += TS_SZ;
+					h.priv->ts_count++;
 					continue;
 				}
 				/* Skip to destination of pointer field. */
-				from_where = &ts[5] + ts[4];
-				ts_remain -= 1 + ts[4];
-				skipped = 0;
+				h.from_where = &h.ts[5] + h.ts[4];
+				h.ts_remain -= 1 + h.ts[4];
+				h.skipped = 0;
 			} else {
-				skipped++;
-				ts += TS_SZ;
-				priv->ts_count++;
+				h.skipped++;
+				h.ts += TS_SZ;
+				h.priv->ts_count++;
 				continue;
 			}
 		}
 
-		if (new_ts) {
+		if (h.new_ts) {
 			/* Check continuity counter. */
-			if ((ts[3] & 0x0F) == priv->tscc)
-				priv->tscc = (priv->tscc + 1) & 0x0F;
+			if ((h.ts[3] & 0x0F) == h.priv->tscc)
+				h.priv->tscc = (h.priv->tscc + 1) & 0x0F;
 			else {
 				/* TS discontinuity handling: */
 				pr_warn("%lu: TS discontinuity: got %#x, expected %#x.\n",
-					priv->ts_count, ts[3] & 0x0F,
-					priv->tscc);
+					h.priv->ts_count, h.ts[3] & 0x0F,
+					h.priv->tscc);
 				/* Drop partly decoded SNDU, reset state, resync on PUSI. */
-				if (priv->ule_skb) {
-					dev_kfree_skb( priv->ule_skb );
+				if (h.priv->ule_skb) {
+					dev_kfree_skb( h.priv->ule_skb );
 					/* Prepare for next SNDU. */
-					// reset_ule(priv);  moved to below.
-					dev->stats.rx_errors++;
-					dev->stats.rx_frame_errors++;
+					// reset_ule(h.priv);  moved to below.
+					h.dev->stats.rx_errors++;
+					h.dev->stats.rx_frame_errors++;
 				}
-				reset_ule(priv);
+				reset_ule(h.priv);
 				/* skip to next PUSI. */
-				priv->need_pusi = 1;
+				h.priv->need_pusi = 1;
 				continue;
 			}
 			/* If we still have an incomplete payload, but PUSI is
 			 * set; some TS cells are missing.
 			 * This is only possible here, if we missed exactly 16 TS
 			 * cells (continuity counter wrap). */
-			if (ts[1] & TS_PUSI) {
-				if (! priv->need_pusi) {
-					if (!(*from_where < (ts_remain-1)) || *from_where != priv->ule_sndu_remain) {
+			if (h.ts[1] & TS_PUSI) {
+				if (! h.priv->need_pusi) {
+					if (!(*h.from_where < (h.ts_remain-1)) || *h.from_where != h.priv->ule_sndu_remain) {
 						/* Pointer field is invalid.  Drop this TS cell and any started ULE SNDU. */
 						pr_warn("%lu: Invalid pointer field: %u.\n",
-							priv->ts_count,
-							*from_where);
+							h.priv->ts_count,
+							*h.from_where);
 
 						/* Drop partly decoded SNDU, reset state, resync on PUSI. */
-						if (priv->ule_skb) {
-							error = true;
-							dev_kfree_skb(priv->ule_skb);
+						if (h.priv->ule_skb) {
+							h.error = true;
+							dev_kfree_skb(h.priv->ule_skb);
 						}
 
-						if (error || priv->ule_sndu_remain) {
-							dev->stats.rx_errors++;
-							dev->stats.rx_frame_errors++;
-							error = false;
+						if (h.error || h.priv->ule_sndu_remain) {
+							h.dev->stats.rx_errors++;
+							h.dev->stats.rx_frame_errors++;
+							h.error = false;
 						}
 
-						reset_ule(priv);
-						priv->need_pusi = 1;
+						reset_ule(h.priv);
+						h.priv->need_pusi = 1;
 						continue;
 					}
 					/* Skip pointer field (we're processing a
 					 * packed payload). */
-					from_where += 1;
-					ts_remain -= 1;
+					h.from_where += 1;
+					h.ts_remain -= 1;
 				} else
-					priv->need_pusi = 0;
+					h.priv->need_pusi = 0;
 
-				if (priv->ule_sndu_remain > 183) {
+				if (h.priv->ule_sndu_remain > 183) {
 					/* Current SNDU lacks more data than there could be available in the
 					 * current TS cell. */
-					dev->stats.rx_errors++;
-					dev->stats.rx_length_errors++;
-					pr_warn("%lu: Expected %d more SNDU bytes, but got PUSI (pf %d, ts_remain %d).  Flushing incomplete payload.\n",
-						priv->ts_count,
-						priv->ule_sndu_remain,
-						ts[4], ts_remain);
-					dev_kfree_skb(priv->ule_skb);
+					h.dev->stats.rx_errors++;
+					h.dev->stats.rx_length_errors++;
+					pr_warn("%lu: Expected %d more SNDU bytes, but got PUSI (pf %d, h.ts_remain %d).  Flushing incomplete payload.\n",
+						h.priv->ts_count,
+						h.priv->ule_sndu_remain,
+						h.ts[4], h.ts_remain);
+					dev_kfree_skb(h.priv->ule_skb);
 					/* Prepare for next SNDU. */
-					reset_ule(priv);
+					reset_ule(h.priv);
 					/* Resync: go to where pointer field points to: start of next ULE SNDU. */
-					from_where += ts[4];
-					ts_remain -= ts[4];
+					h.from_where += h.ts[4];
+					h.ts_remain -= h.ts[4];
 				}
 			}
 		}
 
 		/* Check if new payload needs to be started. */
-		if (priv->ule_skb == NULL) {
+		if (h.priv->ule_skb == NULL) {
 			/* Start a new payload with skb.
 			 * Find ULE header.  It is only guaranteed that the
 			 * length field (2 bytes) is contained in the current
 			 * TS.
-			 * Check ts_remain has to be >= 2 here. */
-			if (ts_remain < 2) {
+			 * Check h.ts_remain has to be >= 2 here. */
+			if (h.ts_remain < 2) {
 				pr_warn("Invalid payload packing: only %d bytes left in TS.  Resyncing.\n",
-					ts_remain);
-				priv->ule_sndu_len = 0;
-				priv->need_pusi = 1;
-				ts += TS_SZ;
+					h.ts_remain);
+				h.priv->ule_sndu_len = 0;
+				h.priv->need_pusi = 1;
+				h.ts += TS_SZ;
 				continue;
 			}
 
-			if (! priv->ule_sndu_len) {
+			if (! h.priv->ule_sndu_len) {
 				/* Got at least two bytes, thus extrace the SNDU length. */
-				priv->ule_sndu_len = from_where[0] << 8 | from_where[1];
-				if (priv->ule_sndu_len & 0x8000) {
+				h.priv->ule_sndu_len = h.from_where[0] << 8 | h.from_where[1];
+				if (h.priv->ule_sndu_len & 0x8000) {
 					/* D-Bit is set: no dest mac present. */
-					priv->ule_sndu_len &= 0x7FFF;
-					priv->ule_dbit = 1;
+					h.priv->ule_sndu_len &= 0x7FFF;
+					h.priv->ule_dbit = 1;
 				} else
-					priv->ule_dbit = 0;
+					h.priv->ule_dbit = 0;
 
-				if (priv->ule_sndu_len < 5) {
+				if (h.priv->ule_sndu_len < 5) {
 					pr_warn("%lu: Invalid ULE SNDU length %u. Resyncing.\n",
-						priv->ts_count,
-						priv->ule_sndu_len);
-					dev->stats.rx_errors++;
-					dev->stats.rx_length_errors++;
-					priv->ule_sndu_len = 0;
-					priv->need_pusi = 1;
-					new_ts = 1;
-					ts += TS_SZ;
-					priv->ts_count++;
+						h.priv->ts_count,
+						h.priv->ule_sndu_len);
+					h.dev->stats.rx_errors++;
+					h.dev->stats.rx_length_errors++;
+					h.priv->ule_sndu_len = 0;
+					h.priv->need_pusi = 1;
+					h.new_ts = 1;
+					h.ts += TS_SZ;
+					h.priv->ts_count++;
 					continue;
 				}
-				ts_remain -= 2;	/* consume the 2 bytes SNDU length. */
-				from_where += 2;
+				h.ts_remain -= 2;	/* consume the 2 bytes SNDU length. */
+				h.from_where += 2;
 			}
 
-			priv->ule_sndu_remain = priv->ule_sndu_len + 2;
+			h.priv->ule_sndu_remain = h.priv->ule_sndu_len + 2;
 			/*
 			 * State of current TS:
-			 *   ts_remain (remaining bytes in the current TS cell)
+			 *   h.ts_remain (remaining bytes in the current TS cell)
 			 *   0	ule_type is not available now, we need the next TS cell
 			 *   1	the first byte of the ule_type is present
 			 * >=2	full ULE header present, maybe some payload data as well.
 			 */
-			switch (ts_remain) {
+			switch (h.ts_remain) {
 				case 1:
-					priv->ule_sndu_remain--;
-					priv->ule_sndu_type = from_where[0] << 8;
-					priv->ule_sndu_type_1 = 1; /* first byte of ule_type is set. */
-					ts_remain -= 1; from_where += 1;
+					h.priv->ule_sndu_remain--;
+					h.priv->ule_sndu_type = h.from_where[0] << 8;
+					h.priv->ule_sndu_type_1 = 1; /* first byte of ule_type is set. */
+					h.ts_remain -= 1; h.from_where += 1;
 					/* Continue w/ next TS. */
 				case 0:
-					new_ts = 1;
-					ts += TS_SZ;
-					priv->ts_count++;
+					h.new_ts = 1;
+					h.ts += TS_SZ;
+					h.priv->ts_count++;
 					continue;
 
 				default: /* complete ULE header is present in current TS. */
 					/* Extract ULE type field. */
-					if (priv->ule_sndu_type_1) {
-						priv->ule_sndu_type_1 = 0;
-						priv->ule_sndu_type |= from_where[0];
-						from_where += 1; /* points to payload start. */
-						ts_remain -= 1;
+					if (h.priv->ule_sndu_type_1) {
+						h.priv->ule_sndu_type_1 = 0;
+						h.priv->ule_sndu_type |= h.from_where[0];
+						h.from_where += 1; /* points to payload start. */
+						h.ts_remain -= 1;
 					} else {
 						/* Complete type is present in new TS. */
-						priv->ule_sndu_type = from_where[0] << 8 | from_where[1];
-						from_where += 2; /* points to payload start. */
-						ts_remain -= 2;
+						h.priv->ule_sndu_type = h.from_where[0] << 8 | h.from_where[1];
+						h.from_where += 2; /* points to payload start. */
+						h.ts_remain -= 2;
 					}
 					break;
 			}
 
 			/* Allocate the skb (decoder target buffer) with the correct size, as follows:
 			 * prepare for the largest case: bridged SNDU with MAC address (dbit = 0). */
-			priv->ule_skb = dev_alloc_skb( priv->ule_sndu_len + ETH_HLEN + ETH_ALEN );
-			if (priv->ule_skb == NULL) {
+			h.priv->ule_skb = dev_alloc_skb( h.priv->ule_sndu_len + ETH_HLEN + ETH_ALEN );
+			if (h.priv->ule_skb == NULL) {
 				pr_notice("%s: Memory squeeze, dropping packet.\n",
-					  dev->name);
-				dev->stats.rx_dropped++;
+					  h.dev->name);
+				h.dev->stats.rx_dropped++;
 				return;
 			}
 
 			/* This includes the CRC32 _and_ dest mac, if !dbit. */
-			priv->ule_sndu_remain = priv->ule_sndu_len;
-			priv->ule_skb->dev = dev;
+			h.priv->ule_sndu_remain = h.priv->ule_sndu_len;
+			h.priv->ule_skb->dev = h.dev;
 			/* Leave space for Ethernet or bridged SNDU header (eth hdr plus one MAC addr). */
-			skb_reserve( priv->ule_skb, ETH_HLEN + ETH_ALEN );
+			skb_reserve( h.priv->ule_skb, ETH_HLEN + ETH_ALEN );
 		}
 
 		/* Copy data into our current skb. */
-		how_much = min(priv->ule_sndu_remain, (int)ts_remain);
-		memcpy(skb_put(priv->ule_skb, how_much), from_where, how_much);
-		priv->ule_sndu_remain -= how_much;
-		ts_remain -= how_much;
-		from_where += how_much;
+		h.how_much = min(h.priv->ule_sndu_remain, (int)h.ts_remain);
+		memcpy(skb_put(h.priv->ule_skb, h.how_much), h.from_where, h.how_much);
+		h.priv->ule_sndu_remain -= h.how_much;
+		h.ts_remain -= h.how_much;
+		h.from_where += h.how_much;
 
 		/* Check for complete payload. */
-		if (priv->ule_sndu_remain <= 0) {
+		if (h.priv->ule_sndu_remain <= 0) {
 			/* Check CRC32, we've got it in our skb already. */
-			__be16 ulen = htons(priv->ule_sndu_len);
-			__be16 utype = htons(priv->ule_sndu_type);
+			__be16 ulen = htons(h.priv->ule_sndu_len);
+			__be16 utype = htons(h.priv->ule_sndu_type);
 			const u8 *tail;
 			struct kvec iov[3] = {
 				{ &ulen, sizeof ulen },
 				{ &utype, sizeof utype },
-				{ priv->ule_skb->data, priv->ule_skb->len - 4 }
+				{ h.priv->ule_skb->data, h.priv->ule_skb->len - 4 }
 			};
 			u32 ule_crc = ~0L, expected_crc;
-			if (priv->ule_dbit) {
+			if (h.priv->ule_dbit) {
 				/* Set D-bit for CRC32 verification,
 				 * if it was set originally. */
 				ulen |= htons(0x8000);
 			}
 
 			ule_crc = iov_crc32(ule_crc, iov, 3);
-			tail = skb_tail_pointer(priv->ule_skb);
+			tail = skb_tail_pointer(h.priv->ule_skb);
 			expected_crc = *(tail - 4) << 24 |
 				       *(tail - 3) << 16 |
 				       *(tail - 2) << 8 |
 				       *(tail - 1);
 			if (ule_crc != expected_crc) {
-				pr_warn("%lu: CRC32 check FAILED: %08x / %08x, SNDU len %d type %#x, ts_remain %d, next 2: %x.\n",
-				       priv->ts_count, ule_crc, expected_crc,
-				       priv->ule_sndu_len, priv->ule_sndu_type,
-				       ts_remain,
-				       ts_remain > 2 ? *(unsigned short *)from_where : 0);
+				pr_warn("%lu: CRC32 check FAILED: %08x / %08x, SNDU len %d type %#x, h.ts_remain %d, next 2: %x.\n",
+				       h.priv->ts_count, ule_crc, expected_crc,
+				       h.priv->ule_sndu_len, h.priv->ule_sndu_type,
+				       h.ts_remain,
+				       h.ts_remain > 2 ? *(unsigned short *)h.from_where : 0);
 
 #ifdef ULE_DEBUG
 				hexdump( iov[0].iov_base, iov[0].iov_len );
 				hexdump( iov[1].iov_base, iov[1].iov_len );
 				hexdump( iov[2].iov_base, iov[2].iov_len );
 
-				if (ule_where == ule_hist) {
-					hexdump( &ule_hist[98*TS_SZ], TS_SZ );
-					hexdump( &ule_hist[99*TS_SZ], TS_SZ );
-				} else if (ule_where == &ule_hist[TS_SZ]) {
-					hexdump( &ule_hist[99*TS_SZ], TS_SZ );
-					hexdump( ule_hist, TS_SZ );
+				if (h.ule_where == h.ule_hist) {
+					hexdump( &h.ule_hist[98*TS_SZ], TS_SZ );
+					hexdump( &h.ule_hist[99*TS_SZ], TS_SZ );
+				} else if (h.ule_where == &h.ule_hist[TS_SZ]) {
+					hexdump( &h.ule_hist[99*TS_SZ], TS_SZ );
+					hexdump( h.ule_hist, TS_SZ );
 				} else {
-					hexdump( ule_where - TS_SZ - TS_SZ, TS_SZ );
-					hexdump( ule_where - TS_SZ, TS_SZ );
+					hexdump( h.ule_where - TS_SZ - TS_SZ, TS_SZ );
+					hexdump( h.ule_where - TS_SZ, TS_SZ );
 				}
-				ule_dump = 1;
+				h.ule_dump = 1;
 #endif
 
-				dev->stats.rx_errors++;
-				dev->stats.rx_crc_errors++;
-				dev_kfree_skb(priv->ule_skb);
+				h.dev->stats.rx_errors++;
+				h.dev->stats.rx_crc_errors++;
+				dev_kfree_skb(h.priv->ule_skb);
 			} else {
 				/* CRC32 verified OK. */
 				u8 dest_addr[ETH_ALEN];
@@ -635,10 +660,10 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 					{ [ 0 ... ETH_ALEN-1] = 0xff };
 
 				/* CRC32 was OK. Remove it from skb. */
-				priv->ule_skb->tail -= 4;
-				priv->ule_skb->len -= 4;
+				h.priv->ule_skb->tail -= 4;
+				h.priv->ule_skb->len -= 4;
 
-				if (!priv->ule_dbit) {
+				if (!h.priv->ule_dbit) {
 					/*
 					 * The destination MAC address is the
 					 * next data in the skb.  It comes
@@ -648,26 +673,26 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 					 * should be passed up the stack.
 					 */
 					register int drop = 0;
-					if (priv->rx_mode != RX_MODE_PROMISC) {
-						if (priv->ule_skb->data[0] & 0x01) {
+					if (h.priv->rx_mode != RX_MODE_PROMISC) {
+						if (h.priv->ule_skb->data[0] & 0x01) {
 							/* multicast or broadcast */
-							if (!ether_addr_equal(priv->ule_skb->data, bc_addr)) {
+							if (!ether_addr_equal(h.priv->ule_skb->data, bc_addr)) {
 								/* multicast */
-								if (priv->rx_mode == RX_MODE_MULTI) {
+								if (h.priv->rx_mode == RX_MODE_MULTI) {
 									int i;
-									for(i = 0; i < priv->multi_num &&
-									    !ether_addr_equal(priv->ule_skb->data,
-											      priv->multi_macs[i]); i++)
+									for(i = 0; i < h.priv->multi_num &&
+									    !ether_addr_equal(h.priv->ule_skb->data,
+											      h.priv->multi_macs[i]); i++)
 										;
-									if (i == priv->multi_num)
+									if (i == h.priv->multi_num)
 										drop = 1;
-								} else if (priv->rx_mode != RX_MODE_ALL_MULTI)
+								} else if (h.priv->rx_mode != RX_MODE_ALL_MULTI)
 									drop = 1; /* no broadcast; */
 								/* else: all multicast mode: accept all multicast packets */
 							}
 							/* else: broadcast */
 						}
-						else if (!ether_addr_equal(priv->ule_skb->data, dev->dev_addr))
+						else if (!ether_addr_equal(h.priv->ule_skb->data, h.dev->dev_addr))
 							drop = 1;
 						/* else: destination address matches the MAC address of our receiver device */
 					}
@@ -675,94 +700,94 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 
 					if (drop) {
 #ifdef ULE_DEBUG
-						netdev_dbg(dev, "Dropping SNDU: MAC destination address does not match: dest addr: %pM, dev addr: %pM\n",
-							   priv->ule_skb->data, dev->dev_addr);
+						netdev_dbg(h.dev, "Dropping SNDU: MAC destination address does not match: dest addr: %pM, h.dev addr: %pM\n",
+							   h.priv->ule_skb->data, h.dev->dev_addr);
 #endif
-						dev_kfree_skb(priv->ule_skb);
+						dev_kfree_skb(h.priv->ule_skb);
 						goto sndu_done;
 					}
 					else
 					{
-						skb_copy_from_linear_data(priv->ule_skb,
+						skb_copy_from_linear_data(h.priv->ule_skb,
 							      dest_addr,
 							      ETH_ALEN);
-						skb_pull(priv->ule_skb, ETH_ALEN);
+						skb_pull(h.priv->ule_skb, ETH_ALEN);
 					}
 				}
 
 				/* Handle ULE Extension Headers. */
-				if (priv->ule_sndu_type < ETH_P_802_3_MIN) {
+				if (h.priv->ule_sndu_type < ETH_P_802_3_MIN) {
 					/* There is an extension header.  Handle it accordingly. */
-					int l = handle_ule_extensions(priv);
+					int l = handle_ule_extensions(h.priv);
 					if (l < 0) {
 						/* Mandatory extension header unknown or TEST SNDU.  Drop it. */
 						// pr_warn("Dropping SNDU, extension headers.\n" );
-						dev_kfree_skb(priv->ule_skb);
+						dev_kfree_skb(h.priv->ule_skb);
 						goto sndu_done;
 					}
-					skb_pull(priv->ule_skb, l);
+					skb_pull(h.priv->ule_skb, l);
 				}
 
 				/*
 				 * Construct/assure correct ethernet header.
-				 * Note: in bridged mode (priv->ule_bridged !=
+				 * Note: in bridged mode (h.priv->ule_bridged !=
 				 * 0) we already have the (original) ethernet
 				 * header at the start of the payload (after
 				 * optional dest. address and any extension
 				 * headers).
 				 */
 
-				if (!priv->ule_bridged) {
-					skb_push(priv->ule_skb, ETH_HLEN);
-					ethh = (struct ethhdr *)priv->ule_skb->data;
-					if (!priv->ule_dbit) {
-						 /* dest_addr buffer is only valid if priv->ule_dbit == 0 */
-						memcpy(ethh->h_dest, dest_addr, ETH_ALEN);
-						eth_zero_addr(ethh->h_source);
+				if (!h.priv->ule_bridged) {
+					skb_push(h.priv->ule_skb, ETH_HLEN);
+					h.ethh = (struct ethhdr *)h.priv->ule_skb->data;
+					if (!h.priv->ule_dbit) {
+						 /* dest_addr buffer is only valid if h.priv->ule_dbit == 0 */
+						memcpy(h.ethh->h_dest, dest_addr, ETH_ALEN);
+						eth_zero_addr(h.ethh->h_source);
 					}
 					else /* zeroize source and dest */
-						memset( ethh, 0, ETH_ALEN*2 );
+						memset( h.ethh, 0, ETH_ALEN*2 );
 
-					ethh->h_proto = htons(priv->ule_sndu_type);
+					h.ethh->h_proto = htons(h.priv->ule_sndu_type);
 				}
 				/* else:  skb is in correct state; nothing to do. */
-				priv->ule_bridged = 0;
+				h.priv->ule_bridged = 0;
 
 				/* Stuff into kernel's protocol stack. */
-				priv->ule_skb->protocol = dvb_net_eth_type_trans(priv->ule_skb, dev);
+				h.priv->ule_skb->protocol = dvb_net_eth_type_trans(h.priv->ule_skb, h.dev);
 				/* If D-bit is set (i.e. destination MAC address not present),
 				 * receive the packet anyhow. */
-				/* if (priv->ule_dbit && skb->pkt_type == PACKET_OTHERHOST)
-					priv->ule_skb->pkt_type = PACKET_HOST; */
-				dev->stats.rx_packets++;
-				dev->stats.rx_bytes += priv->ule_skb->len;
-				netif_rx(priv->ule_skb);
+				/* if (h.priv->ule_dbit && skb->pkt_type == PACKET_OTHERHOST)
+					h.priv->ule_skb->pkt_type = PACKET_HOST; */
+				h.dev->stats.rx_packets++;
+				h.dev->stats.rx_bytes += h.priv->ule_skb->len;
+				netif_rx(h.priv->ule_skb);
 			}
 			sndu_done:
 			/* Prepare for next SNDU. */
-			reset_ule(priv);
+			reset_ule(h.priv);
 		}
 
 		/* More data in current TS (look at the bytes following the CRC32)? */
-		if (ts_remain >= 2 && *((unsigned short *)from_where) != 0xFFFF) {
+		if (h.ts_remain >= 2 && *((unsigned short *)h.from_where) != 0xFFFF) {
 			/* Next ULE SNDU starts right there. */
-			new_ts = 0;
-			priv->ule_skb = NULL;
-			priv->ule_sndu_type_1 = 0;
-			priv->ule_sndu_len = 0;
+			h.new_ts = 0;
+			h.priv->ule_skb = NULL;
+			h.priv->ule_sndu_type_1 = 0;
+			h.priv->ule_sndu_len = 0;
 			// pr_warn("More data in current TS: [%#x %#x %#x %#x]\n",
-			//	*(from_where + 0), *(from_where + 1),
-			//	*(from_where + 2), *(from_where + 3));
-			// pr_warn("ts @ %p, stopped @ %p:\n", ts, from_where + 0);
-			// hexdump(ts, 188);
+			//	*(h.from_where + 0), *(h.from_where + 1),
+			//	*(h.from_where + 2), *(h.from_where + 3));
+			// pr_warn("h.ts @ %p, stopped @ %p:\n", h.ts, h.from_where + 0);
+			// hexdump(h.ts, 188);
 		} else {
-			new_ts = 1;
-			ts += TS_SZ;
-			priv->ts_count++;
-			if (priv->ule_skb == NULL) {
-				priv->need_pusi = 1;
-				priv->ule_sndu_type_1 = 0;
-				priv->ule_sndu_len = 0;
+			h.new_ts = 1;
+			h.ts += TS_SZ;
+			h.priv->ts_count++;
+			if (h.priv->ule_skb == NULL) {
+				h.priv->need_pusi = 1;
+				h.priv->ule_sndu_type_1 = 0;
+				h.priv->ule_sndu_len = 0;
 			}
 		}
 	}	/* for all available TS cells */
-- 
2.7.4


