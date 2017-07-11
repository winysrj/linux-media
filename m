Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:34675 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932750AbdGKTH7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 15:07:59 -0400
Received: by mail-pf0-f171.google.com with SMTP id q85so653861pfq.1
        for <linux-media@vger.kernel.org>; Tue, 11 Jul 2017 12:07:59 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH] [media] davinci: vpif_capture: fix potential NULL deref
Date: Tue, 11 Jul 2017 12:07:52 -0700
Message-Id: <20170711190752.30142-1-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix potential NULL pointer dereference in the error path of memory
allocation failure.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/media/platform/davinci/vpif_capture.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index d78580f9e431..2e36d8a9f5e3 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1593,10 +1593,12 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 	}
 
 done:
-	pdata->asd_sizes[0] = i;
-	pdata->subdev_count = i;
-	pdata->card_name = "DA850/OMAP-L138 Video Capture";
-
+	if (pdata) {
+		pdata->asd_sizes[0] = i;
+		pdata->subdev_count = i;
+		pdata->card_name = "DA850/OMAP-L138 Video Capture";
+	}
+	
 	return pdata;
 }
 
-- 
2.9.3
