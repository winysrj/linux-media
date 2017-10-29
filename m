Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60053 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbdJ2Nnm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 09:43:42 -0400
From: Colin King <colin.king@canonical.com>
To: Fabien Dessenne <fabien.dessenne@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] bdisp: remove redundant assignment to pix
Date: Sun, 29 Oct 2017 13:43:39 +0000
Message-Id: <20171029134339.7101-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Pointer pix is being initialized to a value and a little later
being assigned the same value again. Remove the initial assignment to
avoid a duplicate assignment. Cleans up the clang warning:

drivers/media/platform/sti/bdisp/bdisp-v4l2.c:726:26: warning: Value
stored to 'pix' during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 939da6da7644..7e9ed9c7b3e1 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -723,7 +723,7 @@ static int bdisp_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 static int bdisp_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 {
 	struct bdisp_ctx *ctx = fh_to_ctx(fh);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_pix_format *pix;
 	struct bdisp_frame *frame  = ctx_get_frame(ctx, f->type);
 
 	if (IS_ERR(frame)) {
-- 
2.14.1
