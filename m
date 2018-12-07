Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D90C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69B1D208E7
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 12:34:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69B1D208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbeLGMeM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 07:34:12 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:41174 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbeLGMeM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 07:34:12 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id VFKZg6VrGgJOKVFKcgYpix; Fri, 07 Dec 2018 13:34:10 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21] Various fixes/enhancements
Message-ID: <b0a702b7-1a75-7c06-8418-b4b1585822bf@xs4all.nl>
Date:   Fri, 7 Dec 2018 13:34:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPeHeLktl4KBHLahp7WcOKoeBmRSRlFeQTLaITmG8EUK8varqWJEV3Lghccrbk1BfrcCP6VeB4iNssMY2Xhb+pLYk+tXpc3IaB1s8TWQrRyH8WbkRrND
 UyQA34f2rAFJWZoYqCddjlUW5RZtkAbhcIZuhZe9UGXQ1M0clilFGDq5pIlPxCeqGydcjFQ2WEKC5A==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Note: there are a few patches that combine bindings with code changes.
But since these are older patches and the bindings have already been
reviewed I am not going to require the author to split them up. That's a
bit overkill.

If new patches arrive that have this problem, then I will request this
going forward.

Regards,

	Hans

The following changes since commit 3c28b91380dd1183347d32d87d820818031ebecf:

  media: stkwebcam: Bugfix for wrong return values (2018-12-05 14:10:48 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21i

for you to fetch changes up to 54efad597804e6846ab860e7c2af84af529c669c:

  media: cedrus: Add device-tree compatible and variant for A64 support (2018-12-07 13:12:34 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Akinobu Mita (1):
      media: video-i2c: support runtime PM

Colin Ian King (2):
      media: pvrusb2: fix spelling mistake "statuss" -> "status"
      media: sun6i: fix spelling mistake "droped" -> "dropped"

Dmitry Osipenko (1):
      media: staging: tegra-vde: Replace debug messages with trace points

Ezequiel Garcia (1):
      v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields

Gabriel Francisco Mandaji (1):
      media: vivid: Improve timestamping

Kelvin Lawson (1):
      media: venus: Support V4L2 QP parameters in Venus encoder

Lubomir Rintel (1):
      marvell-ccic: trivial fix to the datasheet URL

Luca Ceresoli (1):
      media: v4l2-subdev: document controls need _FL_HAS_DEVNODE

Malathi Gottam (1):
      media: venus: add support for key frame

Matt Ranostay (1):
      media: video-i2c: check if chip struct has set_power function

Paul Kocialkowski (4):
      media: cedrus: Remove global IRQ spin lock from the driver
      dt-bindings: media: cedrus: Add compatibles for the A64 and H5
      media: cedrus: Add device-tree compatible and variant for H5 support
      media: cedrus: Add device-tree compatible and variant for A64 support

Philipp Zabel (2):
      media: v4l2: clarify H.264 loop filter offset controls
      media: coda: fix H.264 deblocking filter controls

Rob Herring (2):
      media: Use of_node_name_eq for node name comparisons
      staging: media: imx: Use of_node_name_eq for node name comparisons

Sergei Shtylyov (2):
      rcar-csi2: add R8A77980 support
      rcar-vin: add R8A77980 support

Todor Tomov (1):
      MAINTAINERS: Change Todor Tomov's email address

Vivek Gautam (1):
      media: venus: core: Set dma maximum segment size

 Documentation/devicetree/bindings/media/cedrus.txt            |   2 +
 Documentation/devicetree/bindings/media/rcar_vin.txt          |   1 +
 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt |   1 +
 Documentation/media/uapi/v4l/extended-controls.rst            |   6 ++
 MAINTAINERS                                                   |   2 +-
 drivers/media/i2c/video-i2c.c                                 | 153 +++++++++++++++++++++++++-
 drivers/media/platform/coda/coda-bit.c                        |  19 ++--
 drivers/media/platform/coda/coda-common.c                     |  15 ++-
 drivers/media/platform/coda/coda.h                            |   6 +-
 drivers/media/platform/coda/coda_regs.h                       |   2 +-
 drivers/media/platform/exynos4-is/media-dev.c                 |  12 +--
 drivers/media/platform/marvell-ccic/cafe-driver.c             |   2 +-
 drivers/media/platform/qcom/venus/core.c                      |   8 ++
 drivers/media/platform/qcom/venus/venc.c                      |  19 ++++
 drivers/media/platform/qcom/venus/venc_ctrls.c                |  19 +++-
 drivers/media/platform/rcar-vin/rcar-core.c                   |  32 ++++++
 drivers/media/platform/rcar-vin/rcar-csi2.c                   |  11 ++
 drivers/media/platform/sunxi/sun6i-csi/sun6i_video.c          |   4 +-
 drivers/media/platform/ti-vpe/cal.c                           |   4 +-
 drivers/media/platform/vivid/vivid-core.h                     |   3 +
 drivers/media/platform/vivid/vivid-kthread-cap.c              |  51 ++++++---
 drivers/media/platform/vivid/vivid-vbi-cap.c                  |   4 -
 drivers/media/platform/xilinx/xilinx-tpg.c                    |   2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                       |   2 +-
 drivers/media/v4l2-core/v4l2-fwnode.c                         |   6 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                          |  10 ++
 drivers/staging/media/imx/imx-media-of.c                      |   2 +-
 drivers/staging/media/sunxi/cedrus/cedrus.c                   |  17 ++-
 drivers/staging/media/sunxi/cedrus/cedrus.h                   |   2 -
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c               |   9 --
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c                |  13 +--
 drivers/staging/media/sunxi/cedrus/cedrus_video.c             |   5 -
 drivers/staging/media/tegra-vde/tegra-vde.c                   | 222 ++++++++++++++++++++++----------------
 drivers/staging/media/tegra-vde/trace.h                       |  93 ++++++++++++++++
 include/media/v4l2-subdev.h                                   |   6 +-
 35 files changed, 578 insertions(+), 187 deletions(-)
 create mode 100644 drivers/staging/media/tegra-vde/trace.h
