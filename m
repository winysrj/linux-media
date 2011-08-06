Return-path: <linux-media-owner@vger.kernel.org>
Received: from blu0-omc2-s26.blu0.hotmail.com ([65.55.111.101]:6133 "EHLO
	blu0-omc2-s26.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835Ab1HFE5c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Aug 2011 00:57:32 -0400
Message-ID: <BLU0-SMTP40029526361406C4AA91142D83F0@phx.gbl>
From: Manoel Pinheiro <pinusdtv@hotmail.com>
To: linux-media@vger.kernel.org
CC: mchehab@redhat.com
Subject: [PATCH] usb-urb.c: usb_bulk_urb_init and usb_isoc_urb_init
Date: Sat, 6 Aug 2011 01:52:12 -0300
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If there is not enough memory the allocated urb_list will not be freed.


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
---
 drivers/media/dvb/dvb-usb/usb-urb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/usb-urb.c b/drivers/media/dvb/dvb-usb/usb-urb.c
index 86d6893..d62ee0f 100644
--- a/drivers/media/dvb/dvb-usb/usb-urb.c
+++ b/drivers/media/dvb/dvb-usb/usb-urb.c
@@ -148,7 +148,7 @@ static int usb_bulk_urb_init(struct usb_data_stream *stream)
 		if (!stream->urb_list[i]) {
 			deb_mem("not enough memory for urb_alloc_urb!.\n");
 			for (j = 0; j < i; j++)
-				usb_free_urb(stream->urb_list[i]);
+				usb_free_urb(stream->urb_list[j]);
 			return -ENOMEM;
 		}
 		usb_fill_bulk_urb( stream->urb_list[i], stream->udev,
@@ -181,7 +181,7 @@ static int usb_isoc_urb_init(struct usb_data_stream *stream)
 		if (!stream->urb_list[i]) {
 			deb_mem("not enough memory for urb_alloc_urb!\n");
 			for (j = 0; j < i; j++)
-				usb_free_urb(stream->urb_list[i]);
+				usb_free_urb(stream->urb_list[j]);
 			return -ENOMEM;
 		}
 
-- 
1.7.4.4

