Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E55C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 123F62173C
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 15:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbfC0PTa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 11:19:30 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48560 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730792AbfC0PT2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 11:19:28 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: tonyk)
        with ESMTPSA id 6DC82281FF2
From:   =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     mchehab@kernel.org, hverkuil@xs4all.nl, helen.koike@collabora.com,
        lucmaga@gmail.com, linux-kernel@vger.kernel.org,
        kernel@collabora.com, lkcamp@lists.libreplanetbr.org
Subject: [PATCH v2 10/15] media: vimc: Propagate multiplanar state in the stream
Date:   Wed, 27 Mar 2019 12:17:38 -0300
Message-Id: <20190327151743.18528-11-andrealmeid@collabora.com>
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

Add a multiplanar flag in vimc_stream in order to propagate the
state (singleplanar/multiplanar) to subdevices at the stream.

Signed-off-by: André Almeida <andrealmeid@collabora.com>
---
Change in v2:
- New commit

 drivers/media/platform/vimc/vimc-capture.c  | 7 +++++--
 drivers/media/platform/vimc/vimc-streamer.h | 3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 57bc2b64b093..3c93fbd51629 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -454,12 +454,15 @@ static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
 		return ret;
 	}
 
-	if (IS_MULTIPLANAR(vcap))
+	if (IS_MULTIPLANAR(vcap)) {
 		vcap->stream.producer_pixfmt =
 			vcap->format.fmt.pix_mp.pixelformat;
-	else
+		vcap->stream.multiplanar = true;
+	} else {
 		vcap->stream.producer_pixfmt =
 			vcap->format.fmt.pix.pixelformat;
+		vcap->stream.multiplanar = false;
+	}
 
 	ret = vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 1);
 	if (ret) {
diff --git a/drivers/media/platform/vimc/vimc-streamer.h b/drivers/media/platform/vimc/vimc-streamer.h
index 2b3667408794..4878e0b72ea7 100644
--- a/drivers/media/platform/vimc/vimc-streamer.h
+++ b/drivers/media/platform/vimc/vimc-streamer.h
@@ -25,6 +25,8 @@
  * processed in the pipeline.
  * @pipe_size:		size of @ved_pipeline
  * @kthread:		thread that generates the frames of the stream.
+ * @multiplanar:	sets if the stream is running in multiplanar or
+ * singleplanar format mode
  * @producer_pixfmt:	the pixel format requested from the pipeline. This must
  * be set just before calling vimc_streamer_s_stream(ent, 1). This value is
  * propagated up to the source of the base image (usually a sensor node) and
@@ -40,6 +42,7 @@ struct vimc_stream {
 	struct vimc_ent_device *ved_pipeline[VIMC_STREAMER_PIPELINE_MAX_SIZE];
 	unsigned int pipe_size;
 	struct task_struct *kthread;
+	bool multiplanar;
 	u32 producer_pixfmt;
 };
 
-- 
2.21.0

