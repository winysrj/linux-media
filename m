Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4D6C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 12:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5459A20896
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 12:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfARMw3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 07:52:29 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:55603 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbfARMw3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 07:52:29 -0500
Received: from [IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c] ([IPv6:2001:983:e9a7:1:3849:86c5:b8c2:266c])
        by smtp-cloud8.xs4all.net with ESMTPA
        id kTdKgkzLeNR5ykTdLgWVbl; Fri, 18 Jan 2019 13:52:27 +0100
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes/enhancements
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <72a6f860-c01a-1606-5eb1-10b6e74afac5@xs4all.nl>
Date:   Fri, 18 Jan 2019 13:52:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfEUcmcK05aoTzw/m8Dyt9h8W4/Cp+nqVljFbEKyyCzkFU7BM1VPzh/FUQIycp0hZuJiouIYDI16FBw42F6W9+AYWJOG5BKxPpwo+fUj6BlSgjy5BBMYG
 ygYI9Xhe3geJe6z1xcSENzJt+GbGsFPi9MKG96eD8bOIZ+yb2PWrMgHN416NGAMSDbxAc2kuOSUEuqfLs8JSCfmj89K6WnXYRhi0GFNvmezrQAVbNmza/jw0
 sTe5DhXLcq0Vy6L74i/JnBd/dK1Jjw2ZjqdAAiR1EYA=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit e8f9b16d72631870e30a3d8e4ee9f1c097bc7ba0:

  media: remove soc_camera ov9640 (2019-01-17 09:01:11 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1g

for you to fetch changes up to 3a881781fe1ebd9f924aaabf89b6a39284120245:

  media: imx-csi: Input connections to CSI should be optional (2019-01-18 13:09:22 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
French, Nicholas A (1):
      media: ivtv: add parameter to enable ivtvfb on x86 PAT systems

Hans Verkuil (2):
      vimc: fill in correct driver name in querycap
      vidioc-prepare-buf.rst: drop reference to NO_CACHE flags

Matt Ranostay (2):
      media: dt-bindings: media: video-i2c: add melexis mlx90640 documentation
      media: video-i2c: add Melexis MLX90640 thermal camera

Niklas Söderlund (1):
      rcar-vin: fix wrong return value in rvin_set_channel_routing()

Paul Kocialkowski (2):
      media: cedrus: Cleanup duplicate declarations from cedrus_dec header
      media: cedrus: Allow using the current dst buffer as reference

Pawe? Chmiel (4):
      si470x-i2c: Add device tree support
      si470x-i2c: Use managed resource helpers
      si470x-i2c: Add optional reset-gpio support
      media: dt-bindings: Add binding for si470x radio

Philipp Zabel (5):
      media: coda: use macroblock tiling on CODA960 only
      media: coda: fix decoder capture buffer payload
      media: imx: add capture compose rectangle
      media: imx: set compose rectangle to mbus format
      media: imx: lift CSI and PRP ENC/VF width alignment restriction

Souptick Joarder (1):
      media/v4l2-core/videobuf-vmalloc.c: Remove dead code

Steve Longerbeam (4):
      media: i2c: adv748x: Use devm to allocate the device struct
      media: imx: queue subdev events to reachable video devices
      media: imx: capture: Allow event subscribe/unsubscribe
      media: imx-csi: Input connections to CSI should be optional

Yangtao Li (2):
      media: exynos4-is: convert to DEFINE_SHOW_ATTRIBUTE
      media: platform: sti: remove bdisp_dbg_declare() and hva_dbg_declare()

 Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt |  20 +++++++
 Documentation/devicetree/bindings/media/si470x.txt               |  26 +++++++++
 Documentation/media/uapi/v4l/vidioc-prepare-buf.rst              |   5 +-
 drivers/media/i2c/Kconfig                                        |   1 +
 drivers/media/i2c/adv748x/adv748x-core.c                         |   5 +-
 drivers/media/i2c/video-i2c.c                                    | 110 +++++++++++++++++++++++++++++++++++++-
 drivers/media/pci/ivtv/Kconfig                                   |  23 ++++++--
 drivers/media/pci/ivtv/ivtvfb.c                                  |  16 +++++-
 drivers/media/platform/coda/coda-bit.c                           |  18 +------
 drivers/media/platform/coda/coda-common.c                        |   2 +-
 drivers/media/platform/exynos4-is/fimc-is.c                      |  16 ++----
 drivers/media/platform/rcar-vin/rcar-dma.c                       |   2 +-
 drivers/media/platform/sti/bdisp/bdisp-debug.c                   |  34 ++++--------
 drivers/media/platform/sti/hva/hva-debugfs.c                     |  36 +++++--------
 drivers/media/platform/vimc/vimc-capture.c                       |   2 +-
 drivers/media/platform/vimc/vimc-common.h                        |   2 +
 drivers/media/platform/vimc/vimc-core.c                          |   1 -
 drivers/media/radio/si470x/radio-si470x-i2c.c                    |  52 +++++++++++-------
 drivers/media/radio/si470x/radio-si470x.h                        |   1 +
 drivers/media/v4l2-core/videobuf-vmalloc.c                       |  20 -------
 drivers/staging/media/imx/imx-ic-prpencvf.c                      |   5 +-
 drivers/staging/media/imx/imx-media-capture.c                    | 107 +++++++++++++++++++++++++++++-------
 drivers/staging/media/imx/imx-media-csi.c                        |  16 ++++--
 drivers/staging/media/imx/imx-media-dev.c                        |  24 +++++++++
 drivers/staging/media/imx/imx-media-utils.c                      |  15 ++++--
 drivers/staging/media/imx/imx-media-vdic.c                       |   4 +-
 drivers/staging/media/imx/imx-media.h                            |   2 +
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c                  |  13 +++++
 drivers/staging/media/sunxi/cedrus/cedrus_dec.h                  |   8 +--
 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c                |  10 ++--
 30 files changed, 423 insertions(+), 173 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/melexis,mlx90640.txt
 create mode 100644 Documentation/devicetree/bindings/media/si470x.txt
