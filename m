Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:33965 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753544AbdHROQ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 10:16:58 -0400
Received: by mail-wr0-f170.google.com with SMTP id y96so68405118wrc.1
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 07:16:58 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 7/7] media: venus: venc: drop VP9 codec support
Date: Fri, 18 Aug 2017 17:16:06 +0300
Message-Id: <20170818141606.4835-8-stanimir.varbanov@linaro.org>
In-Reply-To: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
References: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No one of the supported Venus version has implemented VP9 codec
for enconding, so drop it from the list of codecs.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/venc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 9f459024aa07..6f123a387cf9 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -84,10 +84,6 @@ static const struct venus_format venc_formats[] = {
 		.pixfmt = V4L2_PIX_FMT_VP8,
 		.num_planes = 1,
 		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
-	}, {
-		.pixfmt = V4L2_PIX_FMT_VP9,
-		.num_planes = 1,
-		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
 	},
 };
 
-- 
2.11.0
