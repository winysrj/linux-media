Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:64773 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbaHKVJj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 17:09:39 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NA500CESUS1BU00@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 11 Aug 2014 17:09:37 -0400 (EDT)
Received: from recife.lan ([105.144.34.4])
 by ussync3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0NA50053DURXWFA0@ussync3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 11 Aug 2014 17:09:37 -0400 (EDT)
Date: Mon, 11 Aug 2014 18:09:32 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] siano: add support for PCTV 77e
Message-id: <20140811180932.7727f4b7.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for PCTV miroStick (77e) device tha tuses a sms1140
chipset.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/common/siano/sms-cards.c | 6 ++++++
 drivers/media/common/siano/sms-cards.h | 1 +
 drivers/media/usb/siano/smsusb.c       | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index 8276999..edc6086 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -157,6 +157,12 @@ static struct sms_board sms_boards[] = {
 		.type = SMS_DENVER_2160,
 		.default_mode = DEVICE_MODE_DAB_TDMB,
 	},
+	[SMS1XXX_BOARD_PCTV_77E] = {
+		.name	= "Hauppauge miroStick 77e",
+		.type	= SMS_NOVA_B0,
+		.fw[DEVICE_MODE_DVBT_BDA] = SMS_FW_DVB_NOVA_12MHZ_B0,
+		.default_mode = DEVICE_MODE_DVBT_BDA,
+	},
 };
 
 struct sms_board *sms_get_board(unsigned id)
diff --git a/drivers/media/common/siano/sms-cards.h b/drivers/media/common/siano/sms-cards.h
index c63b544..4c4cadd 100644
--- a/drivers/media/common/siano/sms-cards.h
+++ b/drivers/media/common/siano/sms-cards.h
@@ -45,6 +45,7 @@
 #define SMS1XXX_BOARD_SIANO_RIO		18
 #define SMS1XXX_BOARD_SIANO_DENVER_1530	19
 #define SMS1XXX_BOARD_SIANO_DENVER_2160 20
+#define SMS1XXX_BOARD_PCTV_77E		21
 
 struct sms_board_gpio_cfg {
 	int lna_vhf_exist;
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 1836a41..89c86ee 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -655,6 +655,8 @@ static const struct usb_device_id smsusb_id_table[] = {
 		.driver_info = SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD },
 	{ USB_DEVICE(0x3275, 0x0080),
 		.driver_info = SMS1XXX_BOARD_SIANO_RIO },
+	{ USB_DEVICE(0x2013, 0x0257),
+		.driver_info = SMS1XXX_BOARD_PCTV_77E },
 	{ } /* Terminating entry */
 	};
 
-- 
1.9.3

