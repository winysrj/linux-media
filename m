Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out112.alice.it ([85.37.17.112]:3523 "EHLO
	smtp-out112.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab0APVqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 16:46:09 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	Jim Paris <jim@jtan.com>, Max Thrun <bear24rw@gmail.com>
Subject: [PATCH] ov534: fix end of frame handling, make the camera work again.
Date: Sat, 16 Jan 2010 22:45:00 +0100
Message-Id: <1263678300-20313-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix a regression, probably introduced in the driver split, which made
the ov534 driver unusable: every last packet was discarded because we
were mis-calculating the frame size before actually adding the packet.

Plus, the debug message should reflect that we discard also packets
beyond the expected frame size.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Cc: Max Thrun <bear24rw@gmail.com>
---

Max, can you test this as well? This should be better than removing all
the discard logic at once. After this is in I'll keep working on your
changes.

Jean-Francois, if this is proven to be the right thing to do, it should
go mainline along with the driver split.

Thanks,
   Antonio Ospite

Index: gspca/linux/drivers/media/video/gspca/ov534.c
===================================================================
--- gspca.orig/linux/drivers/media/video/gspca/ov534.c
+++ gspca/linux/drivers/media/video/gspca/ov534.c
@@ -992,9 +992,9 @@
 			frame = gspca_get_i_frame(gspca_dev);
 			if (frame == NULL)
 				goto discard;
-			if (frame->data_end - frame->data !=
+			if (frame->data_end - frame->data + (len - 12) !=
 			    gspca_dev->width * gspca_dev->height * 2) {
-				PDEBUG(D_PACK, "short frame");
+				PDEBUG(D_PACK, "wrong sized frame");
 				goto discard;
 			}
 			gspca_frame_add(gspca_dev, LAST_PACKET,
