Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:55182 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751795AbdINKgd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 06:36:33 -0400
Subject: [PATCH 6/8] [media] ttusb_dec: Reduce the scope for three variables
 in ttusb_dec_process_urb()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <66b087d3-6dd3-1e1c-d33d-e34c9e2ffe25@users.sourceforge.net>
Message-ID: <7c7b66d3-bf34-0635-7941-faeb10854de8@users.sourceforge.net>
Date: Thu, 14 Sep 2017 12:36:22 +0200
MIME-Version: 1.0
In-Reply-To: <66b087d3-6dd3-1e1c-d33d-e34c9e2ffe25@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 13 Sep 2017 21:23:29 +0200

* Move the definition for the local variables "b", "d" and "length" into
  an if branch so that the corresponding setting will only be performed
  if a memory allocation succeeded in this function.

* Adjust their data types.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index 7759de653ee9..e9fe4c6142a5 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -812,19 +812,18 @@ static void ttusb_dec_process_urb(struct urb *urb)
 		int i;
 
 		for (i = 0; i < FRAMES_PER_ISO_BUF; i++) {
-			struct usb_iso_packet_descriptor *d;
-			u8 *b;
-			int length;
 			struct urb_frame *frame;
 
-			d = &urb->iso_frame_desc[i];
-			b = urb->transfer_buffer + d->offset;
-			length = d->actual_length;
-
 			frame = kmalloc(sizeof(*frame), GFP_ATOMIC);
 			if (frame) {
 				unsigned long flags;
+				struct usb_iso_packet_descriptor const *d;
+				u8 const *b;
+				unsigned int length;
 
+				d = &urb->iso_frame_desc[i];
+				b = urb->transfer_buffer + d->offset;
+				length = d->actual_length;
 				memcpy(frame->data, b, length);
 				frame->length = length;
 
-- 
2.14.1
