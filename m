Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35326 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1756400AbcIPOY2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 10:24:28 -0400
Date: Fri, 16 Sep 2016 10:24:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Greg KH <greg@kroah.com>
cc: Wade Berrier <wberrier@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sean Young <sean@mess.org>, <linux-media@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: [PATCH] USB: change bInterval default to 10 ms
In-Reply-To: <20160915224804.GA14827@miniwade.localdomain>
Message-ID: <Pine.LNX.4.44L0.1609161017070.1657-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some full-speed mceusb infrared transceivers contain invalid endpoint
descriptors for their interrupt endpoints, with bInterval set to 0.
In the past they have worked out okay with the mceusb driver, because
the driver sets the bInterval field in the descriptor to 1,
overwriting whatever value may have been there before.  However, this
approach was never sanctioned by the USB core, and in fact it does not
work with xHCI controllers, because they use the bInterval value that
was present when the configuration was installed.

Currently usbcore uses 32 ms as the default interval if the value in
the endpoint descriptor is invalid.  It turns out that these IR
transceivers don't work properly unless the interval is set to 10 ms
or below.  To work around this mceusb problem, this patch changes the
endpoint-descriptor parsing routine, making the default interval value
be 10 ms rather than 32 ms.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Wade Berrier <wberrier@gmail.com>
CC: <stable@vger.kernel.org>

---


[as1812]


 drivers/usb/core/config.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

Index: usb-4.x/drivers/usb/core/config.c
===================================================================
--- usb-4.x.orig/drivers/usb/core/config.c
+++ usb-4.x/drivers/usb/core/config.c
@@ -240,8 +240,10 @@ static int usb_parse_endpoint(struct dev
 	memcpy(&endpoint->desc, d, n);
 	INIT_LIST_HEAD(&endpoint->urb_list);
 
-	/* Fix up bInterval values outside the legal range. Use 32 ms if no
-	 * proper value can be guessed. */
+	/*
+	 * Fix up bInterval values outside the legal range.
+	 * Use 10 or 8 ms if no proper value can be guessed.
+	 */
 	i = 0;		/* i = min, j = max, n = default */
 	j = 255;
 	if (usb_endpoint_xfer_int(d)) {
@@ -250,13 +252,15 @@ static int usb_parse_endpoint(struct dev
 		case USB_SPEED_SUPER_PLUS:
 		case USB_SPEED_SUPER:
 		case USB_SPEED_HIGH:
-			/* Many device manufacturers are using full-speed
+			/*
+			 * Many device manufacturers are using full-speed
 			 * bInterval values in high-speed interrupt endpoint
-			 * descriptors. Try to fix those and fall back to a
-			 * 32 ms default value otherwise. */
+			 * descriptors. Try to fix those and fall back to an
+			 * 8-ms default value otherwise.
+			 */
 			n = fls(d->bInterval*8);
 			if (n == 0)
-				n = 9;	/* 32 ms = 2^(9-1) uframes */
+				n = 7;	/* 8 ms = 2^(7-1) uframes */
 			j = 16;
 
 			/*
@@ -271,10 +275,12 @@ static int usb_parse_endpoint(struct dev
 			}
 			break;
 		default:		/* USB_SPEED_FULL or _LOW */
-			/* For low-speed, 10 ms is the official minimum.
+			/*
+			 * For low-speed, 10 ms is the official minimum.
 			 * But some "overclocked" devices might want faster
-			 * polling so we'll allow it. */
-			n = 32;
+			 * polling so we'll allow it.
+			 */
+			n = 10;
 			break;
 		}
 	} else if (usb_endpoint_xfer_isoc(d)) {
@@ -282,10 +288,10 @@ static int usb_parse_endpoint(struct dev
 		j = 16;
 		switch (to_usb_device(ddev)->speed) {
 		case USB_SPEED_HIGH:
-			n = 9;		/* 32 ms = 2^(9-1) uframes */
+			n = 7;		/* 8 ms = 2^(7-1) uframes */
 			break;
 		default:		/* USB_SPEED_FULL */
-			n = 6;		/* 32 ms = 2^(6-1) frames */
+			n = 4;		/* 8 ms = 2^(4-1) frames */
 			break;
 		}
 	}

