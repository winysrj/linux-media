Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FDBC43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 05:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 345C2218D9
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 05:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfB0F54 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 00:57:56 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:4173 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725914AbfB0F54 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 00:57:56 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9A5E484FE98949BE9BF1;
        Wed, 27 Feb 2019 13:57:52 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.408.0; Wed, 27 Feb 2019
 13:57:46 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <mchehab@kernel.org>, <gregkh@linuxfoundation.org>,
        <heiko@sntech.de>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devel@driverdev.osuosl.org>, <linux-media@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] media: rockchip-vpu: Remove duplicated include from rockchip_vpu_drv.c
Date:   Wed, 27 Feb 2019 13:57:23 +0800
Message-ID: <20190227055723.27488-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
index 962412c..5761146 100644
--- a/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
+++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
@@ -22,7 +22,6 @@
 #include <media/v4l2-event.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/videobuf2-core.h>
-#include <media/videobuf2-core.h>
 #include <media/videobuf2-vmalloc.h>
 
 #include "rockchip_vpu_common.h"
-- 
2.7.0


