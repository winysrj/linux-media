Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46BCC00319
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A50222070B
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 14:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfBUOV5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 09:21:57 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:55785 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727545AbfBUOV4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 09:21:56 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id wpETg3zIdLMwIwpEYg1DVS; Thu, 21 Feb 2019 15:21:55 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 7/7] vimc: free vimc_cap_device when the last user disappears
Date:   Thu, 21 Feb 2019 15:21:48 +0100
Message-Id: <20190221142148.3412-8-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfEFfH2w905IGNUNpewA18h8FgNTDIlBaZv8cYCmfD8ONPHiTgayzK8uxiuIBhydVzGtKzjBXGeCpTOUXyEYyr1ctIiI1fakgPtFtOEhOZwWPchM3V6Eq
 ywVszzjkeHR6ePuhYZ6Cl+36JnMaUAJGC4wH1tdLrBtYI0Kmi45povaRzdrYSzvwKtrNr08SMfv2Ab12BldNxhrEJqkltXqrvs8EFFO8dRVHTAtU3gcZOhme
 nKLhYQggDT4u5QFfOY3RAEFsG0yY2K86CNFJCmWw+bSAhYjarniHSf2wLKkOLypoGE/I58C1KJpN6tusJh88xA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Don't free vimc_cap_device immediately, instead do this
in the video_device release function which is called when the
last user closes the video device. Only then is it safe to
free the memory.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
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

