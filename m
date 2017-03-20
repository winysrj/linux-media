Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36197 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753644AbdCTLN3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 07:13:29 -0400
Date: Mon, 20 Mar 2017 20:00:06 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, singhalsimran0@gmail.com,
        dan.carpenter@oracle.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] staging: atomisp: remove useless condition in
 if-statements
Message-ID: <20170320110006.GA17811@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The css_pipe_id was checked with 'CSS_PIPE_ID_COPY' in previous if-
statement. In this case, if the css_pipe_id equals to 'CSS_PIPE_ID_COPY',
it could not enter the next if-statement. But the "next" if-statement
has the condition to check whether the css_pipe_id equals to
'CSS_PIPE_ID_COPY' or not. It should be removed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 6bdd19e..929ed80 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -910,8 +910,7 @@ static struct atomisp_video_pipe *__atomisp_get_pipe(
 	} else if (asd->run_mode->val == ATOMISP_RUN_MODE_VIDEO) {
 		/* For online video or SDV video pipe. */
 		if (css_pipe_id == CSS_PIPE_ID_VIDEO ||
-		    css_pipe_id == CSS_PIPE_ID_COPY ||
-		    css_pipe_id == CSS_PIPE_ID_YUVPP) {
+		    css_pipe_id == CSS_PIPE_ID_COPY) {
 			if (buf_type == CSS_BUFFER_TYPE_OUTPUT_FRAME)
 				return &asd->video_out_video_capture;
 			return &asd->video_out_preview;
@@ -919,8 +918,7 @@ static struct atomisp_video_pipe *__atomisp_get_pipe(
 	} else if (asd->run_mode->val == ATOMISP_RUN_MODE_PREVIEW) {
 		/* For online preview or ZSL preview pipe. */
 		if (css_pipe_id == CSS_PIPE_ID_PREVIEW ||
-		    css_pipe_id == CSS_PIPE_ID_COPY ||
-		    css_pipe_id == CSS_PIPE_ID_YUVPP)
+		    css_pipe_id == CSS_PIPE_ID_COPY)
 			return &asd->video_out_preview;
 	}
 	/* For capture pipe. */
-- 
1.9.1
