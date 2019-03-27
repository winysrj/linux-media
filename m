Return-Path: <SRS0=UobA=R6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78324C4360F
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48C9A205C9
	for <linux-media@archiver.kernel.org>; Wed, 27 Mar 2019 18:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553713055;
	bh=SeuXXXEJshdCjxNBfiXdPj39+UBW8JBgmx3N6Jlwr0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rkR7FNmdyBhITVIITAeLbnPEwmW4HcHpPNTV/TyZJxG/LNvrujsCwnvbOFDD8MJGI
	 GqxFqoKMLGvXlCfm9ADLt0nuqPrx7rbqsn64RcQVnzGFFjD4/6xY//5/kznY2qQgdX
	 VHi1qL5Q7WeOSEqmupB/l1GtyanbqFMS3/LBEdG8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389915AbfC0SPw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Mar 2019 14:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388942AbfC0SPw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Mar 2019 14:15:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA9A217D9;
        Wed, 27 Mar 2019 18:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553710550;
        bh=SeuXXXEJshdCjxNBfiXdPj39+UBW8JBgmx3N6Jlwr0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFXHPKK+2c9xJA+7+8PB2R4GjtTCGWrMxh7iFVclwSVNKvD5WadNTcooNTRqwamcU
         jC5yo48kCJP3O5+jb6d8A9umyQ4A+51yzsjj997JJH3ZvLWzLrvUf6PiwxEPjz6IID
         k29BybciNqkcLKfM3l0ik82X4FxtEezUOBTRSn+M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 172/192] media: rcar-vin: Allow independent VIN link enablement
Date:   Wed, 27 Mar 2019 14:10:04 -0400
Message-Id: <20190327181025.13507-172-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327181025.13507-1-sashal@kernel.org>
References: <20190327181025.13507-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

[ Upstream commit c5ff0edb8e2270a75935c73217fb0de1abd2d910 ]

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
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index ce09799976ef..e1085e3ab3cc 100644
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
2.19.1

