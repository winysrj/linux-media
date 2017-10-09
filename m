Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:52673 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754141AbdJIMZZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 08:25:25 -0400
Received: by mail-wm0-f54.google.com with SMTP id k4so22958071wmc.1
        for <linux-media@vger.kernel.org>; Mon, 09 Oct 2017 05:25:25 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 2/2] media: venus: venc: fix bytesused v4l2_plane field
Date: Mon,  9 Oct 2017 15:24:58 +0300
Message-Id: <20171009122458.3053-2-stanimir.varbanov@linaro.org>
In-Reply-To: <20171009122458.3053-1-stanimir.varbanov@linaro.org>
References: <20171009122458.3053-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes wrongly filled bytesused field of v4l2_plane structure
by include data_offset in the plane, Also fill data_offset and
bytesused for capture type of buffers only.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/venc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 6f123a387cf9..9445ad492966 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -963,15 +963,16 @@ static void venc_buf_done(struct venus_inst *inst, unsigned int buf_type,
 	if (!vbuf)
 		return;
 
-	vb = &vbuf->vb2_buf;
-	vb->planes[0].bytesused = bytesused;
-	vb->planes[0].data_offset = data_offset;
-
 	vbuf->flags = flags;
 
 	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		vb = &vbuf->vb2_buf;
+		vb2_set_plane_payload(vb, 0, bytesused + data_offset);
+		vb->planes[0].data_offset = data_offset;
 		vb->timestamp = timestamp_us * NSEC_PER_USEC;
 		vbuf->sequence = inst->sequence_cap++;
+
+		WARN_ON(vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0));
 	} else {
 		vbuf->sequence = inst->sequence_out++;
 	}
-- 
2.11.0
