Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A3FC4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6767208E4
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfCESvs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:51:48 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:51673 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727755AbfCESvr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:51:47 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id F264F20000F;
        Tue,  5 Mar 2019 18:51:43 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 11/31] media: entity: Skip link validation for pads to which there is no route to
Date:   Tue,  5 Mar 2019 19:51:30 +0100
Message-Id: <20190305185150.20776-12-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Links are validated along the pipeline which is about to start streaming.
Not all the pads in entities that are traversed along that pipeline are
part of the pipeline, however. Skip the link validation for such pads,
and while at there rename "other_pad" to "local_pad" to convey the fact
the route to be checked is internal to the entity.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/media-entity.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 3304e76bbafa..5d21ecaaaf4b 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -488,11 +488,16 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
 		bitmap_fill(has_no_links, entity->num_pads);
 
 		list_for_each_entry(link, &entity->links, list) {
-			struct media_pad *other_pad = link->sink->entity == entity
+			struct media_pad *local_pad = link->sink->entity == entity
 				? link->sink : link->source;
 
+			/* Ignore pads to which there is no route. */
+			if (!media_entity_has_route(entity, pad->index,
+						    local_pad->index))
+				continue;
+
 			/* Mark that a pad is connected by a link. */
-			bitmap_clear(has_no_links, other_pad->index, 1);
+			bitmap_clear(has_no_links, local_pad->index, 1);
 
 			/*
 			 * Pads that either do not need to connect or
@@ -501,13 +506,13 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
 			 */
 			if (!(pad->flags & MEDIA_PAD_FL_MUST_CONNECT) ||
 			    link->flags & MEDIA_LNK_FL_ENABLED)
-				bitmap_set(active, other_pad->index, 1);
+				bitmap_set(active, local_pad->index, 1);
 
 			/*
 			 * Link validation will only take place for
 			 * sink ends of the link that are enabled.
 			 */
-			if (link->sink != other_pad ||
+			if (link->sink != local_pad ||
 			    !(link->flags & MEDIA_LNK_FL_ENABLED))
 				continue;
 
-- 
2.20.1

