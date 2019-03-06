Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05C6C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A85FF206DD
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfCFWni (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 17:43:38 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60870 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfCFWni (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 17:43:38 -0500
Received: from localhost.localdomain (unknown [IPv6:2804:431:9719:798c:6bb0:a97a:4a09:e6d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id B1EF928036E;
        Wed,  6 Mar 2019 22:43:28 +0000 (GMT)
From:   Helen Koike <helen.koike@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org, andrealmeid@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com
Subject: [PATCH 5/8] media: vimc: stream: cleanup frame field from struct vimc_stream
Date:   Wed,  6 Mar 2019 19:42:41 -0300
Message-Id: <20190306224244.21070-6-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190306224244.21070-1-helen.koike@collabora.com>
References: <20190306224244.21070-1-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There is no need to have the frame field in the vimc_stream struct.

Signed-off-by: Helen Koike <helen.koike@collabora.com>
---

 drivers/media/platform/vimc/vimc-streamer.c | 10 ++++------
 drivers/media/platform/vimc/vimc-streamer.h |  1 -
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/media/platform/vimc/vimc-streamer.c
index 392754c18046..b7c1fdef5f0d 100644
--- a/drivers/media/platform/vimc/vimc-streamer.c
+++ b/drivers/media/platform/vimc/vimc-streamer.c
@@ -117,6 +117,7 @@ static int vimc_streamer_pipeline_init(struct vimc_stream *stream,
 static int vimc_streamer_thread(void *data)
 {
 	struct vimc_stream *stream = data;
+	u8 *frame = NULL;
 	int i;
 
 	set_freezable();
@@ -127,12 +128,9 @@ static int vimc_streamer_thread(void *data)
 			break;
 
 		for (i = stream->pipe_size - 1; i >= 0; i--) {
-			stream->frame = stream->ved_pipeline[i]->process_frame(
-					stream->ved_pipeline[i],
-					stream->frame);
-			if (!stream->frame)
-				break;
-			if (IS_ERR(stream->frame))
+			frame = stream->ved_pipeline[i]->process_frame(
+					stream->ved_pipeline[i], frame);
+			if (!frame || IS_ERR(frame))
 				break;
 		}
 		//wait for 60hz
diff --git a/drivers/media/platform/vimc/vimc-streamer.h b/drivers/media/platform/vimc/vimc-streamer.h
index 752af2e2d5a2..dc1d0be431cb 100644
--- a/drivers/media/platform/vimc/vimc-streamer.h
+++ b/drivers/media/platform/vimc/vimc-streamer.h
@@ -19,7 +19,6 @@ struct vimc_stream {
 	struct media_pipeline pipe;
 	struct vimc_ent_device *ved_pipeline[VIMC_STREAMER_PIPELINE_MAX_SIZE];
 	unsigned int pipe_size;
-	u8 *frame;
 	struct task_struct *kthread;
 };
 
-- 
2.20.1

