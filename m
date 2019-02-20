Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68C3C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 07:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB412183F
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 07:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfBTHxR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 02:53:17 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:41007 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726105AbfBTHxQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 02:53:16 -0500
X-UUID: f203075f9e734d4a9485828857fb6d9f-20190220
X-UUID: f203075f9e734d4a9485828857fb6d9f-20190220
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <jerry-ch.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 998428990; Wed, 20 Feb 2019 15:53:10 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 20 Feb 2019 15:53:09 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 20 Feb 2019 15:53:09 +0800
From:   Jerry-ch Chen <Jerry-Ch.chen@mediatek.com>
To:     <hans.verkuil@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>, <tfiga@chromium.org>,
        <matthias.bgg@gmail.com>, <mchehab@kernel.org>
CC:     <yuzhao@chromium.org>, <zwisler@chromium.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <Sean.Cheng@mediatek.com>,
        <sj.huang@mediatek.com>, <christie.yu@mediatek.com>,
        <holmes.chiou@mediatek.com>, <frederic.chen@mediatek.com>,
        <Jerry-ch.Chen@mediatek.com>, <jungo.lin@mediatek.com>,
        <Rynn.Wu@mediatek.com>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <devicetree@vger.kernel.org>,
        Jerry-ch Chen <jerry-ch.chen@mediatek.com>
Subject: [RFC PATCH V0 6/7] media: platform: Add Mediatek FD driver KConfig
Date:   Wed, 20 Feb 2019 15:48:12 +0800
Message-ID: <1550648893-42050-7-git-send-email-Jerry-Ch.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
References: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds KConfig for Mediatek Face Detection driver (FD).
FD is embedded in Mediatek SoCs. It can provide hardware
accelerated face detection function.

Signed-off-by: Jerry-ch Chen <jerry-ch.chen@mediatek.com>
---
 drivers/media/platform/Kconfig         |  2 ++
 drivers/media/platform/mtk-isp/Kconfig | 10 ++++++++++
 2 files changed, 12 insertions(+)
 create mode 100644 drivers/media/platform/mtk-isp/Kconfig

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index a505e9f..ef08d48 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -32,6 +32,8 @@ source "drivers/media/platform/davinci/Kconfig"
 
 source "drivers/media/platform/omap/Kconfig"
 
+source "drivers/media/platform/mtk-isp/Kconfig"
+
 config VIDEO_ASPEED
 	tristate "Aspeed AST2400 and AST2500 Video Engine driver"
 	depends on VIDEO_V4L2
diff --git a/drivers/media/platform/mtk-isp/Kconfig b/drivers/media/platform/mtk-isp/Kconfig
new file mode 100644
index 0000000..096d2cb
--- /dev/null
+++ b/drivers/media/platform/mtk-isp/Kconfig
@@ -0,0 +1,10 @@
+config VIDEO_MEDIATEK_FD_SUPPORT
+	bool "Mediatek face detection processing function"
+
+	default n
+	help
+		Support the basic hardware accelerated face detectioin feature.
+
+		FD driver provide face detection function, it can detect
+		faces of Rotation-in-Plane from -180 degrees to +180 degrees
+		and Rotation-off-Plane from -90 degrees to +90 degrees.
-- 
1.9.1

