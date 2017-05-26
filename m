Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38374 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947941AbdEZP0B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:26:01 -0400
Subject: [PATCH 02/12] atomisp: remove NUM_OF_BLS
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:25:57 +0100
Message-ID: <149581235405.17406.14617300483450029323.stgit@builder>
In-Reply-To: <149581234670.17406.8086980349538517529.stgit@builder>
References: <149581234670.17406.8086980349538517529.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the removal of the HAS_BL bootloader code the value of NUM_OF_BLS is an
invariant zero. So let's get rid of it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
index 57b4fe5..a179de5 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
@@ -234,9 +234,9 @@ sh_css_load_firmware(const char *fw_data,
 
 	sh_css_num_binaries = file_header->binary_nr;
 	/* Only allocate memory for ISP blob info */
-	if (sh_css_num_binaries > (NUM_OF_SPS + NUM_OF_BLS)) {
+	if (sh_css_num_binaries > NUM_OF_SPS) {
 		sh_css_blob_info = kmalloc(
-					(sh_css_num_binaries - (NUM_OF_SPS + NUM_OF_BLS)) *
+					(sh_css_num_binaries - NUM_OF_SPS) *
 					sizeof(*sh_css_blob_info), GFP_KERNEL);
 		if (sh_css_blob_info == NULL)
 			return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
@@ -272,15 +272,15 @@ sh_css_load_firmware(const char *fw_data,
 			if (err != IA_CSS_SUCCESS)
 				return err;
 		} else {
-			/* All subsequent binaries (including bootloaders) (i>NUM_OF_SPS+NUM_OF_BLS) are ISP firmware */
-			if (i < (NUM_OF_SPS + NUM_OF_BLS))
+			/* All subsequent binaries (including bootloaders) (i>NUM_OF_SPS) are ISP firmware */
+			if (i < NUM_OF_SPS)
 				return IA_CSS_ERR_INTERNAL_ERROR;
 
 			if (bi->type != ia_css_isp_firmware)
 				return IA_CSS_ERR_INTERNAL_ERROR;
 			if (sh_css_blob_info == NULL) /* cannot happen but KW does not see this */
 				return IA_CSS_ERR_INTERNAL_ERROR;
-			sh_css_blob_info[i-(NUM_OF_SPS + NUM_OF_BLS)] = bd;
+			sh_css_blob_info[i - NUM_OF_SPS] = bd;
 		}
 	}
 
