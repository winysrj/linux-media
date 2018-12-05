Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2039C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 14:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C622084C
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 14:15:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1C622084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbeLEOP3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:15:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:5648 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbeLEOP3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 09:15:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Dec 2018 06:15:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,317,1539673200"; 
   d="scan'208";a="299544494"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2018 06:15:27 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id D8D212106C;
        Wed,  5 Dec 2018 16:15:26 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gUXxN-0001wZ-Qq; Wed, 05 Dec 2018 16:15:17 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     rajneesh.bhardwaj@intel.com, yong.zhi@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com
Subject: [PATCH 1/1] ipu3-cio2: Allow probe to succeed if there are no sensors connected
Date:   Wed,  5 Dec 2018 16:15:17 +0200
Message-Id: <20181205141517.7433-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The device won't be powered off on systems that have no sensors connected
unless it has a driver bound to it. Allow that to happen even if there are
no sensors connected to cio2.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 447baaebca448..e281e55cdca4a 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1810,7 +1810,8 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 
 	/* Register notifier for subdevices we care */
 	r = cio2_notifier_init(cio2);
-	if (r)
+	/* Proceed without sensors connected to allow the device to suspend. */
+	if (r && r != -ENODEV)
 		goto fail_cio2_queue_exit;
 
 	r = devm_request_irq(&pci_dev->dev, pci_dev->irq, cio2_irq,
-- 
2.11.0

