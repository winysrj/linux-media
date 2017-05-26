Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38426 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030645AbdEZP33 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:29:29 -0400
Subject: [PATCH 09/11] atomisp: Unify lut free logic
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:29:25 +0100
Message-ID: <149581256100.17585.7448530032630612515.stgit@builder>
In-Reply-To: <149581243155.17585.8164899156710160858.stgit@builder>
References: <149581243155.17585.8164899156710160858.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ISP2401 introduced a helper for this which we can use just as well on the
ISP2400 and remove some more noise differences.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |    7 -------
 .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |   14 --------------
 2 files changed, 21 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index 55d2a69..dfef219 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -2533,15 +2533,8 @@ ia_css_pipe_destroy(struct ia_css_pipe *pipe)
 		break;
 	}
 
-#ifndef ISP2401
-	if (pipe->scaler_pp_lut != mmgr_NULL) {
-		hmm_free(pipe->scaler_pp_lut);
-		pipe->scaler_pp_lut = mmgr_NULL;
-	}
-#else
 	sh_css_params_free_gdc_lut(pipe->scaler_pp_lut);
 	pipe->scaler_pp_lut = mmgr_NULL;
-#endif
 
 	my_css.active_pipes[ia_css_pipe_get_pipe_num(pipe)] = NULL;
 	sh_css_pipe_free_shading_table(pipe);
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
index d8c22e8..4822437 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c
@@ -3356,15 +3356,8 @@ enum ia_css_err ia_css_pipe_set_bci_scaler_lut(struct ia_css_pipe *pipe,
 	}
 
 	/* Free any existing tables. */
-#ifndef ISP2401
-	if (pipe->scaler_pp_lut != mmgr_NULL) {
-		hmm_free(pipe->scaler_pp_lut);
-		pipe->scaler_pp_lut = mmgr_NULL;
-	}
-#else
 	sh_css_params_free_gdc_lut(pipe->scaler_pp_lut);
 	pipe->scaler_pp_lut = mmgr_NULL;
-#endif
 
 #ifndef ISP2401
 	if (store) {
@@ -3445,15 +3438,8 @@ void sh_css_params_free_default_gdc_lut(void)
 {
 	IA_CSS_ENTER_PRIVATE("void");
 
-#ifndef ISP2401
-	if (default_gdc_lut != mmgr_NULL) {
-		hmm_free(default_gdc_lut);
-		default_gdc_lut = mmgr_NULL;
-	}
-#else
 	sh_css_params_free_gdc_lut(default_gdc_lut);
 	default_gdc_lut = mmgr_NULL;
-#endif
 
 	IA_CSS_LEAVE_PRIVATE("void");
 
