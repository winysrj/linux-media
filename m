Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:55344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753507AbaI2Son (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 14:44:43 -0400
Message-ID: <1412016072.9649.15.camel@localhost>
Subject: [PATCH] [media] cx231xx: cx231xx_uninit_bulk attempts to reference
 and free isoc_ctl instead of bulk_ctl
From: Luke Suchocki <kernel@suchocki.net>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org
Date: Mon, 29 Sep 2014 13:41:12 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


cx231xx_uninit_bulk() checks that
dev->video_mode.bulk_ctl.transfer_buffer[i] is not NULL, but then calls
usb_free_cohert() with dev->video_mode.isoc_ctl.transfer_buffer[i]
resulting in "BUG: unable to handle NULL pointer dereference" when
closing stream; most likely a cut-and-paste slip from previous
uninit_isoc function.

This will present itself when cx231xx.ko is loaded with
"transfer_mode=0" (USB bulk transfers).

Signed-off-by: Luke Suchocki <kernel@suchocki.net>

--- a/drivers/media/usb/cx231xx/cx231xx-core.c  2014-09-29
13:06:52.006326612 -0500
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c  2014-09-29
13:10:46.796695980 -0500
@@ -943,7 +943,7 @@ void cx231xx_uninit_bulk(struct cx231xx
                        if (dev->video_mode.bulk_ctl.transfer_buffer[i])
{
                                usb_free_coherent(dev->udev,

urb->transfer_buffer_length,
-
dev->video_mode.isoc_ctl.
+
dev->video_mode.bulk_ctl.
                                                transfer_buffer[i],
                                                urb->transfer_dma);



