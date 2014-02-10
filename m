Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-d02.mx.aol.com ([205.188.109.194]:51078 "EHLO
	omr-d02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaBJJuv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 04:50:51 -0500
Received: from mtaout-mbe02.mx.aol.com (mtaout-mbe02.mx.aol.com [172.26.254.174])
	by omr-d02.mx.aol.com (Outbound Mail Relay) with ESMTP id 5621C700000AB
	for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 04:45:13 -0500 (EST)
Received: from [192.168.10.62] (p23240-ipngn2601marunouchi.tokyo.ocn.ne.jp [180.11.96.240])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mtaout-mbe02.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id AE29B380000A3
	for <linux-media@vger.kernel.org>; Mon, 10 Feb 2014 04:45:12 -0500 (EST)
Message-ID: <52F89FB9.7080004@aim.com>
Date: Mon, 10 Feb 2014 18:45:29 +0900
From: Satoshi Nagahama <sattnag@aim.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Siano: smsusb - Add a device id for PX-S1UD
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a device id to support for PX-S1UD (PLEX ISDB-T usb dongle) which
has sms2270.

Signed-off-by: Satoshi Nagahama <sattnag@aim.com>
---
 drivers/media/usb/siano/smsusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/siano/smsusb.c
b/drivers/media/usb/siano/smsusb.c
index 05bd91a..1836a41 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -653,6 +653,8 @@ static const struct usb_device_id smsusb_id_table[] = {
 		.driver_info = SMS1XXX_BOARD_ZTE_DVB_DATA_CARD },
 	{ USB_DEVICE(0x19D2, 0x0078),
 		.driver_info = SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD },
+	{ USB_DEVICE(0x3275, 0x0080),
+		.driver_info = SMS1XXX_BOARD_SIANO_RIO },
 	{ } /* Terminating entry */
 	};

-- 
1.8.4.2

