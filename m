Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:57998 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325AbcHKVXt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:23:49 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 2/6] staging: media: lirc: lirc_imon: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:23:39 +0200
Message-Id: <1470950624-26455-3-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470950624-26455-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470950624-26455-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/staging/media/lirc/lirc_imon.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index ff1926ca1f96f5..a183e68ec32089 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -797,16 +797,11 @@ static int imon_probe(struct usb_interface *interface,
 		goto free_rbuf;
 	}
 	rx_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!rx_urb) {
-		dev_err(dev, "%s: usb_alloc_urb failed for IR urb\n", __func__);
+	if (!rx_urb)
 		goto free_lirc_buf;
-	}
 	tx_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!tx_urb) {
-		dev_err(dev, "%s: usb_alloc_urb failed for display urb\n",
-		    __func__);
+	if (!tx_urb)
 		goto free_rx_urb;
-	}
 
 	mutex_init(&context->ctx_lock);
 	context->vfd_proto_6p = vfd_proto_6p;
-- 
2.8.1

