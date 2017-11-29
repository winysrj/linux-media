Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35997 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754261AbdK2Kqy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:54 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/12] media: dvb_net: stop abusing /** for comments
Date: Wed, 29 Nov 2017 05:46:30 -0500
Message-Id: <461afb273947098b5760fe27ba90f0cfa71578b5.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comments that start with "/**" aren't kernel-doc stuff.
So, just start them with "/*".

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_net.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 06b0dcc13695..c018e3c06d5d 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -125,7 +125,7 @@ struct dvb_net_priv {
 };
 
 
-/**
+/*
  *	Determine the packet's protocol ID. The rule here is that we
  *	assume 802.3 if the type field is short enough to be a length.
  *	This is normal practice and works for any 'now in use' protocol.
@@ -155,7 +155,7 @@ static __be16 dvb_net_eth_type_trans(struct sk_buff *skb,
 
 	rawp = skb->data;
 
-	/**
+	/*
 	 *	This is a magic hack to spot IPX packets. Older Novell breaks
 	 *	the protocol design and runs IPX over 802.3 without an 802.2 LLC
 	 *	layer. We look for FFFF which isn't a used 802.2 SSAP/DSAP. This
@@ -164,7 +164,7 @@ static __be16 dvb_net_eth_type_trans(struct sk_buff *skb,
 	if (*(unsigned short *)rawp == 0xFFFF)
 		return htons(ETH_P_802_3);
 
-	/**
+	/*
 	 *	Real 802.2 LLC
 	 */
 	return htons(ETH_P_802_2);
@@ -215,7 +215,8 @@ static int ule_exthdr_padding(struct dvb_net_priv *p)
 	return 0;
 }
 
-/** Handle ULE extension headers.
+/*
+ * Handle ULE extension headers.
  *  Function is called after a successful CRC32 verification of an ULE SNDU to complete its decoding.
  *  Returns: >= 0: nr. of bytes consumed by next extension header
  *	     -1:   Mandatory extension header that is not recognized or TEST SNDU; discard.
@@ -291,7 +292,7 @@ static int handle_ule_extensions( struct dvb_net_priv *p )
 }
 
 
-/** Prepare for a new ULE SNDU: reset the decoder state. */
+/* Prepare for a new ULE SNDU: reset the decoder state. */
 static inline void reset_ule( struct dvb_net_priv *p )
 {
 	p->ule_skb = NULL;
@@ -304,7 +305,7 @@ static inline void reset_ule( struct dvb_net_priv *p )
 	p->ule_bridged = 0;
 }
 
-/**
+/*
  * Decode ULE SNDUs according to draft-ietf-ipdvb-ule-03.txt from a sequence of
  * TS cells of a single PID.
  */
@@ -1005,7 +1006,7 @@ static int dvb_net_sec_callback(const u8 *buffer1, size_t buffer1_len,
 {
 	struct net_device *dev = filter->priv;
 
-	/**
+	/*
 	 * we rely on the DVB API definition where exactly one complete
 	 * section is delivered in buffer1
 	 */
-- 
2.14.3
