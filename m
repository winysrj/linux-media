Return-Path: <SRS0=+L2G=PM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FEFC43612
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 16:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D031B21872
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 16:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfADQMc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 4 Jan 2019 11:12:32 -0500
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:24784 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726256AbfADQMb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Jan 2019 11:12:31 -0500
X-Halon-ID: 818c4d46-103b-11e9-874f-005056917f90
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-02.atm.binero.net (Halon) with ESMTPA
        id 818c4d46-103b-11e9-874f-005056917f90;
        Fri, 04 Jan 2019 17:12:20 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] rcar-vin: remove unneeded locking in async callbacks
Date:   Fri,  4 Jan 2019 17:12:18 +0100
Message-Id: <20190104161218.24120-1-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The locking implemented in the async notifier callbacks are unnecessary
as the global list_lock in v4l2-async.c is held whenever one of the
callbacks are called.

The locking in itself is not harmful however it produces a LOCKDEP
warning between the global v4l2-async list_lock and the rcar-vin local
locking schema. Remove the rcar-vin locking for the async callbacks to
reduce complexity and silent the false LOCKDEP warning.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f0719ce24b97a9f9..0e81b557f3b6e53c 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -542,9 +542,7 @@ static void rvin_parallel_notify_unbind(struct v4l2_async_notifier *notifier,
 
 	vin_dbg(vin, "unbind parallel subdev %s\n", subdev->name);
 
-	mutex_lock(&vin->lock);
 	rvin_parallel_subdevice_detach(vin);
-	mutex_unlock(&vin->lock);
 }
 
 static int rvin_parallel_notify_bound(struct v4l2_async_notifier *notifier,
@@ -554,9 +552,7 @@ static int rvin_parallel_notify_bound(struct v4l2_async_notifier *notifier,
 	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
 	int ret;
 
-	mutex_lock(&vin->lock);
 	ret = rvin_parallel_subdevice_attach(vin, subdev);
-	mutex_unlock(&vin->lock);
 	if (ret)
 		return ret;
 
@@ -664,7 +660,6 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
 	}
 
 	/* Create all media device links between VINs and CSI-2's. */
-	mutex_lock(&vin->group->lock);
 	for (route = vin->info->routes; route->mask; route++) {
 		struct media_pad *source_pad, *sink_pad;
 		struct media_entity *source, *sink;
@@ -700,7 +695,6 @@ static int rvin_group_notify_complete(struct v4l2_async_notifier *notifier)
 			break;
 		}
 	}
-	mutex_unlock(&vin->group->lock);
 
 	return ret;
 }
@@ -716,8 +710,6 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
 		if (vin->group->vin[i])
 			rvin_v4l2_unregister(vin->group->vin[i]);
 
-	mutex_lock(&vin->group->lock);
-
 	for (i = 0; i < RVIN_CSI_MAX; i++) {
 		if (vin->group->csi[i].fwnode != asd->match.fwnode)
 			continue;
@@ -725,8 +717,6 @@ static void rvin_group_notify_unbind(struct v4l2_async_notifier *notifier,
 		vin_dbg(vin, "Unbind CSI-2 %s from slot %u\n", subdev->name, i);
 		break;
 	}
-
-	mutex_unlock(&vin->group->lock);
 }
 
 static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
@@ -736,8 +726,6 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
 	struct rvin_dev *vin = v4l2_dev_to_vin(notifier->v4l2_dev);
 	unsigned int i;
 
-	mutex_lock(&vin->group->lock);
-
 	for (i = 0; i < RVIN_CSI_MAX; i++) {
 		if (vin->group->csi[i].fwnode != asd->match.fwnode)
 			continue;
@@ -746,8 +734,6 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
 		break;
 	}
 
-	mutex_unlock(&vin->group->lock);
-
 	return 0;
 }
 
-- 
2.20.1

