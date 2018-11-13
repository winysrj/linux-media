Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36491 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731295AbeKMT2I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 14:28:08 -0500
Received: by mail-pf1-f193.google.com with SMTP id d13-v6so5758507pfo.3
        for <linux-media@vger.kernel.org>; Tue, 13 Nov 2018 01:30:54 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [PATCH] media: venus: fix reported size of 0-length buffers
Date: Tue, 13 Nov 2018 18:30:48 +0900
Message-Id: <20181113093048.236201-1-acourbot@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The last buffer is often signaled by an empty buffer with the
V4L2_BUF_FLAG_LAST flag set. Such buffers were returned with the
bytesused field set to the full size of the OPB, which leads
user-space to believe that the buffer actually contains useful data. Fix
this by passing the number of bytes reported used by the firmware.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 189ec975c6bb..282de21cf2e1 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -885,10 +885,8 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
 	vbuf->field = V4L2_FIELD_NONE;
 
 	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
-		unsigned int opb_sz = venus_helper_get_opb_size(inst);
-
 		vb = &vbuf->vb2_buf;
-		vb2_set_plane_payload(vb, 0, bytesused ? : opb_sz);
+		vb2_set_plane_payload(vb, 0, bytesused);
 		vb->planes[0].data_offset = data_offset;
 		vb->timestamp = timestamp_us * NSEC_PER_USEC;
 		vbuf->sequence = inst->sequence_cap++;
-- 
2.19.1.930.g4563a0d9d0-goog
