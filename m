Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35097 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbbHFJyo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2015 05:54:44 -0400
From: Shraddha Barke <shraddha.6596@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Joe Perches <joe@perches.com>, Peter Karlsson <peter@zapto.se>,
	Tapasweni Pathak <tapaswenipathak@gmail.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Tina Johnson <tinajohnson.1234@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shraddha Barke <shraddha.6596@gmail.com>
Subject: [PATCH v3 1/2] Staging: ft1000: ft1000-usb: use USB API functions rather than constants
Date: Thu,  6 Aug 2015 15:24:21 +0530
Message-Id: <1438854862-10213-1-git-send-email-shraddha.6596@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduces the use of the function usb_endpoint_is_bulk_in().

Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
---
Changes in v3:
  -Change in commit message and add use of function usb_endpoint_is_bulk_in().
 
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index fd255c6..d1ba0b8 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -111,17 +111,13 @@ static int ft1000_probe(struct usb_interface *interface,
 		pr_debug("endpoint %d\n", i);
 		pr_debug("bEndpointAddress=%x, bmAttributes=%x\n",
 			 endpoint->bEndpointAddress, endpoint->bmAttributes);
-		if ((endpoint->bEndpointAddress & USB_DIR_IN)
-		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
-			USB_ENDPOINT_XFER_BULK)) {
+		if (usb_endpoint_is_bulk_in(endpoint)) {
 			ft1000dev->bulk_in_endpointAddr =
 				endpoint->bEndpointAddress;
 			pr_debug("in: %d\n", endpoint->bEndpointAddress);
 		}
 
-		if (!(endpoint->bEndpointAddress & USB_DIR_IN)
-		    && ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) ==
-			USB_ENDPOINT_XFER_BULK)) {
+		if (usb_endpoint_is_bulk_in(endpoint)) {
 			ft1000dev->bulk_out_endpointAddr =
 				endpoint->bEndpointAddress;
 			pr_debug("out: %d\n", endpoint->bEndpointAddress);
-- 
2.1.0

