Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C09CC282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 11:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4691221905
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 11:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfBALWM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 06:22:12 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:8461 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729077AbfBALWL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 06:22:11 -0500
X-UUID: 6ad149b3ee0842abb63e1e7f346e5445-20190201
X-UUID: 6ad149b3ee0842abb63e1e7f346e5445-20190201
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 348000399; Fri, 01 Feb 2019 19:22:04 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs03n2.mediatek.inc (172.21.101.182) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 1 Feb 2019 19:21:56 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 1 Feb 2019 19:21:56 +0800
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
        <srv_heupstream@mediatek.com>
Subject: [RFC PATCH V0 0/7] media: platform: Add support for Digital Image Processing (DIP) on mt8183 SoC
Date:   Fri, 1 Feb 2019 19:21:24 +0800
Message-ID: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-TM-SNTS-SMTP: CA264A73EA0FD9BE3A8B9ACEDDFE1DC7191A229C5BAC4219CCD3DF43A2E02B602000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,

This is the first version of the RFC patch series adding Digital Image
Processing (DIP) driver on Mediatek mt8183 SoC, which will be used in camera
features on CrOS application. It belongs to the first Mediatek’s ISP driver
series based on V4L2 and media controller framework. I posted the main part of
the DIP driver as RFC to discuss first and would like some review comments on
the overall structure of the driver.

Digital Image Processing (DIP) unit can accept the tuning parameters and adjust
the image content in Mediatek ISP system. Furthermore, it performs demosaicing
and noise reduction on the image to support the advanced camera features of the
application. The DIP driver also support image format conversion, resizing and
rotation with its hardware path.

The driver is implemented with V4L2 and media controller framework. We have the
following entities describing the DIP path.

1. Meta (output video device): connects to DIP sub device. It accepts the input
   tuning buffer from userspace. The metadata interface used currently is only
   a temporary solution to kick off driver development and is not ready for
   reviewed yet.

2. RAW (output video device): connects to DIP sub device. It accepts input image
   buffer from userspace.

3. DIP (sub device): connects to MDP-0 and MDP-1. When processing an image, DIP
   hardware support multiple output image with different size and format so it
   needs two capture video devices to return the streaming data to the user.

4. MDP-0 (capture video device): return the processed image data.

5. MDP-1 (capture video device): return the processed image data, the image
   size and format can be different from the ones of MDP-0.

The overall file structure of the DIP driver is as following:

* mtk_dip-dev-ctx-core.c: Implements common software flow of DIP driver.
  DIP driver supports two or more software contexts. For example, context 0 is
  created for preview path and context 1 is for capture path. Both the two
  contexts share the same DIP hardware to process the images.
* mtk_dip-v4l2.c: Static DIP contexts configuration.
* mtk_dip.c: Controls the hardware flow.
* mtk_dip-dev.c: Implements context-independent flow.
* mtk_dip-ctrl.c: Handles the HW ctrl request from userspace.
* mtk_dip-smem-drv.c: Provides the shared memory management required operation.
  We reserved a memory region for the co-processor and DIP to exchange the
  tuning and hardware configuration data.
* mtk_dip-v4l2-util.c: Implements V4L2 and vb2 ops.

Frederic Chen (7):
  [media] dt-bindings: mt8183: Add binding for DIP shared memory
  dts: arm64: mt8183: Add DIP shared memory node
  [media] dt-bindings: mt8183: Added DIP-SMEM dt-bindings
  [media] dt-bindings: mt8183: Added DIP dt-bindings
  dts: arm64: mt8183: Add DIP nodes
  media: platform: Add Mediatek DIP driver KConfig
  [media] platform: mtk-isp: Add Mediatek DIP driver

 .../bindings/media/mediatek,dip_smem.txt           |   29 +
 .../bindings/media/mediatek,mt8183-dip.txt         |   35 +
 .../mediatek,reserve-memory-dip_smem.txt           |   45 +
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   36 +
 drivers/media/platform/Kconfig                     |    2 +
 drivers/media/platform/mtk-isp/Kconfig             |   21 +
 drivers/media/platform/mtk-isp/Makefile            |   18 +
 drivers/media/platform/mtk-isp/isp_50/Makefile     |   17 +
 drivers/media/platform/mtk-isp/isp_50/dip/Makefile |   35 +
 .../platform/mtk-isp/isp_50/dip/mtk_dip-core.h     |  188 +++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c     |  173 +++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h     |   43 +
 .../platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h      |  319 ++++
 .../mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c      | 1643 ++++++++++++++++++++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-dev.c      |  374 +++++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-dev.h      |  191 +++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c |  452 ++++++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-smem.h     |   25 +
 .../mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c         | 1000 ++++++++++++
 .../mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h         |   38 +
 .../platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c     |  292 ++++
 .../platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h     |   60 +
 .../media/platform/mtk-isp/isp_50/dip/mtk_dip.c    | 1385 +++++++++++++++++
 .../media/platform/mtk-isp/isp_50/dip/mtk_dip.h    |   93 ++
 24 files changed, 6514 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,mt8183-dip.txt
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-dip_smem.txt
 create mode 100644 drivers/media/platform/mtk-isp/Kconfig
 create mode 100644 drivers/media/platform/mtk-isp/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/Makefile
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-core.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctrl.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-ctx.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev-ctx-core.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-dev.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem-drv.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-smem.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2-util.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip-v4l2.h
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.c
 create mode 100644 drivers/media/platform/mtk-isp/isp_50/dip/mtk_dip.h

-- 
1.9.1

