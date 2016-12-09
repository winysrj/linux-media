Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:49954 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753306AbcLILhP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 06:37:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v3] [media] dvb: avoid warning in dvb_net
Date: Fri,  9 Dec 2016 12:36:29 +0100
Message-Id: <20161209113648.3529485-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With gcc-5 or higher on x86, we can get a bogus warning in the
dvb-net code:

drivers/media/dvb-core/dvb_net.c: In function 'dvb_net_ule':
arch/x86/include/asm/string_32.h:78:22: error: '*((void *)&dest_addr+4)' may be used uninitialized in this function [-Werror=maybe-uninitialized]

The problem here is that gcc doesn't track all of the conditions
to prove it can't end up copying uninitialized data.
This changes the logic around so we zero out the destination
address earlier when we determine that it is not set here.
This allows the compiler to figure it out.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
When I got the same warning earlier, Mauro created commit 8b0041db80dd
("[media] dvb-net: split the logic at dvb_net_ule() into other
functions") to clean up the code, and that addressed all the warnings
I saw earlier, but I now got a different randconfig build that
needs either this patch or Mauro's variant "dvb_net: simplify
the logic that fills the ethernet address" that does the same
change slightly differently.
---
 drivers/media/dvb-core/dvb_net.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index dfc03a95df71..f06e0488aa2c 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -719,6 +719,9 @@ static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h,
 		skb_copy_from_linear_data(h->priv->ule_skb, dest_addr,
 					  ETH_ALEN);
 		skb_pull(h->priv->ule_skb, ETH_ALEN);
+	} else {
+		/* dest_addr buffer is only valid if h->priv->ule_dbit == 0 */
+		eth_zero_addr(dest_addr);
 	}
 
 	/* Handle ULE Extension Headers. */
@@ -750,16 +753,8 @@ static void dvb_net_ule_check_crc(struct dvb_net_ule_handle *h,
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
-
+		memcpy(h->ethh->h_dest, dest_addr, ETH_ALEN);
+		eth_zero_addr(h->ethh->h_source);
 		h->ethh->h_proto = htons(h->priv->ule_sndu_type);
 	}
 	/* else:  skb is in correct state; nothing to do. */
-- 
2.9.0

