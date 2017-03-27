Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:26640 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753453AbdC0PO3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 11:14:29 -0400
Subject: [PATCH 2/5] atomisp: Remove another dead define
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 27 Mar 2017 16:13:56 +0100
Message-ID: <149062763137.15399.14721816276370656571.stgit@rszulisx-mobl.ger.corp.intel.com>
In-Reply-To: <149062762280.15399.12714375439154128065.stgit@rszulisx-mobl.ger.corp.intel.com>
References: <149062762280.15399.12714375439154128065.stgit@rszulisx-mobl.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HAS_TNR3 is never defined so we can remove it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css_sp.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
index ada64bf..e6a3459 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_sp.c
@@ -841,10 +841,6 @@ configure_isp_from_args(
 	ia_css_ref_configure(binary, (const struct ia_css_frame **)args->delay_frames, pipeline->dvs_frame_delay);
 	ia_css_tnr_configure(binary, (const struct ia_css_frame **)args->tnr_frames);
 	ia_css_bayer_io_config(binary, args);
-#ifdef HAS_TNR3
-	/* Remove support for TNR2 once TNR3 fully integrated */
-	ia_css_tnr3_configure(binary, (const struct ia_css_frame **)args->tnr_frames);
-#endif
 	return err;
 }
 
