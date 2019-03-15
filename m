Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95210C10F00
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63EBF218D0
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbfCOQpe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:45:34 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49042 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbfCOQpd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 12:45:33 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 3A20D260215
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: [PATCH 10/16] media: vimc: cap: Add multiplanar default format
Date:   Fri, 15 Mar 2019 13:43:53 -0300
Message-Id: <20190315164359.626-11-andrealmeid@collabora.com>
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

vimc already have a default single planar default format.
Add a multiplanar default pixel format to perfom those
same actions.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
 drivers/media/platform/vimc/vimc-capture.c | 31 +++++++++++++++++-----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 2d668012e9e9..24052f15c4cf 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -96,6 +96,15 @@ static const struct v4l2_format fmt_default = {
 	.fmt.pix.colorspace = V4L2_COLORSPACE_DEFAULT,
 };
 
+static const struct v4l2_format fmt_default_mp = {
+	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
+	.fmt.pix_mp.width = 640,
+	.fmt.pix_mp.height = 480,
+	.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_YVU420M,
+	.fmt.pix_mp.field = V4L2_FIELD_NONE,
+	.fmt.pix_mp.colorspace = V4L2_COLORSPACE_DEFAULT,
+};
+
 struct vimc_cap_buffer {
 	/*
 	 * struct vb2_v4l2_buffer must be the first element
@@ -160,7 +169,9 @@ static int vimc_cap_try_fmt_vid_cap(struct file *file, void *priv,
 
 	/* Don't accept a pixelformat that is not on the table */
 	if (!v4l2_format_info(format->pixelformat))
-		format->pixelformat = fmt_default.fmt.pix.pixelformat;
+		format->pixelformat = multiplanar ?
+				fmt_default_mp.fmt.pix_mp.pixelformat :
+				fmt_default.fmt.pix.pixelformat;
 
 	return v4l2_fill_pixfmt_mp(format, format->pixelformat,
 				format->width, format->height);
@@ -627,11 +638,19 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 	spin_lock_init(&vcap->qlock);
 
 	/* Set default frame format */
-	vcap->format = fmt_default;
-	v4l2_fill_pixfmt(&vcap->format.fmt.pix,
-			 vcap->format.fmt.pix.pixelformat,
-			 vcap->format.fmt.pix.width,
-			 vcap->format.fmt.pix.height);
+	if (multiplanar) {
+		vcap->format = fmt_default_mp;
+		v4l2_fill_pixfmt_mp(&vcap->format.fmt.pix_mp,
+				vcap->format.fmt.pix_mp.pixelformat,
+				vcap->format.fmt.pix_mp.width,
+				vcap->format.fmt.pix_mp.height);
+	} else {
+		vcap->format = fmt_default;
+		v4l2_fill_pixfmt(&vcap->format.fmt.pix,
+				vcap->format.fmt.pix.pixelformat,
+				vcap->format.fmt.pix.width,
+				vcap->format.fmt.pix.height);
+	}
 
 	/* Fill the vimc_ent_device struct */
 	vcap->ved.ent = &vcap->vdev.entity;
-- 
2.21.0

