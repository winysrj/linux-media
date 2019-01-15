Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AEAC43387
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 03:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E725220866
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 03:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfAODh5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 22:37:57 -0500
Received: from mga12.intel.com ([192.55.52.136]:58713 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbfAODh5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 22:37:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Jan 2019 19:37:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,480,1539673200"; 
   d="scan'208";a="114725376"
Received: from harojas-mobl1.amr.corp.intel.com (HELO yzhi-desktop.amr.corp.intel.com) ([10.254.10.3])
  by fmsmga007.fm.intel.com with ESMTP; 14 Jan 2019 19:37:55 -0800
From:   Yong Zhi <yong.zhi@intel.com>
To:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc:     tfiga@chromium.org, rajmohan.mani@intel.com,
        tian.shu.qiu@intel.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, mchehab@kernel.org, bingbu.cao@intel.com,
        dan.carpenter@oracle.com, Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH 2/2] media: ipu3-imgu: Remove dead code for NULL check
Date:   Mon, 14 Jan 2019 21:37:45 -0600
Message-Id: <1547523465-27807-2-git-send-email-yong.zhi@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1547523465-27807-1-git-send-email-yong.zhi@intel.com>
References: <1547523465-27807-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Since ipu3_css_buf_dequeue() never returns NULL, remove the
dead code to fix static checker warning:

drivers/staging/media/ipu3/ipu3.c:493 imgu_isr_threaded()
warn: 'b' is an error pointer or valid

Signed-off-by: Yong Zhi <yong.zhi@intel.com>
---
Link to Dan's bug report:
https://www.spinics.net/lists/linux-media/msg145043.html

 drivers/staging/media/ipu3/ipu3.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
index d521b3afb8b1..839d9398f8e9 100644
--- a/drivers/staging/media/ipu3/ipu3.c
+++ b/drivers/staging/media/ipu3/ipu3.c
@@ -489,12 +489,11 @@ static irqreturn_t imgu_isr_threaded(int irq, void *imgu_ptr)
 			mutex_unlock(&imgu->lock);
 		} while (PTR_ERR(b) == -EAGAIN);
 
-		if (IS_ERR_OR_NULL(b)) {
-			if (!b || PTR_ERR(b) == -EBUSY)	/* All done */
-				break;
-			dev_err(&imgu->pci_dev->dev,
-				"failed to dequeue buffers (%ld)\n",
-				PTR_ERR(b));
+		if (IS_ERR(b)) {
+			if (PTR_ERR(b) != -EBUSY)	/* All done */
+				dev_err(&imgu->pci_dev->dev,
+					"failed to dequeue buffers (%ld)\n",
+					PTR_ERR(b));
 			break;
 		}
 
-- 
2.7.4

