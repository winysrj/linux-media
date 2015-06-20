Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33950 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbbFTC6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 22:58:25 -0400
Date: Sat, 20 Jun 2015 08:28:17 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] [media] dvb_core: Replace memset with eth_zero_addr
Message-ID: <20150620025817.GA4420@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use eth_zero_addr to assign the zero address to the given address
array instead of memset when second argument is address of zero.

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@eth_zero_addr@
expression e;
@@

-memset(e,0x00,ETH_ALEN);
+eth_zero_addr(e);
// </smpl>

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/media/dvb-core/dvb_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index a694fb1..b81e026 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -709,7 +709,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 					if (!priv->ule_dbit) {
 						 /* dest_addr buffer is only valid if priv->ule_dbit == 0 */
 						memcpy(ethh->h_dest, dest_addr, ETH_ALEN);
-						memset(ethh->h_source, 0, ETH_ALEN);
+						eth_zero_addr(ethh->h_source);
 					}
 					else /* zeroize source and dest */
 						memset( ethh, 0, ETH_ALEN*2 );
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
