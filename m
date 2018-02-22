Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:48037 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753101AbeBVJwc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 04:52:32 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Hans Verkuil" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH] media: stm32-dcmi: fix unnecessary parentheses
Date: Thu, 22 Feb 2018 10:51:27 +0100
Message-ID: <1519293087-19984-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix unnecessary parentheses in if conditions.
Detected by checkpatch.pl --strict.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 536c0d5..269e963 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -477,7 +477,7 @@ static void dcmi_buf_queue(struct vb2_buffer *vb)
 
 	spin_lock_irq(&dcmi->irqlock);
 
-	if ((dcmi->state == RUNNING) && (!dcmi->active)) {
+	if (dcmi->state == RUNNING && !dcmi->active) {
 		dcmi->active = buf;
 
 		dev_dbg(dcmi->dev, "Starting capture on buffer[%d] queued\n",
@@ -730,7 +730,7 @@ static void __find_outer_frame_size(struct stm32_dcmi *dcmi,
 		int h_err = (fsize->height - pix->height);
 		int err = w_err + h_err;
 
-		if ((w_err >= 0) && (h_err >= 0) && (err < min_err)) {
+		if (w_err >= 0 && h_err >= 0 && err < min_err) {
 			min_err = err;
 			match = fsize;
 		}
@@ -1065,10 +1065,10 @@ static int dcmi_s_selection(struct file *file, void *priv,
 	r.top  = clamp_t(s32, r.top, 0, pix.height - r.height);
 	r.left = clamp_t(s32, r.left, 0, pix.width - r.width);
 
-	if (!((r.top == dcmi->sd_bounds.top) &&
-	      (r.left == dcmi->sd_bounds.left) &&
-	      (r.width == dcmi->sd_bounds.width) &&
-	      (r.height == dcmi->sd_bounds.height))) {
+	if (!(r.top == dcmi->sd_bounds.top &&
+	      r.left == dcmi->sd_bounds.left &&
+	      r.width == dcmi->sd_bounds.width &&
+	      r.height == dcmi->sd_bounds.height)) {
 		/* Crop if request is different than sensor resolution */
 		dcmi->do_crop = true;
 		dcmi->crop = r;
-- 
1.9.1
