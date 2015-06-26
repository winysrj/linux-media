Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33502 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbFZEem (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 00:34:42 -0400
Date: Fri, 26 Jun 2015 10:04:37 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] pctv452e: Replace memset with eth_zero_addr
Message-ID: <20150626043437.GA15971@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use eth_zero_addr to assign the zero address to the given address
array instead of memset when second argument is address of zero.
Note that the 6 in the third argument of memset appears to represent
an ethernet address size (ETH_ALEN).

The Coccinelle semantic patch that makes this change is as follows:

// <smpl>
@eth_zero_addr@
expression e;
@@

-memset(e,0x00,6);
+eth_zero_addr(e);
// </smpl>

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/media/usb/dvb-usb/pctv452e.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index d17618f..ec397c4 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -611,7 +611,7 @@ static int pctv452e_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
 	return 0;
 
 failed:
-	memset(mac, 0, 6);
+	eth_zero_addr(mac);
 
 	return ret;
 }
-- 
1.9.1

