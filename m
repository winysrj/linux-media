Return-Path: <SRS0=7C2H=RS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF89C4360F
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05AE9218D4
	for <linux-media@archiver.kernel.org>; Fri, 15 Mar 2019 16:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbfCOQp4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:45:56 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:49094 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbfCOQpw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Mar 2019 12:45:52 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id E13E0281586
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: [PATCH 16/16] media: vimc: cap: Dynamically define device caps
Date:   Fri, 15 Mar 2019 13:43:59 -0300
Message-Id: <20190315164359.626-17-andrealmeid@collabora.com>
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

The device capabilities are defined according to the
multiplanar kernel parameter. A device can't support
both CAP_VIDEO_CAPTURE and CAP_VIDEO_CAPTURE_MPLANAR
at the same time.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
 drivers/media/platform/vimc/vimc-capture.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 50f7e71f23cd..c30a2887db33 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -652,7 +652,9 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 
 	/* Initialize the vb2 queue */
 	q = &vcap->queue;
-	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->type = multiplanar ?
+		V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+		V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_USERPTR;
 	q->drv_priv = vcap;
 	q->buf_struct_size = sizeof(struct vimc_cap_buffer);
@@ -697,7 +699,9 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 
 	/* Initialize the video_device struct */
 	vdev = &vcap->vdev;
-	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	vdev->device_caps = (multiplanar ?
+			V4L2_CAP_VIDEO_CAPTURE_MPLANE :
+			V4L2_BUF_TYPE_VIDEO_CAPTURE) | V4L2_CAP_STREAMING;
 	vdev->entity.ops = &vimc_cap_mops;
 	vdev->release = video_device_release_empty;
 	vdev->fops = &vimc_cap_fops;
-- 
2.21.0

