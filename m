Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:51223 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751485AbdH2LFF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 07:05:05 -0400
Subject: [PATCH 1/2] [media] imon: Delete an error message for a failed memory
 allocation in imon_init_intf0()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geliang Tang <geliangtang@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Young <sean@mess.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <09417655-9241-72f4-6484-a3c8b3eae87a@users.sourceforge.net>
Message-ID: <fa1210a3-ced1-f39e-2cb8-5fe258778336@users.sourceforge.net>
Date: Tue, 29 Aug 2017 13:04:49 +0200
MIME-Version: 1.0
In-Reply-To: <09417655-9241-72f4-6484-a3c8b3eae87a@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 29 Aug 2017 12:40:07 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/imon.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index bd76534a2749..e6978f1b7f2c 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2313,7 +2313,6 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf,
-	if (!ictx) {
-		dev_err(dev, "%s: kzalloc failed for context", __func__);
+	if (!ictx)
 		goto exit;
-	}
+
 	rx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!rx_urb)
 		goto rx_urb_alloc_failed;
-- 
2.14.1
