Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B14C282CE
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 23:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CC3620869
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 23:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbfBLXt7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 18:49:59 -0500
Received: from mxhk.zte.com.cn ([63.217.80.70]:54484 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728445AbfBLXt7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 18:49:59 -0500
Received: from mse01.zte.com.cn (unknown [10.30.3.20])
        by Forcepoint Email with ESMTPS id 9DD0DDBCF2CD546476AA;
        Wed, 13 Feb 2019 07:49:56 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse01.zte.com.cn with ESMTP id x1CNnpY5002336;
        Wed, 13 Feb 2019 07:49:51 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019021307501023-25782424 ;
          Wed, 13 Feb 2019 07:50:10 +0800 
From:   Wen Yang <wen.yang99@zte.com.cn>
To:     benjamin.gaignard@linaro.org
Cc:     mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>,
        "Hans Verkuil (hansverk)" <hansverk@cisco.com>,
        Wen Yang <yellowriver2010@hotmail.com>
Subject: [PATCH v2 4/4] media: platform: sti: fix possible object reference leak
Date:   Wed, 13 Feb 2019 07:48:49 +0800
Message-Id: <1550015329-42952-1-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-02-13 07:50:10,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-02-13 07:49:44,
        Serialize complete at 2019-02-13 07:49:44
X-MAIL: mse01.zte.com.cn x1CNnpY5002336
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The call to of_parse_phandle() returns a node pointer with refcount
incremented thus it must be explicitly decremented here after the last
usage.
The of_find_device_by_node() takes a reference to the underlying device
structure, we also should release that reference.

Hans Verkuil says:
The cec driver should never take a reference of the hdmi device.
It never accesses the HDMI device, it only needs the HDMI device pointer as
a key in the notifier list.
The real problem is that several CEC drivers take a reference of the HDMI
device and never release it. So those drivers need to be fixed.

This patch fixes those two issues.

Fixes: fc4e009c6c98 ("[media] stih-cec: add CEC notifier support")
Suggested-by: Hans Verkuil (hansverk) <hansverk@cisco.com>
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Hans Verkuil (hansverk) <hansverk@cisco.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Wen Yang <yellowriver2010@hotmail.com>
Cc: linux-media@vger.kernel.org
---
v2->v1: 
- move of_node_put() to just after the 'hdmi_dev = of_find_device_by_node(np)'.
- put_device() can be done before the cec = devm_kzalloc line.

 drivers/media/platform/sti/cec/stih-cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/sti/cec/stih-cec.c b/drivers/media/platform/sti/cec/stih-cec.c
index d34099f..721021f 100644
--- a/drivers/media/platform/sti/cec/stih-cec.c
+++ b/drivers/media/platform/sti/cec/stih-cec.c
@@ -317,9 +317,11 @@ static int stih_cec_probe(struct platform_device *pdev)
 	}
 
 	hdmi_dev = of_find_device_by_node(np);
+	of_node_put(np);
 	if (!hdmi_dev)
 		return -EPROBE_DEFER;
 
+	put_device(&hdmi_dev->dev);
 	cec->notifier = cec_notifier_get(&hdmi_dev->dev);
 	if (!cec->notifier)
 		return -ENOMEM;
-- 
2.9.5

