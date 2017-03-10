Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53916 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933724AbdCJLet (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:34:49 -0500
Subject: [PATCH 6/8] atomisp: tidy firmware loading code a little
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 10 Mar 2017 11:34:41 +0000
Message-ID: <148914567405.25309.7279299274767425668.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
References: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The FWNAME define is never used so can be removed. The option to skip firmware
loading isn't really Cherrytrail specific so remove this and complete the
merging of the two driver versions for this file.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 97103b4..755c27c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -51,12 +51,10 @@
 /* G-Min addition: pull this in from intel_mid_pm.h */
 #define CSTATE_EXIT_LATENCY_C1  1
 
-#ifdef ISP2401
 static uint skip_fwload = 0;
 module_param(skip_fwload, uint, 0644);
-MODULE_PARM_DESC(skip_fwload, "Skip atomisp firmware load for COS");
+MODULE_PARM_DESC(skip_fwload, "Skip atomisp firmware load");
 
-#endif
 /* set reserved memory pool size in page */
 unsigned int repool_pgnr;
 module_param(repool_pgnr, uint, 0644);
@@ -1088,14 +1086,9 @@ atomisp_load_firmware(struct atomisp_device *isp)
 	int rc;
 	char *fw_path = NULL;
 
-#ifdef ISP2401
 	if (skip_fwload)
 		return NULL;
 
-#endif
-#if defined(ATOMISP_FWNAME)
-	fw_path = ATOMISP_FWNAME;
-#else
 	if (isp->media_dev.driver_version == ATOMISP_CSS_VERSION_21) {
 		if (isp->media_dev.hw_revision ==
 		    ((ATOMISP_HW_REVISION_ISP2401 << ATOMISP_HW_REVISION_SHIFT)
@@ -1112,7 +1105,6 @@ atomisp_load_firmware(struct atomisp_device *isp)
 		     | ATOMISP_HW_STEPPING_B0))
 			fw_path = "shisp_2400b0_v21.bin";
 	}
-#endif
 
 	if (!fw_path) {
 		dev_err(isp->dev,
