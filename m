Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36121 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754834AbdCUCRH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 22:17:07 -0400
Date: Tue, 21 Mar 2017 11:12:57 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4 V2] staging: atomisp: remove useless condition in
 if-statements
Message-ID: <20170321021257.GA1658@SEL-JYOUN-D1>
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
V2: one(2/4) of this series was updated so I tried to send them again.

 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 811331d..f7c0705 100644
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
