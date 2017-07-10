Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34222 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753367AbdGJGRc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 02:17:32 -0400
From: Hari Prasath <gehariprasath@gmail.com>
To: mchehab@kernel.org
Cc: gehariprasath@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Varsha Rao <rvarsha016@gmail.com>,
        simran singhal <singhalsimran0@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3] staging: atomisp: use kstrdup to replace kmalloc and memcpy
Date: Mon, 10 Jul 2017 11:47:00 +0530
Message-Id: <20170710061704.4990-1-gehariprasath@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kstrdup kernel primitive can be used to replace kmalloc followed by
string copy. This was reported by coccinelle tool.

Signed-off-by: Hari Prasath <gehariprasath@gmail.com>
---
	v1: Replace kmalloc followed by memcpy with kmemdup. Based on
	    review comments from Alan Cox, this could better be done
	    using kstrdup.
	v2: Replace kmalloc followed by memcpy by kstrdup in this case
	    as it essentially is a string copy.Review comment recieved
	    questioning the return value in case of error. Error value
	    returned should be what the calling function is expecting.
	v3: Retain the original error value returned to the calling
	    function if kstrdup() fails.
---
 .../staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c  | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 34cc56f..5d231ee 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -144,14 +144,10 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
 	)
 	{
 		char *namebuffer;
-		int namelength = (int)strlen(name);
 
-		namebuffer = (char *) kmalloc(namelength + 1, GFP_KERNEL);
-		if (namebuffer == NULL)
+		namebuffer = kstrdup(name, GFP_KERNEL);
+		if (!namebuffer)
 			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
-
-		memcpy(namebuffer, name, namelength + 1);
-
 		bd->name = fw_minibuffer[index].name = namebuffer;
 	} else {
 		bd->name = name;
-- 
2.10.0.GIT
