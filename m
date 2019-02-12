Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9F2C282CA
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 23:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 670D620869
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 23:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731996AbfBLXtE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 18:49:04 -0500
Received: from mxhk.zte.com.cn ([63.217.80.70]:14854 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728792AbfBLXtE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 18:49:04 -0500
Received: from mse01.zte.com.cn (unknown [10.30.3.20])
        by Forcepoint Email with ESMTPS id 97E5AD5EE8295C9A5969;
        Wed, 13 Feb 2019 07:49:01 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse01.zte.com.cn with ESMTP id x1CNmuEI002250;
        Wed, 13 Feb 2019 07:48:56 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019021307491490-25782404 ;
          Wed, 13 Feb 2019 07:49:14 +0800 
From:   Wen Yang <wen.yang99@zte.com.cn>
To:     m.szyprowski@samsung.com
Cc:     mchehab@kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        Wen Yang <wen.yang99@zte.com.cn>,
        "Hans Verkuil (hansverk)" <hansverk@cisco.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wen Yang <yellowriver2010@hotmail.com>
Subject: [PATCH v2 3/4] media: s5p-cec: fix possible object reference leak
Date:   Wed, 13 Feb 2019 07:47:59 +0800
Message-Id: <1550015279-42723-1-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-02-13 07:49:14,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-02-13 07:48:48,
        Serialize complete at 2019-02-13 07:48:48
X-MAIL: mse01.zte.com.cn x1CNmuEI002250
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The call to of_parse_phandle() returns a node pointer with refcount
incremented thus it must be explicitly decremented here after the last
usage.
The of_find_device_by_node() takes a reference to the underlying device
structure, we also should release that reference.
This patch fixes those two issues.

Hans Verkuil says:
The cec driver should never take a reference of the hdmi device.
It never accesses the HDMI device, it only needs the HDMI device pointer as
a key in the notifier list.
The real problem is that several CEC drivers take a reference of the HDMI
device and never release it. So those drivers need to be fixed.

Fixes: a93d429b51fb ("[media] s5p-cec: add cec-notifier support, move out of staging")
Suggested-by: Hans Verkuil (hansverk) <hansverk@cisco.com>
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Hans Verkuil (hansverk) <hansverk@cisco.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wen Yang <yellowriver2010@hotmail.com>
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org
---
v2->v1: 
- move of_node_put() to just after the 'hdmi_dev = of_find_device_by_node(np)'.
- put_device() can be done before the cec = devm_kzalloc line.

 drivers/media/platform/s5p-cec/s5p_cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
index 8837e26..1f5c355 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -192,9 +192,11 @@ static int s5p_cec_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 	hdmi_dev = of_find_device_by_node(np);
+	of_node_put(np);
 	if (hdmi_dev == NULL)
 		return -EPROBE_DEFER;
 
+	put_device(&hdmi_dev->dev);
 	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
 	if (!cec)
 		return -ENOMEM;
-- 
2.9.5

