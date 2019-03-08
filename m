Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CF2C43381
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 05:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6796F20684
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 05:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfCHFuQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 00:50:16 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:51182 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725308AbfCHFuQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 00:50:16 -0500
X-UUID: 48d76a11833e4eb9b24eeabb01ff5fd0-20190308
X-UUID: 48d76a11833e4eb9b24eeabb01ff5fd0-20190308
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <daoyuan.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 428045824; Fri, 08 Mar 2019 13:49:57 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs03n1.mediatek.inc (172.21.101.181) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 8 Mar 2019 13:49:55 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 8 Mar 2019 13:49:55 +0800
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
Subject: [RFC v1 0/4] media: mediatek: support mdp3 on mt8183 platform
Date:   Fri, 8 Mar 2019 13:49:16 +0800
Message-ID: <1552024160-33055-1-git-send-email-daoyuan.huang@mediatek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: daoyuan huang <daoyuan.huang@mediatek.com>

This is the first version of RFC patch for Media Data Path 3 (MDP3),
MDP3 is used for scaling and color format conversion.
support using GCE to write register in critical time limitation.
support V4L2 m2m device control.

---
Based on v5.0-rc1 and these series:
device tree:
http://lists.infradead.org/pipermail/linux-mediatek/2019-February/017570.html
clock control:
http://lists.infradead.org/pipermail/linux-mediatek/2019-February/017320.html
system control processor (SCP):
http://lists.infradead.org/pipermail/linux-mediatek/2019-February/017774.html
global command engine (GCE):
http://lists.infradead.org/pipermail/linux-mediatek/2019-January/017143.html
---

daoyuan huang (4):
  dt-binding: mt8183: Add Mediatek MDP3 dt-bindings
  dts: arm64: mt8183: Add Mediatek MDP3 nodes
  media: platform: Add Mediatek MDP3 driver KConfig
  media: platform: mtk-mdp3: Add Mediatek MDP3 driver

 .../bindings/media/mediatek,mt8183-mdp3.txt        |  217 ++++
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |  109 ++
 drivers/media/platform/Kconfig                     |   18 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/mtk-mdp3/Makefile           |    9 +
 drivers/media/platform/mtk-mdp3/isp_reg.h          |   38 +
 drivers/media/platform/mtk-mdp3/mdp-platform.h     |   67 ++
 drivers/media/platform/mtk-mdp3/mdp_reg_ccorr.h    |   76 ++
 drivers/media/platform/mtk-mdp3/mdp_reg_rdma.h     |  207 ++++
 drivers/media/platform/mtk-mdp3/mdp_reg_rsz.h      |  110 ++
 drivers/media/platform/mtk-mdp3/mdp_reg_wdma.h     |  126 +++
 drivers/media/platform/mtk-mdp3/mdp_reg_wrot.h     |  116 ++
 drivers/media/platform/mtk-mdp3/mmsys_config.h     |  189 ++++
 drivers/media/platform/mtk-mdp3/mmsys_mutex.h      |   36 +
 drivers/media/platform/mtk-mdp3/mmsys_reg_base.h   |   39 +
 drivers/media/platform/mtk-mdp3/mtk-img-ipi.h      |  272 +++++
 drivers/media/platform/mtk-mdp3/mtk-mdp3-cmdq.c    |  407 +++++++
 drivers/media/platform/mtk-mdp3/mtk-mdp3-cmdq.h    |   52 +
 drivers/media/platform/mtk-mdp3/mtk-mdp3-comp.c    | 1180 ++++++++++++++++++++
 drivers/media/platform/mtk-mdp3/mtk-mdp3-comp.h    |  176 +++
 drivers/media/platform/mtk-mdp3/mtk-mdp3-core.c    |  257 +++++
 drivers/media/platform/mtk-mdp3/mtk-mdp3-core.h    |   89 ++
 drivers/media/platform/mtk-mdp3/mtk-mdp3-m2m.c     |  784 +++++++++++++
 drivers/media/platform/mtk-mdp3/mtk-mdp3-m2m.h     |   52 +
 drivers/media/platform/mtk-mdp3/mtk-mdp3-regs.c    |  778 +++++++++++++
 drivers/media/platform/mtk-mdp3/mtk-mdp3-regs.h    |  382 +++++++
 drivers/media/platform/mtk-mdp3/mtk-mdp3-vpu.c     |  277 +++++
 drivers/media/platform/mtk-mdp3/mtk-mdp3-vpu.h     |   90 ++
 28 files changed, 6155 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,mt8183-mdp3.txt
 create mode 100644 drivers/media/platform/mtk-mdp3/Makefile
 create mode 100644 drivers/media/platform/mtk-mdp3/isp_reg.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mdp-platform.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mdp_reg_ccorr.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mdp_reg_rdma.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mdp_reg_rsz.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mdp_reg_wdma.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mdp_reg_wrot.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mmsys_config.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mmsys_mutex.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mmsys_reg_base.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-img-ipi.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-cmdq.c
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-cmdq.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-comp.c
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-comp.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-core.c
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-core.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-m2m.c
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-m2m.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-regs.c
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-regs.h
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-vpu.c
 create mode 100644 drivers/media/platform/mtk-mdp3/mtk-mdp3-vpu.h

-- 
1.9.1

