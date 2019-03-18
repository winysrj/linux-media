Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A565C4360F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B20A2133F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfCRTQ5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:16:57 -0400
Received: from retiisi.org.uk ([95.216.213.190]:55206 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727577AbfCRTQ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 15:16:57 -0400
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 3AA54634C80;
        Mon, 18 Mar 2019 21:15:03 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Subject: [RFC 3/8] v4l2-fwnode: Use v4l2_async_notifier_add_fwnode_remote_subdev
Date:   Mon, 18 Mar 2019 21:16:48 +0200
Message-Id: <20190318191653.7197-4-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190318191653.7197-1-sakari.ailus@linux.intel.com>
References: <20190318191653.7197-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Shorten v4l2_async_notifier_fwnode_parse_endpoint by using
v4l2_async_notifier_add_fwnode_remote_subdev.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 27827842dffd..74af7065996a 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -615,15 +615,6 @@ v4l2_async_notifier_fwnode_parse_endpoint(struct device *dev,
 	if (!asd)
 		return -ENOMEM;
 
-	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-	asd->match.fwnode =
-		fwnode_graph_get_remote_endpoint(endpoint);
-	if (!asd->match.fwnode) {
-		dev_dbg(dev, "no remote endpoint found\n");
-		ret = -ENOTCONN;
-		goto out_err;
-	}
-
 	ret = v4l2_fwnode_endpoint_alloc_parse(endpoint, &vep);
 	if (ret) {
 		dev_warn(dev, "unable to parse V4L2 fwnode endpoint (%d)\n",
@@ -643,7 +634,8 @@ v4l2_async_notifier_fwnode_parse_endpoint(struct device *dev,
 	if (ret < 0)
 		goto out_err;
 
-	ret = v4l2_async_notifier_add_subdev(notifier, asd);
+	ret = v4l2_async_notifier_add_fwnode_remote_subdev(notifier, endpoint,
+							   asd);
 	if (ret < 0) {
 		/* not an error if asd already exists */
 		if (ret == -EEXIST)
-- 
2.11.0

