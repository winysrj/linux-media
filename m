Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB7DC43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 086B320835
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfCGKKH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:10:07 -0500
Received: from regular1.263xmail.com ([211.150.99.136]:48098 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfCGKKF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 05:10:05 -0500
Received: from randy.li?rock-chips.com (unknown [192.168.167.139])
        by regular1.263xmail.com (Postfix) with ESMTP id 4166C48E;
        Thu,  7 Mar 2019 18:03:27 +0800 (CST)
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
Received: from randy-pc.lan (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P17008T140071111993088S1551952999924990_;
        Thu, 07 Mar 2019 18:03:27 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <f008dc88e6b82d623552a75b76084900>
X-RL-SENDER: randy.li@rock-chips.com
X-SENDER: randy.li@rock-chips.com
X-LOGIN-NAME: randy.li@rock-chips.com
X-FST-TO: linux-media@vger.kernel.org
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From:   Randy Li <randy.li@rock-chips.com>
To:     linux-media@vger.kernel.org
Cc:     Randy Li <randy.li@rock-chips.com>, ayaka@soulik.info,
        hverkuil@xs4all.nl, maxime.ripard@bootlin.com, joro@8bytes.org,
        linux-kernel@vger.kernel.org, jernej.skrabec@gmail.com,
        nicolas@ndufresne.ca, paul.kocialkowski@bootlin.com,
        linux-rockchip@lists.infradead.org, thomas.petazzoni@bootlin.com,
        mchehab@kernel.org, ezequiel@collabora.com,
        linux-arm-kernel@lists.infradead.org, posciak@chromium.org,
        groeck@chromium.org
Subject: [PATCH v2 0/6] [WIP]: rockchip mpp for v4l2 video deocder
Date:   Thu,  7 Mar 2019 18:03:10 +0800
Message-Id: <20190307100316.925-1-randy.li@rock-chips.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Although I really want to push those work after I added more codec
supports, but I found it is more urge to do those in v4l2 core framework and
userspace.

I would use this driver to present the current problems, write down a
summary here and I would reply to those threads later to push forward.

1. Slice construction is a bad idea. I think I have said my reason in
the IRC and mail before, vp9 is always good example.

And it would request the driver to update QP table/CABAC table every
slice.

I would make something to describe a buffer with some addtional meta
data.

But the current request API limit a buffer with associated with
an request buffer, which prevent sharing some sequence data, but it 
still can solve some problems.

2. Advantage DMA memory control.
I think I need to do some work at v4l2 core.

2.1 The DMA address of each planes. I have sent a mail before talked
about why multiple planes is necessary for the rockchip platform. And
it maybe required by the other platforms.

2.2 IOMMU resume
The most effective way to restore the decoder from critical error is
doing a restting  by reset controller.
Which would leading its slave IOMMU reset at the same time. Then none of
those v4l2 buffers are mapping in the IOMMU.

3. H.264 and HEVC header
I still think those structure have some not necessary fileds in dpb or
reference part, which I don't think hardware decoder would care about
that or can be predict from the other information.

I would join to talk later.

4. The work flow of V4L2
I need a method to prepare the register set before the device acutally
begin the transaction. Which is necessary for those high frame rate usecase.

Also it is useful for those device would share some hardware resources
with the other device and it can save more power.

I think I need to do some work at v4l2 core.

Randy Li (6):
  arm64: dts: rockchip: add power domain to iommu
  staging: video: rockchip: add v4l2 decoder
  [TEST]: rockchip: mpp: support qptable
  staging: video: rockchip: add video codec
  arm64: dts: rockchip: boost clocks for rk3328
  arm64: dts: rockchip: add video codec for rk3328

 .../arm64/boot/dts/rockchip/rk3328-rock64.dts |   32 +
 arch/arm64/boot/dts/rockchip/rk3328.dtsi      |  116 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi      |    2 +
 drivers/staging/Kconfig                       |    2 +
 drivers/staging/Makefile                      |    1 +
 drivers/staging/rockchip-mpp/Kconfig          |   34 +
 drivers/staging/rockchip-mpp/Makefile         |   10 +
 drivers/staging/rockchip-mpp/mpp_debug.h      |   87 ++
 drivers/staging/rockchip-mpp/mpp_dev_common.c | 1367 +++++++++++++++++
 drivers/staging/rockchip-mpp/mpp_dev_common.h |  212 +++
 drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c |  997 ++++++++++++
 drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c  |  619 ++++++++
 drivers/staging/rockchip-mpp/mpp_service.c    |  197 +++
 drivers/staging/rockchip-mpp/mpp_service.h    |   38 +
 drivers/staging/rockchip-mpp/rkvdec/hal.h     |   63 +
 drivers/staging/rockchip-mpp/rkvdec/hevc.c    |  166 ++
 drivers/staging/rockchip-mpp/rkvdec/regs.h    |  608 ++++++++
 drivers/staging/rockchip-mpp/vdpu2/hal.h      |   52 +
 drivers/staging/rockchip-mpp/vdpu2/mpeg2.c    |  277 ++++
 drivers/staging/rockchip-mpp/vdpu2/regs.h     |  699 +++++++++
 20 files changed, 5575 insertions(+), 4 deletions(-)
 create mode 100644 drivers/staging/rockchip-mpp/Kconfig
 create mode 100644 drivers/staging/rockchip-mpp/Makefile
 create mode 100644 drivers/staging/rockchip-mpp/mpp_debug.h
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_common.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_common.h
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_rkvdec.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_dev_vdpu2.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_service.c
 create mode 100644 drivers/staging/rockchip-mpp/mpp_service.h
 create mode 100644 drivers/staging/rockchip-mpp/rkvdec/hal.h
 create mode 100644 drivers/staging/rockchip-mpp/rkvdec/hevc.c
 create mode 100644 drivers/staging/rockchip-mpp/rkvdec/regs.h
 create mode 100644 drivers/staging/rockchip-mpp/vdpu2/hal.h
 create mode 100644 drivers/staging/rockchip-mpp/vdpu2/mpeg2.c
 create mode 100644 drivers/staging/rockchip-mpp/vdpu2/regs.h

-- 
2.20.1



