Return-Path: <SRS0=Hs4g=PC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A20C43387
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 23:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 913EE218AE
	for <linux-media@archiver.kernel.org>; Tue, 25 Dec 2018 23:27:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQDZVG5C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbeLYX1f (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 25 Dec 2018 18:27:35 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33197 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbeLYX1f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Dec 2018 18:27:35 -0500
Received: by mail-pf1-f194.google.com with SMTP id c123so7165019pfb.0;
        Tue, 25 Dec 2018 15:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6ZAriIxlYoeqP9IEVh5Nvz3X8xyHhiwRf4UwJ49BmUM=;
        b=LQDZVG5C26bXFU/pluou5yVmXbcD/D5Y9fhBSb6z8y3y+YE7BUsmwIyNegRQypOGgK
         6FutmvBZb6OmzSrMoTnHsoFjp+6S+UoXNOB1E/lkO0/cjXcyZmZ/UBN4Qv/TawD3iPPw
         dtDdIiOsnPAwf1T2SRDcSXnVlmDV1vMCKmQc1KNCfkjSw45WxeZUD2BFXUGxfQaeNGNK
         L3E/H4XwY6Pb6r6zjKr3NaBL+WrXwiKUJBvTnn6PKWFbMiKLN55vU4OqdACvoVDbRTB2
         y/VIKRqZgj0EZ0h5MsO2NtolfLFWSz1cNzvGwqYG1EH/0Wr5GkLCmONJ5jRmWXwy5p/w
         DC9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6ZAriIxlYoeqP9IEVh5Nvz3X8xyHhiwRf4UwJ49BmUM=;
        b=Iwu8paCQQxCHis14g8HRCVTzWiWlaGGD73gtNESaDGyMqOd3xCjVipbMzEHjHuF/5K
         HtzlhWByYD36f3wmHlAkOQU1QTS7TKl5Er5QXZYypIn/J4+VpO5rUSq6wT+RTSKXUKsI
         UoP42bnEy5K77rJL76kbde2bDEc2iGhO8ySc94sr2CHOWciiUG5jVmlwYkaxRUaNydho
         yZSeg8j3cakToLdHuMPW94fg9rT5Al0OwCrAoqhIGHbMaBnydPrwWkPYVmMhOJIPjNMB
         MgUtHEInQnq3CiDQeQI7F+ea1BVfgTWLNIIyFIH4OkP8SK0ehOAvSwNNXvdNuDgmRo2w
         d+wA==
X-Gm-Message-State: AJcUukc1hvX0lZaFV8mxtJyzTq2K1jZpI0D7kOZvetp2ICKOgZJb5bZo
        faN4HLqHqE9786NLMyqhHorNWGRu
X-Google-Smtp-Source: AFSGD/WsmWEkEHCBt32cJVDqy2NpgRRI0qnhzZ0TBRevPPtOkBSR7AhIDVNp5Sc6jsm5iGvmDdE8+A==
X-Received: by 2002:a62:59c9:: with SMTP id k70mr18021789pfj.243.1545780453624;
        Tue, 25 Dec 2018 15:27:33 -0800 (PST)
Received: from mappy.world.mentorg.com (c-98-210-181-167.hsd1.ca.comcast.net. [98.210.181.167])
        by smtp.gmail.com with ESMTPSA id y84sm67027552pfb.81.2018.12.25.15.27.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Dec 2018 15:27:32 -0800 (PST)
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-renesas-soc@vger.kernel.org (open list:MEDIA DRIVERS FOR RENESAS
        - VIN), linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH] media: rcar-vin: Allow independent VIN link enablement
Date:   Tue, 25 Dec 2018 15:27:25 -0800
Message-Id: <20181225232725.15935-1-slongerbeam@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There is a block of code in rvin_group_link_notify() that prevents
enabling a link to a VIN node if any entity in the media graph is
in use. This prevents enabling a VIN link even if there is an in-use
entity somewhere in the graph that is independent of the link's
pipeline.

For example, the code block will prevent enabling a link from
the first rcar-csi2 receiver to a VIN node even if there is an
enabled link somewhere far upstream on the second independent
rcar-csi2 receiver pipeline.

If this code block is meant to prevent modifying a link if the
link is actively involved in streaming, there is already such a
check in __media_entity_setup_link() that verifies the stream_count
of the link's source and sink entities are both zero.

Remove the code block so that VIN node links can be enabled even if
there are other independent in-use entities.

Fixes: c0cc5aef31 ("media: rcar-vin: add link notify for Gen3")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f0719ce24b97..b2c9a876969e 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -116,7 +116,6 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
 						struct rvin_group, mdev);
 	unsigned int master_id, channel, mask_new, i;
 	unsigned int mask = ~0;
-	struct media_entity *entity;
 	struct video_device *vdev;
 	struct media_pad *csi_pad;
 	struct rvin_dev *vin = NULL;
@@ -131,11 +130,6 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
 	    !is_media_entity_v4l2_video_device(link->sink->entity))
 		return 0;
 
-	/* If any entity is in use don't allow link changes. */
-	media_device_for_each_entity(entity, &group->mdev)
-		if (entity->use_count)
-			return -EBUSY;
-
 	mutex_lock(&group->lock);
 
 	/* Find the master VIN that controls the routes. */
-- 
2.17.1

