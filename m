Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.204]:16110 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751573AbdKLITB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Nov 2017 03:19:01 -0500
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id EE93228C9CE
        for <linux-media@vger.kernel.org>; Sun, 12 Nov 2017 02:19:00 -0600 (CST)
Date: Sun, 12 Nov 2017 02:18:59 -0600
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] usb: uvc_debugfs: remove unnecessary NULL check before
 debugfs_remove_recursive
Message-ID: <20171112081859.GA19079@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NULL check before freeing functions like debugfs_remove_recursive
is not needed.

This issue was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/media/usb/uvc/uvc_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_debugfs.c b/drivers/media/usb/uvc/uvc_debugfs.c
index 368f8f8..6995aeb 100644
--- a/drivers/media/usb/uvc/uvc_debugfs.c
+++ b/drivers/media/usb/uvc/uvc_debugfs.c
@@ -128,6 +128,5 @@ void uvc_debugfs_init(void)
 
 void uvc_debugfs_cleanup(void)
 {
-	if (uvc_debugfs_root_dir != NULL)
-		debugfs_remove_recursive(uvc_debugfs_root_dir);
+	debugfs_remove_recursive(uvc_debugfs_root_dir);
 }
-- 
2.7.4
