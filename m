Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A90C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 15:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FD2620989
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 15:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfCRPzd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:55:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:39560 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbfCRPzd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 11:55:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Mar 2019 08:55:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,494,1544515200"; 
   d="scan'208";a="143022210"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga002.jf.intel.com with ESMTP; 18 Mar 2019 08:55:31 -0700
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 1744720399;
        Mon, 18 Mar 2019 17:55:30 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1h5ubV-0007cv-Rx; Mon, 18 Mar 2019 17:55:10 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     rajmohan.mani@intel.com, tfiga@chromium.org
Subject: [PATCH 1/1] ipu3-cio2: Set CSI-2 receiver sub-device entity function
Date:   Mon, 18 Mar 2019 17:55:09 +0200
Message-Id: <20190318155509.29279-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Set the entity function for the four CSI-2 receiver sub-devices the driver
creates. This avoids a kernel warning from each as well.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 617fb2e944dc3..b76dff851f3d2 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1601,6 +1601,7 @@ static int cio2_queue_init(struct cio2_device *cio2, struct cio2_queue *q)
 	subdev->owner = THIS_MODULE;
 	snprintf(subdev->name, sizeof(subdev->name),
 		 CIO2_ENTITY_NAME " %td", q - cio2->queue);
+	subdev->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
 	v4l2_set_subdevdata(subdev, cio2);
 	r = v4l2_device_register_subdev(&cio2->v4l2_dev, subdev);
 	if (r) {
-- 
2.11.0

