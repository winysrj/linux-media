Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42371 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409AbZKGVu4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 16:50:56 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 07 Nov 2009 21:50:59 +0000
Message-ID: <1257630659.15927.420.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 26/75] ttusb-dec: declare MODULE_FIRMWARE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/ttusb-dec/ttusb_dec.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
index d91e063..f835852 100644
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -1781,3 +1781,6 @@ MODULE_AUTHOR("Alex Woods <linux-dvb@giblets.org>");
 MODULE_DESCRIPTION(DRIVER_NAME);
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(usb, ttusb_dec_table);
+MODULE_FIRMWARE("dvb-ttusb-dec-2000t.fw");
+MODULE_FIRMWARE("dvb-ttusb-dec-2540t.fw");
+MODULE_FIRMWARE("dvb-ttusb-dec-3000s.fw");
-- 
1.6.5.2



