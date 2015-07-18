Return-path: <linux-media-owner@vger.kernel.org>
Received: from v22015052838725402.yourvserver.net ([37.120.178.132]:47873 "EHLO
	v22015052838725402.yourvserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbbGRHe6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2015 03:34:58 -0400
Message-ID: <55A9FCF5.6080908@edfritsch.de>
Date: Sat, 18 Jul 2015 09:15:01 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEzDtnBrZQ==?= <loepke@edfritsch.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: pboettcher@kernellabs.com
Subject: [PATCH] Technisat SkyStar USB HD,(DVB-S/S2) too much URBs for arm
 devices
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using 8 URBs results in a consecutive buffer allocation of too much
memory for some arm devices.
As we use isochronuous transfers the number of URBs can be reduced
without risking data-loss.

Signed-off-by: Christian Loepke <loepke@edfritsch.de>

--- linux/drivers/media/usb/dvb-usb/technisat-usb2.orig.c
+++ linux/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -707,7 +707,7 @@

                        .stream = {
                                .type = USB_ISOC,
-                               .count = 8,
+                               .count = 4,
                                .endpoint = 0x2,
                                .u = {
                                        .isoc = {
