Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84B0C43387
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 21:20:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F3552070C
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 21:20:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dmLjOxv3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfAFVUc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 16:20:32 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53316 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbfAFVUc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 16:20:32 -0500
Received: by mail-wm1-f65.google.com with SMTP id d15so5464374wmb.3;
        Sun, 06 Jan 2019 13:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=l/m278v1FdY2IwqJYejNRD0kA2spZH4uZWxndJarknI=;
        b=dmLjOxv33a9TIxAdoo9GtkhTVCFassCFTRiEqgMB3RNS/QbUIuCbCimrPpJWRzFiXl
         VZ93PVsLJzLDzaqZSl4zqu1W67H7oDAq+kepSfIGnGz/8TFTx8uwCA45PPgDn54lH475
         TWoSlKtbYqMDqXkR76VQH0oTjx0UG3mz0fOViaJt+mr6xbe5rflAS60OIcxB7JBFuppd
         cvBrobM4YDBUaii20IxoiV25jBrhKH3VtH2FGE0gFiY/tfFKoHs9cFloS5o0igqGnm3P
         FS0Q7KR1nO8LnssWzT6wudfOlruYzfT5Fcr0HTwCW+kJPnmKOSC3ElXNa2MwiUr1NWZu
         5Iwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l/m278v1FdY2IwqJYejNRD0kA2spZH4uZWxndJarknI=;
        b=UCsiSvCSKB6udRYzfND2VOfczYrccvX41bOEtxQ+jPe5JTFFDLVlnxHaYgV16RNxx3
         xtudHAcIx+S9lvajrND/gxYuy+8dv/I/nxi5z5u+WE+S74AqJm10pIV45ZK+TnaRXzc3
         eAfQUmLi0vK5jbVxsB2i6a1qei0/qUmzRW4GCDZ6qzSmTryvJcLVBCUO1yO4dsKCR1UW
         22SvweHjkz7rFJPoG+y4drBySpgqIIeaMfRPvdnPcL16Ko8TNeeyR3YrN5XYVxxPPLS9
         Cq4sqIrw8fVbrtyLraLFPFtTuCC0JG/HDYEGuJsG9kuGqw/mNwCJKprOKmr/lNuCWeOo
         xO9Q==
X-Gm-Message-State: AJcUukfTA5smXej5dUCl0xf10LkQzrpYpNuisv8erqt2NMSqg1u3tJ6z
        KKq1E7YckyIHZuWRAyIvVRKid76+
X-Google-Smtp-Source: ALg8bN56xqHU7busknN2X9AqT+8g8tm68U0LVOkEuDdeHpxOtRXu32z6xvNXIq2oGpxqpwqaux8cqw==
X-Received: by 2002:a1c:26c1:: with SMTP id m184mr1628258wmm.25.1546809629009;
        Sun, 06 Jan 2019 13:20:29 -0800 (PST)
Received: from mappy.world.mentorg.com (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id o81sm10451476wmd.10.2019.01.06.13.20.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Jan 2019 13:20:27 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-renesas-soc@vger.kernel.org (open list:MEDIA DRIVERS FOR RENESAS
        - VIN), linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH v2] media: rcar-vin: Allow independent VIN link enablement
Date:   Sun,  6 Jan 2019 13:20:18 -0800
Message-Id: <20190106212018.16519-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There is a block of code in rvin_group_link_notify() that loops through
all entities in the media graph, and prevents enabling a link to a VIN
node if any entity is in use. This prevents enabling a VIN link even if
there is an in-use entity somewhere in the graph that is independent of
the link's pipeline.

For example, the code will prevent enabling a link from the first
rcar-csi2 receiver to a VIN node even if there is an enabled link
somewhere far upstream on the second independent rcar-csi2 receiver
pipeline.

If this code is meant to prevent modifying a link if any entity in the
graph is actively involved in streaming (because modifying the CHSEL
register fields can disrupt any/all running streams), then the entities
stream counts should be checked rather than the use counts.

(There is already such a check in __media_entity_setup_link() that verifies
the stream_count of the link's source and sink entities are both zero,
but that is insufficient, since there should be no running streams in
the entire graph).

Modify the media_device_for_each_entity() loop to check the entity
stream_count instead of the use_count, and elaborate on the comment.
VIN node links can now be enabled even if there are other independent
in-use entities that are not streaming.

Fixes: c0cc5aef31 ("media: rcar-vin: add link notify for Gen3")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
Changes in v2:
- bring back the media_device_for_each_entity() loop but check the
  stream_count not the use_count.
---
 drivers/media/platform/rcar-vin/rcar-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f0719ce24b97..6dd6b11c1b2b 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -131,9 +131,13 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
 	    !is_media_entity_v4l2_video_device(link->sink->entity))
 		return 0;
 
-	/* If any entity is in use don't allow link changes. */
+	/*
+	 * Don't allow link changes if any entity in the graph is
+	 * streaming, because modifying the CHSEL register fields
+	 * can disrupt running streams.
+	 */
 	media_device_for_each_entity(entity, &group->mdev)
-		if (entity->use_count)
+		if (entity->stream_count)
 			return -EBUSY;
 
 	mutex_lock(&group->lock);
-- 
2.17.1

