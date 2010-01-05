Return-path: <linux-media-owner@vger.kernel.org>
Received: from [206.15.93.42] ([206.15.93.42]:9423 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932125Ab0AERDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2010 12:03:34 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/media/dvb/dvb-core/dvb_net.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:45:21 -0700
Cc: netdev@vger.kernel.org, linux-media@vger.kernel.org,
	davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050945.21446.hartleys@visionengravers.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the %pM kernel extension to display the MAC address and mask.

The only difference in the output is that the output is shown in
the usual colon-separated hex notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 8b8558f..da6552d 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -949,11 +949,8 @@ static int dvb_net_filter_sec_set(struct net_device *dev,
 	(*secfilter)->filter_mask[10] = mac_mask[1];
 	(*secfilter)->filter_mask[11]=mac_mask[0];
 
-	dprintk("%s: filter mac=%02x %02x %02x %02x %02x %02x\n",
-	       dev->name, mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
-	dprintk("%s: filter mask=%02x %02x %02x %02x %02x %02x\n",
-	       dev->name, mac_mask[0], mac_mask[1], mac_mask[2],
-	       mac_mask[3], mac_mask[4], mac_mask[5]);
+	dprintk("%s: filter mac=%pM\n", dev->name, mac);
+	dprintk("%s: filter mask=%pM\n", dev->name, mac_mask);
 
 	return 0;
 }
