Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:54079 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab0DZQZU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 12:25:20 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1O6R7Q-0006uU-U7
	for linux-media@vger.kernel.org; Mon, 26 Apr 2010 18:25:12 +0200
Received: from 92.103.125.220 ([92.103.125.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 18:25:12 +0200
Received: from ticapix by 92.103.125.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 26 Apr 2010 18:25:12 +0200
To: linux-media@vger.kernel.org
From: "pierre.gronlier" <ticapix@gmail.com>
Subject: [PATCH] Read MAC for TeVii S470 PCI-e DVB-S2 card
Date: Mon, 26 Apr 2010 18:26:29 +0200
Message-ID: <hr4eor$2t9$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000204000905010600000802"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000204000905010600000802
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This patch retrieve the correct mac address from the eeprom for TeVii
S470 card.


Signed-off-by: Pierre Gronlier <pierre.gronlier@gmail.com>


diff --git a/linux/drivers/media/video/cx23885/cx23885-dvb.c
b/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c
@@ -929,6 +929,22 @@
                netup_ci_init(port);
                break;
                }
+       case CX23885_BOARD_TEVII_S470: {
+               u8 eeprom[256]; /* 24C02 i2c eeprom */
+
+               if (port->nr != 1)
+                       break;
+
+               /* Read entire EEPROM */
+               dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
+               tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
sizeof(eeprom));
+               printk(KERN_INFO "TeVii S470 MAC= "
+                               "%02X:%02X:%02X:%02X:%02X:%02X\n",
+                               eeprom[0xa0], eeprom[0xa1], eeprom[0xa2],
+                               eeprom[0xa3], eeprom[0xa4], eeprom[0xa5]);
+               memcpy(port->frontends.adapter.proposed_mac, eeprom +
0xa0, 6);
+               break;
+               }
        }

        return ret;


-- 
pierre gronlier

--------------000204000905010600000802
Content-Type: text/x-patch;
 name="s470_read_mac_address.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="s470_read_mac_address.patch"

Read MAC for TeVii S470 PCI-e DVB-S2 card.
Signed-off-by: Pierre Gronlier <pierre.gronlier@gmail.com>

diff --git a/linux/drivers/media/video/cx23885/cx23885-dvb.c b/linux/drivers/media/video/cx23885/cx23885-dvb.c
--- a/linux/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c
@@ -929,6 +929,22 @@
 		netup_ci_init(port);
 		break;
 		}
+	case CX23885_BOARD_TEVII_S470: {
+		u8 eeprom[256]; /* 24C02 i2c eeprom */
+
+		if (port->nr != 1)
+			break;
+
+		/* Read entire EEPROM */
+		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
+		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom, sizeof(eeprom));
+		printk(KERN_INFO "TeVii S470 MAC= "
+				"%02X:%02X:%02X:%02X:%02X:%02X\n",
+				eeprom[0xa0], eeprom[0xa1], eeprom[0xa2],
+				eeprom[0xa3], eeprom[0xa4], eeprom[0xa5]);
+		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xa0, 6);
+		break;
+		}
 	}
 
 	return ret;

--------------000204000905010600000802--

