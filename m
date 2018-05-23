Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46868 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754007AbeEWF1h (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 01:27:37 -0400
From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] media: staging: atomisp: Fix potential NULL pointer dereference
Date: Wed, 23 May 2018 10:51:35 +0530
Message-Id: <1527052896-30777-6-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
In-Reply-To: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
References: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In sh_css_config_input_network(), "stream" is being dereferenced
before it is null checked.
Fix it by moving the "stream" pointer dereference after it has been
properly null checked.

Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
index c771e4b..eb84d51 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css.c
@@ -529,11 +529,12 @@ static enum ia_css_err
 sh_css_config_input_network(struct ia_css_stream *stream)
 {
 	unsigned int fmt_type;
-	struct ia_css_pipe *pipe = stream->last_pipe;
+	struct ia_css_pipe *pipe;
 	struct ia_css_binary *binary = NULL;
 	enum ia_css_err err = IA_CSS_SUCCESS;
 
 	assert(stream != NULL);
+	pipe = stream->last_pipe;
 	assert(pipe != NULL);
 
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE,
-- 
2.7.4
