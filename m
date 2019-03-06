Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 140D4C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF63C206DD
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 22:43:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbfCFWnt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 17:43:49 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60874 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfCFWnt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2019 17:43:49 -0500
Received: from localhost.localdomain (unknown [IPv6:2804:431:9719:798c:6bb0:a97a:4a09:e6d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 2218E27FF14;
        Wed,  6 Mar 2019 22:43:36 +0000 (GMT)
From:   Helen Koike <helen.koike@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        lkcamp@lists.libreplanetbr.org, andrealmeid@collabora.com,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com
Subject: [PATCH 6/8] media: vimc: stream: add docs to struct vimc_stream
Date:   Wed,  6 Mar 2019 19:42:42 -0300
Message-Id: <20190306224244.21070-7-helen.koike@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190306224244.21070-1-helen.koike@collabora.com>
References: <20190306224244.21070-1-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add missing documentation for struct vimc_stream

Signed-off-by: Helen Koike <helen.koike@collabora.com>
---

 drivers/media/platform/vimc/vimc-streamer.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/vimc/vimc-streamer.h b/drivers/media/platform/vimc/vimc-streamer.h
index dc1d0be431cb..a7c5ac5ace4f 100644
--- a/drivers/media/platform/vimc/vimc-streamer.h
+++ b/drivers/media/platform/vimc/vimc-streamer.h
@@ -15,6 +15,21 @@
 
 #define VIMC_STREAMER_PIPELINE_MAX_SIZE 16
 
+/**
+ * struct vimc_stream - struct that represents a stream in the pipeline
+ *
+ * @pipe:		the media pipeline object associated with this stream
+ * @ved_pipeline:	array containing all the entities participating in the
+ * stream. The order is from a video device (usually a capture device) where
+ * stream_on was called, to the entity generating the first base image to be
+ * processed in the pipeline.
+ * @pipe_size:		size of @ved_pipeline
+ * @kthread:		thread that generates the frames of the stream.
+ *
+ * When the user call stream_on in a video device, struct vimc_stream is
+ * used to keep track of all entities and subdevices that generates and
+ * process frames for the stream.
+ */
 struct vimc_stream {
 	struct media_pipeline pipe;
 	struct vimc_ent_device *ved_pipeline[VIMC_STREAMER_PIPELINE_MAX_SIZE];
-- 
2.20.1

