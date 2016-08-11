Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:58004 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555AbcHKVXu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:23:50 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 3/6] staging: media: lirc: lirc_sasem: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:23:40 +0200
Message-Id: <1470950624-26455-4-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470950624-26455-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470950624-26455-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/staging/media/lirc/lirc_sasem.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index 2218d0042030ed..b080fde6d740c9 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -758,17 +758,12 @@ static int sasem_probe(struct usb_interface *interface,
 	}
 	rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!rx_urb) {
-		dev_err(&interface->dev,
-			"%s: usb_alloc_urb failed for IR urb\n", __func__);
 		alloc_status = 5;
 		goto alloc_status_switch;
 	}
 	if (vfd_ep_found) {
 		tx_urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!tx_urb) {
-			dev_err(&interface->dev,
-				"%s: usb_alloc_urb failed for VFD urb",
-				__func__);
 			alloc_status = 6;
 			goto alloc_status_switch;
 		}
-- 
2.8.1

