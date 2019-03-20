Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F8DCC4360F
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 205762184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfCTMdQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 08:33:16 -0400
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:33158 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727916AbfCTMdI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 08:33:08 -0400
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud9.xs4all.net with ESMTPA
        id 6aP3hd3OKeXb86aP4hCEUL; Wed, 20 Mar 2019 13:33:06 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCH v5.1 2/2] cedrus: set requires_requests
Date:   Wed, 20 Mar 2019 13:33:05 +0100
Message-Id: <20190320123305.5224-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190320123305.5224-1-hverkuil-cisco@xs4all.nl>
References: <20190320123305.5224-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfFyHJoj8MpaET1Wn/JKYnvOayg0QoUYoWtmhrbXrn1YD4YU0dMveNnMc+HSxYEFu2C1YK53rOj8AxZ0wzAHXD6tAujhSRC3uoGgkoHLBsh9dw+n8NCSl
 XWkP4NNvMnF0HYjxMv4KERXn1bQIocjqcIUYy+WSKF88MkX+xvDoV3SiHtXRDAMbIvo/zZCJBwiCEr4JK7wphC5iahKPXFCzjChhIqRvql4Xf1KuMUxh+9M5
 DNgJdQvKciVPMnYaN95/ADF8FReQRqJ9QsXt4Q10lfs=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

The cedrus stateless decoder requires the use of request, so
indicate this by setting requires_requests to 1.

Note that the cedrus driver never checked for this, and as far
as I can tell would just crash if an attempt was made to queue
a buffer without a request.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index b47854b3bce4..9673874ece10 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -536,6 +536,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->lock = &ctx->dev->dev_mutex;
 	src_vq->dev = ctx->dev->dev;
 	src_vq->supports_requests = true;
+	src_vq->requires_requests = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
-- 
2.20.1

