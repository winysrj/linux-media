Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A965C10F06
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8B2F2085A
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 14:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfCNOSx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:18:53 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:38199 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727547AbfCNOSx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 10:18:53 -0400
X-UUID: 23b0a6fb90f649788d667caef71d6fe1-20190314
X-UUID: 23b0a6fb90f649788d667caef71d6fe1-20190314
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <louis.kuo@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 906859612; Thu, 14 Mar 2019 22:18:48 +0800
Received: from MTKMBS01DR.mediatek.inc (172.21.101.111) by
 mtkmbs03n2.mediatek.inc (172.21.101.182) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 14 Mar 2019 22:18:40 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs01dr.mediatek.inc (172.21.101.111) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 14 Mar 2019 22:18:40 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 14 Mar 2019 22:18:40 +0800
From:   Louis Kuo <louis.kuo@mediatek.com>
To:     <hans.verkuil@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>, <tfiga@chromium.org>,
        <keiichiw@chromium.org>, <matthias.bgg@gmail.com>,
        <mchehab@kernel.org>
CC:     <yuzhao@chromium.org>, <zwisler@chromium.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <Sean.Cheng@mediatek.com>,
        <sj.huang@mediatek.com>, <christie.yu@mediatek.com>,
        <holmes.chiou@mediatek.com>, <frederic.chen@mediatek.com>,
        <Jerry-ch.Chen@mediatek.com>, <jungo.lin@mediatek.com>,
        <Rynn.Wu@mediatek.com>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <devicetree@vger.kernel.org>
Subject: [RFC PATCH V1 0/4] media: support Mediatek sensor interface driver 
Date:   Thu, 14 Mar 2019 22:18:32 +0800
Message-ID: <1552573116-21421-1-git-send-email-louis.kuo@mediatek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-TM-SNTS-SMTP: 7C47F9829ECF2542968A8C1A13AE8142ED2490F1E55F5D5B153698508CB763632000:8
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

This is the RFC patch adding Sensor Inferface(seninf) driver on
Mediatek mt8183 SoC, which will be used in camera features on CrOS application.
It belongs to the first Mediatek's camera driver series based on V4L2 and media controller framework.
I posted the main part of the seninf driver as RFC to discuss first and would like some review comments
on the overall structure of the driver.

The driver is implemented with V4L2 framework.
1. Register as a V4L2 sub-device.
2. Only one entity with sink pads linked to camera sensors for choosing desired camera sensor by setup link
   and with source pads linked to cam-io for routing different types of decoded packet datas to PASS1 driver
   to generate sensor image frame and meta-data.

The overall file structure of the seninf driver is as following:

* mtk_seninf.c: Implement software and HW control flow of seninf driver.
* seninf_drv_def.h: Define data structure and enumeration.
* seninf_reg.h: Define HW register R/W macros and HW register names.

[ v1: use recommended coding style, remove unused function, remove redundant code, do error handling ]

Louis Kuo (4):
  media: platform: mtk-isp: Add Mediatek sensor interface driver
  media: platform: Add Mediatek sensor interface driver KConfig
  dt-bindings: mt8183: Add sensor interface dt-bindings
  dts: arm64: mt8183: Add sensor interface nodes

 .../devicetree/bindings/media/mediatek-seninf.txt  |   52 +
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   34 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/mtk-isp/Kconfig             |   16 +
 drivers/media/platform/mtk-isp/Makefile            |   14 +
 drivers/media/platform/mtk-isp/isp_50/Makefile     |   17 +
 .../media/platform/mtk-isp/isp_50/seninf/Makefile  |    4 +
 .../platform/mtk-isp/isp_50/seninf/mtk_seninf.c    | 1246 ++++++++++++++++++++
 .../mtk-isp/isp_50/seninf/seninf_drv_def.h         |  201 ++++
 .../platform/mtk-isp/isp_50/seninf/seninf_reg.h    |  992 ++++++++++++++++
 10 files changed, 2578 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-seninf.txt
 create mode 100644 drivers/media/platform/mtk-isp/Kconfig
 create mode 100644 drivers/media/platform/mtk-isp/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/seninf/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/seninf/mtk_seninf.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/seninf/seninf_drv_def.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/seninf/seninf_reg.h

-- 
1.9.1

