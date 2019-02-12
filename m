Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B060C282CE
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 23:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1171E2084E
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 23:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731607AbfBLXqe (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 18:46:34 -0500
Received: from mxhk.zte.com.cn ([63.217.80.70]:60686 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731439AbfBLXqe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 18:46:34 -0500
Received: from mse01.zte.com.cn (unknown [10.30.3.20])
        by Forcepoint Email with ESMTPS id 8E7E9A730E51313FCED6;
        Wed, 13 Feb 2019 07:46:31 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse01.zte.com.cn with ESMTP id x1CNkRGn001887;
        Wed, 13 Feb 2019 07:46:27 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019021307464640-25782376 ;
          Wed, 13 Feb 2019 07:46:46 +0800 
From:   Wen Yang <wen.yang99@zte.com.cn>
To:     hans.verkuil@cisco.com
Cc:     mchehab@kernel.org, thierry.reding@gmail.com, jonathanh@nvidia.com,
        linux-tegra@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>,
        "Hans Verkuil (hansverk)" <hansverk@cisco.com>,
        Wen Yang <yellowriver2010@hotmail.com>
Subject: [PATCH v2 2/4] media: tegra-cec: fix possible object reference leak
Date:   Wed, 13 Feb 2019 07:45:29 +0800
Message-Id: <1550015129-41867-1-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-02-13 07:46:46,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-02-13 07:46:20,
        Serialize complete at 2019-02-13 07:46:20
X-MAIL: mse01.zte.com.cn x1CNkRGn001887
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
Fixes: 9d2d60687c9a ("media: tegra-cec: add Tegra HDMI CEC driver")
Suggested-by: Hans Verkuil (hansverk) <hansverk@cisco.com>
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Hans Verkuil (hansverk) <hansverk@cisco.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: Wen Yang <yellowriver2010@hotmail.com>
Cc: linux-tegra@vger.kernel.org
Cc: linux-media@vger.kernel.org
---
v2->v1: 
- move of_node_put() to just after the 'hdmi_dev = of_find_device_by_node(np)'.
- put_device() can be done before the cec = devm_kzalloc line.

 drivers/media/platform/tegra-cec/tegra_cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
index aba488c..e99991b 100644
--- a/drivers/media/platform/tegra-cec/tegra_cec.c
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -340,9 +340,11 @@ static int tegra_cec_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 	hdmi_dev = of_find_device_by_node(np);
+	of_node_put(np);
 	if (hdmi_dev == NULL)
 		return -EPROBE_DEFER;
 
+	put_device(&hdmi_dev->dev);
 	cec = devm_kzalloc(&pdev->dev, sizeof(struct tegra_cec), GFP_KERNEL);
 
 	if (!cec)
-- 
2.9.5

