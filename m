Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33691 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761318AbbEEQeD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 12:34:03 -0400
Received: by lbbzk7 with SMTP id zk7so133160130lbb.0
        for <linux-media@vger.kernel.org>; Tue, 05 May 2015 09:34:02 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/4] dw2102: remove unnecessary printing of MAC address
Date: Tue,  5 May 2015 19:33:52 +0300
Message-Id: <1430843635-24002-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While reading the MAC address for SU3000-based devices the system was
printing excessive debug information in the logs:

Output before the patch:

[ 1515.780692] bc 00 00 00 00 00
[ 1515.781440] bc ea 00 00 00 00
[ 1515.782251] bc ea 2b 00 00 00
[ 1515.783094] bc ea 2b 46 00 00
[ 1515.783816] bc ea 2b 46 12 00
[ 1515.784565] bc ea 2b 46 12 92
[ 1515.784571] dvb-usb: MAC address: bc:ea:2b:46:12:92

Output after the patch:

[ 3803.495706] dvb-usb: MAC address: bc:ea:2b:46:12:92

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/dw2102.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 28fd6ba..4ad6bb2 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -928,8 +928,6 @@ static int su3000_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
 			break;
 		else
 			mac[i] = ibuf[0];
-
-		debug_dump(mac, 6, printk);
 	}
 
 	return 0;
-- 
1.9.1

