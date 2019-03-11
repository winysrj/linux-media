Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8C8C43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 13:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE479222B5
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 13:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfCKNaT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:30:19 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:47954 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbfCKNaR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 09:30:17 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3L0OhRLUJ4HFn3L0RhERcf; Mon, 11 Mar 2019 14:30:15 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.2] Various fixes/enhancements
Message-ID: <474cb7b0-466e-ec9c-eb49-0de05652aadc@xs4all.nl>
Date:   Mon, 11 Mar 2019 14:30:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfIexUUNnWkMLxg9YLHTxAKaEo5Gt7xAqmXvHLLGiRkzs1V7zqbexYQpaPZ7RvB7KlJo2UrN0h0izyoA46vXdWbWdr2GnZ2LVjrzBXW/F/gDAji7LkBg+
 +zpA0tJwAYu3tfDvOggNTHgcgDMuGXSsKOoAblXjBDMK90W3cdP2jZiBC7WW/KOmi2YOX0I7eaPBRA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The following changes since commit 15d90a6ae98e6d2c68497b44a491cb9efbb98ab1:

  media: dvb/earth-pt1: fix wrong initialization for demod blocks (2019-03-04 06:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.2a

for you to fetch changes up to ae38291f80093727d9398734917067f2d2f8fe74:

  vb2: drop VB2_BUF_STATE_REQUEUEING (2019-03-11 13:44:05 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Alexandre Courbot (1):
      media: mtk-vcodec: fix access to vb2_v4l2_buffer struct

Biju Das (4):
      media: dt-bindings: media: rcar-csi2: Add r8a774a1 support
      media: rcar-csi2: Enable support for r8a774a1
      media: dt-bindings: media: rcar_vin: Add r8a774a1 support
      media: rcar-vin: Enable support for r8a774a1

Dan Carpenter (1):
      media: staging/imx7: Fix an error code in mipi_csis_clk_get()

Geert Uytterhoeven (1):
      media: rcar_drif: Remove devm_ioremap_resource() error printing

Hans Verkuil (12):
      cec: fill in cec chardev kobject to ease debugging
      media-devnode: fill in media chardev kobject to ease debugging
      vivid: use vzalloc for dev->bitmap_out
      vim2m: replace devm_kzalloc by kzalloc
      v4l2-subdev: add release() internal op
      v4l2-subdev: handle module refcounting here
      vimc: zero the media_device on probe
      vimc: free vimc_cap_device when the last user disappears
      vimc: use new release op
      imx7: fix smatch error
      cobalt: replace VB2_BUF_STATE_REQUEUEING by _ERROR
      vb2: drop VB2_BUF_STATE_REQUEUEING

Hugues Fruchet (2):
      media: stm32-dcmi: fix check of pm_runtime_get_sync return value
      media: stm32-dcmi: fix DMA corruption when stopping streaming

Niklas Söderlund (1):
      rcar-vin: Fix lockdep warning at stream on

Rui Miguel Silva (1):
      media: imx7-media-csi: don't store a floating pointer

Shaobo He (1):
      platform/sh_veu.c: remove redundant NULL pointer checks

Steve Longerbeam (5):
      media: imx: vdic: Restore default case to prepare_vdi_in_buffers()
      media: imx: csi: Allow unknown nearest upstream entities
      media: imx: Clear fwnode link struct for each endpoint iteration
      media: imx: Rename functions that add IPU-internal subdevs
      media: imx: Don't register IPU subdevs/links if CSI port missing

YueHaibing (1):
      media: cpia2: Fix use-after-free in cpia2_exit

 Documentation/devicetree/bindings/media/rcar_vin.txt          |  1 +
 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt |  1 +
 drivers/media/cec/cec-core.c                                  |  1 +
 drivers/media/common/videobuf2/videobuf2-core.c               | 15 ++------
 drivers/media/common/videobuf2/videobuf2-v4l2.c               |  1 -
 drivers/media/media-devnode.c                                 |  1 +
 drivers/media/media-entity.c                                  | 28 ---------------
 drivers/media/pci/cobalt/cobalt-irq.c                         |  2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c            |  4 +--
 drivers/media/platform/rcar-vin/rcar-core.c                   | 47 +++++++++++++++++++------
 drivers/media/platform/rcar-vin/rcar-csi2.c                   |  4 +++
 drivers/media/platform/rcar_drif.c                            |  8 ++---
 drivers/media/platform/sh_veu.c                               |  6 ----
 drivers/media/platform/stm32/stm32-dcmi.c                     | 23 ++++++++++--
 drivers/media/platform/vim2m.c                                | 35 ++++++++++++-------
 drivers/media/platform/vimc/vimc-capture.c                    | 13 +++++--
 drivers/media/platform/vimc/vimc-common.c                     |  4 ++-
 drivers/media/platform/vimc/vimc-common.h                     |  2 ++
 drivers/media/platform/vimc/vimc-core.c                       |  2 ++
 drivers/media/platform/vimc/vimc-debayer.c                    | 15 ++++++--
 drivers/media/platform/vimc/vimc-scaler.c                     | 15 ++++++--
 drivers/media/platform/vimc/vimc-sensor.c                     | 19 +++++++---
 drivers/media/platform/vivid/vivid-vid-out.c                  | 14 +++++---
 drivers/media/usb/cpia2/cpia2_v4l.c                           |  3 +-
 drivers/media/v4l2-core/v4l2-device.c                         | 19 +++++++---
 drivers/media/v4l2-core/v4l2-subdev.c                         | 22 +++++-------
 drivers/staging/media/imx/imx-ic-common.c                     |  2 +-
 drivers/staging/media/imx/imx-media-csi.c                     | 18 +++++++---
 drivers/staging/media/imx/imx-media-dev.c                     | 11 ++----
 drivers/staging/media/imx/imx-media-internal-sd.c             | 32 +++++------------
 drivers/staging/media/imx/imx-media-of.c                      | 73 +++++++++++++++++++++++++--------------
 drivers/staging/media/imx/imx-media-vdic.c                    |  8 ++++-
 drivers/staging/media/imx/imx-media.h                         |  7 ++--
 drivers/staging/media/imx/imx7-media-csi.c                    |  6 ++--
 drivers/staging/media/imx/imx7-mipi-csis.c                    |  4 +--
 include/media/media-entity.h                                  | 24 -------------
 include/media/v4l2-subdev.h                                   | 15 +++++++-
 include/media/videobuf2-core.h                                | 21 ++++-------
 38 files changed, 297 insertions(+), 229 deletions(-)
