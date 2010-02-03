Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:34230 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757920Ab0BCUYY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 15:24:24 -0500
Message-ID: <4B69DB51.8030900@arcor.de>
Date: Wed, 03 Feb 2010 21:23:45 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 2/15] -  tm6000 bugfix
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com> <4B688E41.2050806@arcor.de> <4B689094.2070204@redhat.com> <4B6894FE.6010202@arcor.de> <4B69D83D.5050809@arcor.de> <4B69D8CC.2030008@arcor.de>
In-Reply-To: <4B69D8CC.2030008@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>

--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -459,13 +506,13 @@ static int tm6000_usb_probe(struct usb_interface
*interface,
     /* Check to see next free device and mark as used */
     nr=find_first_zero_bit(&tm6000_devused,TM6000_MAXBOARDS);
     if (nr >= TM6000_MAXBOARDS) {
-        printk ("tm6000: Supports only %i em28xx
boards.\n",TM6000_MAXBOARDS);
+        printk ("tm6000: Supports only %i tm60xx
boards.\n",TM6000_MAXBOARDS);
         usb_put_dev(usbdev);
         return -ENOMEM;
     }

-- 
Stefan Ringel <stefan.ringel@arcor.de>

