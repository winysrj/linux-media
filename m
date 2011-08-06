Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38152 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab1HFJv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2011 05:51:59 -0400
Received: by wwf5 with SMTP id 5so223001wwf.1
        for <linux-media@vger.kernel.org>; Sat, 06 Aug 2011 02:51:58 -0700 (PDT)
Subject: [PATCH 1/2] IT9135 Add support for KWORLD_UB499_2T_T09 (id
 1b80:e409)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: jasondong <jason.dong@ite.com.tw>
In-Reply-To: <1312539895.2763.33.camel@Jason-Linux>
References: <1312539895.2763.33.camel@Jason-Linux>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Aug 2011 10:51:49 +0100
Message-ID: <1312624309.2353.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for KWORLD_UB499_2T_T09 to IT9135 Driver

***Please note*** that adapter 2 on this device does not function
correctly.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 drivers/media/dvb/dvb-usb/it9135.c      |   23 ++++++++++++-----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index a0f2ee9..4208d3f 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -137,6 +137,7 @@
 #define USB_PID_KWORLD_PC160_2T				0xc160
 #define USB_PID_KWORLD_PC160_T				0xc161
 #define USB_PID_KWORLD_UB383_T				0xe383
+#define USB_PID_KWORLD_UB499_2T_T09			0xe409
 #define USB_PID_KWORLD_VSTREAM_COLD			0x17de
 #define USB_PID_KWORLD_VSTREAM_WARM			0x17df
 #define USB_PID_TERRATEC_CINERGY_T_USB_XE		0x0055
diff --git a/drivers/media/dvb/dvb-usb/it9135.c b/drivers/media/dvb/dvb-usb/it9135.c
index 7fa21c7..772adf4 100644
--- a/drivers/media/dvb/dvb-usb/it9135.c
+++ b/drivers/media/dvb/dvb-usb/it9135.c
@@ -2256,6 +2256,7 @@ struct usb_device_id it9135_usb_id_table[] = {
 	{USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135)},
 	{USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9005)},
 	{USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9135_9006)},
+	{USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB499_2T_T09)},
 	{0},			/* Terminating entry */
 };
 
@@ -2319,18 +2320,18 @@ struct dvb_usb_device_properties it9135_properties[] = {
 				       }
 				 }
 		      },
-		     },
-	 .num_device_descs = 1,
+	},
+	 .num_device_descs = 2,
 	 .devices = {
-		     {"ITEtech USB2.0 DVB-T Recevier",
-		      {&it9135_usb_id_table[0], &it9135_usb_id_table[1],
-		       &it9135_usb_id_table[2], NULL},
-		      {NULL},
-		      },
-		     {NULL},
-
-		     }
-	 }
+		{   "ITEtech USB2.0 DVB-T Recevier",
+			{ &it9135_usb_id_table[0], &it9135_usb_id_table[1],
+				&it9135_usb_id_table[2], NULL },
+			},
+		{   "Kworld UB499-2T T09",
+			{ &it9135_usb_id_table[3], NULL },
+			},
+		}
+	}
 };
 
 int it9135_device_count = ARRAY_SIZE(it9135_properties);
-- 
1.7.4.1


