Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay03.digicable.hu ([92.249.128.185]:60015 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab0FNUxG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 16:53:06 -0400
Message-ID: <4C168F51.90708@freemail.hu>
Date: Mon, 14 Jun 2010 22:21:37 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Krivchikov Sergei <sergei.krivchikov@gmail.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] gspca_pac7302: add Genius iSlim 310
References: <68c794d61003301249u138e643am20bb264375c3dfe1@mail.gmail.com>	<4BB2E42B.4090302@freemail.hu>	<AANLkTikIivyjNkVYlo4CKCJcFK_UW5J28qG48cnWQBm8@mail.gmail.com>	<4C164387.1000608@freemail.hu> <20100614193003.00988b97@tele>
In-Reply-To: <20100614193003.00988b97@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Márton Németh <nm127@freemail.hu>

Add Genius iSlim 310 webcam to the supported list of the PAC7302 driver.
For more information see http://linuxtv.org/wiki/index.php/PixArt_PAC7301/PAC7302 .

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff --git a/Documentation/video4linux/gspca.txt b/Documentation/video4linux/gspca.txt
index f13eb03..f9b9d32 100644
--- a/Documentation/video4linux/gspca.txt
+++ b/Documentation/video4linux/gspca.txt
@@ -253,6 +253,7 @@ pac7302		093a:2620	Apollo AC-905
 pac7302		093a:2621	PAC731x
 pac7302		093a:2622	Genius Eye 312
 pac7302		093a:2624	PAC7302
+pac7302		093a:2625	Genius iSlim 310
 pac7302		093a:2626	Labtec 2200
 pac7302		093a:2628	Genius iLook 300
 pac7302		093a:2629	Genious iSlim 300
diff --git a/drivers/media/video/gspca/pac7302.c b/drivers/media/video/gspca/pac7302.c
index 2a68220..7c0f265 100644
--- a/drivers/media/video/gspca/pac7302.c
+++ b/drivers/media/video/gspca/pac7302.c
@@ -1200,6 +1200,7 @@ static const struct usb_device_id device_table[] __devinitconst = {
 	{USB_DEVICE(0x093a, 0x2621)},
 	{USB_DEVICE(0x093a, 0x2622), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2624), .driver_info = FL_VFLIP},
+	{USB_DEVICE(0x093a, 0x2625)},
 	{USB_DEVICE(0x093a, 0x2626)},
 	{USB_DEVICE(0x093a, 0x2628)},
 	{USB_DEVICE(0x093a, 0x2629), .driver_info = FL_VFLIP},
