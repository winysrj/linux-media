Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C34C43381
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4E71218AC
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbfCOQpG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:45:06 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48980 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729661AbfCOQpF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 12:45:05 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 4A58F281584
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: [PATCH 02/16] media: vimc: Remove unnecessary stream check
Date:   Fri, 15 Mar 2019 13:43:45 -0300
Message-Id: <20190315164359.626-3-andrealmeid@collabora.com>
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

Since V4L2 already checks if the stream is running (and avoid starting
it twice), remove the check at subdevices.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
 drivers/media/platform/vimc/vimc-debayer.c | 3 ---
 drivers/media/platform/vimc/vimc-scaler.c  | 3 ---
 drivers/media/platform/vimc/vimc-sensor.c  | 4 ----
 3 files changed, 10 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
index fc3babdb3a1c..5f84cb38f0f9 100644
--- a/drivers/media/platform/vimc/vimc-debayer.c
+++ b/drivers/media/platform/vimc/vimc-debayer.c
@@ -337,9 +337,6 @@ static int vimc_deb_s_stream(struct v4l2_subdev *sd, int enable)
 		const struct v4l2_format_info *pix_info;
 		unsigned int frame_size;
 
-		if (vdeb->src_frame)
-			return 0;
-
 		/* We only support translating bayer to RGB24 */
 		if (src_pixelformat != V4L2_PIX_FMT_RGB24) {
 			dev_err(vdeb->dev,
diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
index d613297a75b8..3102febefd63 100644
--- a/drivers/media/platform/vimc/vimc-scaler.c
+++ b/drivers/media/platform/vimc/vimc-scaler.c
@@ -213,9 +213,6 @@ static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
 		const struct v4l2_format_info *pix_info;
 		unsigned int frame_size;
 
-		if (vsca->src_frame)
-			return 0;
-
 		if (!vimc_sca_is_pixfmt_supported(pixelformat)) {
 			dev_err(vsca->dev, "pixfmt (%s) is not supported\n",
 				v4l2_get_fourcc_name(pixelformat));
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index cfa72dd39748..44a75099ce7f 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -197,10 +197,6 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 		const struct v4l2_format_info *pix_info;
 		unsigned int frame_size;
 
-		if (vsen->kthread_sen)
-			/* tpg is already executing */
-			return 0;
-
 		/* Calculate the frame size */
 		pix_info = v4l2_format_info(pixelformat);
 		frame_size = vsen->mbus_format.width * pix_info->bpp[0] *
-- 
2.21.0

