Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09036C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2F0520675
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfCFWoA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 17:44:00 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60884 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfCFWoA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 17:44:00 -0500
Received: from localhost.localdomain (unknown [IPv6:2804:431:9719:798c:6bb0:a97a:4a09:e6d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 7232E28036E;
        Wed,  6 Mar 2019 22:43:49 +0000 (GMT)
From:   Helen Koike <helen.koike@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org, andrealmeid@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com
Subject: [PATCH 7/8] media: vimc: stream: init/terminate the first entity
Date:   Wed,  6 Mar 2019 19:42:43 -0300
Message-Id: <20190306224244.21070-8-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190306224244.21070-1-helen.koike@collabora.com>
References: <20190306224244.21070-1-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The s_stream callback was not being called for the first entity in the
stream pipeline array.
Instead of verifying the type of the node (video or subdevice) and
calling s_stream from the second entity in the pipeline, do this process
for all the entities in the pipeline for consistency.

The previous code was not a problem because the first entity is a video
device and not a subdevice, but this patch prepares vimc to allow
setting some configuration in the entity before calling s_stream.

Signed-off-by: Helen Koike <helen.koike@collabora.com>
---

 drivers/media/platform/vimc/vimc-streamer.c | 25 ++++++++++++---------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/media/platform/vimc/vimc-streamer.c
index b7c1fdef5f0d..5a3bda62fbc8 100644
--- a/drivers/media/platform/vimc/vimc-streamer.c
+++ b/drivers/media/platform/vimc/vimc-streamer.c
@@ -46,19 +46,18 @@ static struct media_entity *vimc_get_source_entity(struct media_entity *ent)
  */
 static void vimc_streamer_pipeline_terminate(struct vimc_stream *stream)
 {
-	struct media_entity *entity;
+	struct vimc_ent_device *ved;
 	struct v4l2_subdev *sd;
 
 	while (stream->pipe_size) {
 		stream->pipe_size--;
-		entity = stream->ved_pipeline[stream->pipe_size]->ent;
-		entity = vimc_get_source_entity(entity);
+		ved = stream->ved_pipeline[stream->pipe_size];
 		stream->ved_pipeline[stream->pipe_size] = NULL;
 
-		if (!is_media_entity_v4l2_subdev(entity))
+		if (!is_media_entity_v4l2_subdev(ved->ent))
 			continue;
 
-		sd = media_entity_to_v4l2_subdev(entity);
+		sd = media_entity_to_v4l2_subdev(ved->ent);
 		v4l2_subdev_call(sd, video, s_stream, 0);
 	}
 }
@@ -89,18 +88,24 @@ static int vimc_streamer_pipeline_init(struct vimc_stream *stream,
 		}
 		stream->ved_pipeline[stream->pipe_size++] = ved;
 
+		if (is_media_entity_v4l2_subdev(ved->ent)) {
+			sd = media_entity_to_v4l2_subdev(ved->ent);
+			ret = v4l2_subdev_call(sd, video, s_stream, 1);
+			if (ret && ret != -ENOIOCTLCMD) {
+				pr_err("subdev_call error %s\n", ved->ent->name);
+				vimc_streamer_pipeline_terminate(stream);
+				return ret;
+			}
+		}
+
 		entity = vimc_get_source_entity(ved->ent);
 		/* Check if the end of the pipeline was reached*/
 		if (!entity)
 			return 0;
 
+		/* Get the next device in the pipeline */
 		if (is_media_entity_v4l2_subdev(entity)) {
 			sd = media_entity_to_v4l2_subdev(entity);
-			ret = v4l2_subdev_call(sd, video, s_stream, 1);
-			if (ret && ret != -ENOIOCTLCMD) {
-				vimc_streamer_pipeline_terminate(stream);
-				return ret;
-			}
 			ved = v4l2_get_subdevdata(sd);
 		} else {
 			vdev = container_of(entity,
-- 
2.20.1

