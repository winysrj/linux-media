Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15DDC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 01:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8638A2086D
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 01:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbfBUBT3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 20:19:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:54672 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726700AbfBUBT3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 20:19:29 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4735290610FD52356E0A;
        Thu, 21 Feb 2019 09:19:26 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.408.0; Thu, 21 Feb 2019 09:19:16 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Patrick Lerda <patrick9876@free.fr>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-media@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] media: rc: remove unused including <linux/version.h>
Date:   Thu, 21 Feb 2019 01:32:55 +0000
Message-ID: <20190221013255.156500-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Remove including <linux/version.h> that don't need it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/media/rc/ir-rcmm-decoder.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/rc/ir-rcmm-decoder.c b/drivers/media/rc/ir-rcmm-decoder.c
index f1096ac1e5c5..64fb65a9a19f 100644
--- a/drivers/media/rc/ir-rcmm-decoder.c
+++ b/drivers/media/rc/ir-rcmm-decoder.c
@@ -5,7 +5,6 @@
 
 #include "rc-core-priv.h"
 #include <linux/module.h>
-#include <linux/version.h>
 
 #define RCMM_UNIT		166667	/* nanosecs */
 #define RCMM_PREFIX_PULSE	416666  /* 166666.666666666*2.5 */





