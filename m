Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33892 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdHZUwH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 26 Aug 2017 16:52:07 -0400
From: Himanshu Jha <himanshujha199640@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] [media] atomisp2: Remove null check before kfree
Date: Sun, 27 Aug 2017 02:21:49 +0530
Message-Id: <1503780709-8938-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kfree on NULL pointer is a no-op and therefore checking is redundant.

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 .../staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c    | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 6358216..451c76e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -295,10 +295,8 @@ void sh_css_unload_firmware(void)
 	}
 
 	memset(&sh_css_sp_fw, 0, sizeof(sh_css_sp_fw));
-	if (sh_css_blob_info) {
-		kfree(sh_css_blob_info);
-		sh_css_blob_info = NULL;
-	}
+	kfree(sh_css_blob_info);
+	sh_css_blob_info = NULL;
 	sh_css_num_binaries = 0;
 }
 
-- 
2.7.4
