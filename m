Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59647 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752778AbcKSO5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Nov 2016 09:57:07 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] [media] dvb_net: simplify the logic that fills the ethernet address
Date: Sat, 19 Nov 2016 12:57:00 -0200
Message-Id: <e067a0ee1e8872983c02170351a6f1c93beaeb8e.1479567006.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479567006.git.mchehab@s-opensource.com>
References: <20161027150848.3623829-1-arnd@arndb.de>
 <cover.1479567006.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479567006.git.mchehab@s-opensource.com>
References: <cover.1479567006.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_net.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index bd833b0824c6..10478ac99ffb 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -660,12 +660,13 @@ static int dvb_net_ule_should_drop(struct dvb_net_ule_handle *h)
 	return 0;
 }
 
-
 static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h,
 				  u32 ule_crc, u32 expected_crc)
 {
 	u8 dest_addr[ETH_ALEN];
 
+	eth_zero_addr(dest_addr);
+
 	if (ule_crc != expected_crc) {
 		pr_warn("%lu: CRC32 check FAILED: %08x / %08x, SNDU len %d type %#x, ts_remain %d, next 2: %x.\n",
 			h->priv->ts_count, ule_crc, expected_crc,
@@ -750,15 +751,8 @@ static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h,
 	if (!h->priv->ule_bridged) {
 		skb_push(h->priv->ule_skb, ETH_HLEN);
 		h->ethh = (struct ethhdr *)h->priv->ule_skb->data;
-		if (!h->priv->ule_dbit) {
-			/*
-			 * dest_addr buffer is only valid if
-			 * h->priv->ule_dbit == 0
-			 */
-			memcpy(h->ethh->h_dest, dest_addr, ETH_ALEN);
-			eth_zero_addr(h->ethh->h_source);
-		} else /* zeroize source and dest */
-			memset(h->ethh, 0, ETH_ALEN * 2);
+		memcpy(h->ethh->h_dest, dest_addr, ETH_ALEN);
+		eth_zero_addr(h->ethh->h_source);
 
 		h->ethh->h_proto = htons(h->priv->ule_sndu_type);
 	}
-- 
2.7.4


