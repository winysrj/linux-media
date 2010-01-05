Return-path: <linux-media-owner@vger.kernel.org>
Received: from [206.15.93.42] ([206.15.93.42]:9423 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932077Ab0AERDV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jan 2010 12:03:21 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/media/video/cx23885/cx23885-dvb.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:49:37 -0700
Cc: linux-media@vger.kernel.org, stoth@kernellabs.com,
	davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050949.37415.hartleys@visionengravers.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Steven Toth <stoth@kernellabs.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index e45d2df..f9243de 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -994,15 +994,8 @@ static int dvb_register(struct cx23885_tsport *port)
 		netup_get_card_info(&dev->i2c_bus[0].i2c_adap, &cinfo);
 		memcpy(port->frontends.adapter.proposed_mac,
 				cinfo.port[port->nr - 1].mac, 6);
-		printk(KERN_INFO "NetUP Dual DVB-S2 CI card port%d MAC="
-			"%02X:%02X:%02X:%02X:%02X:%02X\n",
-			port->nr,
-			port->frontends.adapter.proposed_mac[0],
-			port->frontends.adapter.proposed_mac[1],
-			port->frontends.adapter.proposed_mac[2],
-			port->frontends.adapter.proposed_mac[3],
-			port->frontends.adapter.proposed_mac[4],
-			port->frontends.adapter.proposed_mac[5]);
+		printk(KERN_INFO "NetUP Dual DVB-S2 CI card port%d MAC=%pM\n",
+			port->nr, port->frontends.adapter.proposed_mac);
 
 		netup_ci_init(port);
 		break;
