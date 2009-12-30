Return-path: <linux-media-owner@vger.kernel.org>
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:54660 "HELO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751636AbZL3TQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 14:16:07 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] drivers/media/video/cx23885/cx23885-dvb.c: use %pM to show MAC address
Date: Wed, 30 Dec 2009 14:08:57 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F64E@mi8nycmail19.Mi8.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Cc: <stoth@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Steven Toth <stoth@kernellabs.com>

---

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
