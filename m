Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:42491 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2KVSdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:43 -0500
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id DCDF6CA8B60
	for <linux-media@vger.kernel.org>; Thu, 22 Nov 2012 12:59:24 +0100 (CET)
Date: Thu, 22 Nov 2012 12:59:06 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] gspca - stv06xx: Fix a regression with the bridge/sensor
 vv6410
Message-ID: <20121122125906.35d6f98a@armhf>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jean-François Moine <moinejf@free.fr>

Setting the H and V flip controls at webcam connection time prevents
the webcam to work correctly.

This patch checks if the webcam is streaming before setting the flips.
It does not set the flips (nor other controls) at webcam start time.

Tested-by: Philippe ROUBACH <philippe.roubach@free.fr>
Signed-off-by: Jean-François Moine <moinejf@free.fr>

--- a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
@@ -52,9 +52,13 @@
 
 	switch (ctrl->id) {
 	case V4L2_CID_HFLIP:
+		if (!gspca_dev->streaming)
+			return 0;
 		err = vv6410_set_hflip(gspca_dev, ctrl->val);
 		break;
 	case V4L2_CID_VFLIP:
+		if (!gspca_dev->streaming)
+			return 0;
 		err = vv6410_set_vflip(gspca_dev, ctrl->val);
 		break;
 	case V4L2_CID_GAIN:

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
