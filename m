Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33978 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbcKBGNN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 02:13:13 -0400
Date: Wed, 2 Nov 2016 11:43:00 +0530
From: Nadim Almas <nadim.902@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        Julia.Lawall@lip6.fr
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging:media:davinci_vpfe: used devm_kzalloc in place of
 kzalloc
Message-ID: <20161102061300.GA4157@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to resource-managed function devm_kzalloc instead
of kzolloc and remove unneeded kzfree

Also, remove kzfree in probe function and  remove
function,vpfe_remove as it is now has nothing to do.
The Coccinelle semantic patch used to make this change is as follows:
/<smpl>
@platform@
identifier p, probefn, removefn;
@@
struct platform_driver p = {
.probe = probefn,
.remove = removefn,
};

@prb@
identifier platform.probefn, pdev;
expression e, e1, e2;
@@
probefn(struct platform_device *pdev, ...) {
<+...
- e = kzalloc(e1, e2)
+ e = devm_kzalloc(&pdev->dev, e1, e2)
...
?-kzfree(e);
...+>
}
@rem depends on prb@
identifier platform.removefn;
expression prb.e;
@@
removefn(...) {
<...
- kzfree(e);
...>
}
//</smpl>

Signed-off-by: Nadim Almas <nadim.902@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index bf077f8..cd44f0f 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -579,7 +579,7 @@ static int vpfe_probe(struct platform_device *pdev)
 	struct resource *res1;
 	int ret = -ENOMEM;
 
-	vpfe_dev = kzalloc(sizeof(*vpfe_dev), GFP_KERNEL);
+	vpfe_dev = devm_kzalloc(&pdev->dev, sizeof(*vpfe_dev), GFP_KERNEL);
 	if (!vpfe_dev)
 		return ret;
 
@@ -681,7 +681,6 @@ static int vpfe_probe(struct platform_device *pdev)
 probe_disable_clock:
 	vpfe_disable_clock(vpfe_dev);
 probe_free_dev_mem:
-	kzfree(vpfe_dev);
 
 	return ret;
 }
@@ -702,7 +701,6 @@ static int vpfe_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
 	media_device_unregister(&vpfe_dev->media_dev);
 	vpfe_disable_clock(vpfe_dev);
-	kzfree(vpfe_dev);
 
 	return 0;
 }
-- 
2.7.4

