Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7B8C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2346C2146F
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731250AbfC0PTr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:19:47 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48610 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730980AbfC0PTq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 11:19:46 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id F03BC281FF2
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com, lkcamp@lists.libreplanetbr.org
Subject: [PATCH v2 15/15] media: vimc: Create multiplanar parameter
Date:   Wed, 27 Mar 2019 12:17:43 -0300
Message-Id: <20190327151743.18528-16-andrealmeid@collabora.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190327151743.18528-1-andrealmeid@collabora.com>
References: <20190327151743.18528-1-andrealmeid@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Create multiplanar kernel module parameter to define if the driver is
running in single planar or in multiplanar mode. Define the device
capabilities according to the multiplanar kernel parameter. A device can't
support both CAP_VIDEO_CAPTURE and CAP_VIDEO_CAPTURE_MPLANAR at the
same time.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
Change in v2:
- Squash commits to create multiplanar module parameter and to define
the device capabilities
- Move the creation of the multiplanar parameter to the end of
history, so it's only added when all required changes are applied

 drivers/media/platform/vimc/vimc-capture.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index f5bfb36a145c..3666fcca6812 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -28,6 +28,10 @@
 
 #define VIMC_CAP_DRV_NAME "vimc-capture"
 
+static unsigned int multiplanar;
+module_param(multiplanar, uint, 0000);
+MODULE_PARM_DESC(multiplanar, "0 (default) creates a single planar device, 1 creates a multiplanar device.");
+
 /* Checks if the device supports multiplanar capture */
 #define IS_MULTIPLANAR(vcap) \
 	(vcap->vdev.device_caps & V4L2_CAP_VIDEO_CAPTURE_MPLANE)
@@ -681,7 +685,9 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 
 	/* Initialize the vb2 queue */
 	q = &vcap->queue;
-	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->type = multiplanar ?
+		V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE :
+		V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	q->io_modes = VB2_MMAP | VB2_DMABUF | VB2_USERPTR;
 	q->drv_priv = vcap;
 	q->buf_struct_size = sizeof(struct vimc_cap_buffer);
@@ -709,9 +715,12 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 	dev_set_drvdata(comp, &vcap->ved);
 	vcap->dev = comp;
 
+
 	/* Initialize the video_device struct */
 	vdev = &vcap->vdev;
-	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	vdev->device_caps = (multiplanar ?
+			V4L2_CAP_VIDEO_CAPTURE_MPLANE :
+			V4L2_BUF_TYPE_VIDEO_CAPTURE) | V4L2_CAP_STREAMING;
 	vdev->entity.ops = &vimc_cap_mops;
 	vdev->release = vimc_cap_release;
 	vdev->fops = &vimc_cap_fops;
-- 
2.21.0

