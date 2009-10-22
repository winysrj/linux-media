Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbZJVN5R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 09:57:17 -0400
Date: Thu, 22 Oct 2009 15:57:07 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, eric.dumazet@gmail.com,
	jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
	bruce.w.allan@intel.com, peter.p.waskiewicz.jr@intel.com,
	john.ronciak@intel.com, e1000-devel@lists.sourceforge.net,
	mchehab@infradead.org, linux-media@vger.kernel.org
Subject: [PATCH net-next-2.6 4/4] dvb: dvb_net: use mc helpers to access
	multicast list
Message-ID: <20091022135706.GI2868@psychotron.lab.eng.brq.redhat.com>
References: <20091022135120.GC2868@psychotron.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022135120.GC2868@psychotron.lab.eng.brq.redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_net.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 8c9ae0a..eb50fb0 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -1110,17 +1110,16 @@ static int dvb_net_feed_stop(struct net_device *dev)
 }
 
 
-static int dvb_set_mc_filter (struct net_device *dev, struct dev_mc_list *mc)
+static void dvb_set_mc_filter(void *data, unsigned char *addr)
 {
-	struct dvb_net_priv *priv = netdev_priv(dev);
+	struct dvb_net_priv *priv = data;
 
 	if (priv->multi_num == DVB_NET_MULTICAST_MAX)
-		return -ENOMEM;
+		return;
 
-	memcpy(priv->multi_macs[priv->multi_num], mc->dmi_addr, 6);
+	memcpy(priv->multi_macs[priv->multi_num], addr, ETH_ALEN);
 
 	priv->multi_num++;
-	return 0;
 }
 
 
@@ -1140,21 +1139,14 @@ static void wq_set_multicast_list (struct work_struct *work)
 	} else if ((dev->flags & IFF_ALLMULTI)) {
 		dprintk("%s: allmulti mode\n", dev->name);
 		priv->rx_mode = RX_MODE_ALL_MULTI;
-	} else if (dev->mc_count) {
-		int mci;
-		struct dev_mc_list *mc;
-
+	} else if (netdev_mc_count(dev)) {
 		dprintk("%s: set_mc_list, %d entries\n",
-			dev->name, dev->mc_count);
+			dev->name, netdev_mc_count(dev));
 
 		priv->rx_mode = RX_MODE_MULTI;
 		priv->multi_num = 0;
 
-		for (mci = 0, mc=dev->mc_list;
-		     mci < dev->mc_count;
-		     mc = mc->next, mci++) {
-			dvb_set_mc_filter(dev, mc);
-		}
+		netdev_mc_walk(dev, dvb_set_mc_filter, priv);
 	}
 
 	netif_addr_unlock_bh(dev);
-- 
1.6.2.5

