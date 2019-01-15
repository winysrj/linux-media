Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBA2C43444
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87FCA205C9
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:10:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UfRPiKU0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfAOBKh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 20:10:37 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33610 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfAOBKg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 20:10:36 -0500
Received: by mail-pl1-f196.google.com with SMTP id z23so471313plo.0;
        Mon, 14 Jan 2019 17:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eP6uF8slG5iT5YdRTwXRwNSjOO8UngFqPnVkGwD3rns=;
        b=UfRPiKU0tGb5XEtUhZRPSR3p6IqNNrXsbz+n6K/PlZi991s2/uSDMvXxLwTG9Laot3
         mgWkPOwI0OL0ugf6I0S3/le8hcncixq4LkqnjHUue2AVUn7t1DRg5TFgQOaelR4KfT/N
         iAkCICURgRbh4ehcmCXa8P+W/IoBmehPU25QAkY42BxnOMYHmn2zfd99ZcvSyIgSRCYH
         JwJO0ZfzMkZkGPYVw/a8/8hts76kss7d4ggdZbftzmf7XS1Ci6hgoYnCcLoROvhnwaSU
         A6yxNWcs4x6lY0TJoHKSGBqPznWqTdyzbyrbrC1/FE+uPQh7zN6kdH/My7vUSbRdocya
         Y2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eP6uF8slG5iT5YdRTwXRwNSjOO8UngFqPnVkGwD3rns=;
        b=lwrcn8U04v6vXpxwhUcZ8JwpPqxT09GwbkMq1cYBDwnnYMmo8Td/ivPFGfxW/GOQDb
         X52OLx3b5t0X7X9BrVMgHmBvDk1dNoeTvk1rt1PFMqmSAV06c8e7z/7FSIEjfvXwNJJZ
         QSPQeJsncUfoNsnqqT3KgadVuVEECSsq1VwjrF/116keCvCwnz4Xrhxs/J7GnJN3JNXf
         FVRCWKNBSl+OFO8Btufw+VM62WVoNdSoGBgRX5nCeHed33wu60iAjo0cUf26lQfN+x8A
         T/qqWHd7i0JbSZVzbSRWiXmw3iMhQUz5d1LnAxuedHzhTtUAeuDXXvaQT/kRWpHLVNZq
         6LhQ==
X-Gm-Message-State: AJcUukfZWzLA6l/EX+l87PQLMPFTrRSfCtLyAKg+TdtzmTdxfRVn0Knt
        otMgUb8VeVQM+OchvIiP2apxAhs6wRc=
X-Google-Smtp-Source: ALg8bN7x/hdo0wnKkMX3KYX9kZAKgCYiyPf35Oz6tL3LBf1FumYBg6aSUU/J+WBZ4prWvhYqZXyVcQ==
X-Received: by 2002:a17:902:724a:: with SMTP id c10mr1379391pll.51.1547514635489;
        Mon, 14 Jan 2019 17:10:35 -0800 (PST)
Received: from majic.sklembedded.com (c-73-202-231-77.hsd1.ca.comcast.net. [73.202.231.77])
        by smtp.googlemail.com with ESMTPSA id y71sm2488523pfi.123.2019.01.14.17.10.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 17:10:34 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-renesas-soc@vger.kernel.org (open list:MEDIA DRIVERS FOR RENESAS
        - VIN), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] media: rcar-vin: Allow independent VIN link enablement
Date:   Mon, 14 Jan 2019 17:10:19 -0800
Message-Id: <20190115011019.20025-1-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

There is a block of code in rvin_group_link_notify() that prevents
enabling a link to a VIN node if any entity in the media graph is
in use. This prevents enabling a VIN link even if there is an in-use
entity somewhere in the graph that is independent of the link's
pipeline.

For example, the code block will prevent enabling a link from
the first rcar-csi2 receiver to a VIN node even if there is an
enabled link somewhere far upstream on the second independent
rcar-csi2 receiver pipeline.

If this code block is meant to prevent modifying a link if any entity
in the graph is actively involved in streaming (because modifying
the CHSEL register fields can disrupt any/all running streams), then
the entities stream counts should be checked rather than the use counts.

(There is already such a check in __media_entity_setup_link() that verifies
the stream_count of the link's source and sink entities are both zero,
but that is insufficient, since there should be no running streams in
the entire graph).

Modify the code block to check the entity stream_count instead of the
use_count (and elaborate on the comment). VIN node links can now be
enabled even if there are other independent in-use entities that are
not streaming.

Fixes: c0cc5aef31 ("media: rcar-vin: add link notify for Gen3")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
Changes in v3:
- Removed RFC from subject and added Niklas' Reviewed-by.
  No functional changes.
Changes in v2:
- bring back the media_device_for_each_entity() loop but check the
  stream_count not the use_count.
---
 drivers/media/platform/rcar-vin/rcar-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f0719ce24b97..aef8d8dab6ab 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -131,9 +131,13 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
 	    !is_media_entity_v4l2_video_device(link->sink->entity))
 		return 0;
 
-	/* If any entity is in use don't allow link changes. */
+	/*
+	 * Don't allow link changes if any entity in the graph is
+	 * streaming, modifying the CHSEL register fields can disrupt
+	 * running streams.
+	 */
 	media_device_for_each_entity(entity, &group->mdev)
-		if (entity->use_count)
+		if (entity->stream_count)
 			return -EBUSY;
 
 	mutex_lock(&group->lock);
-- 
2.17.1

