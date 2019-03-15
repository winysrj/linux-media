Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80EFC43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A6BD218D4
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbfCOQpa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:45:30 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49036 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbfCOQp3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 12:45:29 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 0F6D7281585
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: [PATCH 09/16] media: vimc: cap: Add multiplanar formats
Date:   Fri, 15 Mar 2019 13:43:52 -0300
Message-Id: <20190315164359.626-10-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190315164359.626-1-andrealmeid@collabora.com>
References: <20190315164359.626-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add multiplanar formats to be exposed to the userspace as
supported formats. Since we don't want to support multiplanar
formats when the driver is in singleplanar mode, we only access
the multiplanar formats array if the multiplanar mode is enabled.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
 drivers/media/platform/vimc/vimc-capture.c | 30 ++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 09a8fd618b12..2d668012e9e9 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -54,6 +54,19 @@ static const u32 vimc_cap_supported_pixfmt[] = {
 	V4L2_PIX_FMT_SRGGB12,
 };
 
+static const u32 vimc_cap_supported_pixfmt_mp[] = {
+	V4L2_PIX_FMT_YUV420M,
+	V4L2_PIX_FMT_YVU420M,
+	V4L2_PIX_FMT_YUV422M,
+	V4L2_PIX_FMT_YVU422M,
+	V4L2_PIX_FMT_YUV444M,
+	V4L2_PIX_FMT_YVU444M,
+	V4L2_PIX_FMT_NV12M,
+	V4L2_PIX_FMT_NV21M,
+	V4L2_PIX_FMT_NV16M,
+	V4L2_PIX_FMT_NV61M,
+};
+
 struct vimc_cap_device {
 	struct vimc_ent_device ved;
 	struct video_device vdev;
@@ -153,13 +166,26 @@ static int vimc_cap_try_fmt_vid_cap(struct file *file, void *priv,
 				format->width, format->height);
 }
 
+/**
+ * When multiplanar is true, consider that the vimc_cap_enum_fmt_vid_cap_mp
+ * is concantenate in the vimc_cap_enum_fmt_vid_cap array. Otherwise, just
+ * consider the single-planar array
+ */
 static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
 				     struct v4l2_fmtdesc *f)
 {
-	if (f->index >= ARRAY_SIZE(vimc_cap_supported_pixfmt))
+	const unsigned int sp_size = ARRAY_SIZE(vimc_cap_supported_pixfmt);
+	const unsigned int mp_size = ARRAY_SIZE(vimc_cap_supported_pixfmt_mp);
+
+	if (f->index >= sp_size + (multiplanar ? mp_size : 0))
 		return -EINVAL;
 
-	f->pixelformat = vimc_cap_supported_pixfmt[f->index];
+	if (f->index >= sp_size)
+		f->pixelformat = vimc_cap_supported_pixfmt_mp[f->index -
+							      sp_size];
+	else
+		f->pixelformat = vimc_cap_supported_pixfmt[f->index];
+
 	strncpy(f->description, v4l2_get_fourcc_name(f->pixelformat), 4);
 	f->description[4] = '\0';
 
-- 
2.21.0

