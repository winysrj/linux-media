Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:54722 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754504AbcKUN7Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 08:59:24 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vpfe_capture: fix compiler warning
Message-ID: <b24501c0-b70a-5030-0373-e23e059b66d5@xs4all.nl>
Date: Mon, 21 Nov 2016 14:59:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

davinci/vpfe_capture.c: In function 'vpfe_probe':
davinci/vpfe_capture.c:1992:9: warning: 'ret' may be used uninitialized 
in this function [-Wmaybe-uninitialized]
   return ret;
          ^~~

This is indeed correct, so if the kmalloc fails set ret to -ENOMEM.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/platform/davinci/vpfe_capture.c 
b/drivers/media/platform/davinci/vpfe_capture.c
index 6c41782..bc2c62b 100644
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

