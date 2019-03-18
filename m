Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163FCC4360F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E51912175B
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfCRTQ7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:16:59 -0400
Received: from retiisi.org.uk ([95.216.213.190]:55240 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727546AbfCRTQ6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 15:16:58 -0400
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 7D7D3634C86;
        Mon, 18 Mar 2019 21:15:03 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Subject: [RFC 6/8] ipu3-cio2: Clean up notifier's subdev list if parsing endpoints fails
Date:   Mon, 18 Mar 2019 21:16:51 +0200
Message-Id: <20190318191653.7197-7-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190318191653.7197-1-sakari.ailus@linux.intel.com>
References: <20190318191653.7197-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The notifier must be cleaned up whenever parsing endpoints fails. Do that
to avoid a memory leak in that case.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 617fb2e944dc..5972c215148a 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1504,7 +1504,7 @@ static int cio2_notifier_init(struct cio2_device *cio2)
 		sizeof(struct sensor_async_subdev),
 		cio2_fwnode_parse);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	if (list_empty(&cio2->notifier.asd_list))
 		return -ENODEV;	/* no endpoint */
@@ -1514,9 +1514,13 @@ static int cio2_notifier_init(struct cio2_device *cio2)
 	if (ret) {
 		dev_err(&cio2->pci_dev->dev,
 			"failed to register async notifier : %d\n", ret);
-		v4l2_async_notifier_cleanup(&cio2->notifier);
+		goto out;
 	}
 
+out:
+	if (ret)
+		v4l2_async_notifier_cleanup(&cio2->notifier);
+
 	return ret;
 }
 
-- 
2.11.0

