Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:50763 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933566AbeDXNP4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 09:15:56 -0400
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] media: dvb_net: fix dvb_net_tx()'s return type
Date: Tue, 24 Apr 2018 15:15:51 +0200
Message-Id: <20180424131554.2910-1-luc.vanoostenryck@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, but the implementation in this
driver returns an 'int'.

Fix this by returning 'netdev_tx_t' in this driver too.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 drivers/media/dvb-core/dvb_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index ba39f9942..10f78109b 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -1005,7 +1005,7 @@ static int dvb_net_sec_callback(const u8 *buffer1, size_t buffer1_len,
 	return 0;
 }
 
-static int dvb_net_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t dvb_net_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	dev_kfree_skb(skb);
 	return NETDEV_TX_OK;
-- 
2.17.0
