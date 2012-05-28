Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45243 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2E1RF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 13:05:29 -0400
Date: Mon, 28 May 2012 19:05:25 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] gspca - sonixj: Fix bad values of webcam 0458:7025
Message-ID: <20120528190525.06a348e3@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The webcam 0458:7025 (Eye911Q) has:
- an inverted power pin,
- a sensor mi0360b which cannot be probed.

Signed-off-by: Jean-François Moine <moinejf@free.fr>
---
 drivers/media/video/gspca/sonixj.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 4d1696d..f38faa9 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -3120,7 +3120,7 @@ static const struct sd_desc sd_desc = {
 			| (SENSOR_ ## sensor << 8) \
 			| (flags)
 static const struct usb_device_id device_table[] = {
-	{USB_DEVICE(0x0458, 0x7025), BS(SN9C120, MI0360)},
+	{USB_DEVICE(0x0458, 0x7025), BSF(SN9C120, MI0360B, F_PDN_INV)},
 	{USB_DEVICE(0x0458, 0x702e), BS(SN9C120, OV7660)},
 	{USB_DEVICE(0x045e, 0x00f5), BSF(SN9C105, OV7660, F_PDN_INV)},
 	{USB_DEVICE(0x045e, 0x00f7), BSF(SN9C105, OV7660, F_PDN_INV)},
-- 
1.7.10

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
