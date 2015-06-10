Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:42689 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754252AbbFJKTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 06:19:55 -0400
From: Fabien Dessenne <fabien.dessenne@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	<hugues.fruchet@st.com>, <kernel@stlinux.com>
Subject: [PATCH] [media] bdisp: remove needless check
Date: Wed, 10 Jun 2015 12:19:37 +0200
Message-ID: <1433931577-13669-1-git-send-email-fabien.dessenne@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/platform/sti/bdisp/bdisp-v4l2.c:947 bdisp_s_selection() warn: unsigned 'out.width' is never less than zero.
	drivers/media/platform/sti/bdisp/bdisp-v4l2.c:947 bdisp_s_selection() warn: unsigned 'out.height' is never less than zero.
Indeed, width and height are unsigned.

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 89d7a22..9a8405c 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -944,8 +944,7 @@ static int bdisp_s_selection(struct file *file, void *fh,
 	out.width = ALIGN(in->width, frame->fmt->w_align);
 	out.height = ALIGN(in->height, frame->fmt->w_align);
 
-	if ((out.width < 0) || (out.height < 0) ||
-	    ((out.left + out.width) > frame->width) ||
+	if (((out.left + out.width) > frame->width) ||
 	    ((out.top + out.height) > frame->height)) {
 		dev_err(ctx->bdisp_dev->dev,
 			"Invalid crop: %dx%d@(%d,%d) vs frame: %dx%d\n",
-- 
1.9.1

