Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34851 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751637AbdIVGNU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 02:13:20 -0400
Received: by mail-pf0-f194.google.com with SMTP id i23so88122pfi.2
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 23:13:20 -0700 (PDT)
Date: Fri, 22 Sep 2017 11:43:13 +0530
From: Aishwarya Pant <aishpant@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Cc: outreachy-kernel@googlegroups.com
Subject: [PATCH] [media] atomisp2: remove cast from memory allocation
Message-ID: <20170922061313.GA10665@aishwarya>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch removes the following warning issued was coccicheck:
WARNING: casting value returned by memory allocation function to (char *) is
useless.

Signed-off-by: Aishwarya Pant <aishpant@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 6358216..53a7891 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -145,8 +145,8 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
 		size_t configstruct_size = sizeof(struct ia_css_config_memory_offsets);
 		size_t statestruct_size = sizeof(struct ia_css_state_memory_offsets);
 
-		char *parambuf = (char *)kmalloc(paramstruct_size + configstruct_size + statestruct_size,
-							GFP_KERNEL);
+		char *parambuf = kmalloc(paramstruct_size + configstruct_size + statestruct_size,
+					 GFP_KERNEL);
 		if (parambuf == NULL)
 			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 
-- 
2.7.4
