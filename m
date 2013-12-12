Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59118 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3LLTjB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 14:39:01 -0500
Received: by mail-wg0-f48.google.com with SMTP id z12so943937wgg.27
        for <linux-media@vger.kernel.org>; Thu, 12 Dec 2013 11:39:00 -0800 (PST)
Received: from [192.168.1.101] (92.40.97.112.threembb.co.uk. [92.40.97.112])
        by mx.google.com with ESMTPSA id dn2sm434850wid.1.2013.12.12.11.38.56
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Thu, 12 Dec 2013 11:38:59 -0800 (PST)
Message-ID: <1386877131.9141.1.camel@canaries64-MCP7A>
Subject: [PATCH] it913x: Add support for Avermedia H335 id 0x0335
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Thu, 12 Dec 2013 19:38:51 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # v3.11+
---
 drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
 drivers/media/usb/dvb-usb-v2/it913x.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 4a53454..8407178 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -239,6 +239,7 @@
 #define USB_PID_AVERMEDIA_A835B_4835			0x4835
 #define USB_PID_AVERMEDIA_1867				0x1867
 #define USB_PID_AVERMEDIA_A867				0xa867
+#define USB_PID_AVERMEDIA_H335				0x0335
 #define USB_PID_AVERMEDIA_TWINSTAR			0x0825
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index 1cb6899..fe95a58 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -799,6 +799,9 @@ static const struct usb_device_id it913x_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CTVDIGDUAL_V2,
 		&it913x_properties, "Digital Dual TV Receiver CTVDIGDUAL_V2",
 			RC_MAP_IT913X_V1) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_H335,
+		&it913x_properties, "Avermedia H335",
+			RC_MAP_IT913X_V2) },
 	{}		/* Terminating entry */
 };
 
-- 
1.8.3.2

