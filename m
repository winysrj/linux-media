Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56600 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934534AbcATKzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2016 05:55:46 -0500
From: Roland Zitzke <zitzke@gmx.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [Patch] Support AVerMedia DVD EZMaker 7 (C039)
Date: Wed, 20 Jan 2016 11:55:42 +0100
Message-Id: <0214E8CF-724D-47C8-B621-CD7D434CD1AE@gmx.de>
Cc: Roland Zitzke <zitzke@telos.de>
To: linux-media@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
this is an USB grabber card based on the CX231XX chip.

The Linux TV wiki has some rather contradicting information on this card. However I can confirm that the latest Conexant  driver works just fine once it is compiled with the additional product and vendor id of this card.
https://www.linuxtv.org/wiki/index.php/AVerMedia_DVD_EZMaker_7_(C039)

The following simple patch does the job on the recent v4l tree.
Is there a way to get it included without setting up a git infrastructure?
Thanks and best regards
Roland
--- v4l/cx231xx-cards_old.c	2016-01-20 08:42:06.391203025 +0100
+++ v4l/cx231xx-cards.c	2016-01-20 10:37:41.862148030 +0100
@@ -908,6 +908,8 @@ struct usb_device_id cx231xx_id_table[]
 	 .driver_info = CX231XX_BOARD_OTG102},
 	{USB_DEVICE(USB_VID_TERRATEC, 0x00a6),
 	 .driver_info = CX231XX_BOARD_TERRATEC_GRABBY},
+    {USB_DEVICE(0x07ca, 0xc039),
+     .driver_info = CX231XX_BOARD_CNXT_VIDEO_GRABBER},
 	{},
 };
 

