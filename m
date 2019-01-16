Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A894C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 16:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40745205C9
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 16:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404786AbfAPQDh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:03:37 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:44828 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727010AbfAPQDh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 11:03:37 -0500
Received: from [IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f] ([IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id jnfCgVCN7NR5yjnfDgQ9Ut; Wed, 16 Jan 2019 17:03:35 +0100
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v5.1] Various fixes
Message-ID: <def370d1-838c-bcb8-8e92-c4a211b58f1d@xs4all.nl>
Date:   Wed, 16 Jan 2019 17:03:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfN2vbUbKakmzJtTMf0v0fBvaj3vNqdVm7cjfIj9KNQRwXMj0d+bFKfTmt1vA71Jvzgegwk6iYxTJac2Qs9nkoHwEH9HtPCmG686BqWNd3p48akgw/rso
 O21Rcsc6wlzOPAYDylyX0KsTpwndQiEg1pXbdVNRAQ7powXk0gCU1+oFO4u+VWQ8XZP3Zx5gL/28sXQgLBySWoF63YpGloNfFKnXzOMyJC9Se/kmhJs3Xgaw
 uwekHNyJPJIKWNevEHwmPIahtkPSIIJUZCj73XUjjNz7csTKM3nG0HiZqmSdaVPzxM8xe1BaVuiwvkLTeVNjKDKycsFPWMFdq4WSknMKunlklTM67NORuz9L
 XO1R+bqm
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Updates to s5p-jpeg, gspca, imx, coda, rcar-vin.

Regards,

	Hans

The following changes since commit 1e0d0a5fd38192f23304ea2fc2b531fea7c74247:

  media: s5p-mfc: fix incorrect bus assignment in virtual child device (2019-01-07 14:39:36 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v5.1f

for you to fetch changes up to 98ef14f1f1c7048fb21375f8644a9a72a384a75a:

  media: imx.rst: Update doc to reflect fixes to interlaced capture (2019-01-16 16:52:48 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Pawe? Chmiel (1):
      media: s5p-jpeg: Correct step and max values for V4L2_CID_JPEG_RESTART_INTERVAL

Philipp Zabel (12):
      media: gspca: ov534: replace msleep(10) with usleep_range
      media: gspca: support multiple pixel formats in ENUM_FRAMEINTERVALS
      media: gspca: support multiple pixel formats in TRY_FMT
      media: gspca: ov543-ov772x: move video format specific registers into bridge_start
      media: gspca: ov534-ov772x: add SGBRG8 bayer mode support
      media: gspca: ov534-ov722x: remove mode specific video data registers from bridge_init
      media: gspca: ov534-ov722x: remove camera clock setup from bridge_init
      media: gspca: ov534-ov772x: remove unnecessary COM3 initialization
      media: v4l2-ctrl: Add control to enable h.264 constrained intra prediction
      media: v4l2-ctrl: Add control for h.264 chroma qp offset
      media: coda: Add control for h.264 constrained intra prediction
      media: coda: Add control for h.264 chroma qp index offset

Steve Longerbeam (12):
      media: rcar-vin: Allow independent VIN link enablement
      media: videodev2.h: Add more field helper macros
      gpu: ipu-csi: Swap fields according to input/output field types
      gpu: ipu-v3: Add planar support to interlaced scan
      media: imx: Fix field negotiation
      media: imx-csi: Double crop height for alternate fields at sink
      media: imx: interweave and odd-chroma-row skip are incompatible
      media: imx-csi: Allow skipping odd chroma rows for YVU420
      media: imx: vdic: rely on VDIC for correct field order
      media: imx-csi: Move crop/compose reset after filling default mbus fields
      media: imx: Allow interweave with top/bottom lines swapped
      media: imx.rst: Update doc to reflect fixes to interlaced capture

 Documentation/media/uapi/v4l/extended-controls.rst |   9 +++
 Documentation/media/v4l-drivers/imx.rst            | 103 +++++++++++++++++++++-------------
 drivers/gpu/ipu-v3/ipu-cpmem.c                     |  26 ++++++++-
 drivers/gpu/ipu-v3/ipu-csi.c                       | 126 ++++++++++++++++++++++++++++--------------
 drivers/media/platform/coda/coda-bit.c             |   6 +-
 drivers/media/platform/coda/coda-common.c          |  11 ++++
 drivers/media/platform/coda/coda.h                 |   2 +
 drivers/media/platform/rcar-vin/rcar-core.c        |   8 ++-
 drivers/media/platform/s5p-jpeg/jpeg-core.c        |   2 +-
 drivers/media/usb/gspca/gspca.c                    |  18 ++++--
 drivers/media/usb/gspca/ov534.c                    | 153 ++++++++++++++++++++++++++++++++++++---------------
 drivers/media/v4l2-core/v4l2-ctrls.c               |   3 +
 drivers/staging/media/imx/imx-ic-prpencvf.c        |  46 ++++++++++++----
 drivers/staging/media/imx/imx-media-capture.c      |  14 +++++
 drivers/staging/media/imx/imx-media-csi.c          | 156 ++++++++++++++++++++++++++++++++++++++--------------
 drivers/staging/media/imx/imx-media-vdic.c         |  12 +---
 include/uapi/linux/v4l2-controls.h                 |   2 +
 include/uapi/linux/videodev2.h                     |   7 +++
 include/video/imx-ipu-v3.h                         |   8 ++-
 19 files changed, 516 insertions(+), 196 deletions(-)
