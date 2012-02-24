Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:53214 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757677Ab2BXQBh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 11:01:37 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Danny Kukawka <dkukawka@suse.de>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Jiri Pirko <jpirko@redhat.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] dvb_net: check given MAC address, if invalid return -EADDRNOTAVAIL
Date: Fri, 24 Feb 2012 17:01:13 +0100
Message-Id: <1330099282-4588-4-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
References: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check if given address is valid in .ndo_set_mac_address, if
invalid return -EADDRNOTAVAIL as eth_mac_addr() already does
if is_valid_ether_addr() fails.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/media/dvb/dvb-core/dvb_net.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 8766ce8..ebae67e 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -1190,7 +1190,10 @@ static void wq_restart_net_feed (struct work_struct *work)
 static int dvb_net_set_mac (struct net_device *dev, void *p)
 {
 	struct dvb_net_priv *priv = netdev_priv(dev);
-	struct sockaddr *addr=p;
+	struct sockaddr *addr = p;
+
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
 
 	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
 
-- 
1.7.8.3

