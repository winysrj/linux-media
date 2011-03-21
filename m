Return-path: <mchehab@pedra>
Received: from smtp21.services.sfr.fr ([93.17.128.3]:18032 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab1CUT67 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2011 15:58:59 -0400
Message-ID: <4D87AE00.8090403@sfr.fr>
Date: Mon, 21 Mar 2011 20:58:56 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
	Jean-Francois Moine <moinejf@free.fr>,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>
Subject: [PATCH] add endpoint direction test in alt_xfer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, 

This patch fixes a bug in gspca, more precisely in alt_xfer().

This function looks for an input transfer endpoint in an alternate setting.
By default it returns the first endpoint corresponding to the transfer type 
indicated in parameter.
But with some USB devices, the first endpoint corresponding to the transfer 
type is not always an INPUT endpoint but an OUTPOUT one.

This patch adds the endpoint direction test to be sure to return an INPUT endpoint

Regards


Signed-off-by: Patrice CHOTARD <patricechotard@free.fr>
---
 drivers/media/video/gspca/gspca.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index f21f2a2..03823ea 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -631,7 +631,8 @@ static struct usb_host_endpoint *alt_xfer(struct usb_host_interface *alt,
 		ep = &alt->endpoint[i];
 		attr = ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
 		if (attr == xfer
-		    && ep->desc.wMaxPacketSize != 0)
+		    && ep->desc.wMaxPacketSize != 0
+		    && usb_endpoint_dir_in(&ep->desc))
 			return ep;
 	}
 	return NULL;
-- 
1.7.0.4

