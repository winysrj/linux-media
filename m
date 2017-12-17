Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:42160 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbdLQPlA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 10:41:00 -0500
Received: by mail-wm0-f65.google.com with SMTP id b199so25227561wme.1
        for <linux-media@vger.kernel.org>; Sun, 17 Dec 2017 07:41:00 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 6/8] [media] ddbridge: fix deinit order in case of failure in ddb_init()
Date: Sun, 17 Dec 2017 16:40:47 +0100
Message-Id: <20171217154049.1125-7-d.scheller.oss@gmail.com>
In-Reply-To: <20171217154049.1125-1-d.scheller.oss@gmail.com>
References: <20171217154049.1125-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

In ddb_init(), the deinitialization sequence isn't correct when handling
errors, and could even lead to a memleak depending on where things failed.
Fix the deinit order.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 07f3e37a0fca..548b7047ca09 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -3273,7 +3273,7 @@ int ddb_init(struct ddb *dev)
 	ddb_init_boards(dev);
 
 	if (ddb_i2c_init(dev) < 0)
-		goto fail;
+		goto fail1;
 	ddb_ports_init(dev);
 	if (ddb_buffers_alloc(dev) < 0) {
 		dev_info(dev->dev, "Could not allocate buffer memory\n");
@@ -3291,14 +3291,14 @@ int ddb_init(struct ddb *dev)
 	return 0;
 
 fail3:
-	ddb_ports_detach(dev);
 	dev_err(dev->dev, "fail3\n");
-	ddb_ports_release(dev);
+	ddb_ports_detach(dev);
+	ddb_buffers_free(dev);
 fail2:
 	dev_err(dev->dev, "fail2\n");
-	ddb_buffers_free(dev);
+	ddb_ports_release(dev);
 	ddb_i2c_release(dev);
-fail:
+fail1:
 	dev_err(dev->dev, "fail1\n");
 	return -1;
 }
-- 
2.13.6
