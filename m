Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59653 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752761AbcKSO5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 09:57:07 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] [media] dvb-net: split the logic at dvb_net_ule() into other functions
Date: Sat, 19 Nov 2016 12:56:59 -0200
Message-Id: <39d3010062225c81f8160e3d64aeed3f1c7aa7a2.1479567006.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479567006.git.mchehab@s-opensource.com>
References: <20161027150848.3623829-1-arnd@arndb.de>
 <cover.1479567006.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479567006.git.mchehab@s-opensource.com>
References: <cover.1479567006.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is too big and too complex, making really hard
to understand what's there.

Split it into sub-routines, in order to make it easier to be
understood, and to allow gcc to better parse it.

As a bonus, it gets rid of a goto in the middle of a routine.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_net.c | 828 ++++++++++++++++++++++-----------------
 1 file changed, 467 insertions(+), 361 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 6fef0fc61cd2..bd833b0824c6 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -332,8 +332,458 @@ struct dvb_net_ule_handle {
 #endif
 };
 
+static int dvb_net_ule_new_ts_cell(struct dvb_net_ule_handle *h)
+{
+	/* We are about to process a new TS cell. */
+
+#ifdef ULE_DEBUG
+	if (h->ule_where >= &h->ule_hist[100*TS_SZ])
+		h->ule_where = h->ule_hist;
+	memcpy(h->ule_where, h->ts, TS_SZ);
+	if (h->ule_dump) {
+		hexdump(h->ule_where, TS_SZ);
+		h->ule_dump = 0;
+	}
+	h->ule_where += TS_SZ;
+#endif
+
+	/*
+	 * Check TS h->error conditions: sync_byte, transport_error_indicator,
+	 * scrambling_control .
+	 */
+	if ((h->ts[0] != TS_SYNC) || (h->ts[1] & TS_TEI) ||
+	    ((h->ts[3] & TS_SC) != 0)) {
+		pr_warn("%lu: Invalid TS cell: SYNC %#x, TEI %u, SC %#x.\n",
+			h->priv->ts_count, h->ts[0],
+			(h->ts[1] & TS_TEI) >> 7,
+			(h->ts[3] & TS_SC) >> 6);
+
+		/* Drop partly decoded SNDU, reset state, resync on PUSI. */
+		if (h->priv->ule_skb) {
+			dev_kfree_skb(h->priv->ule_skb);
+			/* Prepare for next SNDU. */
+			h->dev->stats.rx_errors++;
+			h->dev->stats.rx_frame_errors++;
+		}
+		reset_ule(h->priv);
+		h->priv->need_pusi = 1;
+
+		/* Continue with next TS cell. */
+		h->ts += TS_SZ;
+		h->priv->ts_count++;
+		return 1;
+	}
+
+	h->ts_remain = 184;
+	h->from_where = h->ts + 4;
+
+	return 0;
+}
+
+static int dvb_net_ule_ts_pusi(struct dvb_net_ule_handle *h)
+{
+	if (h->ts[1] & TS_PUSI) {
+		/* Find beginning of first ULE SNDU in current TS cell. */
+		/* Synchronize continuity counter. */
+		h->priv->tscc = h->ts[3] & 0x0F;
+		/* There is a pointer field here. */
+		if (h->ts[4] > h->ts_remain) {
+			pr_err("%lu: Invalid ULE packet (pointer field %d)\n",
+				h->priv->ts_count, h->ts[4]);
+			h->ts += TS_SZ;
+			h->priv->ts_count++;
+			return 1;
+		}
+		/* Skip to destination of pointer field. */
+		h->from_where = &h->ts[5] + h->ts[4];
+		h->ts_remain -= 1 + h->ts[4];
+		h->skipped = 0;
+	} else {
+		h->skipped++;
+		h->ts += TS_SZ;
+		h->priv->ts_count++;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int dvb_net_ule_new_ts(struct dvb_net_ule_handle *h)
+{
+	/* Check continuity counter. */
+	if ((h->ts[3] & 0x0F) == h->priv->tscc)
+		h->priv->tscc = (h->priv->tscc + 1) & 0x0F;
+	else {
+		/* TS discontinuity handling: */
+		pr_warn("%lu: TS discontinuity: got %#x, expected %#x.\n",
+			h->priv->ts_count, h->ts[3] & 0x0F,
+			h->priv->tscc);
+		/* Drop partly decoded SNDU, reset state, resync on PUSI. */
+		if (h->priv->ule_skb) {
+			dev_kfree_skb(h->priv->ule_skb);
+			/* Prepare for next SNDU. */
+			// reset_ule(h->priv);  moved to below.
+			h->dev->stats.rx_errors++;
+			h->dev->stats.rx_frame_errors++;
+		}
+		reset_ule(h->priv);
+		/* skip to next PUSI. */
+		h->priv->need_pusi = 1;
+		return 1;
+	}
+	/*
+	 * If we still have an incomplete payload, but PUSI is
+	 * set; some TS cells are missing.
+	 * This is only possible here, if we missed exactly 16 TS
+	 * cells (continuity counter wrap).
+	 */
+	if (h->ts[1] & TS_PUSI) {
+		if (!h->priv->need_pusi) {
+			if (!(*h->from_where < (h->ts_remain-1)) ||
+			    *h->from_where != h->priv->ule_sndu_remain) {
+				/*
+				 * Pointer field is invalid.
+				 * Drop this TS cell and any started ULE SNDU.
+				 */
+				pr_warn("%lu: Invalid pointer field: %u.\n",
+					h->priv->ts_count,
+					*h->from_where);
+
+				/*
+				 * Drop partly decoded SNDU, reset state,
+				 * resync on PUSI.
+				 */
+				if (h->priv->ule_skb) {
+					h->error = true;
+					dev_kfree_skb(h->priv->ule_skb);
+				}
+
+				if (h->error || h->priv->ule_sndu_remain) {
+					h->dev->stats.rx_errors++;
+					h->dev->stats.rx_frame_errors++;
+					h->error = false;
+				}
+
+				reset_ule(h->priv);
+				h->priv->need_pusi = 1;
+				return 1;
+			}
+			/*
+			 * Skip pointer field (we're processing a
+			 * packed payload).
+			 */
+			h->from_where += 1;
+			h->ts_remain -= 1;
+		} else
+			h->priv->need_pusi = 0;
+
+		if (h->priv->ule_sndu_remain > 183) {
+			/*
+			 * Current SNDU lacks more data than there
+			 * could be available in the current TS cell.
+			 */
+			h->dev->stats.rx_errors++;
+			h->dev->stats.rx_length_errors++;
+			pr_warn("%lu: Expected %d more SNDU bytes, but got PUSI (pf %d, h->ts_remain %d).  Flushing incomplete payload.\n",
+				h->priv->ts_count,
+				h->priv->ule_sndu_remain,
+				h->ts[4], h->ts_remain);
+			dev_kfree_skb(h->priv->ule_skb);
+			/* Prepare for next SNDU. */
+			reset_ule(h->priv);
+			/*
+			 * Resync: go to where pointer field points to:
+			 * start of next ULE SNDU.
+			 */
+			h->from_where += h->ts[4];
+			h->ts_remain -= h->ts[4];
+		}
+	}
+	return 0;
+}
+
+
+/*
+ * Start a new payload with skb.
+ * Find ULE header.  It is only guaranteed that the
+ * length field (2 bytes) is contained in the current
+ * TS.
+ * Check h.ts_remain has to be >= 2 here.
+ */
+static int dvb_net_ule_new_payload(struct dvb_net_ule_handle *h)
+{
+	if (h->ts_remain < 2) {
+		pr_warn("Invalid payload packing: only %d bytes left in TS.  Resyncing.\n",
+			h->ts_remain);
+		h->priv->ule_sndu_len = 0;
+		h->priv->need_pusi = 1;
+		h->ts += TS_SZ;
+		return 1;
+	}
+
+	if (!h->priv->ule_sndu_len) {
+		/* Got at least two bytes, thus extrace the SNDU length. */
+		h->priv->ule_sndu_len = h->from_where[0] << 8 |
+					h->from_where[1];
+		if (h->priv->ule_sndu_len & 0x8000) {
+			/* D-Bit is set: no dest mac present. */
+			h->priv->ule_sndu_len &= 0x7FFF;
+			h->priv->ule_dbit = 1;
+		} else
+			h->priv->ule_dbit = 0;
+
+		if (h->priv->ule_sndu_len < 5) {
+			pr_warn("%lu: Invalid ULE SNDU length %u. Resyncing.\n",
+				h->priv->ts_count,
+				h->priv->ule_sndu_len);
+			h->dev->stats.rx_errors++;
+			h->dev->stats.rx_length_errors++;
+			h->priv->ule_sndu_len = 0;
+			h->priv->need_pusi = 1;
+			h->new_ts = 1;
+			h->ts += TS_SZ;
+			h->priv->ts_count++;
+			return 1;
+		}
+		h->ts_remain -= 2;	/* consume the 2 bytes SNDU length. */
+		h->from_where += 2;
+	}
+
+	h->priv->ule_sndu_remain = h->priv->ule_sndu_len + 2;
+	/*
+	 * State of current TS:
+	 *   h->ts_remain (remaining bytes in the current TS cell)
+	 *   0	ule_type is not available now, we need the next TS cell
+	 *   1	the first byte of the ule_type is present
+	 * >=2	full ULE header present, maybe some payload data as well.
+	 */
+	switch (h->ts_remain) {
+	case 1:
+		h->priv->ule_sndu_remain--;
+		h->priv->ule_sndu_type = h->from_where[0] << 8;
+
+		/* first byte of ule_type is set. */
+		h->priv->ule_sndu_type_1 = 1;
+		h->ts_remain -= 1;
+		h->from_where += 1;
+		/* fallthrough */
+	case 0:
+		h->new_ts = 1;
+		h->ts += TS_SZ;
+		h->priv->ts_count++;
+		return 1;
+
+	default: /* complete ULE header is present in current TS. */
+		/* Extract ULE type field. */
+		if (h->priv->ule_sndu_type_1) {
+			h->priv->ule_sndu_type_1 = 0;
+			h->priv->ule_sndu_type |= h->from_where[0];
+			h->from_where += 1; /* points to payload start. */
+			h->ts_remain -= 1;
+		} else {
+			/* Complete type is present in new TS. */
+			h->priv->ule_sndu_type = h->from_where[0] << 8 |
+						 h->from_where[1];
+			h->from_where += 2; /* points to payload start. */
+			h->ts_remain -= 2;
+		}
+		break;
+	}
+
+	/*
+	 * Allocate the skb (decoder target buffer) with the correct size,
+	 * as follows:
+	 *
+	 * prepare for the largest case: bridged SNDU with MAC address
+	 * (dbit = 0).
+	 */
+	h->priv->ule_skb = dev_alloc_skb(h->priv->ule_sndu_len +
+					 ETH_HLEN + ETH_ALEN);
+	if (!h->priv->ule_skb) {
+		pr_notice("%s: Memory squeeze, dropping packet.\n",
+			  h->dev->name);
+		h->dev->stats.rx_dropped++;
+		return -1;
+	}
+
+	/* This includes the CRC32 _and_ dest mac, if !dbit. */
+	h->priv->ule_sndu_remain = h->priv->ule_sndu_len;
+	h->priv->ule_skb->dev = h->dev;
+	/*
+	 * Leave space for Ethernet or bridged SNDU header
+	 * (eth hdr plus one MAC addr).
+	 */
+	skb_reserve(h->priv->ule_skb, ETH_HLEN + ETH_ALEN);
+
+	return 0;
+}
+
+
+static int dvb_net_ule_should_drop(struct dvb_net_ule_handle *h)
+{
+	static const u8 bc_addr[ETH_ALEN] = { [0 ... ETH_ALEN - 1] = 0xff };
+
+	/*
+	 * The destination MAC address is the next data in the skb.  It comes
+	 * before any extension headers.
+	 *
+	 * Check if the payload of this SNDU should be passed up the stack.
+	 */
+	if (h->priv->rx_mode == RX_MODE_PROMISC)
+		return 0;
+
+	if (h->priv->ule_skb->data[0] & 0x01) {
+		/* multicast or broadcast */
+		if (!ether_addr_equal(h->priv->ule_skb->data, bc_addr)) {
+			/* multicast */
+			if (h->priv->rx_mode == RX_MODE_MULTI) {
+				int i;
+
+				for (i = 0; i < h->priv->multi_num &&
+				     !ether_addr_equal(h->priv->ule_skb->data,
+						       h->priv->multi_macs[i]);
+				     i++)
+					;
+				if (i == h->priv->multi_num)
+					return 1;
+			} else if (h->priv->rx_mode != RX_MODE_ALL_MULTI)
+				return 1; /* no broadcast; */
+			/*
+			 * else:
+			 * all multicast mode: accept all multicast packets
+			 */
+		}
+		/* else: broadcast */
+	} else if (!ether_addr_equal(h->priv->ule_skb->data, h->dev->dev_addr))
+		return 1;
+
+	return 0;
+}
+
+
+static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h,
+				  u32 ule_crc, u32 expected_crc)
+{
+	u8 dest_addr[ETH_ALEN];
+
+	if (ule_crc != expected_crc) {
+		pr_warn("%lu: CRC32 check FAILED: %08x / %08x, SNDU len %d type %#x, ts_remain %d, next 2: %x.\n",
+			h->priv->ts_count, ule_crc, expected_crc,
+			h->priv->ule_sndu_len, h->priv->ule_sndu_type,
+			h->ts_remain,
+			h->ts_remain > 2 ?
+				*(unsigned short *)h->from_where : 0);
+
+	#ifdef ULE_DEBUG
+		hexdump(iov[0].iov_base, iov[0].iov_len);
+		hexdump(iov[1].iov_base, iov[1].iov_len);
+		hexdump(iov[2].iov_base, iov[2].iov_len);
+
+		if (h->ule_where == h->ule_hist) {
+			hexdump(&h->ule_hist[98*TS_SZ], TS_SZ);
+			hexdump(&h->ule_hist[99*TS_SZ], TS_SZ);
+		} else if (h->ule_where == &h->ule_hist[TS_SZ]) {
+			hexdump(&h->ule_hist[99*TS_SZ], TS_SZ);
+			hexdump(h->ule_hist, TS_SZ);
+		} else {
+			hexdump(h->ule_where - TS_SZ - TS_SZ, TS_SZ);
+			hexdump(h->ule_where - TS_SZ, TS_SZ);
+		}
+		h->ule_dump = 1;
+	#endif
+
+		h->dev->stats.rx_errors++;
+		h->dev->stats.rx_crc_errors++;
+		dev_kfree_skb(h->priv->ule_skb);
+
+		return;
+	}
+
+	/* CRC32 verified OK. */
+
+	/* CRC32 was OK, so remove it from skb. */
+	h->priv->ule_skb->tail -= 4;
+	h->priv->ule_skb->len -= 4;
+
+	if (!h->priv->ule_dbit) {
+		if (dvb_net_ule_should_drop(h)) {
+#ifdef ULE_DEBUG
+			netdev_dbg(h->dev,
+				   "Dropping SNDU: MAC destination address does not match: dest addr: %pM, h->dev addr: %pM\n",
+				   h->priv->ule_skb->data, h->dev->dev_addr);
+#endif
+			dev_kfree_skb(h->priv->ule_skb);
+			return;
+		}
+
+		skb_copy_from_linear_data(h->priv->ule_skb, dest_addr,
+					  ETH_ALEN);
+		skb_pull(h->priv->ule_skb, ETH_ALEN);
+	}
+
+	/* Handle ULE Extension Headers. */
+	if (h->priv->ule_sndu_type < ETH_P_802_3_MIN) {
+		/* There is an extension header.  Handle it accordingly. */
+		int l = handle_ule_extensions(h->priv);
+
+		if (l < 0) {
+			/*
+			 * Mandatory extension header unknown or TEST SNDU.
+			 * Drop it.
+			 */
+
+			// pr_warn("Dropping SNDU, extension headers.\n" );
+			dev_kfree_skb(h->priv->ule_skb);
+			return;
+		}
+		skb_pull(h->priv->ule_skb, l);
+	}
+
+	/*
+	 * Construct/assure correct ethernet header.
+	 * Note: in bridged mode (h->priv->ule_bridged != 0)
+	 * we already have the (original) ethernet
+	 * header at the start of the payload (after
+	 * optional dest. address and any extension
+	 * headers).
+	 */
+	if (!h->priv->ule_bridged) {
+		skb_push(h->priv->ule_skb, ETH_HLEN);
+		h->ethh = (struct ethhdr *)h->priv->ule_skb->data;
+		if (!h->priv->ule_dbit) {
+			/*
+			 * dest_addr buffer is only valid if
+			 * h->priv->ule_dbit == 0
+			 */
+			memcpy(h->ethh->h_dest, dest_addr, ETH_ALEN);
+			eth_zero_addr(h->ethh->h_source);
+		} else /* zeroize source and dest */
+			memset(h->ethh, 0, ETH_ALEN * 2);
+
+		h->ethh->h_proto = htons(h->priv->ule_sndu_type);
+	}
+	/* else:  skb is in correct state; nothing to do. */
+	h->priv->ule_bridged = 0;
+
+	/* Stuff into kernel's protocol stack. */
+	h->priv->ule_skb->protocol = dvb_net_eth_type_trans(h->priv->ule_skb,
+							   h->dev);
+	/*
+	 * If D-bit is set (i.e. destination MAC address not present),
+	 * receive the packet anyhow.
+	 */
+#if 0
+	if (h->priv->ule_dbit && skb->pkt_type == PACKET_OTHERHOST)
+		h->priv->ule_skb->pkt_type = PACKET_HOST;
+#endif
+	h->dev->stats.rx_packets++;
+	h->dev->stats.rx_bytes += h->priv->ule_skb->len;
+	netif_rx(h->priv->ule_skb);
+}
+
 static void dvb_net_ule(struct net_device *dev, const u8 *buf, size_t buf_len)
 {
+	int ret;
 	struct dvb_net_ule_handle h = {
 		.dev = dev,
 		.buf = buf,
@@ -352,251 +802,42 @@ static void dvb_net_ule(struct net_device *dev, const u8 *buf, size_t buf_len)
 #endif
 	};
 
-	/* For all TS cells in current buffer.
+	/*
+	 * For all TS cells in current buffer.
 	 * Appearently, we are called for every single TS cell.
 	 */
-	for (h.ts = h.buf, h.ts_end = h.buf + h.buf_len; h.ts < h.ts_end; /* no incr. */ ) {
+	for (h.ts = h.buf, h.ts_end = h.buf + h.buf_len;
+	     h.ts < h.ts_end; /* no incr. */) {
 		if (h.new_ts) {
 			/* We are about to process a new TS cell. */
-
-#ifdef ULE_DEBUG
-			if (h.ule_where >= &h.ule_hist[100*TS_SZ]) h.ule_where = h.ule_hist;
-			memcpy( h.ule_where, h.ts, TS_SZ );
-			if (h.ule_dump) {
-				hexdump( h.ule_where, TS_SZ );
-				h.ule_dump = 0;
-			}
-			h.ule_where += TS_SZ;
-#endif
-
-			/* Check TS h.error conditions: sync_byte, transport_error_indicator, scrambling_control . */
-			if ((h.ts[0] != TS_SYNC) || (h.ts[1] & TS_TEI) || ((h.ts[3] & TS_SC) != 0)) {
-				pr_warn("%lu: Invalid TS cell: SYNC %#x, TEI %u, SC %#x.\n",
-				       h.priv->ts_count, h.ts[0],
-				       (h.ts[1] & TS_TEI) >> 7,
-				       (h.ts[3] & TS_SC) >> 6);
-
-				/* Drop partly decoded SNDU, reset state, resync on PUSI. */
-				if (h.priv->ule_skb) {
-					dev_kfree_skb( h.priv->ule_skb );
-					/* Prepare for next SNDU. */
-					h.dev->stats.rx_errors++;
-					h.dev->stats.rx_frame_errors++;
-				}
-				reset_ule(h.priv);
-				h.priv->need_pusi = 1;
-
-				/* Continue with next TS cell. */
-				h.ts += TS_SZ;
-				h.priv->ts_count++;
+			if (dvb_net_ule_new_ts_cell(&h))
 				continue;
-			}
-
-			h.ts_remain = 184;
-			h.from_where = h.ts + 4;
 		}
+
 		/* Synchronize on PUSI, if required. */
 		if (h.priv->need_pusi) {
-			if (h.ts[1] & TS_PUSI) {
-				/* Find beginning of first ULE SNDU in current TS cell. */
-				/* Synchronize continuity counter. */
-				h.priv->tscc = h.ts[3] & 0x0F;
-				/* There is a pointer field here. */
-				if (h.ts[4] > h.ts_remain) {
-					pr_err("%lu: Invalid ULE packet (pointer field %d)\n",
-					       h.priv->ts_count, h.ts[4]);
-					h.ts += TS_SZ;
-					h.priv->ts_count++;
-					continue;
-				}
-				/* Skip to destination of pointer field. */
-				h.from_where = &h.ts[5] + h.ts[4];
-				h.ts_remain -= 1 + h.ts[4];
-				h.skipped = 0;
-			} else {
-				h.skipped++;
-				h.ts += TS_SZ;
-				h.priv->ts_count++;
+			if (dvb_net_ule_ts_pusi(&h))
 				continue;
-			}
 		}
 
 		if (h.new_ts) {
-			/* Check continuity counter. */
-			if ((h.ts[3] & 0x0F) == h.priv->tscc)
-				h.priv->tscc = (h.priv->tscc + 1) & 0x0F;
-			else {
-				/* TS discontinuity handling: */
-				pr_warn("%lu: TS discontinuity: got %#x, expected %#x.\n",
-					h.priv->ts_count, h.ts[3] & 0x0F,
-					h.priv->tscc);
-				/* Drop partly decoded SNDU, reset state, resync on PUSI. */
-				if (h.priv->ule_skb) {
-					dev_kfree_skb( h.priv->ule_skb );
-					/* Prepare for next SNDU. */
-					// reset_ule(h.priv);  moved to below.
-					h.dev->stats.rx_errors++;
-					h.dev->stats.rx_frame_errors++;
-				}
-				reset_ule(h.priv);
-				/* skip to next PUSI. */
-				h.priv->need_pusi = 1;
+			if (dvb_net_ule_new_ts(&h))
 				continue;
-			}
-			/* If we still have an incomplete payload, but PUSI is
-			 * set; some TS cells are missing.
-			 * This is only possible here, if we missed exactly 16 TS
-			 * cells (continuity counter wrap). */
-			if (h.ts[1] & TS_PUSI) {
-				if (! h.priv->need_pusi) {
-					if (!(*h.from_where < (h.ts_remain-1)) || *h.from_where != h.priv->ule_sndu_remain) {
-						/* Pointer field is invalid.  Drop this TS cell and any started ULE SNDU. */
-						pr_warn("%lu: Invalid pointer field: %u.\n",
-							h.priv->ts_count,
-							*h.from_where);
-
-						/* Drop partly decoded SNDU, reset state, resync on PUSI. */
-						if (h.priv->ule_skb) {
-							h.error = true;
-							dev_kfree_skb(h.priv->ule_skb);
-						}
-
-						if (h.error || h.priv->ule_sndu_remain) {
-							h.dev->stats.rx_errors++;
-							h.dev->stats.rx_frame_errors++;
-							h.error = false;
-						}
-
-						reset_ule(h.priv);
-						h.priv->need_pusi = 1;
-						continue;
-					}
-					/* Skip pointer field (we're processing a
-					 * packed payload). */
-					h.from_where += 1;
-					h.ts_remain -= 1;
-				} else
-					h.priv->need_pusi = 0;
-
-				if (h.priv->ule_sndu_remain > 183) {
-					/* Current SNDU lacks more data than there could be available in the
-					 * current TS cell. */
-					h.dev->stats.rx_errors++;
-					h.dev->stats.rx_length_errors++;
-					pr_warn("%lu: Expected %d more SNDU bytes, but got PUSI (pf %d, h.ts_remain %d).  Flushing incomplete payload.\n",
-						h.priv->ts_count,
-						h.priv->ule_sndu_remain,
-						h.ts[4], h.ts_remain);
-					dev_kfree_skb(h.priv->ule_skb);
-					/* Prepare for next SNDU. */
-					reset_ule(h.priv);
-					/* Resync: go to where pointer field points to: start of next ULE SNDU. */
-					h.from_where += h.ts[4];
-					h.ts_remain -= h.ts[4];
-				}
-			}
 		}
 
 		/* Check if new payload needs to be started. */
 		if (h.priv->ule_skb == NULL) {
-			/* Start a new payload with skb.
-			 * Find ULE header.  It is only guaranteed that the
-			 * length field (2 bytes) is contained in the current
-			 * TS.
-			 * Check h.ts_remain has to be >= 2 here. */
-			if (h.ts_remain < 2) {
-				pr_warn("Invalid payload packing: only %d bytes left in TS.  Resyncing.\n",
-					h.ts_remain);
-				h.priv->ule_sndu_len = 0;
-				h.priv->need_pusi = 1;
-				h.ts += TS_SZ;
-				continue;
-			}
-
-			if (! h.priv->ule_sndu_len) {
-				/* Got at least two bytes, thus extrace the SNDU length. */
-				h.priv->ule_sndu_len = h.from_where[0] << 8 | h.from_where[1];
-				if (h.priv->ule_sndu_len & 0x8000) {
-					/* D-Bit is set: no dest mac present. */
-					h.priv->ule_sndu_len &= 0x7FFF;
-					h.priv->ule_dbit = 1;
-				} else
-					h.priv->ule_dbit = 0;
-
-				if (h.priv->ule_sndu_len < 5) {
-					pr_warn("%lu: Invalid ULE SNDU length %u. Resyncing.\n",
-						h.priv->ts_count,
-						h.priv->ule_sndu_len);
-					h.dev->stats.rx_errors++;
-					h.dev->stats.rx_length_errors++;
-					h.priv->ule_sndu_len = 0;
-					h.priv->need_pusi = 1;
-					h.new_ts = 1;
-					h.ts += TS_SZ;
-					h.priv->ts_count++;
-					continue;
-				}
-				h.ts_remain -= 2;	/* consume the 2 bytes SNDU length. */
-				h.from_where += 2;
-			}
-
-			h.priv->ule_sndu_remain = h.priv->ule_sndu_len + 2;
-			/*
-			 * State of current TS:
-			 *   h.ts_remain (remaining bytes in the current TS cell)
-			 *   0	ule_type is not available now, we need the next TS cell
-			 *   1	the first byte of the ule_type is present
-			 * >=2	full ULE header present, maybe some payload data as well.
-			 */
-			switch (h.ts_remain) {
-				case 1:
-					h.priv->ule_sndu_remain--;
-					h.priv->ule_sndu_type = h.from_where[0] << 8;
-					h.priv->ule_sndu_type_1 = 1; /* first byte of ule_type is set. */
-					h.ts_remain -= 1; h.from_where += 1;
-					/* Continue w/ next TS. */
-				case 0:
-					h.new_ts = 1;
-					h.ts += TS_SZ;
-					h.priv->ts_count++;
-					continue;
-
-				default: /* complete ULE header is present in current TS. */
-					/* Extract ULE type field. */
-					if (h.priv->ule_sndu_type_1) {
-						h.priv->ule_sndu_type_1 = 0;
-						h.priv->ule_sndu_type |= h.from_where[0];
-						h.from_where += 1; /* points to payload start. */
-						h.ts_remain -= 1;
-					} else {
-						/* Complete type is present in new TS. */
-						h.priv->ule_sndu_type = h.from_where[0] << 8 | h.from_where[1];
-						h.from_where += 2; /* points to payload start. */
-						h.ts_remain -= 2;
-					}
-					break;
-			}
-
-			/* Allocate the skb (decoder target buffer) with the correct size, as follows:
-			 * prepare for the largest case: bridged SNDU with MAC address (dbit = 0). */
-			h.priv->ule_skb = dev_alloc_skb( h.priv->ule_sndu_len + ETH_HLEN + ETH_ALEN );
-			if (h.priv->ule_skb == NULL) {
-				pr_notice("%s: Memory squeeze, dropping packet.\n",
-					  h.dev->name);
-				h.dev->stats.rx_dropped++;
+			ret = dvb_net_ule_new_payload(&h);
+			if (ret < 0)
 				return;
-			}
-
-			/* This includes the CRC32 _and_ dest mac, if !dbit. */
-			h.priv->ule_sndu_remain = h.priv->ule_sndu_len;
-			h.priv->ule_skb->dev = h.dev;
-			/* Leave space for Ethernet or bridged SNDU header (eth hdr plus one MAC addr). */
-			skb_reserve( h.priv->ule_skb, ETH_HLEN + ETH_ALEN );
+			if (ret)
+				continue;
 		}
 
 		/* Copy data into our current skb. */
 		h.how_much = min(h.priv->ule_sndu_remain, (int)h.ts_remain);
-		memcpy(skb_put(h.priv->ule_skb, h.how_much), h.from_where, h.how_much);
+		memcpy(skb_put(h.priv->ule_skb, h.how_much),
+		       h.from_where, h.how_much);
 		h.priv->ule_sndu_remain -= h.how_much;
 		h.ts_remain -= h.how_much;
 		h.from_where += h.how_much;
@@ -610,7 +851,8 @@ static void dvb_net_ule(struct net_device *dev, const u8 *buf, size_t buf_len)
 			struct kvec iov[3] = {
 				{ &ulen, sizeof ulen },
 				{ &utype, sizeof utype },
-				{ h.priv->ule_skb->data, h.priv->ule_skb->len - 4 }
+				{ h.priv->ule_skb->data,
+				  h.priv->ule_skb->len - 4 }
 			};
 			u32 ule_crc = ~0L, expected_crc;
 			if (h.priv->ule_dbit) {
@@ -625,145 +867,9 @@ static void dvb_net_ule(struct net_device *dev, const u8 *buf, size_t buf_len)
 				       *(tail - 3) << 16 |
 				       *(tail - 2) << 8 |
 				       *(tail - 1);
-			if (ule_crc != expected_crc) {
-				pr_warn("%lu: CRC32 check FAILED: %08x / %08x, SNDU len %d type %#x, h.ts_remain %d, next 2: %x.\n",
-				       h.priv->ts_count, ule_crc, expected_crc,
-				       h.priv->ule_sndu_len, h.priv->ule_sndu_type,
-				       h.ts_remain,
-				       h.ts_remain > 2 ? *(unsigned short *)h.from_where : 0);
 
-#ifdef ULE_DEBUG
-				hexdump( iov[0].iov_base, iov[0].iov_len );
-				hexdump( iov[1].iov_base, iov[1].iov_len );
-				hexdump( iov[2].iov_base, iov[2].iov_len );
+			dvb_net_ule_check_crc(&h, ule_crc, expected_crc);
 
-				if (h.ule_where == h.ule_hist) {
-					hexdump( &h.ule_hist[98*TS_SZ], TS_SZ );
-					hexdump( &h.ule_hist[99*TS_SZ], TS_SZ );
-				} else if (h.ule_where == &h.ule_hist[TS_SZ]) {
-					hexdump( &h.ule_hist[99*TS_SZ], TS_SZ );
-					hexdump( h.ule_hist, TS_SZ );
-				} else {
-					hexdump( h.ule_where - TS_SZ - TS_SZ, TS_SZ );
-					hexdump( h.ule_where - TS_SZ, TS_SZ );
-				}
-				h.ule_dump = 1;
-#endif
-
-				h.dev->stats.rx_errors++;
-				h.dev->stats.rx_crc_errors++;
-				dev_kfree_skb(h.priv->ule_skb);
-			} else {
-				/* CRC32 verified OK. */
-				u8 dest_addr[ETH_ALEN];
-				static const u8 bc_addr[ETH_ALEN] =
-					{ [ 0 ... ETH_ALEN-1] = 0xff };
-
-				/* CRC32 was OK. Remove it from skb. */
-				h.priv->ule_skb->tail -= 4;
-				h.priv->ule_skb->len -= 4;
-
-				if (!h.priv->ule_dbit) {
-					/*
-					 * The destination MAC address is the
-					 * next data in the skb.  It comes
-					 * before any extension headers.
-					 *
-					 * Check if the payload of this SNDU
-					 * should be passed up the stack.
-					 */
-					register int drop = 0;
-					if (h.priv->rx_mode != RX_MODE_PROMISC) {
-						if (h.priv->ule_skb->data[0] & 0x01) {
-							/* multicast or broadcast */
-							if (!ether_addr_equal(h.priv->ule_skb->data, bc_addr)) {
-								/* multicast */
-								if (h.priv->rx_mode == RX_MODE_MULTI) {
-									int i;
-									for(i = 0; i < h.priv->multi_num &&
-									    !ether_addr_equal(h.priv->ule_skb->data,
-											      h.priv->multi_macs[i]); i++)
-										;
-									if (i == h.priv->multi_num)
-										drop = 1;
-								} else if (h.priv->rx_mode != RX_MODE_ALL_MULTI)
-									drop = 1; /* no broadcast; */
-								/* else: all multicast mode: accept all multicast packets */
-							}
-							/* else: broadcast */
-						}
-						else if (!ether_addr_equal(h.priv->ule_skb->data, h.dev->dev_addr))
-							drop = 1;
-						/* else: destination address matches the MAC address of our receiver device */
-					}
-					/* else: promiscuous mode; pass everything up the stack */
-
-					if (drop) {
-#ifdef ULE_DEBUG
-						netdev_dbg(h.dev, "Dropping SNDU: MAC destination address does not match: dest addr: %pM, h.dev addr: %pM\n",
-							   h.priv->ule_skb->data, h.dev->dev_addr);
-#endif
-						dev_kfree_skb(h.priv->ule_skb);
-						goto sndu_done;
-					}
-					else
-					{
-						skb_copy_from_linear_data(h.priv->ule_skb,
-							      dest_addr,
-							      ETH_ALEN);
-						skb_pull(h.priv->ule_skb, ETH_ALEN);
-					}
-				}
-
-				/* Handle ULE Extension Headers. */
-				if (h.priv->ule_sndu_type < ETH_P_802_3_MIN) {
-					/* There is an extension header.  Handle it accordingly. */
-					int l = handle_ule_extensions(h.priv);
-					if (l < 0) {
-						/* Mandatory extension header unknown or TEST SNDU.  Drop it. */
-						// pr_warn("Dropping SNDU, extension headers.\n" );
-						dev_kfree_skb(h.priv->ule_skb);
-						goto sndu_done;
-					}
-					skb_pull(h.priv->ule_skb, l);
-				}
-
-				/*
-				 * Construct/assure correct ethernet header.
-				 * Note: in bridged mode (h.priv->ule_bridged !=
-				 * 0) we already have the (original) ethernet
-				 * header at the start of the payload (after
-				 * optional dest. address and any extension
-				 * headers).
-				 */
-
-				if (!h.priv->ule_bridged) {
-					skb_push(h.priv->ule_skb, ETH_HLEN);
-					h.ethh = (struct ethhdr *)h.priv->ule_skb->data;
-					if (!h.priv->ule_dbit) {
-						 /* dest_addr buffer is only valid if h.priv->ule_dbit == 0 */
-						memcpy(h.ethh->h_dest, dest_addr, ETH_ALEN);
-						eth_zero_addr(h.ethh->h_source);
-					}
-					else /* zeroize source and dest */
-						memset( h.ethh, 0, ETH_ALEN*2 );
-
-					h.ethh->h_proto = htons(h.priv->ule_sndu_type);
-				}
-				/* else:  skb is in correct state; nothing to do. */
-				h.priv->ule_bridged = 0;
-
-				/* Stuff into kernel's protocol stack. */
-				h.priv->ule_skb->protocol = dvb_net_eth_type_trans(h.priv->ule_skb, h.dev);
-				/* If D-bit is set (i.e. destination MAC address not present),
-				 * receive the packet anyhow. */
-				/* if (h.priv->ule_dbit && skb->pkt_type == PACKET_OTHERHOST)
-					h.priv->ule_skb->pkt_type = PACKET_HOST; */
-				h.dev->stats.rx_packets++;
-				h.dev->stats.rx_bytes += h.priv->ule_skb->len;
-				netif_rx(h.priv->ule_skb);
-			}
-			sndu_done:
 			/* Prepare for next SNDU. */
 			reset_ule(h.priv);
 		}
-- 
2.7.4


