Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50703 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756960AbbJVI6B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2015 04:58:01 -0400
To: linux-media <linux-media@vger.kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] go7007: fix broken test
Message-ID: <5628A4B5.1050102@xs4all.nl>
Date: Thu, 22 Oct 2015 10:56:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The wrong flags field was tested for the GO7007_BOARD_HAS_AUDIO flag: that
flag is in board->main_info.flags, not in board->flags.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index 4857c46..aa9eca4 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1289,7 +1289,7 @@ static int go7007_usb_probe(struct usb_interface *intf,

 	/* Allocate the URBs and buffers for receiving the audio stream */
 	if ((board->flags & GO7007_USB_EZUSB) &&
-	    (board->flags & GO7007_BOARD_HAS_AUDIO)) {
+	    (board->main_info.flags & GO7007_BOARD_HAS_AUDIO)) {
 		for (i = 0; i < 8; ++i) {
 			usb->audio_urbs[i] = usb_alloc_urb(0, GFP_KERNEL);
 			if (usb->audio_urbs[i] == NULL)
