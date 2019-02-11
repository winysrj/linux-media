Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416C2C282D7
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 09:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AE6120863
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 09:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfBKJSW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:18:22 -0500
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:51696 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726212AbfBKJSW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 04:18:22 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id t7jEgrcjwRO5Zt7jIg2zCM; Mon, 11 Feb 2019 10:18:20 +0100
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
To:     linux-media@vger.kernel.org
Cc:     Dafna Hirschfeld <dafna3@gmail.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 3/3] cedrus: set requires_requests
Date:   Mon, 11 Feb 2019 10:18:16 +0100
Message-Id: <20190211091816.33022-4-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190211091816.33022-1-hverkuil-cisco@xs4all.nl>
References: <20190211091816.33022-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfMP3vo0ujAS4UGBm8MBrZ0e0zc+lDAY95UwhAWyGIk1IGyg56LYP4J6lQLpO2Pgz5LE5tWgg+p79RzeU5DBuZo5K8vThdVRxydItboZnx6cjX33SgPtJ
 jmEQ8jRrrkWSjzzXbiXhQ5Yq9OKFXExxojSFmSp6UzjpvYVYC++k87y3v96CF+8ETh/GNbJD0lT5biFhMgso4Ls7f6vo+07vysS4gLaumy/DiyLJAKcqmdo/
 cxqXf3b11qM8s1Ma5x8F8GpK0fX81R88dqZg71tlTcwh7kSbVXGgXcdp1K8blC1OKmG04UVXF/CRLEaqSV4TFEqSLYLrdFxUjL7lMUavVKs=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The cedrus stateless decoder requires the use of request, so
indicate this by setting requires_requests to 1.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/staging/media/sunxi/cedrus/cedrus_video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
index b5cc79389d67..2c77d82a8527 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
@@ -526,6 +526,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->lock = &ctx->dev->dev_mutex;
 	src_vq->dev = ctx->dev->dev;
 	src_vq->supports_requests = true;
+	src_vq->requires_requests = true;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
-- 
2.20.1

