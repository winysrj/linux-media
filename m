Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46868 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754057AbeEWF1j (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 01:27:39 -0400
From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] media: staging: atomisp: Fix potential NULL pointer dereference
Date: Wed, 23 May 2018 10:51:36 +0530
Message-Id: <1527052896-30777-7-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
In-Reply-To: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
References: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In verify_copy_out_frame_format(), "pipe" is being dereferenced before
it is null checked.
Fix it by moving the "pipe" pointer dereference after it has been
properly null checked.

Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index eb84d51..487e768 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -455,12 +455,14 @@ static enum ia_css_frame_format yuv422_copy_formats[] = {
 static enum ia_css_err
 verify_copy_out_frame_format(struct ia_css_pipe *pipe)
 {
-	enum ia_css_frame_format out_fmt = pipe->output_info[0].format;
+	enum ia_css_frame_format out_fmt;
 	unsigned int i, found = 0;
 
 	assert(pipe != NULL);
 	assert(pipe->stream != NULL);
 
+	out_fmt = pipe->output_info[0].format;
+
 	switch (pipe->stream->config.input_config.format) {
 	case ATOMISP_INPUT_FORMAT_YUV420_8_LEGACY:
 	case ATOMISP_INPUT_FORMAT_YUV420_8:
-- 
2.7.4
