Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46868 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754032AbeEWF1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 01:27:34 -0400
From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] media: staging: atomisp: Fix potential NULL pointer dereference
Date: Wed, 23 May 2018 10:51:34 +0530
Message-Id: <1527052896-30777-5-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
In-Reply-To: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
References: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In ia_css_pipe_get_primary_binarydesc(), "pipe" is being dereferenced
before it is null checked.
Fix it by moving the "pipe" pointer dereference after it has been
properly null checked.

Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
---
 .../atomisp/pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c     | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c
index 98a2a3e..ca86157 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c
@@ -554,7 +554,7 @@ void ia_css_pipe_get_primary_binarydesc(
 	struct ia_css_frame_info *vf_info,
 	unsigned int stage_idx)
 {
-	enum ia_css_pipe_version pipe_version = pipe->config.isp_pipe_version;
+	enum ia_css_pipe_version pipe_version;
 	int mode;
 	unsigned int i;
 	struct ia_css_frame_info *out_infos[IA_CSS_BINARY_MAX_OUTPUT_PORTS];
@@ -567,6 +567,7 @@ void ia_css_pipe_get_primary_binarydesc(
 	/*assert(vf_info != NULL);*/
 	IA_CSS_ENTER_PRIVATE("");
 
+	pipe_version = pipe->config.isp_pipe_version;
 	if (pipe_version == IA_CSS_PIPE_VERSION_2_6_1)
 		mode = primary_hq_binary_modes[stage_idx];
 	else
-- 
2.7.4
