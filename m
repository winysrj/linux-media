Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38068 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751768AbdINKSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 06:18:46 -0400
From: Srishti Sharma <srishtishar@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: media: atomisp: Use kcalloc instead of kzalloc
Date: Thu, 14 Sep 2017 15:48:40 +0530
Message-Id: <1505384320-6093-1-git-send-email-srishtishar@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use kcalloc instead of kzalloc to check for an overflow before
multiplication. Done using the following semantic patch by
coccinelle.

http://coccinelle.lip6.fr/rules/kzalloc.cocci

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 6358216..2f4b71a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -235,7 +235,9 @@ sh_css_load_firmware(const char *fw_data,
 		sh_css_blob_info = NULL;
 	}
 
-	fw_minibuffer = kzalloc(sh_css_num_binaries * sizeof(struct fw_param), GFP_KERNEL);
+	fw_minibuffer = kcalloc(sh_css_num_binaries, sizeof(struct fw_param),
+				GFP_KERNEL);
+
 	if (fw_minibuffer == NULL)
 		return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 
-- 
2.7.4
