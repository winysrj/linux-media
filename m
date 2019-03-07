Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23F4C10F0C
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 09:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 466A120840
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 09:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfCGJaK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 04:30:10 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:59382 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726207AbfCGJaJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 04:30:09 -0500
Received: from test-no.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 1pLlh7xLdLMwI1pLrhxTCs; Thu, 07 Mar 2019 10:30:07 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv3 8/9] vimc: free vimc_cap_device when the last user disappears
Date:   Thu,  7 Mar 2019 10:30:00 +0100
Message-Id: <20190307093001.30435-9-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190307093001.30435-1-hverkuil-cisco@xs4all.nl>
References: <20190307093001.30435-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfN8kVqLfMSIe67KDjPWm7pSwY91BmLSoJhwI/fxub4/tZMqvd5NqVW/d123Y2Mx4LZSgDg6Cl4m1NXZSezslHhNvXQo+osxvyyiJn3u2CLqIFVtmLZbr
 x+5ws6qHa8aOofg75DTFIi9/my+GrOL3I59aUC01miCMjpcN/dK3HlIevUQZW4cnCIaY9fTsky7vN7QtlqM1Fql/daJBcVfXHr101s7zr/pyfZ4KDwP0RWSG
 LgvEWuFQMuwKwCtxRh8MG3z0lUk9RUSzk2TAx91mh+cc0wkdNoy5oqA3jMyBztYNfYAdjPh3UxK9P84U97FubQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Don't free vimc_cap_device immediately, instead do this
in the video_device release function which is called when the
last user closes the video device. Only then is it safe to
free the memory.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vimc/vimc-capture.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index ea869631a3f6..3d433361d297 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -338,6 +338,15 @@ static const struct media_entity_operations vimc_cap_mops = {
 	.link_validate		= vimc_link_validate,
 };
 
+static void vimc_cap_release(struct video_device *vdev)
+{
+	struct vimc_cap_device *vcap = container_of(vdev, struct vimc_cap_device,
+						    vdev);
+
+	vimc_pads_cleanup(vcap->ved.pads);
+	kfree(vcap);
+}
+
 static void vimc_cap_comp_unbind(struct device *comp, struct device *master,
 				 void *master_data)
 {
@@ -348,8 +357,6 @@ static void vimc_cap_comp_unbind(struct device *comp, struct device *master,
 	vb2_queue_release(&vcap->queue);
 	media_entity_cleanup(ved->ent);
 	video_unregister_device(&vcap->vdev);
-	vimc_pads_cleanup(vcap->ved.pads);
-	kfree(vcap);
 }
 
 static void *vimc_cap_process_frame(struct vimc_ent_device *ved,
@@ -467,7 +474,7 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 	vdev = &vcap->vdev;
 	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	vdev->entity.ops = &vimc_cap_mops;
-	vdev->release = video_device_release_empty;
+	vdev->release = vimc_cap_release;
 	vdev->fops = &vimc_cap_fops;
 	vdev->ioctl_ops = &vimc_cap_ioctl_ops;
 	vdev->lock = &vcap->lock;
-- 
2.20.1

