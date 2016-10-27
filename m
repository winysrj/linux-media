Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:58521 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965819AbcJ0OI4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:08:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [media] dvb: avoid warning in dvb_net
Date: Thu, 27 Oct 2016 15:57:41 +0200
Message-Id: <20161027140835.2345937-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With gcc-5 or higher on x86, we can get a bogus warning in the
dvb-net code:

drivers/media/dvb-core/dvb_net.c: In function ‘dvb_net_ule’:
arch/x86/include/asm/string_32.h:77:14: error: ‘dest_addr’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
drivers/media/dvb-core/dvb_net.c:633:8: note: ‘dest_addr’ was declared here

The problem here is that gcc doesn't track all of the conditions
to prove it can't end up copying uninitialized data.
This changes the logic around so we zero out the destination
address earlier when we determine that it is not set here.
This allows the compiler to figure it out.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/dvb-core/dvb_net.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index 088914c4623f..f1b416de9dab 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -688,6 +688,9 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 							      ETH_ALEN);
 						skb_pull(priv->ule_skb, ETH_ALEN);
 					}
+				} else {
+					 /* othersie use zero destination address */
+					eth_zero_addr(dest_addr);
 				}
 
 				/* Handle ULE Extension Headers. */
@@ -715,13 +718,8 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 				if (!priv->ule_bridged) {
 					skb_push(priv->ule_skb, ETH_HLEN);
 					ethh = (struct ethhdr *)priv->ule_skb->data;
-					if (!priv->ule_dbit) {
-						 /* dest_addr buffer is only valid if priv->ule_dbit == 0 */
-						memcpy(ethh->h_dest, dest_addr, ETH_ALEN);
-						eth_zero_addr(ethh->h_source);
-					}
-					else /* zeroize source and dest */
-						memset( ethh, 0, ETH_ALEN*2 );
+					memcpy(ethh->h_dest, dest_addr, ETH_ALEN);
+					eth_zero_addr(ethh->h_source);
 
 					ethh->h_proto = htons(priv->ule_sndu_type);
 				}
-- 
2.9.0

