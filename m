Return-path: <linux-media-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:33699 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283Ab3FAKBz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Jun 2013 06:01:55 -0400
Message-ID: <1370079510.29224.4.camel@localhost.localdomain>
Subject: [PATCH] PVRUSB2: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: isely@pobox.com, mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:38:30 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/usb/pvrusb2/pvrusb2-io.c b/drivers/media/usb/pvrusb2/pvrusb2-io.c
--- a/drivers/media/usb/pvrusb2/pvrusb2-io.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-io.c
@@ -354,9 +354,9 @@ static int pvr2_stream_buffer_count(stru
 		if (scnt < sp->buffer_slot_count) {
 			struct pvr2_buffer **nb = NULL;
 			if (scnt) {
-				nb = kmalloc(scnt * sizeof(*nb),GFP_KERNEL);
+				nb = kmemdup(sp->buffers, scnt * sizeof(*nb),
+					     GFP_KERNEL);
 				if (!nb) return -ENOMEM;
-				memcpy(nb,sp->buffers,scnt * sizeof(*nb));
 			}
 			kfree(sp->buffers);
 			sp->buffers = nb;


