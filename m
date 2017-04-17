Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:27463 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753266AbdDQJQA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 05:16:00 -0400
From: Songjun Wu <songjun.wu@microchip.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, <nicolas.ferre@microchip.com>
CC: <linux-arm-kernel@lists.infrad>,
        Songjun Wu <songjun.wu@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: [PATCH] [media] atmel-isc: Fix the static checker warning
Date: Mon, 17 Apr 2017 17:07:57 +0800
Message-ID: <20170417090757.29199-1-songjun.wu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize the pointer 'fmt' before the start of
the loop.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
---

 drivers/media/platform/atmel/atmel-isc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 7dacf8c1354f..c4b2115559a5 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1490,6 +1490,7 @@ static int isc_formats_init(struct isc_device *isc)
 		}
 	}
 
+	fmt = &isc_formats[0];
 	for (i = 0, num_fmts = 0; i < ARRAY_SIZE(isc_formats); i++) {
 		if (fmt->isc_support || fmt->sd_support)
 			num_fmts++;
-- 
2.11.0
