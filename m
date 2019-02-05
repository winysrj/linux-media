Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D323CC282D7
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1A512080D
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727960AbfBEGnV (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 01:43:21 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:2008 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726416AbfBEGnU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 01:43:20 -0500
X-UUID: 30d9d09fc6ed4e47a84ff5eecda5a48f-20190205
X-UUID: 30d9d09fc6ed4e47a84ff5eecda5a48f-20190205
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1751329073; Tue, 05 Feb 2019 14:43:05 +0800
Received: from MTKMBS06N1.mediatek.inc (172.21.101.129) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 5 Feb 2019 14:43:03 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 5 Feb 2019 14:43:03 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 5 Feb 2019 14:43:03 +0800
From:   Frederic Chen <frederic.chen@mediatek.com>
To:     <hans.verkuil@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>, <tfiga@chromium.org>,
        <matthias.bgg@gmail.com>, <mchehab@kernel.org>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <Sean.Cheng@mediatek.com>,
        <sj.huang@mediatek.com>, <christie.yu@mediatek.com>,
        <holmes.chiou@mediatek.com>, <frederic.chen@mediatek.com>,
        <Jerry-ch.Chen@mediatek.com>, <jungo.lin@mediatek.com>,
        <Rynn.Wu@mediatek.com>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <yuzhao@chromium.org>,
        <zwisler@chromium.org>
Subject: [RFC PATCH V0 0/7] media: platform: Add support for ISP Pass 1 on mt8183 SoC 
Date:   Tue, 5 Feb 2019 14:42:39 +0800
Message-ID: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

This is a first version of the RFC patch series adding the driver for
Pass 1 (P1) unit in Mediatek's camera ISP system on mt8183 SoC, which
will be used in camera features of CrOS. It's the first time Mediatek
develops ISP kernel drivers based on V4L2 and media controller
framework. I posted the main part of the ISP Pass 1 driver as RFC to
discuss first and would like some review comments on the overall
architecture of the driver.

Pass 1 unit processes image signal from sensor devices and accepts the
tuning parameters to adjust the image quality. It performs optical
black correction, defect pixel correction, W/IR imbalance correction
and lens shading correction for RAW processing.

The driver is implemented with V4L2 and media controller framework so
we have the following entities to describe the ISP pass 1 path. (The
current metadata interface used in meta input and partial meta nodes
is only a temporary solution to kick off the driver development and is
not ready to be reviewed yet):

1. meta input (output video device): connects to ISP P1 sub device. It
accepts the tuning buffer from user.

2. ISP P1 (sub device): connects to partial meta 0, partial meta 1,
main stream and packed out video devices. When processing an image,
Pass 1 hardware supports multiple output images with different sizes
and formats so it needs two capture video devices ("main stream" and
"packed out") to return the image data to the user.

3. partial meta 0 (capture video device): return the statistics
metadata.

4. partial meta 1 (capture video device): return the statistics
metadata.

5. main stream (capture video device): return the processed image data
which is used in capture scenario.

6. packed out (capture video device): return the processed image data
which is used in preview scenario.

The overall file structure of the ISP Pass 1 driver is as following:

* mtk_cam.c: Controls the hardware dependent flow and configuration.
* mtk_cam-v4l2.c: High-level software context configuration.
* mtk_cam-v4l2-util.c: Implements V4L2 and vb2 ops.
* mtk_cam-dev-ctx-core.c: Common software flow of the driver.
* mtk_cam-dev.c: Implements context independent flow.
* mtk_cam-vpu.c: Communicates with the co-processor on the SoC through
  the VPU driver.
* mtk_cam-smem-drv.c: Provides the shared memory management required
  operations. We reserved a memory region for the co-processor and
  Pass 1 unit to exchange the tuning and configuration data.


Frederic Chen (2):
  [media] dt-bindings: mt8183: Add binding for ISP Pass 1 shared memory
  media: platform: Add Mediatek ISP Pass 1 driver KConfig

Jungo Lin (5):
  dts: arm64: mt8183: Add ISP Pass 1 shared memory node
  [media] dt-bindings: mt8183: Added CAM-SMEM dt-bindings
  [media] dt-bindings: mt8183: Added camera ISP Pass 1 dt-bindings
  dts: arm64: mt8183: Add ISP Pass 1 nodes
  [media] platform: mtk-isp: Add Mediatek ISP Pass 1 driver

 .../bindings/media/mediatek,cam_smem.txt           |   32 +
 .../bindings/media/mediatek,mt8183-camisp.txt      |   59 +
 .../mediatek,reserve-memory-cam_smem.txt           |   44 +
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   54 +
 drivers/media/platform/Kconfig                     |    2 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/mtk-isp/Kconfig             |   21 +
 drivers/media/platform/mtk-isp/Makefile            |   14 +
 drivers/media/platform/mtk-isp/isp_50/Makefile     |   17 +
 drivers/media/platform/mtk-isp/isp_50/cam/Makefile |   35 +
 .../platform/mtk-isp/isp_50/cam/mtk_cam-ctx.h      |  327 ++++
 .../mtk-isp/isp_50/cam/mtk_cam-dev-ctx-core.c      |  986 +++++++++++++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-dev.c      |  381 +++++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-dev.h      |  204 +++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-regs.h     |  146 ++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c |  452 ++++++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-smem.h     |   27 +
 .../mtk-isp/isp_50/cam/mtk_cam-v4l2-util.c         | 1555 ++++++++++++++++++++
 .../mtk-isp/isp_50/cam/mtk_cam-v4l2-util.h         |   49 +
 .../platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.c     |  288 ++++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.h     |   40 +
 .../platform/mtk-isp/isp_50/cam/mtk_cam-vpu.c      |  466 ++++++
 .../platform/mtk-isp/isp_50/cam/mtk_cam-vpu.h      |  158 ++
 .../media/platform/mtk-isp/isp_50/cam/mtk_cam.c    | 1235 ++++++++++++++++
 .../media/platform/mtk-isp/isp_50/cam/mtk_cam.h    |  347 +++++
 25 files changed, 6941 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,cam_smem.txt
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,mt8183-camisp.txt
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-cam_smem.txt
 create mode 100644 drivers/media/platform/mtk-isp/Kconfig
 create mode 100644 drivers/media/platform/mtk-isp/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-ctx.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev-ctx-core.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-dev.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-regs.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem-drv.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-smem.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2-util.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-v4l2.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-vpu.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam-vpu.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/cam/mtk_cam.h

-- 
1.9.1



