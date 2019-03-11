Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0224C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A7FC20657
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 14:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfCKOBd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 10:01:33 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39984 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726897AbfCKOBd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 10:01:33 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 46AE5752EC5F1A47A0E9;
        Mon, 11 Mar 2019 22:01:31 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.408.0; Mon, 11 Mar 2019 22:01:30 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <gregkh@linuxfoundation.org>, <Julia.Lawall@lip6.fr>,
        <kimbrownkd@gmail.com>, <colin.king@canonical.com>,
        <hans.verkuil@cisco.com>, <linux-media@vger.kernel.org>,
        <devel@driverdev.osuosl.org>
Subject: [PATCH] staging: davinci: drop pointless static qualifier in vpfe_resizer_init()
Date:   Mon, 11 Mar 2019 22:14:05 +0800
Message-ID: <20190311141405.123611-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There is no need to have the 'T *v' variable static
since new value always be assigned before use it.

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 6098f43ac51b..a2a672d4615d 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1881,7 +1881,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 	struct v4l2_subdev *sd = &vpfe_rsz->crop_resizer.subdev;
 	struct media_pad *pads = &vpfe_rsz->crop_resizer.pads[0];
 	struct media_entity *me = &sd->entity;
-	static resource_size_t  res_len;
+	resource_size_t  res_len;
 	struct resource *res;
 	int ret;
 
-- 
2.20.1

