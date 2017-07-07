Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36326 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbdGGLuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 07:50:54 -0400
From: Hari Prasath <gehariprasath@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        rvarsha016@gmail.com, julia.lawall@lip6.fr,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: atomisp: replace kmalloc & memcpy with kmemdup
Date: Fri,  7 Jul 2017 17:20:44 +0530
Message-Id: <20170707115044.21744-1-gehariprasath@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmemdup can be used to replace kmalloc followed by a memcpy.This was
pointed out by the coccinelle tool.

Signed-off-by: Hari Prasath <gehariprasath@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 34cc56f..58d4619 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -146,12 +146,10 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
 		char *namebuffer;
 		int namelength = (int)strlen(name);
 
-		namebuffer = (char *) kmalloc(namelength + 1, GFP_KERNEL);
+		namebuffer = (char *)kmemdup(name, namelength + 1, GFP_KERNEL);
 		if (namebuffer == NULL)
 			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
 
-		memcpy(namebuffer, name, namelength + 1);
-
 		bd->name = fw_minibuffer[index].name = namebuffer;
 	} else {
 		bd->name = name;
-- 
2.10.0.GIT
