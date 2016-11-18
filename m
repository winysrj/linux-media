Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:60374 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753523AbcKRXVN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:13 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 20/35] media: ti-vpe: vpe: Added MODULE_DEVICE_TABLE hint
Date: Fri, 18 Nov 2016 17:20:30 -0600
Message-ID: <20161118232045.24665-21-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ti_vpe module currently does not get loaded automatically.
Added MODULE_DEVICE_TABLE hint to the driver to assist.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index d3412accf564..05b793595ce9 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2447,6 +2447,7 @@ static const struct of_device_id vpe_of_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, vpe_of_match);
 #endif
 
 static struct platform_driver vpe_pdrv = {
-- 
2.9.0

