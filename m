Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.helmutauer.de ([185.170.112.187]:48236 "EHLO
        v2201612530341454.powersrv.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753407AbdBGImf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 03:42:35 -0500
Message-ID: <cfb14339f809faa9b5e40d2fa53f330b.squirrel@helmutauer.de>
In-Reply-To: <33044ec5031546f79ae9d37565240ed3.squirrel@helmutauer.de>
References: <20170127080622.GA4153@mwanda>
    <ae72e45aeea9d3cbead7c50e1cbe4c5b.squirrel@helmutauer.de>
    <33044ec5031546f79ae9d37565240ed3.squirrel@helmutauer.de>
Date: Tue, 7 Feb 2017 09:42:47 +0100
Subject: [PATCH] [MEDIA] add device ID to ati remote
From: vdr@helmutauer.de
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Author: Helmut Auer <vdr@xxx.de>
Date:   Fri Jan 27 19:09:35 2017 +0100

    Adding 1 device ID to ati_remote driver.

    Signed-off-by: Helmut Auer <vdr@xxx.de>

diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 0884b7d..83022b1 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -108,6 +108,7 @@
 #define NVIDIA_REMOTE_PRODUCT_ID       0x0005
 #define MEDION_REMOTE_PRODUCT_ID       0x0006
 #define FIREFLY_REMOTE_PRODUCT_ID      0x0008
+#define REYCOM_REMOTE_PRODUCT_ID       0x000c

 #define DRIVER_VERSION         "2.2.1"
 #define DRIVER_AUTHOR           "Torrey Hoffman <thoffman@arnor.net>"
@@ -227,6 +228,10 @@ static struct usb_device_id ati_remote_table[] = {
                USB_DEVICE(ATI_REMOTE_VENDOR_ID, FIREFLY_REMOTE_PRODUCT_ID),
                .driver_info = (unsigned long)&type_firefly
        },
+       {
+               USB_DEVICE(ATI_REMOTE_VENDOR_ID, REYCOM_REMOTE_PRODUCT_ID),
+               .driver_info = (unsigned long)&type_firefly
+       },
        {}      /* Terminating entry */
 };


