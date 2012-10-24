Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ye0-f174.google.com ([209.85.213.174]:44370 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab2JXMOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 08:14:40 -0400
Received: by mail-ye0-f174.google.com with SMTP id m12so37297yen.19
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2012 05:14:39 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: awalls@md.metrocast.net
Cc: mchehab@infradead.org, linux-media@vger.kernel.org, tj@kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] ivtv: ivtv-driver: Replace 'flush_work_sync()'
Date: Wed, 24 Oct 2012 10:14:16 -0200
Message-Id: <1351080856-20469-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

Since commit 43829731d (workqueue: deprecate flush[_delayed]_work_sync()),
flush_work() should be used instead of flush_work_sync().

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/pci/ivtv/ivtv-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 74e9a50..5d0a5df 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -304,7 +304,7 @@ static void request_modules(struct ivtv *dev)
 
 static void flush_request_modules(struct ivtv *dev)
 {
-	flush_work_sync(&dev->request_module_wk);
+	flush_work(&dev->request_module_wk);
 }
 #else
 #define request_modules(dev)
-- 
1.7.9.5

