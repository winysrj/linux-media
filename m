Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1624C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 17:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7EDB8218FD
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 17:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbfBAR34 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 12:29:56 -0500
Received: from mga18.intel.com ([134.134.136.126]:40186 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730752AbfBAR34 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Feb 2019 12:29:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2019 09:29:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,549,1539673200"; 
   d="scan'208";a="296551851"
Received: from yzhi-z87x-ud5h.jf.intel.com ([134.134.159.168])
  by orsmga005.jf.intel.com with ESMTP; 01 Feb 2019 09:29:55 -0800
From:   Yong Zhi <yong.zhi@intel.com>
To:     linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc:     rajmohan.mani@intel.com, tfiga@chromium.org,
        laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
        mchehab@kernel.org, tian.shu.qiu@intel.com, bingbu.cao@intel.com,
        Yong Zhi <yong.zhi@intel.com>
Subject: [PATCH v3 2/2] media: ipu3-imgu: Remove dead code for NULL check
Date:   Fri,  1 Feb 2019 09:23:37 -0800
Message-Id: <1549041817-3862-2-git-send-email-yong.zhi@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1549041817-3862-1-git-send-email-yong.zhi@intel.com>
References: <1549041817-3862-1-git-send-email-yong.zhi@intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Since ipu3_css_buf_dequeue() never returns NULL, remove the
dead code to fix static checker warning:

drivers/staging/media/ipu3/ipu3.c:493 imgu_isr_threaded()
warn: 'b' is an error pointer or valid

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
[Bug report: https://lore.kernel.org/linux-media/20190104122856.GA1169@kadam/]
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/staging/media/ipu3/ipu3.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/ipu3/ipu3.c b/drivers/staging/media/ipu3/ipu3.c
index d521b3a..839d939 100644
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

