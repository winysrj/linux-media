Return-Path: <SRS0=4gUs=QT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B039C282C4
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 23:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 078E12084E
	for <linux-media@archiver.kernel.org>; Tue, 12 Feb 2019 23:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfBLXpo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Feb 2019 18:45:44 -0500
Received: from out1.zte.com.cn ([202.103.147.172]:43784 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfBLXpo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Feb 2019 18:45:44 -0500
Received: from mse01.zte.com.cn (unknown [10.30.3.20])
        by Forcepoint Email with ESMTPS id 8E590E239FC4DE14821F;
        Wed, 13 Feb 2019 07:45:41 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse01.zte.com.cn with ESMTP id x1CNjZ1E001782;
        Wed, 13 Feb 2019 07:45:36 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019021307455443-25782367 ;
          Wed, 13 Feb 2019 07:45:54 +0800 
From:   Wen Yang <wen.yang99@zte.com.cn>
To:     narmstrong@baylibre.com
Cc:     mchehab@kernel.org, khilman@baylibre.com,
        linux-media@lists.freedesktop.org,
        linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        Wen Yang <wen.yang99@zte.com.cn>,
        "Hans Verkuil (hansverk)" <hansverk@cisco.com>,
        Wen Yang <yellowriver2010@hotmail.com>
Subject: [PATCH v2 1/4] media: platform: meson-ao-cec: fix possible object reference leak
Date:   Wed, 13 Feb 2019 07:44:35 +0800
Message-Id: <1550015075-41548-1-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-02-13 07:45:54,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-02-13 07:45:28,
        Serialize complete at 2019-02-13 07:45:28
X-MAIL: mse01.zte.com.cn x1CNjZ1E001782
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

Fixes: 7ec2c0f72cb1 ("media: platform: Add Amlogic Meson AO CEC Controller driver")
Suggested-by: Hans Verkuil (hansverk) <hansverk@cisco.com>
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Hans Verkuil (hansverk) <hansverk@cisco.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Kevin Hilman <khilman@baylibre.com>
Cc: Wen Yang <yellowriver2010@hotmail.com>
Cc: linux-media@lists.freedesktop.org
Cc: linux-amlogic@lists.infradead.org
Cc: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
v2->v1: 
- move of_node_put() to just after the 'hdmi_dev = of_find_device_by_node(np)'.
- put_device() can be done before the cec = devm_kzalloc line.

 drivers/media/platform/meson/ao-cec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/meson/ao-cec.c b/drivers/media/platform/meson/ao-cec.c
index cd4be38..f757ece 100644
--- a/drivers/media/platform/meson/ao-cec.c
+++ b/drivers/media/platform/meson/ao-cec.c
@@ -613,9 +613,11 @@ static int meson_ao_cec_probe(struct platform_device *pdev)
 	}
 
 	hdmi_dev = of_find_device_by_node(np);
+	of_node_put(np);
 	if (hdmi_dev == NULL)
 		return -EPROBE_DEFER;
 
+	put_device(&hdmi_dev->dev);
 	ao_cec = devm_kzalloc(&pdev->dev, sizeof(*ao_cec), GFP_KERNEL);
 	if (!ao_cec)
 		return -ENOMEM;
-- 
2.9.5

