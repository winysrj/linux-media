Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:46963 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937280AbeE3HQv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 03:16:51 -0400
Received: by mail-pl0-f65.google.com with SMTP id 30-v6so10510561pld.13
        for <linux-media@vger.kernel.org>; Wed, 30 May 2018 00:16:51 -0700 (PDT)
From: Keiichi Watanabe <keiichiw@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 2/2] media: mtk-vcodec: Support VP9 profile in decoder
Date: Wed, 30 May 2018 16:16:13 +0900
Message-Id: <20180530071613.125768-3-keiichiw@chromium.org>
In-Reply-To: <20180530071613.125768-1-keiichiw@chromium.org>
References: <20180530071613.125768-1-keiichiw@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_CID_MPEG_VIDEO_VP9_PROFILE control in MediaTek decoder's
driver.
MediaTek decoder only supports profile 0 for now.

Signed-off-by: Keiichi Watanabe <keiichiw@chromium.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 86f0a7134365..f9393504356d 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -1400,6 +1400,12 @@ int mtk_vcodec_dec_ctrls_setup(struct mtk_vcodec_ctx *ctx)
 				V4L2_CID_MIN_BUFFERS_FOR_CAPTURE,
 				0, 32, 1, 1);
 	ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	v4l2_ctrl_new_std_menu(&ctx->ctrl_hdl,
+				&mtk_vcodec_dec_ctrl_ops,
+				V4L2_CID_MPEG_VIDEO_VP9_PROFILE,
+				V4L2_MPEG_VIDEO_VP9_PROFILE_3,
+				~(1U << V4L2_MPEG_VIDEO_VP9_PROFILE_0),
+				V4L2_MPEG_VIDEO_VP9_PROFILE_0);

 	if (ctx->ctrl_hdl.error) {
 		mtk_v4l2_err("Adding control failed %d",
--
2.17.0.921.gf22659ad46-goog
