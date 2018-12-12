Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BB9EC04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 11:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AAC12084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 11:49:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AAC12084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbeLLLta (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 06:49:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:57975 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbeLLLt3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 06:49:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2018 03:49:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,344,1539673200"; 
   d="scan'208";a="117723810"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga002.jf.intel.com with ESMTP; 12 Dec 2018 03:49:26 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id C07662022B;
        Wed, 12 Dec 2018 13:49:25 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gX311-0005sW-Oh; Wed, 12 Dec 2018 13:49:23 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     yong.zhi@intel.com, bingbu.cao@intel.com, tian.shu.qiu@intel.com
Subject: [PATCH 1/1] ipu3-cio2: Use MEDIA_ENT_F_VID_IF_BRIDGE as receiver entity function
Date:   Wed, 12 Dec 2018 13:49:23 +0200
Message-Id: <20181212114923.22557-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Address the following warnings by setting the entity's function to an
appropriate value.

[    5.043377] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 0 was not initialized!
[    5.043427] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 1 was not initialized!
[    5.043463] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 2 was not initialized!
[    5.043502] ipu3-cio2 0000:00:14.3: Entity type for entity ipu3-csi2 3 was not initialized!

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 447baaebca448..e827e12b9718f 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1597,6 +1597,7 @@ static int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
 
 	/* Initialize subdev */
 	v4l2_subdev_init(subdev, &cio2_subdev_ops);
+	subdev->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
 	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	subdev->owner = THIS_MODULE;
 	snprintf(subdev->name, sizeof(subdev->name),
-- 
2.11.0

