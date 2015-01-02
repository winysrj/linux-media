Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49158 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbABN44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 08:56:56 -0500
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH 2/5] lmedm04: Fix usb_submit_urb BOGUS urb xfer, pipe 1 != type 3 in interrupt urb
Date: Fri,  2 Jan 2015 13:56:28 +0000
Message-Id: <1420206991-3939-2-git-send-email-tvboxspy@gmail.com>
In-Reply-To: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>
References: <1420206991-3939-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A quirk of some older firmwares that report endpoint pipe type as PIPE_BULK
but the endpoint otheriwse functions as interrupt.

Check if usb_endpoint_type is USB_ENDPOINT_XFER_BULK and set as usb_rcvbulkpipe.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index f1edb29..15db9f6 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -354,6 +354,7 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct lme2510_state *lme_int = adap_to_priv(adap);
+	struct usb_host_endpoint *ep;
 
 	lme_int->lme_urb = usb_alloc_urb(0, GFP_ATOMIC);
 
@@ -375,6 +376,12 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 				adap,
 				8);
 
+	/* Quirk of pipe reporting PIPE_BULK but behaves as interrupt */
+	ep = usb_pipe_endpoint(d->udev, lme_int->lme_urb->pipe);
+
+	if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_BULK)
+		lme_int->lme_urb->pipe = usb_rcvbulkpipe(d->udev, 0xa),
+
 	lme_int->lme_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
 	usb_submit_urb(lme_int->lme_urb, GFP_ATOMIC);
-- 
2.1.0

