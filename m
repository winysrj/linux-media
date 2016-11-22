Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:53968 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752140AbcKVUw7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 15:52:59 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] DaVinci-VPFE-Capture: fix error handling
Date: Tue, 22 Nov 2016 21:52:17 +0100
Message-Id: <20161122205231.799066-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A recent cleanup had the right idea to remove the initialization
of the error variable, but missed the actual benefit of that,
which is that we get warnings if there is a bug in it. Now
we get a warning about a bug that was introduced by this cleanup:

drivers/media/platform/davinci/vpfe_capture.c: In function 'vpfe_probe':
drivers/media/platform/davinci/vpfe_capture.c:1992:9: error: 'ret' may be used uninitialized in this function [-Werror=maybe-uninitialized]

This adds the missing initialization that the warning is about,
and another one that was preexisting and that we did not get
a warning for. That second bug has existed since the driver
was first added.

Fixes: efb74461f5a6 ("[media] DaVinci-VPFE-Capture: Delete an unnecessary variable initialisation in vpfe_probe()")
Fixes: 7da8a6cb3e5b ("V4L/DVB (12248): v4l: vpfe capture bridge driver for DM355 and DM6446")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/davinci/vpfe_capture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 6c41782b3ba0..ee1cd79739c8 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1847,8 +1847,10 @@ static int vpfe_probe(struct platform_device *pdev)
 
 	/* Allocate memory for ccdc configuration */
 	ccdc_cfg = kmalloc(sizeof(*ccdc_cfg), GFP_KERNEL);
-	if (!ccdc_cfg)
+	if (!ccdc_cfg) {
+		ret = -ENOMEM;
 		goto probe_free_dev_mem;
+	}
 
 	mutex_lock(&ccdc_lock);
 
@@ -1964,6 +1966,7 @@ static int vpfe_probe(struct platform_device *pdev)
 			v4l2_info(&vpfe_dev->v4l2_dev,
 				  "v4l2 sub device %s register fails\n",
 				  sdinfo->name);
+			ret = -ENXIO;
 			goto probe_sd_out;
 		}
 	}
-- 
2.9.0

