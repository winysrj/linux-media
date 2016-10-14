Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59079 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756600AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH 34/57] [media] b2c2: don't break long lines
Date: Fri, 14 Oct 2016 17:20:22 -0300
Message-Id: <efca44b8c9f5aebc1e8a9e2f291dcfc72152771a.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index d4bdba60b0f7..f9b07649a862 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -33,8 +33,7 @@
 
 static int debug;
 module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level (1=info,ts=2,"
-		"ctrl=4,i2c=8,v8mem=16 (or-able))." DEBSTATUS);
+MODULE_PARM_DESC(debug, "set debugging level (1=info,ts=2,ctrl=4,i2c=8,v8mem=16 (or-able))." DEBSTATUS);
 #undef DEBSTATUS
 
 #define deb_info(args...) dprintk(0x01, args)
@@ -403,8 +402,7 @@ static int flexcop_usb_transfer_init(struct flexcop_usb *fc_usb)
 		frame_size, i, j, ret;
 	int buffer_offset = 0;
 
-	deb_ts("creating %d iso-urbs with %d frames "
-			"each of %d bytes size = %d.\n", B2C2_USB_NUM_ISO_URB,
+	deb_ts("creating %d iso-urbs with %d frames each of %d bytes size = %d.\n", B2C2_USB_NUM_ISO_URB,
 			B2C2_USB_FRAMES_PER_ISO, frame_size, bufsize);
 
 	fc_usb->iso_buffer = usb_alloc_coherent(fc_usb->udev,
@@ -429,8 +427,7 @@ static int flexcop_usb_transfer_init(struct flexcop_usb *fc_usb)
 	for (i = 0; i < B2C2_USB_NUM_ISO_URB; i++) {
 		int frame_offset = 0;
 		struct urb *urb = fc_usb->iso_urb[i];
-		deb_ts("initializing and submitting urb no. %d "
-			"(buf_offset: %d).\n", i, buffer_offset);
+		deb_ts("initializing and submitting urb no. %d (buf_offset: %d).\n", i, buffer_offset);
 
 		urb->dev = fc_usb->udev;
 		urb->context = fc_usb;
-- 
2.7.4


