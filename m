Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35246 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752793AbdLKQhe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 11:37:34 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ron Economos <w6rz@comcast.net>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/3] media: dvb_net: let dynamic debug enable some DVB net handling
Date: Mon, 11 Dec 2017 11:37:25 -0500
Message-Id: <43da4dd969eb0d2dd874e5d49e7c6de22700f1a2.1513010227.git.mchehab@s-opensource.com>
In-Reply-To: <3749c9084b647a3ca80e78a9f5a3bd83ecb1e4cb.1513010227.git.mchehab@s-opensource.com>
References: <3749c9084b647a3ca80e78a9f5a3bd83ecb1e4cb.1513010227.git.mchehab@s-opensource.com>
In-Reply-To: <3749c9084b647a3ca80e78a9f5a3bd83ecb1e4cb.1513010227.git.mchehab@s-opensource.com>
References: <3749c9084b647a3ca80e78a9f5a3bd83ecb1e4cb.1513010227.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pr_debug() and netdev_dbg() can be enabled/disabled dynamically
via sysfs. So, stop hidding them under ULE_DEBUG config macro.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_net.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index bff5cd908df6..bf0bea5c21c1 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -287,11 +287,9 @@ static int handle_ule_extensions( struct dvb_net_priv *p )
 		if (l < 0)
 			return l;	/* Stop extension header processing and discard SNDU. */
 		total_ext_len += l;
-#ifdef ULE_DEBUG
 		pr_debug("ule_next_hdr=%p, ule_sndu_type=%i, l=%i, total_ext_len=%i\n",
 			 p->ule_next_hdr, (int)p->ule_sndu_type,
 			 l, total_ext_len);
-#endif
 
 	} while (p->ule_sndu_type < ETH_P_802_3_MIN);
 
@@ -704,11 +702,9 @@ static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h, struct kvec iov[
 
 	if (!h->priv->ule_dbit) {
 		if (dvb_net_ule_should_drop(h)) {
-#ifdef ULE_DEBUG
 			netdev_dbg(h->dev,
 				   "Dropping SNDU: MAC destination address does not match: dest addr: %pM, h->dev addr: %pM\n",
 				   h->priv->ule_skb->data, h->dev->dev_addr);
-#endif
 			dev_kfree_skb(h->priv->ule_skb);
 			return;
 		}
-- 
2.14.3
