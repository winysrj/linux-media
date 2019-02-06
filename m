Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D21C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 21:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F72217F9
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 21:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbfBFV3P (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 16:29:15 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47842 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbfBFV3P (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 16:29:15 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id A856526CF0E
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 1/2] rockchip/vpu: Rename pixel format helpers
Date:   Wed,  6 Feb 2019 18:28:59 -0300
Message-Id: <20190206212900.30321-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The rockchip VPU driver uses generic names for its pixel format
helpers. We want to use the same names for generic versions
of these helpers, so temporarily rename the rockchip ones,
to avoid the name collision.

The driver will be switched to the generic helpers later,
and the driver helpers will go away.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../staging/media/rockchip/vpu/rockchip_vpu_enc.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
index ab0fb2053620..fb5e36aedd8c 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
@@ -41,7 +41,7 @@
  * @is_compressed: Is it a compressed format?
  * @multiplanar: Is it a multiplanar variant format? (e.g. NV12M)
  */
-struct v4l2_format_info {
+struct rockchip_vpu_v4l2_format_info {
 	u32 format;
 	u32 header_size;
 	u8 num_planes;
@@ -52,10 +52,10 @@ struct v4l2_format_info {
 	u8 multiplanar;
 };
 
-static const struct v4l2_format_info *
-v4l2_format_info(u32 format)
+static const struct rockchip_vpu_v4l2_format_info *
+rockchip_vpu_v4l2_format_info(u32 format)
 {
-	static const struct v4l2_format_info formats[] = {
+	static const struct rockchip_vpu_v4l2_format_info formats[] = {
 		{ .format = V4L2_PIX_FMT_YUV420M,	.num_planes = 3, .cpp = { 1, 1, 1 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
 		{ .format = V4L2_PIX_FMT_NV12M,		.num_planes = 2, .cpp = { 1, 2, 0 }, .hsub = 2, .vsub = 2, .multiplanar = 1 },
 		{ .format = V4L2_PIX_FMT_YUYV,		.num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 2, .vsub = 1 },
@@ -76,11 +76,11 @@ static void
 fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt,
 	       int pixelformat, int width, int height)
 {
-	const struct v4l2_format_info *info;
+	const struct rockchip_vpu_v4l2_format_info *info;
 	struct v4l2_plane_pix_format *plane;
 	int i;
 
-	info = v4l2_format_info(pixelformat);
+	info = rockchip_vpu_v4l2_format_info(pixelformat);
 	if (!info)
 		return;
 
-- 
2.20.1

