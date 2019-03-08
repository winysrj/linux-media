Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F13C10F09
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 05:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4003821019
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 05:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfCHFuf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 00:50:35 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:28485 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726175AbfCHFue (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 00:50:34 -0500
X-UUID: 81f46b7521194059ac1f7daa395b79af-20190308
X-UUID: 81f46b7521194059ac1f7daa395b79af-20190308
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <daoyuan.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1057481845; Fri, 08 Mar 2019 13:50:09 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 8 Mar 2019 13:50:04 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 8 Mar 2019 13:50:04 +0800
From:   Daoyuan Huang <daoyuan.huang@mediatek.com>
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
        <ping-hsun.wu@mediatek.com>,
        daoyuan huang <daoyuan.huang@mediatek.com>
Subject: [RFC v1 3/4] media: platform: Add Mediatek MDP3 driver KConfig
Date:   Fri, 8 Mar 2019 13:49:19 +0800
Message-ID: <1552024160-33055-4-git-send-email-daoyuan.huang@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1552024160-33055-1-git-send-email-daoyuan.huang@mediatek.com>
References: <1552024160-33055-1-git-send-email-daoyuan.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 9DA6112907AFFB01DA24D7390CEA2CDF568F57DADF019EDBDEEC2786FD2E6AB22000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: daoyuan huang <daoyuan.huang@mediatek.com>

This patch adds Kconfig for Mediatek Media Data Path 3 (MDP3)
driver. MDP3 is used to do scaling and color format conversion.

Signed-off-by: Ping-Hsun Wu <ping-hsun.wu@mediatek.com>
Signed-off-by: daoyuan huang <daoyuan.huang@mediatek.com>
---
 drivers/media/platform/Kconfig  | 18 ++++++++++++++++++
 drivers/media/platform/Makefile |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index a505e9f..6e8b594 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -244,6 +244,24 @@ config VIDEO_MEDIATEK_MDP
 	    To compile this driver as a module, choose M here: the
 	    module will be called mtk-mdp.
 
+config VIDEO_MEDIATEK_MDP3
+	tristate "Mediatek MDP v3 driver"
+	depends on MTK_IOMMU || COMPILE_TEST
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on ARCH_MEDIATEK || COMPILE_TEST
+	depends on HAS_DMA
+	select VIDEOBUF2_DMA_CONTIG
+	select V4L2_MEM2MEM_DEV
+	select VIDEO_MEDIATEK_VPU
+	select MTK_CMDQ
+	default n
+	help
+	    It is a v4l2 driver and present in Mediatek MT8183 SoC.
+	    The driver supports for scaling and color space conversion.
+
+	    To compile this driver as a module, choose M here: the
+	    module will be called mtk-mdp3.
+
 config VIDEO_MEDIATEK_VCODEC
 	tristate "Mediatek Video Codec driver"
 	depends on MTK_IOMMU || COMPILE_TEST
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index e6deb25..1e2cb92b 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -92,6 +92,8 @@ obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
 
 obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
 
+obj-$(CONFIG_VIDEO_MEDIATEK_MDP3)	+= mtk-mdp3/
+
 obj-$(CONFIG_VIDEO_MEDIATEK_JPEG)	+= mtk-jpeg/
 
 obj-$(CONFIG_VIDEO_QCOM_CAMSS)		+= qcom/camss/
-- 
1.9.1

