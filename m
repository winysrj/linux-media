Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:57328 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754585AbdJJHxO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:53:14 -0400
Received: by mail-wm0-f41.google.com with SMTP id l68so2568351wmd.5
        for <linux-media@vger.kernel.org>; Tue, 10 Oct 2017 00:53:14 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2] media: venus: venc: fix bytesused v4l2_plane field
Date: Tue, 10 Oct 2017 10:52:36 +0300
Message-Id: <20171010075236.26424-1-stanimir.varbanov@linaro.org>
In-Reply-To: <20171009122458.3053-2-stanimir.varbanov@linaro.org>
References: <20171009122458.3053-2-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes wrongly filled bytesused field of v4l2_plane structure
by include data_offset in the plane, Also fill data_offset and
bytesused for capture type of buffers only.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
v2: Just delete pointless WARN_ON.

 drivers/media/platform/qcom/venus/venc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 6f123a387cf9..3fcf0e9b7b29 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -963,13 +963,12 @@ static void venc_buf_done(struct venus_inst *inst, unsigned int buf_type,
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
 	} else {
-- 
2.11.0
