Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCB6C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 07:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7889521904
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 07:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbfBTHwl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 02:52:41 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:50329 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725777AbfBTHwl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 02:52:41 -0500
X-UUID: e9716bcf6ad9402688d1fb136d3f1b2f-20190220
X-UUID: e9716bcf6ad9402688d1fb136d3f1b2f-20190220
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <jerry-ch.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1293738806; Wed, 20 Feb 2019 15:52:34 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs03n2.mediatek.inc (172.21.101.182) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 20 Feb 2019 15:52:33 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 20 Feb 2019 15:52:33 +0800
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
        <srv_heupstream@mediatek.com>, <devicetree@vger.kernel.org>
Subject: [RFC PATCH V0 0/7] media: platform: Add support for Face Detection (FD) on mt8183 SoC
Date:   Wed, 20 Feb 2019 15:48:06 +0800
Message-ID: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 430434F4B5B73D6AB60BAACB55FFBAD7B0A93BCBD88D341970DFC58BA2B1D5012000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

This is the first version of the RFC patch series adding Face Detection
(FD) driver on Mediatek mt8183 SoC, which will be used in camera features
on CrOS application. It belongs to the first Mediatek's camera driver
series based on V4L2 and media controller framework. I posted the main part
of the FD driver as RFC to discuss first and would like some review
comments on the overall structure of the driver.

Face Detection (FD) unit provide hardware accelerated face detection
feature. It can detect different sizes of faces in a given image.
Furthermore, it has the capability to detect the faces of Rotation-in-Plane
from -180 to +180 degrees and Rotation-off-Plane from -90 to +90 degrees.

The driver is implemented with V4L2 and media controller framework. We have
the following entities describing the FD path.

1. Meta input (output video device): connects to FD sub device. It accepts
   the input parameter buffer from userspace. The metadata interface used
   currently is only a temporary solution to kick off driver development
   and is not ready for reviewed yet.

2. RAW (output video device): connects to FD sub device. It accepts input
   image buffer from userspace.

3. FD (sub device): connects to Meta output. When processing an image,
   FD hardware only returns the statistics of detected faces so it needs
   only one capture video devices to return the streaming data to the user.

4. Meta output (capture video device): Return the result of detected faces
   as metadata output.

   The overall file structure of the FD driver is as following:

* mtk_fd-dev-ctx-core.c: Implements common software flow of FD driver.
* mtk_fd-v4l2.c: Static FD contexts configuration.
* mtk_fd.c: Controls the hardware flow.
* mtk_fd-dev.c: Implements context-independent flow.
* mtk_fd-ctrl.c: Handles the HW ctrl request from userspace.
* mtk_fd-smem-drv.c: Provides the shared memory management required
operation. We reserved a memory region for the co-processor and FD to
exchange the hardware configuration data.
* mtk_fd-v4l2-util.c: Implements V4L2 and vb2 ops.

Jerry-ch Chen (7):
  dt-bindings: mt8183: Add binding for FD shared memory
  dts: arm64: mt8183: Add FD shared memory node
  dt-bindings: mt8183: Added FD-SMEM dt-bindings
  dt-bindings: mt8183: Added FD dt-bindings
  dts: arm64: mt8183: Add FD nodes
  media: platform: Add Mediatek FD driver KConfig
  platform: mtk-isp: Add Mediatek FD driver

 .../devicetree/bindings/media/mediatek,fd_smem.txt |   28 +
 .../bindings/media/mediatek,mt8183-fd.txt          |   30 +
 .../mediatek,reserve-memory-fd_smem.txt            |   44 +
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   28 +
 drivers/media/platform/Kconfig                     |    2 +
 drivers/media/platform/mtk-isp/Kconfig             |   10 +
 drivers/media/platform/mtk-isp/Makefile            |   16 +
 drivers/media/platform/mtk-isp/fd/Makefile         |   38 +
 drivers/media/platform/mtk-isp/fd/mtk_fd-core.h    |  157 +++
 drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h     |  299 ++++++
 .../platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c      |  917 +++++++++++++++++
 drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c     |  355 +++++++
 drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h     |  198 ++++
 .../media/platform/mtk-isp/fd/mtk_fd-smem-drv.c    |  452 +++++++++
 drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h    |   25 +
 .../media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c   | 1046 ++++++++++++++++++++
 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c    |  115 +++
 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h    |   36 +
 drivers/media/platform/mtk-isp/fd/mtk_fd.c         |  730 ++++++++++++++
 drivers/media/platform/mtk-isp/fd/mtk_fd.h         |  127 +++
 20 files changed, 4653 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,fd_smem.txt
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,mt8183-fd.txt
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-fd_smem.txt
 create mode 100644 drivers/media/platform/mtk-isp/Kconfig
 create mode 100644 drivers/media/platform/mtk-isp/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/fd/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-core.h
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-ctx.h
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev-ctx-core.c
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev.c
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-dev.h
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-smem-drv.c
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-smem.h
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2-util.c
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.c
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd-v4l2.h
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd.c
 create mode 100644 drivers/media/platform/mtk-isp/fd/mtk_fd.h

-- 
1.9.1
