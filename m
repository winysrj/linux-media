Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:32839 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdGGOq1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 10:46:27 -0400
From: Hari Prasath <gehariprasath@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        rvarsha016@gmail.com, julia.lawall@lip6.fr,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: atomisp: use kstrdup to replace kmalloc and memcpy
Date: Fri,  7 Jul 2017 20:15:21 +0530
Message-Id: <20170707144521.4520-1-gehariprasath@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kstrdup kernel primitive can be used to replace kmalloc followed by
string copy. This was reported by coccinelle tool

Signed-off-by: Hari Prasath <gehariprasath@gmail.com>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c       | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 34cc56f..68db87b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -144,14 +144,10 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
 	)
 	{
 		char *namebuffer;
-		int namelength = (int)strlen(name);
-
-		namebuffer = (char *) kmalloc(namelength + 1, GFP_KERNEL);
-		if (namebuffer == NULL)
-			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
-
-		memcpy(namebuffer, name, namelength + 1);
 
+		namebuffer = kstrdup(name, GFP_KERNEL);
+		if (!namebuffer)
+			return -ENOMEM;
 		bd->name = fw_minibuffer[index].name = namebuffer;
 	} else {
 		bd->name = name;
-- 
2.10.0.GIT
